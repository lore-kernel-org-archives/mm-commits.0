Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08D1C4361B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 19:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C448222D74
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 19:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgLSTfm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 14:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbgLSTfl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 19 Dec 2020 14:35:41 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EFDC0613CF
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 11:35:01 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id l11so14252856lfg.0
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 11:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xcWtXrMO+0hLztBLJUxRA4dQ4p5GWkZ1849NW4e1u94=;
        b=IpXxZ4PYWti9EnRaeFDXjWcoIuEIj2uX1TFCjZWzk7VKqOMCbzHcOwVDbuIFszHlL7
         PWsXD9TyXwgfLkzvfnXKvIt8nSquwtPf6/mfmoC64ap0aH7+Pl4KgUFJeElJarep5OXE
         x7EyjFPYpJ2gFYxB8NbInWevLCwf9sVHW01xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xcWtXrMO+0hLztBLJUxRA4dQ4p5GWkZ1849NW4e1u94=;
        b=oCej6/pObWUTjI4MIWeRT/Pv50cMshNbrGiRJWydpwT2isYXpHlt5xTlC0K6+RqjWp
         gzZZsozgjXA2rchsXs/AcQxxi4ix0Neh0A6LZ7084LRlDrjoKY0DsQPeGkgbTYRmftj8
         BZ5mapsGT+qRlCmd1/DEy0kANE6l9sUAGERKJMfsQ3tJGHHYKhz3ruA/zjiWW82mz5eU
         +22B1TgbYpYkqSYJfR5qNytAqoIaZDuc8fDrxb64nZgiS6b+Kmwq4dl1LsY7q0PXJVKw
         Su3py9PQrLvpEEyxHQ/Hfs4QxNqbxdwCjSnExnRPrI+sihDfSyUQ/rMaoVd2mpbnumLR
         RkGw==
X-Gm-Message-State: AOAM532CeyfqGyw5Pq5yJ4wsDSzwpOzscqGhljfZtrL3S2GNfsb2PdzM
        FZtmYpka3mFcJYgYSD2nFdF+PYtJwqGhJw==
X-Google-Smtp-Source: ABdhPJx+hJ0oPVTcqgiwMAk37VZVVyeUxLqeSyNkZSJRaJOV3v8/SM7eEMnBq0SKLunC6JYS8ZP5/g==
X-Received: by 2002:a2e:a414:: with SMTP id p20mr4302712ljn.98.1608406498485;
        Sat, 19 Dec 2020 11:34:58 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id e2sm1526131ljp.75.2020.12.19.11.34.58
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 11:34:58 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id o19so14235344lfo.1
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 11:34:58 -0800 (PST)
X-Received: by 2002:a2e:9b13:: with SMTP id u19mr4080972lji.48.1608406035446;
 Sat, 19 Dec 2020 11:27:15 -0800 (PST)
MIME-Version: 1.0
References: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
 <20201218220233.pgX0nYYVt%akpm@linux-foundation.org> <X91JLZhrXYaLzoB8@elver.google.com>
 <20201218171327.180140338d183b41a962742d@linux-foundation.org> <CAHk-=whK70LHzMw5SxUu_1NHkWtZc-o1PHyotkmwR49e2Jh6rw@mail.gmail.com>
In-Reply-To: <CAHk-=whK70LHzMw5SxUu_1NHkWtZc-o1PHyotkmwR49e2Jh6rw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 19 Dec 2020 11:26:59 -0800
X-Gmail-Original-Message-ID: <CAHk-=wghj1OkyqS0o-W9K19tsytyAwfdZrxpMNhwGX60WbJ_uw@mail.gmail.com>
Message-ID: <CAHk-=wghj1OkyqS0o-W9K19tsytyAwfdZrxpMNhwGX60WbJ_uw@mail.gmail.com>
Subject: Re: [patch 21/78] kasan: split out shadow.c from common.c
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Branislav.Rankov@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Dec 19, 2020 at 11:17 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> (That cuts the series of 78 down to 17

18, actually.

>                       - and I haven't actually
> verified that even that smaller subset is entirely independent of the
> dropped patches yet).

Looks like that small remainder is fine.

           Linus
