Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A580C43217
	for <mm-commits@archiver.kernel.org>; Wed,  4 May 2022 20:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378034AbiEDUoU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 May 2022 16:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378416AbiEDUoF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2022 16:44:05 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16DC63F7
        for <mm-commits@vger.kernel.org>; Wed,  4 May 2022 13:40:26 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bu29so4376421lfb.0
        for <mm-commits@vger.kernel.org>; Wed, 04 May 2022 13:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n5f7afkXUKTo3IPWzmlyI8gr9ELiri6KDY4jDCLAwqk=;
        b=hxZbDwh249V8ZWvJvHgV8HOAuCwzitlpmdUaF1aBT2GoF1r95NpNwyDzyBX4DdfW4t
         S+439ChsQrTcSauZNdL3zxMoiHfb+9og+70XrhkoRCXDijiIGEY4j8RIp1HfceEd4Ycx
         YfSmJLaV8W0hI8BFv1q8CTPECn1nKJl+L25HM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n5f7afkXUKTo3IPWzmlyI8gr9ELiri6KDY4jDCLAwqk=;
        b=wjL30O1thy8WbCcsmzl6WEfwEDFZfW66Tf5n39jp6uV5eiZZxthKzNgiZoMCFteBg+
         LxTuVqrwQg7L9gPwC2f45u1Gy4MFEHYbkLhAxY8Ms8gt8FtKNCvDPYeHJWH43hRfnMgC
         BOnMpp3ty6va7guRbHoMptJ0ek+0F3h3Zp3FGpZOzHCJlJSexSep3vfqlH2SXsRmr402
         PIfElg2eNTJjHHIXBobwS8gcdZ08ZgNbgJDzSA0aYnAqAwuX19FvrnUlaNeaJUDFedgh
         ufD9LFZWXqG1KQZr6LAiPwMTnXCgn3TBVDvo7+Dm8Ach8eYFZr0dFnGbQhFO7nm2HH7x
         pTZw==
X-Gm-Message-State: AOAM532QEvxO3oTp4LMm0sIx0jQZXt7JDDD5SN7O8gq8YngmeDNkDTQA
        yFSUCU+U/7fEP0IKdgFkOv/zG7p7gbhLmLaYmsA=
X-Google-Smtp-Source: ABdhPJwvZqdb2EYvPg/GUSMBpP3YI+J8MgLG2OR0twp23gYV9GMWC7ZYGxhKqpSjdCs1HuzNPuK80g==
X-Received: by 2002:a05:6512:321b:b0:44a:78f2:500b with SMTP id d27-20020a056512321b00b0044a78f2500bmr14620928lfe.434.1651696825007;
        Wed, 04 May 2022 13:40:25 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id m11-20020ac24acb000000b0047255d21191sm1297776lfp.192.2022.05.04.13.40.23
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 13:40:24 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id b18so4309929lfv.9
        for <mm-commits@vger.kernel.org>; Wed, 04 May 2022 13:40:23 -0700 (PDT)
X-Received: by 2002:a05:6512:3a4:b0:473:b9ea:7673 with SMTP id
 v4-20020a05651203a400b00473b9ea7673mr3445886lfp.687.1651696823645; Wed, 04
 May 2022 13:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic>
In-Reply-To: <YnLfl6lupN2nq7+t@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 May 2022 13:40:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
Message-ID: <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
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
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, May 4, 2022 at 1:18 PM Borislav Petkov <bp@alien8.de> wrote:
>
> Zen3 has FSRM.

Sadly, I'm on Zen2 with my 3970X, and the Zen 3 threadrippers seem to
be basically impossible to get.

> So below's the git test suite with clear_user on Zen3. It creates a lot
> of processes so we get to clear_user a bunch and that's the inlined rep
> movsb.

Oh, the clear_user() in the ELF loader? I wouldn't have expected that
to be noticeable.

Now, clear_page() is *very* noticeable, but that has its own special
magic and doesn't use clear_user().

Maybe there is some other clear_user() case I never thought of. My dim
memories of profiles definitely had copy_to_user, clear_page and
copy_page being some of the top copy loops.

                   Linus
