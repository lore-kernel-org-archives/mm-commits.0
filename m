Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28C5C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD53361205
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 00:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238266AbhI1AKu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238255AbhI1AKu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 20:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C238061181;
        Tue, 28 Sep 2021 00:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632787751;
        bh=G9Bb2CyLTpqq6+sW1jfjTIIzdX/rgKTvTMWzze5UlCg=;
        h=Date:From:To:Subject:From;
        b=hRdNfKjpP9LZi+0I8eybntldlQ7KRDlssHxBSD9vL3lrdHFjR9mSQk54uQByXsg/r
         gsxHMJrhfN8Y9QCa316iIf5L9krhrnw7drX926BbPwdr3nK3k3PQSlQASls9RPUVAz
         pIjSXWHmj8oNQhPBD3m9xNw9V2gMTBDBdtezkJR8=
Date:   Mon, 27 Sep 2021 17:09:11 -0700
From:   akpm@linux-foundation.org
To:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject:  +
 mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch added to
 -mm tree
Message-ID: <20210928000911.YcLcDNX2u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: needn't hold kdamond_lock to print pid of kdamond
has been added to the -mm tree.  Its filename is
     mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changbin Du <changbin.du@gmail.com>
Subject: mm/damon: needn't hold kdamond_lock to print pid of kdamond

Just get the pid by 'current->pid'. Meanwhile, to be symmetrical make
the 'starts' and 'finishes' logs both info level.

Link: https://lkml.kernel.org/r/20210927232432.17750-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond
+++ a/mm/damon/core.c
@@ -652,9 +652,7 @@ static int kdamond_fn(void *data)
 	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
 
-	mutex_lock(&ctx->kdamond_lock);
-	pr_debug("kdamond (%d) starts\n", ctx->kdamond->pid);
-	mutex_unlock(&ctx->kdamond_lock);
+	pr_debug("kdamond (%d) starts\n", current->pid);
 
 	if (ctx->primitive.init)
 		ctx->primitive.init(ctx);
@@ -705,7 +703,7 @@ static int kdamond_fn(void *data)
 	if (ctx->primitive.cleanup)
 		ctx->primitive.cleanup(ctx);
 
-	pr_debug("kdamond (%d) finishes\n", ctx->kdamond->pid);
+	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
_

Patches currently in -mm which might be from changbin.du@gmail.com are

mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch

