From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch added to -mm tree
Date: Fri, 07 Sep 2012 12:56:29 -0700
Message-ID: <20120907195630.328E11E00E8@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46159 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2IGT4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 15:56:32 -0400
Received: by ghbz15 with SMTP id z15so372890ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 12:56:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, minchan@kernel.org


The patch titled
     Subject: memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch

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
Subject: memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix

small cleanup

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_isolation.c~memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix
+++ a/mm/page_isolation.c
@@ -202,8 +202,9 @@ __test_page_isolated_in_pageblock(unsign
 			 * MIGRATE_ISOLATE list.
 			 */
 			if (get_freepage_migratetype(page) != MIGRATE_ISOLATE) {
-				struct page *end_page = page +
-						(1 << page_order(page)) - 1;
+				struct page *end_page;
+
+				end_page = page + (1 << page_order(page)) - 1;
 				move_freepages(page_zone(page), page, end_page,
 						MIGRATE_ISOLATE);
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
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
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
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

