Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909A0C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 19:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 785B861168
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 19:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350977AbhIHTjm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 15:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352047AbhIHTjh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 15:39:37 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB54C061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 12:38:29 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k23so2470851pji.0
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 12:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gvazVKjmr0ClIho70lbSxFcul3Doejyi9xOGphIQgSc=;
        b=G8ISVSNEbp3arAmmZ1NVQuW8XViUjZjT8qNl33yyw/ZcLp7ujOL7kBLdwMrBcuurUI
         XeQLe570kph/dAHfqBC4CPKiWu3nIH/dFNgpi0QphfCclLziQ7JD4bCTNxU2lppRDVNG
         Mk3TZAd5I/B+YSBkxM5Eyomw606hnw2LbXyTVQHHRHXtCNn/TVPSV3QuXCL6VgTYnqet
         Qb4cqek0Vw+QOCErj8Ze/uIkm93+1X1wQnvve/g5N+lQvZOiiTMgwkIYSokue+5maM8S
         CGBSCUD/jdvCTDNQWR8yI+cak2lk2YuG5Nxrr97SodVhtBZ0Ow7pipaYOitbly9rwFgy
         cQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gvazVKjmr0ClIho70lbSxFcul3Doejyi9xOGphIQgSc=;
        b=X8XSJb8b7gEabKTovOVC/sEhDEeny+hn4fb1RzXkkSG90Pntb8O1dAfmWNvNYH1xLy
         FEie/92qMtuim7/InDI3//fv/FJNJNux6DUCKI9gB6AFxmmyrp5rTmek79KqRuobbkp3
         Q6bPf0u0LD8h2zIYk5RESGS7bIle2gSwnOYWb8/HvWcsIHrjDbtB+kfPHzbRuPic1wgW
         CUkc6I2SCM0S8mLPVCX4vRWnRmJ8hQTmXNpMeagSJS340XQ7PkCGQeLURAUAQRnIEnwb
         CCQ8MyCSWA8LFvzsuD7yAARGQCIlnaxvvCw0huBjI2RF4F3Vy+EnzyAI1oghmaBj0MH4
         yq2w==
X-Gm-Message-State: AOAM533/gfAc5l/6+PTK6lqi/u0dmLl+Wwe2V/pqteGy5KN98rDcSfn8
        Qc7jyBPvRAyL6x49fZBWefQ=
X-Google-Smtp-Source: ABdhPJyhimC+RogpTliRksSE9iDYr7aP/zZKpKMTx55hFOu0fpmxmB5f/Yhp3J/skXtZ2EAst3WDmQ==
X-Received: by 2002:a17:90a:16:: with SMTP id 22mr86494pja.25.1631129908478;
        Wed, 08 Sep 2021 12:38:28 -0700 (PDT)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id t9sm26345pfe.73.2021.09.08.12.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 12:38:28 -0700 (PDT)
Date:   Wed, 8 Sep 2021 12:38:27 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, aklimov@redhat.com,
        Alexander Lobakin <alobakin@pm.me>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dennis Zhou <dennis@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Will Deacon <will@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: Re: [patch 108/147] bitops: move find_bit_*_le functions from le.h
 to find.h
Message-ID: <YTkRM/98mwL2GKns@yury-ThinkPad>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908025901.gV9fu4cei%akpm@linux-foundation.org>
 <CAHk-=wg-978nkW_zKigwRQSW4qAcn47q3gG5x45dOe6dh2dmUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg-978nkW_zKigwRQSW4qAcn47q3gG5x45dOe6dh2dmUg@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Sep 08, 2021 at 11:37:54AM -0700, Linus Torvalds wrote:
> On Tue, Sep 7, 2021 at 7:59 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > From: Yury Norov <yury.norov@gmail.com>
> > Subject: bitops: move find_bit_*_le functions from le.h to find.h
> >
> > It's convenient to have all find_bit declarations in one place.
> 
> What what what?
> 
> The subject line says "move".
> 
> The body of the commit message doesn't imply anything else.
> 
> But the patch doesn't "move" anything at all:
> 
> >  include/asm-generic/bitops/find.h |  193 ----------------------------
> >  include/asm-generic/bitops/le.h   |   64 ---------
> >  2 files changed, 257 deletions(-)
> 
> What's going on?
> 
> Dropped just because I refuse to have anything to do with patches that
> lie about what they are actually doing.

This is how the patch looks in my tree:
https://github.com/norov/linux/commit/4a92b733138e3fd71cd8a021ad53cbce68d61cfc

And in my submission:
http://lkml.iu.edu/hypermail/linux/kernel/2108.1/07330.html

So it actually does what it says. The following patch in this series
also differs from what I have in my tree. Something weird happened...

Andrew, Linus, are you OK if I resend the patchset?

Yury
