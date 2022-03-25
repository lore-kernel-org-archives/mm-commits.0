Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24D8C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357431AbiCYBgK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357432AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EFF26565
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFDD860AD1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1AAC340ED;
        Fri, 25 Mar 2022 01:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171996;
        bh=vTLv/h38nC+O4kJQ+fHgygyXtC7lLK6sO6DE4wCSp1c=;
        h=Date:To:From:Subject:From;
        b=vXakSDjOsIe//GtvvvobFsm6nnfYeLG7rniLp/f1to7F+1qPQwoipitv8zze3q0Dw
         9UcIRpISfNMuZSLerUeWno5SnXOUCIMNWLM41F+tLax/8K2aIyVXYNNjNPOGiCUmmo
         ASSRQ2usYIxv7rOJCbyM1qtc5KXtcN0cljELY/9A=
Date:   Thu, 24 Mar 2022 18:33:15 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        rientjes@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch removed from -mm tree
Message-Id: <20220325013316.2B1AAC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: use damon_select_ops() instead of damon_{v,p}a_set_operations()
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use damon_select_ops() instead of damon_{v,p}a_set_operations()

This commit makes DAMON_RECLAIM to select the registered monitoring
operations for the physical address space instead of setting it on its
own.  This allows DAMON_RECLAIM be independent of DAMON_PADDR, but leave
the dependency as is, because it's the only one monitoring operations it
use, and therefore it makes no sense to build DAMON_RECLAIM without
DAMON_PADDR.

Link: https://lkml.kernel.org/r/20220215184603.1479-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-damon_select_ops-instead-of-damon_vpa_set_operations
+++ a/mm/damon/reclaim.c
@@ -384,7 +384,9 @@ static int __init damon_reclaim_init(voi
 	if (!ctx)
 		return -ENOMEM;
 
-	damon_pa_set_operations(ctx);
+	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
+		return -EINVAL;
+
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
 
 	target = damon_new_target();
_

Patches currently in -mm which might be from sj@kernel.org are


