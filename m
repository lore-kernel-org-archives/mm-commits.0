Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B586C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1610560F26
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhKKCve (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234443AbhKKCve (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 924C1610A2;
        Thu, 11 Nov 2021 02:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598925;
        bh=DTMiXZuPj2foIfdvWg49eZjxdYzc81KI1Z9PvNzWzac=;
        h=Date:From:To:Subject:From;
        b=0tRl4ABInpZOKNtVAGl8PooUGuIYRviAj9WF6Ul0jBRCQxS6zJBlSDtAwXERhn46N
         nq3BG7v2n0H6LrcJXL5G4pZBC7whkit4qHZ2xTfqxE+f/do/0MlPBVSmEKHv/JThqa
         QeS2WN1RfH0Ubge/Gv0hy0d+hX6e+kg1DBhWjgD0=
Date:   Wed, 10 Nov 2021 18:48:45 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org,
        sjpark@amazon.de
Subject:  [merged]
 mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch removed from
 -mm tree
Message-ID: <20211111024845.Dd6P2aAKb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: print kdamond start log in debug mode only
has been removed from the -mm tree.  Its filename was
     mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


