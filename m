Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B65C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEE9E610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347884AbhIBV7W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348030AbhIBV7Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFE26603E9;
        Thu,  2 Sep 2021 21:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619897;
        bh=SB8LluEJBKfA9VuRo5xIbKlkqBmgRIZ1DBnTOcBcpJI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e6hkxg3YEjYEcDLXWbfVlxokfwa7EpexJyA0Aw5WixZTxgr+7/gqlB5VhUY1px9zk
         iBfKbCT4qIq8wgcjcYSVyXzx+WNRzK9dOuHimdYlRcO1cfHj8t7hCXGeKv9ejhkEj/
         0Rl0m2kS4unHx+gAmkJ83EYj6t4UXV8JgOaUEr+I=
Date:   Thu, 02 Sep 2021 14:58:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        davis.george@siemens.com, erosca@de.adit-jv.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 157/212] mm/page_isolation: tracing: trace all
 test_pages_isolated failures
Message-ID: <20210902215816.A4FiUG6gR%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "George G. Davis" <davis.george@siemens.com>
Subject: mm/page_isolation: tracing: trace all test_pages_isolated failures

Some test_pages_isolated failure conditions don't include trace points. 
For debugging issues caused by "pinned" pages, make sure to trace all
calls whether they succeed or fail.  In this case, a failure case did not
result in a trace point.  So add the missing failure case in
test_pages_isolated traces.

Link: https://lkml.kernel.org/r/20210823202823.13765-1-george_davis@mentor.com
Signed-off-by: George G. Davis <davis.george@siemens.com>
Cc: Eugeniu Rosca <erosca@de.adit-jv.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-tracing-trace-all-test_pages_isolated-failures
+++ a/mm/page_isolation.c
@@ -287,6 +287,7 @@ int test_pages_isolated(unsigned long st
 	unsigned long pfn, flags;
 	struct page *page;
 	struct zone *zone;
+	int ret;
 
 	/*
 	 * Note: pageblock_nr_pages != MAX_ORDER. Then, chunks of free pages
@@ -299,15 +300,21 @@ int test_pages_isolated(unsigned long st
 			break;
 	}
 	page = __first_valid_page(start_pfn, end_pfn - start_pfn);
-	if ((pfn < end_pfn) || !page)
-		return -EBUSY;
+	if ((pfn < end_pfn) || !page) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	/* Check all pages are free or marked as ISOLATED */
 	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
 	pfn = __test_page_isolated_in_pageblock(start_pfn, end_pfn, isol_flags);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
+	ret = pfn < end_pfn ? -EBUSY : 0;
+
+out:
 	trace_test_pages_isolated(start_pfn, end_pfn, pfn);
 
-	return pfn < end_pfn ? -EBUSY : 0;
+	return ret;
 }
_
