Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB413C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 22:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiHTW0a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 18:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiHTW0a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 18:26:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED19837183
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 15:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 862E560C37
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 22:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D401FC433C1;
        Sat, 20 Aug 2022 22:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661034387;
        bh=IbOSpBr6hgM+RrYSyvDUAhZ2z8aIAsJ2KER84r92/yc=;
        h=Date:To:From:Subject:From;
        b=X3aYIcoffAM8x7pw7G+C+O3SZTBcAr9vcJ0H55A/VPlD3M3rgriDKOYIbalshk84H
         el4oytInGZlBFIYX4jQJS6k3hQxcZhMtAPuUxau1gVlW6UASP5BKy7tNvR6fWLQrIZ
         kRU8dMJCHTPeZFXqgMgxlPi/xAZgDYYKMEJP9qM8=
Date:   Sat, 20 Aug 2022 15:26:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hch@lst.de,
        felix.kuehling@amd.com, apopple@nvidia.com, alex.sierra@amd.com,
        alex.williamson@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-re-allow-pinning-of-zero-pfns-again.patch added to mm-hotfixes-unstable branch
Message-Id: <20220820222627.D401FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: re-allow pinning of zero pfns (again)
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-re-allow-pinning-of-zero-pfns-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-re-allow-pinning-of-zero-pfns-again.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alex Williamson <alex.williamson@redhat.com>
Subject: mm: re-allow pinning of zero pfns (again)
Date: Wed, 10 Aug 2022 10:53:59 -0600

The below referenced commit makes the same error as 1c563432588d ("mm: fix
is_pinnable_page against a cma page"), re-interpreting the logic to
exclude pinning of the zero page, which breaks device assignment with
vfio.

To avoid further subtle mistakes, split the logic into discrete tests.

Link: https://lkml.kernel.org/r/166015037385.760108.16881097713975517242.stgit@omen
Link: https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen
Fixes: f25cbb7a95a2 ("mm: add zone device coherent type memory support")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Felix Kuehling <felix.kuehling@amd.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-re-allow-pinning-of-zero-pfns-again
+++ a/include/linux/mm.h
@@ -1544,9 +1544,20 @@ static inline bool is_longterm_pinnable_
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
-	return !(is_device_coherent_page(page) ||
-		 is_zone_movable_page(page) ||
-		 is_zero_pfn(page_to_pfn(page)));
+	/*
+	 * The zero page might reside in a movable zone, however it may not
+	 * be migrated and can therefore be pinned.  The vfio subsystem pins
+	 * user mappings including the zero page for IOMMU translation.
+	 */
+	if (is_zero_pfn(page_to_pfn(page)))
+		return true;
+
+	/* Coherent device memory must always allow eviction. */
+	if (is_device_coherent_page(page))
+		return false;
+
+	/* Otherwise, non-movable zone pages can be pinned. */
+	return !is_zone_movable_page(page);
 }
 #else
 static inline bool is_longterm_pinnable_page(struct page *page)
_

Patches currently in -mm which might be from alex.williamson@redhat.com are

mm-re-allow-pinning-of-zero-pfns-again.patch

