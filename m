Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054F6C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1889610CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhICVCI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235133AbhICVCH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6999B610C8;
        Fri,  3 Sep 2021 21:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702867;
        bh=J8a5AWR4a4jy/X8Vt9UCp1bG7D2+cCOJsvm2o63KvC8=;
        h=Date:From:To:Subject:From;
        b=u/iy3wCUpYRKHKcFDjFFP/YDFav7uuLOxct47GQjCPao+gfBcDYyxCxnO5VqHVbtY
         wipyQnBi8JMtyCanWid51XGoo8iZP4mOZV1BmIjqQ+aF+RXEqFyoeqyRpPEGE4Fle8
         wXZ++/1SKYJ8AbLeUYqNU2iisI0ABTDl23NX1mVM=
Date:   Fri, 03 Sep 2021 14:01:07 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch
 removed from -mm tree
Message-ID: <20210903210107.bmBz0N-et%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: use readable NUMA_NO_NODE macro instead of magic number
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/mempolicy: use readable NUMA_NO_NODE macro instead of magic number

The caller of mpol_misplaced() already use NUMA_NO_NODE to check whether
current page node is misplaced, thus using NUMA_NO_NODE in
mpol_misplaced() instead of magic number is more readable.

Link: https://lkml.kernel.org/r/1b77c0ce21183fa86f4db250b115cf5e27396528.1627558356.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer
+++ a/mm/mempolicy.c
@@ -2425,8 +2425,8 @@ static void sp_free(struct sp_node *n)
  * node id.  Policy determination "mimics" alloc_page_vma().
  * Called from fault path where we know the vma and faulting address.
  *
- * Return: -1 if the page is in a node that is valid for this policy, or a
- * suitable node ID to allocate a replacement page from.
+ * Return: NUMA_NO_NODE if the page is in a node that is valid for this
+ * policy, or a suitable node ID to allocate a replacement page from.
  */
 int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long addr)
 {
@@ -2437,7 +2437,7 @@ int mpol_misplaced(struct page *page, st
 	int thiscpu = raw_smp_processor_id();
 	int thisnid = cpu_to_node(thiscpu);
 	int polnid = NUMA_NO_NODE;
-	int ret = -1;
+	int ret = NUMA_NO_NODE;
 
 	pol = get_vma_policy(vma, addr);
 	if (!(pol->flags & MPOL_F_MOF))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch
mm-migrate-introduce-a-local-variable-to-get-the-number-of-pages.patch
mm-migrate-fix-the-incorrect-function-name-in-comments.patch
mm-migrate-change-to-use-bool-type-for-page_was_mapped.patch

