Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93615C25B08
	for <mm-commits@archiver.kernel.org>; Fri,  5 Aug 2022 23:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241565AbiHEXcz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Aug 2022 19:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241236AbiHEXcy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 Aug 2022 19:32:54 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFAB1A817
        for <mm-commits@vger.kernel.org>; Fri,  5 Aug 2022 16:32:53 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id y13so7388381ejp.13
        for <mm-commits@vger.kernel.org>; Fri, 05 Aug 2022 16:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oX5dixeC5cISzlmeE16lJbqJDGD4u5Eew52IH1AkIug=;
        b=OGweQEBV6PwoBvKXWW7hNFk0oy34DwHtq9zVl/wNvm42Kggg7c0oJ/FBOOo1oQaG3b
         vBKqmHIuluGFEQKNy3P/KT7LWjqca78MHWczUx6TQysIZkKyAE927djCJSimDev2kNRi
         Bq1V6hnmwcqPo/6RS8mi1/QjimKryQFOdsZ3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=oX5dixeC5cISzlmeE16lJbqJDGD4u5Eew52IH1AkIug=;
        b=uUqz0mkb0wxKOVtyBNU3fGDqFZr7Fm4OMqCuFkDdxAYpR1qo9SQ0+wLNAIK8vV1xUi
         mWiUS9G+jWmThtaFaV7W6cU1QY5AWxQwP+gyfkcG4RlsoPArJwccVuNalgWl5L04IW2x
         7Fuv8wtfxytBlQMYAnEnKmNnmwYVdmJ1VItIMv4Kf+pEoDCzyrr6SdZp7rF+CKZ+GmHe
         Abk6gdABagIqvPp7b8y+w3LsD86/IEHKKdoATzHhUncRNrEPvd7flJEo6yAn2wa4ERH5
         8bnquPv1sJkfcLh3VTqriIsM5TXW2udwSs4yuGOKF70ybHhI6wsHyhLwhu6xmVZmfXw1
         SQPg==
X-Gm-Message-State: ACgBeo2x+By6Uk4Pjl1GAWLYiz4wcyP07ltmJwzNkusspBKYxT1FYIII
        SJOUDZciqJgRrOQsWo2idwATiddcz7Vcxfts
X-Google-Smtp-Source: AA6agR45YuhEjg0C0aWG4Z+nmHXVSzQKoY/qNwQRIynkdonmn3v6bvMtW+UXpwB29cs/iRc7eYL8cA==
X-Received: by 2002:a17:906:ee8e:b0:730:3646:d178 with SMTP id wt14-20020a170906ee8e00b007303646d178mr6936384ejb.426.1659742371337;
        Fri, 05 Aug 2022 16:32:51 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id a4-20020a170906684400b0073080c22898sm2156362ejs.15.2022.08.05.16.32.50
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 16:32:50 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id j1so4795702wrw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Aug 2022 16:32:50 -0700 (PDT)
X-Received: by 2002:a5d:638b:0:b0:220:6e1a:8794 with SMTP id
 p11-20020a5d638b000000b002206e1a8794mr5558868wru.193.1659742370294; Fri, 05
 Aug 2022 16:32:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220803133541.18b82ec9344ed0e8b975fe5b@linux-foundation.org>
In-Reply-To: <20220803133541.18b82ec9344ed0e8b975fe5b@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 5 Aug 2022 16:32:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiOSXvk=70tpR9E1tvDmCf8s-81bT+92aE-iKocxdTsyw@mail.gmail.com>
Message-ID: <CAHk-=wiOSXvk=70tpR9E1tvDmCf8s-81bT+92aE-iKocxdTsyw@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 5.20-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Aug 3, 2022 at 1:35 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - memcg debug/visibility work from Roman Gushchin

Well, not just memcg.

There's that new CONFIG_SHRINKER_DEBUG too.

Which looks like yet another "people add Kconfig options incorrectly".

We don't make new features "default y" unless there's some truly
pressing reason for it (ie "99.9% of all people will want this" or "we
used to always compile this in, now it's optional").

And shouldn't that thing be under the DEBUG_VM heading anyway?

I removed the completely bogus and inappropriate "default y".

People, please stop doing that 'default y' thing.

I realize that everybody always thinks their own code is *sooo*
important that it should be enabled everywhere, but if we've gone 30
years without it in the past, maybe it's not so critical after all,
and maybe people shouldn't randomly enable it unless they WANT it. Ok?

The main reasons for 'default y' tend to be literally

 - this used to be unconditional, now we have a config variable for
it, so let's make it 'default y' so that people don't suddenly lose
functionality

 - this feature truly does cure cancer

 - this isn't actually a feature, but is a gating question to other
features that you may want to just shut up

That last case is mainly used by the network driver subsystem, where
it asks 'Do you want to see drivers by vendor Xyzzy?', and it defaults
to indeed show those options. But admittedly that network driver case
is also _partly_ guided by that first case, ie it has often been
something where a group of drivers were moved to be under a "do you
care about this vendor" situation.

                     Linus
