Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2974EC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbiCVVua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236933AbiCVVu0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D46424BF4
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E5FEB81DAB
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3A7C340EC;
        Tue, 22 Mar 2022 21:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985735;
        bh=SkZx00q+H6WrsqNnmJVvB41rO8MrGlg/DGNSTgWKqr4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=JNjE5yN9q6vkWbdtDCRLpiVfJOVzGXT/4TmYtaeqhrPvIK0+IkLO8T6d2P9qIQPNm
         0I3xC3FFGvpROwMl1BsgKidWpd2WQ2GnWsECuVkYq7Ehxba1sA9hmFydeF8tRiDRf6
         eaVO6pyPpilqYVqjpqBoHhWyENG5Ssy1yHmMRsO8=
Date:   Tue, 22 Mar 2022 14:48:55 -0700
To:     xhao@linux.alibaba.com, rientjes@google.com, sj@kernel.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 205/227] mm/damon/reclaim: use damon_select_ops() instead of damon_{v,p}a_set_operations()
Message-Id: <20220322214855.CD3A7C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
