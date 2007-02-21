From: akpm@linux-foundation.org
Subject: + mm-tiny-shmemc-cleanups.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:15:09 -0800
Message-ID: <200702212215.l1LMF9OJ028044@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52197 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423185AbXBUWS0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ebiederm@xmission.com, hugh@veritas.com


The patch titled
     mm/{,tiny-}shmem.c cleanups
has been added to the -mm tree.  Its filename is
     mm-tiny-shmemc-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm/{,tiny-}shmem.c cleanups
From: Adrian Bunk <bunk@stusta.de>

shmem_{nopage,mmap} are no longer used in ipc/shm.c

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 -----
 mm/shmem.c         |    5 +++--
 mm/tiny-shmem.c    |    2 ++
 3 files changed, 5 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-tiny-shmemc-cleanups include/linux/mm.h
--- a/include/linux/mm.h~mm-tiny-shmemc-cleanups
+++ a/include/linux/mm.h
@@ -660,15 +660,11 @@ static inline int page_mapped(struct pag
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-struct page *shmem_nopage(struct vm_area_struct *vma,
-			unsigned long address, int *type);
 int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new);
 struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
 					unsigned long addr);
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #else
-#define shmem_nopage filemap_nopage
-
 static inline int shmem_lock(struct file *file, int lock,
 			     struct user_struct *user)
 {
@@ -688,7 +684,6 @@ static inline struct mempolicy *shmem_ge
 }
 #endif
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
-extern int shmem_mmap(struct file *file, struct vm_area_struct *vma);
 
 int shmem_zero_setup(struct vm_area_struct *);
 
diff -puN mm/shmem.c~mm-tiny-shmemc-cleanups mm/shmem.c
--- a/mm/shmem.c~mm-tiny-shmemc-cleanups
+++ a/mm/shmem.c
@@ -1228,7 +1228,8 @@ failed:
 	return error;
 }
 
-struct page *shmem_nopage(struct vm_area_struct *vma, unsigned long address, int *type)
+static struct page *shmem_nopage(struct vm_area_struct *vma,
+				 unsigned long address, int *type)
 {
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	struct page *page = NULL;
@@ -1335,7 +1336,7 @@ out_nomem:
 	return retval;
 }
 
-int shmem_mmap(struct file *file, struct vm_area_struct *vma)
+static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
 	vma->vm_ops = &shmem_vm_ops;
diff -puN mm/tiny-shmem.c~mm-tiny-shmemc-cleanups mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~mm-tiny-shmemc-cleanups
+++ a/mm/tiny-shmem.c
@@ -126,6 +126,7 @@ int shmem_unuse(swp_entry_t entry, struc
 	return 0;
 }
 
+#if 0
 int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
@@ -135,6 +136,7 @@ int shmem_mmap(struct file *file, struct
 	return 0;
 #endif
 }
+#endif  /*  0  */
 
 #ifndef CONFIG_MMU
 unsigned long shmem_get_unmapped_area(struct file *file,
_

Patches currently in -mm which might be from bunk@stusta.de are

arch-arm26-kernel-entrys-remove-dead-code.patch
make-ipc-shmcshm_nopage-static.patch
mm-tiny-shmemc-cleanups.patch
git-cpufreq.patch
make-kernel-kmodckmod_mk-static.patch
git-drm.patch
git-dvb.patch
make-dvb_usb_gl861_debug-static.patch
make-pvr2_encoder_prep_config-static.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
drivers-mmc-kconfig-source-drivers-mmc-card-kconfig.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
make-drivers-usb-misc-iowarriorciowarrior_ids-static.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch
kill-net-rxrpc-rxrpc_symsc.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
