Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96E6C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 19:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C03AA61139
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 19:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241971AbhIHTsA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 15:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbhIHTr7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 15:47:59 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF84C061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 12:46:50 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a4so4764983lfg.8
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 12:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ShwnwTL5LphBttkz12QEUV+tZvqUUd9G1IadovG2h78=;
        b=br/JUv0IvLJ0ieD+WZ/vSr3QmBdThEmQNOUtwB+DebLJBf9TSGYYNqSYJ4P6PZPsyw
         faUmdGsdFnwEbZnKkKCkWteeEcPOHk4u4nUZqGUVlUdqVKz+Czt1TkUW2avAsBdp2a+I
         3HPHu5MSaUYidKLj1dNFC0Fbc1M2nMzey6dGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ShwnwTL5LphBttkz12QEUV+tZvqUUd9G1IadovG2h78=;
        b=Fh8Mjzg5oYxucHVGmy1D6MEQ/3+SOQQ24J/0LLBcrpXscJ3vp7cT/Gwgwdl0gERou7
         xqYhWoPCnhVKPJOF94dfmLPSpK50IhJjPEJm0MSxuGx2ACS/aZ0L/qg3OOZy/1IPpcQC
         dn+8duKkZ02BWYV20RqJQAj195rdZg8I+Mqhme83vvrXqvM6unHBQV3jB116U+svgc5T
         DDi1/Nhbiq9mCB8LNslSwkjo8AKRGLGuMuG1M8b/J+MH4KT+TFYMb+SwFpblmEeSXFJv
         R6OhH75KJ4NtaTLpPa1U9CJzL9GfknW61jKXQvjx2fVLCSyFW6MHlGdOxDBNAWvUU2Ng
         fEpg==
X-Gm-Message-State: AOAM533XSae0Y1wL2wjlmHyg83h6HSNwqxxWvFpZvQ2rzOeVLAn3dkTS
        AX98wgDGNYEcW4Ymh0EFs5sHmN4foM4UH/X5Fkg=
X-Google-Smtp-Source: ABdhPJxKxaYZLfQZg+jvKw+zNyms1ovGKIiNVRa98TyuJ9gBVh48tcyqSJX3zuLVPpmo2nMvvLoA5Q==
X-Received: by 2002:ac2:4204:: with SMTP id y4mr2842130lfh.501.1631130409035;
        Wed, 08 Sep 2021 12:46:49 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id h8sm376428ljh.27.2021.09.08.12.46.47
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 12:46:47 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id n2so7194638lfk.0
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 12:46:47 -0700 (PDT)
X-Received: by 2002:a05:6512:3da5:: with SMTP id k37mr3920874lfv.655.1631130407102;
 Wed, 08 Sep 2021 12:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908025901.gV9fu4cei%akpm@linux-foundation.org> <CAHk-=wg-978nkW_zKigwRQSW4qAcn47q3gG5x45dOe6dh2dmUg@mail.gmail.com>
 <YTkRM/98mwL2GKns@yury-ThinkPad>
In-Reply-To: <YTkRM/98mwL2GKns@yury-ThinkPad>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 12:46:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiS=z2yLEo2pUwmf9BgEnPeshMxm+xxRjFhhJ8Rm8Aw4Q@mail.gmail.com>
Message-ID: <CAHk-=wiS=z2yLEo2pUwmf9BgEnPeshMxm+xxRjFhhJ8Rm8Aw4Q@mail.gmail.com>
Subject: Re: [patch 108/147] bitops: move find_bit_*_le functions from le.h to find.h
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, aklimov@redhat.com,
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

On Wed, Sep 8, 2021 at 12:38 PM Yury Norov <yury.norov@gmail.com> wrote:
>
> Andrew, Linus, are you OK if I resend the patchset?

I've removed the whole series from my queue, so yes, resending is the
right thing.

That said, by now it's starting to be the latter half of the second
week of the merge window, and by the time it has gone through the
queues, I'm not going to guarantee that I'll be in a mood to merge new
stuff any more.

This has not been a particularly huge merge window in number of
commits, but there's actually been an unusually large number of these
kinds of odd things where I go "that's just not right".

So I've been a bit testy with people (sorry about that), and I'm
getting to the point where I just am not feeling very generous to
stuff that wasn't all prim and proper and ready by the merge window.

              Linus
