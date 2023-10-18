Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED1CCDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbjJRVhs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbjJRVgw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A661B9
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BECC433C7;
        Wed, 18 Oct 2023 21:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664964;
        bh=XlYeAugXsSu3j9NIiqtiCcRc/Jo57lkxgeCET+ShfyQ=;
        h=Date:To:From:Subject:From;
        b=2PoNDunAB6ms3ISk3UjvdAxKO3QSSGhKKSZh4yAhgCIILDQ/BfdXda0Exw+wH8oaP
         cqWtRRDqH/bsXyGX28PrqPHYBjW0mTKkz5kE7BStL5wYgn3F51KwUFjj4mwZ8S3EEO
         ZSbnsF9AZjDI1Lnu5XPCrEMg3yXjJzPjH7jY0KeQ=
Date:   Wed, 18 Oct 2023 14:36:04 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, Liam.Howlett@oracle.com, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-vma_merge-and-split_vma-internal.patch removed from -mm tree
Message-Id: <20231018213604.C1BECC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make vma_merge() and split_vma() internal
has been removed from the -mm tree.  Its filename was
     mm-make-vma_merge-and-split_vma-internal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: make vma_merge() and split_vma() internal
Date: Wed, 11 Oct 2023 18:04:29 +0100

Now the common pattern of - attempting a merge via vma_merge() and should
this fail splitting VMAs via split_vma() - has been abstracted, the former
can be placed into mm/internal.h and the latter made static.

In addition, the split_vma() nommu variant also need not be exported.

Link: https://lkml.kernel.org/r/405f2be10e20c4e9fbcc9fe6b2dfea105f6642e0.1697043508.git.lstoakes@gmail.com
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
@@ -3235,16 +3235,7 @@ extern int vma_expand(struct vma_iterato
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
@@ -1002,6 +1002,15 @@ struct page *follow_trans_huge_pmd(struc
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


