Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A64C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357409AbiCYBeV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357551AbiCYBdR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BA9BD8AE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C374CB8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D45C340ED;
        Fri, 25 Mar 2022 01:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171902;
        bh=O/gVcw2DwJe61moPQ99EDRSbCHoyX32eKL8OTzjw9RQ=;
        h=Date:To:From:Subject:From;
        b=yeNQjX9X+bjb2LQFKYwIoz8jDcNAiq/RJmpRtrO+UNOj0KYNNGJ2kM4f4twgt8Wiq
         oef+lJiuhgrmpcP07aI9T2WywS7xwbnxnYHjE6t5F8K22z3AyqfBFrAT1QyjCqFWqj
         iGvRuOEU8DDPfds3rREm+prPcJ88ut+kLTVsTs9o=
Date:   Thu, 24 Mar 2022 18:31:41 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch removed from -mm tree
Message-Id: <20220325013142.56D45C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: fix race with changing page more robustly
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: fix race with changing page more robustly

We're only intended to deal with the non-Compound page after we split thp
in memory_failure.  However, the page could have changed compound pages
due to race window.  If this happens, we could retry once to hopefully
handle the page next round.  Also remove unneeded orig_head.  It's always
equal to the hpage.  So we can use hpage directly and remove this
redundant one.

Link: https://lkml.kernel.org/r/20220218090118.1105-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-fix-race-with-changing-page-more-robustly
+++ a/mm/memory-failure.c
@@ -1686,7 +1686,6 @@ int memory_failure(unsigned long pfn, in
 {
 	struct page *p;
 	struct page *hpage;
-	struct page *orig_head;
 	struct dev_pagemap *pgmap;
 	int res = 0;
 	unsigned long page_flags;
@@ -1732,7 +1731,7 @@ try_again:
 		goto unlock_mutex;
 	}
 
-	orig_head = hpage = compound_head(p);
+	hpage = compound_head(p);
 	num_poisoned_pages_inc();
 
 	/*
@@ -1813,10 +1812,21 @@ try_again:
 	lock_page(p);
 
 	/*
-	 * The page could have changed compound pages during the locking.
-	 * If this happens just bail out.
+	 * We're only intended to deal with the non-Compound page here.
+	 * However, the page could have changed compound pages due to
+	 * race window. If this happens, we could try again to hopefully
+	 * handle the page next round.
 	 */
-	if (PageCompound(p) && compound_head(p) != orig_head) {
+	if (PageCompound(p)) {
+		if (retry) {
+			if (TestClearPageHWPoison(p))
+				num_poisoned_pages_dec();
+			unlock_page(p);
+			put_page(p);
+			flags &= ~MF_COUNT_INCREASED;
+			retry = false;
+			goto try_again;
+		}
 		action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
 		res = -EBUSY;
 		goto unlock_page;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

