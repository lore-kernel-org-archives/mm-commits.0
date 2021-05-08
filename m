Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68960C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 457D261402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhEHWst (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWss (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75292613C5;
        Sat,  8 May 2021 22:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514066;
        bh=hIjartPNfUnwbkhvr/9cgJhr1Ns7oFBLqjPdtGzIH/U=;
        h=Date:From:To:Subject:From;
        b=iInn2L9/K2ytFQB/eNZR4W8THAnrTbvoJMSOP7cQoOLFbqmEBbEH5oo06t1qLe3x9
         PFYiR+6tUaI7+8T17XuUOmt7Kck9Mo2kMf85YvtcDIfFuClbHCyIt1IkuZvTxdQUb3
         ch6P2j4fd0Lqt1MNRo8shwGTHlP2iEphwCJmpsi8=
Date:   Sat, 08 May 2021 15:47:46 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  [merged]
 mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch removed from
 -mm tree
Message-ID: <20210508224746.8fpvjthOd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: drop clearing of flag from prep_new_huge_page
has been removed from the -mm tree.  Its filename was
     mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from osalvador@suse.de are


