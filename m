Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D1BC2BBD5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87E0B224B0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgLODMt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbgLODMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:41 -0500
Date:   Mon, 14 Dec 2020 19:11:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001873;
        bh=m+R9Ih7fCVNomQAK/AtRoQBdXAYt0F/wMx0o7LPzhRw=;
        h=From:To:Subject:In-Reply-To:From;
        b=Q+xRb4ll70dgHau+YoiM74CtdCE+/gz9iXam5uTGyUI7UiOdlCfBIsmgYgMgWxj6W
         vSUHy0/RTCZ94vGKWya4ndHQ8LWHMQUkrtDGnsBanYSi0Gpoz91yLCDLhnXooDOX/Y
         SCx8LkZFCoL8oaK1lyEene6tOAU4EnSTwE5LTBTA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, zou_wei@huawei.com
Subject:  [patch 133/200] mm/page_alloc: mark some symbols with
 static keyword
Message-ID: <20201215031112.3l9C_e0_r%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>
Subject: mm/page_alloc: mark some symbols with static keyword

Fix the following sparse warnings:

mm/page_alloc.c:3040:6: warning: symbol '__drain_all_pages' was not declared. Should it be static?
mm/page_alloc.c:6349:6: warning: symbol '__zone_set_pageset_high_and_batch' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/1605517365-65858-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-mark-some-symbols-with-static-keyword
+++ a/mm/page_alloc.c
@@ -3035,7 +3035,7 @@ static void drain_local_pages_wq(struct
  * that need the guarantee that every CPU has drained can disable the
  * optimizing racy check.
  */
-void __drain_all_pages(struct zone *zone, bool force_all_cpus)
+static void __drain_all_pages(struct zone *zone, bool force_all_cpus)
 {
 	int cpu;
 
@@ -6357,7 +6357,7 @@ static void pageset_init(struct per_cpu_
 	pcp->batch = BOOT_PAGESET_BATCH;
 }
 
-void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
+static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
 		unsigned long batch)
 {
 	struct per_cpu_pageset *p;
_
