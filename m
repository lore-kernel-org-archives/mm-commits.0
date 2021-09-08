Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C910AC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 16:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B25A46105A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 16:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349183AbhIHQcm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234225AbhIHQcl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 12:32:41 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303CAC061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 09:31:33 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id s3so4471385ljp.11
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 09:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SVlWaxGx6FYZPcg4i9WVD15rj+S71jYg6Og6e2k1zfU=;
        b=L9F43tftzm0xASYTik31lPxna5y5nRH1cgGiCCBAz5Liw7VqJrSIBOCUhTjiw3WSzs
         54KnrAHqR0LQ+pHK+hMCLCQ+DNgZmPxQR1YlrjxEoWiyVqfHcxpFkO3pISkZksxSO8xP
         lYuCXBN2XaCvf++ggfc47HL1+MK3tQ8Frbz0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SVlWaxGx6FYZPcg4i9WVD15rj+S71jYg6Og6e2k1zfU=;
        b=pOXz8nJJstDdAdmIdr7cnRw5QIvGFNONkS71+MqmbA/Vxe10J8I1lMNsDo5Ax3SOyK
         rZWNP4W5ByptU3M9+Fi5SVmaJTLxluQc7kyXFt8oqs8henEkXfXJkt/fJmGn9BHIUr4y
         QZmN14S0+fHmtvR+JvGGCgUCGgZHwoU8sfdMvQR69h7xXE13ySS/KgQrbNFi6W6owMfc
         EKaY/Eeob2rCRL4Kweq7LwlzfP63txZw8iLRE5PTAe65pQiZPAVNPyWgDTQ8rkjQQA3C
         sfdbFw3ehc26cOPj3ShAcR4EJZ2ectTZtlb1OUZov9mqmOK+bB+RHly0cvMIQmDaZr8f
         P8xQ==
X-Gm-Message-State: AOAM531qCN108JmvzdmfRcS0A6HLwYBl00roTeSwCjgUho72AUSF8CY/
        9wPlW4pSBICooSGaW6hKPQ/OzIEkcScfnzSVJfw=
X-Google-Smtp-Source: ABdhPJxa/ACb9XAjcbSXxJH3x824iD125/k9XS6Aw9ZjSX9kB5hdyLztU++3e2a0P8NKfpBatcCWlA==
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr3586012ljp.312.1631118690788;
        Wed, 08 Sep 2021 09:31:30 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id v3sm234348lfr.44.2021.09.08.09.31.26
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 09:31:26 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id f2so4519984ljn.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 09:31:26 -0700 (PDT)
X-Received: by 2002:a2e:8185:: with SMTP id e5mr3412736ljg.31.1631118685695;
 Wed, 08 Sep 2021 09:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210908025436.dvsgeCXAh%akpm@linux-foundation.org>
 <d35ad130-c72a-c47b-9d00-5c7bb5196421@redhat.com> <c29dc2e4-df74-c5cc-9580-9cdff7e2a309@suse.cz>
 <0bc898a0-2c3f-a8db-ef19-e8c5ebc3ed71@redhat.com>
In-Reply-To: <0bc898a0-2c3f-a8db-ef19-e8c5ebc3ed71@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 09:31:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjKFKyAz+DtAyXCaj8-ppaK_1TRyXPFvaNm42B1wDzEug@mail.gmail.com>
Message-ID: <CAHk-=wjKFKyAz+DtAyXCaj8-ppaK_1TRyXPFvaNm42B1wDzEug@mail.gmail.com>
Subject: Re: [patch 031/147] mm, slub: protect put_cpu_partial() with disabled
 irqs instead of cmpxchg
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christoph Lameter <cl@linux.com>,
        Mike Galbraith <efault@gmx.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Jann Horn <jannh@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        mm-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        quic_qiancai@quicinc.com, David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Sep 8, 2021 at 9:11 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
> The non-save variant simply translated onto CLI and STI, which seems to
> be very fast.

It will depend on the microarchitecture.

Happily:

> The cost of save+restore when the irqs are already disabled is the same
> (did a quick test).

The really expensive part used to be P4. 'popf' was hundreds of cycles
if any of the non-arithmetic bits changed, iirc.

P4 used to be a big headache just because of things like that -
straightforward code ran very well, but anything a bit more special
took forever because it flushed the pipeline.

So some of our optimizations may be historic because of things like
that. We don't really need to worry about the P4 glass jaws any more,
but it *used* to be much quicker to do 'preempt_disable()' that just
does an add to a memory location than it was to disable interrupts.

> Cannot remember who told me, but (apparently) the expensive part is
> reading the CPU FLAGS.

Again, it ends up being very dependent on the uarch.

Reading and writing the flags register is somewhat expensive because
it's not really "one" register in hardware any more (even if that was
obviously the historical implementation).

These days, the arithmetic flags are generally multiple renamed
registers, and then the other flags are a separate system register
(possibly multiple bits spread out).

The cost of doing those flag reads and writes are hard to really
specify, because in an OoO architecture a lot of it ends up being "how
much of that can be done in parallel, and what's the pipeline
serialization cost". Doing a loop with rdtsc is not necessarily AT ALL
indicative of the cost when there is other real code around it.

The cost _could_ be much smaller, in case there is little
serialization with normal other code. Or, it could be much bigger than
what a rdtsc shows, because if it's a hard pipeline flush, then a
tight loop with those things won't have any real work to flush, while
in "real code" there may be hundreds of instructions in flight and
doing the flush is very expensive.

The good news is that afaik, all the modern x86 CPU microarchitectures
do reasonably well. And while a "pushf/cli/popf" sequence is probably
more cycles than an add/subtract one in a benchmark, if the preempt
counter is not otherwise needed, and is cold in the cache, then the
pushf/cli/popf may be *much* cheaper than a cache miss.

So the only way to really tell would be to run real benchmarks of real
loads on multiple different microarchitectures.

I'm pretty sure the actual result is: "you can't measure the 10-cycle
difference on any modern core because it can actually go either way".

But "I'm pretty sure" and "reality" are not the same thing.

These days, pipeline flushes and cache misses (and then as a very
particularly bad case - cache line pingpong issues) are almost the
only thing that matters.

And the most common reason by far for the pipeline flushes are branch
mispredicts, but see above: the system bits in the flags register
_have_ been cause of them in the past, so it's not entirely
impossible.

               Linus
