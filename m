Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C19DC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Apr 2022 10:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbiDRKSO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Apr 2022 06:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237609AbiDRKSN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Apr 2022 06:18:13 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D91C18E14
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 03:15:34 -0700 (PDT)
Received: from zn.tnic (p200300ea971b58ab329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:58ab:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 558ED1EC04D6;
        Mon, 18 Apr 2022 12:15:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650276929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RM/rO2nSYBQbuHoHVjIaODYmIO7pXSDf4TWfQ4csBws=;
        b=MQgt2hFuDaYoEzmsIuBiS8wkZvB7sEEXvMu4fWaUFgUiIyHtyR0nEDABkIJImlb062/GXx
        YjR7lfH1aswxm2ZOjYE3D8gmit5kqeUTn3NgYnHYBnKgrg2XThWzK/unEBzEv/zMpI4q+A
        Y7jXSSr+cyX5hpd8cEtz3/bsP3s3iBI=
Date:   Mon, 18 Apr 2022 12:15:25 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-ID: <Yl06PWVgeZplboXV@zn.tnic>
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org>
 <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic>
 <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic>
 <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic>
 <YlxtTNFP58TcUHZQ@zn.tnic>
 <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Apr 17, 2022 at 01:56:25PM -0700, Linus Torvalds wrote:
> That 'movq %rcx,%rax' can't be right. The caller expects it to be zero
> on input and stay zero on output.
> 
> But I think "xorl %eax,%eax" is good, since %eax was used as a
> temporary in that function.

Yah, wanted to singlestep that whole asm anyway to make sure it is good.
And just started going through it - I think it can be even optimized a
bit to use %rax for the rest bytes and decrement it into 0 eventually.

The "xorl %eax,%eax" is still there, though, in case we fault on the
user access and so that we can clear it to the compiler's expectation.

I've added comments too so that it is clear what happens at a quick glance.

SYM_FUNC_START(clear_user_original)
        mov %rcx,%rax
        shr $3,%rcx             # qwords
        and $7,%rax             # rest bytes
        test %rcx,%rcx
        jz 1f

        # do the qwords first
        .p2align 4
0:      movq $0,(%rdi)
        lea 8(%rdi),%rdi
        dec %rcx
        jnz   0b

1:      test %rax,%rax
        jz 3f

        # now do the rest bytes
2:      movb $0,(%rdi)
        inc %rdi
        decl %eax
        jnz  2b

3:
        xorl %eax,%eax
        RET

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
