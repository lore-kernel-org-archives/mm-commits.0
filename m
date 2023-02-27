Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49667C6FA8E
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 03:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjB0DO3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 22:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjB0DOY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 22:14:24 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001571ABEE
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 19:14:20 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id bh1so5289135plb.11
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 19:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XiIQfLaVDvoCKN6tgoEV8M2nB4X44bUY3bnMRChmfXk=;
        b=k4NvlOOLoIgY7fp2yCM3XEr51HMJmmYLWhQf/jrMUQOIyL21RrHElwe+BXnonQvQeH
         7KjvaxmZwTx6EcpYtW8Oyj492urSRFqp4zeIM3/vLHuJILtXU3S3xc43kBdipMMLPpKQ
         nTJrrk8TZzvMT425/LcU4q/gkwqxPYpRpWFSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiIQfLaVDvoCKN6tgoEV8M2nB4X44bUY3bnMRChmfXk=;
        b=vcCj1Dl65t7sldkSLx/RPuEB014Mlc6muyKrEZoP8RSi2ADP/XUG3Qn/dpBqY2hEQQ
         MEYiUMzfJbdwAL1w1qkvx3/24q5NG0EOu6HaebUTvjEIfWaR69rAjx2fEcFRza516iIw
         7R00lOJAJzleAQJOAHNX0HhTnT/r3BBlZqybO3Jw6TV1m2x+9mY2ZTcY3iwzFMlcU05x
         kfjVb1LwsXR93lePeh1J/ImVsv9tzR8LK/nZ16bBSlt/i8ZL4yR20miQA2J+OuGFP3Lt
         zSS/c8gL9yRVWqkpjvItwPUcNBMF6OGzhLHLt9CsOTVbZzQLKRr3x6ZhzTJu5bL5CoXm
         zhVQ==
X-Gm-Message-State: AO0yUKVZWqgAg4yj6xKdWZ7FH3nqhk2tsj7NUKElnya7IzbplIROqIMj
        /9wq9bsHPFpQ7Px7EXV2Ta1OEg==
X-Google-Smtp-Source: AK7set+/RkLoB/lxX5R9uuCJE/PCaCqmKuJM4Abr9ew3nURtp81WLawORM1O48Bkr4V/5/SYvNYJpg==
X-Received: by 2002:a17:902:eccc:b0:19c:eda7:e0fd with SMTP id a12-20020a170902eccc00b0019ceda7e0fdmr7830052plh.59.1677467660217;
        Sun, 26 Feb 2023 19:14:20 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id 3-20020a170902c10300b00186b69157ecsm3312160pli.202.2023.02.26.19.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 19:14:19 -0800 (PST)
Date:   Mon, 27 Feb 2023 12:14:15 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yjay.kim@lge.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, minchan@kernel.org, ddstreet@ieee.org,
        taejoon.song@lge.com
Subject: Re: +
 mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages.patch added
 to mm-unstable branch
Message-ID: <Y/wgB0LpBau0YbVu@google.com>
References: <20230226215739.BD1CAC4339B@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230226215739.BD1CAC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/02/26 13:57), Andrew Morton wrote:
> The worst-case scenario on finding same element pages is that almost all
> elements are same at the first glance but only last few elements are
> different.
> 
> Since the same element tends to be grouped from the beginning of the
> pages, if we check the first element with the last element before looping
> through all elements, we might have some chances to quickly detect
> non-same element pages.
> 
> 1. Test is done under LG webOS TV (64-bit arch)
> 2. Dump the swap-out pages (~819200 pages)
> 3. Analyze the pages with simple test script which counts the iteration
>    number and measures the speed at off-line
> 
> Under 64-bit arch, the worst iteration count is PAGE_SIZE / 8 bytes = 512.
> The speed is based on the time to consume page_same_filled() function
> only.  The result, on average, is listed as below:
> 
>                                    Num of Iter    Speed(MB/s)
> Looping-Forward (Orig)                 38            99265
> Looping-Backward                       36           102725
> Last-element-check (This Patch)        33           125072
> 
> The result shows that the average iteration count decreases by 13% and the
> speed increases by 25% with this patch.  This patch does not increase the
> overall time complexity, though.
> 
> I also ran simpler version which uses backward loop.  Just looping
> backward also makes some improvement, but less than this patch.
> 
> A similar change has already been made to zram in 90f82cbfe502 ("zram: try
> to avoid worst-case scenario on same element pages").
> 
> Link: https://lkml.kernel.org/r/20230205190036.1730134-1-taejoon.song@lge.com
> Signed-off-by: Taejoon Song <taejoon.song@lge.com>
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Seth Jennings <sjenning@redhat.com>
> Cc: Taejoon Song <taejoon.song@lge.com>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: <yjay.kim@lge.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
