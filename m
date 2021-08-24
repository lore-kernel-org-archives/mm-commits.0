Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B53AC4338F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 21:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D86F56135F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 21:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhHXVTv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Aug 2021 17:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230523AbhHXVTs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 24 Aug 2021 17:19:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F54C6135F;
        Tue, 24 Aug 2021 21:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629839943;
        bh=kWz9H6iC6dGo14c2G3IfU/JrWyUPzbKnylaVZqkaQU4=;
        h=Date:From:To:Subject:From;
        b=NDNGT+JWHXrsqeLwJU8nAWaEFT+Xw7bmBSqxzMayoOFH6Df7vpObHtGWFzT2mj2Ig
         VCYktWCMm3F6Uuzc+JuU7qMovdM7AH2VoeBtliPqy0TTyM8lDUFXxFCPL9/GF1XCJt
         oSBBOyxFSzI/awc/3eNtsvtCMH6GP+nMU/m6ly6E=
Date:   Tue, 24 Aug 2021 14:19:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, erosca@de.adit-jv.com,
        davis.george@siemens.com
Subject:  +
 mm-page_isolation-tracing-trace-all-test_pages_isolated-failures.patch added
 to -mm tree
Message-ID: <20210824211903.B9T_h%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm/page_isolation: tracing: trace all test_pages_isolated failures
has been added to the -mm tree.  Its filename is
     mm-page_isolation-tracing-trace-all-test_pages_isolated-failures.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-tracing-trace-all-test_pages_isolated-failures.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-tracing-trace-all-test_pages_isolated-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "George G. Davis" <davis.george@siemens.com>
Subject: [PATCH] mm/page_isolation: tracing: trace all test_pages_isolated failures

Some test_pages_isolated failure conditions don't include trace points. 
For debugging issues caused by "pinned" pages, make sure to trace all
calls whether they succeed or fail.  In this case, a failure case did not
result in a trace point.  So add the missing failure case in
test_pages_isolated traces.

Link: https://lkml.kernel.org/r/20210823202823.13765-1-george_davis@mentor.com
Signed-off-by: George G. Davis <davis.george@siemens.com>
Cc: Eugeniu Rosca <erosca@de.adit-jv.com>
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

Patches currently in -mm which might be from davis.george@siemens.com are

mm-page_isolation-tracing-trace-all-test_pages_isolated-failures.patch

