Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23551C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 18:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E17E8229C5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 18:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgLVSjH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 13:39:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgLVSjH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 13:39:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6253322B2B;
        Tue, 22 Dec 2020 18:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608662306;
        bh=ZLPy2/k4dj+q/4uN4gJ2XDetCACVG+IJthYVvBqxIVk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nuE5Y6wAsSoDSYCreWozVHaO3rZDcB5P6yc+1w5s6W+TxNX6aMoHLJoy6YMkce03v
         tEQGItjXxythbtOe+aH8CT4RU9o9si/9A3JtWlrozBmrJGK07gHZPNKjgh7nlA2Bg8
         njxzeaxTReKqbp0p0ZBkXCSdVluwyj1y7zfREQ8k=
Date:   Tue, 22 Dec 2020 10:38:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [patch 21/78] kasan: split out shadow.c from common.c
Message-Id: <20201222103825.1ca614e98be0df48ee3611d0@linux-foundation.org>
In-Reply-To: <CAHk-=whJodNM=W7xWNKQFofsV5pXbozaAwrs2hGa=Bi=8n18ZQ@mail.gmail.com>
References: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
        <20201218220233.pgX0nYYVt%akpm@linux-foundation.org>
        <X91JLZhrXYaLzoB8@elver.google.com>
        <20201218171327.180140338d183b41a962742d@linux-foundation.org>
        <CAHk-=whK70LHzMw5SxUu_1NHkWtZc-o1PHyotkmwR49e2Jh6rw@mail.gmail.com>
        <CAG_fn=UuweEsetS8o-wwrke=9JQOxFvDvjRjG9Y8YG+5bLpfOA@mail.gmail.com>
        <CAHk-=whJodNM=W7xWNKQFofsV5pXbozaAwrs2hGa=Bi=8n18ZQ@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 21 Dec 2020 09:41:37 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Dec 21, 2020 at 1:46 AM Alexander Potapenko <glider@google.com> wrote:
> >
> > It would be a pity to punt that big chunk of MTE-related work the
> > folks did just because of the leftover KFENCE bits, we didn't mean to.
> 
> Note that it wasn't just the kfence bits - that was only a symptom of
> the problem.
> 
> The real problem is that Andrew apparently doesn't have a
> KASAN-capable setup right now, so he isn't building what he sends me.
>
> linux-next ends up building the end result, of course, but that's the
> full series, and the smaller sequences don't get any build testing.
> 

All sorted out now - I'll send the kasan work along later today.
