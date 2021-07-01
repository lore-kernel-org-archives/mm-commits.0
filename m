Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA61C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D262261480
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbhGABzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABzN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C06CD61241;
        Thu,  1 Jul 2021 01:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104364;
        bh=TFh44qdMZt9Vja3LMR2t+j58k4ehpx3rEYrJZb1pg1M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WW78ydZWlDXTQkA2PKxV4ffAyp3EMMsB3nX2jtYQjtzlaTqSfvolprwjmftNFIiHu
         PLuT6nkdDjhpNfybLT5GyP9xcBJ/5N8SBV3gY36CrLfpGhnou1BYvzHUVPlc2onqu8
         qugndc9nJOHwgcNc9C6U6HdNW8E0o/QpgEBadVmY=
Date:   Wed, 30 Jun 2021 18:52:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        georgi.djakov@linaro.org, linux-mm@kvack.org, lmark@codeaurora.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 103/192] mm/memory_hotplug: rate limit page
 migration warnings
Message-ID: <20210701015243.6hfM4X7tH%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Mark <lmark@codeaurora.org>
Subject: mm/memory_hotplug: rate limit page migration warnings

When offlining memory the system can attempt to migrate a lot of pages, if
there are problems with migration this can flood the logs.  Printing all
the data hogs the CPU and cause some RT threads to run for a long time,
which may have some bad consequences.

Rate limit the page migration warnings in order to avoid this.

Link: https://lkml.kernel.org/r/20210505140542.24935-1-georgi.djakov@linaro.org
Signed-off-by: Liam Mark <lmark@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-rate-limit-page-migration-warnings
+++ a/mm/memory_hotplug.c
@@ -1406,6 +1406,8 @@ do_migrate_range(unsigned long start_pfn
 	struct page *page, *head;
 	int ret = 0;
 	LIST_HEAD(source);
+	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		if (!pfn_valid(pfn))
@@ -1452,8 +1454,10 @@ do_migrate_range(unsigned long start_pfn
 						    page_is_file_lru(page));
 
 		} else {
-			pr_warn("failed to isolate pfn %lx\n", pfn);
-			dump_page(page, "isolation failed");
+			if (__ratelimit(&migrate_rs)) {
+				pr_warn("failed to isolate pfn %lx\n", pfn);
+				dump_page(page, "isolation failed");
+			}
 		}
 		put_page(page);
 	}
@@ -1482,9 +1486,11 @@ do_migrate_range(unsigned long start_pfn
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret) {
 			list_for_each_entry(page, &source, lru) {
-				pr_warn("migrating pfn %lx failed ret:%d ",
-				       page_to_pfn(page), ret);
-				dump_page(page, "migration failure");
+				if (__ratelimit(&migrate_rs)) {
+					pr_warn("migrating pfn %lx failed ret:%d\n",
+						page_to_pfn(page), ret);
+					dump_page(page, "migration failure");
+				}
 			}
 			putback_movable_pages(&source);
 		}
_
