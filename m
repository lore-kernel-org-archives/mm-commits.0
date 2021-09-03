Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8B2C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 00:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 168BA61056
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 00:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhICAtJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 20:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbhICAtI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Sep 2021 20:49:08 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AF4C061575
        for <mm-commits@vger.kernel.org>; Thu,  2 Sep 2021 17:48:09 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id r13so2978319pff.7
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 17:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:references:in-reply-to:mime-version:message-id
         :content-transfer-encoding;
        bh=+18oeo+OGr71BMoOWexeG9aX72YBISWj1VF0yl+y9zg=;
        b=Y6RhjmseUZIS66CGSthEj3Wel0Nyhl2uwKRthJYu3IW0/sjxUQRigQDnBjm/ZO1ptE
         p8OlykAEG8HDkLnvT1hSCUw1+njBPI55Xvt+VA6AlvOjVzl5zAU5oMZsESvCgDC5W+2C
         H2abrFFS8CZP9e1v4aWoyueyqyfvv/yxDc3bhTX+J/u1lJjPVcR10uMno223wNqeyJLH
         YCF5bXp2IAptQrSRcnsL2s2EqPTFLLsFl0s0Cx3+DUa9VXDmnIYygq/8pvEF7K3cj8vh
         e1J4d6VOwLcZSzLWQE1tQTDBZDoOWtzcIIWIBSR7GNaCPi2IqQWn2ofqZbF1zSp6/5wN
         sUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=+18oeo+OGr71BMoOWexeG9aX72YBISWj1VF0yl+y9zg=;
        b=izEI0UVa5kK7dUrGweVnDgraBcQlWCwhIelwP+HD4O8LkyT5NW13S38yHo6PfyODD6
         Y+0XeGtci3Y1aZr2BXtvVMG3yDsJnihwZR4/w+bxjuR/fQrQ8KtDM+8s6mN4Fu0uB1M3
         1lnR9VpzbggPinFc0Up+cp/xG5sGmUdF6gtFFdeMHaepeL1FqVZEZMcMGX7ef9grVjsN
         Vca00M9ZHuYbWShD5wLmGZGuuFmVdc94QyqXttwIYK0O/tmM8LWmpG712rbRtOGkervt
         da9Fhb8iR6FtExBQW1POLUtzsiTYd1orWEAS2cHrghHyasIBp42ssonxxiuDVXTyeXkR
         UmJg==
X-Gm-Message-State: AOAM531OmDAlfoaGKydq4xqu3FOCv79Wc+LdQ2fBdj9KgH4kESVbMZCK
        7GS2GrNwWngYMNRGNas0J1s=
X-Google-Smtp-Source: ABdhPJxZNt9AgvXxmXgCbB+pBbcfTyBAjFVvyoyj9sFucrIg7K3XY/JoTJ6g/9BA2BzMRyzT+lec2A==
X-Received: by 2002:aa7:8387:0:b029:395:a683:a0e6 with SMTP id u7-20020aa783870000b0290395a683a0e6mr778373pfm.12.1630630089131;
        Thu, 02 Sep 2021 17:48:09 -0700 (PDT)
Received: from localhost (203-219-56-12.tpgi.com.au. [203.219.56.12])
        by smtp.gmail.com with ESMTPSA id u9sm3942905pgp.83.2021.09.02.17.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 17:48:08 -0700 (PDT)
Date:   Fri, 03 Sep 2021 10:48:03 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [patch 119/212] lazy tlb: shoot lazies, a non-refcounting lazy
 tlb option
To:     Andrew Morton <akpm@linux-foundation.org>, anton@ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-mm@kvack.org, Andy Lutomirski <luto@kernel.org>,
        mm-commits@vger.kernel.org, paulus@ozlabs.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20210902215620._WXglfIJy%akpm@linux-foundation.org>
        <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
In-Reply-To: <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
MIME-Version: 1.0
Message-Id: <1630629987.6eck6qpy33.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Excerpts from Andy Lutomirski's message of September 3, 2021 8:28 am:
>=20
>=20
> On Thu, Sep 2, 2021, at 2:56 PM, Andrew Morton wrote:
>> From: Nicholas Piggin <npiggin@gmail.com>
>> Subject: lazy tlb: shoot lazies, a non-refcounting lazy tlb option
>>=20
>> On big systems, the mm refcount can become highly contented when doing a
>> lot of context switching with threaded applications (particularly
>> switching between the idle thread and an application thread).
>>=20
>> Abandoning lazy tlb slows switching down quite a bit in the important
>> user->idle->user cases, so instead implement a non-refcounted scheme tha=
t
>> causes __mmdrop() to IPI all CPUs in the mm_cpumask and shoot down any
>> remaining lazy ones.
>>=20
>> Shootdown IPIs are some concern, but they have not been observed to be a
>> big problem with this scheme (the powerpc implementation generated 314
>> additional interrupts on a 144 CPU system during a kernel compile).  The=
re
>> are a number of strategies that could be employed to reduce IPIs if they
>> turn out to be a problem for some workload.
>=20
> This pile is:
>=20
> Nacked-by: Andy Lutomirski <luto@kernel.org>
>=20
> For reasons that have been discussed previously. My series is still in pr=
ogress.  It=E2=80=99s moving slowly for two reasons.  First, I have limited=
 time to work on it. Second, the existing mm refcounting is a giant pile of=
 worms, and that needs fixing one way or another before we add yet more com=
plexity. For example, has anyone noticed that kthread mms are refcounted us=
ing different rules than everything else?

It's been like a year with ~no progress. mm refcounting is not a pile of =20
worms, as you can see in my series it's pretty simple. The _x86_ mm=20
refcounting is a huge pile of crap, but that doesn't give reason to nack=20
this series.

>=20
> Even if my modified refcounting scheme isn=E2=80=99t the eventual winner,=
 the prerequisite cleanups are still prerequisites. I absolutely nack anyth=
ing that adds yet more nonsensical complexity to the existing scheme, makes=
 it substantially more fragile, and does not fix the underlying crap that m=
akes speeding up responsibly such a mess.
>=20
> Nick or anyone else, you=E2=80=99re welcome to finish up my series (and I=
 can give pointers) or you can wait.

You or anyone else is welcome to rebase your series on top of mine.

Thanks,
Nick
