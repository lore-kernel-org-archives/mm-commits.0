Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F015C11F64
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 18:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D6C61417
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 18:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhGASKp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jul 2021 14:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbhGASKp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2021 14:10:45 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6455C061762
        for <mm-commits@vger.kernel.org>; Thu,  1 Jul 2021 11:08:12 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id bq39so769981lfb.12
        for <mm-commits@vger.kernel.org>; Thu, 01 Jul 2021 11:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXni4bb/TXgvzjhBaj+QquJYNCCSPcmm8mQJJHE9nPE=;
        b=O6qFrPFwsZ2r2EZAj5t2vNm3MXhRCTBtU6iaBWCdf9yPTv47fqx9MjX1XEx44LJzxl
         rfUleozbWZh/BspZ8dCW6TT92UvxOSt2FFdA7DvRPka9KNteXC39qBsPY3mNwTfB6CQZ
         AuMOqCW7VxdT5S2xAfOGklwZs5s9PRKMwqLeo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXni4bb/TXgvzjhBaj+QquJYNCCSPcmm8mQJJHE9nPE=;
        b=XMw6ThsvZbJDaz7emGz1KSJ4PGqAab6WmTZacSEvgpUvbi3haJFD/NTem7Qdan4TsN
         Axk/EX3s7HsHv58eYix8rCiFkxF0JNJxdeb2AMhhF5nAwGuR6fR4k2tz+jkTeV0jUm9U
         au8UdOp6E5Q5JmfT7cZRHg1F5g9plqmm37nGCJn0jL2/Cmi9opRiUBsV3DxzO8sTPd18
         EanCtz/G8DmHPpyRA+rm9nl6LERcl11RKF8siIXqMP/Z5kB71G6UlqzhncM9rEPjRk3O
         yEOIPtpHhoO5JICEi4ogjnKzu0ZS4iNdezLgScr8kozMfU5hwIDCb4EDkNsUpI+Wse01
         FSZA==
X-Gm-Message-State: AOAM533S3NpaPdlAz92KUXs/nzOeiU1ZwdoEUDQxJMNQZ0l5n2Z1Dgwo
        HhKINy9bczRk6eJvY7f/UP5Of1p8apEu4E+dpDs=
X-Google-Smtp-Source: ABdhPJydJfuZR/WuOTh5FKOW1eiksujlcx1Yh7oT1Lpz6WzHQgA1j9mVpmIRrkUY18YxrwyMElkYuw==
X-Received: by 2002:a19:f60c:: with SMTP id x12mr682784lfe.290.1625162890929;
        Thu, 01 Jul 2021 11:08:10 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id q5sm34813lfb.277.2021.07.01.11.08.10
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 11:08:10 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id a15so13371690lfr.6
        for <mm-commits@vger.kernel.org>; Thu, 01 Jul 2021 11:08:10 -0700 (PDT)
X-Received: by 2002:a05:6512:3f82:: with SMTP id x2mr617715lfa.421.1625162889824;
 Thu, 01 Jul 2021 11:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015258.BrxjIzdE1%akpm@linux-foundation.org> <YN3Xbdc9N81PIegK@google.com>
In-Reply-To: <YN3Xbdc9N81PIegK@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 1 Jul 2021 11:07:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgKgjX+7h5WQ5eeVVZT_yQvQuJHEH5Jic-_btZSYaR6tw@mail.gmail.com>
Message-ID: <CAHk-=wgKgjX+7h5WQ5eeVVZT_yQvQuJHEH5Jic-_btZSYaR6tw@mail.gmail.com>
Subject: Re: [patch 108/192] mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
To:     Minchan Kim <minchan@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        zhaoyang.huang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jul 1, 2021 at 7:55 AM Minchan Kim <minchan@kernel.org> wrote:
>
> Sorry for the late. I don't think this is correct.

Not _too_ late - I had applied the series to my tree already, but I
try to delay merging my akpm branch overnight exactly to see if there
are any replies to Andrew's sending of the series.

So I've dropped this patch from that branch.

              Linus
