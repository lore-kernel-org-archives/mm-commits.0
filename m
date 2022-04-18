Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823B1C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Apr 2022 17:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiDRRNr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Apr 2022 13:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbiDRRNr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Apr 2022 13:13:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1AE20F7F
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 10:11:06 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bu29so25204210lfb.0
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 10:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JnfBKZjgF0QAT2+ZNkrVkIt3p+ZK2qll9C8ReRWwK94=;
        b=N/kozEv3htHzVB9QEynfrlQU/Mv+YKRQ+Usc9cumiP5Mmpjh7RTikZqiiUaqpeWnlX
         cPoGWW1kY4AhKXsnK+qQTcNnOhTGfJIve2qIABJfHTK8YQyvK1KPMYZxO+iuDVgjUoj9
         Idk6AkYvv0WfNah3F8jeBIGSzSMzsddOwZ3UA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JnfBKZjgF0QAT2+ZNkrVkIt3p+ZK2qll9C8ReRWwK94=;
        b=tLhemAIAHmRbcYxZivARFIDU1P2BtcQAzowLHGsymx9hg0NvX+1fhOlvB2c6/0rNVD
         5xKvSgEWvuoB5VSaCvH4a9gNBx2TC4BlebPkynqYQtzXnDKdRrj9QQqzetI+wxC/dC8F
         a7zlHWeGOgvwjrVQXaQ6x2RVarGslvE5q1GyYTSzB64Oa2XZYz1TtTiDV+ToFckLS6gQ
         /9xnnRb6ZXsJwsL8MyheooEdGy5i++S6x3cGfj//Tqju+qAWYhogchYSq5Zb5ya3Pn76
         siMAJDzVkEIpYDf96dS0MPPJKdYxKARiZ/VMfgLYB5sereVlqhOUeBnHub+jJZu3kx9X
         3DRQ==
X-Gm-Message-State: AOAM5338B7PxRryPb0VMVLNABWz77viadGYbs+ArwzvZI/ai5uMA61yI
        EdkdTcPLWtzjgx/lxmDw/BBlb/PswaBHJye5xJE=
X-Google-Smtp-Source: ABdhPJztTcNyQdLm41FgHMNxXVAdly0pAAHAQ9Ywb0Q0Vk8bcOiw2IfqkLhtJCNl+1yPSWcNChKT2w==
X-Received: by 2002:a05:6512:2608:b0:448:35c4:bc9f with SMTP id bt8-20020a056512260800b0044835c4bc9fmr8130625lfb.666.1650301864250;
        Mon, 18 Apr 2022 10:11:04 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id e17-20020ac25cb1000000b0046d04516c94sm1260711lfq.28.2022.04.18.10.10.59
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 10:11:00 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id p10so25088175lfa.12
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 10:10:59 -0700 (PDT)
X-Received: by 2002:a05:6512:2291:b0:46b:b72b:c947 with SMTP id
 f17-20020a056512229100b0046bb72bc947mr8563401lfu.531.1650301859252; Mon, 18
 Apr 2022 10:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org> <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic> <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic> <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic> <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic>
In-Reply-To: <Yl06PWVgeZplboXV@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 18 Apr 2022 10:10:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
Message-ID: <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Apr 18, 2022 at 3:15 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Yah, wanted to singlestep that whole asm anyway to make sure it is good.
> And just started going through it - I think it can be even optimized a
> bit to use %rax for the rest bytes and decrement it into 0 eventually.

Ugh. If you do this, you need to have a big comment about how that
%rcx value gets fixed up with EX_TYPE_UCOPY_LEN (which basically ends
up doing "%rcx = %rcx*8+%rax" in ex_handler_ucopy_len() for the
exception case).

Plus you need to explain the xorl here:

> 3:
>         xorl %eax,%eax
>         RET

because with your re-written function it *looks* like %eax is already
zero, so - once again - this is about how the exception cases work and
get here magically.

So that needs some big comment about "if an exception happens, we jump
to label '3', and the exception handler will fix up %rcx, but we'll
need to clear %rax".

Or something like that.

But yes, that does look like it will work, it's just really subtle how
%rcx is zero for the 'rest bytes', and %rax is the byte count
remaining in addition.

                  Linus
