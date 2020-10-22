Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10905C388F7
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3AAC223BF
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408175;
	bh=sEp+u17iM1dfrPzr4m3p5anIFf6b4eg8gSNNdeHrtNQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=A1sVd6qw+r8u61ckQ5obWI/w32M0ATtg5P7cAh5995IAq4gOLd5SxWzaPekBT+b3b
	 QTALQ27wwlzf/1sMXJ4z9LuAkNNt7hH8ZW/K1xjrULTnf2zeDLB+u4POn3gkZCReCk
	 ELB518DSbC4vcCItn3XfJPBc2Ij4YDQPpQ/kCQrs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373244AbgJVXJf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C05E820756;
        Thu, 22 Oct 2020 23:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408174;
        bh=sEp+u17iM1dfrPzr4m3p5anIFf6b4eg8gSNNdeHrtNQ=;
        h=Date:From:To:Subject:From;
        b=2NMD4tg/85APa9BMccnWQcW2ymxYohwwldTKfCm07ulRoq5EiMAA5oH0gMKBr4tWD
         X8kOu0lXrW3r4nvTuWtvYJ0/ahkhyRW3TuD+s/F+2aNcZq1dp20UYTEdSBVIA3hFDD
         XNxiz4gXEPG7CFrWmwG/Zgf7NDOb82I+QhoX2G9g=
Date:   Thu, 22 Oct 2020 16:09:33 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mmap-add-inline-vma_next-for-readability-of-mmap-code.patch removed from
 -mm tree
Message-ID: <20201022230933.x9vGCayQU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: add inline vma_next() for readability of mmap code
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-inline-vma_next-for-readability-of-mmap-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: add inline vma_next() for readability of mmap code

There are three places that the next vma is required which uses the same
block of code.  Replace the block with a function and add comments on what
happens in the case where NULL is encountered.

Link: http://lkml.kernel.org/r/20200818154707.2515169-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/mm/mmap.c~mm-mmap-add-inline-vma_next-for-readability-of-mmap-code
+++ a/mm/mmap.c
@@ -558,6 +558,23 @@ static int find_vma_links(struct mm_stru
 	return 0;
 }
 
+/*
+ * vma_next() - Get the next VMA.
+ * @mm: The mm_struct.
+ * @vma: The current vma.
+ *
+ * If @vma is NULL, return the first vma in the mm.
+ *
+ * Returns: The next VMA after @vma.
+ */
+static inline struct vm_area_struct *vma_next(struct mm_struct *mm,
+					 struct vm_area_struct *vma)
+{
+	if (!vma)
+		return mm->mmap;
+
+	return vma->vm_next;
+}
 static unsigned long count_vma_pages_range(struct mm_struct *mm,
 		unsigned long addr, unsigned long end)
 {
@@ -1128,10 +1145,7 @@ struct vm_area_struct *vma_merge(struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
-	if (prev)
-		next = prev->vm_next;
-	else
-		next = mm->mmap;
+	next = vma_next(mm, prev);
 	area = next;
 	if (area && area->vm_end == end)		/* cases 6, 7, 8 */
 		next = next->vm_next;
@@ -2632,7 +2646,7 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *next = prev ? prev->vm_next : mm->mmap;
+	struct vm_area_struct *next = vma_next(mm, prev);
 	struct mmu_gather tlb;
 
 	lru_add_drain();
@@ -2831,7 +2845,7 @@ int __do_munmap(struct mm_struct *mm, un
 		if (error)
 			return error;
 	}
-	vma = prev ? prev->vm_next : mm->mmap;
+	vma = vma_next(mm, prev);
 
 	if (unlikely(uf)) {
 		/*
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


