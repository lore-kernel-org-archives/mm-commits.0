From: akpm@linux-foundation.org
Subject: [merged] cgroup-fix-frequent-ebusy-at-rmdir.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:10 -0700
Message-ID: <200904061934.n36JYAR3011428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394AbZDFTip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:38:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     cgroup: fix frequent -EBUSY at rmdir
has been removed from the -mm tree.  Its filename was
     cgroup-fix-frequent-ebusy-at-rmdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: fix frequent -EBUSY at rmdir
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In following situation, with memory subsystem,

	/groupA use_hierarchy==1
		/01 some tasks
		/02 some tasks
		/03 some tasks
		/04 empty

When tasks under 01/02/03 hit limit on /groupA, hierarchical reclaim
is triggered and the kernel walks tree under groupA. In this case,
rmdir /groupA/04 fails with -EBUSY frequently because of temporal
refcnt from the kernel.

In general. cgroup can be rmdir'd if there are no children groups and
no tasks. Frequent fails of rmdir() is not useful to users.
(And the reason for -EBUSY is unknown to users.....in most cases)

This patch tries to modify above behavior, by
	- retries if css_refcnt is got by someone.
	- add "return value" to pre_destroy() and allows subsystem to
	  say "we're really busy!"

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    6 +-
 include/linux/cgroup.h            |    6 +-
 kernel/cgroup.c                   |   81 +++++++++++++++++++++++-----
 mm/memcontrol.c                   |    5 +
 4 files changed, 79 insertions(+), 19 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroup-fix-frequent-ebusy-at-rmdir Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroup-fix-frequent-ebusy-at-rmdir
+++ a/Documentation/cgroups/cgroups.txt
@@ -476,11 +476,13 @@ cgroup->parent is still valid. (Note - c
 newly-created cgroup if an error occurs after this subsystem's
 create() method has been called for the new cgroup).
 
-void pre_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp);
+int pre_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp);
 
 Called before checking the reference count on each subsystem. This may
 be useful for subsystems which have some extra references even if
-there are not tasks in the cgroup.
+there are not tasks in the cgroup. If pre_destroy() returns error code,
+rmdir() will fail with it. From this behavior, pre_destroy() can be
+called multiple times against a cgroup.
 
 int can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	       struct task_struct *task)
diff -puN include/linux/cgroup.h~cgroup-fix-frequent-ebusy-at-rmdir include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-fix-frequent-ebusy-at-rmdir
+++ a/include/linux/cgroup.h
@@ -135,6 +135,10 @@ enum {
 	CGRP_RELEASABLE,
 	/* Control Group requires release notifications to userspace */
 	CGRP_NOTIFY_ON_RELEASE,
+	/*
+	 * A thread in rmdir() is wating for this cgroup.
+	 */
+	CGRP_WAIT_ON_RMDIR,
 };
 
 struct cgroup {
@@ -360,7 +364,7 @@ int cgroup_is_descendant(const struct cg
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*create)(struct cgroup_subsys *ss,
 						  struct cgroup *cgrp);
-	void (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
+	int (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup_subsys *ss,
 			  struct cgroup *cgrp, struct task_struct *tsk);
diff -puN kernel/cgroup.c~cgroup-fix-frequent-ebusy-at-rmdir kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-frequent-ebusy-at-rmdir
+++ a/kernel/cgroup.c
@@ -622,13 +622,18 @@ static struct inode *cgroup_new_inode(mo
  * Call subsys's pre_destroy handler.
  * This is called before css refcnt check.
  */
-static void cgroup_call_pre_destroy(struct cgroup *cgrp)
+static int cgroup_call_pre_destroy(struct cgroup *cgrp)
 {
 	struct cgroup_subsys *ss;
+	int ret = 0;
+
 	for_each_subsys(cgrp->root, ss)
-		if (ss->pre_destroy)
-			ss->pre_destroy(ss, cgrp);
-	return;
+		if (ss->pre_destroy) {
+			ret = ss->pre_destroy(ss, cgrp);
+			if (ret)
+				break;
+		}
+	return ret;
 }
 
 static void free_cgroup_rcu(struct rcu_head *obj)
@@ -722,6 +727,22 @@ static void cgroup_d_remove_dir(struct d
 	remove_dir(dentry);
 }
 
+/*
+ * A queue for waiters to do rmdir() cgroup. A tasks will sleep when
+ * cgroup->count == 0 && list_empty(&cgroup->children) && subsys has some
+ * reference to css->refcnt. In general, this refcnt is expected to goes down
+ * to zero, soon.
+ *
+ * CGRP_WAIT_ON_RMDIR flag is modified under cgroup's inode->i_mutex;
+ */
+DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
+
+static void cgroup_wakeup_rmdir_waiters(const struct cgroup *cgrp)
+{
+	if (unlikely(test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
+		wake_up_all(&cgroup_rmdir_waitq);
+}
+
 static int rebind_subsystems(struct cgroupfs_root *root,
 			      unsigned long final_bits)
 {
@@ -1317,6 +1338,12 @@ int cgroup_attach_task(struct cgroup *cg
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
 	synchronize_rcu();
 	put_css_set(cg);
+
+	/*
+	 * wake up rmdir() waiter. the rmdir should fail since the cgroup
+	 * is no longer empty.
+	 */
+	cgroup_wakeup_rmdir_waiters(cgrp);
 	return 0;
 }
 
@@ -2608,9 +2635,11 @@ static int cgroup_rmdir(struct inode *un
 	struct cgroup *cgrp = dentry->d_fsdata;
 	struct dentry *d;
 	struct cgroup *parent;
+	DEFINE_WAIT(wait);
+	int ret;
 
 	/* the vfs holds both inode->i_mutex already */
-
+again:
 	mutex_lock(&cgroup_mutex);
 	if (atomic_read(&cgrp->count) != 0) {
 		mutex_unlock(&cgroup_mutex);
@@ -2626,17 +2655,39 @@ static int cgroup_rmdir(struct inode *un
 	 * Call pre_destroy handlers of subsys. Notify subsystems
 	 * that rmdir() request comes.
 	 */
-	cgroup_call_pre_destroy(cgrp);
+	ret = cgroup_call_pre_destroy(cgrp);
+	if (ret)
+		return ret;
 
 	mutex_lock(&cgroup_mutex);
 	parent = cgrp->parent;
-
-	if (atomic_read(&cgrp->count)
-	    || !list_empty(&cgrp->children)
-	    || !cgroup_clear_css_refs(cgrp)) {
+	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
+	/*
+	 * css_put/get is provided for subsys to grab refcnt to css. In typical
+	 * case, subsystem has no reference after pre_destroy(). But, under
+	 * hierarchy management, some *temporal* refcnt can be hold.
+	 * To avoid returning -EBUSY to a user, waitqueue is used. If subsys
+	 * is really busy, it should return -EBUSY at pre_destroy(). wake_up
+	 * is called when css_put() is called and refcnt goes down to 0.
+	 */
+	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
+	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
+
+	if (!cgroup_clear_css_refs(cgrp)) {
+		mutex_unlock(&cgroup_mutex);
+		schedule();
+		finish_wait(&cgroup_rmdir_waitq, &wait);
+		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
+		if (signal_pending(current))
+			return -EINTR;
+		goto again;
+	}
+	/* NO css_tryget() can success after here. */
+	finish_wait(&cgroup_rmdir_waitq, &wait);
+	clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 
 	spin_lock(&release_list_lock);
 	set_bit(CGRP_REMOVED, &cgrp->flags);
@@ -3194,10 +3245,12 @@ void __css_put(struct cgroup_subsys_stat
 {
 	struct cgroup *cgrp = css->cgroup;
 	rcu_read_lock();
-	if ((atomic_dec_return(&css->refcnt) == 1) &&
-	    notify_on_release(cgrp)) {
-		set_bit(CGRP_RELEASABLE, &cgrp->flags);
-		check_for_release(cgrp);
+	if (atomic_dec_return(&css->refcnt) == 1) {
+		if (notify_on_release(cgrp)) {
+			set_bit(CGRP_RELEASABLE, &cgrp->flags);
+			check_for_release(cgrp);
+		}
+		cgroup_wakeup_rmdir_waiters(cgrp);
 	}
 	rcu_read_unlock();
 }
diff -puN mm/memcontrol.c~cgroup-fix-frequent-ebusy-at-rmdir mm/memcontrol.c
--- a/mm/memcontrol.c~cgroup-fix-frequent-ebusy-at-rmdir
+++ a/mm/memcontrol.c
@@ -2272,11 +2272,12 @@ free_out:
 	return ERR_PTR(-ENOMEM);
 }
 
-static void mem_cgroup_pre_destroy(struct cgroup_subsys *ss,
+static int mem_cgroup_pre_destroy(struct cgroup_subsys *ss,
 					struct cgroup *cont)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	mem_cgroup_force_empty(mem, false);
+
+	return mem_cgroup_force_empty(mem, false);
 }
 
 static void mem_cgroup_destroy(struct cgroup_subsys *ss,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup.patch

