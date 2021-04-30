Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F94C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D798861492
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhD3GBu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhD3GBt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC9061494;
        Fri, 30 Apr 2021 06:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762462;
        bh=bJD5ERUSaLycD82SRygqqgZeDG6yRKu5nMB5gMLkYp0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DKUQI7J/1Th/p+o6qmET+lf8SvYdnz7YUp6KV+zG7JcN0KDfHwvfjvN2G8TKDZSDz
         awpUMSqImi4t8+OASplHG4vbBiJjgSxLAOPf285rla2HhI5Ydn3WikzUBzTtM7vdUF
         Unx6+urYv7eoz3TdQSlSmOz7Ejd0RHYE6o3/AkxU=
Date:   Thu, 29 Apr 2021 23:01:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 152/178] mm: remove lru_add_drain_all in
 alloc_contig_range
Message-ID: <20210430060101.N6K6rE2UJ%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -8649,8 +8649,6 @@ int alloc_contig_range(unsigned long sta
 	 * isolated thus they won't get removed from buddy.
 	 */
 
-	lru_add_drain_all();
-
 	order = 0;
 	outer_start = start;
 	while (!PageBuddy(pfn_to_page(outer_start))) {
_
