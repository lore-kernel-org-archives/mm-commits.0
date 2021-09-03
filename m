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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AC5C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 23:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C78560698
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 23:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhICXtg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 19:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbhICXtg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2021 19:49:36 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F2CC061575
        for <mm-commits@vger.kernel.org>; Fri,  3 Sep 2021 16:48:35 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d3-20020a17090ae28300b0019629c96f25so619519pjz.2
        for <mm-commits@vger.kernel.org>; Fri, 03 Sep 2021 16:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=FUw/U7wUzdkNKq4EJmFyiRWw+zm4MYy5pAm6ERlKeMs=;
        b=KXvATiNRBADllyLI+dSMz+MSGHXzxRL3PAJy7MNOfqEruP+/vXR8dEFQj39JLPceQF
         tJLG5iqtm5iNlC5BQf/1WKLBLCMyjSBHznPBNCWZbqYoNy1ltodT2wWos3M3PTiuK9lI
         89PF1weszbNqhcsl8L4CsFRmO2Fu1lfOL4Ns0A/P3RPsrbQTRgkaAV1UfSsaLIFKhue9
         s+JmG3AFVMB3cUYoGh2qw27E5lAfrXaSJv5CDo/1dGfpkSLRwje5QDBAoTkr3StsOWrs
         2XPd2zvrSdHrgPvP7xWDJZ0GHp3C7e7SU3v4q2OMxhYxiUKzkoLZXi7kMJTS4vcIzJqc
         ifwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=FUw/U7wUzdkNKq4EJmFyiRWw+zm4MYy5pAm6ERlKeMs=;
        b=A3OEZZRPKR4wzqIqRkwdKLlarG3C7Zh9V0CqvPJpjb0BIAgBSmiDJrnNLJTQwlOHz4
         L058apl0da6hJyLxUU6yVJVjPLyY3iuo2wrnxGayJbU0FZC0xCXreBxps2tkocb5FZE3
         WaVGMU1DvWIcv90G0T5mE/LAqEoR+vlN8R0ygcdcyg+Ub6J5seis6GH5eO88fOhSK2em
         NBb3J/+8Ivwlq73DuKVv2c7hiR29fnumX91dHxTZF3GgyvOpBEL1QbqQeRLymPXgcUYw
         LFeAUoFIXUHlpLiN6mzxesC/CwkwFAnV94EmTTiXR8/luGBuoww5rf6KcmtWQK6SzeTG
         023A==
X-Gm-Message-State: AOAM531SIC2L8ACIweVptnWzwxJ+ZeQx9NCojh/qaJ/6IoIQDYaZrQfo
        sG2xLtIZ+9t6uN7RBZjfm/M=
X-Google-Smtp-Source: ABdhPJzoXG1o3Fu65K32iIkeyYTgof+Pg2BEFVH2knjcjfUgV2uNxpN2GWg1Efj+oAElYAJptKN4Xw==
X-Received: by 2002:a17:902:7282:b029:12c:75a0:faa5 with SMTP id d2-20020a1709027282b029012c75a0faa5mr942586pll.35.1630712915462;
        Fri, 03 Sep 2021 16:48:35 -0700 (PDT)
Received: from localhost (203-219-56-12.tpgi.com.au. [203.219.56.12])
        by smtp.gmail.com with ESMTPSA id p16sm294532pjz.44.2021.09.03.16.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 16:48:35 -0700 (PDT)
Date:   Sat, 04 Sep 2021 09:48:29 +1000
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
        <1630646475.88h9vy4orc.astroid@bobo.none>
In-Reply-To: <1630646475.88h9vy4orc.astroid@bobo.none>
MIME-Version: 1.0
Message-Id: <1630712651.bfnp24hcmw.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Excerpts from Nicholas Piggin's message of September 3, 2021 3:44 pm:
> Excerpts from Andy Lutomirski's message of September 3, 2021 3:11 pm:
>> On 9/2/21 5:46 PM, Nicholas Piggin wrote:
>>> Excerpts from Andrew Morton's message of September 3, 2021 8:53 am:
>>>> On Thu, 2 Sep 2021 15:50:03 -0700 Linus Torvalds <torvalds@linux-found=
ation.org> wrote:
>>>>
>>>>> On Thu, Sep 2, 2021 at 3:29 PM Andy Lutomirski <luto@kernel.org> wrot=
e:
>>>>>>
>>>>>> This pile is:
>>>>>>
>>>>>> Nacked-by: Andy Lutomirski <luto@kernel.org>
>>>>>
>>>>> Can you specify exactly the range you want me to drop?
>>>>>
>>>>> I assume it's the four patches 117-120, ie
>>>>>
>>>>>   lazy tlb: introduce lazy mm refcount helper functions
>>>>>   lazy tlb: allow lazy tlb mm refcounting to be configurable
>>>>>   lazy tlb: shoot lazies, a non-refcounting lazy tlb option
>>>>>   powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
>>>>>
>>>>> but I just want to double-check before I do surgery on that series.
>>>>
>>>> Yes, those 4.
>>>>
>>>> Sorry, I missed that email thread...
>>>>
>>>=20
>>> That's not reasonable. Andy has had complete misunderstandings about th=
e
>>> series which seems to stem from x86's horrible hacks that have gone in
>>> has confused him.
>>=20
>> The horrible hacks in question are almost exclusively in core code.
>=20
> No, they're in x86.
>=20
>> Here's a brief summary of the situation.
>>=20
>> There's a messy interaction between mmget()/mmdrop() and membarrier.
>> membarrier currently depends on some mmget() and mmdrop() calls to be
>> full barriers.
>=20
> Membarrier has had (and is improving but still has) some complexity,=20
> which is caused by interaction with _existing_ lazy-mm code in the tree.=20
> The complexity is not with lazy-mm itself, and my series does not add
> more to the membarrier interaction. So I don't accept the criticism
> that it has to do with membarrier complexity.
>=20
>> You make membarrier keep working by putting an ifdef'd
>> smp_mb() in the core scheduler.
>=20
> Sure, it's well commented and replaces the smp_mb provided by atomic=20
> operation that membarrier relied on to an explicit one. That's not a
> horrible hack.
>=20
>> I clean up the code to make it work
>> independently of smp_mb() and therefore save the cost of the
>> unconditional barrier for non-membarrier-using programs.
>=20
> Great. Nothing to do with this series though which is not changing=20
> membarrier ordering.
>=20
> I can certainly help you rebase it on top of these patches if you need.
>=20
>>=20
>> Your series adds an option MMU_LAZY_TLB_REFCOUNT=3Dn for architectures t=
o
>> opt out of lazy TLB refcounting.  This is simply wrong.  Right now, the
>> core scheduler provides current->active_mm and guarantees that
>> current->active_mm always points to a live (possibly mm_users =3D=3D 0 b=
ut
>> definitely not freed) mm_struct.  With MMU_LAZY_TLB_REFCOUNT=3Dn,
>> current->active_mm still exists, is still updated, but may point to
>> freed memory.
>=20
> Wrong. It does nothing of the sort. I told you this in the previous=20
> discussion, you obviously ignored me. You are just wrong, and you can't
> actually point to where this happens.
>=20
> This criticism is invalid too.

If there's no further objections that can be substanitated, then=20
can we merge this please?

By the way I should add -

>>> I've kept trying to offer to help Andy with reviewing his stuff or fix=20
>>> the horrible x86 hacks, but nothing.
>>=20
>> I haven't finished it yet.  Sorry.
>>=20
>=20
> No need to be sorry about that, it will be trivial to rebase on top of=20
> my series, I've even done a quick attempt. No problem at all.

This alternative is far from a foregone conclusion even if it does ever=20
get finished. It adds significant ordering complexity to core scheduler
that my approach does not have, for no benefit for powerpc and likely=20
no measurable benefit for others either. The first hurdle for it=20
obviously will be why can't x86 be updated to use this shoot-lazies=20
work, with actual numbers.

Thanks,
Nick
