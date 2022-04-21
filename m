Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9E0C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 17:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390537AbiDURZr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 13:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390505AbiDURZq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 13:25:46 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90372B251
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 10:22:54 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 17so6626014lji.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 10:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/AfDMww0ycBxrjvRQwLCHmq5YuufUqn+uMvN5LmZDY=;
        b=eJ9tArgvEbb4NPhUtQvUKRhsT1d0d9SHze4TnuOVVIm+ZG8tDkcqYaIu03Fpl9hdOG
         I0dLGKvUNniBBsOcYBUNHpO2BcjoONm6oWxDq25iThwDJ5Nd3KFjFKinZ5BREBOgqn/7
         gZ5GmykMh/JFqZ17wisI6dOcFGCwNNv6dnJiY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/AfDMww0ycBxrjvRQwLCHmq5YuufUqn+uMvN5LmZDY=;
        b=p2f9TnAmRRDZ1k92v73GhVBsi9oWQK3WkiHQ20mA0EjJQl1rLCSPqcPsW+wTwlvoS/
         NZSHMfKKgqtqXPpnnS1211jhPTYDWppjbbqWnlQ/zsBUt7aRxFQMAx/UtaXmOofbQ0K1
         dJaSbt4MtwohcNgMZkXRJDf+yilraipAJP7D0IY972DyxpJXu7yZcapJdqOzM9C9jgrk
         7IP90+v+qEBCO71wPy5CMR74a1qNaqHc2Ewbmk3wflr+jdf7hvXbEws/0UAakm0Y16UB
         MRFTWRFa2pyLJi/A+eGXXSG2Ubm2+wwDm7aQOdWjx1MhwFRrYwA8QSqWDGfbDd10h2pb
         tiBg==
X-Gm-Message-State: AOAM532MIBNg3pF2r8dIHjXOjeKN6q2qp9EjVqGt6NdhOF0RsHfx3qha
        LgJCucEaTvEcbEAT4Hw9lPV6g7249bc1oQf9F5k=
X-Google-Smtp-Source: ABdhPJx+MsnuhSHrnNapMBXqI9RbOl8Jbo652OtW0vwcw+LZUIlGSBbbucFeqeIstTGTdoKLmjj4UQ==
X-Received: by 2002:a2e:864d:0:b0:24d:bb90:153 with SMTP id i13-20020a2e864d000000b0024dbb900153mr413659ljj.61.1650561772966;
        Thu, 21 Apr 2022 10:22:52 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id s14-20020a2e2c0e000000b0024db3275cd4sm1615218ljs.12.2022.04.21.10.22.49
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 10:22:51 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id h3so5192659lfu.8
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 10:22:49 -0700 (PDT)
X-Received: by 2002:a05:6512:108b:b0:470:90b9:fb51 with SMTP id
 j11-20020a056512108b00b0047090b9fb51mr358743lfg.52.1650561768960; Thu, 21 Apr
 2022 10:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <Ylr8rR+LHQ1uGL47@zn.tnic> <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic> <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic> <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
In-Reply-To: <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 21 Apr 2022 10:22:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
Message-ID: <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
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

On Thu, Apr 21, 2022 at 9:50 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> where that "read(..) = 16" is the important part. It correctly figured
> out that it can only do 16 bytes (ok, 17, but we've always allowed the
> user accessor functions to block).

Bad choice of words - by "block" I meant "doing the accesses in
blocks", in this case 64-bit words.

Obviously the user accessors _also_ "block" in the sense of having to
wait for page faults and IO.

I think 'copy_{to,from}_user()' actually does go to the effort to try
to do byte-exact results, though.

In particular, see copy_user_handle_tail in arch/x86/lib/copy_user_64.S.

But I think that we long ago ended up deciding it really wasn't worth
doing it, and x86 ends up just going to unnecessary lengths for this
case.

               Linus
