Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D88C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 23:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12CD26108B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 23:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241671AbhIBXQv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhIBXQu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Sep 2021 19:16:50 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9777C061575
        for <mm-commits@vger.kernel.org>; Thu,  2 Sep 2021 16:15:51 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id h1so6553255ljl.9
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 16:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QEe1uUnB3VIjFnanRTFg5dOUu65jLiMP0LAdT+dmP0I=;
        b=ENRs3hCxFxVqQbIU8uvntM+TTwPpJnXQYJJ3102PI6+lk3shQTK4KN5aU9ENRLR+NP
         T+1l14GvTuu42eMZRSERXr3iVMGmCDC5juEDGcrVriJZQYPh+h902/Ez7xAg0H24teCU
         9nulPtqVs8Ow5pmWkKNuUlUjs1cuY1rTmdQtg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QEe1uUnB3VIjFnanRTFg5dOUu65jLiMP0LAdT+dmP0I=;
        b=ddVXEbDAiqcYeyAJ2UIdmTW+3/ReAgODI5magEtCAsjL47NEs9+p2Crf6qZHiVtTiI
         iwV5kL8YC4/wZmRp3r/m7r4ijZSKfsFKTS47g24yikD7HmSqX5hEjehIbzch+aS+mTU/
         6ycTE+utdAT9gaUS/EjaQyqEyKSRzfK8NqX3tLHc+2i/JjtXxixTa6rxwFpQfRAS3wqS
         N0MFE00Dkyz19MIQGF2Z89WKOejJQsuFmgqAvxVh7TKYa8f+2/2p2ybw5w0v9eYwFmuW
         D6KOkV4idkqBSYah1NpOjSw1T8GwBkExEMrFtBkqXPikrNrUm+loNhBg1a7JyVurhz6m
         cZTQ==
X-Gm-Message-State: AOAM533HHC47LOk7+eP5oXdDb+wD4Q4II5IXBXAjppSMrovIpgmnDHX5
        080dKkVpp4ZQYlGy6Rtvbv63pqx02hWKAjC8WLc=
X-Google-Smtp-Source: ABdhPJxjyEMPXJRO73t0tyGhvVcTxu8a14xnbYOUBIWOpwytgkmnNY0qaEHdUh9TtcdHxq87/Wnv5g==
X-Received: by 2002:a2e:98d1:: with SMTP id s17mr596161ljj.138.1630624549331;
        Thu, 02 Sep 2021 16:15:49 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id k3sm318344lfj.129.2021.09.02.16.15.48
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 16:15:48 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id t12so7667944lfg.9
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 16:15:48 -0700 (PDT)
X-Received: by 2002:a05:6512:228f:: with SMTP id f15mr404545lfu.253.1630624548039;
 Thu, 02 Sep 2021 16:15:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org> <20210902215152.ibWfL_bvd%akpm@linux-foundation.org>
In-Reply-To: <20210902215152.ibWfL_bvd%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Sep 2021 16:15:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ@mail.gmail.com>
Message-ID: <CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ@mail.gmail.com>
Subject: Re: [patch 036/212] mm, slab: make flush_slab() possible to call with
 irqs enabled
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Mike Galbraith <efault@gmx.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Jann Horn <jannh@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        mm-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 2, 2021 at 2:51 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Vlastimil Babka <vbabka@suse.cz>
> Subject: mm, slab: make flush_slab() possible to call with irqs enabled
>
> Currently flush_slab() is always called with disabled IRQs if it's needed,
> but the following patches will change that, so add a parameter to control
> IRQ disabling within the function, which only protects the kmem_cache_cpu
> manipulation and not the call to deactivate_slab() which doesn't need it.

I absolutely DETEST this patch.

Code like this is just garbage:

> -static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
> +static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
> +                             bool lock)
....
> +       if (lock)
> +               local_irq_save(flags);

with actively misleading names ("lock"? WTF? There's no lock there!)
and just disgusting semantics with conditionals etc.

And the thing is, I don't even see that this would be in the least required.

If that function had just been split into two: the first part that
needed to absolutely be called with interrupts disabled, and the
latter part that didn't, then none of this stupid ugly code would be
needed at all.

So flush_slab() could have been split into "that first part that
returned the freelist and page, and then the second part that did the
deactivate_slab() and the stats update.

Then somebody who had interrupts disabled anyway (ie existing cases)
would just do both.

And then the new code that you want to have with interrupts disabled
just for the first part would do the first part with interrupts
disabled, and the second part without.

See? No need for a "flags" field and odd conditional interrupt disables.

And yes, I realize that the "inline" means that *most* of the time,
the compiler will inline things, the "conditional" will become static,
and it will not be a run-time conditional.

But it's the human-readable conditional that is the ugly part here.
Now any sane human that reads that flush_slab() code will see "oh,
sometimes interrupts are disabled, and sometimes they aren't".

Because that is what the code does, at that level.

But no, what's actually going on is that interrupts are *always*
disabled - it's just that sometimes they will have already been
disabled in the caller. So all that misleading and misnamed "lock"
argument does is really "were interrupts already disabled so that I
don't need to disable and re-enable them".

That's what the code actually *does*, but it's not how the code reads,
and it's not how the code is written, or how the argument in question
is named.

So it's all very misleading, and ugly.

I'm going to sleep on this, and maybe tomorrow morning my reaction
will be "whatever, the code probably works".

But more likely, tomorrow morning I will take another look, and still
say "no, this is actually making the code less maintainable and
actively misleading", and just throw the whole slab series out the
window.

                 Linus
