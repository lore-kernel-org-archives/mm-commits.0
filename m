Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B90C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C90461104
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347361AbhIHC4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347421AbhIHC4D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:56:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17E6E61100;
        Wed,  8 Sep 2021 02:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069696;
        bh=HzNXv/zXh7+mtwoGwAl+xx7zHq5/brAzSpoyeK4i64U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FRhbIIAnjP5l54BW/6NzFMezHQVGTpaTUbs5xbMvH9A/PZ2zz+FUQrnVR56LBVej7
         AsVkaoH2K6Q1lpfeCP2xwccOMolX7WT7Q2y0yjL2uEVT1Fk9QaRb7DY/lP86vJ45XL
         BUUZiOfbLLUFhhA+hmg/F02YTo8oXs6+j5nnhbJY=
Date:   Tue, 07 Sep 2021 19:54:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rafael@kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 037/147] mm: memory_hotplug: cleanup after removal
 of pfn_valid_within()
Message-ID: <20210908025455.RodG9sgjP%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
