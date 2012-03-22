From: akpm@linux-foundation.org
Subject: [merged] cgroup-revert-ss_id_lock-to-spinlock.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:42 -0700
Message-ID: <20120322201942.837FAA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:41753 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab2CVUTu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:50 -0400
Received: by ghbz15 with SMTP id z15so402488ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, eric.dumazet@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: revert ss_id_lock to spinlock
has been removed from the -mm tree.  Its filename was
     cgroup-revert-ss_id_lock-to-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: cgroup: revert ss_id_lock to spinlock

Commit c1e2ee2dc436 "memcg: replace ss->id_lock with a rwlock" has now
been seen to cause the unfair behavior we should have expected from
converting a spinlock to an rwlock: softlockup in cgroup_mkdir(), whose
get_new_cssid() is waiting for the wlock, while there are 19 tasks using
the rlock in css_get_next() to get on with their memcg workload (in an
artificial test, admittedly).  Yet lib/idr.c was made suitable for RCU way
back: revert that commit, restoring ss->id_lock to a spinlock.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    2 +-
 kernel/cgroup.c        |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-revert-ss_id_lock-to-spinlock include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-revert-ss_id_lock-to-spinlock
+++ a/include/linux/cgroup.h
@@ -498,7 +498,7 @@ struct cgroup_subsys {
 	struct list_head sibling;
 	/* used when use_id == true */
 	struct idr idr;
-	rwlock_t id_lock;
+	spinlock_t id_lock;
 
 	/* should be defined only by modular subsystems */
 	struct module *module;
diff -puN kernel/cgroup.c~cgroup-revert-ss_id_lock-to-spinlock kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-revert-ss_id_lock-to-spinlock
+++ a/kernel/cgroup.c
@@ -4885,9 +4885,9 @@ void free_css_id(struct cgroup_subsys *s
 
 	rcu_assign_pointer(id->css, NULL);
 	rcu_assign_pointer(css->id, NULL);
-	write_lock(&ss->id_lock);
+	spin_lock(&ss->id_lock);
 	idr_remove(&ss->idr, id->id);
-	write_unlock(&ss->id_lock);
+	spin_unlock(&ss->id_lock);
 	kfree_rcu(id, rcu_head);
 }
 EXPORT_SYMBOL_GPL(free_css_id);
@@ -4913,10 +4913,10 @@ static struct css_id *get_new_cssid(stru
 		error = -ENOMEM;
 		goto err_out;
 	}
-	write_lock(&ss->id_lock);
+	spin_lock(&ss->id_lock);
 	/* Don't use 0. allocates an ID of 1-65535 */
 	error = idr_get_new_above(&ss->idr, newid, 1, &myid);
-	write_unlock(&ss->id_lock);
+	spin_unlock(&ss->id_lock);
 
 	/* Returns error when there are no free spaces for new ID.*/
 	if (error) {
@@ -4931,9 +4931,9 @@ static struct css_id *get_new_cssid(stru
 	return newid;
 remove_idr:
 	error = -ENOSPC;
-	write_lock(&ss->id_lock);
+	spin_lock(&ss->id_lock);
 	idr_remove(&ss->idr, myid);
-	write_unlock(&ss->id_lock);
+	spin_unlock(&ss->id_lock);
 err_out:
 	kfree(newid);
 	return ERR_PTR(error);
@@ -4945,7 +4945,7 @@ static int __init_or_module cgroup_init_
 {
 	struct css_id *newid;
 
-	rwlock_init(&ss->id_lock);
+	spin_lock_init(&ss->id_lock);
 	idr_init(&ss->idr);
 
 	newid = get_new_cssid(ss, 0);
@@ -5040,9 +5040,9 @@ css_get_next(struct cgroup_subsys *ss, i
 		 * scan next entry from bitmap(tree), tmpid is updated after
 		 * idr_get_next().
 		 */
-		read_lock(&ss->id_lock);
+		spin_lock(&ss->id_lock);
 		tmp = idr_get_next(&ss->idr, &tmpid);
-		read_unlock(&ss->id_lock);
+		spin_unlock(&ss->id_lock);
 
 		if (!tmp)
 			break;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch

