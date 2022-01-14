Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA871C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiANWKw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiANWKw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E3FC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:10:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA7A1CE2384
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF42CC36AE9;
        Fri, 14 Jan 2022 22:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198248;
        bh=Crjmo7tHv8SQwDHJ1SZziUwYsbzz7L7y0cmGnpncxfA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c/gJFmuEn1wdW4awCCkTj7naIguVxYfuYwz09LwswAMCBgATn6hyCgsGUpVJoxxzd
         hyRdTl3lPDrN3VMaY3KGglbk7bDuHl/USQfrA7wjKYLHUOsUgmPG7RaUUiFOMWPRio
         mW88gLPXmddS21tUTzZ0XzndjwMGC73Xr2QpzNtA=
Date:   Fri, 14 Jan 2022 14:10:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 145/146] mm/damon/vaddr: hide kernel pointer from
 damon_va_three_regions() failure log
Message-ID: <20220114221047.5nwaCB_o6%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: hide kernel pointer from damon_va_three_regions() failure log

The failure log message for 'damon_va_three_regions()' prints the target
id, which is a 'struct pid' pointer in the case.  To avoid exposing the
kernel pointer via the log, this commit makes the log to use the index of
the target in the context's targets list instead.

Link: https://lkml.kernel.org/r/20211229131016.23641-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log
+++ a/mm/damon/vaddr.c
@@ -232,13 +232,19 @@ static int damon_va_three_regions(struct
 static void __damon_va_init_regions(struct damon_ctx *ctx,
 				     struct damon_target *t)
 {
+	struct damon_target *ti;
 	struct damon_region *r;
 	struct damon_addr_range regions[3];
 	unsigned long sz = 0, nr_pieces;
-	int i;
+	int i, tidx = 0;
 
 	if (damon_va_three_regions(t, regions)) {
-		pr_debug("Failed to get three regions of target %lu\n", t->id);
+		damon_for_each_target(ti, ctx) {
+			if (ti == t)
+				break;
+			tidx++;
+		}
+		pr_debug("Failed to get three regions of %dth target\n", tidx);
 		return;
 	}
 
_
