Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97FAC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD19E60F93
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhISXYY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISXYY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:24:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 695C960F93;
        Sun, 19 Sep 2021 23:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632093778;
        bh=BmWJpxKgyJD5d3nFPfDbKqiuKmuoSGgAQI+AugHBmA8=;
        h=Date:From:To:Subject:From;
        b=Gli02ly6Fk23ANcupq7qugbVSbNfi0P3BZF/gKeEKauvIHl4D/TfGXONrK9WFS029
         fVrhiQWYhhvPPTUQFw8KZI3HUEte2H7pZlJDLQ3/5UxPvPxfCUuBkCFYoE6WKdcrMf
         MxIJcNxoZ+xnjlr5SXP/uXiGA1T5wgrMnmHr04m8=
Date:   Sun, 19 Sep 2021 16:22:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjpark@amazon.de, corbet@lwn.net,
        sj@kernel.org
Subject:  +
 mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch added to -mm
 tree
Message-ID: <20210919232257.ZFV1L%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: print kdamond start log in debug mode only
has been added to the -mm tree.  Its filename is
     mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: print kdamond start log in debug mode only

Logging of kdamond startup is using 'pr_info()' unnecessarily.  This
commit makes it to use 'pr_debug()' instead.

Link: https://lkml.kernel.org/r/20210917123958.3819-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-print-kdamond-start-log-in-debug-mode-only
+++ a/mm/damon/core.c
@@ -653,7 +653,7 @@ static int kdamond_fn(void *data)
 	unsigned long sz_limit = 0;
 
 	mutex_lock(&ctx->kdamond_lock);
-	pr_info("kdamond (%d) starts\n", ctx->kdamond->pid);
+	pr_debug("kdamond (%d) starts\n", ctx->kdamond->pid);
 	mutex_unlock(&ctx->kdamond_lock);
 
 	if (ctx->primitive.init)
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch

