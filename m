Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27688C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 16:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbiD0QFz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 12:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242321AbiD0QEg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 12:04:36 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D3F35C1DC
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 09:01:13 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bq30so3964760lfb.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f86HljRdWHz/mbjYe5zQP1uXjxkFKfJygzPgkJmoMVk=;
        b=Jlr52u75tjiUlJGnxg5Xo0MF63HPxETIuoZHnTdCRIjmiHitYd5Ks2EY8BuItM/J7d
         gR7eBpn6GwNGZT01SDRKTXwBHHYrFWQN4mjks3PrCeOKK2CN+3+tzCTLedjw1U7bpnh6
         92iB5aeArNJpCipv26I2S+O3N7mDDnOOupAYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f86HljRdWHz/mbjYe5zQP1uXjxkFKfJygzPgkJmoMVk=;
        b=gtdTrdCNCX2VJ7FL5ulBnzlTgWq/Un5kuXkydgGkf0+WqB/MShiilAsXwedvsyKayp
         eomdbeREdjVmrVTQnXcyo2/hxrgwuJ1JynGNokmbSgIa04NtULM3i3d2Rigs5j4m7D5v
         RGtLRm1dg1F3qz2v3DBL3I00wOqlQHWlfxnM5xJsUR53N3ar0bkmO+0bDGgL2uovdL+S
         YdH5ueYgcv7I28RsG0MsFvTiELFCBguYCLYkwrz7oipgxv7ZGZVbb6xpXJB3QkHyRtrb
         wuJfdODWdywQS/eGTwqQbn+yToWV5RpWgXgG7VTpCAyBhhdAaxih5z9+9YK+7XpE3Lz8
         lhcw==
X-Gm-Message-State: AOAM530sjaoTYsMDMNkV7yJa/W/1geV9VHk1tBTDfueIBmhC8ahjE5OV
        CK0a0+gdHEW+/SeIViex6XldzmqIAiMI+8rBLnE=
X-Google-Smtp-Source: ABdhPJxtkNx5YFX8jG3V2ccxDHggJ/uGYztPV/Owv2YheO3Nb6J2pq7HjOH38EFszg5N6mNs+zt3lw==
X-Received: by 2002:a05:6512:945:b0:44a:f03f:e8c9 with SMTP id u5-20020a056512094500b0044af03fe8c9mr21097947lft.163.1651075254608;
        Wed, 27 Apr 2022 09:00:54 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id z4-20020a2e9b84000000b0024f0cb78c76sm1256383lji.52.2022.04.27.09.00.52
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:00:53 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id 17so3285993lji.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 09:00:52 -0700 (PDT)
X-Received: by 2002:a2e:934b:0:b0:24f:cce:5501 with SMTP id
 m11-20020a2e934b000000b0024f0cce5501mr12651353ljh.443.1651075251987; Wed, 27
 Apr 2022 09:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic> <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic>
In-Reply-To: <YmkdxaKdc2w/3I7o@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 27 Apr 2022 09:00:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
Message-ID: <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
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

On Wed, Apr 27, 2022 at 3:41 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Any particular reason for the explicit "q" suffix? The register already
> denotes the opsize and the generated opcode is the same.

No, I just added the 'q' prefix to distinguish it from the 'l'
instruction working on the same register one line earlier.

And then I wasn't consistent throughout, because it was really just
about me thinking about that "here we can use 32-bit ops, and here we
are working with the full possible 64-bit range".

So take that code as what it is - an untested and slightly edited
version of the code you sent me, meant for "how about like this"
purposes rather than anything else.

                   Linus
