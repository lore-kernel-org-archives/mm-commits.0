Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69FDC11F67
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 02:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8D7B61D74
	for <mm-commits@archiver.kernel.org>; Wed, 30 Jun 2021 02:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhF3C2a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Jun 2021 22:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbhF3C23 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jun 2021 22:28:29 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ED6C061760
        for <mm-commits@vger.kernel.org>; Tue, 29 Jun 2021 19:26:01 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id q18so2104277lfc.7
        for <mm-commits@vger.kernel.org>; Tue, 29 Jun 2021 19:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WmcQjM4NtRj2hGLTZ2H2V0YhAbT4pllJIOpllS1okx4=;
        b=Na9tArEjazj6+sScSHtAWzPkvlasIO2Ly/mGFZ9h6CSZV5V7vDM1S5iz+4EtuhyjKB
         TkAQj813eo6NTNfMbDdVK8NME8Nm0t7X2gTNtbYjh6LpdB0oUAKRFlTSA3o8X3kvyKmJ
         5JmTgy0riT2rd7wQaAYlvZDNVzU2dd73+Ex1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WmcQjM4NtRj2hGLTZ2H2V0YhAbT4pllJIOpllS1okx4=;
        b=qQSupZu4rGbGtcL9xuux2zSvx2kFmGWy1gyKSqw09J37F8o3y0LOe/2hM/6mu87USS
         PglApYDEMF62w+/BSpMPK7AkcpzwXVGZVwGJwv8cLMjdl79jZ4gaZn1tabsbsowWpqo5
         CBiSJ8QcN4RwaTS8cZ8aVKGdx1W9nqNtWp+fiaEYWUILDzWuzAUCq4HzTArZYt+m8BxA
         ZaFn3YbLmtrlGo+jpTsWI9WbKo7sFNcgq7w5oAGUx6WZ9bl8uKawx+9FpzQx+0QNeN3G
         ZVGcJ0LgkaZKsg4sYRcuMeV6HR74DpOrAf8DtStHKMalXixcN+5gA2/W2mC4He59JblQ
         N9Ig==
X-Gm-Message-State: AOAM530ulXc5680M4dGURCdueDzzfr05mERiA0rm3PN+zzjqXQsVxIkb
        i7S1uNsaUVCesZAmMUYcRj6n1GgTVJs0aaGXO7g=
X-Google-Smtp-Source: ABdhPJwpcXgj3kBy+egszHMDBSDz4b7J+jMudDFRAQ0WBo2NaGeanJnx7SrE4E6GmZkh5Z7jG51D3A==
X-Received: by 2002:a19:8c55:: with SMTP id i21mr17401167lfj.409.1625019959681;
        Tue, 29 Jun 2021 19:25:59 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id r24sm126180lfi.157.2021.06.29.19.25.58
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 19:25:58 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id n14so2088944lfu.8
        for <mm-commits@vger.kernel.org>; Tue, 29 Jun 2021 19:25:58 -0700 (PDT)
X-Received: by 2002:a05:6512:557:: with SMTP id h23mr25719199lfl.253.1625019958291;
 Tue, 29 Jun 2021 19:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210628193256.008961950a714730751c1423@linux-foundation.org>
 <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org> <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
 <YNu23Fu2HJhUEN5g@t490s> <YNvLUbrzkM+IOJlf@t490s>
In-Reply-To: <YNvLUbrzkM+IOJlf@t490s>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 29 Jun 2021 19:25:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgt_666dOxYycGegSeUtLebUv0hVrcgXwXE9b-2_V=HXw@mail.gmail.com>
Message-ID: <CAHk-=wgt_666dOxYycGegSeUtLebUv0hVrcgXwXE9b-2_V=HXw@mail.gmail.com>
Subject: Re: [patch 128/192] mm: improve mprotect(R|W) efficiency on pages
 referenced once
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Evgeniy Stepanov <eugenis@google.com>, kostyak@google.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Peter Collingbourne <pcc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jun 29, 2021 at 6:39 PM Peter Xu <peterx@redhat.com> wrote:
>
> And since MM_CP_DIRTY_ACCT implies "VM_WRITE|VM_SHARED" all set, above should
> be a slightly faster version of below:

That's way too subtle, particularly since the MM_CP_DIRTY_ACCT logic
comes from another file entirely.

I don't think it's even faster, considering that presumably the
anonymous mapping case is the common one, and that's the one that
needs all the extra tests, it's likely better to _not_ test that very
subtle flag at all, and just doing the straightforward and obvious
tests that are understandable _locally_.

So I claim that it's

 (a) not an optimization at all

 (b) completely locally unintuitive and unreadable

> Again, I think in all cases some more comment should be good indeed..

I really want more than a comment. I want that MM_CP_DIRTY_ACCT bit
testing gone.

The only point where it makes sense to check MM_CP_DIRTY_ACCT is
within the context of "is the page already dirty".

So I think the logic should be something along the lines of

 - first:

         if (!(vma->vm_flags & VM_WRITE))
                return false;

   because that logic is set in stone, and true regardless of anything
else. If the vma isn't writable, we're not going to set the write bit.
End of story.

 - then, check the vma_is_anonumous() case:

        if (vma_is_anonymous(vma))
                return page_count(pte_page(pte)) == 1;

     because if it's a writable mapping, and anonymous, then we can
mark it writable if we're the exclusive owners of that page.

 - and THEN we can handle the "ok, shared mapping, now let's start
thinking about dirty accounting" cases.

Make it obvious and correct. This is not a sequence where you should
try to (incorrectly) optimize away individual instructions.

               Linus
