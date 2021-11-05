Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0F3C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 854126136A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhKEUsy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233752AbhKEUsr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C1EE61288;
        Fri,  5 Nov 2021 20:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145167;
        bh=NRDUh2MdEyFRB0KledZvV54NdO0zcH9XWhGWSwoPEzw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uAnuQqciTDUsVLwlmw4Xxg+vscxCFLrsD7iWs4cP6vHp3QbS91+hHrk6yvCGF79oE
         Oofa0f/Qr7JuWfGJsoQUBsNRb6aFe02e7E+GwsOEQSLCGV45K0sbHTMJU/CJPUQ2jq
         WPcPTLL13FxannVHewoe5eGeZFcWVEIM6tn1tswg=
Date:   Fri, 05 Nov 2021 13:46:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org
Subject:  [patch 219/262] mm/damon/core: print kdamond start log in
 debug mode only
Message-ID: <20211105204606.buFORSv6G%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
