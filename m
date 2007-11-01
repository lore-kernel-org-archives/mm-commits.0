From: akpm@linux-foundation.org
Subject: + remove-mm_ptovvtop.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:43:44 -0700
Message-ID: <200711010743.lA17hiiS018728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51534 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769AbXKAHox (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:44:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bryan.wu@analog.com, gerg@uclinux.org, miles.bader@necel.com, ysato@users.sourceforge.jp


The patch titled
     remove mm_{ptov,vtop}()
has been added to the -mm tree.  Its filename is
     remove-mm_ptovvtop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -187,8 +187,6 @@ extern void blkfin_inv_cache_all(void);
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
git-dvb.patch
git-hwmon.patch
git-input.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
scheduled-oss-driver-removal.patch
cleanup-after-apus-removal.patch
53c7xx-removal-fallout.patch
remove-mm_ptovvtop.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
