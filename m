Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98080C43334
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 20:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiFVUOV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFVUOQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2022 16:14:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236A413E9A
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 13:14:15 -0700 (PDT)
Received: from zn.tnic (p200300ea974657a0329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9746:57a0:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 88B1E1EC04FB;
        Wed, 22 Jun 2022 22:14:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1655928849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rFuSHJzwwt4PLrDbB1K3TByKrUIZ7mUmXXNvdkifRus=;
        b=aePInROFcL1WALSd+y/WzuOnSE7mkUfk6qnf7w7jbHED4l3NMFWUJDVoxgUjtkmLTYWpLx
        YWHy8fOeV09NbyJ48Do/6xEzFODl6/KXDfAda+yx5fenzWxn/BznroJ60lGNyTYiKEGlUw
        NtTZYq7+BrIIg/utaEf/nGQyk9BAz7A=
Date:   Wed, 22 Jun 2022 22:14:05 +0200
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
Subject: Re: [PATCH] x86/clear_user: Make it faster
Message-ID: <YrN4DdR9HN0srNWe@zn.tnic>
References: <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
 <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
 <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic>
 <Ynq1nVpu1xCpjnXm@zn.tnic>
 <YozQZMyQ0NDdD8cH@zn.tnic>
 <YrMlVBoDxB21l/kD@zn.tnic>
 <CAHk-=wgmOfipHDvshwooTV81hMh6FHieSvhgGVWZMX8w+E-2DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgmOfipHDvshwooTV81hMh6FHieSvhgGVWZMX8w+E-2DQ@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 22, 2022 at 10:06:42AM -0500, Linus Torvalds wrote:
> I'm not sure how valid the TSC thing is, with the extra
> synchronization maybe interacting with the whole microcode engine
> startup/stop thing.

Very possible.

So I went and did the original microbenchmark which started people
looking into this in the first place and with it, it looks very
good:

before:

$ dd if=/dev/zero of=/dev/null bs=1024k status=progress
400823418880 bytes (401 GB, 373 GiB) copied, 17 s, 23.6 GB/s

after:

$ dd if=/dev/zero of=/dev/null bs=1024k status=progress
2696274771968 bytes (2.7 TB, 2.5 TiB) copied, 50 s, 53.9 GB/s

So that's very persuasive in my book.

> I'm also not sure the rdtsc is doing the same thing on your AMD tests
> vs your Intel tests - I suspect you end up both using 'rdtscp' (as

That is correct.

> opposed to the 'lsync' variant we also have), but I don't think the
> ordering really is all that well defined architecturally, so AMD may
> have very different serialization rules than Intel does.
>
> .. and that serialization may well be different wrt normal load/stores
> and microcode.

Well, if it is that, hw people have always been telling me to use RDTSC
to measure stuff but I will object next time.

> So those numbers look like they have a 3% difference, but I'm not 100%
> convinced it might not be due to measuring artifacts. The fact that it
> worked well for you on your AMD platform doesn't necessarily mean that
> it has to work on icelake-x.

Well, it certainly is something uarch-specific because that machine
had an eval Icelake sample before and it would show the same minute
slowdown too. I attributed it to the CPU being an eval sample but I
guess uarch-wise it didn't matter.

> But it could equally easily be that "rep stosb" really just isn't any
> better on that platform, and the numbers are just giving the plain
> reality.

Right.

> Or it could mean that it makes some cache access decision ("this is
> big enough that let's not pollute L1 caches, do stores directly to
> L2") that might be better for actual performance afterwards, but that
> makes that clearing itself that bit slower.

There's that too.

> IOW, I do think that microbenchmarks are kind of suspect to begin
> with, and the rdtsc thing in particular may work better on some
> microarchitectures than it does others.
> 
> Very hard to make a judgment call - I think the only thing that really
> ends up mattering is the macro-benchmarks, but I think when you tried
> that it was way too noisy to actually show any real signal.

Yap, that was the reason why I went down to the microbenchmarks. But
even with the real benchmark, it would show a slightly bad numbers on
ICL which got me scratching my head as to why that is...

> That is, of course, a problem with memcpy and memset in general. It's
> easy to do microbenchmarks for them, it's not just clear whether said
> microbenchmarks give numbers that are actually meaningful, exactly
> because of things like cache replacement policy etc.
> 
> And finally, I will repeat that this particular code probably just
> isn't that important. The memory clearing for page allocation and
> regular memcpy is where most of the real time is spent, so I don't
> think that you should necessarily worry too much about this special
> case.

Yeah, I started poking at this because people would come with patches or
complain about stuff being slow but then no one would actually sit down
and do the measurements...

Oh well, anyway, I still think we should take that because that dd thing
above is pretty good-lookin' even on ICL. And we now have a good example
of how all this patching thing should work - have the insns patched
in and only replace with calls to other variants on the minority of
machines.

And the ICL slowdown is small enough and kinda hard to measure...

Thoughts?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
