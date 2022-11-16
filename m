Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B08C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 01:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiKPBJ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiKPBJZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 20:09:25 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1F32FFE4
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 17:09:23 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 6so15209931pgm.6
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 17:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B4qSseVarX04Pnx0TvZzcKE5aShfKEBE4jk28L6jr24=;
        b=bbPftyn7t+8SWUOJ1LTrQOzxJC9hqUCDinetqx4IatFItXFrZYhTtz2R6y8P35Z5dD
         EGdDA/1mIguovDERij/NBbm9BpLc9iWIfAvD3yTSQBvFoseoFKulmJhfS+HX10PS2q81
         +QjMvJLtd06Xb+TNWL0pSJqSoJ5Xr+4hjbcj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B4qSseVarX04Pnx0TvZzcKE5aShfKEBE4jk28L6jr24=;
        b=b4ZDaKfOtU53DxQ51O3a97CeHW6f5jxIzEDGjm89P9ykBxgQGl7PeOOWWpquBuHa+c
         UgBPv3sAEv39vo2shxh5JQXfE7auV2S1Q70DbTG2Q8K63/P9p+VaYZoEZ0sEPLW3yZhX
         TkgwpnJaQrxt3qK5My2WYvzlt7xZMb/8dizHcFoSaNB5h63q0J0dTabnfPOppCJ4Uaxy
         3qTyvXWk8woEksilqruI7/jNrijt/klvOhwYH4YEKYLu9mfkdrTO611UhA34I9tt/mqe
         SKsp5d6WefwHHGYggQK+gxK59q2L1zWssiZOTHtJgiDlPY8TrpU1MC9DN4eYXrR7+dVI
         S3XQ==
X-Gm-Message-State: ANoB5pkLWCmbVqVPj3modtvWQ319+riw6Ztl+WJC7RKDP83oUujjILaI
        t773qggQVZRDe/lLMZdwyMBnKg==
X-Google-Smtp-Source: AA0mqf4KwbBK+Oz2UmDH5KB1HZa0xSkbN+pY4a7Kh5Jlp1UV0hZ4JLQpspMqbWWyPevZbV+8L+VzKg==
X-Received: by 2002:aa7:9839:0:b0:56b:d363:a31b with SMTP id q25-20020aa79839000000b0056bd363a31bmr20818741pfl.78.1668560963001;
        Tue, 15 Nov 2022 17:09:23 -0800 (PST)
Received: from google.com ([240f:75:7537:3187:9603:e3e0:aec4:58d5])
        by smtp.gmail.com with ESMTPSA id k18-20020aa79d12000000b0056b9ec7e2desm9400408pfp.125.2022.11.15.17.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 17:09:22 -0800 (PST)
Date:   Wed, 16 Nov 2022 10:09:17 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, suleiman@google.com, ngupta@vflare.org,
        keescook+coverity-bot@chromium.org, keescook@chromium.org,
        senozhatsky@chromium.org
Subject: Re: + zram-introduce-recompress-sysfs-knob-fix-2.patch added to
 mm-unstable branch
Message-ID: <Y3Q4PQ7nyI1F4LuP@google.com>
References: <20221115004212.CD9B7C433C1@smtp.kernel.org>
 <Y3QZmY9KyJWEDv5v@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3QZmY9KyJWEDv5v@google.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/11/15 14:58), Minchan Kim wrote:
> > --- a/drivers/block/zram/zram_drv.c~zram-introduce-recompress-sysfs-knob-fix-2
> > +++ a/drivers/block/zram/zram_drv.c
> > @@ -1689,6 +1689,7 @@ static int zram_recompress(struct zram *
> >  	 * Iterate the secondary comp algorithms list (in order of priority)
> >  	 * and try to recompress the page.
> >  	 */
> > +	prio_max = min(prio_max, ZRAM_MAX_COMPS);
> >  	for (; prio < prio_max; prio++) {
> >  		if (!zram->comps[prio])
> >  			continue;
> > _
> 
> Hi Andrew,
> 
> Please drop this patch. It makes reviewer think "oh, zram_recompress
> pass the higher prio_max value than the one zram allowed by somehow
> so we need to get the min value here", which is not true once review
> read code again/again and scratch head and then post patch to remove
> the unncessary line. I prefer reviewer happier.

I don't disagree. Let's drop it.
