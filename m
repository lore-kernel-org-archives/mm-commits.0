Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5EDC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 15:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376805AbiATPxX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 10:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376780AbiATPxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 10:53:20 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFC1C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 07:53:20 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id m4so30445244edb.10
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 07:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=miHQqHvTi6uNk+KpO2ktO68R7ziuvLbIMJiH1uT6JE8=;
        b=WZU35Ix3qzzyvPEMn6FTozbA8yxxxJx/MgkNOS2Oo81IAotubCyzrFts+5kvBPnCXd
         CPwMXu6gwbAw4BlivOqh+M/w+E+Ld98tp5BwGQQ8l/sTnAdAOfgKB8+UdFeppa73c7ix
         W7AqZkyAzFIcr9qbNx4K8sxV+KXwB9CTJ2UK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=miHQqHvTi6uNk+KpO2ktO68R7ziuvLbIMJiH1uT6JE8=;
        b=Kozx9+YXC2+B6/8ApyVQ0hArlL6b6ynnjH6DoreVbl2yvxuE2brn9spg8tfbmHTnSL
         A1CJqPduIji5OT1Q/u/OohWR2CLM8ju19kmp/rUq36qMj7cQLVix5xpKhlb4l5NIArIv
         GRc2V3zcZVaLDTZGVq0UHOqxc+RrKSgY+cF1zL3D8XoYobbiKUtMsikAaN8ATcqXkS6g
         6/aFlJwpRYQ9lVtgiut2TYH59p0FSEmyr61p+8K65hguHoRr7dC4JcW+oTvleIzliZY7
         S37UnJxoKHrArzmQUI5004MzhQHhAjEZEFtlC/GCe7Nm/6FagcF2c50vaTR4FmKHBUNp
         FFCA==
X-Gm-Message-State: AOAM530Haw+nhNLFoZz9fSS7mw+a4rvbhX2wqyDUfG0c/nQK8Z6FtZa4
        0aV3W593xfQmyF6bY3AakJqv7WHbQlC7MmHk
X-Google-Smtp-Source: ABdhPJzOVAOuPIYCH4sYIO3nNz87kmAYZJm8Eodb+uH9PsR9uYLFLhvhbyZUW6yzIJh7M3nR7jzasA==
X-Received: by 2002:a50:da48:: with SMTP id a8mr36213435edk.155.1642693998843;
        Thu, 20 Jan 2022 07:53:18 -0800 (PST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id gh33sm1165743ejc.17.2022.01.20.07.53.16
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 07:53:17 -0800 (PST)
Received: by mail-wm1-f43.google.com with SMTP id r7-20020a1c4407000000b0034e043aaac7so564102wma.5
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 07:53:16 -0800 (PST)
X-Received: by 2002:a05:6000:1787:: with SMTP id e7mr20222060wrg.281.1642693995967;
 Thu, 20 Jan 2022 07:53:15 -0800 (PST)
MIME-Version: 1.0
References: <CAAH8bW_3mVqCxebkYeY0XKBfTAjPi1dtygCBEy4GpqvyeKAPqA@mail.gmail.com>
In-Reply-To: <CAAH8bW_3mVqCxebkYeY0XKBfTAjPi1dtygCBEy4GpqvyeKAPqA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 20 Jan 2022 17:53:00 +0200
X-Gmail-Original-Message-ID: <CAHk-=whc9DAJN-TWPTnw=bSjHwXk1zDGeJ9A8eniaK7Jfax5aQ@mail.gmail.com>
Message-ID: <CAHk-=whc9DAJN-TWPTnw=bSjHwXk1zDGeJ9A8eniaK7Jfax5aQ@mail.gmail.com>
Subject: Re: [GIT PULL] Bitmap patches for 5.17-rc1
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dennis Zhou <dennis@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        linux-mm <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Will Deacon <will@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Jan 15, 2022 at 7:10 PM Yury Norov <yury.norov@gmail.com> wrote:
>
> bitmap patches for 5.17-rc1
>
> Hi Linus, please pull these patches for bitmap. They were supposed to
> be pulled in 5.16 cycle, but due to merge glitch we decided to merge them
> in 5.17.

So I'm looking at this pull request that changes quite a bit of random
files, and some rather core headers, and I see *no* actual explanation
for what this pull request does and why I should pull it.

Only a "we didn't do it last cycle, so we should do it now". That's
not much of an argument.  If anything, it makes me go "there was
something wrong with it last time".

I can look at the commits (and I did), but that's really not how this
is all supposed to work.

When I _do_ look at the commits, one thing that stands out is how this
was all appears to be rebased after the merge window opened (just
minutes before you sent the pull request, I suspect).

Which is *also* not how things are supposed to work.

I also don't have your pgp key (not your fault - pgp key distribution
is broken because keyservers are broken) and I haven't pulled from you
before. That all just makes this pull request something where I think
it's all likely good, but there are enough problems that I haven't
actually pulled it.

Put another way: the contents do not appear _wrong_ per se, but there
are many things in this pull request that keep me from actually doing
the pull..

                   Linus
