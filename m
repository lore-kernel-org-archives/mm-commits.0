From: akpm@linux-foundation.org
Subject: +
 not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch added to -mm tree
Date: Wed, 27 Aug 2014 13:29:37 -0700
Message-ID: <53fe3fb1.gxp+lHwZQIwijTrE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:54045 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964975AbaH0U3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 16:29:38 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so280789pab.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 13:29:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, paul.gortmaker@windriver.com, qiuxishi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch

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
Subject: not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes

ERROR: space prohibited after that open parenthesis '('
#34: FILE: fs/proc/kcore.c:613:
+	if ( (MODULES_VADDR != VMALLOC_START) &&

ERROR: space prohibited before that close parenthesis ')'
#35: FILE: fs/proc/kcore.c:614:
+		(MODULES_END != VMALLOC_END) ) {

total: 2 errors, 0 warnings, 12 lines checked

./patches/not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Baoquan He <bhe@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/kcore.c~not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes fs/proc/kcore.c
--- a/fs/proc/kcore.c~not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes
+++ a/fs/proc/kcore.c
@@ -610,8 +610,7 @@ static void __init proc_kcore_text_init(
 struct kcore_list kcore_modules;
 static void __init add_modules_range(void)
 {
-	if ( (MODULES_VADDR != VMALLOC_START) &&
-		(MODULES_END != VMALLOC_END) ) {
+	if (MODULES_VADDR != VMALLOC_START && MODULES_END != VMALLOC_END) {
 		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
 			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range-fix.patch
mm-slab_commonc-suppress-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
watchdog-control-hard-lockup-detection-default-fix.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

