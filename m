From: akpm@linux-foundation.org
Subject: + idr-make-idr_get_next-good-for-rcu_read_lock.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:48:51 -0800
Message-ID: <20120120234852.8D39820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:55252 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2ATXsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:48:55 -0500
Received: by wibhm11 with SMTP id hm11so51737wib.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:48:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, eric.dumazet@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, tj@kernel.org


The patch titled
     Subject: idr: make idr_get_next() good for rcu_read_lock()
has been added to the -mm tree.  Its filename is
     idr-make-idr_get_next-good-for-rcu_read_lock.patch

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
Subject: idr: make idr_get_next() good for rcu_read_lock()

Make one small adjustment to idr_get_next(): take the height from the top
layer (stable under RCU) instead of from the root (unprotected by RCU), as
idr_find() does: so that it can be used with RCU locking.  Copied comment
on RCU locking from idr_find().

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/idr.c~idr-make-idr_get_next-good-for-rcu_read_lock lib/idr.c
--- a/lib/idr.c~idr-make-idr_get_next-good-for-rcu_read_lock
+++ a/lib/idr.c
@@ -595,8 +595,10 @@ EXPORT_SYMBOL(idr_for_each);
  * Returns pointer to registered object with id, which is next number to
  * given id. After being looked up, *@nextidp will be updated for the next
  * iteration.
+ *
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
  */
-
 void *idr_get_next(struct idr *idp, int *nextidp)
 {
 	struct idr_layer *p, *pa[MAX_LEVEL];
@@ -605,11 +607,11 @@ void *idr_get_next(struct idr *idp, int 
 	int n, max;
 
 	/* find first ent */
-	n = idp->layers * IDR_BITS;
-	max = 1 << n;
 	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
+	n = (p->layer + 1) * IDR_BITS;
+	max = 1 << n;
 
 	while (id < max) {
 		while (n > 0 && p) {
_
Subject: Subject: idr: make idr_get_next() good for rcu_read_lock()

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

