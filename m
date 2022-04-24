Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1519FC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiDXU1o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239588AbiDXU1i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:27:38 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8012415047C
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:24:36 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t25so22936981lfg.7
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8D1tjludKMiFebgWWVz4ujQ9Db5s730fW/dMT08kpsM=;
        b=B/znUTigREnkE9FGYtanhZgKzwF1BCsrwTatdUOzXcIQBpKPen5PEkOrDwrtwBSsa2
         rxNc/brlHn+IPbLFpZls+5ZVaWqq3eLMyIZDJcMiJq1TM+4IFVA/HfkJWn6RNLs4JSqh
         55EXE/t9HSnVgz4ZWkJHKOQQE73gr0ZuMmKzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8D1tjludKMiFebgWWVz4ujQ9Db5s730fW/dMT08kpsM=;
        b=MHGpshothHuELeH+tm6Ibns5lq0Fj28p4twvNNKpMCWZrpFO63J/4YDeuuheQMfd5p
         QERkYpjvgzFgT5VqWub5/pCXceobrWl1BiHJ2AUoIYEe1acm9Y/T5py5YKlJEVtI/468
         65nLilLoIxs8llsxnSd2nITC7tUWerifYiwquIZXUTtg3w4HD597v0SwABnF4zkoKBPg
         B6A+vKXpNAXdSmboWJoNITeUDc4jNJ0vE9Jetbo9vVL83z/GO6vuYyXOGxMrweQwWEkd
         9FJSTBiFDeWgmVK4XIR+4tZiEQKOiCR+p7QkS842+iyMDiZOjfFJsGG8x4IbAlaSPKAQ
         mozg==
X-Gm-Message-State: AOAM533yHZO/HCqr6Tr0JwlcmsUAps5vg6TIF840bNw7oqMd6CaK53hF
        78H7++JHuTm0UxoBZuxKDYmCZNxCZkqLMQ3qw24=
X-Google-Smtp-Source: ABdhPJyytnlTPKQaJYfpyFp166TP8vv8CZllf6r/Dtg2+vP/EhzoWxpnMdJWsP4uLiH7SyS9/eMZfw==
X-Received: by 2002:a05:6512:2352:b0:471:f89d:4788 with SMTP id p18-20020a056512235200b00471f89d4788mr5495057lfu.402.1650831874518;
        Sun, 24 Apr 2022 13:24:34 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id i7-20020ac25d27000000b00450abeb4267sm1132744lfb.140.2022.04.24.13.24.31
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 13:24:32 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id x17so22937081lfa.10
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:24:31 -0700 (PDT)
X-Received: by 2002:a05:6512:1193:b0:471:af88:2d74 with SMTP id
 g19-20020a056512119300b00471af882d74mr10577735lfr.531.1650831871721; Sun, 24
 Apr 2022 13:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic> <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic> <YmFy8DEqvX4FlnuB@zn.tnic> <CAHk-=wgf2C9nFiC+3UFG4k7XVTQq5aV6fasSYuT_nQeo_Yew6A@mail.gmail.com>
 <CAHk-=wi69odFRCuYbhVFmaiaj4UcRDv74XeeksjFAdV0wBg2Ow@mail.gmail.com>
 <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
In-Reply-To: <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 24 Apr 2022 13:24:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiwbAUu3xs9c9-xxJrF1-OupynEEeXb+nzZ22wSz5M9Ug@mail.gmail.com>
Message-ID: <CAHk-=wiwbAUu3xs9c9-xxJrF1-OupynEEeXb+nzZ22wSz5M9Ug@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Apr 24, 2022 at 12:54 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And last time we discussed this, Al was looking at making it
> byte-exact, and I'm pretty sure he noted that other architectures
> already didn't do always do it.
>
> Let me go try to find it.

Hmnm. I may have mis-remembered the details. The thread I was thinking
of was this:

   https://lore.kernel.org/all/20200719031733.GI2786714@ZenIV.linux.org.uk/

and while Al was arguing for not enforcing the exact byte count, he
still suggested that it must make *some* progress. But note the whole

 "There are two problems with that.  First of all, the promise was
  bogus - there are architectures where it is simply not true.  E.g. ppc
  (or alpha, or sparc, or...)  can have copy_from_user() called with source
  one word prior to an unmapped page, fetch that word, fail to fetch the next
  one and bugger off without doing any stores"

ie it's simply never been the case in general, and Al mentions ppc,
alpha and sparc as examples of architectures where it has not been
true.

(arm and arm64, btw, does seem to have the "try harder" byte copy loop
at the end, like x86 does).

And that's when I argued that we should just accept that the byte
exact behavior simply has never been reality, and we shouldn't even
try to make it be reality.

NOTE! We almost certainly do want to have some limit of how much off
we can be, though. I do *not* think we can just unroll the loop a ton,
and say "hey, we're doing copies in chunks of 16 words, so now we're
off by up to 128 bytes".

I'd suggest making it clear that being "off" by a word is fine,
because that's the natural thing for any architecture that needs to do
a "load low/high word" followed by "store aligned word" due to not
handling unaligned faults well (eg the whole traditional RISC thing).

And yes, I think it's actually somewhat detrimental to our test
coverage that x86 does the byte-exact thing, because it means that
*if* we have any code that depends on it, it will just happen to work
on x86, but then fail on architectures that don't get nearly the same
test coverage.

              Linus
