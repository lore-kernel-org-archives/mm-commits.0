Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72172C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4888D61078
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhIHSbA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 14:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbhIHSbA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 14:31:00 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5006C061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 11:29:51 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id k4so6680156lfj.7
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8NnmQRyDs5Y9X2yXrAQ+qLvMtz3/gq+6zXFbpPctNPE=;
        b=DltejL/6wpiKcD1jG52u2yc5A/r8Oh8vM2unDuTW4AgSiSx+is9/HaEU9wZ7Mz4324
         ST6bo8sEIyoE7j+ffdVuIRJS652PmyUPKRTnxJ9Rdk7jXJQyGPtviC3F0A+yGKTbhx6r
         60cZWk4SZ/bAAx8GCFLFD+Lzb2nF1My0Ad9VY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8NnmQRyDs5Y9X2yXrAQ+qLvMtz3/gq+6zXFbpPctNPE=;
        b=AkQJA6ajED9xfnxSApe03w8J7UwqXuoSzIJZ2mBqaH9S0HRR2mVWeiJmZM46+FD1iW
         KU1yzDiZQ+2K2453ctjyVY5fLZq1JLnARU35RWXMhXGOV1Vwir9u49didOaJ8ahBP+XI
         JEsoH5ZuZMzoGfmJFpDRv6JxrhWXGp50NdMXIqkSD73uO6ywa8NXKNZrYkPw68yPNbhk
         espV+GiwmurubmxODyLsQVprpe53q71Qz8egZVis38RbbuK7Mkk6Ghe7LEe4H7wg/ZDE
         nU69VmH28AAJhyYwi673x0ZdLzoegdRdlTneo0q8RbYfetXGvTE8WVRcJ2iUGX1s6+ih
         H/nA==
X-Gm-Message-State: AOAM530X9Ro2HYXl0XrzMrn4w/YtWpC7RAFSxc73hQX4yrzsb22tsCoS
        oJuFxrMtq0yzj481rnnrkbJ4iNgX3RXT8RhPJFM=
X-Google-Smtp-Source: ABdhPJz/iHLR+NUjmmMr98V4fLGrYXNzpJWpt7duSaVDtpZ/JcqT52sOo8QWJe6AZEMnBuOd5s9VZg==
X-Received: by 2002:ac2:5391:: with SMTP id g17mr3367176lfh.371.1631125789796;
        Wed, 08 Sep 2021 11:29:49 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id c24sm285864lfm.100.2021.09.08.11.29.47
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 11:29:48 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id p15so5047677ljn.3
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:29:47 -0700 (PDT)
X-Received: by 2002:a2e:b53a:: with SMTP id z26mr3748810ljm.95.1631125787070;
 Wed, 08 Sep 2021 11:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org> <20210908025842.MCdSIuFM5%akpm@linux-foundation.org>
In-Reply-To: <20210908025842.MCdSIuFM5%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 11:29:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg2M2qLWKEZg7FfeQM6jyLDr=pySCP0vDEW2sRu9gtncA@mail.gmail.com>
Message-ID: <CAHk-=wg2M2qLWKEZg7FfeQM6jyLDr=pySCP0vDEW2sRu9gtncA@mail.gmail.com>
Subject: Re: [patch 102/147] lib/string: optimized memmove
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>, drew@beagleboard.org,
        Guo Ren <guoren@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@esmil.dk,
        Linux-MM <linux-mm@kvack.org>, mcroce@microsoft.com,
        mick@ics.forth.gr, mm-commits@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Sep 7, 2021 at 7:58 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> When the destination buffer is before the source one, or when the buffers
> doesn't overlap, it's safe to use memcpy() instead, which is optimized to
> use a bigger data size possible.

This one is actively buggy.

It depends on the possibly incorrect assumption that memcpy() always
copies upwards.

That is admittedly commonly true, but it's not something we can depend
on. Not even when the memcpy() implementation in the very same file
ends up doing so - because architectures can and should replace that
function with their own ones, and we have that __HAVE_ARCH_MEMCPY for
exactly that case.

Like 101/147, all reasonable architectures end up having their own
implementation anyway, but the immediate reason I'm dropping this
patch is that it's literally incorrect.

             Linus
