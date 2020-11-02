Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCD6C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 19:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB21722268
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 19:58:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WB2ZxTjc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgKBT4V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Nov 2020 14:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgKBTzP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2020 14:55:15 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958A2C0617A6
        for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2020 11:55:15 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id w14so15988083wrs.9
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 11:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k5A/EgqemLJHyDlB4QJwwgxeJLYtpvLZ7RNKLU5WGtM=;
        b=WB2ZxTjccAamLEcZE06q1LVwtvMY8+mAxG0rpRCE9N3Y3l4kSV8AJ9xPRYDglumfOe
         +xy0dIFCaPBScdclyXOd4fwIFt6OdbzCkHbVS5VDaH+UkNxCOZxDR5F6RRxAXLiXl519
         UMlOsceI37TOQ8yDZFSynwUKLEsXxko2/osNsfUm2tYapSm6hF/C53HWCZ/QH5Qy9pUa
         9dkgl5BiJNAXvjSZ8HvckLx1OddZc7k5Ejm1OpXKSQnt+di8oBmaEGugFlFxvTf/zjhK
         aTNnkatSTRTqf5q88g+TkR3WqPT90sbfMloG9ds5EN14IPIi420FGssnUGxXoVEmKhzV
         tZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5A/EgqemLJHyDlB4QJwwgxeJLYtpvLZ7RNKLU5WGtM=;
        b=kYc1iaacp7Tk13ekcNTYf9x3/y04qrdQEAphCpdO/6mqmJGfkdskjqGinGZOO4tbz3
         DufneM5uPFy3D6gSXVPwTzog7emv+KM0rfXAUbaHEQewnHvZweLnKthlC8tY0+0WjzVd
         xnYJ1rGFbfAO0PSaeDqgFbaj/HZyWUAQBg5OSupWXPnP2Z9pvHRemjHiJ96wYbwPoMYX
         edwFtWFCFyxPdgc6nz53HiW82SlKmM2V03NzhMbIvg10XdhWPIE+19MLBITBR6/cJ+OW
         3CSfYeVnJVZVeoz09fWIFbdNQ6a0IIrPmwpQkyB+5byqsuYgJYi0NuUQ2vXXahTNR8qe
         uvvg==
X-Gm-Message-State: AOAM532SETnhkXjWyttpiM5B0SvaiOSsc0zU4OUnJeBJoiLDeGkZipO8
        FwoDNfgI1Uk1AFosh9Jca3HDtNm9sH0l+iRJRvHUJQ==
X-Google-Smtp-Source: ABdhPJyzDNcrIdilbE3mzaRTkDxGXakQuOsy8v1942eLfhUlUHnghdYcXk5QDqW7PXgfTo4wzC7Iiqkte7m+Hm+NsHk=
X-Received: by 2002:a5d:54c1:: with SMTP id x1mr23345365wrv.172.1604346913867;
 Mon, 02 Nov 2020 11:55:13 -0800 (PST)
MIME-Version: 1.0
References: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
 <20201102010804.uENOQsZO9%akpm@linux-foundation.org> <CAHk-=wjweewYgnT2MX2iqbj2+7QamHH+pdMQGvr3duPL5a_dvA@mail.gmail.com>
 <CACSApvZmNAOCUEEs051G7bc9-JbSv1auh+xUvuitP6LkWfn-5w@mail.gmail.com> <CAHk-=wh3FcWMRAt-WGYcKP-YxLDBkpbNtVzLrm+=t6xixV+A9w@mail.gmail.com>
In-Reply-To: <CAHk-=wh3FcWMRAt-WGYcKP-YxLDBkpbNtVzLrm+=t6xixV+A9w@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 2 Nov 2020 14:54:37 -0500
Message-ID: <CACSApvZiWLAzSpkkBSo9=U_Fpx85_xCryaDh+sFsr7Uw8-RjUg@mail.gmail.com>
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

On Mon, Nov 2, 2020 at 1:51 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Nov 2, 2020 at 9:49 AM Soheil Hassas Yeganeh <soheil@google.com> wrote:
> >
> > Thank you for the suggestion. That was the first version I tried, and
> > I can confirm it fixes the race because we call ep_send_events() once
> > more before returning.  Though, I believe, due to time_out=1, we won't
> > goto fetch_events to call ep_events_available():
> >
> > if (!res && eavail &&
> >    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
> >  goto fetch_events;
>
> Right. We won't be repeating the loop, but we will do one final send_events.
>
> Which I think is really the point, no?

Yes, absolutely, that's the point.

> > You're spot on that the patch is more complicated than your
> > suggestion.  However, the downside I observed was a performance
> > regression for the non-racy case: Suppose there are a few threads with
> > a similar non-zero timeout and no ready event. They will all
> > experience a noticeable contention in ep_scan_ready_list, by
> > unconditionally calling ep_send_events(). The contention was large
> > because there will be 2 write locks on ep->lock and one mutex lock on
> > ep->mtx with a large critical section.
>
> Ugh. I really detest the eventpoll code. Afaik, it has no normal users
> anywhere, so it gets no real coverage except for the odd cases
> (presumably inside google?)
>
> A lot of the work over the last couple of years has been to try to
> simplify the code and streamline it, and fix bugs due to recursion.
>
> I really wish we would continue that pattern of trying to simplify
> this code rather than add more complexity on top of it, which is why I
> reacted to strongly to that patch.
>
> And that whole ep_poll() function is written in just about the most
> confusing way possible, with code that looks like loops but aren't
> ("while (0)") and goto's that _are_ loops ("goto fetch_events").

I wholeheartedly agree. Due to its cryptic implementation, It was
really difficult to think about the correctness of the fixes.

On Mon, Nov 2, 2020 at 2:39 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Nov 2, 2020 at 10:51 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I'll go stare at it some more.
>
> That code is fundamentally broken in so many ways.
>
> Look at how  ep_poll() does that ep_events_available() without
> actually holding the ep->lock (or the ep->mtx) in half the cases.
>
> End result: it works in 99.9% of all cases, but there's a race with
> somebody else doing
>
>         WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
>         /*
>          * Quickly re-inject items left on "txlist".
>          */
>         list_splice(&txlist, &ep->rdllist);
>
> when that code can see an empty rdllist and an inactive ovflist and
> thus decide that there are no events available.
>
> I think the "Quickly re-inject" comment may be because some people
> knew of that race.
>
> The signal handling is also odd and looks broken.
>
> The "short circuit on fatal signals" means that ep_send_events() isn't
> actually done on a SIGKILL, but the code also used an exclusive wait,
> so nobody else will be woken up either.
>
> Admittedly you can steal wakeups other ways, by simply not caring
> about the end result, so maybe that's all just inherent in epoll
> anyway. But it looks strange, and it seems pointless: the right thing
> to do would seem to be simply to have a regular check for
> signal_pending(), and returning -EINTR if rather than looping.
>
> And that do { } while (0) is entirely pointless. It seems to exist in
> order to use "break" instead of the goto that everything else does,
> which I guess is nice, except the whole need for that comes from how
> oddly the code is written.
>
> Why doesn't this all do something like the attached instead?

This looks really great to me! Thank you!  I'll give it a try and get
back to you soon.

> NOTE! I did not bother to fix that ep_events_available() race.

Given that you're calling ep_events_available() under lock, I think
this should address the inefficiency for the non-racy timeout case,  I
mentioned above. The remaining races are preexisting and all result in
spurious events, which should be fine.

Thanks again!
Soheil

>                       Linus



> I'll go stare at it some more.
>
>                    Linus
