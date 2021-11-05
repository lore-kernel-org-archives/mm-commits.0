Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B413C43219
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D4961288
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhKEUs4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233759AbhKEUsx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E9736128E;
        Fri,  5 Nov 2021 20:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145173;
        bh=3i89PQ7nij2ffc9bwDtJ1DYgHE4O3FbG1Cw9fmK7GFc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hDQxVMyS4wZ7X3HjpX8l5qkBWgibA6/WkpQZ0VOnKSv2dIcBPwg9CXD7rFaiTnf5s
         I80ATNyICfMWs8uovq7oCuI3PMVY4T516aYCxzr4/eGhzW8/MfCstjibMskvxsyMsN
         45G0MnDhWXD8UKzuH5Sy5DP0Dh9jZVAD4+l/ZK4E=
Date:   Fri, 05 Nov 2021 13:46:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, changbin.du@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 221/262] mm/damon: needn't hold kdamond_lock to
 print pid of kdamond
Message-ID: <20211105204612.z0ZosYrZ6%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>
Subject: mm/damon: needn't hold kdamond_lock to print pid of kdamond

Just get the pid by 'current->pid'. Meanwhile, to be symmetrical make
the 'starts' and 'finishes' logs both use debug level.

Link: https://lkml.kernel.org/r/20210927232432.17750-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
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
