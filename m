Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE4DC43333
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AEC464EC0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237990AbhCDA6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354497AbhCDAJY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:09:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E624764F60;
        Thu,  4 Mar 2021 00:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816458;
        bh=S1v8kDnfya0BQkUNYJz3muk6AOWjMTC3Cg3Rg8QZeYE=;
        h=Date:From:To:Subject:From;
        b=1uPzIgvSeyISzaDpjpNs7/Zh2wQ6yoFdIUlUVaWWAGdKthJDLpWLZJ7TlWfO/lWCg
         VFSWOpr0L/6VjG9AKGfLHWdJ/uqa4r8rSnbWAS1chXpr7hZm4sYYgBI/in/cRI6QnX
         AtJWZiMbSnKJ6NKV8EwJr6mAxz1Yu9KEiiYAfY0g=
Date:   Wed, 03 Mar 2021 16:07:37 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  + mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch added
 to -mm tree
Message-ID: <20210304000737.yThLyDlMI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix mpol_misplaced kernel-doc
has been added to the -mm tree.  Its filename is
     mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/mempolicy: fix mpol_misplaced kernel-doc

Sphinx interprets the Return section as a list and complains about it. 
Turn it into a sentence and move it to the end of the kernel-doc to fit
the kernel-doc style.

Link: https://lkml.kernel.org/r/20210225150642.2582252-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    1 +
 mm/mempolicy.c                    |   11 ++++-------
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-mempolicy-fix-mpol_misplaced-kernel-doc
+++ a/Documentation/core-api/mm-api.rst
@@ -92,3 +92,4 @@ More Memory Management Functions
    :export:
 
 .. kernel-doc:: mm/page_alloc.c
+.. kernel-doc:: mm/mempolicy.c
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

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch

