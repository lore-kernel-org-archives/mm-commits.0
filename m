Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93952C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 07:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73C3161058
	for <mm-commits@archiver.kernel.org>; Tue, 28 Sep 2021 07:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbhI1HY4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Sep 2021 03:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236713AbhI1HY4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Sep 2021 03:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC9DD61058;
        Tue, 28 Sep 2021 07:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632813797;
        bh=QaPGNf8ZikLv69Jhcqeoagc6kGLnH16GeateFFZX6io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:From;
        b=glN/AMsvDYmLy4P1ilUtXPNFhHlHcfVtj6yVThvfi+Eez2cOWZomynPxKucXsXi7m
         roxj7yOvaOoDNDeGnPV7WS56wE98ib1OMqQ5lvsNSLqItQLQiuYD7h81k5A8DZ6+EO
         sKva4x2qOUpe7ZzZq81+KxqrVoAaeEzFI4bnbn1LHQXHtu9HDl5v3a0LkjYyH1vinQ
         /Gkv48n+Dl/VKsgzlJ16K/T150DFm+FxQnjweux1R99V6LBPxZ/eKg5sWIJtCvUAVs
         0gb74tLF74kH/Jra8ZNHnC9RH5vuF2Z3rxGobJNsxx+5I3V2koflBKgz3G5xic/CyK
         7C4MjfHSJ0OXw==
From:   SeongJae Park <sj@kernel.org>
Cc:     changbin.du@gmail.com, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject: Re: + mm-damon-remove-unnecessary-do_exit-from-kdamond.patch added to -mm tree
Date:   Tue, 28 Sep 2021 07:23:14 +0000
Message-Id: <20210928072314.14788-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210928000908.31Gnc7g__%akpm@linux-foundation.org>
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

> 
> The patch titled
>      Subject: mm/damon: remove unnecessary do_exit() from kdamond
> has been added to the -mm tree.  Its filename is
>      mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
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
> Subject: mm/damon: remove unnecessary do_exit() from kdamond
> 
> Just return from the kthread function.
> 
> Link: https://lkml.kernel.org/r/20210927232421.17694-1-changbin.du@gmail.com
> Signed-off-by: Changbin Du <changbin.du@gmail.com>
> Cc: SeongJae Park <sjpark@amazon.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

> ---
> 
>  mm/damon/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/damon/core.c~mm-damon-remove-unnecessary-do_exit-from-kdamond
> +++ a/mm/damon/core.c
> @@ -714,7 +714,7 @@ static int kdamond_fn(void *data)
>  	nr_running_ctxs--;
>  	mutex_unlock(&damon_lock);
>  
> -	do_exit(0);
> +	return 0;
>  }
>  
>  #include "core-test.h"
> _
> 
> Patches currently in -mm which might be from changbin.du@gmail.com are
> 
> mm-damon-remove-unnecessary-do_exit-from-kdamond.patch
> mm-damon-neednt-hold-kdamond_lock-to-print-pid-of-kdamond.patch
