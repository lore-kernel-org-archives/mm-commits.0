From: akpm@linux-foundation.org
Subject: + memcg-remove-pcg_cache-page_cgroup-flag-fix.patch added to -mm tree
Date: Wed, 29 Feb 2012 14:10:49 -0800
Message-ID: <20120229221049.7ED0CA023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48456 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2B2WKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 17:10:52 -0500
Received: by faaa19 with SMTP id a19so2364faa.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 14:10:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org


The patch titled
     Subject: memcg: remove PCG_CACHE page_cgroup flag fix
has been added to the -mm tree.  Its filename is
     memcg-remove-pcg_cache-page_cgroup-flag-fix.patch

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
Subject: memcg: remove PCG_CACHE page_cgroup flag fix

Swapping tmpfs loads show absurd wrapped rss and wrong cache in memcg's
memory.stat statistics: __mem_cgroup_uncharge_common() is failing to
distinguish the anon and tmpfs cases.

Mostly we can decide between them by PageAnon, which is reliable once it
has been set; but there are several callers who need to uncharge a
MEM_CGROUP_CHARGE_TYPE_MAPPED page before it was fully initialized, so
allow that case to override the PageAnon decision.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-pcg_cache-page_cgroup-flag-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcg_cache-page_cgroup-flag-fix
+++ a/mm/memcontrol.c
@@ -2919,13 +2919,16 @@ __mem_cgroup_uncharge_common(struct page
 	if (!PageCgroupUsed(pc))
 		goto unlock_out;
 
+	anon = PageAnon(page);
+
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+		anon = true;
+		/* fallthrough */
 	case MEM_CGROUP_CHARGE_TYPE_DROP:
 		/* See mem_cgroup_prepare_migration() */
 		if (page_mapped(page) || PageCgroupMigration(pc))
 			goto unlock_out;
-		anon = true;
 		break;
 	case MEM_CGROUP_CHARGE_TYPE_SWAPOUT:
 		if (!PageAnon(page)) {	/* Shared memory */
@@ -2933,10 +2936,8 @@ __mem_cgroup_uncharge_common(struct page
 				goto unlock_out;
 		} else if (page_mapped(page)) /* Anon */
 				goto unlock_out;
-		anon = true;
 		break;
 	default:
-		anon = false;
 		break;
 	}
 
_
Subject: Subject: memcg: remove PCG_CACHE page_cgroup flag fix

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
memcg-fix-deadlock-by-inverting-lrucare-nesting.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
make-swapin-readahead-skip-over-holes-fix.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
tmpfs-security-xattr-setting-on-inode-creation.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-fix.patch
memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch
prio_tree-debugging-patch.patch

