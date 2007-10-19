From: akpm@linux-foundation.org
Subject: - kexec-add-bss-to-resource-tree-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 19 Oct 2007 16:33:55 -0700
Message-ID: <200710192333.l9JNXtxR025987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54203 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758337AbXJSXeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     kexec-add-bss-to-resource-tree-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kexec-add-bss-to-resource-tree-checkpatch-fixes.patch

This patch was dropped because it was folded into kexec-add-bss-to-resource-tree.patch

------------------------------------------------------
Subject: kexec-add-bss-to-resource-tree-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: externs should be avoided in .c files
#68: FILE: arch/ia64/kernel/setup.c:98:
+extern char _text[], _end[], _etext[], _edata[], _bss[];

WARNING: externs should be avoided in .c files
#144: FILE: arch/x86/kernel/e820_64.c:50:
+extern struct resource code_resource, data_resource, bss_resource;

ERROR: use tabs not spaces
#164: FILE: arch/x86/kernel/efi_32.c:606:
+                               struct resource *data_resource,$

WARNING: externs should be avoided in .c files
#192: FILE: arch/x86/kernel/setup_32.c:77:
+extern struct resource bss_resource;

total: 1 errors, 3 warnings, 173 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/efi_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/efi_32.c~kexec-add-bss-to-resource-tree-checkpatch-fixes arch/x86/kernel/efi_32.c
--- a/arch/x86/kernel/efi_32.c~kexec-add-bss-to-resource-tree-checkpatch-fixes
+++ a/arch/x86/kernel/efi_32.c
@@ -603,7 +603,7 @@ void __init efi_enter_virtual_mode(void)
 
 void __init
 efi_initialize_iomem_resources(struct resource *code_resource,
-                               struct resource *data_resource,
+			       struct resource *data_resource,
 			       struct resource *bss_resource)
 {
 	struct resource *res;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
capabilities-clean-up-file-capability-reading.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
kexec-add-bss-to-resource-tree.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
