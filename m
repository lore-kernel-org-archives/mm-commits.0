Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599E6C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 19:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C7DC6056B
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 19:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhICTCU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 15:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbhICTCU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2021 15:02:20 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8022C061575
        for <mm-commits@vger.kernel.org>; Fri,  3 Sep 2021 12:01:19 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id i28so316092ljm.7
        for <mm-commits@vger.kernel.org>; Fri, 03 Sep 2021 12:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hpt968KhO5ktLt8YZKt9AMhba/VWw0L2qLvsN0Cw5fg=;
        b=SaHNhGpkehheSw6XhO8LZI4PTAvSrKZ3CEqIDKt6V2qAdoZV81tMwv/4VsBvkyNEPl
         rUU3bvS6GvgoKBxlXXFPz2lJEJVgcT4oWGuAQF9XtdaNIME+jJuu4hP1a7jmHC9p1Yqm
         JtkrvAdhcq3UFqWgynIoG6OgxZ5znHEQFeflM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hpt968KhO5ktLt8YZKt9AMhba/VWw0L2qLvsN0Cw5fg=;
        b=iTsnMLVJbNHrbv3RGLMwej2kjcdI6aFyqytfKQiI6Orr/L/o1XQV4/sGeAbEJ70xJ1
         MWSTR1MaiynIgZNaFV8TIeQZkA3ex7WqmKNQSDhiIQwJip/5IGlz1JZwyBBVzz/7QbTW
         6Wk3WnsCqMpnw/SBbZDfP+5tJWH64NbZ1t5yrwo9RxUNGv8nODXshq+JjF9f02b6nlye
         kaQNJ/lz0mYjAVhot/ljkwTNhakJV4mRcv+GZXiNKYyJF5Cy2lvxMx/8dzbpoHiaIyOo
         hFIii7mQncadqF2cAL+pF9ghXPSLWQmJ0sEM5ogy0FPRLQZrGc5T8UZDYtcLZBeN756V
         aorg==
X-Gm-Message-State: AOAM531KWVN6GFR2+nJ6rupN9C2RC9yBL6shKsYscVh0BvjMtfaHXFkx
        AMzcNuon0mm12EtcuOhMu1QpbKDig/rF3k45xyM=
X-Google-Smtp-Source: ABdhPJwV2h7AfnZbDdD7Un1TpyrP46z116H/Oj8u88+jdxibshBHZ7zuZq61ybL8zd1Pa1evuSMtQA==
X-Received: by 2002:a2e:3807:: with SMTP id f7mr369948lja.200.1630695677723;
        Fri, 03 Sep 2021 12:01:17 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id d19sm26793lfv.74.2021.09.03.12.01.16
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 12:01:17 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id k13so231314lfv.2
        for <mm-commits@vger.kernel.org>; Fri, 03 Sep 2021 12:01:16 -0700 (PDT)
X-Received: by 2002:a05:6512:3da5:: with SMTP id k37mr267698lfv.655.1630695676700;
 Fri, 03 Sep 2021 12:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
 <20210902215342.RcyFEb0qQ%akpm@linux-foundation.org> <CAHk-=wgQTRX=5SkCmS+zfmpqubGHGJvXX_HgnPG8JSpHKHBMeg@mail.gmail.com>
 <5327ba7e-fe70-ed72-b372-254d516fd8ea@nvidia.com>
In-Reply-To: <5327ba7e-fe70-ed72-b372-254d516fd8ea@nvidia.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 3 Sep 2021 12:01:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wge1uH1KNbGgfCJC=74PaT_x3M2Eqpgejkh4FmS1ENudg@mail.gmail.com>
Message-ID: <CAHk-=wge1uH1KNbGgfCJC=74PaT_x3M2Eqpgejkh4FmS1ENudg@mail.gmail.com>
Subject: Re: [patch 071/212] mm: gup: fix potential pgmap refcnt leak in __gup_device_huge()
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 3, 2021 at 10:55 AM John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 9/3/21 9:35 AM, Linus Torvalds wrote:
> >
> > Hmm. I think "ret" is unnecessary, and this could just have been
> >
> >          return addr == end;
> >
> > at the end to check that we did it all.
>
> Yes, definitely.
>
> So, to be extra clear even though this is tiny and trivial: this incremental
> change, on top of the current patch, looks good to me:

Ack.  I did the merge of Andrew's series as-is, to avoid even more
disruption (I already skipped two sub-series in there), but wouldn't
mind this simplification.

That said, it's not like it's a big deal, just me reacting to that
patch being larger than strictly needed. It's not like the extra "ret"
thing is confusing or wrong per se.

So I'll leave it to others if they want to pursue this.

                Linus
