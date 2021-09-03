Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9B4C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 16:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 193DC610D2
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 16:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhICQTl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 12:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbhICQTk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2021 12:19:40 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790B4C061575
        for <mm-commits@vger.kernel.org>; Fri,  3 Sep 2021 09:18:40 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id y6so10405739lje.2
        for <mm-commits@vger.kernel.org>; Fri, 03 Sep 2021 09:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+Ifm1Ubzf/9uVSh73mk7zdYrVrljFyDr53eQvvjhmE=;
        b=VvoY+GV60+vFaTTSTAXY/UA26ZqynQ7iZJyEAtYxN2Bc31ew6yGcV++VYWl2XVReF0
         WZGfLonRSdg58CtPZ9bVY4Gyl0QEqRwaJYbD26pCd+m0CIt0PehAohS4+ab++JmvwhfQ
         pv84XxshkaFRsNbuy5kAh3Aap28CH5h8hqceI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+Ifm1Ubzf/9uVSh73mk7zdYrVrljFyDr53eQvvjhmE=;
        b=EMLMchfg5ZcAM+kYSDbuRfUVk+xTmKkv8nChkICpvrxUe4r9KpwwpT/Yzv2hGiQZql
         jtcFZ6AuqWhmREguq6KxpW5A6ZRHOyCsOSZ3JEcIW/66ANHcJgdgblQVKHjOzyeBKsZn
         JTq0ldN3tjDkIxeQAbKj1+esGtTb5CgIcnQu13qJ/YHqUsiFvW6lr0eEbIz3dOtGXgOw
         mjYUGHU8Mq89Ha1wkvLprnH2jy1ZvjwmxblLozQz885fI/tr5AgIddyLzv4xRUVuDXkj
         /1N5R2m4fAzIaoenxwOL4KlF5Uq67D3klSEP9Aoq8CPV5B3Y/Qhb3cK+rtlvZjSCnAgo
         7+ow==
X-Gm-Message-State: AOAM532oZdqv4ksOhqYpUSCAYJGFj+hDZIYimDR89szgQJuw2DeXxN+n
        pYprwpSe0RWP0tvfJWYe64zrL1ZhuaihLF8r60c=
X-Google-Smtp-Source: ABdhPJzKqjMD//UDRY1DTSIq2hlKbQ/SbSLcVFPxzPPtkzZXmFHzPRST3em+q45qu/nn7fZVTogEBw==
X-Received: by 2002:a2e:a367:: with SMTP id i7mr3520246ljn.244.1630685917854;
        Fri, 03 Sep 2021 09:18:37 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id a13sm554587lfu.13.2021.09.03.09.18.36
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 09:18:37 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id p38so12867655lfa.0
        for <mm-commits@vger.kernel.org>; Fri, 03 Sep 2021 09:18:36 -0700 (PDT)
X-Received: by 2002:a05:6512:3d28:: with SMTP id d40mr3444816lfv.474.1630685916389;
 Fri, 03 Sep 2021 09:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
 <20210902215152.ibWfL_bvd%akpm@linux-foundation.org> <CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ@mail.gmail.com>
 <CAHk-=wiz+vp1k1Ag+fD57P4ehOpTAc=A9zT7YbGENUu57azeuQ@mail.gmail.com>
 <CAHk-=wiX77e3G-cOP+OLPzf8krQXgyiz7PikurJYa0fsDhS34Q@mail.gmail.com>
 <ec75906a-bf4d-cad0-dd66-cdf2b7d35b1e@suse.cz> <d406ebb42fb9914d1a6f2fe9f26bf083612ec796.camel@gmx.de>
In-Reply-To: <d406ebb42fb9914d1a6f2fe9f26bf083612ec796.camel@gmx.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 3 Sep 2021 09:18:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjRfFtnQ5p42s_5Uv8i0U5YKSBpTH++_ZMKZyyvYicYmQ@mail.gmail.com>
Message-ID: <CAHk-=wjRfFtnQ5p42s_5Uv8i0U5YKSBpTH++_ZMKZyyvYicYmQ@mail.gmail.com>
Subject: Re: [patch 036/212] mm, slab: make flush_slab() possible to call with
 irqs enabled
To:     Mike Galbraith <efault@gmx.de>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Jann Horn <jannh@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        mm-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 2, 2021 at 11:22 PM Mike Galbraith <efault@gmx.de> wrote:
>
> To my eyeballs, below duplication of a couple lines of initialization
> needed by the lockless function is less icky than the double return.

Ack. Something like this seems to avoid the whole issue.

Vlastimil - the alternative I was actually going to suggest for that
"double return value" thing is something we use elsewhere in the VM
code - just use a structure for "state".

It's not hugely common, and I think Mike's solution in this case is
the much simpler one, but I'll mention it anyway because it's actually
been quite successful in the few cases we use it, and it's both
readable to humans and generates fairly good code.

The "generates fairly good code" is generally more true when inlining,
but it's not horrible even outside of that.

So the idea with the "state structure" is that you just pass in both
the arguments and the return values in a struct.

Some examples of this are

 - 'struct follow_page_context' in mm/gup.c is an example of a small local one.

 - 'struct vm_fault' is an example of a *big* one, that has a lot of
state, and that is actually exported as an interface.

That 'struct vm_fault' one is interesting as an example because it
does that "both inputs and outputs", and has that unnamed "const
struct" member to actually catch mis-uses where some callee would
change those fields (which is a no-no).

It's also an example of something that generates good code despite not
inlining, because it actively makes argument passing simpler and
avoids copying arguments as you call other functions.

Those issues are non-issues in this case, which is why I point to that
'follow_page_context' in the gup code as a very different example of
this, which is much more along the lines of the slub case. It's purely
local to that call chain, and it's basically used to return more
state.

In both cases, the top-level caller just initializes things on the
stack. For that 'struct vm_fault' case you actually *have* to use an
initializer, since the constant fields cannot be changed later.  It
makes for pretty legible code, and when things are inlined, all those
fields actually act exactly like just regular local variables shared
across functions.

When things aren't inlined, it can generate extra memory accesses, but
that 'struct vm_fault' is an example of when that isn't even
necessarily worse.

Anyway, I wanted to just point that out as a pattern that has been
quite successful.

Side note: one very special case of that pattern goes back decades:
the VM use of structures that get returned and passed *as* structures.
It's in fact so common that people don't even think about it: 'pte_t'
and friends. They are designed to be opaque data types that are often
multi-word structures.

Quite often those structures have only one or two words in them, which
helps code generation (returning two words can be done in registers),
but they _can_ have more.

Eg x86:

  typedef union {
          struct {
                  unsigned long pte_low, pte_high;
          };
          pteval_t pte;
  } pte_t;

or some powerpc cases:

    typedef struct { pte_basic_t pte, pte1, pte2, pte3; } pte_t;

just to show that you can actually pass structures not by reference,
but by value, and it's not even unusual in the kernel. That can also
be used to return multiple values if you want to.

Note: code generation really matters, and when doing those multi-value
structures, for code generation it's generally important to limit it
to at most two words.

Anything more, and the compiler will generally be forced to pass it by
copying it to the stack and using a pointer to it, and then you get
the worst of both worlds. You're better off just passing the structure
by reference, and avoiding extra copies on the stack.

ANYWAY.

I'll drop this part from Andrew's patch-bomb, and I can take it later
in its cleaned-up form. You mentioned a git tree elsewhere, maybe even
that way.

              Linus
