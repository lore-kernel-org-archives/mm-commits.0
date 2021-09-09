Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16F5C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3FB611AD
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346551AbhIIVCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346074AbhIIVCi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D8E26103D;
        Thu,  9 Sep 2021 21:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221288;
        bh=WpqFzRZ7iLtryeap9v4nLwILFH9v7OaB52DVU/UWtHc=;
        h=Date:From:To:Subject:From;
        b=LARz0v00gAXfuBbWhLUFGF+qkPeqNp3V4rCiGmGAxPvcK3YYWLxTf/J2+xJ3GD8ZJ
         U9w/0pdCWUUy4eX6j3xewDqG9Xo4B6fEiOexPTsOpSurzGtY9tYYB0UPyBXv3oNAXQ
         Mncvk6OnB5jiclqBkaEdEdlff2uzVc/cX3pms7Nw=
Date:   Thu, 09 Sep 2021 14:01:28 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, rafael@kernel.org, rppt@linux.ibm.com
Subject:  [merged]
 mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch removed
 from -mm tree
Message-ID: <20210909210128.cjdCVaZME%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: cleanup after removal of pfn_valid_within()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: memory_hotplug: cleanup after removal of pfn_valid_within()

When test_pages_in_a_zone() used pfn_valid_within() is has some logic
surrounding pfn_valid_within() checks.

Since pfn_valid_within() is gone, this logic can be removed.

Link: https://lkml.kernel.org/r/20210713080035.7464-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within
+++ a/mm/memory_hotplug.c
@@ -1298,7 +1298,7 @@ struct zone *test_pages_in_a_zone(unsign
 	unsigned long pfn, sec_end_pfn;
 	struct zone *zone = NULL;
 	struct page *page;
-	int i;
+
 	for (pfn = start_pfn, sec_end_pfn = SECTION_ALIGN_UP(start_pfn + 1);
 	     pfn < end_pfn;
 	     pfn = sec_end_pfn, sec_end_pfn += PAGES_PER_SECTION) {
@@ -1307,13 +1307,10 @@ struct zone *test_pages_in_a_zone(unsign
 			continue;
 		for (; pfn < sec_end_pfn && pfn < end_pfn;
 		     pfn += MAX_ORDER_NR_PAGES) {
-			i = 0;
-			if (i == MAX_ORDER_NR_PAGES || pfn + i >= end_pfn)
-				continue;
 			/* Check if we got outside of the zone */
-			if (zone && !zone_spans_pfn(zone, pfn + i))
+			if (zone && !zone_spans_pfn(zone, pfn))
 				return NULL;
-			page = pfn_to_page(pfn + i);
+			page = pfn_to_page(pfn);
 			if (zone && page_zone(page) != zone)
 				return NULL;
 			zone = page_zone(page);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


