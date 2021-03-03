Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16B9C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91BC64EBD
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237490AbhCDA6q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1449861AbhCCXBy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 18:01:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDB0A64EF9;
        Wed,  3 Mar 2021 23:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614812473;
        bh=09D8nEWb6PWGpNIGbX1gTxANz7puCl8E0RT+KrwHhsA=;
        h=Date:From:To:Subject:From;
        b=I6u07aBehBd1bqe8Q6PecLiAd2DPeVynZhhBLD+pkZU+KNZY0/Ch4s8oJm5W8obxx
         7vjCxINoQWcKGiaEioA1UwglggjiixHPiXcvrF87FVeHj4uunr5mzlW592oAr+o9W8
         zxFu1A9wQl971kPPJG/dfXA8yPyYLK+TdLA2wx0w=
Date:   Wed, 03 Mar 2021 15:01:12 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, vbabka@suse.cz
Subject:  + mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
 added to -mm tree
Message-ID: <20210303230112.sxLQLXDXF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove lru_add_drain_all in alloc_contig_range
has been added to the -mm tree.  Its filename is
     mm-remove-lru_add_drain_all-in-alloc_contig_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-lru_add_drain_all-in-alloc_contig_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove lru_add_drain_all in alloc_contig_range

__alloc_contig_migrate_range already has lru_add_drain_all call via
migrate_prep.  It's necessary to move LRU taget pages into LRU list to be
able to isolated.  However, lru_add_drain_all call after
__alloc_contig_migrate_range is pointless since it has changed source page
freeing from putback_lru_pages to put_page[1].

This patch removes it.

[1] c6c919eb90e0, ("mm: use put_page() to free page instead of putback_lru_page()"

Link: https://lkml.kernel.org/r/20210303204512.2863087-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_alloc.c~mm-remove-lru_add_drain_all-in-alloc_contig_range
+++ a/mm/page_alloc.c
@@ -8597,8 +8597,6 @@ int alloc_contig_range(unsigned long sta
 	 * isolated thus they won't get removed from buddy.
 	 */
 
-	lru_add_drain_all();
-
 	order = 0;
 	outer_start = start;
 	while (!PageBuddy(pfn_to_page(outer_start))) {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
mm-vmstat-add-cma-statistics.patch

