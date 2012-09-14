From: akpm@linux-foundation.org
Subject: + coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch added to -mm tree
Date: Fri, 14 Sep 2012 12:31:56 -0700
Message-ID: <20120914193157.1DB9D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:51696 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2INTb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Sep 2012 15:31:59 -0400
Received: by wgbdt11 with SMTP id dt11so277317wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Sep 2012 12:31:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, oleg@redhat.com


The patch titled
     Subject: coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch

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
Subject: coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes

ERROR: space required before the open parenthesis '('
#35: FILE: fs/proc/base.c:1401:
+	if(dumpable == SUID_DUMPABLE_ENABLED)

total: 1 errors, 0 warnings, 16 lines checked

./patches/coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exec.c~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes fs/exec.c
diff -puN fs/proc/base.c~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes fs/proc/base.c
--- a/fs/proc/base.c~coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes
+++ a/fs/proc/base.c
@@ -1398,7 +1398,7 @@ static int task_dumpable(struct task_str
 	if (mm)
 		dumpable = get_dumpable(mm);
 	task_unlock(task);
-	if(dumpable == SUID_DUMPABLE_ENABLED)
+	if (dumpable == SUID_DUMPABLE_ENABLED)
 		return 1;
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
linux-next.patch
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
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

