Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2CCC54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbjAZWwx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjAZWww (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:52:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FB3618E
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:52:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90B5E61978
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5836C433D2;
        Thu, 26 Jan 2023 22:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674773566;
        bh=i+jsMGFApe84CMzWqU/CWG2NDNxKSpnup9YbJuhvFy0=;
        h=Date:To:From:Subject:From;
        b=PPmPR86hu1P5oUSnvA9UWBifgSQrmjNF6dudf2x1wQDNUKaZDC009ALm5SQxZAhYF
         Co3WPK0VLh8yYa0g8OIcf8z5fZ4EG6GwWMMa7jZ5FcQuWcfT2hW+fSoQFpJznKPRox
         /Mr7N0CKHroH51sGgRx71v+h27ktALYMSDJdy74E=
Date:   Thu, 26 Jan 2023 14:52:45 -0800
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, arnd@arndb.de,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-shm-introduce-new-do_vma_munmap-to-munmap.patch added to mm-unstable branch
Message-Id: <20230126225245.E5836C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: introduce new do_vma_munmap() to munmap
has been added to the -mm mm-unstable branch.  Its filename is
     ipc-shm-introduce-new-do_vma_munmap-to-munmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-shm-introduce-new-do_vma_munmap-to-munmap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: ipc/shm: introduce new do_vma_munmap() to munmap
Date: Thu, 26 Jan 2023 16:20:49 -0500

The shm already has the vma iterator in position for a write. 
do_vmi_munmap() searches for the correct position and aligns the write, so
it is not the right function to use in this case.

The shm VMA tree modification is similar to the brk munmap situation, the
vma iterator is in position and the VMA is already known.  This patch
generalizes the brk munmap function do_brk_munmap() to be used for any
other callers with the vma iterator already in position to munmap a VMA.

Link: https://lkml.kernel.org/r/20230126212049.980501-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Sven Schnelle <svens@linux.ibm.com>
  Link: https://lore.kernel.org/linux-mm/yt9dh6wec21a.fsf@linux.ibm.com/
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 ipc/shm.c          |   11 ++++++-----
 mm/mmap.c          |   40 +++++++++++++++++++---------------------
 3 files changed, 28 insertions(+), 26 deletions(-)

--- a/include/linux/mm.h~ipc-shm-introduce-new-do_vma_munmap-to-munmap
+++ a/include/linux/mm.h
@@ -2972,6 +2972,9 @@ extern int do_munmap(struct mm_struct *,
 extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior);
 
 #ifdef CONFIG_MMU
+extern int do_vma_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
+			 unsigned long start, unsigned long end,
+			 struct list_head *uf, bool downgrade);
 extern int __mm_populate(unsigned long addr, unsigned long len,
 			 int ignore_errors);
 static inline void mm_populate(unsigned long addr, unsigned long len)
--- a/ipc/shm.c~ipc-shm-introduce-new-do_vma_munmap-to-munmap
+++ a/ipc/shm.c
@@ -1786,8 +1786,8 @@ long ksys_shmdt(char __user *shmaddr)
 			 */
 			file = vma->vm_file;
 			size = i_size_read(file_inode(vma->vm_file));
-			do_vmi_munmap(&vmi, mm, vma->vm_start,
-			      vma->vm_end - vma->vm_start, NULL, false);
+			do_vma_munmap(&vmi, vma, vma->vm_start, vma->vm_end,
+				      NULL, false);
 			/*
 			 * We discovered the size of the shm segment, so
 			 * break out of here and fall through to the next
@@ -1810,9 +1810,10 @@ long ksys_shmdt(char __user *shmaddr)
 		/* finding a matching vma now does not alter retval */
 		if ((vma->vm_ops == &shm_vm_ops) &&
 		    ((vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) &&
-		    (vma->vm_file == file))
-			do_vmi_munmap(&vmi, mm, vma->vm_start,
-			      vma->vm_end - vma->vm_start, NULL, false);
+		    (vma->vm_file == file)) {
+			do_vma_munmap(&vmi, vma, vma->vm_start, vma->vm_end,
+				      NULL, false);
+		}
 
 		vma = vma_next(&vmi);
 	}
--- a/mm/mmap.c~ipc-shm-introduce-new-do_vma_munmap-to-munmap
+++ a/mm/mmap.c
@@ -180,9 +180,6 @@ static int check_brk_limits(unsigned lon
 
 	return mlock_future_check(current->mm, current->mm->def_flags, len);
 }
-static int do_brk_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
-			 unsigned long newbrk, unsigned long oldbrk,
-			 struct list_head *uf);
 static int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 		unsigned long addr, unsigned long request, unsigned long flags);
 SYSCALL_DEFINE1(brk, unsigned long, brk)
@@ -236,7 +233,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 
 	/*
 	 * Always allow shrinking brk.
-	 * do_brk_munmap() may downgrade mmap_lock to read.
+	 * do_vma_munmap() may downgrade mmap_lock to read.
 	 */
 	if (brk <= mm->brk) {
 		int ret;
@@ -248,11 +245,11 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 			goto out; /* mapping intersects with an existing non-brk vma. */
 		/*
 		 * mm->brk must be protected by write mmap_lock.
-		 * do_brk_munmap() may downgrade the lock,  so update it
-		 * before calling do_brk_munmap().
+		 * do_vma_munmap() may downgrade the lock,  so update it
+		 * before calling do_vma_munmap().
 		 */
 		mm->brk = brk;
-		ret = do_brk_munmap(&vmi, brkvma, newbrk, oldbrk, &uf);
+		ret = do_vma_munmap(&vmi, brkvma, newbrk, oldbrk, &uf, true);
 		if (ret == 1)  {
 			downgraded = true;
 			goto success;
@@ -2844,26 +2841,27 @@ out:
 }
 
 /*
- * brk_munmap() - Unmap a full or partial vma.
- * @vmi: The vma iterator
- * @vma: The vma to be modified
- * @newbrk: the start of the address to unmap
- * @oldbrk: The end of the address to unmap
+ * do_vma_munmap() - Unmap a full or partial vma.
+ * @vmi: The vma iterator pointing at the vma
+ * @vma: The first vma to be munmapped
+ * @start: the start of the address to unmap
+ * @end: The end of the address to unmap
  * @uf: The userfaultfd list_head
+ * @downgrade: Attempt to downgrade or not
  *
- * Returns: 1 on success.
- * unmaps a partial VMA mapping.  Does not handle alignment, downgrades lock if
- * possible.
- */
-static int do_brk_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
-			 unsigned long newbrk, unsigned long oldbrk,
-			 struct list_head *uf)
+ * Returns: 0 on success and not downgraded, 1 on success and downgraded.
+ * unmaps a VMA mapping when the vma iterator is already in position.
+ * Does not handle alignment.
+ */
+int do_vma_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		  unsigned long start, unsigned long end,
+		  struct list_head *uf, bool downgrade)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int ret;
 
-	arch_unmap(mm, newbrk, oldbrk);
-	ret = do_vmi_align_munmap(vmi, vma, mm, newbrk, oldbrk, uf, true);
+	arch_unmap(mm, start, end);
+	ret = do_vmi_align_munmap(vmi, vma, mm, start, end, uf, downgrade);
 	validate_mm_mt(mm);
 	return ret;
 }
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch
maple_tree-fix-mas_prev-and-mas_find-state-handling.patch
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
madvise-use-split_vma-instead-of-__split_vma-fix.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch
ipc-shm-introduce-new-do_vma_munmap-to-munmap.patch

