Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F14CC64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 04:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBZENP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 23:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjBZENO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 23:13:14 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753377D97
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 20:13:13 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id d30so12907046eda.4
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 20:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPj9sJVzmTzKFB9cxNvS+JRlaKods9oYWgBQku2a2L8=;
        b=CafQUTlsPDHDc2CFQJxnO1AlvGQiJGYr0Ppa+3TBpisRU4X3unCfXutJ4NeYoal0jC
         DL6H/+0M89/cgSPhR6FHIO7yuFnpQ7JdnjTE8FRYszvWOvIKlKIiyi0lDvOzv35A379h
         /V/g4WFFUm7XvEbClTJc35on2eiNeGcswApbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPj9sJVzmTzKFB9cxNvS+JRlaKods9oYWgBQku2a2L8=;
        b=TtU8w0kyaLKsxU6mHiHC2USEJ/rEHbjAeaUcRCtv5A9dICfql3yxC774jkTQw8rDrL
         wTKLPmaC50MHV5bdzcGOq19ibv2qXJ11bgNfOr6ggxa6DDWx/H6aTRJeY+BYXxf2pFJ1
         053BK+Qb6uGhlrfpk/azi3Flh87Xqzk+PCEnhd/W/DDzkSf7qzTIms6d/7B8dAdJkEE4
         dn5Hwk34ZuGxQtT8eHMEzWJhux95tGf6Cg8dkdfR1+JfSdkeuFHsVSVmdyEoarU/qSAZ
         KI2cVFIQN24eFMO4QsJNvhfyYTrlUoREZmOuZYIyWZrTmrX/4p3jU5OG4iftF4FNt01S
         01VA==
X-Gm-Message-State: AO0yUKWEtfmj7nM0hk+b0rd/DRY/cLHiT3hwxg8l0IREv7uR3cyJDGg9
        iMNtMJrl6c99JbvyI/Xq9ruY0IXsyS/BGbTlkKbTog==
X-Google-Smtp-Source: AK7set9qgiiNPZ9lFtVYuJkH5YqqWt56yLY/fOgnbMIjgsRdRFlxIK87gT2en5DIUR1Mu7PleZ6IpA==
X-Received: by 2002:a17:906:e285:b0:8b1:15ab:f4cd with SMTP id gg5-20020a170906e28500b008b115abf4cdmr30559583ejb.53.1677384791540;
        Sat, 25 Feb 2023 20:13:11 -0800 (PST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id x2-20020a170906658200b008bfe95c46c3sm1529078ejn.220.2023.02.25.20.13.10
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 20:13:10 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id ee7so12953116edb.2
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 20:13:10 -0800 (PST)
X-Received: by 2002:a17:906:8508:b0:8d0:2c55:1aa with SMTP id
 i8-20020a170906850800b008d02c5501aamr10538324ejx.0.1677384790526; Sat, 25 Feb
 2023 20:13:10 -0800 (PST)
MIME-Version: 1.0
References: <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <CAHk-=whVN2gKO_7UvMqgG8cetrVs3BCTxQovJvhC5x7AcJDJgQ@mail.gmail.com>
 <CAHk-=wgxWDgLJ-e3uDiYQvmMEqTNYFvDxtHbu4inR=zgBEP11Q@mail.gmail.com>
 <CAHk-=wjFmVL7NiuxL54qLkoabni_yD-oF9=dpDgETtdsiCbhUg@mail.gmail.com>
 <20230225195727.1b73a356f4f1a79833a31885@linux-foundation.org> <CAHk-=whpy3yHt0X5Vb97kdvtryj93KVTJs07zLZVJ8zEXH=Q-A@mail.gmail.com>
In-Reply-To: <CAHk-=whpy3yHt0X5Vb97kdvtryj93KVTJs07zLZVJ8zEXH=Q-A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 25 Feb 2023 20:12:53 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjo3-YZfsG4qJEjMBPxoCC57uWVtyez9LQQu+JTCNtfgg@mail.gmail.com>
Message-ID: <CAHk-=wjo3-YZfsG4qJEjMBPxoCC57uWVtyez9LQQu+JTCNtfgg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.3-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Feb 25, 2023 at 8:03=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Will test right away. It's certainly right in that suspicious area.

Yup. That fixes it for me.

I'll just apply it directly.

              Linus
