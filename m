Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC48DC43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8D92613E8
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWs5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhEHWs4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 979646101D;
        Sat,  8 May 2021 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514074;
        bh=rYqooDONFWHLGxTUCEL+AYP9nUhzqkoVKfcaifoKEKs=;
        h=Date:From:To:Subject:From;
        b=bAqBz+bHYvpCIVIHvC7h2NqEaRhvcx2obUOkTyUJkl5GyRvxc2znYM6t1hnu+LFA6
         5tbkzYpNSogjIeaCcfqlhgF7OENZZ6OF0uBzHWRJ59R84glvKVkAkWQ3K08HYdTn6k
         Pskblai9UlynC7TMwrmFNkcJmGv2xtGEBE2Mfqpo=
Date:   Sat, 08 May 2021 15:47:54 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  [merged]
 mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
 removed from -mm tree
Message-ID: <20210508224754.GMzPThP_1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,page_alloc: drop unnecessary checks from pfn_range_valid_contig
has been removed from the -mm tree.  Its filename was
     mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_alloc: drop unnecessary checks from pfn_range_valid_contig

pfn_range_valid_contig() bails out when it finds an in-use page or a
hugetlb page, among other things.  We can drop the in-use page check since
__alloc_contig_pages can migrate away those pages, and the hugetlb page
check can go too since isolate_migratepages_range is now capable of
dealing with hugetlb pages.  Either way, those checks are racy so let the
end function handle it when the time comes.

Link: https://lkml.kernel.org/r/20210419075413.1064-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/page_alloc.c~mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig
+++ a/mm/page_alloc.c
@@ -8898,12 +8898,6 @@ static bool pfn_range_valid_contig(struc
 
 		if (PageReserved(page))
 			return false;
-
-		if (page_count(page) > 0)
-			return false;
-
-		if (PageHuge(page))
-			return false;
 	}
 	return true;
 }
_

Patches currently in -mm which might be from osalvador@suse.de are


