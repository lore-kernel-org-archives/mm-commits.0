Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3922EC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A93461054
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344137AbhIBXxG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343647AbhIBXxF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Sep 2021 19:53:05 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADE4C061575
        for <mm-commits@vger.kernel.org>; Thu,  2 Sep 2021 16:52:06 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id z2so8015238lft.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 16:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dRoRhRHYyXTHQv8bSMxayqqRJxdPz8ler3X2VgmtUGk=;
        b=UCnuREBRlb3+hDmdkNMSSpSBdCxc69D46HwPkzU73Qvu/GoPPFdLepwOjne5RDR16z
         /tzbspfn3hOT9kEmg48gklALuDOBkxdwcMxZtwJLOIwYN6IwPeeKmO89pT0nN4bUWvQc
         7A9bInuvT6GYwjL8AiGCJnHAdPYu7J6K5uf28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dRoRhRHYyXTHQv8bSMxayqqRJxdPz8ler3X2VgmtUGk=;
        b=qe7gTQuBlPZHX5xIirvuEwResuB9FMUxw0qYud6zhjdaI8pxX6/lEYJ+4O259WbHyE
         It2ilvbT6tI9fd7fRXD8hfO6KArk6t2Wvxj5Y3WNv2pQY1pl+4XYPpDw32Ad64EH+eX3
         xomTr7vOr1FihveyQdpDfANJAfmLqjIwthyjDEDOETlvF03Kt+2m0rTlr7j7bFxP/nAN
         JiwCXRTOvvJvnFZTBNGYNOv13D2hQ98nR3EsZld5aJzruqM0/zd8T68/LOuNN8s9GCMJ
         P66A6aUqjrZc6gLbBMRw2wc8bTKG4bXLhq6r1aTseLBZArRht7n2D9dzzEQ5PFJZPqFQ
         l/TA==
X-Gm-Message-State: AOAM530YHBOdLjmouV8PP9d3kZm7ybSJ5Lo9tcCbBh8Wqf3BwY05kLM4
        8Y0VIGX6/kl25fNkf7GO2TS8QVmtPCYHhKufA6g=
X-Google-Smtp-Source: ABdhPJw4eaFdSkRA03ZWcQ9KG3VwitHi4O6R6u0yMC5OjeaV55u8sDlP4Z5Bn78Jbfyv1te7bhYfIQ==
X-Received: by 2002:a05:6512:344d:: with SMTP id j13mr480538lfr.339.1630626724905;
        Thu, 02 Sep 2021 16:52:04 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id n4sm384427lji.100.2021.09.02.16.52.03
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 16:52:04 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id t12so7820668lfg.9
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 16:52:03 -0700 (PDT)
X-Received: by 2002:a05:6512:230b:: with SMTP id o11mr460496lfu.377.1630626723667;
 Thu, 02 Sep 2021 16:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
 <20210902215152.ibWfL_bvd%akpm@linux-foundation.org> <CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ@mail.gmail.com>
 <CAHk-=wiz+vp1k1Ag+fD57P4ehOpTAc=A9zT7YbGENUu57azeuQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiz+vp1k1Ag+fD57P4ehOpTAc=A9zT7YbGENUu57azeuQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Sep 2021 16:51:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiX77e3G-cOP+OLPzf8krQXgyiz7PikurJYa0fsDhS34Q@mail.gmail.com>
Message-ID: <CAHk-=wiX77e3G-cOP+OLPzf8krQXgyiz7PikurJYa0fsDhS34Q@mail.gmail.com>
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

[ Talking to myself while mulling this series over ... ]

On Thu, Sep 2, 2021 at 4:34 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Instead of having it lock/unlock halfway through the function (and
> have magic "Oh, the caller already holds the lock, so don't lock"
> semantics except with misleading names) I really think that function
> should just have been split in two, and then the locked region can be
> minimized in the caller only taking it for the first part.

If there's some reason why it can't sanely be split into two (too many
common variables or some odd control flow or whatever), at least the
locking logic should be changed from

      if (lock)
               local_irq_save(flags);

to something along the lines of

      if (!caller_already_locked)
               local_irq_save(flags);

so that when you read that function on its own, it's clear that the
lock is always held over that critical section - and the issue is that
perhaps the lock was already taken by the caller.

This ignores the whole misleading "lock" name when it isn't even yet a lock.

            Linus
