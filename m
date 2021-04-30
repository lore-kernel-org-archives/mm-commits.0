Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63741C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F13B614A5
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhD3GCQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhD3GCP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0E9B6148E;
        Fri, 30 Apr 2021 06:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762488;
        bh=4j4lBKBZt0buKrk7MSPDZbKWTBhCp2xR2AT/x8tS5BA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oTpO9q+ZBwBkKXl2UFhSph+RUFeeH1m1+Fs7wR8SS6maEduPDUiol3TIu+rgxyjYq
         Ywyd1iup4kT8GCAEgV1EZtAbz/bJqo6kf4WFtSEUG6Hb+HfPBGPXINaXOZeJKBdteM
         qqfAjVemiDaRTZNNdqEOK9w4ELioj7tiR2xAJ4A4=
Date:   Thu, 29 Apr 2021 23:01:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 161/178] mm/mempolicy: fix mpol_misplaced
 kernel-doc
Message-ID: <20210430060127.8S5CgNPSu%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
