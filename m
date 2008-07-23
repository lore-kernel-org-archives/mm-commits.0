From: akpm@linux-foundation.org
Subject: - page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 15:52:50 -0700
Message-ID: <200807232305.m6NN5R4B016599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYGWXFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     page-allocator-inlnie-some-__alloc_pages-wrappers-fix
has been removed from the -mm tree.  Its filename was
     page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch

This patch was dropped because it was folded into page-allocator-inlnie-some-__alloc_pages-wrappers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator-inlnie-some-__alloc_pages-wrappers-fix
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "__alloc_pages_internal" [net/sunrpc/xprtrdma/svcrdma.ko] undefined!
ERROR: "__alloc_pages_internal" [net/sunrpc/sunrpc.ko] undefined!
ERROR: "__alloc_pages_internal" [net/sunrpc/auth_gss/auth_rpcgss.ko] undefined!
ERROR: "__alloc_pages_internal" [net/ipv6/ipv6.ko] undefined!
ERROR: "__alloc_pages_internal" [net/core/pktgen.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/xfs/xfs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/reiser4/reiser4.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/ntfs/ntfs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/nfs/nfs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/ncpfs/ncpfs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/isofs/isofs.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/gfs2/gfs2.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/fuse/fuse.ko] undefined!
ERROR: "__alloc_pages_internal" [fs/dlm/dlm.ko] undefined!
ERROR: "__alloc_pages_internal" [drivers/virtio/virtio_balloon.ko] undefined!
ERROR: "__alloc_pages_internal" [drivers/scsi/st.ko] undefined!
ERROR: "__alloc_pages_internal" [drivers/scsi/sg.ko] undefined!
...

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~page-allocator-inlnie-some-__alloc_pages-wrappers-fix mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-inlnie-some-__alloc_pages-wrappers-fix
+++ a/mm/page_alloc.c
@@ -1632,6 +1632,7 @@ nopage:
 got_pg:
 	return page;
 }
+EXPORT_SYMBOL(__alloc_pages_internal);
 
 /*
  * Common helper functions.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
vma-page-offset-has-no-callees-drop-it.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-non-const-fix-fix.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
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

