Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F69FA373D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 17:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiJURYf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 13:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiJURYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 13:24:34 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AAB2514EA
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 10:24:18 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id l28so2075669qtv.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 10:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pc1MZrum9U3f5zrb42uMivoTovnGyDRppcBiM2u8cio=;
        b=dExWfQycVB6K7KJX/TXQHtrKNvEFZmzoTPkRzg+mJaUK3ypYPlc0sUv4uB6zv6aejJ
         kj9UBWHeeFZ7ZHJTdgI62G5YA5Z0NTFJj3qJ6YMGIjufATFepwCgO8gFj3FlkJrezqmC
         LmSb69RShHf7vR6ms6pyjbHeKsgpw+eUrC5c8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pc1MZrum9U3f5zrb42uMivoTovnGyDRppcBiM2u8cio=;
        b=UvfJRByIpkLqpVL/qO3ONKZpb3to/20EPiKlTxFUwYKv36gkqj39vQwoLKdXI2Gxh9
         g/LXpu6GKjM+y056dQ09E3eWlpbH2A4s56eGOccUBrX8m9G9LufvpjllQANON8cKHuPK
         SA45V8E2eST/JWtpjOQ3gZgwhpe9nZAMKBT1kVofC17in2Z+5hmc8dMrQZihrrthx0H+
         dwuFjKuusiM1JaIsJKZwN1uP7Bos5jnPakmaW7rkLOmBzUcHO8B73Dq50hD6eXB1TGku
         P2nqQSpPLdOgJ+Z+CmxYcnGmPdGqZhENYlp4mca3r47ewAv01A0YIzjp6dVe1Y2kTBqa
         fKdA==
X-Gm-Message-State: ACrzQf1C2wv34V4+FAUd2yzC40LRx6CbptCu5EW8GLDvC7fDhaC4uu3q
        C8/2a2jwkg6sdpBqzQr5rAmaozkuj1bFJw==
X-Google-Smtp-Source: AMsMyM72ktXIgE5Z1ReuGJht1Z/7HugoQfp71RzI1RXKhVGrluKse2H34TitBZxmb1KuJU1iknxXwQ==
X-Received: by 2002:ac8:578b:0:b0:39c:f006:3563 with SMTP id v11-20020ac8578b000000b0039cf0063563mr17036261qta.636.1666373057661;
        Fri, 21 Oct 2022 10:24:17 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id d4-20020ac81184000000b00359961365f1sm8178745qtj.68.2022.10.21.10.24.16
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 10:24:16 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-367cd2807f2so30195637b3.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 10:24:16 -0700 (PDT)
X-Received: by 2002:a81:d34c:0:b0:349:1e37:ce4e with SMTP id
 d12-20020a81d34c000000b003491e37ce4emr17794908ywl.112.1666373055922; Fri, 21
 Oct 2022 10:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20221020000356.177CDC433C1@smtp.kernel.org> <Y1EZuQcO8UoN91cX@localhost.localdomain>
 <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
 <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com>
 <Y1I1S86zbBmeJ+jq@localhost.localdomain> <CAHk-=wgb3RYTPd24rXs8dRdiqiPAzq7uc4Suxu1On6_DTDnf5g@mail.gmail.com>
In-Reply-To: <CAHk-=wgb3RYTPd24rXs8dRdiqiPAzq7uc4Suxu1On6_DTDnf5g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 21 Oct 2022 10:23:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wigjpfSxu4-JXrKK9gW7m35h4pgmOd1gY2Moe9VCrXh8Q@mail.gmail.com>
Message-ID: <CAHk-=wigjpfSxu4-JXrKK9gW7m35h4pgmOd1gY2Moe9VCrXh8Q@mail.gmail.com>
Subject: Re: [PATCH -mm] -funsigned-char, x86: make struct p4_event_bind::cntr
 signed array
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Oct 21, 2022 at 10:11 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think you can fix that by simply warning about character constants
> with the high bit set.
>
> Something like this..

This actually triggers for the kernel, and I think those (few)
warnings are likely worth just fixing.

Because things like

                put_tty_queue('\377', ldata);

just isn't worth it.

Or look at this horror:

                        if (c == (unsigned char) '\377' && I_PARMRK(tty))

where somebody did realize that '\377' might be -1, so they added the
"helpful" cast.

Wouldn't that be much nicer and simpler as just

                        if (c == 255 && I_PARMRK(tty))

instead? Or just 0377 if you really love octal in the context of
characters (and really, nobody should). Or 0xff.

At no point does "(unsigned char) '\377' " strike me as a really
readable way to write things. There's two of those things.

We also have

        memset(stack, '\xff', 64);

which really isn't helpful either. Why not just use 0xff, or even just -1.

We also have a lot of those in lib/hexdump.c, for no good reason,
particularly as those arrays are 'unsigned char[]' to begin with, not
'char'.

I really don't understand why people would use '\xAA' instead of just
using 0xAA.

We also have

        static char sample_rate_buffer[4] = { '\x80', '\xbb', '\x00', '\x00' };

in sound/usb/mixer_scarlett.c, and that should be a byte array, so the
'char' should probably be 'unsigned char' or 'u8' in the first place,
and again it would be just simpler and clearer to use plain hex
constants.

So that sparse warning looks simple enough, and I think every single
case was just the kernel being odd.

Now, in *string* constants, you sometimes do want to use that format, ie

    u8 array[] = "abcd\377";

is a reasonable way to avoid having to use a more complex initializer.
But that sparse patch of mine only complains about (non-wide)
character constants unless I screwed something up.

                  Linus
