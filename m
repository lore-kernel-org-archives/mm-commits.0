Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C41C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC8AB60C3D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhGFTPD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231886AbhGFTPC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8248461107;
        Tue,  6 Jul 2021 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598742;
        bh=R4xvVi2u6PLnM3MenX7/h+sRkA3AISYUJbvXFbKjj+0=;
        h=Date:From:To:Subject:From;
        b=GGA1bfsveOreAX/MfRMyo8dO8s4Z54YKyH1bMhiJZ6YQpbzK1nHPF0jpscunTILD1
         ESBEUq7LCkXYvsmVT8Xop16T83VSC1qLYYNPVjyyKUJH8nNMYZVr7HEOvbZrWbS885
         PMy8VXv7aqYBfC/76dnVx6rOoE9dPC/YXG1cu+Zc=
Date:   Tue, 06 Jul 2021 12:12:22 -0700
From:   akpm@linux-foundation.org
To:     davem@davemloft.net, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-add-vma_lookup-update-find_vma_intersection-comments.patch removed from
 -mm tree
Message-ID: <20210706191222.xORkGmVkW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add vma_lookup(), update find_vma_intersection() comments
has been removed from the -mm tree.  Its filename was
     mm-add-vma_lookup-update-find_vma_intersection-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from liam.howlett@oracle.com are


