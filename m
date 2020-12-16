Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60924C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 05:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE65222B3
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 05:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgLPFI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 00:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPFI7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2020 00:08:59 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BB7C0613D6
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 21:08:18 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id s26so10536338lfc.8
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 21:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UtbTWDw3nZjjyyJTRDk36inq0066cYLaapH2TBnkVb0=;
        b=j8RQ4cYdgHxhTz/3wUEVINsDeCfi6oNlwLF3p6J4aNGJla7LBEBre5oxHG7dw/NVn8
         AEB25yZMxiqda1sIBdd62/0uP7Ls3k55iLKI9fI7/J6Fl2wD1rcpDp9R3rzu6P5jLnVX
         wHerjArtXSPhu8i8RP7N1OjUpK/rV4CXzeiTLQBvKbQ7ZJ57u4Odi4qXZcVrswi0Dfe1
         B9cpPSrlJ/kuHJt4e4r1l3/aqDH/qP9QaXQ1fpX0jupRFY0JQbBMwc4KZMLkz4i5IHZ8
         BddwsTkmDGcuUKfKgwrPuNsLjmmZfTJGeiYyLabVl9s26aEaX4E/gNLL81dXHec91IRJ
         vG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UtbTWDw3nZjjyyJTRDk36inq0066cYLaapH2TBnkVb0=;
        b=IpzI+adOyfBh9fk0HQGIIIx8P1FoDYqKaf+7VIlsFFy5cpwLew9dHB3Eqv/0tq/Ske
         9Jx+d6dNINW76P/WaLn2wATAn4RHO94dEjQF5iBFpvHnZk13zd/iEP6tWyVVAdL9qf5r
         TyJndi5MxUHLMaIWvoBG9WYmknndEIX6SHMuKqCI2oBT76R5MgxRUU+JOQ74SrZ4w+1w
         CY52W6gqN9asTV8yj+PeEe6dqYESAAxN9ZtCCz6HQ/IOqYFkOMpv45ws0i8SEhMeLJSo
         wtfVS/8bI7+zI2ztag69vayvMgW4/ACFlb/JnxCJm1RHHfPvSU2OcE4B/NsjU9rMPuJC
         teRQ==
X-Gm-Message-State: AOAM533GxcZiOiGnDUV1tUq10RgXOpyQeNIwMP3DSfpKVAgldb8/mT9J
        2sm8myEe4YL069ujTQK33YNG6Ww9F/hA3laXOKTZoA==
X-Google-Smtp-Source: ABdhPJxttOxq5Y3VEkNn1VyGiMHsTgqJvQPxyQAszztVFNiDcu4yvdn9y0eNV0Gk7IxlU3Hm+dUbnLnhx0J+jxarH1A=
X-Received: by 2002:a05:6512:328b:: with SMTP id p11mr11798945lfe.356.1608095294990;
 Tue, 15 Dec 2020 21:08:14 -0800 (PST)
MIME-Version: 1.0
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org> <20201216044730.ADFV7TjN3%akpm@linux-foundation.org>
In-Reply-To: <20201216044730.ADFV7TjN3%akpm@linux-foundation.org>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 16 Dec 2020 06:07:48 +0100
Message-ID: <CAG48ez2bZvS9dHr+3U65KY+Mpcy_Az_x10x9GHdfqWM=rrF-Yw@mail.gmail.com>
Subject: Re: [patch 94/95] mmap locking API: don't check locking if the mm
 isn't live yet
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linux-MM <linux-mm@kvack.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        mm-commits@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Dec 16, 2020 at 5:47 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> In preparation for adding a mmap_assert_locked() check in
> __get_user_pages(), teach the mmap_assert_*locked() helpers that it's fine
> to operate on an mm without locking in the middle of execve() as long as
> it hasn't been installed on a process yet.
>
> Existing code paths that do this are (reverse callgraph):
>
>   get_user_pages_remote
>     get_arg_page
>       copy_strings
>       copy_string_kernel
>       remove_arg_zero
>     tomoyo_dump_page
>       tomoyo_print_bprm
>       tomoyo_scan_bprm
>       tomoyo_environ

Sorry, can you please kill both this patch and the following one
("mm/gup: assert that the mmap lock is held in __get_user_pages()")
from the mm tree?

I'll send new stuff (a new iteration of
https://lore.kernel.org/linux-mm/20201016225713.1971256-1-jannh@google.com/
"[PATCH resend v3 0/2] Broad write-locking of nascent mm in execve",
followed by a resend of "mm/gup: assert that the mmap lock is held in
__get_user_pages()") when it's ready.

As I noted in the cover letter of that thing, which was meant to
replace this patch (but isn't ready yet - yeah, I should get back to
that...), this approach doesn't really work because bprm->vma is used
after the switch to the new mm.

Sorry about the mess... :/

I guess the next time this happens, I should just immediately email
you requesting that the queued-up patches should be dropped once an
issue is identified...
