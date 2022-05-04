Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7598C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  4 May 2022 20:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbiEDUWU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 May 2022 16:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355432AbiEDUWQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2022 16:22:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886EC4DF79
        for <mm-commits@vger.kernel.org>; Wed,  4 May 2022 13:18:38 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E8A981EC01D2;
        Wed,  4 May 2022 22:18:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651695513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LN13oNhwoTos2vgLlc2a7BNkmpb9Etxv0QXEs8aAopY=;
        b=Vn4/rBSirtKSRfxuBE9+kKhlkGpeBvuXTjXXHYmgxkSBxQZiU/Ru97ETy5YS/aiZHdfcYA
        OjB72KJOB8l0FdU0ZrH7fFKXNxAJ29l4GqC2ul/MMzir1Uu6/NvLxXLwkFbPsJipeY4xIR
        kXvKkJyWng7QuAiinvhXJh6W/d3y0vs=
Date:   Wed, 4 May 2022 22:18:31 +0200
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
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-ID: <YnLfl6lupN2nq7+t@zn.tnic>
References: <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic>
 <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic>
 <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic>
 <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic>
 <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, May 04, 2022 at 12:22:34PM -0700, Linus Torvalds wrote:
> Side note: the "do FSRM inline" would likely be a really good thing
> for "copy_to_user()", more so than the silly "clear_user()" that we
> realistically do almost nowhere.

Right, that would be my next project.
> 
> I doubt you can find "clear_user()" outside of benchmarks (but hey,
> people do odd things).

Well, see preview below.

> But "copy_to_user()" is everywhere, and the I$ advantage of inlining
> it might be noticeable on some real loads.
> 
> I remember some git profiles having copy_to_user very high due to
> fstat(), for example - cp_new_stat64 and friends.
> 
> Of course, I haven't profiled git in ages, but I doubt that has

Yeah, see below.

> changed. Many of those kinds of loads are all about name lookup and
> stat (basic things like "make" would be that too, if it weren't for
> the fact that it spends a _lot_ of its time in user space string
> handling).
> 
> The inlining advantage would obviously only show up on CPUs that
> actually do FSRM. Which I think is currently only Ice Lake. I don't
> have access to one.

Zen3 has FSRM.

So below's the git test suite with clear_user on Zen3. It creates a lot
of processes so we get to clear_user a bunch and that's the inlined rep
movsb.

You can see some small but noticeable improvement:

gitsource
                                      rc              clear_use
                                     rc5             clear_user
Min       User         196.65 (   0.00%)      193.16 (   1.77%)
Min       System        57.20 (   0.00%)       55.89 (   2.29%)
Min       Elapsed      270.27 (   0.00%)      266.09 (   1.55%)
Min       CPU           93.00 (   0.00%)       93.00 (   0.00%)
Amean     User         197.05 (   0.00%)      194.14 *   1.48%*
Amean     System        57.41 (   0.00%)       56.35 *   1.83%*
Amean     Elapsed      270.97 (   0.00%)      266.90 *   1.50%*
Amean     CPU           93.00 (   0.00%)       93.00 (   0.00%)
Stddev    User           0.25 (   0.00%)        0.64 (-151.28%)
Stddev    System         0.24 (   0.00%)        0.31 ( -28.73%)
Stddev    Elapsed        0.56 (   0.00%)        0.62 ( -10.17%)
Stddev    CPU            0.00 (   0.00%)        0.00 (   0.00%)
CoeffVar  User           0.13 (   0.00%)        0.33 (-155.05%)
CoeffVar  System         0.41 (   0.00%)        0.54 ( -31.13%)
CoeffVar  Elapsed        0.21 (   0.00%)        0.23 ( -11.85%)
CoeffVar  CPU            0.00 (   0.00%)        0.00 (   0.00%)
Max       User         197.35 (   0.00%)      194.92 (   1.23%)
Max       System        57.75 (   0.00%)       56.64 (   1.92%)
Max       Elapsed      271.66 (   0.00%)      267.60 (   1.49%)
Max       CPU           93.00 (   0.00%)       93.00 (   0.00%)
BAmean-50 User         196.85 (   0.00%)      193.60 (   1.65%)
BAmean-50 System        57.20 (   0.00%)       56.05 (   2.01%)
BAmean-50 Elapsed      270.40 (   0.00%)      266.29 (   1.52%)
BAmean-50 CPU           93.00 (   0.00%)       93.00 (   0.00%)
BAmean-95 User         196.98 (   0.00%)      193.94 (   1.54%)
BAmean-95 System        57.32 (   0.00%)       56.28 (   1.81%)
BAmean-95 Elapsed      270.79 (   0.00%)      266.72 (   1.50%)
BAmean-95 CPU           93.00 (   0.00%)       93.00 (   0.00%)
BAmean-99 User         196.98 (   0.00%)      193.94 (   1.54%)
BAmean-99 System        57.32 (   0.00%)       56.28 (   1.81%)
BAmean-99 Elapsed      270.79 (   0.00%)      266.72 (   1.50%)
BAmean-99 CPU           93.00 (   0.00%)       93.00 (   0.00%)

                          rc   clear_use
                         rc5  clear_user
Duration User        1182.22     1165.67
Duration System       345.58      338.46
Duration Elapsed     1626.80     1602.99

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
