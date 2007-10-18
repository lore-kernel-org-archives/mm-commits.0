From: akpm@linux-foundation.org
Subject: - remap_file_pages-kernel-doc-corrections.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:57 -0700
Message-ID: <200710180704.l9I74vAt031603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756673AbXJRHVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:21:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     remap_file_pages: kernel-doc corrections
has been removed from the -mm tree.  Its filename was
     remap_file_pages-kernel-doc-corrections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remap_file_pages: kernel-doc corrections
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc for sys_remap_file_pages() and add info to the 'prot' NOTE. 
Rename __prot parameter to prot.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/fremap.c~remap_file_pages-kernel-doc-corrections mm/fremap.c
--- a/mm/fremap.c~remap_file_pages-kernel-doc-corrections
+++ a/mm/fremap.c
@@ -97,26 +97,28 @@ static int populate_range(struct mm_stru
 
 }
 
-/***
- * sys_remap_file_pages - remap arbitrary pages of a shared backing store
- *                        file within an existing vma.
+/**
+ * sys_remap_file_pages - remap arbitrary pages of an existing VM_SHARED vma
  * @start: start of the remapped virtual memory range
  * @size: size of the remapped virtual memory range
- * @prot: new protection bits of the range
- * @pgoff: to be mapped page of the backing store file
+ * @prot: new protection bits of the range (see NOTE)
+ * @pgoff: to-be-mapped page of the backing store file
  * @flags: 0 or MAP_NONBLOCKED - the later will cause no IO.
  *
- * this syscall works purely via pagetables, so it's the most efficient
+ * sys_remap_file_pages remaps arbitrary pages of an existing VM_SHARED vma
+ * (shared backing store file).
+ *
+ * This syscall works purely via pagetables, so it's the most efficient
  * way to map the same (large) file into a given virtual window. Unlike
  * mmap()/mremap() it does not create any new vmas. The new mappings are
  * also safe across swapout.
  *
- * NOTE: the 'prot' parameter right now is ignored, and the vma's default
- * protection is used. Arbitrary protections might be implemented in the
- * future.
+ * NOTE: the 'prot' parameter right now is ignored (but must be zero),
+ * and the vma's default protection is used. Arbitrary protections
+ * might be implemented in the future.
  */
 asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
-	unsigned long __prot, unsigned long pgoff, unsigned long flags)
+	unsigned long prot, unsigned long pgoff, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct address_space *mapping;
@@ -125,7 +127,7 @@ asmlinkage long sys_remap_file_pages(uns
 	int err = -EINVAL;
 	int has_write_lock = 0;
 
-	if (__prot)
+	if (prot)
 		return err;
 	/*
 	 * Sanitize the syscall parameters:
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
i-oat-cleanup-pci-issues.patch
profile-likely-unlikely-macros.patch
