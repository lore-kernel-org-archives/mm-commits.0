Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF88C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiANWKs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38626 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiANWKs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ABB38CE19A9
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF39AC36AE9;
        Fri, 14 Jan 2022 22:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198245;
        bh=XI8c08BaJs1j2iC89Rj9atI+5ZEcHjbWcd51QKBOcdM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=V2rlK6Or4GzGREhY/V8e7LYp0yP76zhIpdBbIVKxMftV4C2KR39Pdx+bvP9N87IVp
         9BIQiTwAKBQ2PBa8klwZcrrHQE9TR6902Y4pLVwf0+QLzEKGIwYG3m0KtlF/sDM0+A
         XyWNVUcsOpIkX4w/kgf+R0aLY4RmIbv9m1PQVCUM=
Date:   Fri, 14 Jan 2022 14:10:44 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 144/146] mm/damon/vaddr: use pr_debug() for
 damon_va_three_regions() failure logging
Message-ID: <20220114221044.otM3UPlhQ%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: use pr_debug() for damon_va_three_regions() failure logging

Failure of 'damon_va_three_regions()' is logged using 'pr_err()'.  But,
the function can fail in legal situations.  To avoid making users be
surprised and to keep the kernel clean, this commit makes the log to be
printed using 'pr_debug()'.

Link: https://lkml.kernel.org/r/20211229131016.23641-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging
+++ a/mm/damon/vaddr.c
@@ -238,7 +238,7 @@ static void __damon_va_init_regions(stru
 	int i;
 
 	if (damon_va_three_regions(t, regions)) {
-		pr_err("Failed to get three regions of target %lu\n", t->id);
+		pr_debug("Failed to get three regions of target %lu\n", t->id);
 		return;
 	}
 
_
