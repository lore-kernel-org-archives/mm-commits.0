Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED39C433E2
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA8D61982
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhCSQOx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230373AbhCSQOe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 12:14:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B522261986;
        Fri, 19 Mar 2021 16:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616170474;
        bh=cdtkDUz6WoR2Uq2RXMwHN+WM4mCOPmHz6z4zagzydNY=;
        h=Date:From:To:Subject:From;
        b=q5WhNplY2XRjZPQUkt8KoJ927x7fXlTZTgkp55fUvQVB5DPgKY52dFCW7jtS95w03
         UgIGnHwNz4LMmtoFXfX30Gpyhppaa0+jNoAIMdFo7zqQc/NTDALfNHauFVsieN6C9x
         WhWsAGtLKZtzb0IWKjCcSx/HwxEcHa8Xk5IczagY=
Date:   Fri, 19 Mar 2021 09:14:33 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  +
 mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
 added to -mm tree
Message-ID: <20210319161433.KctnI1xJw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,page_alloc: drop unnecessary checks from pfn_range_valid_contig
has been added to the -mm tree.  Its filename is
     mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_alloc: drop unnecessary checks from pfn_range_valid_contig

pfn_range_valid_contig() bails out when it finds an in-use page or a
hugetlb page, among other things.

We can drop the in-use page check since __alloc_contig_pages can migrate
away those pages, and the hugetlb page check can go too since
isolate_migratepages_range is now capable of dealing with hugetlb pages. 
Either way, those checks are racy so let the end function handle it when
the time comes.

Link: https://lkml.kernel.org/r/20210319132004.4341-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/page_alloc.c~mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig
+++ a/mm/page_alloc.c
@@ -8744,12 +8744,6 @@ static bool pfn_range_valid_contig(struc
 
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

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch

