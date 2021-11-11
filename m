Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107BDC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E017961241
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhKKCvi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234443AbhKKCvi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9575B60F26;
        Thu, 11 Nov 2021 02:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598929;
        bh=rytkW8deFsvpDFrvtCtFe2qVjdwXB5RGsfXuJ7pnqL0=;
        h=Date:From:To:Subject:From;
        b=UArYbdMogwX+DPdGVMn3YpunlnWrjEPqedRWXwSd9l/9/hk8JZG71+P+FDvoqTDfQ
         4x4ENH35hILFCKMvAG/g8n4n8DxpgmN3KUhXAe2hc82p0I5S6wi48G3FSWMf/yWnQs
         U3zhVdLsd/+Pp7FxLjZVViQxqbSl6peuruS8yalY=
Date:   Wed, 10 Nov 2021 18:48:49 -0800
From:   akpm@linux-foundation.org
To:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch removed
 from -mm tree
Message-ID: <20211111024849._xS91pke_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: needn't hold kdamond_lock to print pid of kdamond
has been removed from the -mm tree.  Its filename was
     mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from changbin.du@gmail.com are


