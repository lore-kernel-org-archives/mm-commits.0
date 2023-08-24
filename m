Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA48C727AA
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241313AbjHXXW4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbjHXXWW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3C0CEE
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C9163A67
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DFFC433C7;
        Thu, 24 Aug 2023 23:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919338;
        bh=cnIDC8XWUioWKleCq6bmLmEKttkGH+8IbKRgWmBR4uA=;
        h=Date:To:From:Subject:From;
        b=v+/iXVOd3LjnlOcG/Au726WwJqpXU4lve4eOwdk4nEMwUFUYGHr5OlpHwTAHfel7j
         DD37IDO1QTdDQyMtTGBMXz1HUzRpUeAoFuw9KAAWp3QgJy/X0MGZQ2KlrcwNta/H+B
         bLdMAErYpwWrSVJm3kbWRv47bYj1nnxyCpQd45lw=
Date:   Thu, 24 Aug 2023 16:22:17 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-add-documentation-for-vma_kernel_pagesize.patch removed from -mm tree
Message-Id: <20230824232218.08DFFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: add documentation for vma_kernel_pagesize()
has been removed from the -mm tree.  Its filename was
     hugetlb-add-documentation-for-vma_kernel_pagesize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: add documentation for vma_kernel_pagesize()
Date: Tue, 22 Aug 2023 18:24:59 +0100

This is an exported symbol, so it should have kernel-doc.  Update it to
mention folios, and point out that they might be larger than the supported
page size for this VMA.

Link: https://lkml.kernel.org/r/20230822172459.4190699-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-add-documentation-for-vma_kernel_pagesize
+++ a/mm/hugetlb.c
@@ -968,9 +968,14 @@ pgoff_t linear_hugepage_index(struct vm_
 }
 EXPORT_SYMBOL_GPL(linear_hugepage_index);
 
-/*
- * Return the size of the pages allocated when backing a VMA. In the majority
- * cases this will be same size as used by the page table entries.
+/**
+ * vma_kernel_pagesize - Page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * Folios in this VMA will be aligned to, and at least the size of the
+ * number of bytes returned by this function.
+ *
+ * Return: The default size of the folios allocated when backing a VMA.
  */
 unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


