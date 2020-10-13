Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D28C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 923A02222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633432;
	bh=EVJ6pVcISgxb4lOgFXZEbBgHQwh7xNxgdbR62xPn0xY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=F1uqpEvPMzSYEOJa8ADkTF8ab50I/7NtREeKsG88SyFN8aQ9bRHRUP9yDXXPgrUe0
	 bUZe3oOGtDcEtAIDVrkHEkzbRBbKfTcjrWlriO7iBN2YtHqOyxSrbpAyAgvtq7Exbu
	 wJS8RY2o+KsPAp+a8muh6wbT7dh7UurwiPJHYaM0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389352AbgJMX5M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389233AbgJMX5M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:57:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C70B22247;
        Tue, 13 Oct 2020 23:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633431;
        bh=EVJ6pVcISgxb4lOgFXZEbBgHQwh7xNxgdbR62xPn0xY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OSiNJQ9tJfeUrUtkZd6fXR2d8U/BobSFxhnVF++9jIEujFpp3UR2JzF72QTBRtofD
         LvelHa5bt7p5RxylVoilIBRLqBmwQml2YaFaQDmmkoG09NggJYxNrDzBZjSDOjDaQi
         isL1F75eoeBwryvYGiQS88Q9zPWrvPZXELEEMMhk=
Date:   Tue, 13 Oct 2020 16:57:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 160/181] mm: remove unused alloc_page_vma_node()
Message-ID: <20201013235711.ZFwbFW_m2%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
