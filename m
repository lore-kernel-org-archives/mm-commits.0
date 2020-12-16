Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E499BC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 07:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8995D23339
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 07:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLPH1Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 02:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgLPH1Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2020 02:27:16 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DF0C061793
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 23:26:35 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id u18so45843775lfd.9
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 23:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dq56PI1RpyZpC/WnCE3DqZtwapEa6Hc/yZMjBY7XqHo=;
        b=TyY0++k7un8kdA2Uaf8jGaA5HOodlctoLp8riSlKqeipfZAVmL/gTYnPLUzS/g+5QD
         AeEUv4+WeTLI8dIkL3oFscOYaiW9HG15mDGLSpYf7kOHktxaKHyDxFOggGXTJcaTULkZ
         8eaOg526ElK6yGhHPjVLHXaE6TMq2w0Q0kx/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dq56PI1RpyZpC/WnCE3DqZtwapEa6Hc/yZMjBY7XqHo=;
        b=TfQaAURlxx3wzgebHO+YXD027CqSvdN1mdD4f8lICxtXhrBGH9yuBGC5e+8SRpxE6o
         OXgVaRw/Mlv4JmhQ2mTLLv8+nllE5DGMJ5PHh3HXyaJoPJKtjXnZ+iLjZPRRq5gR+yM+
         1YCP6QXRqayAWd8eRzHUlUmQeeX78dehjnyk0eDf31f89mWeqbeSnpslwylRXIvqLv2h
         wKmMYy4Aq3eKZuIjC+alIdYQkycnEos06jRg49UM4vCqmH0uZbGWaJ5SkcbIsaCk+ovg
         vAtZsYtZtUxByfXWAiG4VODDB1nWdNPP0IVoKOke0Zihh3fi8D1X+ib6+w7IrPmBysLa
         vu4g==
X-Gm-Message-State: AOAM530Y23GrW1ZVZXfhdvoHItd0rs/etk0rQDebr8sb3sDpFUgYtU1E
        ZflI8SGTaPPrmU/BUV27c0mBRfFOz0JD2g==
X-Google-Smtp-Source: ABdhPJwvtM/1xsjd1tPXlCwfLtse0GWWiglWY7+Xjo5zD0EDrfdh43/4o8ZOAofkTAApnI0ezrN4aQ==
X-Received: by 2002:ac2:4217:: with SMTP id y23mr12734750lfh.569.1608103593642;
        Tue, 15 Dec 2020 23:26:33 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id x8sm122314lfn.226.2020.12.15.23.26.32
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 23:26:32 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id o17so42913126lfg.4
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 23:26:32 -0800 (PST)
X-Received: by 2002:a19:8557:: with SMTP id h84mr11735594lfd.201.1608103591993;
 Tue, 15 Dec 2020 23:26:31 -0800 (PST)
MIME-Version: 1.0
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org> <20201216044350.TKAL6BULW%akpm@linux-foundation.org>
In-Reply-To: <20201216044350.TKAL6BULW%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Dec 2020 23:26:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=whBf-mRuYDR0pv4DCggMg5ayqk6=EbK6MSiHrsP1hawYA@mail.gmail.com>
Message-ID: <CAHk-=whBf-mRuYDR0pv4DCggMg5ayqk6=EbK6MSiHrsP1hawYA@mail.gmail.com>
Subject: Re: [patch 28/95] string.h: add FORTIFY coverage for strscpy()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Daniel Micay <danielmicay@gmail.com>,
        Daniel Axtens <dja@axtens.net>,
        Kees Cook <keescook@chromium.org>,
        laniel_francis@privacyrequired.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 15, 2020 at 8:43 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Francis Laniel <laniel_francis@privacyrequired.com>
> Subject: string.h: add FORTIFY coverage for strscpy()
>
> The fortified version of strscpy ensures the following [..]

So I've taken this, because it follows the pattern of what we already
have, but I have to say that the "fortify" stuff is now about half of
string.h.

I think it should probably be split out into its own header file, and
then string.h could just do

  #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) &&
defined(CONFIG_FORTIFY_SOURCE)
     #include <linux/fortify-string.h>
  #endif

or similar.

That won't help my merge window build times (I build with
allmodconfig, so I'll have CONFIG_FORTIFY_SOURCE=y and so my poor
compiler will end up always going off and seeing all that every time
somebody glances at string.h), but I think it would be a cleanup
regardless.

And people who _don't_ build with FORTIFY_SOURCE wouldn't have to read
and parse that big chunk every time <linux/string.h> gets included.

(And yes, just reading the source file and tokenizing it - even if
it's all inside an #ifdef that turns off all the other phases - is
actually quite noticeable overhead in a C compiler. Surprisingly so)

           Linus
