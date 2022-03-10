Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730A8C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Mar 2022 03:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbiCJDiR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 22:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiCJDiO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 22:38:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5455195A04
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 19:37:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 022DDB8245B
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 03:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D624C340EB;
        Thu, 10 Mar 2022 03:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646883431;
        bh=gijTONhScB/fLvP6e1ZiXIEg6m5+IdqJY35TNu2Tydk=;
        h=Date:To:From:Subject:From;
        b=sYJFcmSaPlmhJKJ9duzs3feLSok/AX7jlJR1GEHcrrfMaIRHqD29diUlheiGRrWgs
         DWMphVC+RWEOlNNhQc3YS1IT7OeAYKivd5SySktJ0G4f2sGZldsBVC4Y53GBkU03ax
         w1rbT4rnPEWX0yt6hQwNqBGHG4xuoFU/LdB29NGw=
Date:   Wed, 09 Mar 2022 19:37:10 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-set-pagehwpoison-after-taking-page-lock-in-memory_failure_hugetlb.patch removed from -mm tree
Message-Id: <20220310033711.7D624C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: set PageHWPoison after taking page lock in memory_failure_hugetlb()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-set-pagehwpoison-after-taking-page-lock-in-memory_failure_hugetlb.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: set PageHWPoison after taking page lock in memory_failure_hugetlb()

There is a race condition between memory_failure_hugetlb() and hugetlb
free/demotion, which causes setting PageHWPoison flag on the wrong page
(which was a hugetlb when memory_failrue() was called, but was removed or
demoted when memory_failure_hugetlb() is called).  This results in killing
wrong processes.  So set PageHWPoison flag with holding page lock,

Link: https://lkml.kernel.org/r/20220309091449.2753904-1-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-set-pagehwpoison-after-taking-page-lock-in-memory_failure_hugetlb
+++ a/mm/memory-failure.c
@@ -1496,24 +1496,11 @@ static int memory_failure_hugetlb(unsign
 	int res;
 	unsigned long page_flags;
 
-	if (TestSetPageHWPoison(head)) {
-		pr_err("Memory failure: %#lx: already hardware poisoned\n",
-		       pfn);
-		res = -EHWPOISON;
-		if (flags & MF_ACTION_REQUIRED)
-			res = kill_accessing_process(current, page_to_pfn(head), flags);
-		return res;
-	}
-
-	num_poisoned_pages_inc();
-
 	if (!(flags & MF_COUNT_INCREASED)) {
 		res = get_hwpoison_page(p, flags);
 		if (!res) {
 			lock_page(head);
 			if (hwpoison_filter(p)) {
-				if (TestClearPageHWPoison(head))
-					num_poisoned_pages_dec();
 				unlock_page(head);
 				return -EOPNOTSUPP;
 			}
@@ -1535,13 +1522,16 @@ static int memory_failure_hugetlb(unsign
 	page_flags = head->flags;
 
 	if (hwpoison_filter(p)) {
-		if (TestClearPageHWPoison(head))
-			num_poisoned_pages_dec();
 		put_page(p);
 		res = -EOPNOTSUPP;
 		goto out;
 	}
 
+	if (TestSetPageHWPoison(head))
+		goto already_hwpoisoned;
+
+	num_poisoned_pages_inc();
+
 	/*
 	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
 	 * simply disable it. In order to make it work properly, we need
@@ -1567,6 +1557,13 @@ static int memory_failure_hugetlb(unsign
 out:
 	unlock_page(head);
 	return res;
+already_hwpoisoned:
+	unlock_page(head);
+	pr_err("Memory failure: %#lx: already hardware poisoned\n", pfn);
+	res = -EHWPOISON;
+	if (flags & MF_ACTION_REQUIRED)
+		res = kill_accessing_process(current, page_to_pfn(head), flags);
+	return res;
 }
 
 static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-remove-obsolete-comment.patch
mm-hwpoison-fix-error-page-recovered-but-reported-not-recovered.patch

