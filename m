Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CE2C43603
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E21564E38
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382084AbhCCNaz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235452AbhCCBmL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 20:42:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8E3464E28;
        Wed,  3 Mar 2021 01:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614735125;
        bh=HnFjK8d0LcqZgV9gaT+nifbFia4KhuG50g1vAegPz6w=;
        h=Date:From:To:Subject:From;
        b=YN4WidGW7cIsv9pbLsV15gAIllyqEvK5YxAb3Foy8EHoyvhI85jijD8Jo8X9TuIyi
         vy1hn3xxEzrtF1M0MjMXlYlc9Km4VCzE/SaTbulkFphZGRHfh2Nsd8sob5BN/z/g9N
         8XxuZ/IpTREd43hC0JpLSOdY3m8kcMh7Qke8pkeM=
Date:   Tue, 02 Mar 2021 17:32:04 -0800
From:   akpm@linux-foundation.org
To:     linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, tj@kernel.org
Subject:  + kernel-asyncc-fix-pr_debug-statement.patch added to -mm
 tree
Message-ID: <20210303013204.ONRO4YK2o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/async.c: fix pr_debug statement
has been added to the -mm tree.  Its filename is
     kernel-asyncc-fix-pr_debug-statement.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-asyncc-fix-pr_debug-statement.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-asyncc-fix-pr_debug-statement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-asyncc-fix-pr_debug-statement.patch

