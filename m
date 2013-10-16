From: akpm@linux-foundation.org
Subject: + mm-do-not-walk-all-of-system-memory-during-show_mem.patch added to -mm tree
Date: Wed, 16 Oct 2013 13:36:27 -0700
Message-ID: <525ef8cb.DHN3x7OnQm4SAcsU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761934Ab3JPUg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Oct 2013 16:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de

Subject: + mm-do-not-walk-all-of-system-memory-during-show_mem.patch added to -mm tree
To: mgorman@suse.de
From: akpm@linux-foundation.org
Date: Wed, 16 Oct 2013 13:36:27 -0700


The patch titled
     Subject: mm: do not walk all of system memory during show_mem
has been added to the -mm tree.  Its filename is
     mm-do-not-walk-all-of-system-memory-during-show_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-walk-all-of-system-memory-during-show_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-walk-all-of-system-memory-during-show_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: do not walk all of system memory during show_mem

It has been reported on very large machines that show_mem is taking almost
5 minutes to display information.  This is a serious problem if there is
an OOM storm.  The bulk of the cost is in show_mem doing a very expensive
PFN walk to give us the following information

Total RAM:	Also available as totalram_pages
Highmem pages:	Also available as totalhigh_pages
Reserved pages:	Can be inferred from the zone structure
Shared pages:	PFN walk required
Unshared pages:	PFN walk required
Quick pages:	Per-cpu walk required

Only the shared/unshared pages requires a full PFN walk but that
information is useless.  It is also inaccurate as page pins of unshared
pages would be accounted for as shared.  Even if the information was
accurate, I'm struggling to think how the shared/unshared information
could be useful for debugging OOM conditions.  Maybe it was useful before
rmap existed when reclaiming shared pages was costly but it is less
relevant today.

The PFN walk could be optimised a bit but why bother as the information is
useless.  This patch deletes the PFN walker and infers the total RAM,
highmem and reserved pages count from struct zone.  It omits the
shared/unshared page usage on the grounds that it is useless.  It also
corrects the reporting of HighMem as HighMem/MovableOnly as ZONE_MOVABLE
has similar problems to HighMem with respect to lowmem/highmem exhaustion.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |   39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff -puN lib/show_mem.c~mm-do-not-walk-all-of-system-memory-during-show_mem lib/show_mem.c
--- a/lib/show_mem.c~mm-do-not-walk-all-of-system-memory-during-show_mem
+++ a/lib/show_mem.c
@@ -12,8 +12,7 @@
 void show_mem(unsigned int filter)
 {
 	pg_data_t *pgdat;
-	unsigned long total = 0, reserved = 0, shared = 0,
-		nonshared = 0, highmem = 0;
+	unsigned long total = 0, reserved = 0, highmem = 0;
 
 	printk("Mem-Info:\n");
 	show_free_areas(filter);
@@ -22,43 +21,27 @@ void show_mem(unsigned int filter)
 		return;
 
 	for_each_online_pgdat(pgdat) {
-		unsigned long i, flags;
+		unsigned long flags;
+		int zoneid;
 
 		pgdat_resize_lock(pgdat, &flags);
-		for (i = 0; i < pgdat->node_spanned_pages; i++) {
-			struct page *page;
-			unsigned long pfn = pgdat->node_start_pfn + i;
-
-			if (unlikely(!(i % MAX_ORDER_NR_PAGES)))
-				touch_nmi_watchdog();
-
-			if (!pfn_valid(pfn))
+		for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
+			struct zone *zone = &pgdat->node_zones[zoneid];
+			if (!populated_zone(zone))
 				continue;
 
-			page = pfn_to_page(pfn);
-
-			if (PageHighMem(page))
-				highmem++;
-
-			if (PageReserved(page))
-				reserved++;
-			else if (page_count(page) == 1)
-				nonshared++;
-			else if (page_count(page) > 1)
-				shared += page_count(page) - 1;
+			total += zone->present_pages;
+			reserved = zone->present_pages - zone->managed_pages;
 
-			total++;
+			if (is_highmem_idx(zoneid))
+				highmem += zone->present_pages;
 		}
 		pgdat_resize_unlock(pgdat, &flags);
 	}
 
 	printk("%lu pages RAM\n", total);
-#ifdef CONFIG_HIGHMEM
-	printk("%lu pages HighMem\n", highmem);
-#endif
+	printk("%lu pages HighMem/MovableOnly\n", highmem);
 	printk("%lu pages reserved\n", reserved);
-	printk("%lu pages shared\n", shared);
-	printk("%lu pages non-shared\n", nonshared);
 #ifdef CONFIG_QUICKLIST
 	printk("%lu pages in pagetable cache\n",
 		quicklist_total_size());
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch
mm-hugetlb-correct-missing-private-flag-clearing.patch
mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages.patch
mm-nobootmemc-have-__free_pages_memory-free-in-larger-chunks.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
mm-rearrange-madvise-code-to-allow-for-reuse.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory.patch
mm-do-not-walk-all-of-system-memory-during-show_mem.patch
linux-next.patch

