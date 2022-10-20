Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E3BC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 17:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJTRPR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 13:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJTRPP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 13:15:15 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218D1DCE9F
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 10:15:13 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id g11so34012qts.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 10:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bjCIvltI0ARLYzme57GBWPzsPtp5yIBno5BxRybpBv4=;
        b=Mlaw76yVOCJBJ1ofH8MPx8eyepdOSsu+famkgGAMJrc95zrEp6DmfTCo0zuyLDWSiE
         iFlMT4mxm9bQY+JL+GZWhgnHt5O77Bzgu3q2a+cy6zyfJQZ3FbJWoKpdOg+X4kQ2No2C
         J1g+GUToVB+LNJXErAbrKYJGoEhsy/OrFwJKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bjCIvltI0ARLYzme57GBWPzsPtp5yIBno5BxRybpBv4=;
        b=7tQ1B66LMlM0fd/vOve/SosSLvkkEeENgSGC829wYbDoJIurqjqx10mTYemQZS8Ci+
         TtuC5W+lmdOGYntXSaH0wFGZsC7T2fPO/UyyOCsB9L1wDjP5FeJVeG7RL06N5E+2F6AV
         Z8pT96kPz/UMC0naDuyNw2Xg51I8ukuY/3UJ5bZ3sbhsAMWPYocHt/elhSUbQMURZyoy
         RiAeZnq3aigYsoLkO4AZa+70erx+S00OHcJVQg/SXcgA4+E4nuvRAD/KpNKT3u036KE0
         ISaDWyayvEAfB0Q3576Dv68zXZiu13LY1aqgR0HxspUV7eFZ6moXdri6oI+ijrrxsrMn
         h6pQ==
X-Gm-Message-State: ACrzQf1S1sXtoXDJuSpoxJuKaL4IfnnBJSiBAxm/1PlBJrdffjZkJl63
        WTcWZ+pgVHaPzWEt15uOBA4j0+p5PIgi4Q==
X-Google-Smtp-Source: AMsMyM4eaF5Qi4ZxqB9wOBMM51bhHW4yK0zC3sFaZghJVYBZ+sd78MBMmKgQH2Wpvgp70EIVJ150GA==
X-Received: by 2002:a05:622a:155:b0:39c:dd12:3d10 with SMTP id v21-20020a05622a015500b0039cdd123d10mr11654922qtw.202.1666286112082;
        Thu, 20 Oct 2022 10:15:12 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id g16-20020a05620a40d000b006eeb3165554sm7865959qko.19.2022.10.20.10.15.11
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 10:15:11 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id 126so377549ybw.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 10:15:11 -0700 (PDT)
X-Received: by 2002:a25:bb44:0:b0:6bb:a336:7762 with SMTP id
 b4-20020a25bb44000000b006bba3367762mr11908187ybk.501.1666286110963; Thu, 20
 Oct 2022 10:15:10 -0700 (PDT)
MIME-Version: 1.0
References: <20221020000356.177CDC433C1@smtp.kernel.org> <Y1EZuQcO8UoN91cX@localhost.localdomain>
 <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
In-Reply-To: <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 20 Oct 2022 10:14:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com>
Message-ID: <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com>
Subject: Re: [PATCH -mm] -funsigned-char, x86: make struct p4_event_bind::cntr
 signed array
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Oct 20, 2022 at 9:28 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Nice catch.
>
> Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>

Can we please try to collect these all in one place?

I see that Andrew picked up the original one for -mm, but I think it
would be better if we had one specific place for all of this (one
branch) to collect it all.

I'm actually trying to do a "make allyesconfig" build on x86-64 with
both signed and unsigned char, and trying to see if I can script
something sane to show differences.

Doing the build is easy, but the differences end up being huge just
due to silly constants (ie the whole "one small difference ends up
changing layout, which then causes hundreds of megs of diff just due
to hex constants in the disassembly changing".

I think the problem is that I tried to do the vmlinux file after
linking to make it easier. Doing the individual object files
separately would probably have been a better idea, just to avoid this
kind of relocation offset issues.

There's not a huge amount of pull requests (the week after -rc1 tends
to be quiet for me), so I'll continue to waste my time on this.

                 Linus
