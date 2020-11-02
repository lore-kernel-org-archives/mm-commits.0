Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D38C388F9
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 18:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD430223AC
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604343104;
	bh=PU6HFf+oUVH4K/AEKfERJhtAeq1x3Bxz/KwI7HjgKGI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:Reply-To:List-ID:
	 From;
	b=uYYC4BGM18nsT2EnP1kJH80VHkMJdCfXcqtz6+ZfswByWl99NM9nZs4uyduqytoqi
	 0I+Yjsgu+acATzuL8QpWW+vKZPdYi1ueAxs/56ukMfnw+aCH8Py0V6lgOJ+otWKc5y
	 zEHydS3t7DyZdBbE4zQsdQLwSXdjEJ8PVeZgQP3Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgKBSvn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Nov 2020 13:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgKBSvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2020 13:51:42 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4622EC0617A6
        for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2020 10:51:42 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id m16so16187371ljo.6
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 10:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Il1RVRiUKAxoef5RnNd4syWE0WLl3orYpLwRBHqOz80=;
        b=Y/TBlS1eFyfbbSotePutJHXTGFVPAS+8IcR03nDZGR1K5euC5et7jo1unYNqTUbp3U
         BjqqnZAVvs3BOTVNA0F6VNGSfKnRNlF9V4E4/vPDQFUhmAnDPA3qkxPcbFI9fnkBwHhB
         oDvidamVan9jWztUM4FhGTo0zmOUS68WBJoAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Il1RVRiUKAxoef5RnNd4syWE0WLl3orYpLwRBHqOz80=;
        b=fI5EVLvj/ZXr5b8bhNmprStucpe80ugep7mLACiuHz5F7U5/+c0F/wUfCV5sWLFTEE
         XJzP11wJ1MXRnqutVkzozZM7P/6IR0lgEIszgCIZb4jJPTyCzl0EshGlPE50EzCLGAuu
         pnDO9klX6xy/12DMRBxrbcFP3JTxc8yYT/bMne5lKirrGBSibxPnJz6DE3T7cTE+Yw2K
         jlinK0N9bC+HUPBLwZ9Z1+nZouDw6MMzT9/96Ayfco9rvAvgdjcIuEdUlFAJf0XeAADN
         sDQQ4sWsiVw8uXKFa95d/1N2pWroTVs2P+RPlonaJ9aZAv5IOC/dvVNuyTe3lTjpH4F9
         dDog==
X-Gm-Message-State: AOAM532C/cKUMrN3pQw1rqy44CXeN0x/qACyJL9/tl1EfnHuVPlPWNaI
        FPdUsWhQZi/8njk86TCMfknltN5bOXNPMA==
X-Google-Smtp-Source: ABdhPJx9uLzU7/rkFvfos3zbnAkQbvxB94ae9xgwFLls9lT3WxLPXvCf9QR4HY6x5IviiybtdJ4R+A==
X-Received: by 2002:a05:651c:2044:: with SMTP id t4mr7801461ljo.267.1604343099980;
        Mon, 02 Nov 2020 10:51:39 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id y3sm2873910ljc.131.2020.11.02.10.51.35
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 10:51:36 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id a7so18747909lfk.9
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 10:51:35 -0800 (PST)
X-Received: by 2002:a19:7518:: with SMTP id y24mr3195355lfe.133.1604343095295;
 Mon, 02 Nov 2020 10:51:35 -0800 (PST)
MIME-Version: 1.0
References: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
 <20201102010804.uENOQsZO9%akpm@linux-foundation.org> <CAHk-=wjweewYgnT2MX2iqbj2+7QamHH+pdMQGvr3duPL5a_dvA@mail.gmail.com>
 <CACSApvZmNAOCUEEs051G7bc9-JbSv1auh+xUvuitP6LkWfn-5w@mail.gmail.com>
In-Reply-To: <CACSApvZmNAOCUEEs051G7bc9-JbSv1auh+xUvuitP6LkWfn-5w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 2 Nov 2020 10:51:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh3FcWMRAt-WGYcKP-YxLDBkpbNtVzLrm+=t6xixV+A9w@mail.gmail.com>
Message-ID: <CAHk-=wh3FcWMRAt-WGYcKP-YxLDBkpbNtVzLrm+=t6xixV+A9w@mail.gmail.com>
Subject: Re: [patch 13/15] epoll: check ep_events_available() upon timeout
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Dumazet <edumazet@google.com>,
        Guantao Liu <guantaol@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Nov 2, 2020 at 9:49 AM Soheil Hassas Yeganeh <soheil@google.com> wrote:
>
> Thank you for the suggestion. That was the first version I tried, and
> I can confirm it fixes the race because we call ep_send_events() once
> more before returning.  Though, I believe, due to time_out=1, we won't
> goto fetch_events to call ep_events_available():
>
> if (!res && eavail &&
>    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
>  goto fetch_events;

Right. We won't be repeating the loop, but we will do one final send_events.

Which I think is really the point, no?

> You're spot on that the patch is more complicated than your
> suggestion.  However, the downside I observed was a performance
> regression for the non-racy case: Suppose there are a few threads with
> a similar non-zero timeout and no ready event. They will all
> experience a noticeable contention in ep_scan_ready_list, by
> unconditionally calling ep_send_events(). The contention was large
> because there will be 2 write locks on ep->lock and one mutex lock on
> ep->mtx with a large critical section.

Ugh. I really detest the eventpoll code. Afaik, it has no normal users
anywhere, so it gets no real coverage except for the odd cases
(presumably inside google?)

A lot of the work over the last couple of years has been to try to
simplify the code and streamline it, and fix bugs due to recursion.

I really wish we would continue that pattern of trying to simplify
this code rather than add more complexity on top of it, which is why I
reacted to strongly to that patch.

And that whole ep_poll() function is written in just about the most
confusing way possible, with code that looks like loops but aren't
("while (0)") and goto's that _are_ loops ("goto fetch_events").

I'll go stare at it some more.

                   Linus
