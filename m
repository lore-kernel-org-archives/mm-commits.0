Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E7FC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 706BE61404
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhEEBga (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhEEBga (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A134613FE;
        Wed,  5 May 2021 01:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178533;
        bh=uAG7YGkrp9IVmTVAZ7OIR19QpN1nUApJrAcmuzzXnCc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=exee4UkhxWS0EuuWLYjcHEMykjSlEpHQ1pIQefjlsjg7pBJmZwOtUTSyyxbdAEHPH
         yqmmE8+8fZmVThKlQcX2JT+9VJ7UZDq7VcBLIAEHtSI2koTkP8+v5eOZ3ct2UuOh/r
         8W5qNw25Mgc+X+l2GW9hKs1j3C1qm+4sGFZBHRKI=
Date:   Tue, 04 May 2021 18:35:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 053/143] mm,page_alloc: drop unnecessary checks
 from pfn_range_valid_contig
Message-ID: <20210505013533.bMyEtPe4v%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
