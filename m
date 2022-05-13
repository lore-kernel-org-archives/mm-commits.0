Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E0AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383805AbiEMT17 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383894AbiEMTY2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:24:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427F030566
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A71C6CE3301
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF5AC34100;
        Fri, 13 May 2022 19:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469753;
        bh=PfW2TTbFw8+BMVLCrUct0u1b5GWXnRAyBi/kTmi3XWw=;
        h=Date:To:From:Subject:From;
        b=qTuadxoX78W6Q1lTjT12sHKXnlFDQbbacy69IEv4PzYOwX/L9WdSEyCfOj+lpRHUH
         l55J+AZ5qbdZ0moqdqHtGwV2tjCW6GhIQabB/6i4CTAiJIvEMkbdVnFuM2Z8KNo38/
         Vrmn88VJwdatWmeO6JN1ZZjsIabvBQl+U8ajTQV4=
Date:   Fri, 13 May 2022 12:22:32 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failurec-simplify-num_poisoned_pages_inc-dec.patch removed from -mm tree
Message-Id: <20220513192233.0EF5AC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure.c: simplify num_poisoned_pages_inc/dec
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-simplify-num_poisoned_pages_inc-dec.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhenwei pi <pizhenwei@bytedance.com>
Subject: mm/memory-failure.c: simplify num_poisoned_pages_inc/dec

Originally, do num_poisoned_pages_inc() in memory failure routine, use
num_poisoned_pages_dec() to rollback the number if filtered/ cancelled.

Suggested by Naoya, do num_poisoned_pages_inc() only in action_result(),
this make this clear and simple.

Link: https://lkml.kernel.org/r/20220509105641.491313-6-pizhenwei@bytedance.com
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-simplify-num_poisoned_pages_inc-dec
+++ a/mm/memory-failure.c
@@ -1132,6 +1132,7 @@ static void action_result(unsigned long
 {
 	trace_memory_failure_event(pfn, type, result);
 
+	num_poisoned_pages_inc();
 	pr_err("Memory failure: %#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 }
@@ -1587,8 +1588,6 @@ retry:
 		goto out;
 	}
 
-	num_poisoned_pages_inc();
-
 	/*
 	 * Handling free hugepage.  The possible race with hugepage allocation
 	 * or demotion can be prevented by PageHWPoison flag.
@@ -1806,7 +1805,6 @@ try_again:
 	}
 
 	hpage = compound_head(p);
-	num_poisoned_pages_inc();
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -1830,7 +1828,6 @@ try_again:
 					/* We lost the race, try again */
 					if (retry) {
 						ClearPageHWPoison(p);
-						num_poisoned_pages_dec();
 						retry = false;
 						goto try_again;
 					}
@@ -1893,8 +1890,7 @@ try_again:
 	 */
 	if (PageCompound(p)) {
 		if (retry) {
-			if (TestClearPageHWPoison(p))
-				num_poisoned_pages_dec();
+			ClearPageHWPoison(p);
 			unlock_page(p);
 			put_page(p);
 			flags &= ~MF_COUNT_INCREASED;
@@ -1916,8 +1912,7 @@ try_again:
 	page_flags = p->flags;
 
 	if (hwpoison_filter(p)) {
-		if (TestClearPageHWPoison(p))
-			num_poisoned_pages_dec();
+		TestClearPageHWPoison(p);
 		unlock_page(p);
 		put_page(p);
 		res = -EOPNOTSUPP;
_

Patches currently in -mm which might be from pizhenwei@bytedance.com are


