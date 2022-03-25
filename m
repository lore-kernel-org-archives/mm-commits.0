Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A12C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357412AbiCYBeY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357576AbiCYBd0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D60BF50E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3213B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90174C340EC;
        Fri, 25 Mar 2022 01:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171910;
        bh=cMPc6uB6kEPqfsi0bFVgj29CRG+81c4ciPhexrwDO0o=;
        h=Date:To:From:Subject:From;
        b=LtHHCqekTyNkS07u+C8V6y4TsfqCQm9PnU5aCKAFeloEwLxgOmLBdlLNQJhSPCwNN
         6YYrCE24q4/JYQdws92Ddi6qbXkJBtdJmWX+iceO4PWYSkbfCJomPCeUkYZdRphEPH
         ta6nTwoA2hjuZgkFW5GWp8VAXTAN8Bcak3g8E12w=
Date:   Thu, 24 Mar 2022 18:31:50 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, bp@alien8.de, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-fix-race-with-changing-page-compound-again.patch removed from -mm tree
Message-Id: <20220325013150.90174C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: fix race with changing page compound again
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: fix race with changing page compound again

Patch series "A few fixup patches for memory failure", v2.

This series contains a few patches to fix the race with changing page
compound page, make non-LRU movable pages unhandlable and so on.  More
details can be found in the respective changelogs.


There is a race window where we got the compound_head, the hugetlb page
could be freed to buddy, or even changed to another compound page just
before we try to get hwpoison page.  Think about the below race window:

  CPU 1					  CPU 2
  memory_failure_hugetlb
  struct page *head = compound_head(p);
					  hugetlb page might be freed to
					  buddy, or even changed to another
					  compound page.

  get_hwpoison_page -- page is not what we want now...

If this race happens, just bail out.  Also MF_MSG_DIFFERENT_PAGE_SIZE is
introduced to record this event.

[akpm@linux-foundation.org: s@/**@/*@, per Naoya Horiguchi]
Link: https://lkml.kernel.org/r/20220312074613.4798-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220312074613.4798-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 +
 include/ras/ras_event.h |    1 +
 mm/memory-failure.c     |   12 ++++++++++++
 3 files changed, 14 insertions(+)

--- a/include/linux/mm.h~mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/include/linux/mm.h
@@ -3239,6 +3239,7 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
+	MF_MSG_DIFFERENT_PAGE_SIZE,
 	MF_MSG_UNKNOWN,
 };
 
--- a/include/ras/ras_event.h~mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/include/ras/ras_event.h
@@ -374,6 +374,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_BUDDY, "free buddy page" )				\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
+	EM ( MF_MSG_DIFFERENT_PAGE_SIZE, "different page size" )	\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
--- a/mm/memory-failure.c~mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/mm/memory-failure.c
@@ -732,6 +732,7 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
+	[MF_MSG_DIFFERENT_PAGE_SIZE]	= "different page size",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1532,6 +1533,17 @@ static int memory_failure_hugetlb(unsign
 	}
 
 	lock_page(head);
+
+	/*
+	 * The page could have changed compound pages due to race window.
+	 * If this happens just bail out.
+	 */
+	if (!PageHuge(p) || compound_head(p) != head) {
+		action_result(pfn, MF_MSG_DIFFERENT_PAGE_SIZE, MF_IGNORED);
+		res = -EBUSY;
+		goto out;
+	}
+
 	page_flags = head->flags;
 
 	if (hwpoison_filter(p)) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

