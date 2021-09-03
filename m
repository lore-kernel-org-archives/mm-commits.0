Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837FEC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 00:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AFB160FD7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 00:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346596AbhICArX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 20:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346591AbhICArX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Sep 2021 20:47:23 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5947DC061575
        for <mm-commits@vger.kernel.org>; Thu,  2 Sep 2021 17:46:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d3-20020a17090ae28300b0019629c96f25so2771811pjz.2
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 17:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=N2BdmhRUmSQiNzMSMVImm25XlVE/wi7ggyxEJHpZ/ew=;
        b=T8Vn4YU3vukbWXQQqh3eBzB7cojn2HRpBM+mLtqVGwmUkKvm5F8TfoBw9gIKMbOM4m
         g09dbtbjMHxXsqE/5yH3lm1ERm8HrXY/i0sgS25l+hHPytXFdwJ7DsojbSYconlrA2h9
         EFH5O7e3vif39sfciCf02SPS41I0d18zn4zt4H6Jx4grd5h1MKoqCKL6gWEjFtUK9nbI
         VmBQkcWdXj06V73h8MYNT+xSTEhbm7Wb1SaOyum/sYoS4nYB6Z28R4YKNR15bFqpVR4P
         i7dPuPAgYBX9mnHjp3T6K0nQUvHL3HsKnKArKjNiYwy3Dwwj7fELi0rLXwMqIuiSNzEd
         rDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=N2BdmhRUmSQiNzMSMVImm25XlVE/wi7ggyxEJHpZ/ew=;
        b=QgtAYSUKAVKmPFTEm+NUFuAxH1qWhiek9ExNiXPkQZ54AQJH2zwDPYNSNBX8dgWEo+
         KrYC1qGDKl1E0WwOmJikvE46QUWYhV3Egri1BylY40lHHkqALgAJZJrN1I9qR0slgtN3
         sQlDuRqFS0CmtjAzLauGKquwhA3nJ5e7ttxwLzIfk2T8c1vv2RFKbnPLlNIsZ2yClhLq
         az90YsaUYkh55lXa+yAW/f0GWABvlO1gzErYnE50bzO+cU1/u8IZVUWlX3lDYt3xTiJR
         I18YEuPOBBaKmI65ixr8Ohgl0ndXaxaf1dMEgO0NNUBgCBJdvK/BsbO7uhzhJw3bx1fv
         UxFg==
X-Gm-Message-State: AOAM5326r3xFOaVRQ9f5pWeVQl097WAi3t3OaTS/aXKw0248sbU0zXx9
        4cxsZZDHHU/no5ECNtE/aEU=
X-Google-Smtp-Source: ABdhPJwhvC28qw4rSl7SY7gGtBznms7lX2PFw6l199xd31+jtm5BXHU/X8LnuDy5MSgiQ1lpA4ft/g==
X-Received: by 2002:a17:902:b48c:b0:139:eec4:737c with SMTP id y12-20020a170902b48c00b00139eec4737cmr929609plr.11.1630629983869;
        Thu, 02 Sep 2021 17:46:23 -0700 (PDT)
Received: from localhost (203-219-56-12.tpgi.com.au. [203.219.56.12])
        by smtp.gmail.com with ESMTPSA id v7sm3153207pjg.34.2021.09.02.17.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 17:46:23 -0700 (PDT)
Date:   Fri, 03 Sep 2021 10:46:18 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [patch 119/212] lazy tlb: shoot lazies, a non-refcounting lazy
 tlb option
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Anton Blanchard <anton@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux-MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>,
        mm-commits@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Randy Dunlap <rdunlap@infradead.org>
References: <20210902215620._WXglfIJy%akpm@linux-foundation.org>
        <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
        <CAHk-=wjC05YZycowZkmvjZACNEm3rUhLTneN+Vaz9Ebp1+++Gw@mail.gmail.com>
        <20210902155330.a643b03dc6991cde53133edf@linux-foundation.org>
In-Reply-To: <20210902155330.a643b03dc6991cde53133edf@linux-foundation.org>
MIME-Version: 1.0
Message-Id: <1630629747.odrw4rffkd.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Excerpts from Andrew Morton's message of September 3, 2021 8:53 am:
> On Thu, 2 Sep 2021 15:50:03 -0700 Linus Torvalds <torvalds@linux-foundati=
on.org> wrote:
>=20
>> On Thu, Sep 2, 2021 at 3:29 PM Andy Lutomirski <luto@kernel.org> wrote:
>> >
>> > This pile is:
>> >
>> > Nacked-by: Andy Lutomirski <luto@kernel.org>
>>=20
>> Can you specify exactly the range you want me to drop?
>>=20
>> I assume it's the four patches 117-120, ie
>>=20
>>   lazy tlb: introduce lazy mm refcount helper functions
>>   lazy tlb: allow lazy tlb mm refcounting to be configurable
>>   lazy tlb: shoot lazies, a non-refcounting lazy tlb option
>>   powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
>>=20
>> but I just want to double-check before I do surgery on that series.
>=20
> Yes, those 4.
>=20
> Sorry, I missed that email thread...
>=20

That's not reasonable. Andy has had complete misunderstandings about the
series which seems to stem from x86's horrible hacks that have gone in
has confused him.

My series doesn't affect x86 at all and it's no reason why Andy's series
to improve x86 can't be merged later. But that half finished series he=20
keeps threatening with has been sitting there for almost a year now and=20
it's gone nowhere, while there have been no unresolved technical=20
objections to mine, it works, it's simple and small.

I've kept trying to offer to help Andy with reviewing his stuff or fix=20
the horrible x86 hacks, but nothing.

So

Un-Nacked-by: Nicholas Piggin <npiggin@gmail.com>


Thanks,
Nick
