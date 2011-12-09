From: akpm@linux-foundation.org
Subject: [merged] mm-ensure-that-pfn_valid-is-called-once-per-pageblock-when-reserving-pageblocks.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:32 -0800
Message-ID: <201112092008.pB9K8Xxg014765@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:64268 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1LIUIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, aarcange@redhat.com, arve@android.com, bdang@vmware.com, dave@linux.vnet.ibm.com, john.stultz@linaro.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Ensure that pfn_valid() is called once per pageblock when reserving pageblocks
has been removed from the -mm tree.  Its filename was
     mm-ensure-that-pfn_valid-is-called-once-per-pageblock-when-reserving-pageblocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: Ensure that pfn_valid() is called once per pageblock when reserving pageblocks

setup_zone_migrate_reserve expects that zone->start_pfn starts
at pageblock_nr_pages aligned pfn otherwise we could access
beyond an existing memblock resulting in the following panic if
CONFIG_HOLES_IN_ZONE is not configured and we do not check pfn_valid:

IP: [<c02d331d>] setup_zone_migrate_reserve+0xcd/0x180
*pdpt = 0000000000000000 *pde = f000ff53f000ff53
Oops: 0000 [#1] SMP
Modules linked in:
Supported: Yes

Pid: 1, comm: swapper Not tainted 3.0.7-0.7-pae #1 VMware, Inc.
VMware Virtual Platform/440BX Desktop Reference Platform
EIP: 0060:[<c02d331d>] EFLAGS: 00010006 CPU: 0
EIP is at setup_zone_migrate_reserve+0xcd/0x180
EAX: 000c0000 EBX: f5801fc0 ECX: 000c0000 EDX: 00000000
ESI: 000c01fe EDI: 000c01fe EBP: 00140000 ESP: f2475f58
DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f2474000 task=f2472cd0 task.ti=f2474000)
Stack:
f4000800 00000000 f4000800 000006b8 00000000 000c6cd5 c02d389c 000003b2
00036aa9 00000292 f4000830 c08cfe78 00000000 00000000 c08a76f5 c02d3a1f
c08a771c c08cfe78 c020111b 35310001 00000000 00000000 00000100 f24730c4
Call Trace:
[<c02d389c>] __setup_per_zone_wmarks+0xec/0x160
[<c02d3a1f>] setup_per_zone_wmarks+0xf/0x20
[<c08a771c>] init_per_zone_wmark_min+0x27/0x86
[<c020111b>] do_one_initcall+0x2b/0x160
[<c086639d>] kernel_init+0xbe/0x157
[<c05cae26>] kernel_thread_helper+0x6/0xd
Code: a5 39 f5 89 f7 0f 46 fd 39 cf 76 40 8b 03 f6 c4 08 74 32 eb 91 90 89 c8 c1 e8 0e 0f be 80 80 2f 86 c0 8b 14 85 60 2f 86 c0 89 c8 <2b> 82 b4 12 00 00 c1 e0 05 03 82 ac 12 00 00 8b 00 f6 c4 08 0f
EIP: [<c02d331d>] setup_zone_migrate_reserve+0xcd/0x180 SS:ESP 0068:f2475f58
CR2: 00000000000012b4
---[ end trace 93d72a36b9146f22 ]---

We crashed in pageblock_is_reserved() when accessing pfn 0xc0000 because
highstart_pfn = 0x36ffe.

The issue was introduced in 3.0-rc1 by 6d3163ce ("mm: check if any page in
a pageblock is reserved before marking it MIGRATE_RESERVE").

Make sure that start_pfn is always aligned to pageblock_nr_pages to ensure
that pfn_valid s always called at the start of each pageblock. 
Architectures with holes in pageblocks will be correctly handled by
pfn_valid_within in pageblock_is_reserved.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Dang Bo <bdang@vmware.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Arve Hjnnevg <arve@android.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>	[3.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-ensure-that-pfn_valid-is-called-once-per-pageblock-when-reserving-pageblocks mm/page_alloc.c
--- a/mm/page_alloc.c~mm-ensure-that-pfn_valid-is-called-once-per-pageblock-when-reserving-pageblocks
+++ a/mm/page_alloc.c
@@ -3377,9 +3377,15 @@ static void setup_zone_migrate_reserve(s
 	unsigned long block_migratetype;
 	int reserve;
 
-	/* Get the start pfn, end pfn and the number of blocks to reserve */
+	/*
+	 * Get the start pfn, end pfn and the number of blocks to reserve
+	 * We have to be careful to be aligned to pageblock_nr_pages to
+	 * make sure that we always check pfn_valid for the first page in
+	 * the block.
+	 */
 	start_pfn = zone->zone_start_pfn;
 	end_pfn = start_pfn + zone->spanned_pages;
+	start_pfn = roundup(start_pfn, pageblock_nr_pages);
 	reserve = roundup(min_wmark_pages(zone), pageblock_nr_pages) >>
 							pageblock_order;
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-fix-off-by-two-in-__zone_watermark_ok.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch

