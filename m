Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D3BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 18:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245727AbiEJSRn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 14:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348790AbiEJSPQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 14:15:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41FD28136D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 11:10:19 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AEDA81EC0453;
        Tue, 10 May 2022 20:10:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1652206213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=CA9XCW+3vY90B+NPPSm58PWLfdL7IdSNg6/75IR40wA=;
        b=cHei8f7sF+LIX1COf2p5zo7edf2d3FeiiJT/MuEb+Q2Iz8L3OyLI8MrAmyMVQOIt3Srp40
        l1npxY060bC8ZfGw4MIqYoTwCM3hkP+20uGWQJyHTko6GZSRHM/TvaO/AO+aVA1aY9fugr
        1bRh8sOSLEyS0pfz2smYB02EgSi+jJ0=
Date:   Tue, 10 May 2022 20:10:14 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: clear_user (was: [patch 02/14] tmpfs: fix regressions from wider
 use of ZERO_PAGE)
Message-ID: <YnqqhmYv75p+xl73@zn.tnic>
References: <YmkdxaKdc2w/3I7o@zn.tnic>
 <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic>
 <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic>
 <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
 <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
 <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, May 10, 2022 at 10:28:28AM -0700, Linus Torvalds wrote:
> Well, that's pretty conclusive.

Yap. It appears I don't have a production-type Icelake so I probably
can't show the numbers there but at least I can check whether there's an
improvement too.

> I'm obviously very happy with fsrm. I've been pushing for that thing
> for probably over two decades by now,

The time sounds about right - I'm closing in on two decades poking at
the kernel myself and I've yet to see a more complex feature I've been
advocating for, materialize.

> because I absolutely detest uarch optimizations for memset/memcpy that
> can never be done well in software anyway (because it depends not just
> on cache organization, but on cache sizes and dynamic cache hit/miss
> behavior of the load).

Yeah, you want all that cacheline aggregation to happen underneath where
it can do all the checks etc.

> And one of the things I always wanted to do was to just have
> memcpy/memset entirely inlined.
> 
> In fact, if you go back to the 0.01 linux kernel sources, you'll see

LOL, I think I've seen those sources printed out on a wall somewhere.
:-)

> that they only compile with my bastardized version of gcc-1.40,
> because I made the compiler inline those things with 'rep movs/stos',
> and there was no other implementation of memcpy/memset at all.

Yeah, I have it on my todo to look at inlining the other primitives
too, and see whether that brings any improvements. Now our patching
infrastructure is nicely mature too so that we can be very creative
there.

> That was a bit optimistic at the time, but here we are, 30+ years
> later and it is finally looking possible, at least on some uarchs.

Yap, it takes "only" 30+ years. :-\

And when you think of all the crap stuff that got added in silicon
and *removed* *again* in the meantime... but I'm optimistic now that
Murphy's Law is not going to hold true anymore, we will finally start
optimizing hardware *and* software.

:-)))

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
