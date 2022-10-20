Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EDAC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 19:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiJTTkH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 15:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJTTkF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 15:40:05 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B25C7876
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 12:40:01 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id t16so380314qvm.9
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 12:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X9pgXdyFfszfkRvPZih7Y4YB2xxFEj5etWPG/rSzRiM=;
        b=VrWKZkHuiztJqn1afjPx6nvILG8p+uiiGTCHH8gHYKCOZ6l5XlS8V238U97DoB/fQ8
         0TNIm+Yo6Z5DIh/NCYjlw9XN0mhaP4oXAvBBayugsejmUSbUn4/yMSeFj9PPtTUs33kL
         6qTGV0rVb55S75SV2iBiaMkFsvcDPCDG6OgFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X9pgXdyFfszfkRvPZih7Y4YB2xxFEj5etWPG/rSzRiM=;
        b=PVAJYqlS2yuU8vRTruHLwmg26vPLIZZP8Mb6dleif2mMLhpKrwI73pdOT1w5Od2E2D
         ONPjxHa/+VlWrBhoiDkbmjIsPkHx9LGYGgE2kP3EsIigslQAN0ROgYyehNHPMggnmR+f
         CLVXVoTC7FkwukJuoLvlA3J6QQzAFVhZkq4dnRO3FXEmmA1M/hE7IjcP87Zf2h41eXY+
         Y2URH6GXkENNMgo24nazucaic6Ckr9imHszm6geyarD1ExeAtFxFCUlLJjf0LjLoykBO
         o2F9yVkGR+8xJFCJ/FBGcLyRV5Ib1OaN94aNvYYziSpp/tfBLZGWbBcIUGke4pINf66J
         ze4w==
X-Gm-Message-State: ACrzQf0v1ePxL+Z7lC8s8fCvWPIv+kP6xox6EVrk69Kzn80FSnhs6j0M
        ZzKTiP8e4AZwuXsDYpc3iMIiga6QqF1vlQ==
X-Google-Smtp-Source: AMsMyM45DuuSRa1fx3Cd+UdUrjQmIgP+LYI+5fVR9YSnBZUiwQGA1cQgVgw9CUzblCfG4E7vrkAMxA==
X-Received: by 2002:a05:6214:258d:b0:4b1:eb75:44de with SMTP id fq13-20020a056214258d00b004b1eb7544demr12859275qvb.130.1666294800637;
        Thu, 20 Oct 2022 12:40:00 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id n6-20020a05620a294600b006cfc7f9eea0sm7985768qkp.122.2022.10.20.12.39.59
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 12:40:00 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id y72so760494yby.13
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 12:39:59 -0700 (PDT)
X-Received: by 2002:a05:6902:1147:b0:6c3:ff50:565e with SMTP id
 p7-20020a056902114700b006c3ff50565emr12063589ybu.362.1666294799327; Thu, 20
 Oct 2022 12:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221020000356.177CDC433C1@smtp.kernel.org> <Y1EZuQcO8UoN91cX@localhost.localdomain>
 <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
 <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com>
 <CAHmME9qBZqTd0D_gr8nE+DUzCrC0fxZNZK=7u+21jbgtFgAJBg@mail.gmail.com>
 <CAHk-=wjZDC9o8iwF+bU91Hx40HjGOpMui+VoFCDJkaGCu=rG4A@mail.gmail.com> <202210201151.ECC19BC97A@keescook>
In-Reply-To: <202210201151.ECC19BC97A@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 20 Oct 2022 12:39:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgdXRZy0-3v+vLZdDfRFKFXZLehgmR2QUKSemBA99sfmg@mail.gmail.com>
Message-ID: <CAHk-=wgdXRZy0-3v+vLZdDfRFKFXZLehgmR2QUKSemBA99sfmg@mail.gmail.com>
Subject: Re: [PATCH -mm] -funsigned-char, x86: make struct p4_event_bind::cntr
 signed array
To:     Kees Cook <keescook@chromium.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, masahiroy@kernel.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Oct 20, 2022 at 11:57 AM Kees Cook <keescook@chromium.org> wrote:
>
> For the a/b build, I start with all*config, then:

Yes, I have that part all figured out.

> For the code diff, I use:
>
> objdump --disassemble --demangle --no-show-raw-insn --no-addresses

This part I still hate.

Have you figured out any way to get objdump to actually show the
relocations in-place in the assembly?

Ie, instead of

        call   <will_become_orphaned_pgrp+0xbf>
                        R_X86_64_PLT32  debug_lockdep_rcu_enabled-0x4

just show it as

        call   debug_lockdep_rcu_enabled

to make the diff - when it exists - hugely more legible?

Because now any code changes will not just show the code changes, but
end up showing a lot of silly changes because the "+0xbf" changes.

I guess I'll just have to remove all of those hex constants anyway,
because they also show up for any jumps inside the functions.

I also explored trying to compare just the generates *.s files, but
that has its own set of problems, notably with gcc label numbering.
Plus they are harder to generate for the full tree with our standard
build rules (maybe there's some trick I haven't thought of to make gcc
keep the '*.s' files as it generates the '*.o' ones).

I do have something that "works", but it turns out to be very noisy,
because while gcc *often* generates almost identical code, then when
it doesn't it can be quite nasty.

When there is a *real* difference, having a nasty diff is fine. For
example, the arch/x86/events/intel/p4.c issue that Alexey found
generates huge differences, because gcc can just see that "ok, that's
never negative", and generates completely different code.

That's good.

But when there's some small change that just changes the offset, it's
just annoying, even with --no-addresses. The hex numbers can be edited
out, but then you have the nop padding changes etc etc.

So getting rid of that kind of pointless noise is just about all the
effort here.

                  Linus
