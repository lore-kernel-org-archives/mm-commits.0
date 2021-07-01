Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E33C11F64
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 04:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B389613CD
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 04:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhGAEca (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jul 2021 00:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhGAEca (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2021 00:32:30 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84386C061756
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 21:29:59 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id g14so2322427qvo.7
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 21:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e6r32CFd9H7eJejGHHIav2/aAi5Jwd7KFnBcDwEeSGI=;
        b=ZuclMNPKkf9VyV3v/0DeEnW6Qu554qOBMqrH+7rOL8NU2C8LuUo+jx5CCLSzFM3P7C
         tG3aOMghCHsXHnHLBR0dTiEh4If9SFSxEs16ZcSOU6PE2Hg7bil7W+9iqIxIGjbOF9AE
         M54mAxwPaq6nfpQVdCSVKM13O/IzaEqbovwJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e6r32CFd9H7eJejGHHIav2/aAi5Jwd7KFnBcDwEeSGI=;
        b=FHG9CbkVD+ZaxaiErjM1lBZz9HYUz9bkWBo/3Qr9XBo5NDa35XKg2/nPJy9jDdTz9o
         mZEB/Dv2lojPn/MnsU6EStwqdvQCgLFg/uc7ELod1Fcq+j93jCFRWdYuLFqOMAcF281t
         qrDw1TkT6nsllPVA7JASGY/Mk5N3NTbTHJAT9+MClL69JbYnrCY/2EdPEXXixNblZXIx
         dC7Vrppm1oDHBEEgKDop0VP7rS4/TCbEtKstzXEY3XVbEh4hDqyYJWEl49myXzW5siqs
         nmM0DiuXBqDMDITclhMhIr/ZulgUQPhsv54ZvowLjR8CZx9r8LuiC7S8SxDCK6yVOeBT
         DC0w==
X-Gm-Message-State: AOAM533Ffk520rf1yzNfNNzaFh/aD0gVuDU/pN84jO4yTeIvQ45Ptd/L
        FRiXOWf0wytDCvaWjD6EGif4iCLfg8e5Pg==
X-Google-Smtp-Source: ABdhPJzEnw9hnhZIUJetxFlQOkK4JRLDuYsQGbLIrYYdKLJWvsSGaUPZIbRBlGeEFsI5efYCkaqr7g==
X-Received: by 2002:a0c:df03:: with SMTP id g3mr10333690qvl.1.1625113798716;
        Wed, 30 Jun 2021 21:29:58 -0700 (PDT)
Received: from nitro.local ([89.36.78.230])
        by smtp.gmail.com with ESMTPSA id g4sm1257671qko.89.2021.06.30.21.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 21:29:58 -0700 (PDT)
Date:   Thu, 1 Jul 2021 00:29:56 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org
Subject: Re: [patch 097/192] mm: generalize ZONE_[DMA|DMA32]
Message-ID: <20210701042956.33gefixxi6dqrygw@nitro.local>
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015220.X8rakqyg8%akpm@linux-foundation.org>
 <CAHk-=wgCEiCc0Br4ysp85=iekbLjmakOgemALkL1oJRLiPxidQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgCEiCc0Br4ysp85=iekbLjmakOgemALkL1oJRLiPxidQ@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 07:46:10PM -0700, Linus Torvalds wrote:
> > ZONE_[DMA|DMA32] configs have duplicate definitions on platforms that
> > subscribe to them.  Instead, just make them generic options which can be
> > selected on applicable platforms.
> 
> Hmm. 'b4' doesn't pick up this patch, for some reason.
> 
> Once again, it seems to be a "missing from the lists" case, even
> though I see the "cc: mm-commits".
> 
> I don't see _why_, though.
> 
> I've picked it up from my own mailbox, but it's a bit annoying how b4
> _almost_ makes this all painfree - but not quite.

It seems that 097/192 didn't make it to any of the archival services either
for linux-mm or mm-commits, which is really bizarre, since they are hosted at
two different listserv hosts. E.g. marc.info doesn't have 097 either:

https://marc.info/?l=linux-mm&r=4&b=202107&w=2
https://marc.info/?l=linux-mm-commits&r=4&b=202107&w=2

Since both kvack.org and vger.kernel.org use majordomo, I would guess that
something about that message caused them to drop it. Unfortunately, I don't
have anything insightful to add here other than "b4 is only as good as what
lore.kernel.org actually receives."

-K
