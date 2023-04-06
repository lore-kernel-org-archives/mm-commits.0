Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E830BC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbjDFCpZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbjDFCo7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090F17A81
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F71164217
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1877C433EF;
        Thu,  6 Apr 2023 02:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749097;
        bh=o1RgwKoI36qIw/SM706gYFmNLEEcQ9DoOC6kX4KJWQs=;
        h=Date:To:From:Subject:From;
        b=hQ6TII7ZnOQUO6lZGJhvUBM+ryMKTq2ppp4xB08TdIulCocetej/aBIWg+zy2Nfxi
         7L0Sr9tnreUhlWzzxgYLssGJqowIyIMR0WDZRMOo/KjSAvuFoiF3eC9G4TpuDS1aXR
         voLg1fSxXFkuKrfYLJDkOGzI6KUfD6uNSXzebrzg=
Date:   Wed, 05 Apr 2023 19:44:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch removed from -mm tree
Message-Id: <20230406024456.E1877C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: convert mergeability checks to return bool
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: convert mergeability checks to return bool
Date: Thu, 9 Mar 2023 12:12:56 +0100

The comments already mention returning 'true' so make the code match them.

Link: https://lkml.kernel.org/r/20230309111258.24079-9-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   53 ++++++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-convert-mergeability-checks-to-return-bool
+++ a/mm/mmap.c
@@ -744,10 +744,10 @@ int vma_shrink(struct vma_iterator *vmi,
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
@@ -758,21 +758,20 @@ static inline int is_mergeable_vma(struc
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
@@ -780,7 +779,7 @@ static inline int is_mergeable_anon_vma(
 	 */
 	if ((!anon_vma1 || !anon_vma2) && (!vma ||
 		list_is_singular(&vma->anon_vma_chain)))
-		return 1;
+		return true;
 	return anon_vma1 == anon_vma2;
 }
 
@@ -795,19 +794,18 @@ static inline int is_mergeable_anon_vma(
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
@@ -817,21 +815,20 @@ can_vma_merge_before(struct vm_area_stru
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

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

