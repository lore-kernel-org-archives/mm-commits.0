Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3382C11F68
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA15761D11
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhF2ClT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231680AbhF2ClS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB48A61D0D;
        Tue, 29 Jun 2021 02:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934331;
        bh=kie6ln6rbUKFCxnQgtz3OZ/bbuMl4xeLT/3GaKd8GRM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tfP/mAZo0TPjKFQArc2NaKXpvJZOO4DY/LwGHaw9ZOZRUV3d1S4Ltv76oyieyjJKo
         A37JdEXJEcVsuQxdcS4DOKv62/E9/gyMHvCHrLwv7EAjMiew7ToL7u68jX8ALPZxwY
         4QQxCnbVarKdSiapwHaT3TV/K5OhiEolXk0Ybn1Q=
Date:   Mon, 28 Jun 2021 19:38:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davem@davemloft.net, david@redhat.com,
        dbueso@suse.de, geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 105/192] mm: add vma_lookup(), update
 find_vma_intersection() comments
Message-ID: <20210629023850.mVz51okZB%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm: add vma_lookup(), update find_vma_intersection() comments

Patch series "mm: Add vma_lookup()", v2.

Many places in the kernel use find_vma() to get a vma and then check the
start address of the vma to ensure the next vma was not returned.

Other places use the find_vma_intersection() call with add, addr + 1 as
the range; looking for just the vma at a specific address.

The third use of find_vma() is by developers who do not know that the
function starts searching at the provided address upwards for the next
vma.  This results in a bug that is often overlooked for a long time.

Adding the new vma_lookup() function will allow for cleaner code by
removing the find_vma() calls which check limits, making
find_vma_intersection() calls of a single address to be shorter, and
potentially reduce the incorrect uses of find_vma().


This patch (of 22):

Many places in the kernel use find_vma() to get a vma and then check the
start address of the vma to ensure the next vma was not returned.

Other places use the find_vma_intersection() call with add, addr + 1 as
the range; looking for just the vma at a specific address.

The third use of find_vma() is by developers who do not know that the
function starts searching at the provided address upwards for the next
vma.  This results in a bug that is often overlooked for a long time.

Adding the new vma_lookup() function will allow for cleaner code by
removing the find_vma() calls which check limits, making
find_vma_intersection() calls of a single address to be shorter, and
potentially reduce the incorrect uses of find_vma().

Also change find_vma_intersection() comments and declaration to be of the
correct length and add kernel documentation style comment.

Link: https://lkml.kernel.org/r/20210521174745.2219620-1-Liam.Howlett@Oracle.com
Link: https://lkml.kernel.org/r/20210521174745.2219620-2-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-add-vma_lookup-update-find_vma_intersection-comments
+++ a/include/linux/mm.h
@@ -2676,17 +2676,45 @@ extern struct vm_area_struct * find_vma(
 extern struct vm_area_struct * find_vma_prev(struct mm_struct * mm, unsigned long addr,
 					     struct vm_area_struct **pprev);
 
-/* Look up the first VMA which intersects the interval start_addr..end_addr-1,
-   NULL if none.  Assume start_addr < end_addr. */
-static inline struct vm_area_struct * find_vma_intersection(struct mm_struct * mm, unsigned long start_addr, unsigned long end_addr)
+/**
+ * find_vma_intersection() - Look up the first VMA which intersects the interval
+ * @mm: The process address space.
+ * @start_addr: The inclusive start user address.
+ * @end_addr: The exclusive end user address.
+ *
+ * Returns: The first VMA within the provided range, %NULL otherwise.  Assumes
+ * start_addr < end_addr.
+ */
+static inline
+struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
+					     unsigned long start_addr,
+					     unsigned long end_addr)
 {
-	struct vm_area_struct * vma = find_vma(mm,start_addr);
+	struct vm_area_struct *vma = find_vma(mm, start_addr);
 
 	if (vma && end_addr <= vma->vm_start)
 		vma = NULL;
 	return vma;
 }
 
+/**
+ * vma_lookup() - Find a VMA at a specific address
+ * @mm: The process address space.
+ * @addr: The user address.
+ *
+ * Return: The vm_area_struct at the given address, %NULL otherwise.
+ */
+static inline
+struct vm_area_struct *vma_lookup(struct mm_struct *mm, unsigned long addr)
+{
+	struct vm_area_struct *vma = find_vma(mm, addr);
+
+	if (vma && addr < vma->vm_start)
+		vma = NULL;
+
+	return vma;
+}
+
 static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
 {
 	unsigned long vm_start = vma->vm_start;
_
