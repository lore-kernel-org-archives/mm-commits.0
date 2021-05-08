Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B91C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF3A260233
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWxJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWxI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A81A061402;
        Sat,  8 May 2021 22:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514326;
        bh=YAFY/FjiFbTU4xoVRNd6sws0Z/cgz8YdemCVyNenhNE=;
        h=Date:From:To:Subject:From;
        b=E6EeFyBJupgGg0IcG9fR4kF6RzuMcgLY18K2E93ZEAf3z9xhaoVKjGVxvGB45nbeF
         nnvDjBxbKt5tswQ73/dWk8MxmLt7CdvqwNuzD9r9VnSD9gWid5+WMqd6sIGk+j6Eft
         I31fyYCw/nCAw5/w6MxWBWFb3y9fv9wt+BCRMOxA=
Date:   Sat, 08 May 2021 15:52:06 -0700
From:   akpm@linux-foundation.org
To:     linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, tj@kernel.org
Subject:  [merged] kernel-asyncc-fix-pr_debug-statement.patch
 removed from -mm tree
Message-ID: <20210508225206.vbpy_v2NB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/async.c: fix pr_debug statement
has been removed from the -mm tree.  Its filename was
     kernel-asyncc-fix-pr_debug-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are


