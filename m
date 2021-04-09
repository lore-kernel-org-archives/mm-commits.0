Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A585C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 21:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2E88610CF
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 21:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbhDIV43 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 17:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhDIV42 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2021 17:56:28 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3BEC061762
        for <mm-commits@vger.kernel.org>; Fri,  9 Apr 2021 14:56:14 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id h19so11943099lfu.9
        for <mm-commits@vger.kernel.org>; Fri, 09 Apr 2021 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DxXR2dn277ZxqcFwtteBaWwW/3dtN2eFgo8ineb4CYo=;
        b=H/yvFQzseWo9Qfu+rOzsWKSXSK3IHTJj5m1pxWD8jWJct8oqYip/Cylpdhj9/GnhH4
         w2F5mM3QbgqWk8cbcv9fBggsQxUM2Jb/bSEfFXFliLhldNqqeN8b3GUwpm9JOmK7nRkn
         ONlowcV6AGUfefmH3kc6OnNIsoGix8RUMKX3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DxXR2dn277ZxqcFwtteBaWwW/3dtN2eFgo8ineb4CYo=;
        b=OW6xIoBBfgwcz1lKMXEvhrXg55JtfWiwHa7HBj+3MBmfBYLkUDXJUUhTcSEQHvutm+
         fLKLWhs+ho+Boq8x+y193hdxN9rNk8xUWc4phT5e4ArnU/pDjBXabWGHAnv77O4c8zIx
         vAKUBSC70lfNdT9pRq1F/4sH39ohNvqPOvL2vacZHudNACZQz6Xef1e130foBO2N2Orj
         KgKOjW5swbZgQu5G9sudZQ5yNzyTa0Zpc18xV0zoALvKdyjXVK3/2hxWnuUiEY2D/H4A
         YlSjSrVGoiEnGByBd81HEnqfwd9z0Fpv6PK1jsgaHzkO9aQf6TmOIAJBxYpQamfxecJK
         OIvg==
X-Gm-Message-State: AOAM5322y91cvAtJK9DQlsJZtLrWKjvyxZEXcwMKDEHmahzxWVUHzKvY
        1tvbPo4VfoEXQlDr64yIEZt9kEtg3ALY6Q==
X-Google-Smtp-Source: ABdhPJz9yb/45JgjK5WBiF6X5xJ4rg+oIkNJhX1u2C8rIWaZlWDFh/s089/Kvj4pnBAWGAetC9d7OQ==
X-Received: by 2002:a19:c1c5:: with SMTP id r188mr11601710lff.179.1618005372490;
        Fri, 09 Apr 2021 14:56:12 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id f15sm494064lfr.51.2021.04.09.14.56.11
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 14:56:11 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id l14so5245090ljb.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Apr 2021 14:56:11 -0700 (PDT)
X-Received: by 2002:a2e:9acf:: with SMTP id p15mr10260732ljj.61.1618005371618;
 Fri, 09 Apr 2021 14:56:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
 <20210409202713.NIELx3Tx9%akpm@linux-foundation.org> <CA+fCnZf1ABrQg0dsxtoZa9zM1BSbLYq_Xbu+xi9cv8WAZxdC2g@mail.gmail.com>
In-Reply-To: <CA+fCnZf1ABrQg0dsxtoZa9zM1BSbLYq_Xbu+xi9cv8WAZxdC2g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 9 Apr 2021 14:55:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjAsjrcAXgyJX2K+jFEJ3odsew6zApx65PE_XY+FMR0+w@mail.gmail.com>
Message-ID: <CAHk-=wjAsjrcAXgyJX2K+jFEJ3odsew6zApx65PE_XY+FMR0+w@mail.gmail.com>
Subject: Re: [patch 05/16] kasan: fix hwasan build for gcc
To:     Andrey Konovalov <andreyknvl@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 9, 2021 at 1:39 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
>
> As I commented on the patch, this breaks SW_TAGS build with Clang for me with:
>
> arch/arm64/include/asm/current.h:19: undefined reference to `__hwasan_tls'

I've dropped this patch and the next one ("[PATCH 06/16] kasan: remove
redundant config option") that depended on it.

             Linus
