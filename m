Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43530C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 09:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E60F164EDB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 09:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhBYJN6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbhBYJLw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Feb 2021 04:11:52 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B9C06178A
        for <mm-commits@vger.kernel.org>; Thu, 25 Feb 2021 01:11:12 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id d5so4297723iln.6
        for <mm-commits@vger.kernel.org>; Thu, 25 Feb 2021 01:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LeLPPmID49LvirohPpMN9mTLkHB5bvTGmvtbjDEM2Z8=;
        b=SOOrXddGau0HHs1e43hezGMLM/dQ1m89kgYrawmohOd5eoAXaTvFNqyVBbPA3+lj6t
         tP1eq3F/NLNtJ9vBP2OCj/kSTuZQ9XeNkWfrPAIBaKCxToKxc2T7hgrNRIjW++H5lxhW
         mz2iU+F+rx1bLuXRzOxvs9rG8BJFX6zedRUfnUkhUsTPs0crPdMJXlZO/28rnvNSYIXS
         DScfV874YHdajJJUGJojfK7dzAxazDnk79E+GwruWSbU/aN0WaWRABAvj3DWJvFLyDkw
         u/tNQVLfkSjHZbMoe3BvX/8NzEri0rKiyK36WNZ8cunIOtbTagCG3zNUhg90rhWT9tXl
         a6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LeLPPmID49LvirohPpMN9mTLkHB5bvTGmvtbjDEM2Z8=;
        b=CJatDhzojBDeuqnMZtHWTCWadlP0ZWJV/kd7OJS5lRL3TcXFmbWShuxPhnh981v8E2
         Rp02koirWqSaS47AsY3IE3tUxoMh+6qg4G8nlpOTG1+R2TkNfVY0y0BU0mF6r4zKhaRj
         QnQHTpIObIkMnCDjxiZz1XoI95+Bo1JTzy531r62LrhEJ8IRnjiGktE8j/9g4l4dUYaD
         EauDOFMMQmpQuINnKGE8G60qwzksUp8nqW/2W8STc0Qzb4MYumM8CUuY6ndULFQ3uy+b
         CRYfqk24LoYYQNCXA1ETO7eakdor0riOd6DElZcD0n2bXSE/wS/3nd5K9T+62xmuQSWo
         AIkQ==
X-Gm-Message-State: AOAM531Q9nzVvvO/U5g3Ah799n560mpL8mac4oLpTa3gUfQNtngTXB6g
        oozqn9xLIWZPFxA28WVd/2jAfmTVKIAPXqVw9dU=
X-Google-Smtp-Source: ABdhPJyjiPpkwkTnIjvpd0OF4ySo5GqQjzicjbXJH6FcsMzPQviEYpFqHjv4GBRxRbXr0DHTkVPj3eFf9w/oLYzgKoE=
X-Received: by 2002:a92:d7c7:: with SMTP id g7mr1655745ilq.305.1614244271797;
 Thu, 25 Feb 2021 01:11:11 -0800 (PST)
MIME-Version: 1.0
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
 <CAHk-=wiO1=xV1_gOsiWS9TuFJ_RQ0_HuXLg-qVAMnNj2TvHk2g@mail.gmail.com>
 <CAHk-=wibSMJcDmepGEDQ-O4-_d0KUQi4SAF0h3=fj3Ab3DbBdQ@mail.gmail.com> <CAK8P3a3PJZBJQN-=K8DRAWL8fcUa_FPm92HPFWfvZ5jcH-c7Dg@mail.gmail.com>
In-Reply-To: <CAK8P3a3PJZBJQN-=K8DRAWL8fcUa_FPm92HPFWfvZ5jcH-c7Dg@mail.gmail.com>
From:   Andrey Ryabinin <ryabinin.a.a@gmail.com>
Date:   Thu, 25 Feb 2021 12:12:31 +0300
Message-ID: <CAPAsAGz-xzkak9Cj5TuL_FZ86DTtrfybQtgeou-fSjc0UaZRig@mail.gmail.com>
Subject: Re: incoming
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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

On Thu, Feb 25, 2021 at 11:53 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Wed, Feb 24, 2021 at 10:37 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Wed, Feb 24, 2021 at 1:30 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > Hmm. I haven't bisected things yet, but I suspect it's something with
> > > the KASAN patches. With this all applied, I get:
> > >
> > >   lib/crypto/curve25519-hacl64.c: In function =E2=80=98ladder_cmult.c=
onstprop=E2=80=99:
> > >   lib/crypto/curve25519-hacl64.c:601:1: warning: the frame size of
> > > 2288 bytes is larger than 2048 bytes [-Wframe-larger-than=3D]
> > >
> > > and
> > >
> > >   lib/bitfield_kunit.c: In function =E2=80=98test_bitfields_constants=
=E2=80=99:
> > >   lib/bitfield_kunit.c:93:1: warning: the frame size of 11200 bytes i=
s
> > > larger than 2048 bytes [-Wframe-larger-than=3D]
> > >
> > > which is obviously not really acceptable. A 11kB stack frame _will_
> > > cause issues.
> >
> > A quick bisect shoes that this was introduced by "[patch 101/173]
> > kasan: remove redundant config option".
> >
> > I didn't check what part of that patch screws up, but it's definitely
> > doing something bad.
>
> I'm not sure why that patch surfaced the bug, but it's worth pointing
> out that the underlying problem is asan-stack in combination
> with the structleak plugin. This will happen for every user of kunit.
>

The patch didn't update KASAN_STACK dependency in kconfig:
        config GCC_PLUGIN_STRUCTLEAK_BYREF
....
               depends on !(KASAN && KASAN_STACK=3D1)

This 'depends on'  stopped working with the patch
