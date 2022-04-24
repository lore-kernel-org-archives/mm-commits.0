Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9244C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbiDXUGN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiDXUGN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:06:13 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959DB1EAC5
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:03:10 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 16so395015lju.13
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LLHrC18vqO4mAkzdZZc8nx6SJWE+jfgShrpAIINRfoE=;
        b=EdsexeSGCi4k+MyrihuimqWCq1Wu41k8sNbO7+/sbse2JMHu0Iv9yNxRjmA9oZYxE+
         Orvp/Y/ct3CmG6lrZ4yp8YX79dWSC9Oef/kSYIBtDo5AjFMU5RHfs1pwXYhW2ddthYpB
         a/NKPJjwB/aNxIQQPCcuct2n9voSoTmgtvA0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LLHrC18vqO4mAkzdZZc8nx6SJWE+jfgShrpAIINRfoE=;
        b=Wc8EHJlDgywbE+KQFA/F+JmuhuTgI5tQKRQmITuhdZgVscAkC4VEpxazcnHbV6Yly8
         PUK+bAtKwtMI9vlt4stlvPC4Y++eFwIdjKKmcMJzRyKCcgauijTbACOyQYsGwP5BFXGb
         cumymYGtRbhPb2Qy+QlgqwumqIEVbUGeGx7kP8mjCSVNhT3MMcZb6FX7Czmq7KRReiwS
         VbtjBD0jJ1mVSfNmuORij7V1vVG89AbFlZu5+Xk+on5sOJF29CpMkVLK0lK4WYnvYGCf
         DvNmIBZ0gtBXyoZ0vMaJ1RFX6tu9vHWf8oGrEmiv7y08GTb3BtlZimRo30fZRi5s3anH
         SnrA==
X-Gm-Message-State: AOAM533JNm76EM0UnftgVkMxcGk3IuWcydl67sD7T24QJmt6Q5GZbwCl
        xSvCbj1U7/9O9HFFXsph4Wgr6oi9iHLCw11dlX8=
X-Google-Smtp-Source: ABdhPJwrZR+YtRtlu8kbC2lVLir1u4vVMy65Z/yr/fUKVCWBuhcQ5QbaBFgyqeuauK44sODHLLyxhg==
X-Received: by 2002:a2e:7f13:0:b0:247:ef72:9e8b with SMTP id a19-20020a2e7f13000000b00247ef729e8bmr9131989ljd.205.1650830588591;
        Sun, 24 Apr 2022 13:03:08 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id v9-20020a2e7a09000000b0024dbdd8e297sm975711ljc.19.2022.04.24.13.03.08
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 13:03:08 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id w1so22875541lfa.4
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:03:08 -0700 (PDT)
X-Received: by 2002:a2e:934b:0:b0:24f:cce:5501 with SMTP id
 m11-20020a2e934b000000b0024f0cce5501mr3034323ljh.443.1650830114045; Sun, 24
 Apr 2022 12:55:14 -0700 (PDT)
MIME-Version: 1.0
References: <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic> <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com> <YmWm5AXdwgwu57KZ@zn.tnic>
In-Reply-To: <YmWm5AXdwgwu57KZ@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 24 Apr 2022 12:54:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
Message-ID: <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
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

On Sun, Apr 24, 2022 at 12:37 PM Borislav Petkov <bp@alien8.de> wrote:
>
> You could give me some more details but AFAIU, you mean, that
> fallback to byte-sized reads is unnecessary and I can get rid of
> copy_user_handle_tail? Because that would be a nice cleanup.

Yeah, we already don't have that fallback in many other places.

For example: traditionally we implemented fixed-size small
copy_to/from_user() with get/put_user().

We don't do that any more, but see commit 4b842e4e25b1 ("x86: get rid
of small constant size cases in raw_copy_{to,from}_user()") and
realize how it historically never did the byte-loop fallback.

The "clear_user()" case is another example of something that was never
byte-exact.

And last time we discussed this, Al was looking at making it
byte-exact, and I'm pretty sure he noted that other architectures
already didn't do always do it.

Let me go try to find it.

> Anyway, I ran your short prog and it all looks like you predicted it:

Well, this actually shows a bug.

> fsrm:
> ----
> read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 17

The above is good.

> erms:
> -----
> read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 17

This is good too: erms should do small copies with the expanded case,
but sicne it *thinks* it's a large copy, it will just use "rep movsb"
and be byte-exact.

> rep_good:
> ---------
> read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 16

This is good: it starts off with "rep movsq", does two iterations, and
then fails on the third word, so it only succeeds for 16 bytes.

> original:
> ---------
> read(3, strace: umoven: short read (17 < 33) @0x7f3ff61d5fef
> 0x7f3ff61d5fef, 65536)          = 3586

This is broken.

And I'm *not* talking about the strace warning. The strace warning is
actually just a *result* of the kernel bug.

Look at that return value. It returns '3586'. That's just pure garbage.

So that 'original' routine simply returns the wrong value.

I suspect it's a %rax vs %rcx confusion again, but with your "patch on
top of earlier patch" I didn't go and sort it out.

                   Linus
