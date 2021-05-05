Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B284FC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9711561402
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhEEBgR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhEEBgR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:36:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22AD2613FE;
        Wed,  5 May 2021 01:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178521;
        bh=RL1ujjq08nYkWXbnPmBGfGLFu44lxzcS9SB8dGj6uLE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0ZRRPoZ7VNV3cA49mCc9yIT7+yRvKGJMWLIjaq3kPk1D2xhpXwp5a83ekx8HRhOgY
         uKjmgBSw+BEWUzp72jGCgUojEbltt4IKagL+IfoOs4vBb/ewSK0x9ipyX6z5uNlad8
         1mqmmRKEunf+bb2ukrrC0zVtV432lGE94wW5Umx4=
Date:   Tue, 04 May 2021 18:35:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 049/143] mm,hugetlb: drop clearing of flag from
 prep_new_huge_page
Message-ID: <20210505013520.Fdu29YYr-%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: drop clearing of flag from prep_new_huge_page

Pages allocated via the page allocator or CMA get its private field
cleared by means of post_alloc_hook().

Pages allocated during boot, that is directly from the memblock allocator,
get cleared by
paging_init()->..->memmap_init_zone->..->__init_single_page() before any
memblock allocation.

Based on this ground, let us remove the clearing of the flag from
prep_new_huge_page() as it is not needed.  This was a leftover from
6c0371490140 ("hugetlb: convert PageHugeFreed to HPageFreed flag"). 
Previously the explicit clearing was necessary because compound
allocations do not get this initialization (see prep_compound_page).

Link: https://lkml.kernel.org/r/20210419075413.1064-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page
+++ a/mm/hugetlb.c
@@ -1494,7 +1494,6 @@ static void prep_new_huge_page(struct hs
 	spin_lock_irq(&hugetlb_lock);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
-	ClearHPageFreed(page);
 	spin_unlock_irq(&hugetlb_lock);
 }
 
_
