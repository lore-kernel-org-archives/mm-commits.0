Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB69C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 17:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C4F961108
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 17:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhIIRgY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 13:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237190AbhIIRgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Sep 2021 13:36:22 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72173C061574
        for <mm-commits@vger.kernel.org>; Thu,  9 Sep 2021 10:35:12 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id l18so4164659lji.12
        for <mm-commits@vger.kernel.org>; Thu, 09 Sep 2021 10:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5I/p9vgdVC2lD0iwMlo1HNJ1u/3WVtIOcQkI802FYRs=;
        b=T7vayAUmpXvqbxqhJLahdGloeJKPXoCKZVVhQ1VK2HqSTvDVA0n8hY4Sw4Tyd3frWM
         lV2+7TKHSGkxOMhuaLiKg2ehGDHDl66WK0/seFZfwnIOaCMY3dm2g6skqWNZx8XmkwEI
         apspY5qzRYaHG/duUp7Kh1N3Gga025Ml9knXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5I/p9vgdVC2lD0iwMlo1HNJ1u/3WVtIOcQkI802FYRs=;
        b=dKTbp8fczsz/2zfiqCxzGsydtTlsPRby3Xv/oUUzHFSFYZ8RAyU01NMhP5bRv0Uku1
         tiL3fGoxfmZ2TtQv46WjB0bB4AhNYUaZOiihtKFS9QfxBsmJdyMHu5DKuIdHxyESD3Wb
         Q1DK65OEekafzwtNy+27vrMNeJZzGuiUdYNCxuwCmMHlaHROP7QcO2TjkhU6pyqD/IXk
         tsMvdwcn8l4Q6ftAnIGd2iiwauq4vkklBZcGXrsDJcQksu9M46r8d1t2ZaTZu3qS4pZp
         pXxpsYlJKE0OsUYbkdfS7nfKuNUR07RxwJha+NVs4J+94u7IfK3y4CV5JfL+ot/ahqjQ
         1D4A==
X-Gm-Message-State: AOAM531rnyB8aErSsSenySWlxGK1n3wH1DiSM3D1kxvn36inNGJDGoyr
        M7wNN83e1ygNmbL337QXsyHSUunXevl2r4bppWA=
X-Google-Smtp-Source: ABdhPJwH7fmwciU52cmHi/sch+ldG4ytEIEnxsutF+V/WN4YkbDX8+Jfb10DmhUI5xa6lp66aMwImQ==
X-Received: by 2002:a2e:99d9:: with SMTP id l25mr796784ljj.217.1631208910592;
        Thu, 09 Sep 2021 10:35:10 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id d7sm269081ljc.129.2021.09.09.10.35.09
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 10:35:09 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id r3so4202624ljc.4
        for <mm-commits@vger.kernel.org>; Thu, 09 Sep 2021 10:35:09 -0700 (PDT)
X-Received: by 2002:a05:651c:94:: with SMTP id 20mr846463ljq.164.1631208909475;
 Thu, 09 Sep 2021 10:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908025730.S88ylmikU%akpm@linux-foundation.org> <CAHk-=wgQ+8kmczLLKCY7yDsGHQBRcZESKd1dNaKbrjUgbWeb3A@mail.gmail.com>
 <fab939c0-42c1-f6ee-f7f8-14280cb5b411@bytedance.com> <CAHk-=wjb=emq204cCuW9VWKawbmLRXfHCLHWmyiDysOfs03TiA@mail.gmail.com>
In-Reply-To: <CAHk-=wjb=emq204cCuW9VWKawbmLRXfHCLHWmyiDysOfs03TiA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Sep 2021 10:34:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjaBqNTksWwV3OieN7CA0XwBXLnE1PaGJHhb_tQS6=M4Q@mail.gmail.com>
Message-ID: <CAHk-=wjaBqNTksWwV3OieN7CA0XwBXLnE1PaGJHhb_tQS6=M4Q@mail.gmail.com>
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

On Thu, Sep 9, 2021 at 10:32 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This is basically a very dangerous interface. The fact that it is
> read-only doesn't change that at all.

Just to clarify - we've done dangerous interfaces in the past. We
probably have tons of them still that I haven't even thought about,
and I think I can hear somebody sniggering from miles away about
various bugs that cause much more obvious security holes that I didn't
think of.

But the fact that we might have other holes that can be misused,
doesn't mean we have to add new ones that seem to be almost designed
for misuse.

          Linus
