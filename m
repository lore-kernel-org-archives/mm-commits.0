Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353D1C43460
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 011A160FE6
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhDIFJe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhDIFJZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:09:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C5FE61182;
        Fri,  9 Apr 2021 05:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944885;
        bh=TsQvdvecHs80gPi9Q+/sX9AnUEtCJuAggTtcGhqP29E=;
        h=Date:From:To:Subject:From;
        b=sGpaFoQlfCvisGcrCIP1fYo6WZ5wfhkJblHE83sT25S1s7pHxaEdylSxwKyzLtQEE
         Y0kxqVI1KlGVUjHJmmmz53jBFMO8Xd/0LDKXkre77DhdmABWT2Obu3EHrWjsb3Ou9K
         DqEtjfAAX9vznARDSiL5Jn5wC18VWfsY7amBaVKc=
Date:   Thu, 08 Apr 2021 22:08:05 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
 removed from -mm tree
Message-ID: <20210409050805.q4q5JkgAe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,page_alloc: drop unnecessary checks from pfn_range_valid_contig
has been removed from the -mm tree.  Its filename was
     mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch

This patch was dropped because an updated version will be merged

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
Acked-by: Michal Hocko <mhocko@suse.com>
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
@@ -8897,12 +8897,6 @@ static bool pfn_range_valid_contig(struc
 
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
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

