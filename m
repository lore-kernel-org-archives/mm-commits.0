Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52001C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33E48610E8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348945AbhIBWz2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348417AbhIBWy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:54:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F7B2610E8;
        Thu,  2 Sep 2021 22:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630623210;
        bh=5jgnHxjgHpPmbPMXMaHV5+3ni/YODm3ZbUm3sJrebHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PeeoG/QMnnatK3MMZIFOu6KxPuLO2ciqNLqvSHL96wg2kUuXVY/1nIs7KN6dg7gqh
         zPcGdNpzO2f9r0rSpCK8nyKi1I6HGSxIUYyy+Q4wPIKMkzpkWm8lUkCctYCjaczfob
         5DfO3BkpAU84lpbTJEeqzu8KBhFFFuIhhIiOCoAw=
Date:   Thu, 2 Sep 2021 15:53:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [patch 119/212] lazy tlb: shoot lazies, a non-refcounting lazy
 tlb option
Message-Id: <20210902155330.a643b03dc6991cde53133edf@linux-foundation.org>
In-Reply-To: <CAHk-=wjC05YZycowZkmvjZACNEm3rUhLTneN+Vaz9Ebp1+++Gw@mail.gmail.com>
References: <20210902215620._WXglfIJy%akpm@linux-foundation.org>
        <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
        <CAHk-=wjC05YZycowZkmvjZACNEm3rUhLTneN+Vaz9Ebp1+++Gw@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 2 Sep 2021 15:50:03 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Sep 2, 2021 at 3:29 PM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > This pile is:
> >
> > Nacked-by: Andy Lutomirski <luto@kernel.org>
> 
> Can you specify exactly the range you want me to drop?
> 
> I assume it's the four patches 117-120, ie
> 
>   lazy tlb: introduce lazy mm refcount helper functions
>   lazy tlb: allow lazy tlb mm refcounting to be configurable
>   lazy tlb: shoot lazies, a non-refcounting lazy tlb option
>   powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
> 
> but I just want to double-check before I do surgery on that series.

Yes, those 4.

Sorry, I missed that email thread...
