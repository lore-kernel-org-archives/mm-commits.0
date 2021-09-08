Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD55C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 529F16113E
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350070AbhIHSf5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 14:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350072AbhIHSf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 14:35:57 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6971C061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 11:34:48 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id c8so6747065lfi.3
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aMVIkkBfSE2tqSN2Teaj0GxByK6w+qQQR/o0rQOZufU=;
        b=VsJ85LZphyoafBljbFM8vktNbehdKKjmmvYeX4kr1mqe1OVePjWHmDyKS9lRzXBaEg
         ekBhojeOvDY2YwAusYQGXvZfQd5vAvYetuf5FOQ1i6e6Ou1Zmg36s4kJtNPxPeCtJf8B
         ppFdYZwYE5h2GRyLaXDAHduyLfzhU0aK2G3rw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aMVIkkBfSE2tqSN2Teaj0GxByK6w+qQQR/o0rQOZufU=;
        b=wbY64u22tNFEJJJsBvc9qr/Xa2+9VCaIKYlz3KYsmLVM3el2qMnAc5FM+P954T1ydJ
         bPEYHGxWl2RhtKtW7nU8zrBsWdb3DkQHgFDODaY3fVA1488ZamDNdPJ73zHWroX90AsB
         0qgRxenHh3RrL0ihx48kQr4HDdpoT4ZHgPkHZEgrWY2rQVgGv5OQeltyNU52KJvBEU94
         WS+w5Jbtdsyfw6PKUVkTfVXQqD1Beumb1dcT994iqjSt/M5u92SbMhJf4KJqoylIPAZK
         5zzTP1FFuJJjFN5Q1hEVb3D4Qii8kU6qJtMcU5aQZ/+1PhDhux898j6eYcnRyzthsR+T
         HsDg==
X-Gm-Message-State: AOAM530dwRygZHLuWCrIhEHp/SMBvvoZ55fgSHYJz0joQUL5JL/euxsl
        y0rByieG1RSmjAQLVtiBzGh9tv7WRXoAG/I20zY=
X-Google-Smtp-Source: ABdhPJwbbN1mVDl1H/uyhw9OFz+glmLoNsOBilQ2kd8U5+Scr8aAE4TvoxsczjvtBnfOH0MN1Dq6yw==
X-Received: by 2002:a05:6512:220c:: with SMTP id h12mr3522388lfu.398.1631126086688;
        Wed, 08 Sep 2021 11:34:46 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id y2sm260005lfe.242.2021.09.08.11.34.43
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 11:34:44 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id m4so5052406ljq.8
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:34:43 -0700 (PDT)
X-Received: by 2002:a2e:8185:: with SMTP id e5mr3781033ljg.31.1631126083674;
 Wed, 08 Sep 2021 11:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org> <20210908025845.cwXLsq_Uo%akpm@linux-foundation.org>
In-Reply-To: <20210908025845.cwXLsq_Uo%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 11:34:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjza9+kJJfDXtnQ4YkS637+8H4QZ1tTGRfr39_abkSV-A@mail.gmail.com>
Message-ID: <CAHk-=wjza9+kJJfDXtnQ4YkS637+8H4QZ1tTGRfr39_abkSV-A@mail.gmail.com>
Subject: Re: [patch 103/147] lib/string: optimized memset
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

I'm dropping this one just to be consistent, although for memset()
it's possibly a bit more reasonable to fall back on some default.

But probably not. memcpy and memset really are *so* special that these
generic versions should be considered to be "stupid placeholders for
bringup, and nothing more".

On Tue, Sep 7, 2021 at 7:58 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On a RISC-V machine the speed goes from 140 Mb/s to 241 Mb/s, and this the
> binary size increase according to bloat-o-meter:

I also react to the benchmark numbers: RISC-V already has

  #define __HAVE_ARCH_MEMSET
  #define __HAVE_ARCH_MEMCPY
  #define __HAVE_ARCH_MEMMOVE

in its <asm/string.h> file, so these are just odd.

Did you benchmark these generic functions on their own, rather than
the ones that actually get *used*?

           Linus
