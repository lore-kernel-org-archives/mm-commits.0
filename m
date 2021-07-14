Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F016C07E95
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F4961380
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbhGNBVA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237232AbhGNBVA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 21:21:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4EF661374;
        Wed, 14 Jul 2021 01:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626225489;
        bh=DumK2vQ19Mm5e7sAEZADmTjDByxn7m63ezzcqGkCd+A=;
        h=Date:From:To:Subject:From;
        b=XC02r+wPoFDkAgXyXfnrz3kZi2ZHkSDdOVL5Qm1KsGdoUq6VFU7DAtD1EyD3Jo6le
         S9UJmaH0TcR0RQ4GgJnniLxwHrJ30arieTkHxtl7aMqiqpLLhzpXXlCBrKMki0PwN1
         z8gQmRyge8FkYftmdiMYOMYM5vYcHMhvIXW5S/Jc=
Date:   Tue, 13 Jul 2021 18:18:08 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, rafael@kernel.org, rppt@linux.ibm.com
Subject:  +
 mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch added to
 -mm tree
Message-ID: <20210714011808.Qgk_NqGEq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: cleanup after removal of pfn_valid_within()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

