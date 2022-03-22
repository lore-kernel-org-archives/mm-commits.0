Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DDAC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiCVVpy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbiCVVpu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1A85F4F1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD628615B1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3C2C340F4;
        Tue, 22 Mar 2022 21:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985462;
        bh=5knbsc9OlMkSq/1JDIMEwr7Iq1plkwPjCJe2HFT5o5s=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=MeK1pPSadAhOJHBjCXNBdOmV+lXNgwsEfcOI13rfFlmV9IErLT7PNfJfGbBAVpHrZ
         cbcxiG7B3uFjJbh0Uxn7g6odnIgKVY30iMto9aENL2BdtTrO8t+2c/pyvwk6/apStt
         gnte1kXO3Hf7vQjMK2HKUtlR4E2cXLaOvsipj5hk=
Date:   Tue, 22 Mar 2022 14:44:21 -0700
To:     naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 115/227] mm/memory-failure.c: fix race with changing page more robustly
Message-Id: <20220322214422.0F3C2C340F4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
