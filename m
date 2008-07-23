From: akpm@linux-foundation.org
Subject: - bootmem-add-debugging-framework-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:08:14 -0700
Message-ID: <200807232320.m6NNKpKK017349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756502AbYGWXU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@saeurebad.de, mm-commits@vger.kernel.org


The patch titled
     bootmem-add-debugging-framework-fix
has been removed from the -mm tree.  Its filename was
     bootmem-add-debugging-framework-fix.patch

This patch was dropped because it was folded into bootmem-add-debugging-framework.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem-add-debugging-framework-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/bootmem.c: In function 'init_bootmem_core':
mm/bootmem.c:123: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mm/bootmem.c: In function 'free_all_bootmem_core':
mm/bootmem.c:220: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mm/bootmem.c: In function 'free_bootmem_core':
mm/bootmem.c:279: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mm/bootmem.c: In function 'reserve_bootmem_core':
mm/bootmem.c:388: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mm/bootmem.c: In function 'alloc_bootmem_core':
mm/bootmem.c:485: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mm/bootmem.c:596: warning: format '%d' expects type 'int', but argument 3 has type 'long int'

Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/bootmem.c~bootmem-add-debugging-framework-fix mm/bootmem.c
--- a/mm/bootmem.c~bootmem-add-debugging-framework-fix
+++ a/mm/bootmem.c
@@ -120,7 +120,7 @@ static unsigned long __init init_bootmem
 	mapsize = get_mapsize(bdata);
 	memset(bdata->node_bootmem_map, 0xff, mapsize);
 
-	bdebug("nid=%d start=%lx map=%lx end=%lx mapsize=%lx\n",
+	bdebug("nid=%td start=%lx map=%lx end=%lx mapsize=%lx\n",
 		bdata - bootmem_node_data, start, mapstart, end, mapsize);
 
 	return mapsize;
@@ -217,7 +217,7 @@ static unsigned long __init free_all_boo
 	count += i;
 	bdata->node_bootmem_map = NULL;
 
-	bdebug("nid=%d released=%lx\n", bdata - bootmem_node_data, count);
+	bdebug("nid=%td released=%lx\n", bdata - bootmem_node_data, count);
 
 	return count;
 }
@@ -276,7 +276,7 @@ static void __init free_bootmem_core(boo
 	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
 		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
-	bdebug("nid=%d start=%lx end=%lx\n", bdata - bootmem_node_data,
+	bdebug("nid=%td start=%lx end=%lx\n", bdata - bootmem_node_data,
 		sidx + PFN_DOWN(bdata->node_boot_start),
 		eidx + PFN_DOWN(bdata->node_boot_start));
 
@@ -385,7 +385,7 @@ static void __init reserve_bootmem_core(
 	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
 		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
-	bdebug("nid=%d start=%lx end=%lx flags=%x\n",
+	bdebug("nid=%td start=%lx end=%lx flags=%x\n",
 		bdata - bootmem_node_data,
 		sidx + PFN_DOWN(bdata->node_boot_start),
 		eidx + PFN_DOWN(bdata->node_boot_start),
@@ -483,7 +483,7 @@ alloc_bootmem_core(struct bootmem_data *
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
-	bdebug("nid=%d size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
+	bdebug("nid=%td size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
 		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
 		align, goal, limit);
 
@@ -594,7 +594,7 @@ found:
 		ret = phys_to_virt(start * PAGE_SIZE + node_boot_start);
 	}
 
-	bdebug("nid=%d start=%lx end=%lx\n",
+	bdebug("nid=%td start=%lx end=%lx\n",
 		bdata - bootmem_node_data,
 		start + PFN_DOWN(bdata->node_boot_start),
 		start + areasize + PFN_DOWN(bdata->node_boot_start));
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
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
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

