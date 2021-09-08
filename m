Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFF9C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 19:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD0861164
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 19:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241984AbhIHT6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 15:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbhIHT6F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 15:58:05 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D03C061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 12:56:57 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id l10so7166467lfg.4
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 12:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U2GU/WoMJEZEg5wMR8CgdDh15Dq5OYhzZqSog25cVHc=;
        b=gv0EBXZlKvn9zUCCdhGQJHukqLUNIa7uhKx+8KZPWOCXFkzUUCMEWZEsIO1GOuPlYu
         Lok1SBCybnJcKBxrjTyiZ2pRscQk5Avpq9le70KKiHskthTq4NvdlqKTmN2xBwZC64WK
         uSmyLZ9w0XYcyDre0XONwbxPmKpq+bSud4nb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U2GU/WoMJEZEg5wMR8CgdDh15Dq5OYhzZqSog25cVHc=;
        b=xrOQnLxa5RBl9XG5x9t76hqY6h+22BbI+mDrL5yQgFPUtcrXx3hjMqYn5LrMx47eiw
         mQwU8B9uZQrFdNhgIcXh38XseTuLMrdYUiJNJgi1nYpK3Yr9sBOQBoVIud1hN3uIvw0Z
         4lXMUVu1raRQazinNFqneZIbaT6Bl3QSzFPqcHfMlUVboG4aajsCkr8pwvM72ytAd4mI
         WWV2cFHDh+CzlWkFy4dxUUlZOW62gKFzhS3RIOQOjLY/QPNjPXpVdHkwiq2Q7SUXZ77I
         s6G6K4RL/Vjk5tb9fMMleJSQLFle9XnUIOwmMwHi/nQemd0I2F7yi2PxNfiiLgiWFZrU
         5eAA==
X-Gm-Message-State: AOAM531toiwKSQDN1w92G/GpgDJ5Qs7vwJgwS3JWofYtlk3FQtI0XBEY
        rZURHbBHA+ntkL1LMC1HWaydULu7sB1LbhQ1tLg=
X-Google-Smtp-Source: ABdhPJwdlYMibiNVLd7K6xwGpS+YVJeFkZBBASQ9Ga3QNE0rtI8GW5jWaAkdx/ZSk4E43uP2/SUcQw==
X-Received: by 2002:a05:6512:3d13:: with SMTP id d19mr3694377lfv.607.1631131015318;
        Wed, 08 Sep 2021 12:56:55 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id i5sm1383lfb.124.2021.09.08.12.56.53
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 12:56:54 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id n2so7250379lfk.0
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 12:56:53 -0700 (PDT)
X-Received: by 2002:a05:6512:2611:: with SMTP id bt17mr3958713lfb.141.1631131013416;
 Wed, 08 Sep 2021 12:56:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908025901.gV9fu4cei%akpm@linux-foundation.org> <CAHk-=wg-978nkW_zKigwRQSW4qAcn47q3gG5x45dOe6dh2dmUg@mail.gmail.com>
 <YTkRM/98mwL2GKns@yury-ThinkPad> <20210908124937.bfa68a1428df07eb4e4c0597@linux-foundation.org>
In-Reply-To: <20210908124937.bfa68a1428df07eb4e4c0597@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 12:56:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=whKA+TXGAmT7g5FORm=LucfOCrOHZgU6gVF10oGDt5E+A@mail.gmail.com>
Message-ID: <CAHk-=whKA+TXGAmT7g5FORm=LucfOCrOHZgU6gVF10oGDt5E+A@mail.gmail.com>
Subject: Re: [patch 108/147] bitops: move find_bit_*_le functions from le.h to find.h
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Yury Norov <yury.norov@gmail.com>, aklimov@redhat.com,
        Alexander Lobakin <alobakin@pm.me>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dennis Zhou <dennis@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Will Deacon <will@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Sep 8, 2021 at 12:49 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Linus suggests other changes.

I _think_ my other objections were to patches in different groups
(same 147-email series, but different sub-series).

But I didn't check how you had split things up, so they may end up
being related.

I dropped all of the bit finding ones.

I'm in the middle of writing the merge message, I'll do my test
builds, and then push out, so you can see exactly what I merged (and
by implication, what I did not).

              Linus
