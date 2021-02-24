Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA315C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 21:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF5C864F06
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 21:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbhBXVil (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbhBXVie (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Feb 2021 16:38:34 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9A3C061574
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 13:37:53 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id m22so5327417lfg.5
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 13:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VFPxXchIt+W/0pXC8BPGtbay18iwKGzp1PuWretvaGk=;
        b=hM4SQtINjNebO6btx5X80KuXuOMx5bEWL95QpTnO5PtaCNwWzsM3aYK0UtsI2T0w/v
         1zhjZc6kCphn5Ptml44hmcjag1AXaUW79Admg9MvVjnMNpVZQhO09UeH+jNZ7fL6PCvp
         m2KMFZpvzOQ7ZIpNJk3t4Nv+MxqGHK9TTdJCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VFPxXchIt+W/0pXC8BPGtbay18iwKGzp1PuWretvaGk=;
        b=lvGd2HtDuOiSGM9m32jkECfn+xwT/KVbqXRuQh0vioDUURCgsRJTDF8cf8pblQLhU7
         DkkveRht89VlezFQgEa/ZyVzbnKSO7w/vF/CZKlh8Iz5UFIkyO+1o+TGr/5/5AQx2fwF
         U5f3F7a3WplMjwZPqd06VmzWQI1dWbQB1u+ioC2a0TSreg9e6MKbdI/SAxqjbTezaEea
         4sP8U3Iv2Dum3wQJH4Wc+OHhgdCkIiHAcQ5//P+a238HrllNTaFNPaNu9E0WCha5go1O
         5gZcFORpow2Adb6yIrMZ934wJoaXt9Q0qfJnKzbk3DM11hAC14yA5y6ohejy97XibCl8
         yTvg==
X-Gm-Message-State: AOAM5304h3gN391gVk+pVxYOSuNONl4gmT566oS7oAQD+yxr66sve+nX
        h8xZvaZr7lxAkEm0a+ArYdCioaoye0tXrA==
X-Google-Smtp-Source: ABdhPJxT01bBVdmScR7ybjKSTWj3RYTq8lH81Qk4CHOOYXmxHffWuC6zO5jaLdxCOwI+VoRDwC5Qig==
X-Received: by 2002:ac2:5a19:: with SMTP id q25mr3276lfn.36.1614202671867;
        Wed, 24 Feb 2021 13:37:51 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id j18sm735889lfm.236.2021.02.24.13.37.51
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 13:37:51 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id u4so4160694ljh.6
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 13:37:51 -0800 (PST)
X-Received: by 2002:a2e:9659:: with SMTP id z25mr1063278ljh.411.1614202670878;
 Wed, 24 Feb 2021 13:37:50 -0800 (PST)
MIME-Version: 1.0
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org> <CAHk-=wiO1=xV1_gOsiWS9TuFJ_RQ0_HuXLg-qVAMnNj2TvHk2g@mail.gmail.com>
In-Reply-To: <CAHk-=wiO1=xV1_gOsiWS9TuFJ_RQ0_HuXLg-qVAMnNj2TvHk2g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 24 Feb 2021 13:37:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=wibSMJcDmepGEDQ-O4-_d0KUQi4SAF0h3=fj3Ab3DbBdQ@mail.gmail.com>
Message-ID: <CAHk-=wibSMJcDmepGEDQ-O4-_d0KUQi4SAF0h3=fj3Ab3DbBdQ@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>,
        Walter Wu <walter-zh.wu@mediatek.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Konovalov <andreyknvl@google.com>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Feb 24, 2021 at 1:30 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm. I haven't bisected things yet, but I suspect it's something with
> the KASAN patches. With this all applied, I get:
>
>   lib/crypto/curve25519-hacl64.c: In function =E2=80=98ladder_cmult.const=
prop=E2=80=99:
>   lib/crypto/curve25519-hacl64.c:601:1: warning: the frame size of
> 2288 bytes is larger than 2048 bytes [-Wframe-larger-than=3D]
>
> and
>
>   lib/bitfield_kunit.c: In function =E2=80=98test_bitfields_constants=E2=
=80=99:
>   lib/bitfield_kunit.c:93:1: warning: the frame size of 11200 bytes is
> larger than 2048 bytes [-Wframe-larger-than=3D]
>
> which is obviously not really acceptable. A 11kB stack frame _will_
> cause issues.

A quick bisect shoes that this was introduced by "[patch 101/173]
kasan: remove redundant config option".

I didn't check what part of that patch screws up, but it's definitely
doing something bad.

I will drop that patch.

               Linus
