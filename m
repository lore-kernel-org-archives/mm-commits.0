Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A965C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 19:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F6E6108B
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 19:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhKFTNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 15:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbhKFTND (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 Nov 2021 15:13:03 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0A7C061570
        for <mm-commits@vger.kernel.org>; Sat,  6 Nov 2021 12:10:21 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id v15so13825554ljc.0
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 12:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ztrNCKNvh9kcKRx5BSbp1Y5Vza3mT2w1IWh73cmwDbA=;
        b=RNHsTOUuaHLjmQIfpKECwMmU0SR9oIM4qMYymyTSWvraciRRosgL6QDlh8FeCp15dx
         NLMyaK4dOGXUQzfRr5nGS6LILLkb0OqTc7Gj3GnStgVpS1iF/D2cyQ0QVAY6sZ3wiO+P
         ZqUvz2D+pfC44b+qqMUrWNz6BXXXK6ptF/YeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ztrNCKNvh9kcKRx5BSbp1Y5Vza3mT2w1IWh73cmwDbA=;
        b=rWQn8q7IF/XM/CbPLyLemfuIFKHmS3g8h6GPSuZRZKVqbDOKA4OqJSqoWTEV5Keahp
         gKHCtTedH7oDFRDDJtaYkoBalzAUX6p2AFLQXNaXNAyQ8PW8Eyd7vFXuwpKOpe6vX8zB
         sjaEY6oVFVHgIyXBNnyjf7InfzWCID49uPFpuC2URvU9FYEimr8riFYgxi9xRiraq7JK
         Zlq3bU6jSXGRmd4WZXW3WjmOVAFfSpDTnL3piZZxL7QXFW11Uu0DPw6qctvx6F7c1muP
         o4m263vkz9OuCmeGn/Wme7COmU1np5PSOfUSnNv2YzXnh1hw96SvvTgDXvmEI2Upk0yu
         zZuA==
X-Gm-Message-State: AOAM530bOZ7TuJw8EVltYAJv0vOY4fjglsjVKC+cBTL09NsFpkak2bs2
        URziNkML40De2Ko5cLsXMU47dqhiXy2G1p0VHIY=
X-Google-Smtp-Source: ABdhPJx4rUTjo39LmJxWRd92AzprlZSzpPNvmMJTi4Ne+t78fDVndWMWY37WXcFNgQ8uItn2IbshOQ==
X-Received: by 2002:a05:651c:1543:: with SMTP id y3mr47768604ljp.511.1636225819617;
        Sat, 06 Nov 2021 12:10:19 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id x20sm1235596lfu.196.2021.11.06.12.10.17
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 12:10:18 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id u11so26054441lfs.1
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 12:10:17 -0700 (PDT)
X-Received: by 2002:ac2:57d3:: with SMTP id k19mr13896204lfo.150.1636225817467;
 Sat, 06 Nov 2021 12:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20211105203851.Ise-VKP1_%akpm@linux-foundation.org> <9f241d37-5db8-4cd2-95c5-ef35844d8b08@www.fastmail.com>
In-Reply-To: <9f241d37-5db8-4cd2-95c5-ef35844d8b08@www.fastmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 6 Nov 2021 12:10:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wirXEyqcBwL6_WttZqPb+A6hWfOjOks5NU6eB8uturHdw@mail.gmail.com>
Message-ID: <CAHk-=wirXEyqcBwL6_WttZqPb+A6hWfOjOks5NU6eB8uturHdw@mail.gmail.com>
Subject: Re: [patch 080/262] lazy tlb: allow lazy tlb mm refcounting to be configurable
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Dropped once again until people can agree on this all..

               Linus

On Fri, Nov 5, 2021 at 9:29 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> So I think there are a few credible choices:
>
> 1. Find an alternative solution that gets the performance we want without=
 dangling references.
>
> 2. Make the MMU_LAZY_TLB_REFCOUNT mode genuinely safe.  This means litera=
lly ifdeffing out active_mm so it can't dangle.  Doing that cleanly will be=
 a lot of nasty arch work.
>
> I again apologize that my series is taking so long, although I think it's=
 finally getting into decent shape.  I still need to deal with the scs mess=
 (that's new), finish tidying up kthread, and make sure hotplug is good.  B=
ut all this is because this is really hairy code and I'm trying to do it ri=
ght.
>
> If anyone wants to help, help is welcome.  Otherwise, I really do intend =
to get it all the way done soon.
>
> --Andy
