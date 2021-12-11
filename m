Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2004DC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 11 Dec 2021 01:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhLKBML (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 20:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbhLKBMK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 20:12:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617F8C061714
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 17:08:34 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x15so35830814edv.1
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 17:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rG/BXP74osfka0lZ+Rh+ws4m8UkSBZoHRs2ELVshZSQ=;
        b=TlHQgM5ve++ZiBm6gzzs/QT4jG55kPzc8+VO6XXhpb7HzaajN6FSdjHy7iYLTphYMb
         IOLij3z8ftzgbhicY4qAZYOlZRksS+GUAq894g7FnWm9XMqwAx3QJQOP96yXAdTye7dO
         JOG7snUMttXkG8IRSPaOOegY11+zJgrr1tsWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rG/BXP74osfka0lZ+Rh+ws4m8UkSBZoHRs2ELVshZSQ=;
        b=YS+j9cu55GrWnLIBdQTOjN9TOKF7BcOqH9G005vLM71jRuXy7xXwf6bxTXpIn2jlSN
         MMkecp6mOAgFHrPOktH8oJpkOAnDQ+7+2euGqW4M3QJDd1C35T7no86tPlpXu1wAyvBg
         UUE91DyNtjNM+RvZE5YsV3pcxa8t74/tIbv2hRLJlnxbYQ2OFkBfYJmFkvaAktItmskh
         wK0yiA9ibG1taETFeWK/KLrmt2IMBx+Zp1KMUj7hkbyWRrk7DCNS4nJi+BMtjOL4jawP
         xwM6VwqmCVkTRBNlcPJSDoeJy4IsTSaoM2lxTD42QUlrIf0ptX6ZVt/ANAVAWDKO0GJE
         +beg==
X-Gm-Message-State: AOAM533Qm8H7XrGi9J0iwQkQ4nr5rxPNpK6oHM9+HXXvhTDwVdqoyFf/
        3Sn5CMw0b8AKdHeotWyfl6sOtybxU2mPqZXAh0s=
X-Google-Smtp-Source: ABdhPJz1vPbsyzTdXN61XZSAYfrAJsaC6CJqxT2PPM6wtlIkJhA/VXCqG33eJA/oPralyeo58T3N6w==
X-Received: by 2002:a17:906:dbef:: with SMTP id yd15mr27180088ejb.354.1639184912784;
        Fri, 10 Dec 2021 17:08:32 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id t3sm2218029edr.63.2021.12.10.17.08.31
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 17:08:31 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id a9so17664055wrr.8
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 17:08:30 -0800 (PST)
X-Received: by 2002:a5d:4575:: with SMTP id a21mr18460564wrc.193.1639184910712;
 Fri, 10 Dec 2021 17:08:30 -0800 (PST)
MIME-Version: 1.0
References: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org> <20211210224609.9QkKor7T0%akpm@linux-foundation.org>
In-Reply-To: <20211210224609.9QkKor7T0%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Dec 2021 17:08:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgoJtV-dmJ2zfmj3Odog3L_kc0A31eZFqvOvR=hK4VCMw@mail.gmail.com>
Message-ID: <CAHk-=wgoJtV-dmJ2zfmj3Odog3L_kc0A31eZFqvOvR=hK4VCMw@mail.gmail.com>
Subject: Re: [patch 01/21] Increase default MLOCK_LIMIT to 8 MiB
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ammarfaizi2@gnuweeb.org, andrew@donacou.ch,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Cyril Hrubis <chrubis@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, sir@cmpwn.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Dec 10, 2021 at 2:46 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> -#define MLOCK_LIMIT    ((PAGE_SIZE > 64*1024) ? PAGE_SIZE : 64*1024)
> +#define MLOCK_LIMIT    ((PAGE_SIZE > 8*1024*1024) ? PAGE_SIZE : 8*1024*1024)

I think I'll just make this

  #define MLOCK_LIMIT    (8*1024*1024)

because at the point where it's that big, there's no point in
comparing it against PAGE_SIZE any more.

If some config has that big of a page size, all the rest of the kernel
infrastructure would basically be screwed. We do a lot of core kernel
allocations in one-page chunks..

            Linus
