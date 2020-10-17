Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0D8C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6168F208E4
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976452;
	bh=f5CCkANMVT19gApMAe7FnKgAv0Hukgr+Bo/TXSkzKMA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SUEvscbRtRqi2AYwKBnO9IdhUpyN8Hc5YlxrTUitXgEsCXfKmsyUc/rptz42zhUri
	 9GEjW/kLkxfAMLVBL2MC8QwMh6p5fLueHOvGIiIabaaGG616uIXBysWz0T9T6Cc1Wc
	 UcczyvqlNyRnMYwp8Icovb1OaCOQKePfl5l/YkQ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439890AbgJQXOM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXOL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:14:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACA1420897;
        Sat, 17 Oct 2020 23:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976449;
        bh=f5CCkANMVT19gApMAe7FnKgAv0Hukgr+Bo/TXSkzKMA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sBegiK50yBBpN0N/fQlPnwRmDjA2MknrG751J2jEsuKDEYkkMmGA3TtDGkgnyc5ZM
         Ynbs7pwYiS3jYtC60BgZB0g7aejI4YRd8UYjJEcuXgmTWGCoYJfQkSFmz1VJMRm+1L
         JzDlXdzgIVscM2UQtIO/SJyU6qtELGV4mjbr0S5Q=
Date:   Sat, 17 Oct 2020 16:14:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, Liam.Howlett@Oracle.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 11/40] mm/mmap: add inline munmap_vma_range() for
 code readability
Message-ID: <20201017231409.Qiho8zkqA%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
