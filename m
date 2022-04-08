Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6A9C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 23:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiDHXsN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 19:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236531AbiDHXsM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 19:48:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6AD2CE10
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 16:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD76462163
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 23:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E66C385A3;
        Fri,  8 Apr 2022 23:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649461566;
        bh=CwTCird+/hiwCsbT/3azGRPHOQpda8aYvDuzRlz0n1E=;
        h=Date:To:From:Subject:From;
        b=UPrChWZn3d6UA3UGhuzpHLlCXeelcUUS8l1xlgwVQcVpNisMx0ofrEzEM26G4a8rQ
         eereGl/36jzMmnW+bKz03qy8lRe+jGHlLDZ0+z0eUjk9Opl3H2xeVKSr8dWhO8+mxq
         UcCecioF2YMeAd3AjEC7p5PAN8AF28cyzw7p7BI8=
Date:   Fri, 08 Apr 2022 16:46:05 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        dan.carpenter@oracle.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch added to -mm tree
Message-Id: <20220408234606.32E66C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm/memory-failure.c: fix race with changing page compound again"
has been added to the -mm tree.  Its filename is
     revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
@@ -3292,7 +3292,6 @@ enum mf_action_page_type {
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
@@ -734,7 +734,6 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
-	[MF_MSG_DIFFERENT_PAGE_SIZE]	= "different page size",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1603,16 +1602,6 @@ retry:
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

mm-hwpoison-fix-race-between-hugetlb-free-demotion-and-memory_failure_hugetlb.patch
mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch
revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

