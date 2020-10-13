Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053A2C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5527208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633239;
	bh=1Z4hsXopJUWYi/EpG1a8dZC8svS5qxv0BNVVDj+5dNI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=feDAgEXY9009IkxZtKl5+va23Q+F1Xcbv/H3gw+dzGA8A8X1gaWXiBEWg2rrYS8PK
	 uK17ruU/1UAMnIXrfzyLE2zI7UAYYsFUD7qkNF/Dz1I+b17HttHrPLQtGotRNCZ8Sz
	 EFbHZ3RwQNA5FuDV7MjBD7A90usjnJF0CVLWUnps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388135AbgJMXx7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387743AbgJMXx7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6314921D7B;
        Tue, 13 Oct 2020 23:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633238;
        bh=1Z4hsXopJUWYi/EpG1a8dZC8svS5qxv0BNVVDj+5dNI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HECCHmTYuVs0ztfJ5/L6BdY/ld8Cnpd0LSO8budohSb9GhHMY6relR3af7I7tClgd
         lWvbMJ16e8s6b95tIsiBsy5X4sbfWTJO1nqn8zzdeFqladfptYz/VstYb5NPxIjY+B
         rPLj+QqwZWVu0/1WfoaDT/F9GU4LTmxC8c/NYtKw=
Date:   Tue, 13 Oct 2020 16:53:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 102/181] mm/mmap: leave adjust_next as virtual
 address instead of page frame number
Message-ID: <20201013235357.axSLwNkGD%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: leave adjust_next as virtual address instead of page frame number

Instead of converting adjust_next between bytes and pages number, let's
just store the virtual address into adjust_next.

Also, this patch fixes one typo in the comment of vma_adjust_trans_huge().

[vbabka@suse.cz: changelog tweak]
Link: http://lkml.kernel.org/r/20200828081031.11306-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/mmap.c        |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number
+++ a/mm/huge_memory.c
@@ -2306,13 +2306,13 @@ void vma_adjust_trans_huge(struct vm_are
 
 	/*
 	 * If we're also updating the vma->vm_next->vm_start, if the new
-	 * vm_next->vm_start isn't page aligned and it could previously
+	 * vm_next->vm_start isn't hpage aligned and it could previously
 	 * contain an hugepage: check if we need to split an huge pmd.
 	 */
 	if (adjust_next > 0) {
 		struct vm_area_struct *next = vma->vm_next;
 		unsigned long nstart = next->vm_start;
-		nstart += adjust_next << PAGE_SHIFT;
+		nstart += adjust_next;
 		if (nstart & ~HPAGE_PMD_MASK &&
 		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
 		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
--- a/mm/mmap.c~mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number
+++ a/mm/mmap.c
@@ -758,7 +758,7 @@ int __vma_adjust(struct vm_area_struct *
 			 * vma expands, overlapping part of the next:
 			 * mprotect case 5 shifting the boundary up.
 			 */
-			adjust_next = (end - next->vm_start) >> PAGE_SHIFT;
+			adjust_next = (end - next->vm_start);
 			exporter = next;
 			importer = vma;
 			VM_WARN_ON(expand != importer);
@@ -768,7 +768,7 @@ int __vma_adjust(struct vm_area_struct *
 			 * split_vma inserting another: so it must be
 			 * mprotect case 4 shifting the boundary down.
 			 */
-			adjust_next = -((vma->vm_end - end) >> PAGE_SHIFT);
+			adjust_next = -(vma->vm_end - end);
 			exporter = vma;
 			importer = next;
 			VM_WARN_ON(expand != importer);
@@ -840,8 +840,8 @@ again:
 	}
 	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
-		next->vm_start += adjust_next << PAGE_SHIFT;
-		next->vm_pgoff += adjust_next;
+		next->vm_start += adjust_next;
+		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
 	}
 
 	if (root) {
_
