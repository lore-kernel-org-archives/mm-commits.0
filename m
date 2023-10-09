Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60288E9371F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Oct 2023 23:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbjJIXab (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 19:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378152AbjJIXaa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 19:30:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375289D
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 16:30:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA10C433C7;
        Mon,  9 Oct 2023 23:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696894228;
        bh=BWtzV3RASvJK1WSiV3oMerkr6JPESXeZfR/YuDaat5E=;
        h=Date:To:From:Subject:From;
        b=YWkAAeJkf6w1BRh4UNlvVDTtzvzzHgHVTy4DIYAORttbtTP7vjxVUG5TdXT6+HTAB
         lk257t8qCD6k9XBGs9Jp3jqki4ic7uL/5RetGZ0njuVK0ef08JS8RNcCd094zFr8aE
         ylgMCVlablgarHtH47GE2Q/T6jdqGUkAOSFRmGfY=
Date:   Mon, 09 Oct 2023 16:30:11 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, Liam.Howlett@oracle.com, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch added to mm-unstable branch
Message-Id: <20231009233023.BCA10C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: abstract VMA merge and extend into vma_merge_extend() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: abstract VMA merge and extend into vma_merge_extend() helper
Date: Mon, 9 Oct 2023 21:53:20 +0100

mremap uses vma_merge() in the case where a VMA needs to be extended. 
This can be significantly simplified and abstracted.

This makes it far easier to understand what the actual function is doing,
avoids future mistakes in use of the confusing vma_merge() function and
importantly allows us to make future changes to how vma_merge() is
implemented by knowing explicitly which merge cases each invocation uses.

Note that in the mremap() extend case, we perform this merge only when
old_len == vma->vm_end - addr.  The extension_start, i.e.  the start of
the extended portion of the VMA is equal to addr + old_len, i.e. 
vma->vm_end.

With this refactoring, vma_merge() is no longer required anywhere except
mm/mmap.c, so mark it static.

Link: https://lkml.kernel.org/r/ab531d53bc5b4517c873c6648c08223ee575d8f6.1696884493.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 +++-----
 mm/mmap.c     |   31 ++++++++++++++++++++++++-------
 mm/mremap.c   |   30 +++++++++++++-----------------
 3 files changed, 40 insertions(+), 29 deletions(-)

--- a/mm/internal.h~mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper
+++ a/mm/internal.h
@@ -1014,11 +1014,9 @@ struct page *follow_trans_huge_pmd(struc
 /*
  * mm/mmap.c
  */
-struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
-	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
-	unsigned long end, unsigned long vm_flags, struct anon_vma *,
-	struct file *, pgoff_t, struct mempolicy *, struct vm_userfaultfd_ctx,
-	struct anon_vma_name *);
+struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
+					struct vm_area_struct *vma,
+					unsigned long delta);
 
 enum {
 	/* mark page accessed */
--- a/mm/mmap.c~mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper
+++ a/mm/mmap.c
@@ -860,13 +860,13 @@ can_vma_merge_after(struct vm_area_struc
  * **** is not represented - it will be merged and the vma containing the
  *      area is returned, or the function will return NULL
  */
-struct vm_area_struct *vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
-			struct vm_area_struct *prev, unsigned long addr,
-			unsigned long end, unsigned long vm_flags,
-			struct anon_vma *anon_vma, struct file *file,
-			pgoff_t pgoff, struct mempolicy *policy,
-			struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-			struct anon_vma_name *anon_name)
+static struct vm_area_struct
+*vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
+	   struct vm_area_struct *prev, unsigned long addr, unsigned long end,
+	   unsigned long vm_flags, struct anon_vma *anon_vma, struct file *file,
+	   pgoff_t pgoff, struct mempolicy *policy,
+	   struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+	   struct anon_vma_name *anon_name)
 {
 	struct vm_area_struct *curr, *next, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
@@ -2499,6 +2499,23 @@ static struct vm_area_struct *vma_merge_
 }
 
 /*
+ * Expand vma by delta bytes, potentially merging with an immediately adjacent
+ * VMA with identical properties.
+ */
+struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
+					struct vm_area_struct *vma,
+					unsigned long delta)
+{
+	pgoff_t pgoff = vma->vm_pgoff + vma_pages(vma);
+
+	/* vma is specified as prev, so case 1 or 2 will apply. */
+	return vma_merge(vmi, vma->vm_mm, vma, vma->vm_end, vma->vm_end + delta,
+			 vma->vm_flags, vma->anon_vma, vma->vm_file, pgoff,
+			 vma_policy(vma), vma->vm_userfaultfd_ctx,
+			 anon_vma_name(vma));
+}
+
+/*
  * do_vmi_align_munmap() - munmap the aligned region from @start to @end.
  * @vmi: The vma iterator
  * @vma: The starting vm_area_struct
--- a/mm/mremap.c~mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper
+++ a/mm/mremap.c
@@ -1096,14 +1096,12 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	/* old_len exactly to the end of the area..
 	 */
 	if (old_len == vma->vm_end - addr) {
+		unsigned long delta = new_len - old_len;
+
 		/* can we just expand the current mapping? */
-		if (vma_expandable(vma, new_len - old_len)) {
-			long pages = (new_len - old_len) >> PAGE_SHIFT;
-			unsigned long extension_start = addr + old_len;
-			unsigned long extension_end = addr + new_len;
-			pgoff_t extension_pgoff = vma->vm_pgoff +
-				((extension_start - vma->vm_start) >> PAGE_SHIFT);
-			VMA_ITERATOR(vmi, mm, extension_start);
+		if (vma_expandable(vma, delta)) {
+			long pages = delta >> PAGE_SHIFT;
+			VMA_ITERATOR(vmi, mm, vma->vm_end);
 			long charged = 0;
 
 			if (vma->vm_flags & VM_ACCOUNT) {
@@ -1115,17 +1113,15 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			}
 
 			/*
-			 * Function vma_merge() is called on the extension we
-			 * are adding to the already existing vma, vma_merge()
-			 * will merge this extension with the already existing
-			 * vma (expand operation itself) and possibly also with
-			 * the next vma if it becomes adjacent to the expanded
-			 * vma and  otherwise compatible.
+			 * Function vma_merge_extend() is called on the
+			 * extension we are adding to the already existing vma,
+			 * vma_merge_extend() will merge this extension with the
+			 * already existing vma (expand operation itself) and
+			 * possibly also with the next vma if it becomes
+			 * adjacent to the expanded vma and otherwise
+			 * compatible.
 			 */
-			vma = vma_merge(&vmi, mm, vma, extension_start,
-				extension_end, vma->vm_flags, vma->anon_vma,
-				vma->vm_file, extension_pgoff, vma_policy(vma),
-				vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			vma = vma_merge_extend(&vmi, vma, delta);
 			if (!vma) {
 				vm_unacct_memory(charged);
 				ret = -ENOMEM;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch

