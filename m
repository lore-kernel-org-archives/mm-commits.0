Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229E3C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 12 Feb 2022 02:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiBLCDO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 21:03:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBLCDO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 21:03:14 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37FAD43
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 18:03:11 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id i34so19861959lfv.2
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 18:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VULwDL2bGuoLKw9ZH+vGy6WYNy7nasfTpVY6FmzciTc=;
        b=cvp4WIQfxJbqUzpc4x1MctGtDJsnAQI+zFPY+euY/iWSFPyPWCH5FYR3rldvhD/Yqw
         nE4Ci5yYJ0H6BlHVOPkE7nh5oKifeg4kPSTvsLIWowBUQtl0HRsrEqHhWLa9WkrMyHm3
         93gzHoiSVComNXupDSDiOrcTX/zXxfZPdUaGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VULwDL2bGuoLKw9ZH+vGy6WYNy7nasfTpVY6FmzciTc=;
        b=Yi3ET8cN2hkTttxmpqshR8BR0Vifb20eLBmAD6HwpPbNMjAwu0tbGOOAdEzFpWFtt3
         AZflXju9EjWgAi8cEk5vcusYcmXMFWYB01H3rAa/zvIzYzFuKiGVX9MNUyEACEbDFcdT
         ds01BvX7vfkipLFiuB3w3Y3U8A7tcLYzkjveNHRa5mQvvWd6MM+BCpdBSkohDL1LSbg0
         ZR2ScswAvwSgQBfkMVCnneokWOw/yo90KMcezSjXMKHDvIxOgHC13qVwJQX44rTL+WVM
         Cipc3m1I+879a3U+MllCA7lU1+1PAVgBg4ErD7/iRlttpeFNqidZ8rWfq+IIRo8IEoBa
         T3+A==
X-Gm-Message-State: AOAM531vmqQ96v6Mz98+Xzxs93MJFveGk6Kf9jBHq3kknpVBd8UGnkSx
        A2Z2Ccx8+lIpBVYv9X2FxWoZnOE0sLWlAeK37jQ=
X-Google-Smtp-Source: ABdhPJyyIZf9EQawKKu4I6U29/pZCyA58wTjPykKO18ZO0WZCRyimTpN10Jra93I9dDeb5x+m0Deng==
X-Received: by 2002:a05:6512:128b:: with SMTP id u11mr3095826lfs.470.1644631389862;
        Fri, 11 Feb 2022 18:03:09 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id o12sm3307819lfu.96.2022.02.11.18.03.09
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 18:03:09 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id j14so14759978lja.3
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 18:03:09 -0800 (PST)
X-Received: by 2002:a2e:a231:: with SMTP id i17mr2605893ljm.443.1644631389126;
 Fri, 11 Feb 2022 18:03:09 -0800 (PST)
MIME-Version: 1.0
References: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 11 Feb 2022 18:02:53 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjxzxa36L0hO6FG9BQT9xsjLhi2G61r1EPjO3v7kofEHg@mail.gmail.com>
Message-ID: <CAHk-=wjxzxa36L0hO6FG9BQT9xsjLhi2G61r1EPjO3v7kofEHg@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Feb 11, 2022 at 4:27 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> 5 patches, based on f1baf68e1383f6ed93eb9cff2866d46562607a43.

So this *completely* flummoxed 'b4', because you first sent the wrong
series, and then sent the right one in the same thread.

I fetched the emails  manually, but honestly, this was confusing even
then, with two "[PATCH x/5]" series where the only way to tell the
right one was basically by date of email. They did arrive in the same
order in my mailbox, but even that wouldn't have been guaranteed if
there had been some mailer delays somewhere..

So next time when you mess up, resend it all as a completely new
series and completely new threading - so with a new header email too.
Please?

And since I'm here, let me just verify that yes, the series you
actually want me to apply is this one (as described by the head
email):

  Subject: [patch 1/5] fs/binfmt_elf: fix PT_LOAD p_align values ..
  Subject: [patch 2/5] fs/proc: task_mmu.c: don't read mapcount f..
  Subject: [patch 3/5] mm: vmscan: remove deadlock due to throttl..
  Subject: [patch 4/5] mm: memcg: synchronize objcg lists with a ..
  Subject: [patch 5/5] kfence: make test case compatible with run..

and not the other one with GUP patches?

             Linus
