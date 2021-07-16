Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CECCC636CA
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 20:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 444BF61006
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 20:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhGPUPU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jul 2021 16:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhGPUPS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jul 2021 16:15:18 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF1BC06175F
        for <mm-commits@vger.kernel.org>; Fri, 16 Jul 2021 13:12:22 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id i5so17964526lfe.2
        for <mm-commits@vger.kernel.org>; Fri, 16 Jul 2021 13:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sU8WsVZyZL4hTLOJidVGlj9JhubqHLgGG7TU7feZ63c=;
        b=CF016SMMHT6vvFztAsO+fMbhe+DuyWrPpQs2mWC/vqeWtktS4fgo/7i0dSC7XnmlAD
         T83WSGPq/LMVpsuj9Subv0HZxyhc6LtaD8awgXFhmfAyAYCxiA/w7YdMhl8fjw5ZdXQh
         2FYCKvmLPvrCnmLNoFYZcIVfpkihSFMaqsCL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sU8WsVZyZL4hTLOJidVGlj9JhubqHLgGG7TU7feZ63c=;
        b=TsQPQZPTF66alyKrS9DqiMZInu6FhpNkfrsWZAGMpuLFKE0tesLM8QJ6WDjSvdlOh3
         WzXh1WMZeZtqhp7EJlXwlyMEjvJGrJsP3pniBLbsfkRInzhN2qNpGSVVVj2Z4/v/jlTC
         e8bMN40BCTsVN6+h9etLqQTp39akA/Jtcc75pe49dP27kc/vA4PCP2zY9d3nXIQ3CY63
         apexad+0RVeBiPtJc7+2QYes8akRTjdmWh8BOsUIMAHYv+fmjizUtL+FBkrnpDYFhBy4
         pALvwuUdCrWWQfYKQxckCH038hRTesYcOX63JSYq1xslovQmgxNToiGVV7NVdPrnZlAI
         I5oA==
X-Gm-Message-State: AOAM5303o1Tu7n9XaxvMzPFdBcFP2EnVTR7mxyy5YvvIqp8gKaB7gOTA
        pAhJvpIYRCofVerm3DZ/VQ4QhU2fuvo1dUpw
X-Google-Smtp-Source: ABdhPJz5c+qAKq405z8nlm1WOL1Btwx/O222L25x1UmDC1sAquQZPPx1sRtZYjscyZv4RHs//t4qbA==
X-Received: by 2002:a05:6512:686:: with SMTP id t6mr8673860lfe.69.1626466340484;
        Fri, 16 Jul 2021 13:12:20 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id q3sm1049053ljp.44.2021.07.16.13.12.18
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 13:12:19 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id u25so15600149ljj.11
        for <mm-commits@vger.kernel.org>; Fri, 16 Jul 2021 13:12:18 -0700 (PDT)
X-Received: by 2002:a2e:9a42:: with SMTP id k2mr10438095ljj.507.1626466338693;
 Fri, 16 Jul 2021 13:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
 <20210708010747.zIP9yxsci%akpm@linux-foundation.org> <YPE3l82acwgI2OiV@infradead.org>
In-Reply-To: <YPE3l82acwgI2OiV@infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 16 Jul 2021 13:12:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=whnjz19Ln3=s4rDZn4+XER2pmA+pEVrjpwMYGba2rHAQA@mail.gmail.com>
Message-ID: <CAHk-=whnjz19Ln3=s4rDZn4+XER2pmA+pEVrjpwMYGba2rHAQA@mail.gmail.com>
Subject: Re: [patch 07/54] mm/slub: use stackdepot to save stack trace in objects
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, glittao@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 16, 2021 at 12:39 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> This somewhat unexpectedly causes a crash when running the xfs/433 test
> in xfstests for me.  Reverting the commit fixes the problem:

I don't see why that would be the case, but I'm inclined to revert
that commit for another reason: the code doesn't seem to match the
description of the commit.

It used to be that CONFIG_SLUB_DEBUG was a config option that was
harmless and that defaulted to 'y' because there was little downside.
In fact, it's not just "default y", it doesn't even *ask* the user
unless CONFIG_EXPERT is on. Because it was fairly harmless. And then
SLOB_DEBUG_ON was that "do you actually want this code _enabled_".

But now it basically force-enables that STACKDEPOT support too, and
then instead of having an _optional_ CONFIG_STACKTRACE, you basically
have that as being forced on you whether you want active debugging or
not.

Maybe that

        select STACKDEPOT if STACKTRACE_SUPPORT

should have been

        select STACKDEPOT if STACKTRACE

because i\t used to be that CONFIG_STACKTRACE was somewhat unusual,
and only enabled for special debug cases (admittedly "CONFIG_TRACING"
likely meant that it was fairly widely enabled).

In contrast, STACKTRACE_SUPPORT is basically "this architecture supports it".

So now it seems STACKDEPOT is enabled basically unconditionally.

So I really don't see why it would cause that xfs issue, but I think
there are multiple reasons to just go "Hmm" on that commit.

Comments?

                Linus
