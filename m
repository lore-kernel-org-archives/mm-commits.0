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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEABC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 05:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1B546102A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 05:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbhICFqE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 01:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbhICFqD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2021 01:46:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2C1C061575
        for <mm-commits@vger.kernel.org>; Thu,  2 Sep 2021 22:45:04 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mj9-20020a17090b368900b001965618d019so3110330pjb.4
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 22:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Ea7FD0WPde6YonSkGR4z4c179B+D37khF0oGdfiR2N8=;
        b=nG0lBjZ8wcw7Urj2i6LRFFPSfANiJIZESYUzlWMR5CzoEZDdHhUk1SD2vfyf3/8mqD
         B8YoDUbFyzlu8bhajp8i25+ySkMIo058ucTE3NkGXZmNAgVRSNTpwRKYrIhiAOQRuymA
         2iQVrhqHw1x2zrta7evFOnG/SyN7XRdHS74Bs/LstAlD1+8N2K1yGjAWkmaT5t62W224
         hrxVOVT+qHOa1kotDQB88JjaG3+hYk55tw5sjbH45F863P/2GpbOfvnf0s9h6yqkcviC
         EADhnHaIoMdNu8mRIQHfMM78e6XYQMSRmjkmqHGdZlpRHub6mPCTsbelNkrq58pPO/xg
         omqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Ea7FD0WPde6YonSkGR4z4c179B+D37khF0oGdfiR2N8=;
        b=itHRGoOX+4AVk72SHjcWCG8KLYJeo4UeZrlHHYlGb9sEIRDMLAOu/p0lFAFfpu/r0M
         tSyI4yM59QwzoKhKTNZntznG6PKp/gmfplLligA/5RuxOhjLCuLZ3Lua2eGmMUygBIkV
         wGRgKOiLUduXevilf4EFpFeOo3YBpLdGqRhIUYK+mlRRd/Rqys6lNuvt4pI1gWgM4QZK
         TABtd15PEp2efxP7CrCJTKLRBs2pdbdQHMEg/WP0sPOgUiQZ8wA9ExpimwnrU8Q6Qomk
         uq3JErCYH6hz/qyNA7IaVuZjkmSPwnNLOq3M1usMs8lTEcor57GPoSgRfBGaQRKZfTSR
         8g+g==
X-Gm-Message-State: AOAM533LjrdMw0xbzl8AjaR1zcfxtZSTCcbLO6zm66b86rtJfZsHlQe0
        urdWBO72uo/ZGORaJgzfG2Nutu1/BGQ=
X-Google-Smtp-Source: ABdhPJyae53Zn1s4MR3rSBe42XTlIg3tUzFb2bK8hWwEpLdFXbve6jjsGcQi/GpQC9+F1WMsB2d8QA==
X-Received: by 2002:a17:90b:400c:: with SMTP id ie12mr1951368pjb.112.1630647903733;
        Thu, 02 Sep 2021 22:45:03 -0700 (PDT)
Received: from localhost (203-219-56-12.tpgi.com.au. [203.219.56.12])
        by smtp.gmail.com with ESMTPSA id w3sm3821422pjv.0.2021.09.02.22.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 22:45:03 -0700 (PDT)
Date:   Fri, 03 Sep 2021 15:44:57 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [patch 119/212] lazy tlb: shoot lazies, a non-refcounting lazy
 tlb option
To:     Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Anton Blanchard <anton@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Randy Dunlap <rdunlap@infradead.org>
References: <20210902215620._WXglfIJy%akpm@linux-foundation.org>
        <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
        <CAHk-=wjC05YZycowZkmvjZACNEm3rUhLTneN+Vaz9Ebp1+++Gw@mail.gmail.com>
        <20210902155330.a643b03dc6991cde53133edf@linux-foundation.org>
        <1630629747.odrw4rffkd.astroid@bobo.none>
        <e0166f2c-f742-635b-6b40-eef1a955f8c4@kernel.org>
In-Reply-To: <e0166f2c-f742-635b-6b40-eef1a955f8c4@kernel.org>
MIME-Version: 1.0
Message-Id: <1630646475.88h9vy4orc.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Excerpts from Andy Lutomirski's message of September 3, 2021 3:11 pm:
> On 9/2/21 5:46 PM, Nicholas Piggin wrote:
>> Excerpts from Andrew Morton's message of September 3, 2021 8:53 am:
>>> On Thu, 2 Sep 2021 15:50:03 -0700 Linus Torvalds <torvalds@linux-founda=
tion.org> wrote:
>>>
>>>> On Thu, Sep 2, 2021 at 3:29 PM Andy Lutomirski <luto@kernel.org> wrote=
:
>>>>>
>>>>> This pile is:
>>>>>
>>>>> Nacked-by: Andy Lutomirski <luto@kernel.org>
>>>>
>>>> Can you specify exactly the range you want me to drop?
>>>>
>>>> I assume it's the four patches 117-120, ie
>>>>
>>>>   lazy tlb: introduce lazy mm refcount helper functions
>>>>   lazy tlb: allow lazy tlb mm refcounting to be configurable
>>>>   lazy tlb: shoot lazies, a non-refcounting lazy tlb option
>>>>   powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
>>>>
>>>> but I just want to double-check before I do surgery on that series.
>>>
>>> Yes, those 4.
>>>
>>> Sorry, I missed that email thread...
>>>
>>=20
>> That's not reasonable. Andy has had complete misunderstandings about the
>> series which seems to stem from x86's horrible hacks that have gone in
>> has confused him.
>=20
> The horrible hacks in question are almost exclusively in core code.

No, they're in x86.

> Here's a brief summary of the situation.
>=20
> There's a messy interaction between mmget()/mmdrop() and membarrier.
> membarrier currently depends on some mmget() and mmdrop() calls to be
> full barriers.

Membarrier has had (and is improving but still has) some complexity,=20
which is caused by interaction with _existing_ lazy-mm code in the tree.=20
The complexity is not with lazy-mm itself, and my series does not add
more to the membarrier interaction. So I don't accept the criticism
that it has to do with membarrier complexity.

> You make membarrier keep working by putting an ifdef'd
> smp_mb() in the core scheduler.

Sure, it's well commented and replaces the smp_mb provided by atomic=20
operation that membarrier relied on to an explicit one. That's not a
horrible hack.

> I clean up the code to make it work
> independently of smp_mb() and therefore save the cost of the
> unconditional barrier for non-membarrier-using programs.

Great. Nothing to do with this series though which is not changing=20
membarrier ordering.

I can certainly help you rebase it on top of these patches if you need.

>=20
> Your series adds an option MMU_LAZY_TLB_REFCOUNT=3Dn for architectures to
> opt out of lazy TLB refcounting.  This is simply wrong.  Right now, the
> core scheduler provides current->active_mm and guarantees that
> current->active_mm always points to a live (possibly mm_users =3D=3D 0 bu=
t
> definitely not freed) mm_struct.  With MMU_LAZY_TLB_REFCOUNT=3Dn,
> current->active_mm still exists, is still updated, but may point to
> freed memory.

Wrong. It does nothing of the sort. I told you this in the previous=20
discussion, you obviously ignored me. You are just wrong, and you can't
actually point to where this happens.

This criticism is invalid too.

> I consider this unacceptable.  A comment says "This can
> be disabled if the architecture ensures no CPUs are using an mm as a
> "lazy tlb" beyond its final refcount" -- that's nice, but saying "well,
> if you this, you have to make sure you don't accidentally dereference
> that juicy dangling pointer we give you" is, in my book, a poor
> justification.

It's not a justification, it's a recipe for other archs which might want=20
ot implement it!

>=20
> I have no particular objection to the actual shoot lazies part, except
> insofar as I think we can do even better (e.g. my patch).  But 90% of
> the complexity of my WIP series is cleaning up the mess so that we can
> have a maintainable lazy mm mechanism instead of expanding the current
> hard-to-maintain part into three separate possible modes.

What actually happened is that when you ran out of (incorrect) technical=20
disputes like this confusion about the active_mm thing, you then started=20
to demand that I massively rework core code that you don't understand so=20
that it matches the horrible mess that x86 has got itself into. I can
bring up quotes from previous threads.

>=20
> Maybe I'm holding my own patches to an excessively high standard.
>=20
>=20
>=20
>>=20
>> My series doesn't affect x86 at all and it's no reason why Andy's series
>> to improve x86 can't be merged later. But that half finished series he=20
>> keeps threatening with has been sitting there for almost a year now and=20
>> it's gone nowhere, while there have been no unresolved technical=20
>> objections to mine, it works, it's simple and small.
>=20
> My series barely touches x86.

I'm talking about your previous insistence that my patch series removed=20
"active_mm" from core code, because it doesn't match x86 internals, and=20
similar such stupidity.

> The only "hack" is that x86 may have a
> CPU that has ->mm =3D=3D NULL, ->active_mm !=3D NULL, CR3 pointing to the=
 init
> pgd, and mm_cpumask clear.  I don't see why this is a problem other than
> being somewhat unusual.  But x86 bare metal, like every architecture
> that can only flush the TLB using an IPI, can very efficiently shoot
> lazies, since it shoots the lazies anyway when tearing down pagetables,
> but actually enabling the config option with this series applied will
> result in ->active_mm pointing to freed memory.  Ick.
>=20
>>=20
>> I've kept trying to offer to help Andy with reviewing his stuff or fix=20
>> the horrible x86 hacks, but nothing.
>=20
> I haven't finished it yet.  Sorry.
>=20

No need to be sorry about that, it will be trivial to rebase on top of=20
my series, I've even done a quick attempt. No problem at all.

Thanks,
Nick
