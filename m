Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE892C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 09:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiJKJDW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 05:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJKJDV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 05:03:21 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E6678596
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 02:03:19 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id b145so15783058yba.0
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 02:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RcAOxa1eNezPHmJ9FrETfyniUyQ1uo7YUQ4nKmmzqaQ=;
        b=tl4+sPD+REiD6EkMCv/WFRGMoMNhfDFvCrq9TBhC1g1QrHzRnqXbFYZ65z8TmYWlDB
         CgB8GY/eJZnShEbgfxB8Qpk09fE1WzSU0BbfSiDHJssktoJE5Wt5In2FLMae9pqxMDh5
         BZV8PXin+imLlZqVFUcUQcx28BGHQ53LBd9uJSf+UuvabPhV9IkbU0aLWkrRBZOU7P1Y
         tk0ZBZAySF7M9cZkk7RtADSUNF7waL+8rl2JsCpAlaVYbuposfHn7aXR83NJwi4yDUoU
         sJxzKuaAZoCLd7hsfJELnUm0JWfX4pqsXjDfPSTa0gFZjJj4wfi2rAy6LsejfG6W+9eH
         jQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RcAOxa1eNezPHmJ9FrETfyniUyQ1uo7YUQ4nKmmzqaQ=;
        b=MpM3dfG0XlSsGXpcsmA9ucKbb3CecnwE37OBal84WJJE4T7JNZVSa29WZsF2/MDfWV
         dlLbBl8X12b7+6oOKg8HLILUMfFmNd6fCvjCoxUDNtB131sOctYgXDR2nzlnP35N2TqQ
         rJ71VEWxEUxBsVylCn65uYer8aigKg3DlJIsegLZcA+Kx2tX7b/uyTFe39qn31wdwc8H
         cfRNT2THeLOgMBYd9OnBAv7GokCJbXdZ6shJE8/fIf47mOfNnSUrZpC909pRO1a4F0b6
         9uUmx5LUQ2LkJ1Nz80PsVB6nijDNGKY/UtnmLPTGCpCi/LqYCM9EptJkribDn9RX3xDD
         AcXg==
X-Gm-Message-State: ACrzQf1VfrEa0iqOOoUUJp3W0OIDo91ohZmZOf1W8I/wNKJy69EL/oCf
        1oQpjw3INf34jGgY9eNLPF2UsuZcwZ2Kw5EzIgI3jQ==
X-Google-Smtp-Source: AMsMyM4Urn5vFXswQKScZ6Xnp/tV/RsptNvXWPtkoBumbwT02NnnChX1WgD70JU0gAjj3427ja4Cb9bqPm02qXzoGAU=
X-Received: by 2002:a5b:a44:0:b0:6b0:13b:c93b with SMTP id z4-20020a5b0a44000000b006b0013bc93bmr22875414ybq.398.1665478998747;
 Tue, 11 Oct 2022 02:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org> <CAHk-=wigZoriP8ZB+V87Jf+EQV=ka6DQe_HCAQmh3Dmus2FFhw@mail.gmail.com>
In-Reply-To: <CAHk-=wigZoriP8ZB+V87Jf+EQV=ka6DQe_HCAQmh3Dmus2FFhw@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Tue, 11 Oct 2022 11:02:42 +0200
Message-ID: <CAG_fn=WuMUKjdNwpcc7Msh6wrXFEkigYJJv9rS9+iMJO2d5Y-w@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.1-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Oct 11, 2022 at 3:20 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Oct 8, 2022 at 1:21 PM Andrew Morton <akpm@linux-foundation.org> =
wrote:
> >
> > Alexander Potapenko (43):
> >       crypto: kmsan: disable accelerated configs under KMSAN
>
> Ok, so this conflicted pretty badly with the crypto tree having
> re-organized their Kconfig files.

Sorry about that. There was a fix for this problem:
https://lore.kernel.org/lkml/20220909095811.2166073-2-glider@google.com/,
but I am not sure where it ended up, given that crypto tree didn't
have KMSAN, and -mm didn't have the crypto changes.

> I channelled my inner Alexander the Great, and just cut the whole
> thing through by disabling all the architecture-accelerated crypto
> includes when KMSAN was enabled.

That's exactly the point. Thanks for doing that!

>  But that's very different from your tree that disabled the options
> individually, so some KMSAN person should probably look around at it
> and decide whether some more subtle approach is called for.

No, in fact it was pretty painful to disable the configs one by one.
Thankfully, the new Kconfig layout simplifies the things for us.

> The other thing I notice from just doing a build is that I now get
>
>    vmlinux.o: warning: objtool: kasan_report+0x12: call to
> stackleak_track_stack() with UACCESS enabled

Guess that's unrelated to KMSAN. Happy to take a look anyway.

> which may just be a "need to teach objtool this is ok", but I'm not
> seeing why it's now starting to happen. Maybe just code generation
> changed for some reason, or maybe it's just that config options ended
> up changing enough to expose this on my allmodconfig builds.
>
> Cc'ing people who may know better.
>
> This is just my reaction from doing the merge and test-build. There
> may or may not be more commentary once I've actually tried to boot
> into this thing.
>
>                Linus


Small nit:

     - Dmitry Vyukov introduces KMSAN: the Kernel Memory Sanitizer. It uses
       clang-generated instrumentation to detect used-unintialized bugs dow=
n
       to the single bit level.

s/Dmitry Vyukov/Alexander Potapenko/ ;)
(although contributions of Dmitry Vyukov and Marco Elver to the whole
thing cannot be underestimated!).

--
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
