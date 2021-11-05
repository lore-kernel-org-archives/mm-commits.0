Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6D4C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 853A361252
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhKEUup (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233838AbhKEUup (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE9EF60E94;
        Fri,  5 Nov 2021 20:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145285;
        bh=sGFNxz2N1YWJUJLa6sSjdrPx0R2KpQItJ3kc8xQtrno=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iO0wvjhyBQRCrgBN2bSKGMhc7ZjHPe3bcw1fr5Xe47hwqxKXYMgvWaj9djxjLcUBa
         gBCEiqsNMEkBf95GPiW2D5Y5fp5kuV0U+Xj8La4ANGY961GCuot3YCVPYVV0NWXTXN
         e+o1o2UZYOnK8N5Sa/UH+QRpinyPJmIezXW14+IU=
Date:   Fri, 05 Nov 2021 13:48:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org, xhao@linux.alibaba.com
Subject:  [patch 254/262] mm/damon: remove unnecessary variable
 initialization
Message-ID: <20211105204804.WWEtMEnCD%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: remove unnecessary variable initialization

Patch series "mm/damon: Fix some small bugs", v4.


This patch (of 2):

In 'damon_va_apply_three_regions', There is no need to set variable 'i' as
0

Link: https://lkml.kernel.org/r/b7df8d3dad0943a37e01f60c441b1968b2b20354.1634720326.git.xhao@linux.alibaba.com
Link: https://lkml.kernel.org/r/cover.1634720326.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-remove-unnecessary-variable-initialization
+++ a/mm/damon/vaddr.c
@@ -306,7 +306,7 @@ static void damon_va_apply_three_regions
 		struct damon_addr_range bregions[3])
 {
 	struct damon_region *r, *next;
-	unsigned int i = 0;
+	unsigned int i;
 
 	/* Remove regions which are not in the three big regions now */
 	damon_for_each_region_safe(r, next, t) {
_
