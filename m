Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4572BC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 230F16115B
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348539AbhIHSPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 14:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhIHSO5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 14:14:57 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA95DC061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 11:13:48 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id x27so6616131lfu.5
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3KVP1TQHZdGrdNKj8CPKdoEmE85Oj8PqSeHf9EEMkqw=;
        b=Rwva5mDkJqdQVc7K2+pxGZZRv9fEXrg8bpAWaXCKlb82xtj7LOocPpJ3FtOIPF7o2T
         lb0AK+X/qn/TXn8PuSD5GfvjaC9r27jSHIcgTrgmsZu42SZzapqzrXQi8YLns36kMGPS
         8n2Z8Dj7x83bNIeNJenbleHk+GCMU52JU32Lk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3KVP1TQHZdGrdNKj8CPKdoEmE85Oj8PqSeHf9EEMkqw=;
        b=FjZHEs55LDCJbuxB2gql8N8wSbitgLGhUDxy0ndriM+yk3X9KFl+5IJ4hxqYYF8+0w
         Z1dyYbg4yj9sMJinfXNQ2+494fWlND+AB0EGZHyeL9JFtYyH5/La2Mq7JJ2JJMmYrLrQ
         t4Y8UtBkOezygnqk/IIrCumNnNbjRfMjIdVo6few/lurzR5LslOupjPXc9AP5HqLnO9N
         JMx3LS8dAlv/akNIES+aSJVOOSKauFK47Sbs5tvtfifJcs4pdfOkzcBSDAJ2Hlbhg4Wl
         RoEcOIHM12zFjnapnpK6gcme/u3YlP/O8HYxdziv0IJFjE2MNgCrv99rRV+umX0yOII8
         ESQQ==
X-Gm-Message-State: AOAM532uyLfKKUgkisgovfQWaMsr23EhyDAvYTx5r4dJeR1/BesRDZ79
        700k7RxEoiP+UCzp2YElQVyPA3r6vgJ9Mze3DAQ=
X-Google-Smtp-Source: ABdhPJwAdvGJLoMqEBzicYTYlDgh06cCUMr1oZkw1SpA5z0cjXTqnvrmHNVLwQckrLttmsPJB+H+QA==
X-Received: by 2002:a05:6512:96b:: with SMTP id v11mr3573413lft.121.1631124826666;
        Wed, 08 Sep 2021 11:13:46 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id x6sm254158lfd.208.2021.09.08.11.13.45
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 11:13:45 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id c8so6637386lfi.3
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:13:45 -0700 (PDT)
X-Received: by 2002:a05:6512:1112:: with SMTP id l18mr3468117lfg.402.1631124825204;
 Wed, 08 Sep 2021 11:13:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org> <20210908025730.S88ylmikU%akpm@linux-foundation.org>
In-Reply-To: <20210908025730.S88ylmikU%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 11:13:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgQ+8kmczLLKCY7yDsGHQBRcZESKd1dNaKbrjUgbWeb3A@mail.gmail.com>
Message-ID: <CAHk-=wgQ+8kmczLLKCY7yDsGHQBRcZESKd1dNaKbrjUgbWeb3A@mail.gmail.com>
Subject: Re: [patch 079/147] fs/proc/kcore.c: add mmap interface
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        chenying.kernel@bytedance.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        zhouchengming@bytedance.com, zhoufeng.zf@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Sep 7, 2021 at 7:57 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> After looking at the kcore code, it is found that kcore does not implement
> mmap, resulting in frequent context switching triggered by read.
> Therefore, we want to add mmap interface to optimize performance.  Since
> vmalloc and module areas will change with allocation and release,
> consistency cannot be guaranteed, so mmap interface only maps KCORE_TEXT
> and KCORE_RAM.

Honestly, I still hate this patch.

The last time people wanted to speed up /dev/kcore accesses, it was
all for black-hat reasons and speeding up kernel attacks.

And this code just makes me nervous even aside from that, because I do
not understand what the heck it's doing.


> +       if (kern_addr_valid(start)) {
> +               if (m->type == KCORE_RAM)
> +                       pfn = __pa(start) >> PAGE_SHIFT;
> +               else if (m->type == KCORE_TEXT)
> +                       pfn = __pa_symbol(start) >> PAGE_SHIFT;

Why is "__pa(start)" right in one situation, and "__pa_symbol(start)"
in another.

So this just makes me go "this is all confusing, dangerous, and the
use-case is dubious".

Mapping kernel memory is dangerous. The use-cases for it are dubious.
The patch isn't obvious.

All of that screams "I'll skip this".

           Linus
