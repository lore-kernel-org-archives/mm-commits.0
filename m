Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6868C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 22:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjEPWyY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 18:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbjEPWyR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 18:54:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105266EBB
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 15:54:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D7BF63821
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 22:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D860AC433D2;
        Tue, 16 May 2023 22:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684277653;
        bh=ucoUiOTI6G1qmq0Jjdiaxs9qw+tN2l60INwBCKpvmr4=;
        h=Date:To:From:Subject:From;
        b=KBWftXJSR+zIlMlTO6B/xDQVJewdptEMmZ76dPHpeR6/Zp9Tfoudh5W1DY8Ss3z3l
         HmX07vkAh0RGqpFzLAlXK7ALjZBxHAHZQitksu7f1yJmXOl1mEpuUZmYGsWfqrQkTe
         ymPCsg3zhM0hDoYJMzZmOhTYnrVq1MeV9T8rfs0A=
Date:   Tue, 16 May 2023 15:54:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        david@redhat.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-hugetlb_page_subpool.patch added to mm-unstable branch
Message-Id: <20230516225413.D860AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove hugetlb_page_subpool()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-hugetlb_page_subpool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-hugetlb_page_subpool.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: remove hugetlb_page_subpool()
Date: Tue, 16 May 2023 15:52:05 -0700

All users of hugetlb_page_subpool() have been converted to use the folio
equivalent.  This function can be safely removed.

Link: https://lkml.kernel.org/r/20230516225205.1429196-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   13 -------------
 1 file changed, 13 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_page_subpool
+++ a/include/linux/hugetlb.h
@@ -755,14 +755,6 @@ static inline struct hugepage_subpool *h
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
@@ -1028,11 +1020,6 @@ static inline struct hugepage_subpool *h
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

mm-hugetlb-remove-hugetlb_page_subpool.patch

