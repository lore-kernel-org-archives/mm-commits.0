Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DA0C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 08:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 294C664EF5
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 08:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhBYIyj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236039AbhBYIyd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 03:54:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E839864EF5
        for <mm-commits@vger.kernel.org>; Thu, 25 Feb 2021 08:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614243233;
        bh=3fskHFgSnva8Oq9mRm63RNdT+l9AG26PccKquWMEDdg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=P0WxhwO0ynipw7G8ePCXk6EUzIMeNTJfvQy9cOHNKqrnnPnMMDfLTdh7WOi3RXBLc
         qg97DnGmWdvv+/ZVuPdFwFyltbXWUTU1tSsFMnSE43HdOQsQjh8MBaeiqwA27QZ5ga
         Ld54IR+fqNoRAcw6g0SufJ2R/RROpYHuAvptVomRUDB6Mp4c5pii2ouG6YB8Jm3dCT
         GWY9ajI983pBKg2OO/ubKPyPTEIQ9yALi8LvCv3Gx1zp+Jgtu3q9ZNEqfA7ecYOGh6
         PBkeTUNNqvdoIoxX4ngl5dYOR1EjLs9GlJ6OMnkbUMCbAisNAyoZ/pO8ERhgsDKLsC
         aRC7zvMAhK06g==
Received: by mail-oi1-f182.google.com with SMTP id 18so5372432oiz.7
        for <mm-commits@vger.kernel.org>; Thu, 25 Feb 2021 00:53:52 -0800 (PST)
X-Gm-Message-State: AOAM533S0R+htmbLDV6/K55J+gw2qpKWBuqbnhPwVGnNC/+l/J9HNS4n
        IOMadAkBq5C2UJO39iIDwhy13Zz+VL2MP7lJrPA=
X-Google-Smtp-Source: ABdhPJxWZh7Aw0H3nKOaeXdp6UrihvNG+kAxuGiPufkd+9VN0+GWQpdrJHL1MLhBTcVpvzOpkIHoljBMPmpgAg2VanM=
X-Received: by 2002:aca:4a47:: with SMTP id x68mr1177983oia.67.1614243232085;
 Thu, 25 Feb 2021 00:53:52 -0800 (PST)
MIME-Version: 1.0
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
 <CAHk-=wiO1=xV1_gOsiWS9TuFJ_RQ0_HuXLg-qVAMnNj2TvHk2g@mail.gmail.com> <CAHk-=wibSMJcDmepGEDQ-O4-_d0KUQi4SAF0h3=fj3Ab3DbBdQ@mail.gmail.com>
In-Reply-To: <CAHk-=wibSMJcDmepGEDQ-O4-_d0KUQi4SAF0h3=fj3Ab3DbBdQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 25 Feb 2021 09:53:36 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3PJZBJQN-=K8DRAWL8fcUa_FPm92HPFWfvZ5jcH-c7Dg@mail.gmail.com>
Message-ID: <CAK8P3a3PJZBJQN-=K8DRAWL8fcUa_FPm92HPFWfvZ5jcH-c7Dg@mail.gmail.com>
Subject: Re: incoming
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Walter Wu <walter-zh.wu@mediatek.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Konovalov <andreyknvl@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Feb 24, 2021 at 10:37 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Feb 24, 2021 at 1:30 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Hmm. I haven't bisected things yet, but I suspect it's something with
> > the KASAN patches. With this all applied, I get:
> >
> >   lib/crypto/curve25519-hacl64.c: In function =E2=80=98ladder_cmult.con=
stprop=E2=80=99:
> >   lib/crypto/curve25519-hacl64.c:601:1: warning: the frame size of
> > 2288 bytes is larger than 2048 bytes [-Wframe-larger-than=3D]
> >
> > and
> >
> >   lib/bitfield_kunit.c: In function =E2=80=98test_bitfields_constants=
=E2=80=99:
> >   lib/bitfield_kunit.c:93:1: warning: the frame size of 11200 bytes is
> > larger than 2048 bytes [-Wframe-larger-than=3D]
> >
> > which is obviously not really acceptable. A 11kB stack frame _will_
> > cause issues.
>
> A quick bisect shoes that this was introduced by "[patch 101/173]
> kasan: remove redundant config option".
>
> I didn't check what part of that patch screws up, but it's definitely
> doing something bad.

I'm not sure why that patch surfaced the bug, but it's worth pointing
out that the underlying problem is asan-stack in combination
with the structleak plugin. This will happen for every user of kunit.

I sent a series[1] out earlier this year to turn off the structleak
plugin as an alternative workaround, but need to follow up on
the remaining patches. Someone suggested adding a more
generic way to turn off the plugin for a file instead of open-coding
the CLFAGS_REMOVE_*.o Makefile bit, which would help.

I am also still hoping that someone can come up with a way
to make kunit work better with the structleak plugin, as there
shouldn't be a fundamental reason why it can't work, just that
it the code pattern triggers a particularly bad case in the compiler.

      Arnd

[1] https://lore.kernel.org/lkml/20210125124533.101339-1-arnd@kernel.org/
