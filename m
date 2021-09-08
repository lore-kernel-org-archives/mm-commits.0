Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25B7C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 20:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAAF860F70
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 20:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241996AbhIHURZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 16:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhIHURW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 16:17:22 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D928C061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 13:16:14 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id bg1so1989696plb.13
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 13:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3ShJARNb8UD8G+KYFR36dyKnEBjW7RAQ0P6rMybePVk=;
        b=FyVhuMpc8F7Gp04gX9DJ4771PGIZ4FZyftPVvQOLbNQ09aVfH8wMHY0TeAZKUrU/R0
         j1I5rwH2w5gpEKcwT8OmmfKPFUjndqct42/SmOJy24XaG01mA5OJLlZwT23V43lZ5QEU
         t4JjSMJB36DT3obOE4tgMLxp32SDn4k5MqbkGE5mAQlgG3rZ1cL7rM/pJTSG8pbsFeoc
         iOIx7DdIVVB+2JRfZAhTKEPuDnnbm3E7HDLmhiDYGUv/q/tgImgrot9vbXqDcTkizQBW
         JkA6h5DtRt9rAxdK0N4BncCqE0lJ/ShANRALS+AmfKLgqtX5+UWJmvvIX7fYs4jTcpJJ
         QIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3ShJARNb8UD8G+KYFR36dyKnEBjW7RAQ0P6rMybePVk=;
        b=fx1tHdMasBvdTgyQeVnm4GCz8eoM6gwyiJLEgriXM0kmIuZ69c8+sHIdDUkrcgnnJM
         p2Aw/jMT1l+Ls9steU+PPUk+IT0jDzB9IdWMn9fYTQZJ7knL5GOL4qxo2AZJ1ilnlbCZ
         /mWUrWNfPDqukBSKkUFmWlr/V8j2xAd0lIb3jzuaH/wpbPzEhAZktaKqDTZyBLZohCqJ
         1SmI6Cbew5qf/VHaxkuSD4EXmZ+17JXzG1zLwlyOs7Ah7FxBgBk175ovcQ0fmkCk6LVr
         fkzwrfXGgHA2OZ9EJeUrd6CyLTMRArnpq8TRKm/JAO6CUcwRSjrOMSE3D+cqJMcg/LGB
         CoOQ==
X-Gm-Message-State: AOAM531SL36t8TePMMEYseCxYBNoNbA21iIPOiOF6Mh2gIF0dOF+3jKF
        B3lMlz9GzdEDRINLyG35f755RCUKtbA=
X-Google-Smtp-Source: ABdhPJycfUSyRzjR4NKdvXpYgAeDbpAb+FC9RHwrYIfEHq+tT4awlBbR/P6wiEj7ZFdQryAY6lfwSQ==
X-Received: by 2002:a17:902:ab98:b029:12b:acc0:e18c with SMTP id f24-20020a170902ab98b029012bacc0e18cmr129862plr.10.1631132173922;
        Wed, 08 Sep 2021 13:16:13 -0700 (PDT)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id y11sm56820pfl.198.2021.09.08.13.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:16:13 -0700 (PDT)
Date:   Wed, 8 Sep 2021 13:16:13 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, aklimov@redhat.com,
        Alexander Lobakin <alobakin@pm.me>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dennis Zhou <dennis@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Will Deacon <will@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: Re: [patch 108/147] bitops: move find_bit_*_le functions from le.h
 to find.h
Message-ID: <YTkaDVG3EQj20kKx@yury-ThinkPad>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908025901.gV9fu4cei%akpm@linux-foundation.org>
 <CAHk-=wg-978nkW_zKigwRQSW4qAcn47q3gG5x45dOe6dh2dmUg@mail.gmail.com>
 <YTkRM/98mwL2GKns@yury-ThinkPad>
 <20210908124937.bfa68a1428df07eb4e4c0597@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908124937.bfa68a1428df07eb4e4c0597@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Sep 08, 2021 at 12:49:37PM -0700, Andrew Morton wrote:
> On Wed, 8 Sep 2021 12:38:27 -0700 Yury Norov <yury.norov@gmail.com> wrote:
> 
> > On Wed, Sep 08, 2021 at 11:37:54AM -0700, Linus Torvalds wrote:
> > > On Tue, Sep 7, 2021 at 7:59 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > >
> > > > From: Yury Norov <yury.norov@gmail.com>
> > > > Subject: bitops: move find_bit_*_le functions from le.h to find.h
> > > >
> > > > It's convenient to have all find_bit declarations in one place.
> > > 
> > > What what what?
> > > 
> > > The subject line says "move".
> > > 
> > > The body of the commit message doesn't imply anything else.
> > > 
> > > But the patch doesn't "move" anything at all:
> > > 
> > > >  include/asm-generic/bitops/find.h |  193 ----------------------------
> > > >  include/asm-generic/bitops/le.h   |   64 ---------
> > > >  2 files changed, 257 deletions(-)
> > > 
> > > What's going on?
> > > 
> > > Dropped just because I refuse to have anything to do with patches that
> > > lie about what they are actually doing.
> > 
> > This is how the patch looks in my tree:
> > https://github.com/norov/linux/commit/4a92b733138e3fd71cd8a021ad53cbce68d61cfc
> > 
> > And in my submission:
> > http://lkml.iu.edu/hypermail/linux/kernel/2108.1/07330.html
> > 
> > So it actually does what it says. The following patch in this series
> > also differs from what I have in my tree. Something weird happened...
> 
> There were some competing changes in next for a while so I guess there
> was damage.
> 
> > Andrew, Linus, are you OK if I resend the patchset?
> 
> Linus suggests other changes.  I suggest you get this tree into -next
> as discussed and put the changes through another kernel cycle.

OK, I'll resend next week.
