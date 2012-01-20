From: akpm@linux-foundation.org
Subject: + memcg-let-css_get_next-rely-upon-rcu_read_lock.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:48:58 -0800
Message-ID: <20120120234859.8002C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33531 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab2ATXtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:49:02 -0500
Received: by eaaf1 with SMTP id f1so37128eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:49:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, eric.dumazet@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, tj@kernel.org


The patch titled
     Subject: memcg: let css_get_next() rely upon rcu_read_lock()
has been added to the -mm tree.  Its filename is
     memcg-let-css_get_next-rely-upon-rcu_read_lock.patch

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
Subject: memcg: let css_get_next() rely upon rcu_read_lock()

Remove lock and unlock around css_get_next()'s call to idr_get_next(). 
memcg iterators (only users of css_get_next) already did rcu_read_lock(),
and its comment demands that; but add a WARN_ON_ONCE to make sure of it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/cgroup.c~memcg-let-css_get_next-rely-upon-rcu_read_lock kernel/cgroup.c
--- a/kernel/cgroup.c~memcg-let-css_get_next-rely-upon-rcu_read_lock
+++ a/kernel/cgroup.c
@@ -5087,6 +5087,8 @@ css_get_next(struct cgroup_subsys *ss, i
 		return NULL;
 
 	BUG_ON(!ss->use_id);
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
 	/* fill start point for scan */
 	tmpid = id;
 	while (1) {
@@ -5094,10 +5096,7 @@ css_get_next(struct cgroup_subsys *ss, i
 		 * scan next entry from bitmap(tree), tmpid is updated after
 		 * idr_get_next().
 		 */
-		spin_lock(&ss->id_lock);
 		tmp = idr_get_next(&ss->idr, &tmpid);
-		spin_unlock(&ss->id_lock);
-
 		if (!tmp)
 			break;
 		if (tmp->depth >= depth && tmp->stack[depth] == rootid) {
_
Subject: Subject: memcg: let css_get_next() rely upon rcu_read_lock()

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

