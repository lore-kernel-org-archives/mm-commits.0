Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62F0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 17:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244868AbiEJRbV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 13:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348146AbiEJRan (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 13:30:43 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E05965435
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 10:26:34 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t5so20811256edw.11
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 10:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1zNOhYhMmOf2oC+35ttTupc2oZM3Rq+mPFR6uZmiyWs=;
        b=SVtOS8E/bEl5utAGPbNiPoiwfX4boLQX+OlSQkP6h30LngrZXUTEQwcWzn0S2n95U/
         o6sPQWgS4PKMB+Wl41tlBAJEC00agmRTO86/bMz3y/tZXrfw/STez1ah+3+0AEd97gq9
         39C5HSNM+CjnCJc8Wj5JyVL/bXtjI9OJ7aX0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1zNOhYhMmOf2oC+35ttTupc2oZM3Rq+mPFR6uZmiyWs=;
        b=NBoqqgffceNAn1NB0SLncqERnRapcseWtnLPa2oD45lUtct6EmV5JDB9+v1uAXx8oz
         o6zC6rBR7spTgiKxpAaWjocbGbyCT3iBQs/OtZdaMtgndmYyLjkfmnnyOA6IfOZI7PhL
         dwnc36iHpz9kXqsXjVS6tAmslIunkdr0ynhZgS6O/riSi/CyyC2BEke4V3V5LGBLzj3l
         Zwp8QFkmRkDTS2jo4lbDyfochYpm+SDC2j2MjSdG9+j76xkqp6wDhQIM3WLpRvjKBZnk
         99txht2NH28Ig+UKY1mS/INwg3q3Zfv/1xbyy1OUyaPOIB3BOqkAmv83d3lkCiwI+2pZ
         r92g==
X-Gm-Message-State: AOAM530uwU+2YQE4ZS7BIq42fmSzBJvVxhS7ZnqRyPLpN/TiG2XjLPu2
        6Ddkt1gu1YDgPw1sTyc4P+gVvBFW64zJbn2SHbE=
X-Google-Smtp-Source: ABdhPJxejITNgXzIy5szd2Osc08VhjQwhW9acAmlEW0Bf05xEhXGY6ElDpZqHcKHSgqjLcswRZTT2w==
X-Received: by 2002:a05:6402:2546:b0:427:c112:6de6 with SMTP id l6-20020a056402254600b00427c1126de6mr23687255edb.46.1652203592828;
        Tue, 10 May 2022 10:26:32 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id v4-20020a056402348400b0042617ba63b8sm8082723edc.66.2022.05.10.10.26.32
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 10:26:32 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id x18so24820224wrc.0
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 10:26:32 -0700 (PDT)
X-Received: by 2002:adf:ec08:0:b0:20a:d39d:6ab6 with SMTP id
 x8-20020adfec08000000b0020ad39d6ab6mr19343203wrn.442.1652203094068; Tue, 10
 May 2022 10:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic> <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
In-Reply-To: <Ynow8F3G8Kl6V3gu@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 10 May 2022 10:17:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgRm26_oT-JR+TRzDsfhD1TRxfWDM=j6kJerv+m=NU-yQ@mail.gmail.com>
Message-ID: <CAHk-=wgRm26_oT-JR+TRzDsfhD1TRxfWDM=j6kJerv+m=NU-yQ@mail.gmail.com>
Subject: Re: clear_user (was: [patch 02/14] tmpfs: fix regressions from wider
 use of ZERO_PAGE)
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, May 10, 2022 at 2:31 AM Borislav Petkov <bp@alien8.de> wrote:
>
> > I haven't really done serious profiling work for a while (which is
> > just as well, because it's one of the things that went backwards when
> > I switch to the Zen 2 threadripper for my main machine)
>
> Because of the not as advanced perf support there? Any pain points I can
> forward?

It's not anything fancy, and it's not anything new - you've been cc'd
on me talking about it before.

As mentioned, I don't actually do anything fancy with profiling - I
basically almost always just want to do a simple

    perf record -e cycles:pp

so that I get reasonable instruction attribution for what the
expensive part actually is (where "actually is" is obviously always
just an approximation, I'm not claiming anything else - but I just
don't want to have to try to figure out some huge instruction skid
issue). And then (because I only tend to care about the kernel, and
don't care about _who_ is doing things), I just do

    perf report --sort=dso,symbol

and start looking at the kernel side of things. I then occasionally
enable -g, but I hate doing it, and it' susually because I see "oh
damn, some spinlock slowpath, let's see what the callers are" just to
figure out which spinlock it ls.

VERY rudimentary, in other words. It's the "I don't know where the
time is going, so let's find out".

And that simple thing doesn't work, because Zen 2 doesn't like the
per-thread profiling. So I can be root and use '-a', and it works
fine, except I don't want to do things as root just for profiling.
Plus I don't actually want to see the ACPI "CPU idle" things.

I'm told the issue is that Zen 2 is not stable with IBS (aka "PEBS for
AMD"), which is all kinds of sad, but there it is.

As also mentioned, it's not actually a huge deal for me, because all I
do is read email and do "git pull". And the times when I used
profiling to find things git could need improvement on (usually
pathname lookup for "git diff") are long long gone.

               Linus
