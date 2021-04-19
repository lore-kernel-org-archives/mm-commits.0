Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE386C43461
	for <mm-commits@archiver.kernel.org>; Mon, 19 Apr 2021 22:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A6D161077
	for <mm-commits@archiver.kernel.org>; Mon, 19 Apr 2021 22:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbhDSWNR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Apr 2021 18:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhDSWNR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Apr 2021 18:13:17 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862B4C06138A
        for <mm-commits@vger.kernel.org>; Mon, 19 Apr 2021 15:12:45 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a25so27900899ljm.11
        for <mm-commits@vger.kernel.org>; Mon, 19 Apr 2021 15:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+H3mqp2R90G8NCw9fCRyS3oUOaUPPm2FiUG9y073Tek=;
        b=CvduBEQUHFFh4Jq/ayDbLyMywS01YXp5FiMxStQ35SFbmG4ML4iS2QyKJWWBBzlOUg
         f1XbpwtpjLvOtS3v5710aVWlGcZKjR2JsPDMUdojSq7OYYl101N3FbPXm3uM5qcs7lgu
         te+yhQMxUKyArjW5eUhlZoc0312JyUXJVws3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+H3mqp2R90G8NCw9fCRyS3oUOaUPPm2FiUG9y073Tek=;
        b=KoCJeQTiRqtRTKuLubzlxK7vKukzNs+886PrY4GRqBEqXgTpAGzP2zCqXGRU9bW1W0
         J+YfjQszkncZXzuRjLOf6RJ7iE1tlJiafy4mSiRvRYOGedNTtYfz9XHbnIH2tuPidfzp
         GO29hx5IG211ewlXEDOi5jt84nF4guHdDXSEbiRAUHzVjHiY835rBrCPan334k4PStQr
         10VgXe3KC4gxAhSyOUqq4YdeoCFUnE7UBIYfWcD8e43Z3Z6BMKIaipJuKvjLp/Nze1LR
         bLSWEiNsQGc5N2OK3yZaQDWEqJyGVVAabS/tok9Dy2uWSsld8CLATmVMeIfvSRrpUMRS
         Abrw==
X-Gm-Message-State: AOAM5312VW7o0eTrptiLi5+Fom9LkqPbA3mdSAixrjGBmpOvmdYeUOqi
        IqJANaZogT9SRgaHzJWM0n8aXDBZCNeKw2g4
X-Google-Smtp-Source: ABdhPJwaq7Fmq6tgxc2stNQMkySSKvgBjRlooX89mWHnOVJPbWdGv2QHMzDL5C88NhCTXLeL45sdzA==
X-Received: by 2002:a05:651c:482:: with SMTP id s2mr9257892ljc.397.1618870363847;
        Mon, 19 Apr 2021 15:12:43 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id w18sm1948925lfd.223.2021.04.19.15.12.42
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 15:12:42 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id d27so1555146lfv.9
        for <mm-commits@vger.kernel.org>; Mon, 19 Apr 2021 15:12:42 -0700 (PDT)
X-Received: by 2002:a05:6512:3763:: with SMTP id z3mr13215500lft.487.1618870362276;
 Mon, 19 Apr 2021 15:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
 <20210416224623.nZhisHrwM%akpm@linux-foundation.org> <YH33+R8pwviVysY5@archlinux-ax161>
In-Reply-To: <YH33+R8pwviVysY5@archlinux-ax161>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 19 Apr 2021 15:12:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgkck4D7ANx-uJCTugfR5GgH6MgvrmmGcqQRy6ZMECdTw@mail.gmail.com>
Message-ID: <CAHk-=wgkck4D7ANx-uJCTugfR5GgH6MgvrmmGcqQRy6ZMECdTw@mail.gmail.com>
Subject: Re: [patch 11/12] gcov: clang: fix clang-11+ build
To:     Nathan Chancellor <nathan@kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        johannes.berg@intel.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Apr 19, 2021 at 2:37 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> This should not have been merged into mainline by itself. It was a fix
> for "gcov: use kvmalloc()", which is still in -mm/-next. Merging it
> alone has now broken the build:
>
> https://github.com/ClangBuiltLinux/continuous-integration2/runs/2384465683?check_suite_focus=true
>
> Could it please be reverted in mainline [..]

Now reverted in my tree.

Sasha and stable cc'd too, since it was apparently auto-selected there..

           Linus
