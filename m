Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD3EC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 20:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJTURy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 16:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJTURx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 16:17:53 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ED11AE286
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 13:17:52 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id d13so716511qko.5
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 13:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5JG4TG86FhBNXrSI5BCe8InCASAPAEk8+UVxaf6Yswk=;
        b=E19WGn5kg2GNc1bPFs3gE9EEYsek2Vz9u6HTo6hmpqmn7Hi12UWHL9jAgTjFKfVF05
         6WPFFX/ev06e4XHfeyqDGboH3+F1VDqcn+Il2RCSbhCnWl7DCYVzFB6iTaojMyAIqf0g
         nCtctV3bGTycdZKdJJzLvvpPgbVYjnyFJ10g8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5JG4TG86FhBNXrSI5BCe8InCASAPAEk8+UVxaf6Yswk=;
        b=xoYhNvPVj4VEdL/3Ru9+B1HIEcgXoe03DoT3cGLEdqeJlD1HIWDk2v9w/T+3xXmEh5
         Noc/NTEvsyL54mWjl+N8z7klt3BHob2+2qTGtU4v6MPskboB8o3p7W5M0kJcjQf+5I71
         TnDw/yDaVWvSesQkcDkp81/Szd1rqsBIEGMx1nbPneGCixOvUt8gTurwN8h6jWeNpix3
         aMVGeUqDww7jUwud9tDq/NgOtbrmryzyej4TyAep3BsWh374tO5IDY4riFnZIVNh/5mg
         cgL5S2vFpRdmZpKZwRSvLPmbhQeG52qemmjQEVEue1PSVqQUnB0OQd9Ci/FOSZ12MamA
         +B1g==
X-Gm-Message-State: ACrzQf00am6nmKi5S/G5I2isaYEFFq/POZ7yENqMaXYwoa40ZddLaeCK
        gJDAstQV/y5AcQ6tVy1IiQ+Ef1u57yDrpg==
X-Google-Smtp-Source: AMsMyM60IL8HgxHPgua95LPgQE5UYdS+xGbwbVQSUnf4mYmOHB1u/8CEz+UCaX/gCxWl2OUyl02tbA==
X-Received: by 2002:a05:620a:4455:b0:6ee:791f:97f3 with SMTP id w21-20020a05620a445500b006ee791f97f3mr10958734qkp.557.1666297071429;
        Thu, 20 Oct 2022 13:17:51 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id x7-20020ac87ec7000000b0038d9555b580sm6591746qtj.44.2022.10.20.13.17.50
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 13:17:50 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-360871745b0so4508657b3.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 13:17:50 -0700 (PDT)
X-Received: by 2002:a81:5843:0:b0:361:2d0:7d9 with SMTP id m64-20020a815843000000b0036102d007d9mr13585688ywb.58.1666297070240;
 Thu, 20 Oct 2022 13:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20221020000356.177CDC433C1@smtp.kernel.org> <Y1EZuQcO8UoN91cX@localhost.localdomain>
 <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
 <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com>
 <CAHmME9qBZqTd0D_gr8nE+DUzCrC0fxZNZK=7u+21jbgtFgAJBg@mail.gmail.com>
 <CAHk-=wjZDC9o8iwF+bU91Hx40HjGOpMui+VoFCDJkaGCu=rG4A@mail.gmail.com>
 <202210201151.ECC19BC97A@keescook> <CAHk-=wgdXRZy0-3v+vLZdDfRFKFXZLehgmR2QUKSemBA99sfmg@mail.gmail.com>
In-Reply-To: <CAHk-=wgdXRZy0-3v+vLZdDfRFKFXZLehgmR2QUKSemBA99sfmg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 20 Oct 2022 13:17:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjvp=ys2adnWwc1PNt3OrZ_0EkFaUcvjiVuOoVNjX_+AA@mail.gmail.com>
Message-ID: <CAHk-=wjvp=ys2adnWwc1PNt3OrZ_0EkFaUcvjiVuOoVNjX_+AA@mail.gmail.com>
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

On Thu, Oct 20, 2022 at 12:39 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So getting rid of that kind of pointless noise is just about all the
> effort here.

Current status: of 22.5k object files, 971 have differences.

In many cases, the differences are small and trivial. Example:

 - fscrypt_show_test_dummy_encryption() does that same "print a char with %c"

        seq_printf(seq, "%ctest_dummy_encryption=v%d", sep, vers);

which is entirely harmless and exactly the same as that  (but I most
certainly haven't figured out how to automatically script away that
"oh, %c is fine).

And in other cases, there's no actual difference at all, just
different register usage, so the diff looks fairly big, but doesn't
seem to be real.  In one case I looked at, it started with a 'movzbl',
but it was that in both cases, because the type was actually 'unsigned
char' to begin with. But for some reason it just used different
registers. Example:

 - handle_control_request() in drivers/usb/gadget/udc/dummy_hcd.c

   The reason here *seems* to be that

                        char *buf;
                        buf = (char *)urb->transfer_buffer;

   where it really probably should be 'u8 *buf', since it actually
does a cast to 'u8' in one place, but there isn't even any read of
that 'buf' pointer. So the difference seems to be entirely just some
"different type in assignment" cast internal to gcc that then
incidentally generated a random other choice in register allocation.

And in some cases the differences are enormous:

 - drivers/net/wireless/ralink/rt2x00/rt2800lib.c generates a 220kB diff

which seems to be due to entirely different inlining decisions or
something, and the differences are so enormous that I didn't even
start looking at the cause.

There's a fair number of things in between, like fs/ext4/super.c that
generates a lot of differences, some of them obvious, some of them
very much not obvious that may br similar to the
handle_control_request() ones.

*Presumably* the ext4 super.c code is fine (since it has been used on
architectures that already had unsigned char), but it actually
generates a bigger diff than the p4 events driver does...

And that arch/x86/events/intel/p4.c thing that Alexey found sadly does
not stand out at all in that "somewhere in the middle" bunch.

So I think my "hey, we can automate the comparison" is pretty much a
dud, but I'm not giving up quite yet. It's annoying how *most* of the
kernel files show no differences at all, but then I can't even figure
our why other files do show differences with no obvious reason for
them at all.

                Linus
