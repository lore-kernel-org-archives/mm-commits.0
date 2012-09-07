From: akpm@linux-foundation.org
Subject: + swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch added to -mm tree
Date: Fri, 07 Sep 2012 16:17:44 -0700
Message-ID: <20120907231745.4ECE61001AC@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42690 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2IGXRq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 19:17:46 -0400
Received: by qafl39 with SMTP id l39so7647qaf.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 16:17:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, hughd@google.com, khlebnikov@openvz.org, minchan@kernel.org, riel@redhat.com, shli@fusionio.com, shli@kernel.org


The patch titled
     Subject: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
has been added to the -mm tree.  Its filename is
     swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

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
Subject: swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix

tweak code comment

Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/internal.h~swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix mm/internal.h
--- a/mm/internal.h~swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix
+++ a/mm/internal.h
@@ -359,15 +359,12 @@ extern unsigned long vm_mmap_pgoff(struc
 extern void set_pageblock_order(void);
 
 /*
- * Unnecessary readahead harms performance. 1. for SSD, big size read is more
- * expensive than small size read, so extra unnecessary read only has overhead.
- * For harddisk, this overhead doesn't exist. 2. unnecessary readahead will
- * allocate extra memroy, which further tights memory pressure, so more
- * swapout/swapin.
- * These adds a simple swap random access detection. In swap page fault, if
- * page is found in swap cache, decrease an account of vma, otherwise we need
- * do sync swapin and the account is increased. Optionally swapin will do
- * readahead if the counter is below a threshold.
+ * Unnecessary readahead harms performance, especially for SSD devices, where
+ * large reads are significantly more expensive than small ones.
+ * These implements simple swap random access detection. In swap page fault: if
+ * the page is found in swapcache, decrease a counter in the vma, otherwise we
+ * need to perform sync swapin and the counter is increased.  Optionally swapin
+ * will perform readahead if the counter is below a threshold.
  */
 #ifdef CONFIG_SWAP
 #define SWAPRA_MISS_THRESHOLD  (100)
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
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
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

