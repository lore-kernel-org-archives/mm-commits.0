Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E34C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 12:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2145F6135E
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 12:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344496AbhKRMID (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 07:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344494AbhKRMIA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 07:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD76F6120A;
        Thu, 18 Nov 2021 12:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637237100;
        bh=7Lwd3r9Om9CYIrPizX7sX+chmKtZvJJYBNYHqFpHmHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:From;
        b=co865HRzQPUH9xlVTJbSsykGIXpgMbq5hjQ7+C9J+8XWdGPV2Jh4ooPXftbrhQHZ8
         sfMGBS6NBC18uwH8en0dmVor5KLQsiUf3Mxy1/bdBrc2CGPtTyKRasK16piu9ukWit
         HkW5d+98LCq5N1cVsllPkfDtj97zMjUHhQT6okdz8RdH/m4wjdvBlyUM7d8jnXJK9n
         9uokkYsQOjOQiu65a1TgKDQMosVHazxUOIG3UTFo20opcGlWAZU2r53SQHTXkRVRwv
         jY+39mO+JrSHITHH6C2RecQjlusJ2hF5L5acDHiLja8tuP9hRC4fyGxNUmvPc+NtCa
         n5gBbp89kupaA==
From:   SeongJae Park <sj@kernel.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     akpm@linux-foundation.org, xhao@linux.alibaba.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org
Subject: Re: [PATCH] mm/damon: Fixup trivial nits in mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch
Date:   Thu, 18 Nov 2021 12:04:47 +0000
Message-Id: <20211118120447.20301-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118114827.20052-1-sj@kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

CC-ing mm-commits.


Thanks,
SJ

On Thu, 18 Nov 2021 11:48:27 +0000 SeongJae Park <sj@kernel.org> wrote:

> mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch[1],
> which is merged in -mm but mainline yet, is making unnecessary function
> prototype position changes in the damon.h.  This could make later
> 'git-blame' a little bit complex.  It also violates the 80 columns
> limit, which is not madated but preferred and all other code of DAMON is
> following.
> 
> This commit fixes those.  This should be folded into the patch before it
> is sent to Linus.
> 
> [1] https://lore.kernel.org/mm-commits/20211115174837.wvyS8FbLx%25akpm@linux-foundation.org/
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 4 ++--
>  mm/damon/paddr.c      | 5 +++--
>  mm/damon/vaddr.c      | 8 +++++---
>  3 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 82c0888eeab7..1d1be348f506 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -461,13 +461,13 @@ int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
>  #endif	/* CONFIG_DAMON */
>  
>  #ifdef CONFIG_DAMON_VADDR
> -void damon_va_set_primitives(struct damon_ctx *ctx);
>  bool damon_va_target_valid(void *t);
> +void damon_va_set_primitives(struct damon_ctx *ctx);
>  #endif	/* CONFIG_DAMON_VADDR */
>  
>  #ifdef CONFIG_DAMON_PADDR
> -void damon_pa_set_primitives(struct damon_ctx *ctx);
>  bool damon_pa_target_valid(void *t);
> +void damon_pa_set_primitives(struct damon_ctx *ctx);
>  #endif	/* CONFIG_DAMON_PADDR */
>  
>  #endif	/* _DAMON_H */
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5c3a29d32638..4318134cbc4c 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -246,8 +246,9 @@ static int damon_pa_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
>  	return 0;
>  }
>  
> -static int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
> -		struct damon_region *r, struct damos *scheme)
> +static int damon_pa_scheme_score(struct damon_ctx *context,
> +		struct damon_target *t, struct damon_region *r,
> +		struct damos *scheme)
>  {
>  	switch (scheme->action) {
>  	case DAMOS_PAGEOUT:
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index b18ec8b4f3c6..79481f0c2838 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -281,7 +281,8 @@ static void damon_va_init(struct damon_ctx *ctx)
>   *
>   * Returns true if it is.
>   */
> -static bool damon_intersect(struct damon_region *r, struct damon_addr_range *re)
> +static bool damon_intersect(struct damon_region *r,
> +		struct damon_addr_range *re)
>  {
>  	return !(r->ar.end <= re->start || re->end <= r->ar.start);
>  }
> @@ -623,8 +624,9 @@ static int damon_va_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
>  	return damos_madvise(t, r, madv_action);
>  }
>  
> -static int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
> -		struct damon_region *r, struct damos *scheme)
> +static int damon_va_scheme_score(struct damon_ctx *context,
> +		struct damon_target *t, struct damon_region *r,
> +		struct damos *scheme)
>  {
>  
>  	switch (scheme->action) {
> -- 
> 2.17.1
