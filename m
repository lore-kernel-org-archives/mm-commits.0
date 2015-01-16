From: akpm@linux-foundation.org
Subject: +
 daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch added to -mm tree
Date: Fri, 16 Jan 2015 12:49:04 -0800
Message-ID: <54b97940.Ec8BDTvhXPJKzUD5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbbAPUtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jan 2015 15:49:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew.r.wilcox@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3
has been added to the -mm tree.  Its filename is
     daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch

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
Subject: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3

remap_file_pages went away

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/file.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ext2/file.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3 fs/ext2/file.c
--- a/fs/ext2/file.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3
+++ a/fs/ext2/file.c
@@ -39,7 +39,6 @@ static int ext2_dax_mkwrite(struct vm_ar
 static const struct vm_operations_struct ext2_dax_vm_ops = {
 	.fault		= ext2_dax_fault,
 	.page_mkwrite	= ext2_dax_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch

