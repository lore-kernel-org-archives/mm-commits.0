Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A5BC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 May 2022 21:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiEDVUj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 May 2022 17:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357423AbiEDVUh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2022 17:20:37 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C8B4A900
        for <mm-commits@vger.kernel.org>; Wed,  4 May 2022 14:17:00 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bu29so4503413lfb.0
        for <mm-commits@vger.kernel.org>; Wed, 04 May 2022 14:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BzzdOhDCt7eGrJ7xSteppF2rocbVTzQejsLnteplBXw=;
        b=G/uHV4KHjrOdCRN0Bt8mqA4pguX8W1qcHv0gGuAd97wP/QslpB2qDFxa7IfUIT5J3t
         mUbsems5znzgRkH9P2ZlZb46huiEXWv6fSYf2SgGQ0krbAOm/yiILUWx0tq9SyUOIvIX
         jZcvCaQ1+6pvBACBzKU8inDQoZxGLDjiJD0uI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BzzdOhDCt7eGrJ7xSteppF2rocbVTzQejsLnteplBXw=;
        b=Uwskmu31FqaLE8J6BlFl0pjFDZ7kWNSf7S7pOJQcbSqajRV8/DCvWqfhodh36CJAUg
         DdauA3xsgqY90P9cxHEEGwRnzW7L+Bwl1ubavTx3CtCV4ZPnh2d9dHji6xY2HPiaf/CE
         T7qX3OSyH2fTrSujOfu7miFmloBhIjLAZeiiaObjqc+VLwnd/vUM5u54GG2T8XGi38fr
         nWs45AD42C42ILNO6wUt9VrCwf0XCKgLuR9raWaGgiGJrIuQieEkUIptEHlIGdcExZ21
         ANUuRlCGq7bZvo3bDRDir71FcVpYIJP/fdphvFGLf/V1V4fWAWIl47jBMQe5tkcYDNW3
         G9JA==
X-Gm-Message-State: AOAM531RThW5ZhvercqBp9qgFj8RtVG0ys47eqOHSOgz1spVNk6reTTj
        yMqgzHDcI5FT6JwMehmplli3V9IGXQH++RGg8q0=
X-Google-Smtp-Source: ABdhPJwL/lx3519Yq6ydkjN6vCiZ8laiGYLr7liLGIYd1SxVdeUFCjRS0Zs2G8J1ZfuuYLRGLB+7jw==
X-Received: by 2002:a05:6512:3403:b0:448:5f92:7b0c with SMTP id i3-20020a056512340300b004485f927b0cmr14740437lfr.237.1651699018220;
        Wed, 04 May 2022 14:16:58 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id w24-20020ac24438000000b0047255d21189sm1300174lfl.184.2022.05.04.14.16.57
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 14:16:58 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id m23so3264317ljb.8
        for <mm-commits@vger.kernel.org>; Wed, 04 May 2022 14:16:57 -0700 (PDT)
X-Received: by 2002:a05:6512:b12:b0:44a:ba81:f874 with SMTP id
 w18-20020a0565120b1200b0044aba81f874mr15971597lfu.449.1651698608781; Wed, 04
 May 2022 14:10:08 -0700 (PDT)
MIME-Version: 1.0
References: <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
In-Reply-To: <YnLplKy0Y66SsvQw@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 May 2022 14:09:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
Message-ID: <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
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
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, May 4, 2022 at 2:01 PM Borislav Petkov <bp@alien8.de> wrote:
>
> I could try to do a perf probe or whatever fancy new thing we do now on
> clear_user to get some numbers of how many times it gets called during
> the benchmark run. Or do you wanna know the callers too?

One of the non-performance reasons I like inlined memcpy is actually
that when you do a regular 'perf record' run, the cost of the memcpy
gets associated with the call-site.

Which is universally what I want for those things. I used to love our
inlined spinlocks for the same reason back when we did them.

Yeah, yeah, you can do it with callchain magic, but then you get it
all - and I really consider memcpy/memset to be a special case.
Normally I want the "oh, that leaf function is expensive", but not for
memcpy and memset (and not for spinlocks, but we'll never go back to
the old trivial spinlocks)

I don't tend to particularly care about "how many times has this been
called" kind of trace profiles. It's the actual expense in CPU cycles
I tend to care about.

That said, I cared deeply about those kinds of CPU profiles when I was
working with Al on the RCU path lookup code and looking for where the
problem spots were.

That was years ago.

I haven't really done serious profiling work for a while (which is
just as well, because it's one of the things that went backwards when
I switch to the Zen 2 threadripper for my main machine)

                  Linus
