Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE48C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 08:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiDYIkd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 04:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiDYIkc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 04:40:32 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216DD6A03A
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 01:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LyiGOHkn8ewqfiHfAcRDUVz9K3dHfRuS7M+KepzK9NY=; b=PArCvLYQYdch8TkYlnndDs9iGQ
        bUSxBVwkNA87ubXg/2xrDAlFfPgrEi+1oz3rJ23kKTBK8ukKDawtIqrgZd9RLNhRBXRcHVu40yKCc
        vlkKAgflty8j1vKvLv4vW7na8Y1RIMeNzdVrQs5jUw7Tc+xVPetD6t/gYdcyMvf7iAQ+ZnG2YNMMQ
        OGFqR2T66efwXuSQYQocW58dr/ZqWjj5105gc3xW0edf1U8saZ8dj6qJhfeCJUuqDKoGa8yxqXLED
        D92gLoiPa6RhHVxmFfmjmEZrOYLx4qdlcCOuebbsPk2zUI5VYNhR1BKAkRq8qFi8jIma6FAa7kVXa
        telsGmCw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niuDj-008V8X-NB; Mon, 25 Apr 2022 08:37:23 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4D51B980BF1; Mon, 25 Apr 2022 10:37:23 +0200 (CEST)
Date:   Mon, 25 Apr 2022 10:37:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, axboe@kernel.dk, chenwandun@huawei.com
Subject: Re: +
 mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio.patch added to
 -mm tree
Message-ID: <20220425083723.GB2731@worktop.programming.kicks-ass.net>
References: <20220422205413.C4DF4C385A0@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422205413.C4DF4C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 22, 2022 at 01:54:13PM -0700, Andrew Morton wrote:

> From: Chen Wandun <chenwandun@huawei.com>
> Subject: mm: rework calculation of bdi_min_ratio in bdi_set_min_ratio
> 
> In function bdi_set_min_ratio, min_ratio is unsigned int, it will
> result underflow when setting min_ratio below bdi->min_ratio, it
> is confusing. Rework it, no functional change.
> 
> Link: https://lkml.kernel.org/r/20220422095159.2858305-1-chenwandun@huawei.com
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/page-writeback.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> --- a/mm/page-writeback.c~mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio
> +++ a/mm/page-writeback.c
> @@ -650,18 +650,25 @@ static unsigned int bdi_min_ratio;
>  
>  int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
>  {
> +	unsigned int delta;
>  	int ret = 0;
>  
>  	spin_lock_bh(&bdi_lock);
>  	if (min_ratio > bdi->max_ratio) {
>  		ret = -EINVAL;
>  	} else {

> -		min_ratio -= bdi->min_ratio;
> -		if (bdi_min_ratio + min_ratio < 100) {
> -			bdi_min_ratio += min_ratio;
> -			bdi->min_ratio += min_ratio;
>  		} else {
> -			ret = -EINVAL;

I really don't see the why we're doing this, code gets to be worse, for
no actual gain.

> +		if (min_ratio < bdi->min_ratio) {
> +			delta = bdi->min_ratio - min_ratio;
> +			bdi_min_ratio -= delta;
> +			bdi->min_ratio = min_ratio;
>  		} else {
> +			delta = min_ratio - bdi->min_ratio;
> +			if (bdi_min_ratio + delta < 100) {
> +				bdi_min_ratio += delta;
> +				bdi->min_ratio = min_ratio;
> +			} else {
> +				ret = -EINVAL;
> +			}
>  		}

>  	}
