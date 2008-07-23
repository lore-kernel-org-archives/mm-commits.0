From: akpm@linux-foundation.org
Subject: - page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:13:09 -0700
Message-ID: <200807232325.m6NNPkqI017626__7834.94009306214$1216855621$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754990AbYGWXZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:25:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-arch@vger.kernel.org, righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes
has been removed from the -mm tree.  Its filename was
     page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch

This patch was dropped because it was folded into page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <linux-arch@vger.kernel.org>
Cc: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/suspend.c    |    1 +
 arch/powerpc/lib/code-patching.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/powerpc/kernel/suspend.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes arch/powerpc/kernel/suspend.c
--- a/arch/powerpc/kernel/suspend.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes
+++ a/arch/powerpc/kernel/suspend.c
@@ -7,6 +7,7 @@
  * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
  */
 
+#include <linux/mm.h>
 #include <asm/page.h>
 
 /* References to section boundaries */
diff -puN arch/powerpc/lib/code-patching.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes arch/powerpc/lib/code-patching.c
--- a/arch/powerpc/lib/code-patching.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes
+++ a/arch/powerpc/lib/code-patching.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
+#include <linux/mm.h>
 #include <asm/page.h>
 #include <asm/code-patching.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
kill-generic_file_direct_io.patch
use-generic_access_phys-for-dev-mem-mappings.patch
spufs-use-the-new-vm_ops-access.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
page-flags-record-page-flag-overlays-explicitly.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that.patch
vmallocinfo-add-numa-information.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
bootmem-add-debugging-framework.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core-checkpatch-fixes.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts-fix.patch
rtc-cmos-improve-hpet-irq-glue-build-fix.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch

