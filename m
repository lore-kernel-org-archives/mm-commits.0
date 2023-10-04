Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9D2E7C4F8
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244852AbjJDUWz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244945AbjJDUW3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629C4173D;
        Wed,  4 Oct 2023 13:21:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F7BC433C7;
        Wed,  4 Oct 2023 20:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450908;
        bh=fvQtjPhX6OkcJmWjQOkL1i0p3ykC37QCHrR+wDjQN5w=;
        h=Date:To:From:Subject:From;
        b=e5OAJte3RzgwVY53SCRC+uBLIlof+OtTpQOudhw9czikjXCstc77LWlgyhwO/AK0T
         qOD4Ox5+/P8STR8D30lK8qSWOff9ZZ3EuVbcWKPj709sXE6/hLWN8pQQ6JsnIqMRZw
         inOC+xrDxDpvHJPzwbkmIvZ0mI7lJ4Z2k3TrS2TA=
Date:   Wed, 04 Oct 2023 13:21:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, stable@vger.kernel.org,
        songmuchun@bytedance.com, rppt@kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch removed from -mm tree
Message-Id: <20231004202147.A1F7BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: use nth_page() in place of direct struct page manipulation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/hugetlb: use nth_page() in place of direct struct page manipulation
Date: Wed, 13 Sep 2023 16:12:45 -0400

When dealing with hugetlb pages, manipulating struct page pointers
directly can get to wrong struct page, since struct page is not guaranteed
to be contiguous on SPARSEMEM without VMEMMAP.  Use nth_page() to handle
it properly.

A wrong or non-existing page might be tried to be grabbed, either
leading to a non freeable page or kernel memory access errors.  No bug
is reported.  It comes from code inspection.

Link: https://lkml.kernel.org/r/20230913201248.452081-3-zi.yan@sent.com
Fixes: 57a196a58421 ("hugetlb: simplify hugetlb handling in follow_page_mask")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-nth_page-in-place-of-direct-struct-page-manipulation
+++ a/mm/hugetlb.c
@@ -6493,7 +6493,7 @@ struct page *hugetlb_follow_page_mask(st
 			}
 		}
 
-		page += ((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
+		page = nth_page(page, ((address & ~huge_page_mask(h)) >> PAGE_SHIFT));
 
 		/*
 		 * Note that page may be a sub-page, and with vmemmap
_

Patches currently in -mm which might be from ziy@nvidia.com are


