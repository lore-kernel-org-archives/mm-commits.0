Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B5EC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiEJEPm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiEJEO7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B92527B0B
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29D8EB81AEF
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD91CC385C2;
        Tue, 10 May 2022 04:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155857;
        bh=KSF3IGwtmYAK0jRxz3c91uzH9E9Bix7ydXFJtlUaOgo=;
        h=Date:To:From:Subject:From;
        b=Dm/zvC48cLWxMKhl5A5DuFMrBYNrVikQpkDCJX45//CNckSVFPSl+0Pkj7aP54YJR
         wQnKdbulG7EGM6FxrQx5L5pFQTW9ViNcbuspUvmMJ1Umxpb9Q8J9iEZLhS7Ab9dKE2
         cWtL86ag6+Z2XjHx7T7aiGz2GSLbsZdjq1Adnh3k=
Date:   Mon, 09 May 2022 21:10:57 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        dan.carpenter@oracle.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch removed from -mm tree
Message-Id: <20220510041057.CD91CC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm/memory-failure.c: fix race with changing page compound again"
has been removed from the -mm tree.  Its filename was
     revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Revert "mm/memory-failure.c: fix race with changing page compound again"

Reverts commit 888af2701db7 ("mm/memory-failure.c: fix race with changing
page compound again") because now we fetch the page refcount under
hugetlb_lock in try_memory_failure_hugetlb() so that the race check is no
longer necessary.

Link: https://lkml.kernel.org/r/20220408135323.1559401-4-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 -
 include/ras/ras_event.h |    1 -
 mm/memory-failure.c     |   11 -----------
 3 files changed, 13 deletions(-)

--- a/include/linux/mm.h~revert-mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/include/linux/mm.h
@@ -3251,7 +3251,6 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
-	MF_MSG_DIFFERENT_PAGE_SIZE,
 	MF_MSG_UNKNOWN,
 };
 
--- a/include/ras/ras_event.h~revert-mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/include/ras/ras_event.h
@@ -374,7 +374,6 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_BUDDY, "free buddy page" )				\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
-	EM ( MF_MSG_DIFFERENT_PAGE_SIZE, "different page size" )	\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
--- a/mm/memory-failure.c~revert-mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/mm/memory-failure.c
@@ -733,7 +733,6 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
-	[MF_MSG_DIFFERENT_PAGE_SIZE]	= "different page size",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1605,16 +1604,6 @@ retry:
 		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
-	/*
-	 * The page could have changed compound pages due to race window.
-	 * If this happens just bail out.
-	 */
-	if (!PageHuge(p) || compound_head(p) != head) {
-		action_result(pfn, MF_MSG_DIFFERENT_PAGE_SIZE, MF_IGNORED);
-		res = -EBUSY;
-		goto out;
-	}
-
 	page_flags = head->flags;
 
 	/*
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


