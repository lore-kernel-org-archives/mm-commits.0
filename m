Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D426FE9413E
	for <mm-commits@archiver.kernel.org>; Mon,  9 Oct 2023 23:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbjJIXaN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 19:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbjJIXaM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 19:30:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E74AAF
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 16:30:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7C9C433C8;
        Mon,  9 Oct 2023 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696894209;
        bh=B1+GLa4au92C6v4wYKwTzTHPUi4+jHidAL+aQpr3T0A=;
        h=Date:To:From:Subject:From;
        b=O2wEA7pHR0XJWsZVbHRg8XO5xYbtCpYyDSnscvx7b1F9pnjFDst/Q+Y31i4RmiEEf
         W6pAJkiFKEW8yTb6HHrQ72OjaRaT3RMxVtBPRrXJYV5gPvG+fsPkbpVibnJIk3zEr+
         3M28uvC7sPAtvYOnkigoRCOA1GWcPqAwKGMdsHZY=
Date:   Mon, 09 Oct 2023 16:29:56 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, Liam.Howlett@oracle.com, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vma_merge-and-split_vma-internal.patch added to mm-unstable branch
Message-Id: <20231009233007.4E7C9C433C8@smtp.kernel.org>
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
Date: Mon, 9 Oct 2023 21:53:18 +0100

Now the common pattern of - attempting a merge via vma_merge() and should
this fail splitting VMAs via split_vma() - has been abstracted, the former
can be placed into mm/internal.h and the latter made static.

In addition, the split_vma() nommu variant also need not be exported.

Link: https://lkml.kernel.org/r/31d2c79f7a3bca03d4a4c95e98d9a27cb1f99bf1.1696884493.git.lstoakes@gmail.com
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
@@ -3237,16 +3237,7 @@ extern int vma_expand(struct vma_iterato
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
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch

