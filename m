From: akpm@linux-foundation.org
Subject: - remove-mm_ptovvtop.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:25 -0800
Message-ID: <200802070021.m170L6gp006289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760163AbYBGArV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:47:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bryan.wu@analog.com, gerg@uclinux.org, miles.bader@necel.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     remove mm_{ptov,vtop}()
has been removed from the -mm tree.  Its filename was
     remove-mm_ptovvtop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove mm_{ptov,vtop}()
From: Adrian Bunk <bunk@kernel.org>

This patch removes the unused mm_{ptov,vtop}().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Acked-by: Bryan Wu <bryan.wu@analog.com>
Cc: Miles Bader <miles.bader@necel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/io.h       |    2 --
 include/asm-h8300/io.h          |    2 --
 include/asm-h8300/virtconvert.h |    2 --
 include/asm-m68knommu/io.h      |    2 --
 include/asm-v850/io.h           |    2 --
 5 files changed, 10 deletions(-)

diff -puN include/asm-blackfin/io.h~remove-mm_ptovvtop include/asm-blackfin/io.h
--- a/include/asm-blackfin/io.h~remove-mm_ptovvtop
+++ a/include/asm-blackfin/io.h
@@ -188,8 +188,6 @@ extern void blkfin_inv_cache_all(void);
 #define page_to_phys(page)      ((page - mem_map) << PAGE_SHIFT)
 #define page_to_bus(page)       ((page - mem_map) << PAGE_SHIFT)
 
-#define mm_ptov(vaddr)		((void *) (vaddr))
-#define mm_vtop(vaddr)		((unsigned long) (vaddr))
 #define phys_to_virt(vaddr)	((void *) (vaddr))
 #define virt_to_phys(vaddr)	((unsigned long) (vaddr))
 
diff -puN include/asm-h8300/io.h~remove-mm_ptovvtop include/asm-h8300/io.h
--- a/include/asm-h8300/io.h~remove-mm_ptovvtop
+++ a/include/asm-h8300/io.h
@@ -302,8 +302,6 @@ static __inline__ void ctrl_outl(unsigne
 /*
  * Macros used for converting between virtual and physical mappings.
  */
-#define mm_ptov(vaddr)		((void *) (vaddr))
-#define mm_vtop(vaddr)		((unsigned long) (vaddr))
 #define phys_to_virt(vaddr)	((void *) (vaddr))
 #define virt_to_phys(vaddr)	((unsigned long) (vaddr))
 
diff -puN include/asm-h8300/virtconvert.h~remove-mm_ptovvtop include/asm-h8300/virtconvert.h
--- a/include/asm-h8300/virtconvert.h~remove-mm_ptovvtop
+++ a/include/asm-h8300/virtconvert.h
@@ -10,8 +10,6 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 
-#define mm_ptov(vaddr)		((void *) (vaddr))
-#define mm_vtop(vaddr)		((unsigned long) (vaddr))
 #define phys_to_virt(vaddr)	((void *) (vaddr))
 #define virt_to_phys(vaddr)	((unsigned long) (vaddr))
 
diff -puN include/asm-m68knommu/io.h~remove-mm_ptovvtop include/asm-m68knommu/io.h
--- a/include/asm-m68knommu/io.h~remove-mm_ptovvtop
+++ a/include/asm-m68knommu/io.h
@@ -172,8 +172,6 @@ extern void iounmap(void *addr);
 /*
  * Macros used for converting between virtual and physical mappings.
  */
-#define mm_ptov(vaddr)		((void *) (vaddr))
-#define mm_vtop(vaddr)		((unsigned long) (vaddr))
 #define phys_to_virt(vaddr)	((void *) (vaddr))
 #define virt_to_phys(vaddr)	((unsigned long) (vaddr))
 
diff -puN include/asm-v850/io.h~remove-mm_ptovvtop include/asm-v850/io.h
--- a/include/asm-v850/io.h~remove-mm_ptovvtop
+++ a/include/asm-v850/io.h
@@ -122,8 +122,6 @@ outsl (unsigned long port, const void *s
 #endif
 
 /* Conversion between virtual and physical mappings.  */
-#define mm_ptov(addr)		((void *)__phys_to_virt (addr))
-#define mm_vtop(addr)		((unsigned long)__virt_to_phys (addr))
 #define phys_to_virt(addr)	((void *)__phys_to_virt (addr))
 #define virt_to_phys(addr)	((unsigned long)__virt_to_phys (addr))
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
