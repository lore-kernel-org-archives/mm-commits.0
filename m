Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8521C00A89
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 17:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B2B21D91
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 17:49:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ldc/5Z9q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgKBRtc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgKBRtb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2020 12:49:31 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C12CC0617A6
        for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2020 09:49:31 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id h22so10355897wmb.0
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 09:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMpsM0M3AdGW4q+fUp9nAkmdebCdEbbt+FqsNBDtnyU=;
        b=Ldc/5Z9q44Ih+zCEpxPC0bp2t3nP3laWvJVgM+C/rUcraM5h63WYWsToTDPIhrrfHO
         pAmf5kAc6A2VrP3OMVKSGro1hZ5g5QV2Uf4u7T7Wu+wEB+JSOlJ5ee+hFumPjeropUJT
         aeE4Ya0L8zXaZ49zKjLCKMO1GqTLLHfDiUiLr3xA8678yso9/u4Ya5JgBppWslnlIGEh
         aGFkV25zC7lo9HOg8OGy+FhFtFV13595RPyAN+JdtXISCgkgewEJc6dEMGdkTV7iX9+y
         DBOH5B7+WcHGIij6No8mFdGkkhXr1wP+PmmJuyl+EFINvs2UcRB0xDMj/aS7f+rJXrs4
         027A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMpsM0M3AdGW4q+fUp9nAkmdebCdEbbt+FqsNBDtnyU=;
        b=BGjfj+MI+F6dxBH8cpZs/Fz6HzYqA9LMjTQ6wol82t/AeFwwATYYFPlZoGGaa9Fqu/
         zgQm319uhN85nrL+W60yHHpewibIsoeQ2xW1Mdu5/XtcG5DAE2ugbTfs7gkWfmsX2ZNJ
         +4dv8W5xC0G16CUGtC06SrSJTzUra+WZ2/Hrqj1CsBhaZdApAnzau7/Le0IzttsFGob6
         PlpN/HIlf0R3kj0G97S8guGf7nkhu/Dwsl5woNIa/kTlkpp/gOM34k9/tFmQPcV4nVQe
         QGLZn0mQJY5GaEZb1yjcfS93LgfToqZ2eSsgB/FYdopuOFQwuuKn4aAC9D0RkF0DvEku
         84pw==
X-Gm-Message-State: AOAM533azTWCZtyiO/VIE6KCLQKbI7gjnWs1JGrGOZl4n/u18fQaAQe+
        9GcAbfevwc0AJtd8gFkESOJxI0nm27aTgfsomtE1eg==
X-Google-Smtp-Source: ABdhPJxPk5bF9lRHtWcHQmKc47iH0s0bLRz71yugVR7jasX8OG3MGmuWd5PJb+n0AlN1GK2ENXi7XFtVBwk5fThRntc=
X-Received: by 2002:a1c:4944:: with SMTP id w65mr19504307wma.50.1604339369807;
 Mon, 02 Nov 2020 09:49:29 -0800 (PST)
MIME-Version: 1.0
References: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
 <20201102010804.uENOQsZO9%akpm@linux-foundation.org> <CAHk-=wjweewYgnT2MX2iqbj2+7QamHH+pdMQGvr3duPL5a_dvA@mail.gmail.com>
In-Reply-To: <CAHk-=wjweewYgnT2MX2iqbj2+7QamHH+pdMQGvr3duPL5a_dvA@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 2 Nov 2020 12:48:53 -0500
Message-ID: <CACSApvZmNAOCUEEs051G7bc9-JbSv1auh+xUvuitP6LkWfn-5w@mail.gmail.com>
Subject: Re: [patch 13/15] epoll: check ep_events_available() upon timeout
To:     Linus Torvalds <torvalds@linux-foundation.org>
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

On Mon, Nov 2, 2020 at 12:08 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Nov 1, 2020 at 5:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > After abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2)
> > timeout"), we break out of the ep_poll loop upon timeout, without checking
> > whether there is any new events available.  Prior to that patch-series we
> > always called ep_events_available() after exiting the loop.
>
> This patch looks overly complicated to me.
>
> It does the exact same thing as the "break" does, except:
>
>  - it does it the non-optimized way without the "avoid spinlock"
>
>  - it sets eavail if there was
>
> It would seem like the *much* simpler patch is to just do this oneliner instead:
>
>     diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>     index 4df61129566d..29fa770ce1e3 100644
>     --- a/fs/eventpoll.c
>     +++ b/fs/eventpoll.c
>     @@ -1907,6 +1907,7 @@ static int ep_poll(struct eventpoll *ep,
> struct epoll_event __user *events,
>
>                 if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
>                         timed_out = 1;
>     +                   eavail = 1;
>                         break;
>                 }
>
> and *boom* you're done. That will mean that after a timeout we'll try
> one more time to just do that ep_events_available() thing.

Thank you for the suggestion. That was the first version I tried, and
I can confirm it fixes the race because we call ep_send_events() once
more before returning.  Though, I believe, due to time_out=1, we won't
goto fetch_events to call ep_events_available():

if (!res && eavail &&
   !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
 goto fetch_events;

> I can see no downside to just setting eavail unconditionally and
> keeping the code much simpler. Hmm?

You're spot on that the patch is more complicated than your
suggestion.  However, the downside I observed was a performance
regression for the non-racy case: Suppose there are a few threads with
a similar non-zero timeout and no ready event. They will all
experience a noticeable contention in ep_scan_ready_list, by
unconditionally calling ep_send_events(). The contention was large
because there will be 2 write locks on ep->lock and one mutex lock on
ep->mtx with a large critical section.

FWIW, I also tried the following idea to eliminate that contention but
I couldn't prove that it's correct, because of the gap between calling
ep_events_available and removing this thread from the wait queue.
That was why I resorted to calling __remove_wait_queue() under the
lock.

     diff --git a/fs/eventpoll.c b/fs/eventpoll.c
     index 4df61129566d..29fa770ce1e3 100644
     --- a/fs/eventpoll.c
     +++ b/fs/eventpoll.c
     @@ -1907,6 +1907,7 @@ static int ep_poll(struct eventpoll *ep,
 struct epoll_event __user *events,

                 if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
                         timed_out = 1;
     +                   eavail = ep_events_available(ep);
                         break;
                 }

Also, please note that the non-optimized way without the "avoid
spinlock" is not problematic in any of our benchmarks because, when
the thread times out, it's likely on the wait queue except for this
particular racy scenario.

Thanks!
Soheil


>              Linus
