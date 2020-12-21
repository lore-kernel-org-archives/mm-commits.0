Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C82C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 21 Dec 2020 10:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA7422A85
	for <mm-commits@archiver.kernel.org>; Mon, 21 Dec 2020 10:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgLUKLH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Dec 2020 05:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgLUKLH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Dec 2020 05:11:07 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F958C0611C5
        for <mm-commits@vger.kernel.org>; Mon, 21 Dec 2020 02:10:22 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id h19so6190495qtq.13
        for <mm-commits@vger.kernel.org>; Mon, 21 Dec 2020 02:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0cbhRPuCt0/1sbC5MrA/bpQlkWQDIOUYF5sZHElvneU=;
        b=oiqEGTc/fBYiHoDY1YxtUn0epdLTfQ9K0hSHDs84bPxgn3/v8C8Opp3fWCzWLWTnKJ
         4NdkUMUG4YtaHDj63ElkmWmy7/mst/FlZ1xUGqFb815W/73MxOqKAopOe3RnxZ35R5Hf
         AeS2o7fWcZ7e0Mlz/cBL4oq5PzMlSQhcxObe9SqhUhdrwW7VPbhnq38v+Q4sUkItPnxY
         qQEyeuBziSjD9uFYXEIy0Qn94E5t0rWP0432vGBDaLz6+6Nr62uBGDDsM6O0zViJcfC2
         RQnawrjVqaRMJrQFfSrIxe6raVgAFWSlG2R/LTJeq/rxhSOdvkyannzTBjrUIon8NmTf
         CQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0cbhRPuCt0/1sbC5MrA/bpQlkWQDIOUYF5sZHElvneU=;
        b=r1d49M2DNcAvseJiv+hA/entGDYXAtzAFMtm57lnSJzDryBxNzJjS7aEGFfCmVj2wS
         L5h5JiGz72ncSWx6yrFEW5IwjpklVvBdlMBba5BSIUN2rc8jRZRQqxOPigLMbWtYzmFi
         gdw7xYgo1gWT2nUeQC13PnwWh13gZcIP2VaoLKoF/XdgNRrdRCoWfmXwwq9e/h09/4YM
         JThbL7A2TjZbaTN8D6wuUBGYNH/cplWvwt5+b/EvRIWwDzlwFfV7EAkwf4F/Iw//XsTJ
         Nc0/P485+NpZoi0EnXRF2qf4M+5u51zG1h8bZ8n5DVpQ801Me3UiyqksM0F1PbHu/x7k
         Pi7A==
X-Gm-Message-State: AOAM533dCw7mLNT9M9QJTb9BBQAMhXkDkjlb3vu2YK3IxdXOlgVUcU2U
        /HVDuOBg651KB7sMbMn6F3TrcnCNwnyEA8l4jzXxPxBEIJxdlVgb
X-Google-Smtp-Source: ABdhPJw/lSQmTshYM70tQVP24egHqi7meJRElMP56Q+foUzLSLkSsP46RArT/iuwNW8JzWSISmuWbBCFY3qSJWXq5UQ=
X-Received: by 2002:a05:620a:1372:: with SMTP id d18mr292475qkl.6.1608543977483;
 Mon, 21 Dec 2020 01:46:17 -0800 (PST)
MIME-Version: 1.0
References: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
 <20201218220233.pgX0nYYVt%akpm@linux-foundation.org> <X91JLZhrXYaLzoB8@elver.google.com>
 <20201218171327.180140338d183b41a962742d@linux-foundation.org> <CAHk-=whK70LHzMw5SxUu_1NHkWtZc-o1PHyotkmwR49e2Jh6rw@mail.gmail.com>
In-Reply-To: <CAHk-=whK70LHzMw5SxUu_1NHkWtZc-o1PHyotkmwR49e2Jh6rw@mail.gmail.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Mon, 21 Dec 2020 10:46:05 +0100
Message-ID: <CAG_fn=UuweEsetS8o-wwrke=9JQOxFvDvjRjG9Y8YG+5bLpfOA@mail.gmail.com>
Subject: Re: [patch 21/78] kasan: split out shadow.c from common.c
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Dec 19, 2020 at 8:17 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Dec 18, 2020 at 5:13 PM Andrew Morton <akpm@linux-foundation.org>=
 wrote:
> >
> > Sigh.  I don't have access to my capable-of-compiling-KASAN machine at
> > present :(  We'll need this, yes?
>
> Four of the patches in this patch-bomb mention the not-yet-existing
> kfence.h header. This plus two others have it in the actual patch. The
> fourth has it only as context.
>
> Two others mention kfence in some form or another.
>
> I think I'll drop all the kasan-related patches (and that's most of
> it), and basically only keep the memcg and epoll ones from this
> series.

@Andrew, were you planning to resend the KASAN series for 5.11? Do you
need help with that?

It would be a pity to punt that big chunk of MTE-related work the
folks did just because of the leftover KFENCE bits, we didn't mean to.

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
