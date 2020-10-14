Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56159C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0840E214D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709446;
	bh=K33VM/20BIlGoUk5Yq5WokMNwyMbXFmEgBuHikoEhGM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LTuOPzYBjDJw9N6ZBX9kL2aMxniOyfqCUabS1sA6CjvqcMJv5943Z0V2V6qirPeyV
	 NWCGCXK0FcY9XcQbx9JssTlZn4Du2u9XpLNn+j2xZVoGHvx1CH2biaQTXkbPzS18+g
	 Q7YeK8VFoA8yp1k8Nr+5HFKOc4/43xMDJrJv3pdU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388501AbgJNVEF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgJNVEF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:04:05 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B9C0206B2;
        Wed, 14 Oct 2020 21:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709444;
        bh=K33VM/20BIlGoUk5Yq5WokMNwyMbXFmEgBuHikoEhGM=;
        h=Date:From:To:Subject:From;
        b=UihDWeR3EtGMDjV8vqRknvKmRku4MSL6EeyZoS1T3U6YDsJp+TeQw63KUfE2Avcpy
         Sc6eNUVZa1T63VhmKplXW/Lu3oBq5IdxRdicUNMDzFdF2W0sP7jw8sAVJoqjgBZxK5
         vJOuDLhGwttL5oWReARjOWpEosUYbA0bEAL2eAUw=
Date:   Wed, 14 Oct 2020 14:04:04 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged] mm-remove-unused-alloc_page_vma_node.patch
 removed from -mm tree
Message-ID: <20201014210404.hVbAKnHAa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused alloc_page_vma_node()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-alloc_page_vma_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm: remove unused alloc_page_vma_node()

No one use this macro anymore.

Also fix code style of policy_node().

Link: https://lkml.kernel.org/r/20200921021401.84508-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 --
 mm/mempolicy.c      |    3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/gfp.h~mm-remove-unused-alloc_page_vma_node
+++ a/include/linux/gfp.h
@@ -562,8 +562,6 @@ extern struct page *alloc_pages_vma(gfp_
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
 	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id(), false)
-#define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
-	alloc_pages_vma(gfp_mask, 0, vma, addr, node, false)
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
--- a/mm/mempolicy.c~mm-remove-unused-alloc_page_vma_node
+++ a/mm/mempolicy.c
@@ -1882,8 +1882,7 @@ nodemask_t *policy_nodemask(gfp_t gfp, s
 }
 
 /* Return the node id preferred by the given mempolicy, or the given id */
-static int policy_node(gfp_t gfp, struct mempolicy *policy,
-								int nd)
+static int policy_node(gfp_t gfp, struct mempolicy *policy, int nd)
 {
 	if (policy->mode == MPOL_PREFERRED && !(policy->flags & MPOL_F_LOCAL))
 		nd = policy->v.preferred_node;
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

