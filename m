Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3958C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 02:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE3C611CE
	for <mm-commits@archiver.kernel.org>; Mon, 12 Apr 2021 02:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbhDLCSw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 22:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbhDLCSv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Apr 2021 22:18:51 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4154C061574
        for <mm-commits@vger.kernel.org>; Sun, 11 Apr 2021 19:18:34 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id m18so3339396plc.13
        for <mm-commits@vger.kernel.org>; Sun, 11 Apr 2021 19:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xi8QIS7oxPO9G9BGpLagcjyFpfZxsAUBpS2OgUuKQC4=;
        b=j5ckaxzmPbe+5L+H7sP5DFb75G1acuNZqswVYgA13ZIbSPDFrQO9J4xjuy+X8uQ39M
         PjTA3F386fHXrNkqPDk9wTE0wQO1KnYbBwfB8bAX6cDBfdudHQmLV9uCbP/1gdiJfViq
         trqWZWr04TRhEoPg1siiwKMsBmPIeoEFpndDb1z6zWBiBlqUL+ebvzOPQk2Hd7jHRGIx
         Ryl5jgD4FHSfGvVZB594dbBCr9M48Fu2n4A4QclZUxsNnwPTCoE5n7Dymwa4l82Q0DjU
         UmpW6Ka9PL+5UHvlJ9/saSbQsDz2PdjGdONGnlZoms8TuUm4tjaRJWUG8B31MK2JcpJj
         YTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xi8QIS7oxPO9G9BGpLagcjyFpfZxsAUBpS2OgUuKQC4=;
        b=ZEZZVtKTleVBb1DrrP14GCpNqs9NcI3bKG/g9Dbssnc2BlipCXCVctkEMNisD2nICN
         Py3gcR/epWtKRjj+swOZSqcGH/H4z52uOSQ/tB9ijYX1HSESnzqBotE2x3oOxDGcKgTI
         chDHeE2B/1jaQMw+LncamUfpc8/l+X8LMoch55DpbiGabJVkKaaTmzlTKGruEyEV5cIB
         J61G/mSpAp9GzhaKyWH9Z8O0cs6LxwauJGifAXOGqlFqD7BL60FmBuy7bAdVAH9kCYel
         cfRWqlLX96hK8kS83hliIHGISfVaIbhEaPyqHaK/N4jSgWGosqlTtsGOX6pkFaPUYYGc
         Djrw==
X-Gm-Message-State: AOAM532FpZpPHBgirjrnZ+V13VUnNLsI52ucYVXNdxD8eVM+nhNlaDY4
        VU3tkdy8KuasyJImgBASMUbVQ3hj40UvWw==
X-Google-Smtp-Source: ABdhPJw+tuVDQ3oThk8mOQ6rPgbGGXP7jqwWEZiBJUAwY2T8zrqVgno+vniO/CRRcLuP5yREmIVfww==
X-Received: by 2002:a17:902:7281:b029:ea:afe2:b356 with SMTP id d1-20020a1709027281b02900eaafe2b356mr12481270pll.16.1618193914113;
        Sun, 11 Apr 2021 19:18:34 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id gb15sm9017670pjb.32.2021.04.11.19.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 19:18:33 -0700 (PDT)
Subject: Re: + fs-io_uringc-fix-build.patch added to -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
References: <20210412021748.X7M8F%akpm@linux-foundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b8ab6da7-a71f-35b8-752e-1f1578e33b4c@kernel.dk>
Date:   Sun, 11 Apr 2021 20:18:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210412021748.X7M8F%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 4/11/21 8:17 PM, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: fs-io_uringc-fix-build
> has been added to the -mm tree.  Its filename is
>      fs-io_uringc-fix-build.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/fs-io_uringc-fix-build.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/fs-io_uringc-fix-build.patch
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
> From: Jens Axboe <axboe@kernel.dk>
> Subject: fs-io_uringc-fix-build
> 
> Here's the bit from the incremental:
> 
> Link: https://lkml.kernel.org/r/8bf7c0e9-5ba8-9f35-cefa-4c7b1055eaa0@kernel.dk
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/io_uring.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/fs/io_uring.c~fs-io_uringc-fix-build
> +++ a/fs/io_uring.c
> @@ -2762,7 +2762,11 @@ static void kiocb_done(struct kiocb *kio
>  
>  	if (check_reissue && req->flags & REQ_F_REISSUE) {
>  		req->flags &= ~REQ_F_REISSUE;
> -		if (!io_rw_reissue(req)) {
> +
> +		if (io_resubmit_prep(req)) {
> +			req_ref_get(req);
> +			io_queue_async_work(req);
> +		} else {
>  			int cflags = 0;
>  
>  			req_set_fail_links(req);

LGTM!

-- 
Jens Axboe

