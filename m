From: akpm@linux-foundation.org
Subject: + sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:43:17 -0700
Message-ID: <20120913234318.0141D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64892 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2IMXnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:43:19 -0400
Received: by vbis24 with SMTP id s24so389350vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:43:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com, jmario@redhat.com


The patch titled
     Subject: sectons-fix-const-sections-for-crc32-table-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch

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
Subject: sectons-fix-const-sections-for-crc32-table-checkpatch-fixes

ERROR: code indent should use tabs where possible
#54: FILE: lib/gen_crc32table.c:112:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no space before tabs
#54: FILE: lib/gen_crc32table.c:112:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no spaces at the start of a line
#54: FILE: lib/gen_crc32table.c:112:
+        ^Iprintf("static u32 __cacheline_aligned "$

ERROR: code indent should use tabs where possible
#63: FILE: lib/gen_crc32table.c:122:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no space before tabs
#63: FILE: lib/gen_crc32table.c:122:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no spaces at the start of a line
#63: FILE: lib/gen_crc32table.c:122:
+        ^Iprintf("static u32 __cacheline_aligned "$

ERROR: code indent should use tabs where possible
#72: FILE: lib/gen_crc32table.c:131:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no space before tabs
#72: FILE: lib/gen_crc32table.c:131:
+        ^Iprintf("static u32 __cacheline_aligned "$

WARNING: please, no spaces at the start of a line
#72: FILE: lib/gen_crc32table.c:131:
+        ^Iprintf("static u32 __cacheline_aligned "$

total: 3 errors, 6 warnings, 48 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/sectons-fix-const-sections-for-crc32-table.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Joe Mario <jmario@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/gen_crc32table.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/gen_crc32table.c~sectons-fix-const-sections-for-crc32-table-checkpatch-fixes lib/gen_crc32table.c
--- a/lib/gen_crc32table.c~sectons-fix-const-sections-for-crc32-table-checkpatch-fixes
+++ a/lib/gen_crc32table.c
@@ -109,7 +109,7 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-        	printf("static u32 __cacheline_aligned "
+		printf("static u32 __cacheline_aligned "
 		       "crc32table_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32table_le, LE_TABLE_ROWS,
@@ -119,7 +119,7 @@ int main(int argc, char** argv)
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-        	printf("static u32 __cacheline_aligned "
+		printf("static u32 __cacheline_aligned "
 		       "crc32table_be[%d][%d] = {",
 		       BE_TABLE_ROWS, BE_TABLE_SIZE);
 		output_table(crc32table_be, LE_TABLE_ROWS,
@@ -128,7 +128,7 @@ int main(int argc, char** argv)
 	}
 	if (CRC_LE_BITS > 1) {
 		crc32cinit_le();
-        	printf("static u32 __cacheline_aligned "
+		printf("static u32 __cacheline_aligned "
 		       "crc32ctable_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32ctable_le, LE_TABLE_ROWS,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
slab-fix-debug==0-warning.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
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

