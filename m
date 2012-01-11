From: akpm@linux-foundation.org
Subject: + mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch added to -mm tree
Date: Wed, 11 Jan 2012 14:34:50 -0800
Message-ID: <20120111223451.4347810004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:62849 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2AKWew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 17:34:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: mm: fix NULL ptr dereference in __count_immobile_pages
has been added to the -mm tree.  Its filename is
     mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mel Gorman <mgorman@suse.de>
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
@@ -5387,6 +5387,17 @@ __count_immobile_pages(struct zone *zone
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
Subject: Subject: mm: fix NULL ptr dereference in __count_immobile_pages

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
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
mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-3.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-page-migration-to-reset_owner.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix-null-mem_cgroup_try_charge.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch

