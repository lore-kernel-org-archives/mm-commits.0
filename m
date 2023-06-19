Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34D5EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjFSXZz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjFSXXw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA7A19A8
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA4EA60F79
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED91C433C0;
        Mon, 19 Jun 2023 23:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216975;
        bh=4ATHBuemcj9ZZ+Q5gvX8x+3bbOcYxGrV4ybWhpCBRjA=;
        h=Date:To:From:Subject:From;
        b=Q7NByjvEJNVVStBmkIMslgXLRYTUuZvuB13yUtc5nNKvGuPPR4NHXNGsNoGnarsOP
         AmbMswW/rHTqc5qjsqp2VAKCkrUYP0SN6OGTxYppPa2IH0lO6X6g3TstbGays8oNZn
         b7o8W9p25S4KN18DfI7LZci4xROEbrICR3FhFZt4=
Date:   Mon, 19 Jun 2023 16:22:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch removed from -mm tree
Message-Id: <20230619232255.4ED91C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: fix regression in userfaultfd_unmap_prep()
has been removed from the -mm tree.  Its filename was
     userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: userfaultfd: fix regression in userfaultfd_unmap_prep()
Date: Wed, 31 May 2023 21:54:02 -0400

Android reported a performance regression in the userfaultfd unmap path. 
A closer inspection on the userfaultfd_unmap_prep() change showed that a
second tree walk would be necessary in the reworked code.

Fix the regression by passing each VMA that will be unmapped through to
the userfaultfd_unmap_prep() function as they are added to the unmap list,
instead of re-walking the tree for the VMA.

Link: https://lkml.kernel.org/r/20230601015402.2819343-1-Liam.Howlett@oracle.com
Fixes: 69dbe6daf104 ("userfaultfd: use maple tree iterator to iterate VMAs")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   39 +++++++++++++-------------------
 include/linux/userfaultfd_k.h |    6 ++--
 mm/mmap.c                     |   31 ++++++++++++-------------
 3 files changed, 35 insertions(+), 41 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-fix-regression-in-userfaultfd_unmap_prep
+++ a/fs/userfaultfd.c
@@ -852,31 +852,26 @@ static bool has_unmap_ctx(struct userfau
 	return false;
 }
 
-int userfaultfd_unmap_prep(struct mm_struct *mm, unsigned long start,
+int userfaultfd_unmap_prep(struct vm_area_struct *vma, unsigned long start,
 			   unsigned long end, struct list_head *unmaps)
 {
-	VMA_ITERATOR(vmi, mm, start);
-	struct vm_area_struct *vma;
+	struct userfaultfd_unmap_ctx *unmap_ctx;
+	struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
 
-	for_each_vma_range(vmi, vma, end) {
-		struct userfaultfd_unmap_ctx *unmap_ctx;
-		struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
-
-		if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_UNMAP) ||
-		    has_unmap_ctx(ctx, unmaps, start, end))
-			continue;
-
-		unmap_ctx = kzalloc(sizeof(*unmap_ctx), GFP_KERNEL);
-		if (!unmap_ctx)
-			return -ENOMEM;
-
-		userfaultfd_ctx_get(ctx);
-		atomic_inc(&ctx->mmap_changing);
-		unmap_ctx->ctx = ctx;
-		unmap_ctx->start = start;
-		unmap_ctx->end = end;
-		list_add_tail(&unmap_ctx->list, unmaps);
-	}
+	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_UNMAP) ||
+	    has_unmap_ctx(ctx, unmaps, start, end))
+		return 0;
+
+	unmap_ctx = kzalloc(sizeof(*unmap_ctx), GFP_KERNEL);
+	if (!unmap_ctx)
+		return -ENOMEM;
+
+	userfaultfd_ctx_get(ctx);
+	atomic_inc(&ctx->mmap_changing);
+	unmap_ctx->ctx = ctx;
+	unmap_ctx->start = start;
+	unmap_ctx->end = end;
+	list_add_tail(&unmap_ctx->list, unmaps);
 
 	return 0;
 }
--- a/include/linux/userfaultfd_k.h~userfaultfd-fix-regression-in-userfaultfd_unmap_prep
+++ a/include/linux/userfaultfd_k.h
@@ -188,8 +188,8 @@ extern bool userfaultfd_remove(struct vm
 			       unsigned long start,
 			       unsigned long end);
 
-extern int userfaultfd_unmap_prep(struct mm_struct *mm, unsigned long start,
-				  unsigned long end, struct list_head *uf);
+extern int userfaultfd_unmap_prep(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, struct list_head *uf);
 extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
@@ -271,7 +271,7 @@ static inline bool userfaultfd_remove(st
 	return true;
 }
 
-static inline int userfaultfd_unmap_prep(struct mm_struct *mm,
+static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 					 unsigned long start, unsigned long end,
 					 struct list_head *uf)
 {
--- a/mm/mmap.c~userfaultfd-fix-regression-in-userfaultfd_unmap_prep
+++ a/mm/mmap.c
@@ -2417,6 +2417,21 @@ do_vmi_align_munmap(struct vma_iterator
 			goto munmap_sidetree_failed;
 
 		count++;
+		if (unlikely(uf)) {
+			/*
+			 * If userfaultfd_unmap_prep returns an error the vmas
+			 * will remain split, but userland will get a
+			 * highly unexpected error anyway. This is no
+			 * different than the case where the first of the two
+			 * __split_vma fails, but we don't undo the first
+			 * split, despite we could. This is unlikely enough
+			 * failure that it's not worth optimizing it for.
+			 */
+			error = userfaultfd_unmap_prep(next, start, end, uf);
+
+			if (error)
+				goto userfaultfd_error;
+		}
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
 		BUG_ON(next->vm_start < start);
 		BUG_ON(next->vm_start > end);
@@ -2429,22 +2444,6 @@ do_vmi_align_munmap(struct vma_iterator
 	if (!next)
 		next = vma_next(vmi);
 
-	if (unlikely(uf)) {
-		/*
-		 * If userfaultfd_unmap_prep returns an error the vmas
-		 * will remain split, but userland will get a
-		 * highly unexpected error anyway. This is no
-		 * different than the case where the first of the two
-		 * __split_vma fails, but we don't undo the first
-		 * split, despite we could. This is unlikely enough
-		 * failure that it's not worth optimizing it for.
-		 */
-		error = userfaultfd_unmap_prep(mm, start, end, uf);
-
-		if (error)
-			goto userfaultfd_error;
-	}
-
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
 	{
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


