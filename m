From: akpm@linux-foundation.org
Subject: - mm-shmemc-make-3-functions-static.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:08 -0700
Message-ID: <200710162036.l9GKa8lZ015122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40255 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965942AbXJPVet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm/shmem.c: make 3 functions static
has been removed from the -mm tree.  Its filename was
     mm-shmemc-make-3-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/shmem.c: make 3 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   15 ---------------
 mm/shmem.c         |   10 +++++-----
 2 files changed, 5 insertions(+), 20 deletions(-)

diff -puN include/linux/mm.h~mm-shmemc-make-3-functions-static include/linux/mm.h
--- a/include/linux/mm.h~mm-shmemc-make-3-functions-static
+++ a/include/linux/mm.h
@@ -648,9 +648,6 @@ static inline int page_mapped(struct pag
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new);
-struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
-					unsigned long addr);
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #else
 static inline int shmem_lock(struct file *file, int lock,
@@ -658,18 +655,6 @@ static inline int shmem_lock(struct file
 {
 	return 0;
 }
-
-static inline int shmem_set_policy(struct vm_area_struct *vma,
-				   struct mempolicy *new)
-{
-	return 0;
-}
-
-static inline struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
-						 unsigned long addr)
-{
-	return NULL;
-}
 #endif
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
 
diff -puN mm/shmem.c~mm-shmemc-make-3-functions-static mm/shmem.c
--- a/mm/shmem.c~mm-shmemc-make-3-functions-static
+++ a/mm/shmem.c
@@ -1026,8 +1026,8 @@ static struct page *shmem_swapin_async(s
 	return page;
 }
 
-struct page *shmem_swapin(struct shmem_inode_info *info, swp_entry_t entry,
-			  unsigned long idx)
+static struct page *shmem_swapin(struct shmem_inode_info *info,
+				 swp_entry_t entry, unsigned long idx)
 {
 	struct shared_policy *p = &info->policy;
 	int i, num;
@@ -1329,14 +1329,14 @@ static int shmem_fault(struct vm_area_st
 }
 
 #ifdef CONFIG_NUMA
-int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
+static int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 {
 	struct inode *i = vma->vm_file->f_path.dentry->d_inode;
 	return mpol_set_shared_policy(&SHMEM_I(i)->policy, vma, new);
 }
 
-struct mempolicy *
-shmem_get_policy(struct vm_area_struct *vma, unsigned long addr)
+static struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
+					  unsigned long addr)
 {
 	struct inode *i = vma->vm_file->f_path.dentry->d_inode;
 	unsigned long idx;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
maps2-add-proc-kpagemap-interface.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
dontdiff-update-based-on-gitignore-updates.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
