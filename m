From: akpm@linux-foundation.org
Subject: - bootmem-free-reserve-helpers-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:09:42 -0700
Message-ID: <200807232322.m6NNMK9P017396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363AbYGWXWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, hannes@saeurebad.de, mingo@elte.hu, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     bootmem-free-reserve-helpers-fix
has been removed from the -mm tree.  Its filename was
     bootmem-free-reserve-helpers-fix.patch

This patch was dropped because it was folded into bootmem-free-reserve-helpers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem-free-reserve-helpers-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/bootmem.c: In function '__free':
mm/bootmem.c:233: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mm/bootmem.c: In function '__reserve':
mm/bootmem.c:248: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mm/bootmem.c: In function 'free_bootmem_core':
mm/bootmem.c:270: warning: unused variable 'i'
mm/bootmem.c: In function 'reserve_bootmem_core':
mm/bootmem.c:401: warning: 'return' with a value, in function returning void
mm/bootmem.c:380: warning: unused variable 'i'

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/bootmem.c~bootmem-free-reserve-helpers-fix mm/bootmem.c
--- a/mm/bootmem.c~bootmem-free-reserve-helpers-fix
+++ a/mm/bootmem.c
@@ -230,7 +230,7 @@ static void __init __free(bootmem_data_t
 {
 	unsigned long idx;
 
-	bdebug("nid=%d start=%lx end=%lx\n", bdata - bootmem_node_data,
+	bdebug("nid=%td start=%lx end=%lx\n", bdata - bootmem_node_data,
 		sidx + PFN_DOWN(bdata->node_boot_start),
 		eidx + PFN_DOWN(bdata->node_boot_start));
 
@@ -245,7 +245,7 @@ static int __init __reserve(bootmem_data
 	unsigned long idx;
 	int exclusive = flags & BOOTMEM_EXCLUSIVE;
 
-	bdebug("nid=%d start=%lx end=%lx flags=%x\n",
+	bdebug("nid=%td start=%lx end=%lx flags=%x\n",
 		bdata - bootmem_node_data,
 		sidx + PFN_DOWN(bdata->node_boot_start),
 		eidx + PFN_DOWN(bdata->node_boot_start),
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
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-arm-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mips-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-dvb.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mtd-fix.patch
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

