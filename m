Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69332C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 504F8613C5
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbhEGBDg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhEGBDg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E595C610FA;
        Fri,  7 May 2021 01:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349357;
        bh=y1vUADJOOL1aYGp0RytX30EBNMKTV0CNjr3HUvo4OZ4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q+y9ht+xP+rGoX5T6e1vJc55zQ2flXtN7mR3Vransomf/kYYxt5C2eMvMWlib+7sy
         WyEf5pILbADP8yfTocQDlu+y1V8mVpsijo+UBaZ2NPnebz13yv/4V91qsPQXvWqPfm
         i7RYIzuw+c+wnttFnKYbbJQxwZnUHhUrKEgZ0xp4=
Date:   Thu, 06 May 2021 18:02:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        tj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 12/91] kernel/async.c: fix pr_debug statement
Message-ID: <20210507010236.YunXYB9gc%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kernel/async.c: fix pr_debug statement

An async_func_t returns void - any errors encountered it has to stash
somewhere for consumers to discover later.

Link: https://lkml.kernel.org/r/20210226124355.2503524-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/async.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/async.c~kernel-asyncc-fix-pr_debug-statement
+++ a/kernel/async.c
@@ -124,7 +124,7 @@ static void async_run_entry_fn(struct wo
 	if (initcall_debug && system_state < SYSTEM_RUNNING) {
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		pr_debug("initcall %lli_%pS returned 0 after %lld usecs\n",
+		pr_debug("initcall %lli_%pS returned after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
 			(long long)ktime_to_ns(delta) >> 10);
_
