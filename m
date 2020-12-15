Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0914C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 954892246B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgLODcB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgLODby (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Dec 2020 22:31:54 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6B7C06179C
        for <mm-commits@vger.kernel.org>; Mon, 14 Dec 2020 19:31:14 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a12so35685525lfl.6
        for <mm-commits@vger.kernel.org>; Mon, 14 Dec 2020 19:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cSgnZAxgdYFBnVLwUq+/kPLQYv5pwOEsAQoQHeaGEv8=;
        b=IUxUp9oVRZHyP042vo+fGMwljmwv1AxKAguoszeKa+/+Dj1tefdnnNjjRoZQw5TFbg
         8oeZkWOb79ORMd48hp4pj6F0srJ2qx15aqITeVEIWGjT9iC9ts7ASuPlt8fhHggg6dao
         Jsl8GyRDTtJatiXdXTxNH/x3A3qdjTcNlF000=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cSgnZAxgdYFBnVLwUq+/kPLQYv5pwOEsAQoQHeaGEv8=;
        b=Idoyk4nx4Jdasi5SGmI63MPigUYNzdj6ZOdT2ecqtgg20QBGR5VfrcWvzAIVJELM2L
         bEazAyCfWxMDTG51JdZ28ozi5Nsp95soVXn1q0DtGX985Xn/d83F2SvxQD4rSWo971Dx
         UkHQcPyAxnDkiJRlsuo48Pr6n2S/ZEq7u2/RvA5YECy4QOjNkc5kk1fAfd+GULkdSmPj
         Ui/cx8v9MYJ6CYChJ6O9dDpdDMFVPAnCzFvwaknfwL4FugytXXbIk1GyDTupTApL3sZ1
         KFj/kWbvJybrvo5cz9/q3Dm7iEp8LRitrkQW5UbhcWcfDszDBUQy9XGlffiUNWrWFyEH
         tgrA==
X-Gm-Message-State: AOAM531TldOHnsUiJKveYux4DzWSFJUtGtCp9ElUuOF9VJEEcetlWFVo
        zTRLK5MDa8VYtMhwQjZv3CRN1Hb/syQ2uQ==
X-Google-Smtp-Source: ABdhPJx1VL+6UAYj+E8AQx4niyZ4C/Pt/9qZ07mUlc+xuXSFQc6JMV4dmx7gSqm1jzMVeofmq9Ia/g==
X-Received: by 2002:a2e:9ad3:: with SMTP id p19mr11522228ljj.286.1608003072487;
        Mon, 14 Dec 2020 19:31:12 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id y5sm53810lfl.100.2020.12.14.19.31.11
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 19:31:11 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id o17so32746216lfg.4
        for <mm-commits@vger.kernel.org>; Mon, 14 Dec 2020 19:31:11 -0800 (PST)
X-Received: by 2002:a2e:8995:: with SMTP id c21mr11312711lji.251.1608003070763;
 Mon, 14 Dec 2020 19:31:10 -0800 (PST)
MIME-Version: 1.0
References: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org> <CAHk-=whRm2sKHeY-YQqxEJF=d9fGhnU2ajJs9i7CKC4feuPMTA@mail.gmail.com>
In-Reply-To: <CAHk-=whRm2sKHeY-YQqxEJF=d9fGhnU2ajJs9i7CKC4feuPMTA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 14 Dec 2020 19:30:54 -0800
X-Gmail-Original-Message-ID: <CAHk-=whV8E0d198RGn45ewBu_kGzhyYd3YXOQBg7nAHLYWvB9w@mail.gmail.com>
Message-ID: <CAHk-=whV8E0d198RGn45ewBu_kGzhyYd3YXOQBg7nAHLYWvB9w@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     mm-commits@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 14, 2020 at 7:25 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> All the patches except for _one_ get a nice little green check-mark
> next to them when I use 'git am' on this series.
>
> The one that did not was [patch 192/200].
>
> I have no idea why

Hmm. It looks like that patch is the only one in the series with the
">From" marker in the commit message, from the silly "clarify that
this isn't the first line in a new message in mbox format".

And "b4 am" has turned the single ">" into two, making the stupid
marker worse, and actually corrupting the end result.

Coincidence? Or cause?

            Linus
