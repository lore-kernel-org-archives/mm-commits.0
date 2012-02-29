From: akpm@linux-foundation.org
Subject: + memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch added to -mm tree
Date: Wed, 29 Feb 2012 14:09:15 -0800
Message-ID: <20120229220915.D3104A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38610 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2B2WJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 17:09:18 -0500
Received: by eekc41 with SMTP id c41so157522eek.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 14:09:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: memcg: remove PCG_FILE_MAPPED fix cosmetic fix
has been added to the -mm tree.  Its filename is
     memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch

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
Subject: memcg: remove PCG_FILE_MAPPED fix cosmetic fix

mem_cgroup_move_account() begins with "anon = PageAnon(page)", and
then anon is used thereafter: testing PageAnon(page) in the middle
makes the reader wonder if there's some race to guard against - no.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-pcg_file_mapped-fix-cosmetic-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcg_file_mapped-fix-cosmetic-fix
+++ a/mm/memcontrol.c
@@ -2586,7 +2586,7 @@ static int mem_cgroup_move_account(struc
 
 	move_lock_mem_cgroup(from, &flags);
 
-	if (!PageAnon(page) && page_mapped(page)) {
+	if (!anon && page_mapped(page)) {
 		/* Update mapped_file data for mem_cgroup */
 		preempt_disable();
 		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
_
Subject: Subject: memcg: remove PCG_FILE_MAPPED fix cosmetic fix

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
memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch
prio_tree-debugging-patch.patch

