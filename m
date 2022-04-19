Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC11C4321E
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 16:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353581AbiDSQsp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 12:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354983AbiDSQos (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 12:44:48 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2F331907
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 09:42:05 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id bj36so15354558ljb.13
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 09:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6P1qWvF3V5GecgjWCwMHmxXvgO8LhvNSrvaeOrIx0no=;
        b=bOi7JrsKqW6RMlRYZ9yUMtpdFOoida/a9exETF7P4zUXYy8YfeeMmKRQoxSP+cBkH6
         o6mLBuE//QNcdO3jlJqz53BsfpGwllgT4Tgv3ikKYQ6nO5XfIxIcZHWoBpkfZxheIysG
         An/Fl3+TnkBLB8svtmOlHuNDaqXA1rMz+XTXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6P1qWvF3V5GecgjWCwMHmxXvgO8LhvNSrvaeOrIx0no=;
        b=BTRGExVBolLH1+MFNjNeNTPkcQ0LsgEJyPNW4qb1LWTy3jiZ7g1Xge7pLPDcKoUnyk
         7zYuMbEeOV0bNAPhltBc+m4X/yMbdo4kFKRk0oro3TKhwoMzvlzPeszsf4sVckx/fgwT
         49/rEESTZaYgNkQwRMAXZ7/uEYbTus/AzLH6Rt/EHh4k7zQq693hilDP5JHcLBGW9koM
         ctzt6RpO7PlfLDRHlRlgyZ1QQdK3IZr900Ou/5J7IvnPOkXOK+JiAKF/wREtUyshCwa6
         Nj7Gl3XmPWHQ9/xRG3w1J3PLaZC437khzmAhAfTg/cqotRVsi6UklK98UGZlhNHJxld0
         x3VQ==
X-Gm-Message-State: AOAM533cTnSevukXyAG1r9puTXxt+cCLB2cJk/pAk93FwJmWr8mpM3BT
        8Vt3GlvPwx1gvBwJAPxBYm6KX5nHUHKj/vtk07c=
X-Google-Smtp-Source: ABdhPJzBWx6zZlX/p899xR881WQvIReniy+TvIzAWsDMfgn5EGhTmOz4U6lYIcnTrLVaj85opAMYqg==
X-Received: by 2002:a2e:b8c7:0:b0:24d:a697:cbf3 with SMTP id s7-20020a2eb8c7000000b0024da697cbf3mr10486260ljp.448.1650386523206;
        Tue, 19 Apr 2022 09:42:03 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id m20-20020a194354000000b0046f8c68f965sm1318514lfj.166.2022.04.19.09.41.59
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 09:42:00 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id t25so30401133lfg.7
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 09:41:59 -0700 (PDT)
X-Received: by 2002:ac2:4203:0:b0:448:8053:d402 with SMTP id
 y3-20020ac24203000000b004488053d402mr11323216lfh.687.1650386519338; Tue, 19
 Apr 2022 09:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic> <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic> <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic> <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic>
In-Reply-To: <Yl5+DCfQmG5C3BHf@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 19 Apr 2022 09:41:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
Message-ID: <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
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

On Tue, Apr 19, 2022 at 2:17 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Yap, and I reused your text and expanded it. You made me look at that
> crazy DEFINE_EXTABLE_TYPE_REG macro finally so that I know what it does
> in detail.
>
> So I have the below now, it boots in the guest so it must be perfect.

This looks fine to me.

Although honestly, I'd be even happier without those fancy exception
table tricks. I actually think things would be more legible if we had
explicit error return points that did the

err8:
        shrq $3,%rcx
        addq %rax,%rcx
err1:
        xorl %eax,%eax
        RET

things explicitly.

That's perhaps especially true since this whole thing now added a new
- and even more complex - error case with that _ASM_EXTABLE_TYPE_REG.

But I'm ok with the complex version too, I guess.

                   Linus
