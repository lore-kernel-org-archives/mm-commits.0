Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DCAC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjFIX3K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbjFIX2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D06E3C19
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 246E863EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF0DC433EF;
        Fri,  9 Jun 2023 23:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353272;
        bh=IJjjOy4NLBcRI3k0mnboGrZ02wfUX1gTT50hhlnYS3g=;
        h=Date:To:From:Subject:From;
        b=wuku1BxzxFaH//F2UDyLip7LSUrtQ73XFfPjdOZHx2XJs+qFPVxT/gEyUpODFAzw9
         s7m9YOOgJE6vOBvx86dhXl+vareFffqwrkWiOb2n7lAy7WQyFKksWziQV2eWkAmboN
         N2WZDt3rOFQDruFwqU7ABV9lD5zfsYT+GU7yzUZE=
Date:   Fri, 09 Jun 2023 16:27:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        david@redhat.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-hugetlb_page_subpool.patch removed from -mm tree
Message-Id: <20230609232752.7CF0DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: remove hugetlb_page_subpool()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-hugetlb_page_subpool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: remove hugetlb_page_subpool()
Date: Tue, 16 May 2023 15:52:05 -0700

All users of hugetlb_page_subpool() have been converted to use the folio
equivalent.  This function can be safely removed.

Link: https://lkml.kernel.org/r/20230516225205.1429196-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_page_subpool
+++ a/include/linux/hugetlb.h
@@ -757,14 +757,6 @@ static inline struct hugepage_subpool *h
 	return folio->_hugetlb_subpool;
 }
 
-/*
- * hugetlb page subpool pointer located in hpage[2].hugetlb_subpool
- */
-static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
-{
-	return hugetlb_folio_subpool(page_folio(hpage));
-}
-
 static inline void hugetlb_set_folio_subpool(struct folio *folio,
 					struct hugepage_subpool *subpool)
 {
@@ -1030,11 +1022,6 @@ static inline struct hugepage_subpool *h
 {
 	return NULL;
 }
-
-static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
-{
-	return NULL;
-}
 
 static inline int isolate_or_dissolve_huge_page(struct page *page,
 						struct list_head *list)
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


