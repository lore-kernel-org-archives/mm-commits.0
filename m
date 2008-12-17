From: akpm@linux-foundation.org
Subject: + cgroups-add-css_tryget.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:03:35 -0800
Message-ID: <200812172203.mBHM3Zb3025388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbYLQWEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:04:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     cgroups: add css_tryget()
has been added to the -mm tree.  Its filename is
     cgroups-add-css_tryget.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add css_tryget()
From: Paul Menage <menage@google.com>

Add css_tryget(), that obtains a counted reference on a CSS.  It is used
in situations where the caller has a "weak" reference to the CSS, i.e. 
one that does not protect the cgroup from removal via a reference count,
but would instead be cleaned up by a destroy() callback.

css_tryget() will return true on success, or false if the cgroup is being
removed.

This is similar to Kamezawa Hiroyuki's patch from a week or two ago, but
with the difference that in the event of css_tryget() racing with a
cgroup_rmdir(), css_tryget() will only return false if the cgroup really
does get removed.

This implementation is done by biasing css->refcnt, so that a refcnt of 1
means "releasable" and 0 means "released or releasing".  In the event of a
race, css_tryget() distinguishes between "released" and "releasing" by
checking for the CSS_REMOVED flag in css->flags.

Signed-off-by: Paul Menage <menage@google.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   38 ++++++++++++++++++++----
 kernel/cgroup.c        |   61 +++++++++++++++++++++++++++++++++++----
 2 files changed, 88 insertions(+), 11 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-add-css_tryget include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-css_tryget
+++ a/include/linux/cgroup.h
@@ -52,9 +52,9 @@ struct cgroup_subsys_state {
 	 * hierarchy structure */
 	struct cgroup *cgroup;
 
-	/* State maintained by the cgroup system to allow
-	 * subsystems to be "busy". Should be accessed via css_get()
-	 * and css_put() */
+	/* State maintained by the cgroup system to allow subsystems
+	 * to be "busy". Should be accessed via css_get(),
+	 * css_tryget() and and css_put(). */
 
 	atomic_t refcnt;
 
@@ -64,11 +64,14 @@ struct cgroup_subsys_state {
 /* bits in struct cgroup_subsys_state flags field */
 enum {
 	CSS_ROOT, /* This CSS is the root of the subsystem */
+	CSS_REMOVED, /* This CSS is dead */
 };
 
 /*
- * Call css_get() to hold a reference on the cgroup;
- *
+ * Call css_get() to hold a reference on the css; it can be used
+ * for a reference obtained via:
+ * - an existing ref-counted reference to the css
+ * - task->cgroups for a locked task
  */
 
 static inline void css_get(struct cgroup_subsys_state *css)
@@ -77,9 +80,32 @@ static inline void css_get(struct cgroup
 	if (!test_bit(CSS_ROOT, &css->flags))
 		atomic_inc(&css->refcnt);
 }
+
+static inline bool css_is_removed(struct cgroup_subsys_state *css)
+{
+	return test_bit(CSS_REMOVED, &css->flags);
+}
+
+/*
+ * Call css_tryget() to take a reference on a css if your existing
+ * (known-valid) reference isn't already ref-counted. Returns false if
+ * the css has been destroyed.
+ */
+
+static inline bool css_tryget(struct cgroup_subsys_state *css)
+{
+	if (test_bit(CSS_ROOT, &css->flags))
+		return true;
+	while (!atomic_inc_not_zero(&css->refcnt)) {
+		if (test_bit(CSS_REMOVED, &css->flags))
+			return false;
+	}
+	return true;
+}
+
 /*
  * css_put() should be called to release a reference taken by
- * css_get()
+ * css_get() or css_tryget()
  */
 
 extern void __css_put(struct cgroup_subsys_state *css);
diff -puN kernel/cgroup.c~cgroups-add-css_tryget kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-css_tryget
+++ a/kernel/cgroup.c
@@ -2321,7 +2321,7 @@ static void init_cgroup_css(struct cgrou
 			       struct cgroup *cgrp)
 {
 	css->cgroup = cgrp;
-	atomic_set(&css->refcnt, 0);
+	atomic_set(&css->refcnt, 1);
 	css->flags = 0;
 	if (cgrp == dummytop)
 		set_bit(CSS_ROOT, &css->flags);
@@ -2453,7 +2453,7 @@ static int cgroup_has_css_refs(struct cg
 {
 	/* Check the reference count on each subsystem. Since we
 	 * already established that there are no tasks in the
-	 * cgroup, if the css refcount is also 0, then there should
+	 * cgroup, if the css refcount is also 1, then there should
 	 * be no outstanding references, so the subsystem is safe to
 	 * destroy. We scan across all subsystems rather than using
 	 * the per-hierarchy linked list of mounted subsystems since
@@ -2474,12 +2474,62 @@ static int cgroup_has_css_refs(struct cg
 		 * matter, since it can only happen if the cgroup
 		 * has been deleted and hence no longer needs the
 		 * release agent to be called anyway. */
-		if (css && atomic_read(&css->refcnt))
+		if (css && (atomic_read(&css->refcnt) > 1))
 			return 1;
 	}
 	return 0;
 }
 
+/*
+ * Atomically mark all (or else none) of the cgroup's CSS objects as
+ * CSS_REMOVED. Return true on success, or false if the cgroup has
+ * busy subsystems. Call with cgroup_mutex held
+ */
+
+static int cgroup_clear_css_refs(struct cgroup *cgrp)
+{
+	struct cgroup_subsys *ss;
+	unsigned long flags;
+	bool failed = false;
+	local_irq_save(flags);
+	for_each_subsys(cgrp->root, ss) {
+		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
+		int refcnt;
+		do {
+			/* We can only remove a CSS with a refcnt==1 */
+			refcnt = atomic_read(&css->refcnt);
+			if (refcnt > 1) {
+				failed = true;
+				goto done;
+			}
+			BUG_ON(!refcnt);
+			/*
+			 * Drop the refcnt to 0 while we check other
+			 * subsystems. This will cause any racing
+			 * css_tryget() to spin until we set the
+			 * CSS_REMOVED bits or abort
+			 */
+		} while (atomic_cmpxchg(&css->refcnt, refcnt, 0) != refcnt);
+	}
+ done:
+	for_each_subsys(cgrp->root, ss) {
+		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
+		if (failed) {
+			/*
+			 * Restore old refcnt if we previously managed
+			 * to clear it from 1 to 0
+			 */
+			if (!atomic_read(&css->refcnt))
+				atomic_set(&css->refcnt, 1);
+		} else {
+			/* Commit the fact that the CSS is removed */
+			set_bit(CSS_REMOVED, &css->flags);
+		}
+	}
+	local_irq_restore(flags);
+	return !failed;
+}
+
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 {
 	struct cgroup *cgrp = dentry->d_fsdata;
@@ -2510,7 +2560,7 @@ static int cgroup_rmdir(struct inode *un
 
 	if (atomic_read(&cgrp->count)
 	    || !list_empty(&cgrp->children)
-	    || cgroup_has_css_refs(cgrp)) {
+	    || !cgroup_clear_css_refs(cgrp)) {
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
@@ -3065,7 +3115,8 @@ void __css_put(struct cgroup_subsys_stat
 {
 	struct cgroup *cgrp = css->cgroup;
 	rcu_read_lock();
-	if (atomic_dec_and_test(&css->refcnt) && notify_on_release(cgrp)) {
+	if ((atomic_dec_return(&css->refcnt) == 1) &&
+	    notify_on_release(cgrp)) {
 		set_bit(CGRP_RELEASABLE, &cgrp->flags);
 		check_for_release(cgrp);
 	}
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
linux-next.patch
cpuacct-refactoring-cpuusage_read-cpuusage_write.patch
cpuacct-export-percpu-cpuacct-cgroup-stats.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
devcgroup-use-list_for_each_entry_rcu.patch
devices-cgroup-allow-mkfifo.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch
add-a-refcount-check-in-dput.patch

