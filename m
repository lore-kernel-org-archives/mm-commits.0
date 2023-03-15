Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65C1C76195
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjCOURl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjCOURe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:17:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EBE1C7F0
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0237B81F16
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6072FC433EF;
        Wed, 15 Mar 2023 20:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911450;
        bh=zu3DHvP3NEluZzOHLnHwuMd+QOMgOTGSfgp7JrPRyZ4=;
        h=Date:To:From:Subject:From;
        b=Bq/VHJqfl4UO+2R018zeuLSI8IMuJ5jOZNL6L6i3BL/juZ9bWgySk9GQYvkkZmVTT
         A6YjIz0nNQwGnU7URxS4hcj40QtGBXyHlAAgtqcqXkkpR/ABtH9yp3lqNXNYqYwPZK
         4T0bYAHoP5IvnXCNsZXLRxFOGBhV5du5PhWD9tA8=
Date:   Wed, 15 Mar 2023 13:17:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch added to mm-unstable branch
Message-Id: <20230315201730.6072FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap/vma_merge: convert mergeability checks to return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: convert mergeability checks to return bool
Date: Thu, 9 Mar 2023 12:12:56 +0100

The comments already mention returning 'true' so make the code match them.

Link: https://lkml.kernel.org/r/20230309111258.24079-9-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   53 ++++++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool
+++ a/mm/mmap.c
@@ -757,10 +757,10 @@ int vma_shrink(struct vma_iterator *vmi,
  * If the vma has a ->close operation then the driver probably needs to release
  * per-vma resources, so we don't attempt to merge those.
  */
-static inline int is_mergeable_vma(struct vm_area_struct *vma,
-				   struct file *file, unsigned long vm_flags,
-				   struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-				   struct anon_vma_name *anon_name)
+static inline bool is_mergeable_vma(struct vm_area_struct *vma,
+		struct file *file, unsigned long vm_flags,
+		struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+		struct anon_vma_name *anon_name)
 {
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
@@ -771,21 +771,20 @@ static inline int is_mergeable_vma(struc
 	 * extended instead.
 	 */
 	if ((vma->vm_flags ^ vm_flags) & ~VM_SOFTDIRTY)
-		return 0;
+		return false;
 	if (vma->vm_file != file)
-		return 0;
+		return false;
 	if (vma->vm_ops && vma->vm_ops->close)
-		return 0;
+		return false;
 	if (!is_mergeable_vm_userfaultfd_ctx(vma, vm_userfaultfd_ctx))
-		return 0;
+		return false;
 	if (!anon_vma_name_eq(anon_vma_name(vma), anon_name))
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
-static inline int is_mergeable_anon_vma(struct anon_vma *anon_vma1,
-					struct anon_vma *anon_vma2,
-					struct vm_area_struct *vma)
+static inline bool is_mergeable_anon_vma(struct anon_vma *anon_vma1,
+		 struct anon_vma *anon_vma2, struct vm_area_struct *vma)
 {
 	/*
 	 * The list_is_singular() test is to avoid merging VMA cloned from
@@ -793,7 +792,7 @@ static inline int is_mergeable_anon_vma(
 	 */
 	if ((!anon_vma1 || !anon_vma2) && (!vma ||
 		list_is_singular(&vma->anon_vma_chain)))
-		return 1;
+		return true;
 	return anon_vma1 == anon_vma2;
 }
 
@@ -808,19 +807,18 @@ static inline int is_mergeable_anon_vma(
  * indices (16TB on ia32) because do_mmap() does not permit mmap's which
  * wrap, nor mmaps which cover the final page at index -1UL.
  */
-static int
+static bool
 can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
-		     struct anon_vma *anon_vma, struct file *file,
-		     pgoff_t vm_pgoff,
-		     struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-		     struct anon_vma_name *anon_name)
+		struct anon_vma *anon_vma, struct file *file,
+		pgoff_t vm_pgoff, struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+		struct anon_vma_name *anon_name)
 {
 	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		if (vma->vm_pgoff == vm_pgoff)
-			return 1;
+			return true;
 	}
-	return 0;
+	return false;
 }
 
 /*
@@ -830,21 +828,20 @@ can_vma_merge_before(struct vm_area_stru
  * We cannot merge two vmas if they have differently assigned (non-NULL)
  * anon_vmas, nor if same anon_vma is assigned but offsets incompatible.
  */
-static int
+static bool
 can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
-		    struct anon_vma *anon_vma, struct file *file,
-		    pgoff_t vm_pgoff,
-		    struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
-		    struct anon_vma_name *anon_name)
+		struct anon_vma *anon_vma, struct file *file,
+		pgoff_t vm_pgoff, struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+		struct anon_vma_name *anon_name)
 {
 	if (is_mergeable_vma(vma, file, vm_flags, vm_userfaultfd_ctx, anon_name) &&
 	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
 		pgoff_t vm_pglen;
 		vm_pglen = vma_pages(vma);
 		if (vma->vm_pgoff + vm_pglen == vm_pgoff)
-			return 1;
+			return true;
 	}
-	return 0;
+	return false;
 }
 
 /*
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch
mm-mmap-vma_merge-use-only-primary-pointers-for-preparing-merge.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch
mm-mmap-vma_merge-use-the-proper-vma-pointers-in-cases-1-and-6.patch
mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-4.patch
mm-mmap-vma_merge-initialize-mid-and-next-in-natural-order.patch
mm-mmap-vma_merge-set-mid-to-null-if-not-applicable.patch
mm-mmap-vma_merge-rename-adj_next-to-adj_start.patch
mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch
mm-mmap-start-distinguishing-if-vma-can-be-removed-in-mergeability-test.patch
mm-mremap-simplify-vma-expansion-again.patch

