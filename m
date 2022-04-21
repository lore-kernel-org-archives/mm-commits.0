Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57565C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 16:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiDUQx7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 12:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiDUQx6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 12:53:58 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99C549276
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 09:51:03 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id r18so6535296ljp.0
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 09:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0wR58guBD6vBfg01cSpvLPTtpTPtwglrlYBbuICMBZQ=;
        b=HZzFBX/Q0szTxL7OHhniQp4nMQ3Q/KQyOj5yhwFcE0NPZ9Gt/YcoWGdiBluAch7l14
         asZkqFLD7Eu1IPmtyZU7FzHFWwpBuIcJq4sg9I2LjcyO72SM/UI0N4q+RkDGH3Ja+RZO
         7gC8UNhjVBZISHIdAWXooNWUV42kpEAZu0WUY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0wR58guBD6vBfg01cSpvLPTtpTPtwglrlYBbuICMBZQ=;
        b=AiyIJQXKESbtGl8ihjxMLeIZadwNbFtFH7dDxsZxn6eDRh+bZkp0DkG8g30iz63XEy
         G0261szO7LIPmg+aP9lbDfNSayb87+X9sN7VTn8tlMiL4WYI89O7acE8Pk+gRp6naaXh
         vKkGjV4WL/qZudYpW30ArHjN31pqHr8b5X0CL89dKLj1G5d2bObdkPHLyrMHhBjSlcXl
         adkA+CxTVrIan5wUQ5yqwTfbEvMxEcuxfVOvDytw2BaMtnl70+TiWf/cpjymjARA5mtF
         +aS5VKVSYUylfEoeJ/70bx/EqaagUcTkgx0r8I3/4JaG7PcqslzHNUpGAT6IDFhn7JhO
         /8Fw==
X-Gm-Message-State: AOAM533+QbHR6wq1hnOt5VQBrw6uuoljRyVUW28LJnQB8mSISW40VokQ
        2EdQ9odwbqyH/gcw8D5P+AI9rRfN6h/uryK6n48=
X-Google-Smtp-Source: ABdhPJxzYWEwYOnCBypGHDEDMFBbdE6XU+Y+HBIYf9mpjE2HQwg9EZ3bZj6iIgR8J8AjFrB6zzgwow==
X-Received: by 2002:a05:651c:b0d:b0:24d:a008:46f1 with SMTP id b13-20020a05651c0b0d00b0024da00846f1mr349545ljr.198.1650559861543;
        Thu, 21 Apr 2022 09:51:01 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id t7-20020a199107000000b00471d641e8d6sm2311lfd.281.2022.04.21.09.50.57
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 09:50:59 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id bf11so6493578ljb.7
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 09:50:57 -0700 (PDT)
X-Received: by 2002:a2e:9d46:0:b0:24c:7f1d:73cc with SMTP id
 y6-20020a2e9d46000000b0024c7f1d73ccmr360076ljj.358.1650559856041; Thu, 21 Apr
 2022 09:50:56 -0700 (PDT)
MIME-Version: 1.0
References: <Ylr8rR+LHQ1uGL47@zn.tnic> <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic> <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic>
In-Reply-To: <YmFy8DEqvX4FlnuB@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 21 Apr 2022 09:50:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
Message-ID: <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000e6963c05dd2ce909"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--000000000000e6963c05dd2ce909
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 21, 2022 at 8:06 AM Borislav Petkov <bp@alien8.de> wrote:
>
> on AMD zen3
>
> original:       20.11 Gb/s
> rep_good:       34.662 Gb/s
> erms:           36.378 Gb/s
> fsrm:           36.398 Gb/s

Looks good.

Of course, the interesting cases are the "took a page fault in the middle" ones.

A very simple basic test is something like the attached.

It does no error checking or anything else, but doing a 'strace
./a.out' should give you something like

  ...
  openat(AT_FDCWD, "/dev/zero", O_RDONLY) = 3
  mmap(NULL, 196608, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0x7f10ddfd0000
  munmap(0x7f10ddfe0000, 65536)           = 0
  read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 65536) = 16
  exit_group(16)                          = ?

where that "read(..) = 16" is the important part. It correctly figured
out that it can only do 16 bytes (ok, 17, but we've always allowed the
user accessor functions to block).

With erms/fsrm, presumably you get that optimal "read(..) = 17".

I'm sure we have a test-case for this somewhere, but it was easier for
me to write a few lines of (bad) code than try to find it.

               Linus

--000000000000e6963c05dd2ce909
Content-Type: text/x-csrc; charset="US-ASCII"; name="t.c"
Content-Disposition: attachment; filename="t.c"
Content-Transfer-Encoding: base64
Content-ID: <f_l298k8m60>
X-Attachment-Id: f_l298k8m60

I2luY2x1ZGUgPHN0ZGRlZi5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxmY250bC5o
PgojaW5jbHVkZSA8c3lzL21tYW4uaD4KCi8vIFdoYXRldmVyCiNkZWZpbmUgUEFHRV9TSVpFIDY1
NTM2CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCnsKCWludCBmZDsKCXZvaWQgKm1h
cDsKCglmZCA9IG9wZW4oIi9kZXYvemVybyIsIE9fUkRPTkxZKTsgCgoJbWFwID0gbW1hcChOVUxM
LCAzKlBBR0VfU0laRSwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwKCQlNQVBfUFJJVkFURSB8TUFQ
X0FOT05ZTU9VUyAsIC0xLCAwKTsKCW11bm1hcChtYXAgKyBQQUdFX1NJWkUsIFBBR0VfU0laRSk7
CgoJcmV0dXJuIHJlYWQoZmQsIG1hcCArIFBBR0VfU0laRSAtIDE3LCBQQUdFX1NJWkUpOwp9Cg==
--000000000000e6963c05dd2ce909--
