Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449A4C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 01:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJKBU2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Oct 2022 21:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJKBUY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2022 21:20:24 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9068C1F2EF
        for <mm-commits@vger.kernel.org>; Mon, 10 Oct 2022 18:20:20 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id d22-20020a4a5216000000b0047f740d5847so9052245oob.13
        for <mm-commits@vger.kernel.org>; Mon, 10 Oct 2022 18:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OBsU0GNWyfIKR8QJhJdP9cW2g/Tm8RsQ4/KCjmFrIcA=;
        b=ZYVC0As2dCkDlVVlxAaYR+Vf5j5NHKgM7FosPug9FKJ5N7poc0XVAWPatSsmLcJT2t
         hLId+80pcemqXzCYeaeUbvev6Avt0/+4+V1qVg8GDdlY0oReQH/zZH/TRufdS0zf7JZB
         /cReB6BKayZEApCnRjZzHWK4YpRpUlNMWvxIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OBsU0GNWyfIKR8QJhJdP9cW2g/Tm8RsQ4/KCjmFrIcA=;
        b=OWpOw9vtbc884Nppzrh1ukQnc8InzNDuKPfvyAZlxH70TvfjglJdoh/nIWWpJCmNcX
         iLJd4jMdv51YCvoXuqAiI8Rl6ur3yeI1zJTZVfDsiFChj730pyKu0XVkxQpMdiJ0b/KY
         ROLmqKx1OY5LdPrciPOagj9/NaOPjniUoLnY5l8rR4+x1gy/M6JKxSjCQ5mkOv3K1RgX
         tymb89w5vN1brAV0zJwd6OJhGFrdZnzi72G3en0M6DyX6APwKJd01S1YvIMgHTobZcq4
         4bYXijC6LePIw08wkphwvg+C8J9YVRCbSGApyDz3ThYCWheNt9OqydeUOi15OGs2gaqE
         0tSg==
X-Gm-Message-State: ACrzQf1gLDvX8pJOyjPwos7sWe41bT+huuoJfk5Tr0FKCvsFup/1rkQP
        wgpNFhEAzxlo2xJjx5DjVmU/FUMd57T4LQ==
X-Google-Smtp-Source: AMsMyM6q1zLBUWToQRgKb1rzwuQ20iw1c21bnN6r90Uob03jXTgnkw3Hj2eEZRcq2ViiY/0wVKoEKw==
X-Received: by 2002:a4a:a78a:0:b0:472:a078:98d6 with SMTP id l10-20020a4aa78a000000b00472a07898d6mr8217179oom.97.1665451219443;
        Mon, 10 Oct 2022 18:20:19 -0700 (PDT)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com. [209.85.167.177])
        by smtp.gmail.com with ESMTPSA id w12-20020a056830144c00b006618bbede10sm3969356otp.53.2022.10.10.18.20.16
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 18:20:17 -0700 (PDT)
Received: by mail-oi1-f177.google.com with SMTP id g130so14382763oia.13
        for <mm-commits@vger.kernel.org>; Mon, 10 Oct 2022 18:20:16 -0700 (PDT)
X-Received: by 2002:a54:4899:0:b0:354:add8:52ab with SMTP id
 r25-20020a544899000000b00354add852abmr2158006oic.229.1665451216585; Mon, 10
 Oct 2022 18:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org>
In-Reply-To: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Oct 2022 18:20:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wigZoriP8ZB+V87Jf+EQV=ka6DQe_HCAQmh3Dmus2FFhw@mail.gmail.com>
Message-ID: <CAHk-=wigZoriP8ZB+V87Jf+EQV=ka6DQe_HCAQmh3Dmus2FFhw@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.1-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Oct 8, 2022 at 1:21 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Alexander Potapenko (43):
>       crypto: kmsan: disable accelerated configs under KMSAN

Ok, so this conflicted pretty badly with the crypto tree having
re-organized their Kconfig files.

I channelled my inner Alexander the Great, and just cut the whole
thing through by disabling all the architecture-accelerated crypto
includes when KMSAN was enabled.

 But that's very different from your tree that disabled the options
individually, so some KMSAN person should probably look around at it
and decide whether some more subtle approach is called for.

The other thing I notice from just doing a build is that I now get

   vmlinux.o: warning: objtool: kasan_report+0x12: call to
stackleak_track_stack() with UACCESS enabled

which may just be a "need to teach objtool this is ok", but I'm not
seeing why it's now starting to happen. Maybe just code generation
changed for some reason, or maybe it's just that config options ended
up changing enough to expose this on my allmodconfig builds.

Cc'ing people who may know better.

This is just my reaction from doing the merge and test-build. There
may or may not be more commentary once I've actually tried to boot
into this thing.

               Linus
