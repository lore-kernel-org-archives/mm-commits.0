From: akpm@linux-foundation.org
Subject: + cgroup-revert-ss_id_lock-to-spinlock.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:48:55 -0800
Message-ID: <20120120234856.5FA331E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:62915 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab2ATXs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:48:57 -0500
Received: by yhjj52 with SMTP id j52so105067yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:48:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, eric.dumazet@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, tj@kernel.org


The patch titled
     Subject: cgroup: revert ss_id_lock to spinlock
has been added to the -mm tree.  Its filename is
     cgroup-revert-ss_id_lock-to-spinlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -535,7 +535,7 @@ struct cgroup_subsys {
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
@@ -4939,9 +4939,9 @@ void free_css_id(struct cgroup_subsys *s
 
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
@@ -4967,10 +4967,10 @@ static struct css_id *get_new_cssid(stru
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
@@ -4985,9 +4985,9 @@ static struct css_id *get_new_cssid(stru
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
@@ -4999,7 +4999,7 @@ static int __init_or_module cgroup_init_
 {
 	struct css_id *newid;
 
-	rwlock_init(&ss->id_lock);
+	spin_lock_init(&ss->id_lock);
 	idr_init(&ss->idr);
 
 	newid = get_new_cssid(ss, 0);
@@ -5094,9 +5094,9 @@ css_get_next(struct cgroup_subsys *ss, i
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
Subject: Subject: cgroup: revert ss_id_lock to spinlock

Patches currently in -mm which might be from hughd@google.com are

proc-clear_refs-do-not-clear-reserved-pages.patch
mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch
shm_unlock-fix-long-unpreemptible-section.patch
shm_unlock-fix-unevictable-pages-stranded-after-swap.patch
mm-fix-rss-count-leakage-during-migration.patch
mm-add-rss-counters-consistency-check.patch
mm-postpone-migrated-page-mapping-reset.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
prio_tree-debugging-patch.patch

