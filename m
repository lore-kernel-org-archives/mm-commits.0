Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62803C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB20610E8
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350173AbhIHS2q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 14:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350243AbhIHS2l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 14:28:41 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9C3C0617A8
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 11:27:14 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id f2so5051321ljn.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=czKOIKL3DMCqCG5cwJ0WXSQDif16mrAilaNN0fE83Is=;
        b=eMWgx8GJSrA9wYa5n797lwAZqSlLVxeInOmTd3XxisozrOs1O4IEBP9/JT+dGBUOV5
         84WMWepM4LQlPBgxR8456bKaW/RpOqezttxrakU8cRIGGMjf2LCxS7sRLdjKj8WsAYWf
         duQCFrK8fB+9O2fVBl5O+YG7zpKT65pMEF5Sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=czKOIKL3DMCqCG5cwJ0WXSQDif16mrAilaNN0fE83Is=;
        b=eyDp5Z3J6aAdM4d63VYAKrb6wE0O16W268COmEFU7jGLGgjoa39ZHTvnE0fz9xYYvg
         UP+hdhMBb9ZT4JDnHmxpX4uybwpDTPr526tcb7b/hQjyKMN0Js8MOd3a4FVjcj8cMpwX
         DichayjNLoiUwOexRelfeecgAODZPxdUEmdw5tMEH5/gqdEZ6GeiXxumeXPrmKH8Vy76
         cA9XoS+ylqb9ezk5xSuE7UFr8FlnDnTHDb7LmHTfwRR8YBYVZw4ND1Vz66n5XcmVhVae
         VuR0taVbG8ThyQjiuv9IVPaGXifpjyYaCfyV+5pfUqLfwwfFrMMxKWFGI0nXQbhcS5u9
         CKyQ==
X-Gm-Message-State: AOAM533PgyTgHAptgNaPgxhdUFoPzwyv7Y93P2J0PKAtERe7BaOR2Z/H
        Q9GEe2DP2PKFuKqNL0CL1eUJHGgGbieFG81+y3c=
X-Google-Smtp-Source: ABdhPJz3nN6btnlDvgp+xbwnSaBsNq5g2Kvkcyv2kGFD78dMQmC2pr9WBZU3Ote+1vs0Bk+r9IcGKQ==
X-Received: by 2002:a2e:a7d6:: with SMTP id x22mr3876928ljp.293.1631125632609;
        Wed, 08 Sep 2021 11:27:12 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id z24sm259313lfr.105.2021.09.08.11.27.10
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 11:27:11 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id a4so4340914lfg.8
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:27:10 -0700 (PDT)
X-Received: by 2002:a05:6512:34c3:: with SMTP id w3mr3513265lfr.173.1631125630562;
 Wed, 08 Sep 2021 11:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org> <20210908025839.81TnA0vU3%akpm@linux-foundation.org>
In-Reply-To: <20210908025839.81TnA0vU3%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 11:26:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgsn3MQONEPzGpRuqyBmk2mV_p7wF_Jz0qDdFHvOvaPmA@mail.gmail.com>
Message-ID: <CAHk-=wgsn3MQONEPzGpRuqyBmk2mV_p7wF_Jz0qDdFHvOvaPmA@mail.gmail.com>
Subject: Re: [patch 101/147] lib/string: optimized memcpy
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>, drew@beagleboard.org,
        Guo Ren <guoren@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@esmil.dk,
        Linux-MM <linux-mm@kvack.org>, mcroce@microsoft.com,
        mick@ics.forth.gr, mm-commits@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

I'm going to skip this one too.

On Tue, Sep 7, 2021 at 7:58 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Matteo Croce <mcroce@microsoft.com>
> Subject: lib/string: optimized memcpy
>
> Patch series "lib/string: optimized mem* functions", v2.

Honestly, if we change the fallback memcpy(), I think the change
should be to remove it.

This is a core architecture thing, and every architecture does their
own. And pretty much every architecture has their own optimizations
for memcpy.

Yes, the byte-at-a-time default implementation is bad. But it's
_intentionally_ bad. It's only meant for initial bringup. No
architecture should actually end up using this in the long run, and if
you see it in profiles it should make you go "Ahh" instead.

             Linus
