Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A1CC4338F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 18:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98F3C60F21
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 18:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhG2S25 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhG2S25 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Jul 2021 14:28:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD42F60EFF;
        Thu, 29 Jul 2021 18:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627583332;
        bh=gG690MDebHcA7PGznvsri8raEFNRh+aKOSnHHn3Bbbo=;
        h=Date:From:To:Subject:From;
        b=XolLEAlBBYgQrbHdBqadh6Uf565n5bTvBUGLj3MhXp1d2FOq5F+Ni04pSTH33OTXJ
         fpi03lLlklYd+YzywTN6ZWN96s+ZsSVBzY3vT6FU3waZL2eHFic6Vmvsw/UGpiZgel
         7sbGV7nLNEszlInAr7EgDEzn3LU2Qxak+1vHwuzM=
Date:   Thu, 29 Jul 2021 11:28:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        baolin.wang@linux.alibaba.com
Subject:  +
 mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch
 added to -mm tree
Message-ID: <20210729182850.t3t29%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: use readable NUMA_NO_NODE macro instead of magic numer
has been added to the -mm tree.  Its filename is
     mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/mempolicy: use readable NUMA_NO_NODE macro instead of magic numer

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
@@ -2460,8 +2460,8 @@ static void sp_free(struct sp_node *n)
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
@@ -2472,7 +2472,7 @@ int mpol_misplaced(struct page *page, st
 	int thiscpu = raw_smp_processor_id();
 	int thisnid = cpu_to_node(thiscpu);
 	int polnid = NUMA_NO_NODE;
-	int ret = -1;
+	int ret = NUMA_NO_NODE;
 
 	pol = get_vma_policy(vma, addr);
 	if (!(pol->flags & MPOL_F_MOF))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-mempolicy-use-readable-numa_no_node-macro-instead-of-magic-numer.patch

