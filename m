Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1887BC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjBJAxF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjBJAww (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD6B6D8CF
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BF55B822D1
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3AAC4339B;
        Fri, 10 Feb 2023 00:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990368;
        bh=pt8jNW2INv4+CfjoQMrb2ZfWiI/xGAUxV7qNiqnsn+A=;
        h=Date:To:From:Subject:From;
        b=hyzXKSHxBnvjOTGRUSQxxsGjyASF5FSdA2xbOl6JJFl5yqTf+k6b/L/eFmdcDMMRL
         fkooIv9OTlqDKj5/XnjMCvv2lKf5y5BXWFKmwhKurJcXr7REy130h6G1gAuNrSo5x/
         WrhuI9EJLcBGOfUF9KYjgJ1Dy8dmiwQPWoH+vRFg=
Date:   Thu, 09 Feb 2023 16:52:47 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mlock-convert-mlock-to-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005248.1F3AAC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mlock: convert mlock to vma iterator
has been removed from the -mm tree.  Its filename was
     mlock-convert-mlock-to-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mlock: convert mlock to vma iterator
Date: Fri, 20 Jan 2023 11:26:19 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-19-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   57 +++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

--- a/mm/mlock.c~mlock-convert-mlock-to-vma-iterator
+++ a/mm/mlock.c
@@ -401,8 +401,9 @@ static void mlock_vma_pages_range(struct
  *
  * For vmas that pass the filters, merge/split as appropriate.
  */
-static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
-	unsigned long start, unsigned long end, vm_flags_t newflags)
+static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	       struct vm_area_struct **prev, unsigned long start,
+	       unsigned long end, vm_flags_t newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgoff_t pgoff;
@@ -417,22 +418,22 @@ static int mlock_fixup(struct vm_area_st
 		goto out;
 
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
-	*prev = vma_merge(mm, *prev, start, end, newflags, vma->anon_vma,
-			  vma->vm_file, pgoff, vma_policy(vma),
-			  vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	*prev = vmi_vma_merge(vmi, mm, *prev, start, end, newflags,
+			vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
+			vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 	if (*prev) {
 		vma = *prev;
 		goto success;
 	}
 
 	if (start != vma->vm_start) {
-		ret = split_vma(mm, vma, start, 1);
+		ret = vmi_split_vma(vmi, mm, vma, start, 1);
 		if (ret)
 			goto out;
 	}
 
 	if (end != vma->vm_end) {
-		ret = split_vma(mm, vma, end, 0);
+		ret = vmi_split_vma(vmi, mm, vma, end, 0);
 		if (ret)
 			goto out;
 	}
@@ -471,7 +472,7 @@ static int apply_vma_lock_flags(unsigned
 	unsigned long nstart, end, tmp;
 	struct vm_area_struct *vma, *prev;
 	int error;
-	MA_STATE(mas, &current->mm->mm_mt, start, start);
+	VMA_ITERATOR(vmi, current->mm, start);
 
 	VM_BUG_ON(offset_in_page(start));
 	VM_BUG_ON(len != PAGE_ALIGN(len));
@@ -480,39 +481,37 @@ static int apply_vma_lock_flags(unsigned
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	vma = mas_walk(&mas);
+	vma = vma_iter_load(&vmi);
 	if (!vma)
 		return -ENOMEM;
 
+	prev = vma_prev(&vmi);
 	if (start > vma->vm_start)
 		prev = vma;
-	else
-		prev = mas_prev(&mas, 0);
 
-	for (nstart = start ; ; ) {
-		vm_flags_t newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+	nstart = start;
+	tmp = vma->vm_start;
+	for_each_vma_range(vmi, vma, end) {
+		vm_flags_t newflags;
 
-		newflags |= flags;
+		if (vma->vm_start != tmp)
+			return -ENOMEM;
 
+		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+		newflags |= flags;
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
-		error = mlock_fixup(vma, &prev, nstart, tmp, newflags);
+		error = mlock_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
 		if (error)
 			break;
 		nstart = tmp;
-		if (nstart < prev->vm_end)
-			nstart = prev->vm_end;
-		if (nstart >= end)
-			break;
-
-		vma = find_vma(prev->vm_mm, prev->vm_end);
-		if (!vma || vma->vm_start != nstart) {
-			error = -ENOMEM;
-			break;
-		}
 	}
+
+	if (vma_iter_end(&vmi) < end)
+		return -ENOMEM;
+
 	return error;
 }
 
@@ -658,7 +657,7 @@ SYSCALL_DEFINE2(munlock, unsigned long,
  */
 static int apply_mlockall_flags(int flags)
 {
-	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, current->mm, 0);
 	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
@@ -679,15 +678,15 @@ static int apply_mlockall_flags(int flag
 			to_add |= VM_LOCKONFAULT;
 	}
 
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	for_each_vma(vmi, vma) {
 		vm_flags_t newflags;
 
 		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
 		newflags |= to_add;
 
 		/* Ignore errors */
-		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
-		mas_pause(&mas);
+		mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
+			    newflags);
 		cond_resched();
 	}
 out:
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


