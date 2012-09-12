From: akpm@linux-foundation.org
Subject: + mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch added to -mm tree
Date: Wed, 12 Sep 2012 14:34:13 -0700
Message-ID: <20120912213414.0E5195C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52591 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2ILVeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 17:34:16 -0400
Received: by fass10 with SMTP id s10so146404fas.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 14:34:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, minchan@kernel.org


The patch titled
     Subject: mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch

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
Subject: mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes

ERROR: code indent should use tabs where possible
#73: FILE: mm/page_isolation.c:253:
+                             int **resultp)$

WARNING: please, no spaces at the start of a line
#73: FILE: mm/page_isolation.c:253:
+                             int **resultp)$

ERROR: code indent should use tabs where possible
#75: FILE: mm/page_isolation.c:255:
+        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;$

WARNING: please, no spaces at the start of a line
#75: FILE: mm/page_isolation.c:255:
+        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;$

ERROR: code indent should use tabs where possible
#77: FILE: mm/page_isolation.c:257:
+        if (PageHighMem(page))$

WARNING: please, no spaces at the start of a line
#77: FILE: mm/page_isolation.c:257:
+        if (PageHighMem(page))$

ERROR: code indent should use tabs where possible
#78: FILE: mm/page_isolation.c:258:
+                gfp_mask |= __GFP_HIGHMEM;$

WARNING: please, no spaces at the start of a line
#78: FILE: mm/page_isolation.c:258:
+                gfp_mask |= __GFP_HIGHMEM;$

ERROR: code indent should use tabs where possible
#80: FILE: mm/page_isolation.c:260:
+        return alloc_page(gfp_mask);$

WARNING: please, no spaces at the start of a line
#80: FILE: mm/page_isolation.c:260:
+        return alloc_page(gfp_mask);$

total: 5 errors, 5 warnings, 48 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_isolation.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes
+++ a/mm/page_isolation.c
@@ -250,12 +250,12 @@ int test_pages_isolated(unsigned long st
 }
 
 struct page *alloc_migrate_target(struct page *page, unsigned long private,
-                             int **resultp)
+				  int **resultp)
 {
-        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
+	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
 
-        if (PageHighMem(page))
-                gfp_mask |= __GFP_HIGHMEM;
+	if (PageHighMem(page))
+		gfp_mask |= __GFP_HIGHMEM;
 
-        return alloc_page(gfp_mask);
+	return alloc_page(gfp_mask);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
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
coredump-make-core-dump-functionality-optional-fix-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

