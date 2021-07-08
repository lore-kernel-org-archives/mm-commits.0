Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE02C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 03:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55D3661158
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 03:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhGHDQV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 23:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbhGHDQV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2021 23:16:21 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A29EC061574
        for <mm-commits@vger.kernel.org>; Wed,  7 Jul 2021 20:13:39 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p1so10443621lfr.12
        for <mm-commits@vger.kernel.org>; Wed, 07 Jul 2021 20:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O55ZQycEnXNCbtVr7Ti0xhqPfnDuHqlpxZ+e4ib1qa0=;
        b=ATYyFZVgIXYRxSSxG9UhCSlgfGO5Y8qN8rbztQQV9mVx0LF+/XIt+7Wehpnw8ybvuz
         BPz0EA991MUrEdapqxxqTVfjfFhIgiaRpjySsCUmIvoPEPu3FhwmGEzFxs3RpIag/RC+
         +aC7Fauzc4YkGO00TiOBXlZhI/LxhHBDOD5U0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O55ZQycEnXNCbtVr7Ti0xhqPfnDuHqlpxZ+e4ib1qa0=;
        b=MFaugpuhPXgbLhsy0e3ElUaDUy0ApOgt0dv5W4oQlEsW8dKVgJd1+Ny4IHvOsEOiQc
         9oEI6w/521z3MN7VZIPzS4sKV+tn2pL7C/N0MZr0QVZ6Ahp3VvatzgC3KmyVRkJOoHqX
         77xDktMeGqySzbFKV9duf7oB0tKz23vZPeSz7Jl+255ktmd2MBaY0Z3J7dqc45RwV/nK
         TDIdepxdmQn6dCSnv/DEAEnj8NwosmzqOC/GHMf4LB2pAzog88yx5C2A/uGyKul6QMjc
         DfhJHfQbOT+JGom2kRzqnkxek+8Gd8oHXUT5AH0oWrBRgM9QMzIu2JqDYbn0zpXqAZLu
         zioQ==
X-Gm-Message-State: AOAM533odt+M/3Y3q6Bj5Ll1Pp877bOE+zXfRyhDWp83Yj3bqamTw4Zv
        ZHFCn+leF0IGvl9478wsjFEIYHLXKjyFyPb1zE4=
X-Google-Smtp-Source: ABdhPJzzUUdtyWgnLxfI5Ddr1UP5yhAvurUls3q+AHGD0lCyGrWKQCee+SaERaQzWYDZ3CUb4pZ/Aw==
X-Received: by 2002:a05:6512:3c83:: with SMTP id h3mr16718096lfv.387.1625714017477;
        Wed, 07 Jul 2021 20:13:37 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id m7sm94072ljh.118.2021.07.07.20.13.37
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 20:13:37 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id n14so10465148lfu.8
        for <mm-commits@vger.kernel.org>; Wed, 07 Jul 2021 20:13:37 -0700 (PDT)
X-Received: by 2002:a05:6512:374b:: with SMTP id a11mr21266526lfs.377.1625714006574;
 Wed, 07 Jul 2021 20:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org> <20210708010803.i6RiDHM3L%akpm@linux-foundation.org>
In-Reply-To: <20210708010803.i6RiDHM3L%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 7 Jul 2021 20:13:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=whWxnQW=2Rx8uj01nGMGK3oOS9fJZCe6atVP7and5DkWg@mail.gmail.com>
Message-ID: <CAHk-=whWxnQW=2Rx8uj01nGMGK3oOS9fJZCe6atVP7and5DkWg@mail.gmail.com>
Subject: Re: [patch 11/54] mm: introduce memfd_secret system call to create
 "secret" memory areas
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Roman Gushchin <guro@fb.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Peter Anvin <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Linux-MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Shakeel Butt <shakeelb@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jul 7, 2021 at 6:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Mike Rapoport <rppt@linux.ibm.com>
> Subject: mm: introduce memfd_secret system call to create "secret" memory areas
>
> Introduce "memfd_secret" system call with the ability to create memory
> areas visible only in the context of the owning process and not mapped not
> only to other processes but in the kernel page tables as well.

Am I missing something?

From what I can't tell, this must not be enabled for regular users,
because the secret mapping is effectively mlock'ed into the address
space.

But there does not seem to be any permission checks or any limits, so
this looks like a trivial way for a bad user to force the kernel to
run out of memory.

So this looks entirely unacceptable.

Please tell me what I'm not getting...

             Linus
