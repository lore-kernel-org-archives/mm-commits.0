Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24068C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 10 Feb 2021 19:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC2C964E32
	for <mm-commits@archiver.kernel.org>; Wed, 10 Feb 2021 19:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbhBJTb1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhBJTb0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2021 14:31:26 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2E0C06174A
        for <mm-commits@vger.kernel.org>; Wed, 10 Feb 2021 11:30:46 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id q7so3168138iob.0
        for <mm-commits@vger.kernel.org>; Wed, 10 Feb 2021 11:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ihs70tYni0q7/xIxDpW6m5HxipULmRVeIQFvNpHvGCE=;
        b=XM5beyhbDXwypt4zqdjMG/7ssHjmo5iWp3JfWB07ZqVhNyzcodRqJkHVxc7ZYCqgh0
         PT4VnkwfCAbYhgVJXg5Mkhgo+j4Ix4JYOoWRO013Wb0LDiI22k6bv5AF9DSSTMrdpddV
         uaUTfa5oSjT3ybqDtRAYK2o3InnlfN5F0eQIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ihs70tYni0q7/xIxDpW6m5HxipULmRVeIQFvNpHvGCE=;
        b=foi81DaRla/AV9QaZ7e3UgnyQgtw1doh5ISfGziG38NQgaZykOugeZVIRAcfmuIvYg
         5GwpaCxoP94Cl4nNiCQi34k4qhn4tp1KTf0hMtph/jSjGcmiO9xctq95a2CyqD5OAhYw
         DgHzZ5IGPQAUCYkaJatmOB9aF3p38HNwGdaoW5fSdfHZuXt7bEXiGXXU6qbVGIfoHMGT
         eY1v4uM/Vk1uhT1sit0BAtsWxAKX7K2GhfXbPxaePwTpbzmSz4/FrfmPuaaTieuPRejh
         cgYA8542AjmvQqeQZZ5Q+wa5xYPf4cgJmbrUZvBuKPUrcQFkomY67/fc+DaKypYfb5Mi
         UvRg==
X-Gm-Message-State: AOAM531yZc4cG6ITPQ9166pnZWbVzidPSnmcGtQXdm8YFoOMqo8VbydD
        RvbCvI983j6yCK1Q/BzfdFOauWUg8mFikw==
X-Google-Smtp-Source: ABdhPJywUoeefGEOaO1c+KDzRrwGjbAhFRP8KlheZ50FhLrzXkW/oR63H3pZNjLVay2m3Fs3Hp8PNg==
X-Received: by 2002:a5e:9409:: with SMTP id q9mr2227824ioj.54.1612985445303;
        Wed, 10 Feb 2021 11:30:45 -0800 (PST)
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com. [209.85.166.54])
        by smtp.gmail.com with ESMTPSA id x3sm1338416iof.21.2021.02.10.11.30.44
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:30:44 -0800 (PST)
Received: by mail-io1-f54.google.com with SMTP id s24so3149221iob.6
        for <mm-commits@vger.kernel.org>; Wed, 10 Feb 2021 11:30:44 -0800 (PST)
X-Received: by 2002:a5d:9bc5:: with SMTP id d5mr2228118ion.119.1612985444751;
 Wed, 10 Feb 2021 11:30:44 -0800 (PST)
MIME-Version: 1.0
References: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Feb 2021 11:30:28 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiDX_HjNBLMU5eDc4Q4u83Sc=cQSCmto9mfch7afO4DRw@mail.gmail.com>
Message-ID: <CAHk-=wiDX_HjNBLMU5eDc4Q4u83Sc=cQSCmto9mfch7afO4DRw@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hah. This series shows a small deficiency in your scripting wrt the diffstat:

On Tue, Feb 9, 2021 at 1:41 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
>  .mailmap                          |    1
...
>  mm/slub.c                         |   18 +++++++++-
>  17 files changed, 172 insertions(+), 49 deletions(-)

It actually has 18 files changed, but one of them is a pure rename (no
change to the content), and apparently your diffstat tool can't handle
that case.

It *should* have ended with

 ...
 mm/slub.c                                          | 18 +++++-
 .../selftests/vm/{run_vmtests => run_vmtests.sh}   |  0
 18 files changed, 172 insertions(+), 49 deletions(-)
 rename tools/testing/selftests/vm/{run_vmtests => run_vmtests.sh} (100%)

if you'd done a proper "git diff -M --stat --summary" of the series.

[ Ok, by default git would actually have said

    18 files changed, 171 insertions(+), 48 deletions(-)

  but it looks like you use the patience diff option, which gives that
extra insertion/deletion line because it generates the diff a bit
differently ]

Not a big deal,, but it made me briefly wonder "why doesn't my
diffstat match yours".

           Linus
