Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65D9CCA480
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jun 2022 09:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiFWJl1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jun 2022 05:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiFWJl0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jun 2022 05:41:26 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525374990B
        for <mm-commits@vger.kernel.org>; Thu, 23 Jun 2022 02:41:25 -0700 (PDT)
Received: from zn.tnic (p200300ea974657a0329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9746:57a0:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C9C111EC0589;
        Thu, 23 Jun 2022 11:41:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1655977279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=VIoFRvK57TgQ4tR42ppqxWM0gMfHjrZSqZGHJr73vmc=;
        b=Opgn41K3YP80VbH+klityA4Nm0qg2EA1sq6cuG4aWvarBitCJ7ItOuFcvqmQ0epUkGsZqM
        aWh+AY1NyctP4FIpjN9vZPAJXJWxJRJf+70NWPjgwoEZOMON+MvrHkKPC2xkI83fE884Mg
        e1Rrd/pR+6ifDq2nNFZJ9WEc8CSrogc=
Date:   Thu, 23 Jun 2022 11:41:16 +0200
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
Message-ID: <YrQ1PPB77PBWyaHs@zn.tnic>
References: <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
 <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic>
 <Ynq1nVpu1xCpjnXm@zn.tnic>
 <YozQZMyQ0NDdD8cH@zn.tnic>
 <YrMlVBoDxB21l/kD@zn.tnic>
 <CAHk-=wgmOfipHDvshwooTV81hMh6FHieSvhgGVWZMX8w+E-2DQ@mail.gmail.com>
 <YrN4DdR9HN0srNWe@zn.tnic>
 <CAHk-=wj_MeMUnKyRDuQTiU1OmQ=gfZVZhcD=G7Uma=1gkKkzxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wj_MeMUnKyRDuQTiU1OmQ=gfZVZhcD=G7Uma=1gkKkzxg@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 22, 2022 at 04:07:19PM -0500, Linus Torvalds wrote:
> Might I suggest just using "count=XYZ" to make the sizes the same and
> the numbers a but more comparable? Because when I first looked at the
> numbers I was like "oh, the first one finished in 17s, the second one
> was three times slower!

Yah, I got confused too but then I looked at the rate...

But it looks like even this microbenchmark is hm, well, showing that
there's more than meets the eye. Look at at rates:

for i in $(seq 1 10); do dd if=/dev/zero of=/dev/null bs=1M status=progress count=65536; done 2>&1 | grep copied
32207011840 bytes (32 GB, 30 GiB) copied, 1 s, 32.2 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 1.93069 s, 35.6 GB/s
37597741056 bytes (38 GB, 35 GiB) copied, 1 s, 37.6 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 1.78017 s, 38.6 GB/s
62020124672 bytes (62 GB, 58 GiB) copied, 2 s, 31.0 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 2.13716 s, 32.2 GB/s
60010004480 bytes (60 GB, 56 GiB) copied, 1 s, 60.0 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 1.14129 s, 60.2 GB/s
53212086272 bytes (53 GB, 50 GiB) copied, 1 s, 53.2 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 1.28398 s, 53.5 GB/s
55698259968 bytes (56 GB, 52 GiB) copied, 1 s, 55.7 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 1.22507 s, 56.1 GB/s
55306092544 bytes (55 GB, 52 GiB) copied, 1 s, 55.3 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 1.23647 s, 55.6 GB/s
54387539968 bytes (54 GB, 51 GiB) copied, 1 s, 54.4 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 1.25693 s, 54.7 GB/s
50566529024 bytes (51 GB, 47 GiB) copied, 1 s, 50.6 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 1.35096 s, 50.9 GB/s
58308165632 bytes (58 GB, 54 GiB) copied, 1 s, 58.3 GB/s
68719476736 bytes (69 GB, 64 GiB) copied, 1.17394 s, 58.5 GB/s

Now the same thing with smaller buffers:

for i in $(seq 1 10); do dd if=/dev/zero of=/dev/null bs=1M status=progress count=8192; done 2>&1 | grep copied 
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.28485 s, 30.2 GB/s
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.276112 s, 31.1 GB/s
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.29136 s, 29.5 GB/s
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.283803 s, 30.3 GB/s
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.306503 s, 28.0 GB/s
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.349169 s, 24.6 GB/s
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.276912 s, 31.0 GB/s
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.265356 s, 32.4 GB/s
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.28464 s, 30.2 GB/s
8589934592 bytes (8.6 GB, 8.0 GiB) copied, 0.242998 s, 35.3 GB/s

So it is all magically alignment, microcode "activity" and other
planets-alignment things of the uarch.

It is not getting even close to 50GB/s with larger block sizes - 4M in
this case:

dd if=/dev/zero of=/dev/null bs=4M status=progress count=65536
249334595584 bytes (249 GB, 232 GiB) copied, 10 s, 24.9 GB/s
65536+0 records in
65536+0 records out
274877906944 bytes (275 GB, 256 GiB) copied, 10.9976 s, 25.0 GB/s

so it is all a bit: "yes, we can go faster, but <do all those
requirements first>" :-)

> But yes, apparently that "rep stos" is *much* better with that /dev/zero test.
> 
> That does imply that what it does is to avoid polluting some cache
> hierarchy, since your 'dd' test case doesn't actually ever *use* the
> end result of the zeroing.
> 
> So yeah, memset and memcpy are just fundamentally hard to benchmark,
> because what matters more than the cost of the op itself is often how
> the end result interacts with the code around it.

Yap, and this discarding of the end result is silly but well...

> For example, one of the things that I hope FSRM really does well is
> when small copies (or memsets) are then used immediately afterwards -
> does the just stored data by the microcode get nicely forwarded from
> the store buffers (like it would if it was a loop of stores) or does
> it mean that the store buffer is bypassed and subsequent loads will
> then hit the L1 cache?
> 
> That is *not* an issue in this situation, since any clear_user() won't
> be immediately loaded just a few instructions later, but it's
> traditionally an issue for the "small memset/memcpy" case, where the
> memset/memcpy destination is possibly accessed immediately afterwards
> (either to make further modifications, or to just be read).

Right.

> In a perfect world, you get all the memory forwarding logic kicking
> in, which can really shortcircuit things on an OoO core and take the
> memory pipeline out of the critical path, which then helps IPC.
> 
> And that's an area that legacy microcoded 'rep stosb' has not been
> good at. Whether FSRM is quite there yet, I don't know.

Right.

> (Somebody could test: do a 'store register to memory', then to a
> 'memcpy()' of that memory to another memory area, and then do a
> register load from that new area - at least in _theory_ a very
> aggressive microarchitecture could actually do that whole forwarding,
> and make the latency from the original memory store to the final
> memory load be zero cycles.

Ha, that would be an interesting exercise.

Hmm, but but, how would the hardware recognize it is the same data it
has in the cache at that new virtual address?

I presume it needs some smart tracking of cachelines. But smart tracking
costs so it needs to be something that happens a lot in all the insn
traces hw guys look at when thinking of new "shortcuts" to raise IPC. :)

> I know AMD was supposedly doing that for some of the simpler cases,

Yap, the simpler cases are probably easy to track and I guess that's
what the hw does properly and does the forwarding there while for the
more complex ones, it simply does the whole run-around at least to a
lower-level cache if not to mem.

> and it *does* actually matter for real world loads, because that
> memory indirection is often due to passing data in structures as
> function arguments. So it sounds stupid to store to memory and then
> immediately load it again, but it actually happens _all_the_time_ even
> for smart software).

Right.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
