Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BD0C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8984360F12
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347852AbhIBWBD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347662AbhIBWBC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD5B6056B;
        Thu,  2 Sep 2021 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620003;
        bh=2579X2D7OHiIG+0TmC9k9ahkcd8x014K1suvwG08ANs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ha3chfdsKfvGchgc3itt7I2a5ZyvCCBagrGm6zf5/FYXjqMywOb0t170dxx+h1wp2
         I/cVRxcgwubsA0Z5vnRlXswSFxJSMVdou5DDIjam2KQp2lkM5zLWpXXcAQCVO/asKp
         FR/MEViDEhPSiIDu/WBMp5FrtR97ZiG7xh/lX5sk=
Date:   Thu, 02 Sep 2021 15:00:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 190/212] mm/mempolicy: use readable NUMA_NO_NODE
 macro instead of magic number
Message-ID: <20210902220003.pONh2dywb%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
