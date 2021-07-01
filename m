Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCF5C11F64
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 18:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7146141E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 18:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhGASco (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jul 2021 14:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhGAScm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2021 14:32:42 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA19C061764
        for <mm-commits@vger.kernel.org>; Thu,  1 Jul 2021 11:30:10 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a15so13482226lfr.6
        for <mm-commits@vger.kernel.org>; Thu, 01 Jul 2021 11:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MgQKwoEBB404LDL6nzwNvU8qjp2O2EAi3/ZuC5D3Slc=;
        b=htlkR5jS8EpFN6R7dsROl/p62QsqU0Kw9OWK3at5uj4KFWBINwvZpQHlX8QGuDGC0P
         Kbz68HLDFX+4aEr5Hh0pGqWaPQeYDKx4/zuFqqL9I71Pv5XqjtchLwHmcd/xzcewl56A
         TOE+YJaFAiHOCPhfnLdry146N0NbnhI01qixs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MgQKwoEBB404LDL6nzwNvU8qjp2O2EAi3/ZuC5D3Slc=;
        b=Hu5z958PC7KE7wmxFtjRgDfHwMWuZPztSmS/l6zOEUZZ/0wLjAJoNG6XtykJJnpXTu
         m59jUoxECEYulaAA9JCWtuBCdn1R36PpXBLNndNTz7QIlgnTcnAW9EcH9accP1XSExfX
         3J6MPU+Qf1eI7EUllujjOYL/MMam9URhImTcOfipYINSX8hb4+JOTFZKIvwgx9F8PYT7
         H532JtMzfkUF509vhAg4TC5Num9WSjgXZew3OzZFXmRMOiArqZlwTvPGcaQ6zYA6k36V
         CUvCHc0RozM+TNHHlQGdWML3C4oYdo102lAoq7BM7MT9cjh7qQ/sAZYKyiYAfihYBX2v
         gqHQ==
X-Gm-Message-State: AOAM5338RT2ySSNq7XB/QjesY87rjUo4eVQqmhRFUGu5Ata6cUpn950I
        VlSo2UV/kuvAPwQRDzDyYDvc+6oZURFMHbZfutQ=
X-Google-Smtp-Source: ABdhPJx1lYufTQrpcYA8FoFU4vdJDffsVTrATR0esttK/BWegms1P6hsEE+xYtPK63cSyLmVZL8KMA==
X-Received: by 2002:ac2:5233:: with SMTP id i19mr680983lfl.575.1625164208938;
        Thu, 01 Jul 2021 11:30:08 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id w3sm98994ljo.36.2021.07.01.11.30.07
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 11:30:07 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id f30so13529724lfj.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Jul 2021 11:30:07 -0700 (PDT)
X-Received: by 2002:a05:6512:15a2:: with SMTP id bp34mr734975lfb.40.1625164206758;
 Thu, 01 Jul 2021 11:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210628193256.008961950a714730751c1423@linux-foundation.org>
 <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org> <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
 <YNu23Fu2HJhUEN5g@t490s> <YNvLUbrzkM+IOJlf@t490s> <CAHk-=wgt_666dOxYycGegSeUtLebUv0hVrcgXwXE9b-2_V=HXw@mail.gmail.com>
 <YNye5LNFaNFEPfhA@t490s> <CAHk-=wjzwwJgSOWhnGC52cmkKAiKFVPKYg3zNnsQbdTRPsMN2w@mail.gmail.com>
 <YN0Z8FwG25V29V96@t490s>
In-Reply-To: <YN0Z8FwG25V29V96@t490s>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 1 Jul 2021 11:29:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh1ga4=Q38Uz-SCQGVWv6ZTu0QjkXqR2ysLS0hbbkNvrg@mail.gmail.com>
Message-ID: <CAHk-=wh1ga4=Q38Uz-SCQGVWv6ZTu0QjkXqR2ysLS0hbbkNvrg@mail.gmail.com>
Subject: Re: [patch 128/192] mm: improve mprotect(R|W) efficiency on pages
 referenced once
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Kostya Kortchinsky <kostyak@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Peter Collingbourne <pcc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 6:27 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Jun 30, 2021 at 11:03:25AM -0700, Linus Torvalds wrote:
> >
> > What about that page_count() test, for example: it has a comment, it
> > looks obvious, but it's very different from what do_wp_page() does. So
> > what happens if we have a page-out at the same time that turns that
> > page into a swap cache page, and increments the page count? What about
> > that race? Do we end up with a writable page that is shared with a
> > swap cache entry? Is that ok? Why isn't it ok in the page fault case?
>
> That looks fine to me: when the race happens we must have checked page_count==1
> first and granted the write bit, then add_to_swap_cache() happens after the
> page_count==1 check (as it takes another refcount, so >2 otherwise).  Then it
> also means unmap mappings should happen even after that point.  If my above
> understanding is correct, our newly installed pte will be zapped safely soon,
> but of course after we release the pgtable lock in change_pte_range().

So if this is fine, then maybe we should just remove the page lock in
the do_wp_page() path (and remove the PageKSM check while at it)?

If it's not required by mprotect() to say "I can make the page
writable directly", then it really shouldn't be required by the page
fault path either.

Which I'd love to do, and was really itching to do (it's a nasty
lock), but I worried about it..

I'd hate to have mprotect do one thing, and page faulting do another
thing, and not have some logic to why they have to be different.

                  Linus
