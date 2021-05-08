Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21D2C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93A2561402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWqO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWqM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AE15613C5;
        Sat,  8 May 2021 22:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513910;
        bh=0Ctf+6ewKKodo68Wtk2tt/inXeVlawvBJk000z9X0rY=;
        h=Date:From:To:Subject:From;
        b=Oeq1+n1qgBlBeF7T1tygdgJy9m76PCF20w/03FMfPQNvIfNmYl8SmyyQO7M5F2pM1
         EaswMeR8Y5oQLfr1SiTH9AdeKiz2TBwT6CDR0TwOVxBvQX/hPYBh2uDseVD1dTr05o
         v8Y7i4UsvHgQoPuIj7FyCa0X1jP00MCpiKL78aJo=
Date:   Sat, 08 May 2021 15:45:10 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  [merged] mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch
 removed from -mm tree
Message-ID: <20210508224510.JxRiyYv10%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix mpol_misplaced kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/mempolicy: fix mpol_misplaced kernel-doc

Sphinx interprets the Return section as a list and complains about it. 
Turn it into a sentence and move it to the end of the kernel-doc to fit
the kernel-doc style.

Link: https://lkml.kernel.org/r/20210225150642.2582252-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    1 +
 mm/mempolicy.c                    |   11 ++++-------
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-mempolicy-fix-mpol_misplaced-kernel-doc
+++ a/Documentation/core-api/mm-api.rst
@@ -92,6 +92,7 @@ More Memory Management Functions
    :export:
 
 .. kernel-doc:: mm/page_alloc.c
+.. kernel-doc:: mm/mempolicy.c
 .. kernel-doc:: include/linux/mm_types.h
    :internal:
 .. kernel-doc:: include/linux/mm.h
--- a/mm/mempolicy.c~mm-mempolicy-fix-mpol_misplaced-kernel-doc
+++ a/mm/mempolicy.c
@@ -2448,14 +2448,11 @@ static void sp_free(struct sp_node *n)
  * @addr: virtual address where page mapped
  *
  * Lookup current policy node id for vma,addr and "compare to" page's
- * node id.
- *
- * Returns:
- *	-1	- not misplaced, page is in the right node
- *	node	- node id where the page should be
- *
- * Policy determination "mimics" alloc_page_vma().
+ * node id.  Policy determination "mimics" alloc_page_vma().
  * Called from fault path where we know the vma and faulting address.
+ *
+ * Return: -1 if the page is in a node that is valid for this policy, or a
+ * suitable node ID to allocate a replacement page from.
  */
 int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long addr)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


