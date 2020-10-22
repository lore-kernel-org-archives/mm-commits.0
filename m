Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8B0C388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 190C6223BF
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408180;
	bh=0kbpLjxBEQI3/fl3B4pU09SmKOqsCPDRuOwaQGqsZRI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sH02SOb5FeJiUh/cpA4QM9y2YgztUnyZtIVr/qLEZPP6a0vIaVDW/O8N1E2WSpIa9
	 SSWSEiex+rAX2rVUDdD9FY6UxG/V1ls8WS0k9flXrdLvAE+OMVJaE98x5Bvk3O8676
	 nn2XbMEHh8K/u3LKR+2efityduydhu0lnevWZpnc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373246AbgJVXJj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF8CA20756;
        Thu, 22 Oct 2020 23:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408177;
        bh=0kbpLjxBEQI3/fl3B4pU09SmKOqsCPDRuOwaQGqsZRI=;
        h=Date:From:To:Subject:From;
        b=1zFKNJrzFL2Z516myMwvvOCUrC3MRwBkihj+MC56WW/G45ETS+2C1CCI1PTBSk6Rl
         kaQXFOGOdnEKXvepG3T9cBmeAFbKh7kD2zhwX9eijl64IB++6STqkiiaYgqtOLMyIW
         b0XwHJrbiRxUh1tee7ivaqFvJL9FFRimRhuMbiMw=
Date:   Thu, 22 Oct 2020 16:09:36 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mmap-add-inline-munmap_vma_range-for-code-readability.patch removed from
 -mm tree
Message-ID: <20201022230936.NvsGV4dC6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: add inline munmap_vma_range() for code readability
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-inline-munmap_vma_range-for-code-readability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -575,6 +575,33 @@ static inline struct vm_area_struct *vma
 
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
@@ -1721,13 +1748,9 @@ unsigned long mmap_region(struct file *f
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
@@ -3063,14 +3086,9 @@ static int do_brk_flags(unsigned long ad
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


