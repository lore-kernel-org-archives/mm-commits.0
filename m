Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDA6C2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 06:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8273233A1
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 06:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgLPGPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 01:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgLPGPQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2020 01:15:16 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B2AC0613D6
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 22:14:35 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id a9so45490357lfh.2
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 22:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CR2otONYlokw0GfLrlAOA0cRSyLLzIaYsg7/fCheg8=;
        b=ebuD14yS2VHtFktVMRjuymyPnZpmtjqZviQDsXDI7MBL56e2Dd6L8nwLesychxeQhb
         wMkyCLNg5+FCQTl06fjfFr4TCWSbo73Qm2k5XxIsU91xliZ4SQZ8NohkxDKELP8XkFZv
         nCzwMkAo19YrGkkXsbRqX1ksopoMCJTCDCK3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CR2otONYlokw0GfLrlAOA0cRSyLLzIaYsg7/fCheg8=;
        b=Cv3+Z4i3WBWEHcbHK4c2/DNxMRgmF7H3O2A+mv11Fzd0Jq884r7a8VzFlHIohKEKjt
         jM48j/MGLI48TLths+aMQNggtqrLIMiKoF1oaxiKIHvc+wlCIqGXL8ranvoz0KqneWF9
         9kRYhIkN77xH3pzZFSfLPBtxKJp8AIntYy7N2a9NEg6hOk9V6VAQJm1Z6tWXEIvf4ko+
         FwB1yZ156ywks1y2yPPFWrZr2w6aDNuCZ3gmxf6JJADWFZk3/3BteuW11GLwGmrQLsSl
         60ZH7pk7OGpNA3a5BuDCdIr68f74iIRWk1aZEArWfgHwGyGzyA6yQZKCW5hvM3sIL5qw
         JZNA==
X-Gm-Message-State: AOAM530beQzt8bkc+6Lq3oDf+r/s+tUNwk0V8Jsbm6T4eLDX/1sW0mfo
        89m7JgWVU5thA4kUvHzj5TjhV40GIhyZCw==
X-Google-Smtp-Source: ABdhPJytyop/GK1DDYW6qMuhjiP9tzf93ZD9VKs1uUVoVnccUN6D4hDgxjMrTRRXlKP/7zVXf0ydWQ==
X-Received: by 2002:a19:8053:: with SMTP id b80mr4506142lfd.74.1608099273733;
        Tue, 15 Dec 2020 22:14:33 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id j2sm100358lfe.213.2020.12.15.22.14.32
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 22:14:32 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id o17so42551358lfg.4
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 22:14:32 -0800 (PST)
X-Received: by 2002:a19:7d85:: with SMTP id y127mr12843127lfc.253.1608099272236;
 Tue, 15 Dec 2020 22:14:32 -0800 (PST)
MIME-Version: 1.0
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org> <20201216044407.mwZ3xRLJw%akpm@linux-foundation.org>
In-Reply-To: <20201216044407.mwZ3xRLJw%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Dec 2020 22:14:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiv1OtUti9AqQDV7vOX5j4n9_U70o2KHQJjeJN57wXnbw@mail.gmail.com>
Message-ID: <CAHk-=wiv1OtUti9AqQDV7vOX5j4n9_U70o2KHQJjeJN57wXnbw@mail.gmail.com>
Subject: Re: [patch 33/95] bitops: introduce the for_each_set_clump macro
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux-MM <linux-mm@kvack.org>, michal.simek@xilinx.com,
        mm-commits@vger.kernel.org,
        Syed Nayyar Waris <syednwaris@gmail.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 15, 2020 at 8:44 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Syed Nayyar Waris <syednwaris@gmail.com>
> Subject: bitops: introduce the for_each_set_clump macro
>
> Patch series "Introduce the for_each_set_clump macro", v12.

I'm going to skip this series too.

I don't like how it adds a _really_ obscure function to a _very_ core
header file that is basically included by everything.

If I read the patches right, there is exactly one user. Maybe there
will be more, but it really isn't appropriate to add this kind of
super-rare specialized thing to everybody.

Yes, I may be more sensitive than most, because all my CPU time is
spent compiling. Particularly during the merge window. But I really
don't want to see random stuff added to core headers.

Start off making this a local "clump_bits.h" header just in the GPIO
driver directory. If there is ever another user, maybe it can become a
generic clump_bits.h header at that point. But I have to say, I can't
recall ever having seen or needed this kind of generic bit clumping
interface.

              Linus
