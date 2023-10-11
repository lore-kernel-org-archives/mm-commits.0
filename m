Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7998CDB472
	for <mm-commits@archiver.kernel.org>; Wed, 11 Oct 2023 17:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbjJKRym (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Oct 2023 13:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbjJKRyl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2023 13:54:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB0BB8
        for <mm-commits@vger.kernel.org>; Wed, 11 Oct 2023 10:54:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644DAC433C8;
        Wed, 11 Oct 2023 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697046879;
        bh=XH+NwDWLsOtGHVOIFXY8UsoRsxvoj4bAEXol7Wp0Sfk=;
        h=Date:To:From:Subject:From;
        b=T50HV2xEnXIGLvi0/IsdoODtza/lJYeiTPKCg0OtjO11YELClLvomR8Kfh6+HxhZi
         sNNzTnDaASahYtEE1tTVv36FkY5sF7RVEj+dpaaLe8ssw+COvSSQKql8vtpTeJUJ39
         Jkm6OrgVIbVAGOhELUOSyB9ef5BYP3OeTPAkeUI0=
Date:   Wed, 11 Oct 2023 10:54:26 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, Liam.Howlett@oracle.com, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vma_merge-and-split_vma-internal.patch added to mm-unstable branch
Message-Id: <20231011175436.644DAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make vma_merge() and split_vma() internal
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-vma_merge-and-split_vma-internal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-vma_merge-and-split_vma-internal.patch

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
Subject: mm: make vma_merge() and split_vma() internal
Date: Tue, 10 Oct 2023 19:23:06 +0100

Now the common pattern of - attempting a merge via vma_merge() and should
this fail splitting VMAs via split_vma() - has been abstracted, the former
can be placed into mm/internal.h and the latter made static.

In addition, the split_vma() nommu variant also need not be exported.

Link: https://lkml.kernel.org/r/188659ab3a8efc58a26fbd64b735ebbb88a65aa0.1696929425.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 ---------
 mm/internal.h      |    9 +++++++++
 mm/mmap.c          |    8 ++++----
 mm/nommu.c         |    4 ++--
 4 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-make-vma_merge-and-split_vma-internal
+++ a/include/linux/mm.h
@@ -3248,16 +3248,7 @@ extern int vma_expand(struct vma_iterato
 		      struct vm_area_struct *next);
 extern int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		       unsigned long start, unsigned long end, pgoff_t pgoff);
-extern struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
-	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
-	unsigned long end, unsigned long vm_flags, struct anon_vma *,
-	struct file *, pgoff_t, struct mempolicy *, struct vm_userfaultfd_ctx,
-	struct anon_vma_name *);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
-extern int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *,
-		       unsigned long addr, int new_below);
-extern int split_vma(struct vma_iterator *vmi, struct vm_area_struct *,
-			 unsigned long addr, int new_below);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
--- a/mm/internal.h~mm-make-vma_merge-and-split_vma-internal
+++ a/mm/internal.h
@@ -1011,6 +1011,15 @@ struct page *follow_trans_huge_pmd(struc
 				   unsigned long addr, pmd_t *pmd,
 				   unsigned int flags);
 
+/*
+ * mm/mmap.c
+ */
+struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
+	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
+	unsigned long end, unsigned long vm_flags, struct anon_vma *,
+	struct file *, pgoff_t, struct mempolicy *, struct vm_userfaultfd_ctx,
+	struct anon_vma_name *);
+
 enum {
 	/* mark page accessed */
 	FOLL_TOUCH = 1 << 16,
--- a/mm/mmap.c~mm-make-vma_merge-and-split_vma-internal
+++ a/mm/mmap.c
@@ -2346,8 +2346,8 @@ static void unmap_region(struct mm_struc
  * has already been checked or doesn't make sense to fail.
  * VMA Iterator will point to the end VMA.
  */
-int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		unsigned long addr, int new_below)
+static int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		       unsigned long addr, int new_below)
 {
 	struct vma_prepare vp;
 	struct vm_area_struct *new;
@@ -2428,8 +2428,8 @@ out_free_vma:
  * Split a vma into two pieces at address 'addr', a new vma is allocated
  * either for the first part or the tail.
  */
-int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	      unsigned long addr, int new_below)
+static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		     unsigned long addr, int new_below)
 {
 	if (vma->vm_mm->map_count >= sysctl_max_map_count)
 		return -ENOMEM;
--- a/mm/nommu.c~mm-make-vma_merge-and-split_vma-internal
+++ a/mm/nommu.c
@@ -1305,8 +1305,8 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
  * split a vma into two pieces at address 'addr', a new vma is allocated either
  * for the first part or the tail.
  */
-int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	      unsigned long addr, int new_below)
+static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		     unsigned long addr, int new_below)
 {
 	struct vm_area_struct *new;
 	struct vm_region *region;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch
mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
mm-enforce-the-mapping_map_writable-check-after-call_mmap.patch
mm-mprotect-allow-unfaulted-vmas-to-be-unaccounted-on-mprotect.patch
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch

