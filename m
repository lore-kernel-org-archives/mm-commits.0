From: akpm@linux-foundation.org
Subject: - kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 19 Oct 2007 16:34:22 -0700
Message-ID: <200710192334.l9JNYMjl025998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758758AbXJSXe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     kexec-introduce-bootmem_exclusive-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch

This patch was dropped because it was folded into kexec-introduce-bootmem_exclusive.patch

------------------------------------------------------
Subject: kexec-introduce-bootmem_exclusive-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#69: FILE: arch/x86/kernel/setup_32.c:415:
+			reserve_bootmem(crash_base, crash_size, BOOTMEM_DEFAULT);

WARNING: line over 80 characters
#174: FILE: mm/bootmem.c:114:
+static int __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,

total: 0 errors, 2 warnings, 167 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_32.c |    3 ++-
 mm/bootmem.c               |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/setup_32.c~kexec-introduce-bootmem_exclusive-checkpatch-fixes arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~kexec-introduce-bootmem_exclusive-checkpatch-fixes
+++ a/arch/x86/kernel/setup_32.c
@@ -412,7 +412,8 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(total_mem >> 20));
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size, BOOTMEM_DEFAULT);
+			reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
diff -puN mm/bootmem.c~kexec-introduce-bootmem_exclusive-checkpatch-fixes mm/bootmem.c
--- a/mm/bootmem.c~kexec-introduce-bootmem_exclusive-checkpatch-fixes
+++ a/mm/bootmem.c
@@ -111,8 +111,8 @@ static unsigned long __init init_bootmem
  * might be used for boot-time allocations - or it might get added
  * to the free page pool later on.
  */
-static int __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
-					unsigned long size, int flags)
+static int __init reserve_bootmem_core(bootmem_data_t *bdata,
+			unsigned long addr, unsigned long size, int flags)
 {
 	unsigned long sidx, eidx;
 	unsigned long i;
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
kexec-introduce-bootmem_exclusive.patch
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
