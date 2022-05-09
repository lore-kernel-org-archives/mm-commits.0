Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C706CC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 23:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiEIXXR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 19:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiEIXXI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 19:23:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B4620F4E9
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 16:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A13FEB819CB
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 23:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309C4C385B3;
        Mon,  9 May 2022 23:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652138350;
        bh=iwNsT4qcKw4pEK6kT5MzXSCxo++tWSns7xd194q8I+U=;
        h=Date:To:From:Subject:From;
        b=vC+Ajns1lcz9XGzyVxQJ/X5qL5qr9uFPmtMeGJUfnuXnFr+Bs+X8jPlx6RwmSQJwC
         Kmg/famqptF5xdUVM59xUhmVzfjXn0YNFy3CKmSTEr0AnjFGH3yqlbc+ve/83ZjjMp
         IuOkrYh/9lNxMNjtSFKFyr0u4bMvvco00AfMISGc=
Date:   Mon, 09 May 2022 16:19:09 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-simplify-num_poisoned_pages_inc-dec.patch added to mm-unstable branch
Message-Id: <20220509231910.309C4C385B3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: simplify num_poisoned_pages_inc/dec
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failurec-simplify-num_poisoned_pages_inc-dec.patch

This patch should soon appear in the mm-unstable branch at
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
From: zhenwei pi <pizhenwei@bytedance.com>
Subject: mm/memory-failure.c: simplify num_poisoned_pages_inc/dec

Originally, do num_poisoned_pages_inc() in memory failure routine, use
num_poisoned_pages_dec() to rollback the number if filtered/ cancelled.

Suggested by Naoya, do num_poisoned_pages_inc() only in action_result(),
this make this clear and simple.

Link: https://lkml.kernel.org/r/20220509105641.491313-6-pizhenwei@bytedance.com
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

mm-memory-failurec-move-clear_hwpoisoned_pages.patch
mm-memory-failurec-simplify-num_poisoned_pages_dec.patch
mm-memory-failurec-add-hwpoison_filter-for-soft-offline.patch
mm-hwpoison-disable-hwpoison-filter-during-removing.patch
mm-memory-failurec-simplify-num_poisoned_pages_inc-dec.patch

