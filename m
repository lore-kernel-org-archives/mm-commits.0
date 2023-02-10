Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1574DC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjBJAxA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjBJAws (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523FE6ADC6
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A1D4FCE270F
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330AEC433EF;
        Fri, 10 Feb 2023 00:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990365;
        bh=71yWEsrUxcFRPEf3LGs/6uQgrqXzMem8n5XvTL3dQHk=;
        h=Date:To:From:Subject:From;
        b=JPtH13o37+8RmUoFAWx5koUFv0eMMzlyOXJx2Oh+b7d8+OTtgnIjrckneD7Y7szmm
         ++I1kQvWhQv4CKKwSV3ED1rBFDlHYm7CGQHLD5538+gFfQVlpS+CGC+O+IzQYesDGd
         kSh0eI6VADoiiq0Huo9j43Vn7YydK1k9sdQglUJQ=
Date:   Thu, 09 Feb 2023 16:52:44 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-use-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005245.330AEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: use vma iterator
has been removed from the -mm tree.  Its filename was
     userfaultfd-use-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: userfaultfd: use vma iterator
Date: Fri, 20 Jan 2023 11:26:17 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-17-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   87 +++++++++++++++++----------------------------
 1 file changed, 33 insertions(+), 54 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-use-vma-iterator
+++ a/fs/userfaultfd.c
@@ -883,7 +883,7 @@ static int userfaultfd_release(struct in
 	/* len == 0 means wake all */
 	struct userfaultfd_wake_range range = { .len = 0, };
 	unsigned long new_flags;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	WRITE_ONCE(ctx->released, true);
 
@@ -900,7 +900,7 @@ static int userfaultfd_release(struct in
 	 */
 	mmap_write_lock(mm);
 	prev = NULL;
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	for_each_vma(vmi, vma) {
 		cond_resched();
 		BUG_ON(!!vma->vm_userfaultfd_ctx.ctx ^
 		       !!(vma->vm_flags & __VM_UFFD_FLAGS));
@@ -909,13 +909,12 @@ static int userfaultfd_release(struct in
 			continue;
 		}
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
-		prev = vma_merge(mm, prev, vma->vm_start, vma->vm_end,
+		prev = vmi_vma_merge(&vmi, mm, prev, vma->vm_start, vma->vm_end,
 				 new_flags, vma->anon_vma,
 				 vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
 		if (prev) {
-			mas_pause(&mas);
 			vma = prev;
 		} else {
 			prev = vma;
@@ -1302,7 +1301,7 @@ static int userfaultfd_register(struct u
 	bool found;
 	bool basic_ioctls;
 	unsigned long start, end, vma_end;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	struct vma_iterator vmi;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
 
@@ -1344,17 +1343,13 @@ static int userfaultfd_register(struct u
 	if (!mmget_not_zero(mm))
 		goto out;
 
+	ret = -EINVAL;
 	mmap_write_lock(mm);
-	mas_set(&mas, start);
-	vma = mas_find(&mas, ULONG_MAX);
+	vma_iter_init(&vmi, mm, start);
+	vma = vma_find(&vmi, end);
 	if (!vma)
 		goto out_unlock;
 
-	/* check that there's at least one vma in the range */
-	ret = -EINVAL;
-	if (vma->vm_start >= end)
-		goto out_unlock;
-
 	/*
 	 * If the first vma contains huge pages, make sure start address
 	 * is aligned to huge page size.
@@ -1371,7 +1366,8 @@ static int userfaultfd_register(struct u
 	 */
 	found = false;
 	basic_ioctls = false;
-	for (cur = vma; cur; cur = mas_next(&mas, end - 1)) {
+	cur = vma;
+	do {
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
@@ -1428,16 +1424,14 @@ static int userfaultfd_register(struct u
 			basic_ioctls = true;
 
 		found = true;
-	}
+	} for_each_vma_range(vmi, cur, end);
 	BUG_ON(!found);
 
-	mas_set(&mas, start);
-	prev = mas_prev(&mas, 0);
-	if (prev != vma)
-		mas_next(&mas, ULONG_MAX);
+	vma_iter_set(&vmi, start);
+	prev = vma_prev(&vmi);
 
 	ret = 0;
-	do {
+	for_each_vma_range(vmi, vma, end) {
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vm_flags));
@@ -1458,30 +1452,25 @@ static int userfaultfd_register(struct u
 		vma_end = min(end, vma->vm_end);
 
 		new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;
-		prev = vma_merge(mm, prev, start, vma_end, new_flags,
+		prev = vmi_vma_merge(&vmi, mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 ((struct vm_userfaultfd_ctx){ ctx }),
 				 anon_vma_name(vma));
 		if (prev) {
 			/* vma_merge() invalidated the mas */
-			mas_pause(&mas);
 			vma = prev;
 			goto next;
 		}
 		if (vma->vm_start < start) {
-			ret = split_vma(mm, vma, start, 1);
+			ret = vmi_split_vma(&vmi, mm, vma, start, 1);
 			if (ret)
 				break;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
 		}
 		if (vma->vm_end > end) {
-			ret = split_vma(mm, vma, end, 0);
+			ret = vmi_split_vma(&vmi, mm, vma, end, 0);
 			if (ret)
 				break;
-			/* split_vma() invalidated the mas */
-			mas_pause(&mas);
 		}
 	next:
 		/*
@@ -1498,8 +1487,8 @@ static int userfaultfd_register(struct u
 	skip:
 		prev = vma;
 		start = vma->vm_end;
-		vma = mas_next(&mas, end - 1);
-	} while (vma);
+	}
+
 out_unlock:
 	mmap_write_unlock(mm);
 	mmput(mm);
@@ -1543,7 +1532,7 @@ static int userfaultfd_unregister(struct
 	bool found;
 	unsigned long start, end, vma_end;
 	const void __user *buf = (void __user *)arg;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	struct vma_iterator vmi;
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
@@ -1562,14 +1551,10 @@ static int userfaultfd_unregister(struct
 		goto out;
 
 	mmap_write_lock(mm);
-	mas_set(&mas, start);
-	vma = mas_find(&mas, ULONG_MAX);
-	if (!vma)
-		goto out_unlock;
-
-	/* check that there's at least one vma in the range */
 	ret = -EINVAL;
-	if (vma->vm_start >= end)
+	vma_iter_init(&vmi, mm, start);
+	vma = vma_find(&vmi, end);
+	if (!vma)
 		goto out_unlock;
 
 	/*
@@ -1587,8 +1572,8 @@ static int userfaultfd_unregister(struct
 	 * Search for not compatible vmas.
 	 */
 	found = false;
-	ret = -EINVAL;
-	for (cur = vma; cur; cur = mas_next(&mas, end - 1)) {
+	cur = vma;
+	do {
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
@@ -1605,16 +1590,13 @@ static int userfaultfd_unregister(struct
 			goto out_unlock;
 
 		found = true;
-	}
+	} for_each_vma_range(vmi, cur, end);
 	BUG_ON(!found);
 
-	mas_set(&mas, start);
-	prev = mas_prev(&mas, 0);
-	if (prev != vma)
-		mas_next(&mas, ULONG_MAX);
-
+	vma_iter_set(&vmi, start);
+	prev = vma_prev(&vmi);
 	ret = 0;
-	do {
+	for_each_vma_range(vmi, vma, end) {
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vma->vm_flags));
@@ -1650,26 +1632,23 @@ static int userfaultfd_unregister(struct
 			uffd_wp_range(mm, vma, start, vma_end - start, false);
 
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
-		prev = vma_merge(mm, prev, start, vma_end, new_flags,
+		prev = vmi_vma_merge(&vmi, mm, prev, start, vma_end, new_flags,
 				 vma->anon_vma, vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
 		if (prev) {
 			vma = prev;
-			mas_pause(&mas);
 			goto next;
 		}
 		if (vma->vm_start < start) {
-			ret = split_vma(mm, vma, start, 1);
+			ret = vmi_split_vma(&vmi, mm, vma, start, 1);
 			if (ret)
 				break;
-			mas_pause(&mas);
 		}
 		if (vma->vm_end > end) {
-			ret = split_vma(mm, vma, end, 0);
+			ret = vmi_split_vma(&vmi, mm, vma, end, 0);
 			if (ret)
 				break;
-			mas_pause(&mas);
 		}
 	next:
 		/*
@@ -1683,8 +1662,8 @@ static int userfaultfd_unregister(struct
 	skip:
 		prev = vma;
 		start = vma->vm_end;
-		vma = mas_next(&mas, end - 1);
-	} while (vma);
+	}
+
 out_unlock:
 	mmap_write_unlock(mm);
 	mmput(mm);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


