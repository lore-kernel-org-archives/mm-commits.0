Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815D9C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 17:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C95361100
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 17:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhIIRdf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 13:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbhIIRde (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Sep 2021 13:33:34 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CFEC061574
        for <mm-commits@vger.kernel.org>; Thu,  9 Sep 2021 10:32:24 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id m28so5200311lfj.6
        for <mm-commits@vger.kernel.org>; Thu, 09 Sep 2021 10:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FPjDsk9Q1h6DRiZrMZmPS/GH+AL3OHxxk/T+hteUu20=;
        b=BCZ8Zgn6lh0HwTDFtxVtrfcHjC5t2qXeaauShBCl/aDEJGz2yWxlijBwKAC8N3Zc7B
         FVn/I9ruFCEQQZZwZB+qo4yvWaQYoVinFfaqpCKhTCyi3cksysB7oMYKwPzIP/OaNIiD
         4j/fCYJ1SxTlbkabBEdECKDp+nC7zomesrbd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FPjDsk9Q1h6DRiZrMZmPS/GH+AL3OHxxk/T+hteUu20=;
        b=ZH0oTDRn146EgYW7lmTlB8oo4YsJv18SCSjHxzx1To/X0St3/uoR1nc1b0nJxos/c+
         LapKY012N/KwwZW3KqZ+3c95GGd1u1pZUEjjso3LAHKSXvejEUO6DBaoq5k+xDqWoGTS
         2YqjE+U/Ikgwhr7lWgEjc3EypNEjcmyDmfAwUsfNaeLuWPSiefghLnn3wMWfQoJ1X0kR
         KfXGn8sB59FQPa2FfNZH2guCA0G0R6dD/POX3Nq8qagMwBW23SoFJEwoPXQNokG8fKdm
         fgzUxndmhFMz1fJjx5ay0JVCdJ0ajruUmXvsKQOrNM0Xgk5nkBC4oYwewQ4PG55303Ez
         D2dQ==
X-Gm-Message-State: AOAM530EJbWTZwRFPXjngmLUiQGDnqL2T9ws1sIprECt/wJiY+lW8h7o
        OYjKfcep7jtI2H/CpVEbGfTkbcUV8Q3ruyQ9RN8=
X-Google-Smtp-Source: ABdhPJznf8UXGWH/zVgLkyy/YzZOZmu9Uc5mgoWQrxK1fSTXjQ0vZSpqIo8jK6rVUGaVyvarand8ww==
X-Received: by 2002:a05:6512:6d4:: with SMTP id u20mr720608lff.17.1631208742670;
        Thu, 09 Sep 2021 10:32:22 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id n6sm261469lfb.102.2021.09.09.10.32.21
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 10:32:22 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id c8so5229146lfi.3
        for <mm-commits@vger.kernel.org>; Thu, 09 Sep 2021 10:32:21 -0700 (PDT)
X-Received: by 2002:a05:6512:2611:: with SMTP id bt17mr746379lfb.141.1631208741606;
 Thu, 09 Sep 2021 10:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908025730.S88ylmikU%akpm@linux-foundation.org> <CAHk-=wgQ+8kmczLLKCY7yDsGHQBRcZESKd1dNaKbrjUgbWeb3A@mail.gmail.com>
 <fab939c0-42c1-f6ee-f7f8-14280cb5b411@bytedance.com>
In-Reply-To: <fab939c0-42c1-f6ee-f7f8-14280cb5b411@bytedance.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Sep 2021 10:32:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjb=emq204cCuW9VWKawbmLRXfHCLHWmyiDysOfs03TiA@mail.gmail.com>
Message-ID: <CAHk-=wjb=emq204cCuW9VWKawbmLRXfHCLHWmyiDysOfs03TiA@mail.gmail.com>
Subject: Re: [External] Re: [patch 079/147] fs/proc/kcore.c: add mmap interface
To:     Feng Zhou <zhoufeng.zf@bytedance.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        chenying.kernel@bytedance.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        zhouchengming@bytedance.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 9, 2021 at 2:57 AM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>
> Compared to the read interface, kcore mmap has no increased risk, just
> reduce context switching.

Yes, but the main worry is "do we really need to make this faster and easier"?

Because one of the possible main users is literally the black hat "I
got root, now I want to do a rootkit".

And mmap is very very different from read().

Why? Because using mmap() you can now track changes in realtime (ie
you poll waiting for some memory location to change, possibly even
with hardware assist - like watchpoints or ring3 "monitor/mwait").

So mmap() of the kernel memory literally acts as a prime tool for
looking at and exploiting races.

Which is why I'm _very_ leery of these kinds of interfaces.

Do they have possible good uses? Yes. But the bad uses seem to
actually dominate. The good users don't seem _that_ critical, while
the bad users would seem to absolutely love this interface.

See my argument?

This is basically a very dangerous interface. The fact that it is
read-only doesn't change that at all.

               Linus
