Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541E8C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 09:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbiEJJfa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 05:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbiEJJf3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 05:35:29 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A91928F1FA
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 02:31:30 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 30D2C1EC0606;
        Tue, 10 May 2022 11:31:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1652175085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zqHWw8+bN0CjYM1LFbOF/a1YqjiAXhwdtZ9bv89tejM=;
        b=IjYjMdHVWY8Lu//rAJt83cY2wkPUgmUjvn2LBEvnkPwYTgN8IWDOZlTcgPuuaXhZ6dl4tx
        8fubhtBhHO4Jw/YL5WTUIapE2OADzT4wDJ6ii/ZRY6J8U1lQ2Uv0qOlH9TwOJa1J0v3287
        ZoG0/sFu/wFNhPqomO64beN6k0lRvHY=
Date:   Tue, 10 May 2022 11:31:28 +0200
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
Subject: clear_user (was: [patch 02/14] tmpfs: fix regressions from wider use
 of ZERO_PAGE)
Message-ID: <Ynow8F3G8Kl6V3gu@zn.tnic>
References: <YmiK7Bos+zLAvL0t@zn.tnic>
 <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic>
 <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic>
 <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic>
 <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
 <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Lemme fix that subject so that I can find it easier in my avalanche mbox...

On Wed, May 04, 2022 at 02:09:52PM -0700, Linus Torvalds wrote:
> I don't tend to particularly care about "how many times has this been
> called" kind of trace profiles. It's the actual expense in CPU cycles
> I tend to care about.

Yeah, but, I wanted to measure how much perf improvement that would
bring with the git test suite and wanted to know how often clear_user()
is called in conjunction with it. Because the benchmarks I ran would
show very small improvements and a PF benchmark would even show weird
things like slowdowns with higher core counts.

So for a ~6m running test suite, the function gets called under 700K
times, all from padzero:

           <...>-2536    [006] .....   261.208801: padzero: to: 0x55b0663ed214, size: 3564, cycles: 21900
           <...>-2536    [006] .....   261.208819: padzero: to: 0x7f061adca078, size: 3976, cycles: 17160
           <...>-2537    [008] .....   261.211027: padzero: to: 0x5572d019e240, size: 3520, cycles: 23850
           <...>-2537    [008] .....   261.211049: padzero: to: 0x7f1288dc9078, size: 3976, cycles: 15900
	   ...

which is around 1%-ish of the total time and which is consistent with
the benchmark numbers.

So Mel gave me the idea to simply measure how fast the function becomes. I.e.:

                start = rdtsc_ordered();
                ret = __clear_user(to, n);
                end = rdtsc_ordered();

Computing the mean average of all the samples collected during the test
suite run then shows some improvement:

clear_user_original:
Amean: 9219.71 (Sum: 6340154910, samples: 687674)

fsrm:
Amean: 8030.63 (Sum: 5522277720, samples: 687652)

That's on Zen3.

I'll run this on Icelake now too.

> I haven't really done serious profiling work for a while (which is
> just as well, because it's one of the things that went backwards when
> I switch to the Zen 2 threadripper for my main machine)

Because of the not as advanced perf support there? Any pain points I can
forward?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
