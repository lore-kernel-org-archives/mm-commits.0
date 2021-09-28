Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113B4C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 07:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8CBD60F12
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 07:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239304AbhI1HdL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 03:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239300AbhI1HdK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 03:33:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4225D6108E;
        Tue, 28 Sep 2021 07:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632814291;
        bh=LfpWa9su7wKeKLItmwN/YYhe7FIQPDhtkow3w9knefU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:From;
        b=tnW1XWvOdjeaN8f8dB16FJX2a6U7wGBmMEntNxZhkYoTvd26bmJ8PqQkNe36wuDct
         02LkX/Yxnfb5G53ZInA2e2EqCR0vGY/dGeNfSX5g4pzFx3xmBkx/aKdjLkHQEfJqhL
         gneLpyFGpvwa4lrhtyALKkY3rdo15ZDD3mTqMWEjZtAj6nmpbgpujJ1Q4ntLHyBEnt
         WtqZHl2pNPcmLSHygNLDYwdABxCXQ55JCgekYTzOVbfhk4sTWz5wVHp0d6eRsHsbbA
         qLJdYNxx8Rz35mRaopSgr3aerx5mDVnA6lVj16flTkxRCpL47uvSR4SbFcOoRPHUZ2
         EZzs/dKbcWfDA==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject: Re: + mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch added to -mm tree
Date:   Tue, 28 Sep 2021 07:31:24 +0000
Message-Id: <20210928073124.14874-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210928000911.YcLcDNX2u%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 27 Sep 2021 17:09:11 -0700 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      Subject: mm/damon: needn't hold kdamond_lock to print pid of kdamond
> has been added to the -mm tree.  Its filename is
>      mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Changbin Du <changbin.du@gmail.com>
> Subject: mm/damon: needn't hold kdamond_lock to print pid of kdamond
> 
> Just get the pid by 'current->pid'.

Looks good to me :)

> Meanwhile, to be symmetrical make the 'starts' and 'finishes' logs both info
> level.

We want to log those consistently using 'pr_debug()'[1].  I guess Andrew has
already updated the patch to use 'pr_debug()', but didn't update this commit
message.

Andrew, could you please update above commit message?

[1] https://lore.kernel.org/mm-commits/20210919232257.ZFV1L%25akpm@linux-foundation.org/

> 
> Link: https://lkml.kernel.org/r/20210927232432.17750-1-changbin.du@gmail.com
> Signed-off-by: Changbin Du <changbin.du@gmail.com>
> Cc: SeongJae Park <sjpark@amazon.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

> ---
> 
>  mm/damon/core.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> --- a/mm/damon/core.c~mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond
> +++ a/mm/damon/core.c
> @@ -652,9 +652,7 @@ static int kdamond_fn(void *data)
>  	unsigned int max_nr_accesses = 0;
>  	unsigned long sz_limit = 0;
>  
> -	mutex_lock(&ctx->kdamond_lock);
> -	pr_debug("kdamond (%d) starts\n", ctx->kdamond->pid);
> -	mutex_unlock(&ctx->kdamond_lock);
> +	pr_debug("kdamond (%d) starts\n", current->pid);
>  
>  	if (ctx->primitive.init)
>  		ctx->primitive.init(ctx);
> @@ -705,7 +703,7 @@ static int kdamond_fn(void *data)
>  	if (ctx->primitive.cleanup)
>  		ctx->primitive.cleanup(ctx);
>  
> -	pr_debug("kdamond (%d) finishes\n", ctx->kdamond->pid);
> +	pr_debug("kdamond (%d) finishes\n", current->pid);
>  	mutex_lock(&ctx->kdamond_lock);
>  	ctx->kdamond = NULL;
>  	mutex_unlock(&ctx->kdamond_lock);
> _
> 
> Patches currently in -mm which might be from changbin.du@gmail.com are
> 
> mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
> mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch
