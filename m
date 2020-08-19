Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54243C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 17:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 341C220885
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 17:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597857621;
	bh=R8BIhNZRaFtidcwI18T0vr3UBjVyOdHc1KOh4jtFXb4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=vk2U2qf6XELWm9RZO/BHe5yiG5VNBer6jD46g1/2hwhYZWRbxWyX+mIWFCG6TRdlc
	 h90e23kTJcYuRorI5V3QoPICR48C8DsaSZIWAEGdakXXo2wDRt7SwkTcgZGc6oOJka
	 UWCgW5sKwD9hb17HZYrw7SEywSaNa+pFoJ7rXXOQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgHSRUS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 13:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgHSRUO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 13:20:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BF2F207FF;
        Wed, 19 Aug 2020 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597857613;
        bh=R8BIhNZRaFtidcwI18T0vr3UBjVyOdHc1KOh4jtFXb4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vdcoFmwnVzKJ3d4pBRnnTSQLl3H4rEevwufjD1Da6PFG+cMjh13eWv4kvP/XRJRlE
         j9O7K2Jl3OYmHE/AFWSSZ6v5khZSNLvwVbduExaqEVemde6dW/IQRRBTukNC7NMFxO
         +yeZ2rSuv8BBOD4VzGcK8harKhlFM1ZmBBJ6qW0M=
Date:   Wed, 19 Aug 2020 10:20:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-mmap-add-inline-vma_next-for-readability-of-mmap-code.patch added to -mm
 tree
Message-ID: <20200819172013.Aw0YM4lZ6%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: add inline vma_next() for readability of mmap code
has been added to the -mm tree.  Its filename is
     mm-mmap-add-inline-vma_next-for-readability-of-mmap-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-add-inline-vma_next-for-readability-of-mmap-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-add-inline-vma_next-for-readability-of-mmap-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -560,6 +560,23 @@ static int find_vma_links(struct mm_stru
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
@@ -1131,10 +1148,7 @@ struct vm_area_struct *vma_merge(struct
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
@@ -2640,7 +2654,7 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *next = prev ? prev->vm_next : mm->mmap;
+	struct vm_area_struct *next = vma_next(mm, prev);
 	struct mmu_gather tlb;
 
 	lru_add_drain();
@@ -2839,7 +2853,7 @@ int __do_munmap(struct mm_struct *mm, un
 		if (error)
 			return error;
 	}
-	vma = prev ? prev->vm_next : mm->mmap;
+	vma = vma_next(mm, prev);
 
 	if (unlikely(uf)) {
 		/*
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-mmap-add-inline-vma_next-for-readability-of-mmap-code.patch
mm-mmap-add-inline-munmap_vma_range-for-code-readability.patch

