From: akpm@linux-foundation.org
Subject: + remap_file_pages-kernel-doc-corrections.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:26:50 -0700
Message-ID: <200710151926.l9FJQo3g020895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759839AbXJOT21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, nickpiggin@yahoo.com.au


The patch titled
     remap_file_pages: kernel-doc corrections
has been added to the -mm tree.  Its filename is
     remap_file_pages-kernel-doc-corrections.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-alsa.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
git-nfsd.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
dontdiff-update-based-on-gitignore-updates.patch
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
video-gfx-merge-kconfig-menus.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
remap_file_pages-kernel-doc-corrections.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
