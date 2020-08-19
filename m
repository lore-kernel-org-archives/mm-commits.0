Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB766C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 17:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98F0C20885
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597857604;
	bh=DGe2d04oshtAvK1a3gkN4AM21JT76rbmiXWAw9CL//0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=F4mICqYIJjvXFRWib7UnOs99L8LpHFalY7EMkShpEJtUANOxnzfwP8ndUQDhMm8Hx
	 5738iFRqm7FBER8EZbATdRNvwBCSo4P6GIjht7Vt2GQT/hIR9btdNn/s9LlHEFqPUj
	 HaOGmu/hJ+kXwmbVgzKdR5fna7xn59lin1Q5UVAQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHSRUE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 13:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgHSRUD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 13:20:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D56207FF;
        Wed, 19 Aug 2020 17:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597857602;
        bh=DGe2d04oshtAvK1a3gkN4AM21JT76rbmiXWAw9CL//0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TXpFpkQeXN0L/AnwzXSJ12SWk7AfANcGeSBv2ggh4NQHc1fAA/F1nZl811HeXf0jS
         69q4JDIfj92cP5vCrT5KVp5HKc/AkUrwArhmBzMRN1mvbX03SteyxAYfCbJPq10xWf
         MJQfq/gP5OpTlD6pcvSiib5TnNgvpgnl+czseQOw=
Date:   Wed, 19 Aug 2020 10:20:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-mmap-add-inline-munmap_vma_range-for-code-readability.patch added to -mm
 tree
Message-ID: <20200819172002.s6cwAp-13%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: add inline munmap_vma_range() for code readability
has been added to the -mm tree.  Its filename is
     mm-mmap-add-inline-munmap_vma_range-for-code-readability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-add-inline-munmap_vma_range-for-code-readability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-add-inline-munmap_vma_range-for-code-readability.patch

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
Subject: mm/mmap: add inline munmap_vma_range() for code readability

There are two locations that have a block of code for munmapping a vma
range.  Change those two locations to use a function and add meaningful
comments about what happens to the arguments, which was unclear in the
previous code.

Link: http://lkml.kernel.org/r/20200818154707.2515169-2-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

--- a/mm/mmap.c~mm-mmap-add-inline-munmap_vma_range-for-code-readability
+++ a/mm/mmap.c
@@ -577,6 +577,33 @@ static inline struct vm_area_struct *vma
 
 	return vma->vm_next;
 }
+
+/*
+ * munmap_vma_range() - munmap VMAs that overlap a range.
+ * @mm: The mm struct
+ * @start: The start of the range.
+ * @len: The length of the range.
+ * @pprev: pointer to the pointer that will be set to previous vm_area_struct
+ * @rb_link: the rb_node
+ * @rb_parent: the parent rb_node
+ *
+ * Find all the vm_area_struct that overlap from @start to
+ * @end and munmap them.  Set @pprev to the previous vm_area_struct.
+ *
+ * Returns: -ENOMEM on munmap failure or 0 on success.
+ */
+static inline int
+munmap_vma_range(struct mm_struct *mm, unsigned long start, unsigned long len,
+		 struct vm_area_struct **pprev, struct rb_node ***link,
+		 struct rb_node **parent, struct list_head *uf)
+{
+
+	while (find_vma_links(mm, start, start + len, pprev, link, parent))
+		if (do_munmap(mm, start, len, uf))
+			return -ENOMEM;
+
+	return 0;
+}
 static unsigned long count_vma_pages_range(struct mm_struct *mm,
 		unsigned long addr, unsigned long end)
 {
@@ -1724,13 +1751,9 @@ unsigned long mmap_region(struct file *f
 			return -ENOMEM;
 	}
 
-	/* Clear old maps */
-	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
-			      &rb_parent)) {
-		if (do_munmap(mm, addr, len, uf))
-			return -ENOMEM;
-	}
-
+	/* Clear old maps, set up prev, rb_link, rb_parent, and uf */
+	if (munmap_vma_range(mm, addr, len, &prev, &rb_link, &rb_parent, uf))
+		return -ENOMEM;
 	/*
 	 * Private writable mapping: check memory availability
 	 */
@@ -3071,14 +3094,9 @@ static int do_brk_flags(unsigned long ad
 	if (error)
 		return error;
 
-	/*
-	 * Clear old maps.  this also does some error checking for us
-	 */
-	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
-			      &rb_parent)) {
-		if (do_munmap(mm, addr, len, uf))
-			return -ENOMEM;
-	}
+	/* Clear old maps, set up prev, rb_link, rb_parent, and uf */
+	if (munmap_vma_range(mm, addr, len, &prev, &rb_link, &rb_parent, uf))
+		return -ENOMEM;
 
 	/* Check against address space limits *after* clearing old maps... */
 	if (!may_expand_vm(mm, flags, len >> PAGE_SHIFT))
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-mmap-add-inline-vma_next-for-readability-of-mmap-code.patch
mm-mmap-add-inline-munmap_vma_range-for-code-readability.patch

