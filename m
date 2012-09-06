From: akpm@linux-foundation.org
Subject: + mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch added to -mm tree
Date: Thu, 06 Sep 2012 14:46:45 -0700
Message-ID: <20120906223444.8EA2A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:64837 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2IFWeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 18:34:46 -0400
Received: by ggnu1 with SMTP id u1so252469ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 15:34:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mgorman@suse.de, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix

fix build

Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix
+++ a/mm/vmscan.c
@@ -1729,6 +1729,28 @@ static bool in_reclaim_compaction(struct
 	return false;
 }
 
+#ifdef CONFIG_COMPACTION
+/*
+ * If compaction is deferred for sc->order then scale the number of pages
+ * reclaimed based on the number of consecutive allocation failures
+ */
+static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
+			struct lruvec *lruvec, struct scan_control *sc)
+{
+	struct zone *zone = lruvec_zone(lruvec);
+
+	if (zone->compact_order_failed <= sc->order)
+		pages_for_compaction <<= zone->compact_defer_shift;
+	return pages_for_compaction;
+}
+#else
+static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
+			struct lruvec *lruvec, struct scan_control *sc)
+{
+	return pages_for_compaction;
+}
+#endif
+
 /*
  * Reclaim/compaction is used for high-order allocation requests. It reclaims
  * order-0 pages before compacting the zone. should_continue_reclaim() returns
@@ -1743,7 +1765,6 @@ static inline bool should_continue_recla
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
-	struct zone *zone;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -1778,14 +1799,8 @@ static inline bool should_continue_recla
 	 */
 	pages_for_compaction = (2UL << sc->order);
 
-	/*
-	 * If compaction is deferred for sc->order then scale the number of
-	 * pages reclaimed based on the number of consecutive allocation
-	 * failures
-	 */
-	zone = lruvec_zone(lruvec);
-	if (zone->compact_order_failed <= sc->order)
-		pages_for_compaction <<= zone->compact_defer_shift;
+	pages_for_compaction = scale_for_compaction(pages_for_compaction,
+						    lruvec, sc);
 	inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
 		inactive_lru_pages += get_lru_size(lruvec, LRU_INACTIVE_ANON);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-support-migrate_discard-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

