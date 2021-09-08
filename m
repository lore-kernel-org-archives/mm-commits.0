Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF860C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 20:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD276115C
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 20:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347420AbhIHUKC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 16:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhIHUKB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 16:10:01 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07950C061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 13:08:53 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id t19so6706148lfe.13
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 13:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zfs0wZgJiB4psnoMBBnmwmfJlD/h67WqxBLQ2Yu2SyQ=;
        b=HQqx55zPs34zz/JkJgK/nVZzts+CyeHvZI9qssNWeirW/EZMAGSOVqq7oxm1Yz8XX7
         h0y6ahKGlWNItapvLqFvZcaLKt40VFwhtJb+4aoKQbhj2OecngIoRFUzEoKgR8ZmEqPH
         aEMztn1yvI42H1o1sQFAZagTq/9kE68XfgpvU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zfs0wZgJiB4psnoMBBnmwmfJlD/h67WqxBLQ2Yu2SyQ=;
        b=LUT/K6apWBxlI9yvP0pa2/UpAbbNMc0iCEkDM92A0IqMqJFu+nogyGiZSoSXU3osCq
         gWM/f9fPzNl1/jJA3/m2XZ5hKGltNgn4Il2He6dLdRHqVkU0+YOC4q0Kx+3648roGmPd
         SSQBZBAqRR60yxwgyDtcwhR8mlaas2H4WCMfw6XbXsuP+MkMbIbkoHwnAftzl1wEI/vN
         OQ9Bq5obJdCLlmGirQagXodzeMDUM4hfjIx4I2WEQdjlr4uBv06gJyh7jFVHit9KkTt8
         p/5zfsnB6EN8U4YfkEREP5vJXxNtPkc1I7k4k4tJINRNAN2RQVQR40y0VxVyyZjZKxub
         NHRA==
X-Gm-Message-State: AOAM531EtTR5ahSBo/fegUuXLOSaBTlRPzLRpWks4KJ32bXCoSw4oEyF
        QI0po7d+SOl+y+ZdFL664HoSceMII03cpzIQvcQ=
X-Google-Smtp-Source: ABdhPJzLhXndg+MaM735y/W0zQs3zr0q6e4TCsTmKEfQh/K5VwFuMODLwntRFH9fIIfn3LDECz0/bA==
X-Received: by 2002:ac2:44cb:: with SMTP id d11mr3905007lfm.645.1631131730692;
        Wed, 08 Sep 2021 13:08:50 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id q14sm4296lfm.151.2021.09.08.13.08.48
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 13:08:49 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id w4so5433022ljh.13
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 13:08:48 -0700 (PDT)
X-Received: by 2002:a2e:b53a:: with SMTP id z26mr59095ljm.95.1631131728447;
 Wed, 08 Sep 2021 13:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908025901.gV9fu4cei%akpm@linux-foundation.org> <CAHk-=wg-978nkW_zKigwRQSW4qAcn47q3gG5x45dOe6dh2dmUg@mail.gmail.com>
 <YTkRM/98mwL2GKns@yury-ThinkPad> <20210908124937.bfa68a1428df07eb4e4c0597@linux-foundation.org>
 <CAHk-=whKA+TXGAmT7g5FORm=LucfOCrOHZgU6gVF10oGDt5E+A@mail.gmail.com>
In-Reply-To: <CAHk-=whKA+TXGAmT7g5FORm=LucfOCrOHZgU6gVF10oGDt5E+A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 13:08:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgWC4DQjxbimv3zmjxzyORx5KceB9K-Okb1B7Npnxf-Zw@mail.gmail.com>
Message-ID: <CAHk-=wgWC4DQjxbimv3zmjxzyORx5KceB9K-Okb1B7Npnxf-Zw@mail.gmail.com>
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

On Wed, Sep 8, 2021 at 12:56 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm in the middle of writing the merge message, I'll do my test
> builds, and then push out, so you can see exactly what I merged (and
> by implication, what I did not).

Ok, so no pr-tracker-bot for the manual patch merges, so here's the
equivalent manual "it's merged and pushed out now" notification..

           Linus
