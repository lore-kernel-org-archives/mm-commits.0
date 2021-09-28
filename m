Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1500CC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 22:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA0866138D
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 22:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbhI1Wus (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 18:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238632AbhI1Wur (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 18:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E0016101A;
        Tue, 28 Sep 2021 22:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632869347;
        bh=nNy78tcaNGUVUjC0TAUSyNRCfV/i85E1LdIz1Wg8I20=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TG5vi6kFW3ZMutNvgFOaRZi9sdFA9NGYf8598+f3OuJxN2KvitbE0otKivOEKqY3q
         xe+3mQzomUtHSfQsRDiGKDpdPQYR1OVE0+l9GxfPer5dcihZKV+zugyr5XWRF/iW3O
         UDCvdocGkUZAn03OAawwoI7/ZiQT/9EGfY1PqcRg=
Date:   Tue, 28 Sep 2021 15:49:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject: Re: +
 mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch added to
 -mm tree
Message-Id: <20210928154906.24a727916edc995b5d7bd25f@linux-foundation.org>
In-Reply-To: <20210928073124.14874-1-sj@kernel.org>
References: <20210928000911.YcLcDNX2u%akpm@linux-foundation.org>
        <20210928073124.14874-1-sj@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 28 Sep 2021 07:31:24 +0000 SeongJae Park <sj@kernel.org> wrote:

> > Meanwhile, to be symmetrical make the 'starts' and 'finishes' logs both info
> > level.
> 
> We want to log those consistently using 'pr_debug()'[1].  I guess Andrew has
> already updated the patch to use 'pr_debug()', but didn't update this commit
> message.
> 
> Andrew, could you please update above commit message?

Done, thanks.


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

