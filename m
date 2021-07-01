Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3C3C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 02:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63EAC61451
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 02:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbhGACtA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 22:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238056AbhGACs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jun 2021 22:48:59 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3010C061756
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 19:46:28 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bu19so8954233lfb.9
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 19:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQglpNb77wKw/2A0sWryMcs6GIfaMS3X4Gr9x1CRS2U=;
        b=UuAKzgEkeDP/CDT+r3oCRl2Q9+7RAK3LnaE5Ovff0CwBlJTFw3FrzFZHz0Czej18sA
         IA80VeSoebInhLZk24jM9BZIxAyiKAoDc67vMSGWLidMLhEI6O8eTp4r8ETK0Es7V9F3
         uazK7cbluTi2BIFumCNVmOAYQDsvwZmAggsUk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQglpNb77wKw/2A0sWryMcs6GIfaMS3X4Gr9x1CRS2U=;
        b=CMAfYTvmsira5awgG9REzAah/2i71siQaRFtED5KsfFglFCCnWQuyYguPmw8fLVqXq
         BS1Qrl+k+ST2tG69H7WoPDkuu6QN22Bsf0qxwwKElCacxdfi12rG/Rn978qS6f2XFoFW
         83tbXADI736d1P+WKFUMACvDoo0qeGLxroTLKF2iWiv++tY9Kgy2ZbaZn3awPSHgIC8u
         EZqqdx4hGdxhbf9MhBajkuuDOI5Uj6Yy6f16rvTG4SNaQqGP4pwYuhmhLoEqtsVhsxlz
         Oq7NBvjlJYQzPGBjook+ypSh2SUYaeJiXig4da9N6AlvHkmz36mn+EXh/g3ifAyWEPST
         krKQ==
X-Gm-Message-State: AOAM531+jlK3e7ME1Bb7XwSC8Pk1sB5BO7yex2c1u/3CRXX1c89IJTqT
        T+P2TycnGOcMXDNrxW0X2Tj2b68fuhfzyThI
X-Google-Smtp-Source: ABdhPJzSblBGKrHw2K6RZbGvgu2b5xJMJsDVc+rjtVdf1TjDCxkbXuXUZij5syGhFjjel5m0m2EwQw==
X-Received: by 2002:a05:6512:218d:: with SMTP id b13mr29720246lft.346.1625107586913;
        Wed, 30 Jun 2021 19:46:26 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id m5sm2413813ljo.88.2021.06.30.19.46.26
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 19:46:26 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id u13so9019626lfk.2
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 19:46:26 -0700 (PDT)
X-Received: by 2002:a05:6512:374b:: with SMTP id a11mr29067184lfs.377.1625107585966;
 Wed, 30 Jun 2021 19:46:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org> <20210701015220.X8rakqyg8%akpm@linux-foundation.org>
In-Reply-To: <20210701015220.X8rakqyg8%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Jun 2021 19:46:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgCEiCc0Br4ysp85=iekbLjmakOgemALkL1oJRLiPxidQ@mail.gmail.com>
Message-ID: <CAHk-=wgCEiCc0Br4ysp85=iekbLjmakOgemALkL1oJRLiPxidQ@mail.gmail.com>
Subject: Re: [patch 097/192] mm: generalize ZONE_[DMA|DMA32]
To:     Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 6:52 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Kefeng Wang <wangkefeng.wang@huawei.com>
> Subject: mm: generalize ZONE_[DMA|DMA32]
>
> ZONE_[DMA|DMA32] configs have duplicate definitions on platforms that
> subscribe to them.  Instead, just make them generic options which can be
> selected on applicable platforms.

Hmm. 'b4' doesn't pick up this patch, for some reason.

Once again, it seems to be a "missing from the lists" case, even
though I see the "cc: mm-commits".

I don't see _why_, though.

I've picked it up from my own mailbox, but it's a bit annoying how b4
_almost_ makes this all painfree - but not quite.

                  Linus
