Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC5FC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C3F1613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHWpz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWpy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86EDB61402;
        Sat,  8 May 2021 22:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513892;
        bh=8Wk4GASiYCU3cq7FH3GqOqlT6Yx9pDmjFgLGUhRT7Uk=;
        h=Date:From:To:Subject:From;
        b=GBljuhvmY8AXgOECpE/damdPfeT2NIQRI0l59/8NEPPpXFCoC/dMlbYFoho+3b8At
         cvzzEXgReKpt7tZRXAiepiUCXUPTDd//VcQMLW1ud2sxciGSNQ5RfiMfObRVqg3c0l
         eDSrLyoCVhJ+us0ycQVEYzKcRsMTrDjhVX0FZDtg=
Date:   Sat, 08 May 2021 15:44:52 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, vbabka@suse.cz
Subject:  [merged]
 mm-remove-lru_add_drain_all-in-alloc_contig_range.patch removed from -mm
 tree
Message-ID: <20210508224452.GAbeHBjf-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove lru_add_drain_all in alloc_contig_range
has been removed from the -mm tree.  Its filename was
     mm-remove-lru_add_drain_all-in-alloc_contig_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -8649,8 +8649,6 @@ int alloc_contig_range(unsigned long sta
 	 * isolated thus they won't get removed from buddy.
 	 */
 
-	lru_add_drain_all();
-
 	order = 0;
 	outer_start = start;
 	while (!PageBuddy(pfn_to_page(outer_start))) {
_

Patches currently in -mm which might be from minchan@kernel.org are


