Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7469FC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  4 May 2022 19:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355124AbiEDTea (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 May 2022 15:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352087AbiEDTe3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2022 15:34:29 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958154BBB0
        for <mm-commits@vger.kernel.org>; Wed,  4 May 2022 12:30:52 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id l19so2943057ljb.7
        for <mm-commits@vger.kernel.org>; Wed, 04 May 2022 12:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bl4DsFmDfwvhyMeIDRKZ+MZU2qUZebxraWgPXLtE/5g=;
        b=ehxpRxo5gzBoJTc0GfE/8H6JBEvsN6M2waqrFAfJM3/amRzGZehEE2yL+0HKx0b+YA
         Pz/CMNCNVd14jevagAbqkG3+IRSEWHA4sziJUQa39BkiZStOD//nwHtCgsaypxe8Qwgf
         E1zfjx06w4nHOO9Ci2X2WVJ0fo+jDmCYrlXn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bl4DsFmDfwvhyMeIDRKZ+MZU2qUZebxraWgPXLtE/5g=;
        b=bbvyy12wMafU1yd8FYai3I7e14IFxQYj5ZI/0l+Khiyyvbz/CrZNHQYpwok+Yrxq4a
         6KVe9/PF+D5x/91uS37m9yoAVPdiyh3VrZdG+YxSzM6sh4qnv6K6SifPSBT8VPgAGEZc
         tr4CFPrf1YAIkczDVmTaJ7l2WOsbnEYGQDaxNu237vAFvhscvUe65XeFVua5Gp54Ow9i
         vp2lE2rFVSdsBvJzl9llEVOpG6vB/svIn1mM3Icyj8MghuZAZJdRdLKZx/SYXqpH1E0u
         PhRkY020VoAGTgLu8+z5E2LMdI4yUg+EGToMiSF3XSm/FPM5E0Nl4NXbmfzRlJaQQs0n
         6XnQ==
X-Gm-Message-State: AOAM531Hvlq2d/JoV4543y6fBlgZ7NhalB8d3wEtvwHsYaXP3AI3Tr3Y
        x8BeAuOsEYOZSdmclbEdIAK+8R7/ZDxGcH0dNk4=
X-Google-Smtp-Source: ABdhPJxbkZiMZy4E+fMTZd0egM4h+iuzzEaFBX09j/5kUYjKa2hfgEJR9D/SOXAEYco0s2UfiApHew==
X-Received: by 2002:a2e:8609:0:b0:24f:2ce9:382b with SMTP id a9-20020a2e8609000000b0024f2ce9382bmr13821363lji.28.1651692650698;
        Wed, 04 May 2022 12:30:50 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id u1-20020ac25181000000b0047255d211b4sm1287811lfi.227.2022.05.04.12.30.50
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 12:30:50 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id m23so2977430ljc.0
        for <mm-commits@vger.kernel.org>; Wed, 04 May 2022 12:30:50 -0700 (PDT)
X-Received: by 2002:a05:6512:b12:b0:44a:ba81:f874 with SMTP id
 w18-20020a0565120b1200b0044aba81f874mr15622518lfu.449.1651692171026; Wed, 04
 May 2022 12:22:51 -0700 (PDT)
MIME-Version: 1.0
References: <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic>
 <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic>
In-Reply-To: <YnLMSWbz6BNfsBME@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 May 2022 12:22:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
Message-ID: <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
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
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, May 4, 2022 at 11:56 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Just to update folks here: I haven't forgotten about this - Mel and I
> are running some benchmarks first and staring at results to see whether
> all the hoopla is even worth it.

Side note: the "do FSRM inline" would likely be a really good thing
for "copy_to_user()", more so than the silly "clear_user()" that we
realistically do almost nowhere.

I doubt you can find "clear_user()" outside of benchmarks (but hey,
people do odd things).

But "copy_to_user()" is everywhere, and the I$ advantage of inlining
it might be noticeable on some real loads.

I remember some git profiles having copy_to_user very high due to
fstat(), for example - cp_new_stat64 and friends.

Of course, I haven't profiled git in ages, but I doubt that has
changed. Many of those kinds of loads are all about name lookup and
stat (basic things like "make" would be that too, if it weren't for
the fact that it spends a _lot_ of its time in user space string
handling).

The inlining advantage would obviously only show up on CPUs that
actually do FSRM. Which I think is currently only Ice Lake. I don't
have access to one.

                Linus
