Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C101EC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 10:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E0406113A
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 10:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhIIK21 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 06:28:27 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:45888 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhIIK20 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Sep 2021 06:28:26 -0400
Received: by mail-ed1-f50.google.com with SMTP id g22so1943900edy.12;
        Thu, 09 Sep 2021 03:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Fmq3R4ZzK2rAO3gtoZe7iYBGOdxKYabfT96jQR65EQ0=;
        b=T1mtuJ2B6y6tUjUrhuNBYjqfgjNBNQOJXbjWrnFkTCWsPVuG5DoGd6Q9hbJETqk3FJ
         lf6jCFY9G9PZQYaehFXLeSemw27dR6u4SdvSLQgRXssABMfKFnJ0NcpYjjDqIhJdea+Z
         BECgFtSL8mwL8QTQ8/cQc3sq1Vt13vvecbvMby7Ztwa6Yo2sAdjOxKGroweX5eFP7ZMp
         gAv8h/OIxrnvs13xmfL80m6ChOiWbwLyXJImHPErXHjkqzLW8+kaYdfSKmNVW0BYq/FS
         /ASBUR1eaXSxo+PVSE6RfkqWnFSDtqrouJzE1QX38rtveKctue/n3bMzzqcKiMKl5PY2
         aUEg==
X-Gm-Message-State: AOAM531Plqn4lL9T9YzWHa8VhTzccY50WMNHryw60E2WWWxGRZYCcQG0
        +azJQdc+8LUp139vtsRW0czKelobm5+QVg==
X-Google-Smtp-Source: ABdhPJwa3QgmvV6CY9V8hVwgXd8pOc2trfZsiDNrMpJTNaYnidnxLtkTHRS6tiG+t8xaqTbpgYk8SA==
X-Received: by 2002:aa7:c80a:: with SMTP id a10mr543597edt.174.1631183235170;
        Thu, 09 Sep 2021 03:27:15 -0700 (PDT)
Received: from localhost (mob-83-225-149-177.net.vodafone.it. [83.225.149.177])
        by smtp.gmail.com with ESMTPSA id bi3sm871591edb.91.2021.09.09.03.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 03:27:14 -0700 (PDT)
Date:   Thu, 9 Sep 2021 12:27:06 +0200
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>, drew@beagleboard.org,
        Guo Ren <guoren@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@esmil.dk,
        Linux-MM <linux-mm@kvack.org>, mcroce@microsoft.com,
        mick@ics.forth.gr, mm-commits@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Subject: Re: [patch 103/147] lib/string: optimized memset
Message-ID: <20210909122706.58d9fe20@linux.microsoft.com>
In-Reply-To: <CAHk-=wjza9+kJJfDXtnQ4YkS637+8H4QZ1tTGRfr39_abkSV-A@mail.gmail.com>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
        <20210908025845.cwXLsq_Uo%akpm@linux-foundation.org>
        <CAHk-=wjza9+kJJfDXtnQ4YkS637+8H4QZ1tTGRfr39_abkSV-A@mail.gmail.com>
Organization: Microsoft
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 8 Sep 2021 11:34:27 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I'm dropping this one just to be consistent, although for memset()
> it's possibly a bit more reasonable to fall back on some default.
> 
> But probably not. memcpy and memset really are *so* special that these
> generic versions should be considered to be "stupid placeholders for
> bringup, and nothing more".
> 
> On Tue, Sep 7, 2021 at 7:58 PM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On a RISC-V machine the speed goes from 140 Mb/s to 241 Mb/s, and
> > this the binary size increase according to bloat-o-meter:
> 
> I also react to the benchmark numbers: RISC-V already has
> 
>   #define __HAVE_ARCH_MEMSET
>   #define __HAVE_ARCH_MEMCPY
>   #define __HAVE_ARCH_MEMMOVE
> 
> in its <asm/string.h> file, so these are just odd.
> 
> Did you benchmark these generic functions on their own, rather than
> the ones that actually get *used*?
> 
>            Linus

I benchmarked against the generic routines. The RISC-V specific are
even slower than the generic ones, because generates lot of unaligned
accesses.

That was the whole point of the series initially. These C routines
should have replaced the risc-v specific assembly ones, but then it was
proposed to use them as generic:

https://lore.kernel.org/linux-riscv/YNChl0tkofSGzvIX@infradead.org/

-- 
per aspera ad upstream
