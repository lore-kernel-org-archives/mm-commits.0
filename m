Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD14C00A89
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 17:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38AF920756
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604336940;
	bh=ooh8wTqfJlSRN6V5CxcXzPZy0UyRYio50u2paWm8R48=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:Reply-To:List-ID:
	 From;
	b=vMwNawbj9AKEwgbWMMCtqOEFFeUF+l8OlOXx5bGNWmtme+oLEqrZkqOmPPftNxmcw
	 F25I5cwNju6/ezCwf1wIjb351mKynGdAXgjNmSuxZpzIiCoUaxGkJYaS+S5u2kFBAE
	 QE2y/67sy2BsHtkZ0aUa9rqPmysL/bza3XdCC1uw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgKBRI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbgKBRI7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2020 12:08:59 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58484C0617A6
        for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2020 09:08:59 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a7so18352535lfk.9
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 09:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/yKbwd8teEZfRwagaMtRcUpC2gb0x64xrCI3HX4kiMo=;
        b=GO1P0qRzMuEf9eqjFiCYJZL5DwDA374+wWDOxErTNzaxestNIqQQXioUHFyKKCoRpn
         kInBe+In8Vsyahjo7HvQKMf1i2i2X76nvHCqlxOFio2PpyaIvst+5/LdBNO5fvNAMNV8
         RqVoVU2njXn+oAP5zbMN0mC5JHkXvl8ZQNNLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/yKbwd8teEZfRwagaMtRcUpC2gb0x64xrCI3HX4kiMo=;
        b=o54MuVvR3c4jgOKOGyRQPOJ993wG+FtO8dwhw4GlbD6ngSKu3ds5fax9e3t6PYSLAG
         EFFITdF2np4ELMG7YSI3nUdJW9tVYVz46flewiqXq/lJCey3cdyY1ALYxwzXcoAcLOj4
         YHSwPgr/ZwjHRtS/92TGG/68g3KAAYee9sPwm0+tHf2BsHjIX0kZyavE9fs0o3SFlOjd
         AyjDjAUp5pZUoZf0V8mRqCny+rnVTrp+nYddzTup2T32KpcpqfNmCeEN1IqdtV3Najlb
         Sr4SRbIW/xza+swoIkd+r64S+T3KZpX1BKMLh6IeaZUQc0wgfVBmlnl7+5C/uAS6Bwi6
         YncQ==
X-Gm-Message-State: AOAM5307VIPDr5hspzTMRJUbftI0Q8XRerpOs4rryau2DTyoUYhWb36E
        E6QZjWBCYpU8RJ2sVM6sDrGfCrwNKOrEZQ==
X-Google-Smtp-Source: ABdhPJzcRDsx3NNfQ/ikl5fDzEKL5ZnXy4fAaIkkfQH0pGGDlkfDjlB2ulgIbsnTcgVHHNRbfmInEw==
X-Received: by 2002:a19:cb12:: with SMTP id b18mr5628921lfg.262.1604336937292;
        Mon, 02 Nov 2020 09:08:57 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id 21sm2596228lju.110.2020.11.02.09.08.52
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 09:08:53 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id 126so18359104lfi.8
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 09:08:52 -0800 (PST)
X-Received: by 2002:a19:c703:: with SMTP id x3mr5683463lff.105.1604336932623;
 Mon, 02 Nov 2020 09:08:52 -0800 (PST)
MIME-Version: 1.0
References: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org> <20201102010804.uENOQsZO9%akpm@linux-foundation.org>
In-Reply-To: <20201102010804.uENOQsZO9%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 2 Nov 2020 09:08:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjweewYgnT2MX2iqbj2+7QamHH+pdMQGvr3duPL5a_dvA@mail.gmail.com>
Message-ID: <CAHk-=wjweewYgnT2MX2iqbj2+7QamHH+pdMQGvr3duPL5a_dvA@mail.gmail.com>
Subject: Re: [patch 13/15] epoll: check ep_events_available() upon timeout
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
        Eric Dumazet <edumazet@google.com>, guantaol@google.com,
        khazhy@google.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Nov 1, 2020 at 5:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> After abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2)
> timeout"), we break out of the ep_poll loop upon timeout, without checking
> whether there is any new events available.  Prior to that patch-series we
> always called ep_events_available() after exiting the loop.

This patch looks overly complicated to me.

It does the exact same thing as the "break" does, except:

 - it does it the non-optimized way without the "avoid spinlock"

 - it sets eavail if there was

It would seem like the *much* simpler patch is to just do this oneliner instead:

    diff --git a/fs/eventpoll.c b/fs/eventpoll.c
    index 4df61129566d..29fa770ce1e3 100644
    --- a/fs/eventpoll.c
    +++ b/fs/eventpoll.c
    @@ -1907,6 +1907,7 @@ static int ep_poll(struct eventpoll *ep,
struct epoll_event __user *events,

                if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
                        timed_out = 1;
    +                   eavail = 1;
                        break;
                }

and *boom* you're done. That will mean that after a timeout we'll try
one more time to just do that ep_events_available() thing.

I can see no downside to just setting eavail unconditionally and
keeping the code much simpler. Hmm?

             Linus
