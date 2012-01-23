From: akpm@linux-foundation.org
Subject: [merged] mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:12 -0800
Message-ID: <20120123202113.92636200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pz0-f74.google.com ([209.85.210.74]:60724 "EHLO
	mail-pz0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab2AWUVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix NULL ptr dereference in __count_immobile_pages
has been removed from the -mm tree.  Its filename was
     mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: fix NULL ptr dereference in __count_immobile_pages

Fix the following NULL ptr dereference caused by cat
/sys/devices/system/memory/memory0/removable:

Pid: 13979, comm: sed Not tainted 3.0.13-0.5-default #1 IBM BladeCenter LS21 -[7971PAM]-/Server Blade
RIP: 0010:[<ffffffff810f41f4>]  [<ffffffff810f41f4>] __count_immobile_pages+0x4/0x100
RSP: 0018:ffff880221c37e48  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffea0000000000 RCX: ffffea0000000000
RDX: 0000000000000000 RSI: ffffea0000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000001 R09: 00000000000146b0
R10: 0000000000000000 R11: ffffffff81328980 R12: 0000160000000000
R13: 6db6db6db6db6db7 R14: 0000000000000001 R15: ffffffff81658af0
FS:  00007fc4e8091700(0000) GS:ffff88023fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000698 CR3: 000000023027a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sed (pid: 13979, threadinfo ffff880221c36000, task ffff88022e788480)
Stack:
 ffffea0000000000 ffffea00001c0000 ffffffff810f4324 ffffffff8113e104
 0000000000000001 0000000000000001 ffff880232a33ac0 ffff880230c25000
 ffff880232a33b28 ffffffff813289c1 ffff88022e7d7d40 ffffffffffffffed
Call Trace:
 [<ffffffff810f4324>] is_pageblock_removable_nolock+0x34/0x40
 [<ffffffff8113e104>] is_mem_section_removable+0x74/0xf0
 [<ffffffff813289c1>] show_mem_removable+0x41/0x70
 [<ffffffff811c053e>] sysfs_read_file+0xfe/0x1c0
 [<ffffffff81150be7>] vfs_read+0xc7/0x130
 [<ffffffff81150d53>] sys_read+0x53/0xa0
 [<ffffffff81448392>] system_call_fastpath+0x16/0x1b
 [<00007fc4e7bdbea0>] 0x7fc4e7bdbe9f
Code: 34 00 0f 1f 44 00 00 48 89 ef be 02 00 00 00 e8 f3 f3 ff ff ba 02 00 00 00 48 89 ee 48 89 df e8 53 f0 ff ff eb b9 90 55 89 d5 53
 2b bf 98 06 00 00 48 89 f3 48 81 ef 00 15 00 00 48 81 ff ff

We are crashing because we are trying to dereference NULL zone which
came from pfn=0 (struct page ffffea0000000000). According to the boot
log this page is marked reserved:
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)

and early_node_map confirms that:
early_node_map[3] active PFN ranges
    1: 0x00000010 -> 0x0000009c
    1: 0x00000100 -> 0x000bffa3
    1: 0x00100000 -> 0x00240000

The problem is that memory_present works in PAGE_SECTION_MASK aligned
blocks so the reserved range sneaks into the the section as well.  This
also means that free_area_init_node will not take care of those reserved
pages and they stay uninitialized.

When we try to read the removable status we walk through all available
sections and hope that the zone is valid for all pages in the section. 
But this is not true in this case as the zone and nid are not initialized.

We have only one node in this particular case and it is marked as node=1
(rather than 0) and that made the problem visible because page_to_nid will
return 0 and there are no zones on the node.

Let's check that the zone is valid and that the given pfn falls into its
boundaries and mark the section not removable.  This might cause some
false positives, probably, but we do not have any sane way to find out
whether the page is reserved by the platform or it is just not used for
whatever other reasons.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/page_alloc.c~mm-fix-null-ptr-dereference-in-__count_immobile_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-null-ptr-dereference-in-__count_immobile_pages
+++ a/mm/page_alloc.c
@@ -5414,6 +5414,17 @@ __count_immobile_pages(struct zone *zone
 bool is_pageblock_removable_nolock(struct page *page)
 {
 	struct zone *zone = page_zone(page);
+	unsigned long pfn = page_to_pfn(page);
+
+	/*
+	 * We have to be careful here because we are iterating over memory
+	 * sections which are not zone aware so we might end up outside of
+	 * the zone but still within the section.
+	 */
+	if (!zone || zone->zone_start_pfn > pfn ||
+			zone->zone_start_pfn + zone->spanned_pages <= pfn)
+		return false;
+
 	return __count_immobile_pages(zone, page, 0);
 }
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch

