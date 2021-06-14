Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E19C2B9F4
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 20:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DBD36120E
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 20:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhFNVAY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 17:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhFNVAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jun 2021 17:00:24 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C2FC061574
        for <mm-commits@vger.kernel.org>; Mon, 14 Jun 2021 13:58:21 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q7so41147417iob.4
        for <mm-commits@vger.kernel.org>; Mon, 14 Jun 2021 13:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUm2CpPDSzEmUpQDWXMSlAOsDAzycc/AnnfN9RmbJxU=;
        b=NPG3pUVgFpDZ7b9CUuBo5uYSU/I8WwNTPyoXbqhS1b4kig/l09M5fbK4nRinB81pOJ
         9N51kRy4EMIM/wfXEfsosqGOrGuLj70rsZ9+IkG+gG/CpN+OI0vZbxn8FbtTly3LDJVK
         Y2Yqf+ld8FPT1aAWQjEh/8ofUM5PZWshOw4GVfn8Dx8rB/QH0Lu551RF6W9mHc+PJ66V
         svWOZKRK13VYVxA3kTS4pwYWSGWPyTl5rgiC6qAaUSzn1QqNNSszPn9U027GolUH2i9f
         URkHk24VVpgfW2cGs+5df0b/CO27NJw6ujgGSW51MdnVqOpyup0jtDsifQvCjzpFM7AO
         TYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUm2CpPDSzEmUpQDWXMSlAOsDAzycc/AnnfN9RmbJxU=;
        b=nYda1KkO/jrH1KCUHWCrPZlTtpkfIeMT24cENLDD893l7+mINTr7Tr7Qu1jbGhbPo9
         7NJH92JK1D1uK1Ue+Dn3taViKC0fK0ET8q/kS05xGhIXNEaZUrGxEWohIIHluGDTY3A6
         AaXdpMj8ycNDyYTdszcu9cjO1+saYDWrTpvhfhfSYlVDwkjjz5TCDIdQqxCFJ9BNwhi2
         V13zX4CyBxXuZfLTsr/tunsQatoGA4Ka5j+O0OYK2FE5X75561KDi1kgJQctcLOKwRx2
         +F4YvYmCcLzI7Ig4Ps5R5x1eXCbipJLv5+fwXdNy1/3d4vmJGyt8MFiuFta82ougeoH0
         Tf/w==
X-Gm-Message-State: AOAM530MyRlquqFM0qbb2EDbxzKW0nbr77z3L6hON128OuQ7dVJ6XLVr
        lg197J6g237qDQB0fqA6wxc133jrWuOk/MjFJyKmEA==
X-Google-Smtp-Source: ABdhPJwmyY/fFuMwzHzC7qWuQGoLNZrWi9g/vZz/SfS2Vx52fvlP1jBu5rER4pHbfsv8tJy04DBbhzCi+zcx0nhRiOk=
X-Received: by 2002:a5d:9414:: with SMTP id v20mr16029182ion.66.1623704300408;
 Mon, 14 Jun 2021 13:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210601202257.eHEQRmS9t%akpm@linux-foundation.org>
In-Reply-To: <20210601202257.eHEQRmS9t%akpm@linux-foundation.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Mon, 14 Jun 2021 13:58:09 -0700
Message-ID: <CAMn1gO4QjCseNe9WR6iuBXnzdQ-CKv9qvcags8xs04LPbGizjA@mail.gmail.com>
Subject: Re: + mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Kostya Kortchinsky <kostyak@google.com>,
        mm-commits@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Hridya Valsaraju <hridya@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jun 1, 2021 at 1:23 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
> has been added to the -mm tree.  Its filename is
>      mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Peter Collingbourne <pcc@google.com>
> Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
>
> add comments, prohibit optimization for NUMA pages

Hi Andrew,

I was wondering why this was added as a separate patch instead of
being combined into the previous one. It seems like combining the
patches will be less likely to cause issues in the future (e.g.
someone cherry-picks the v4 patch but not the v4->v5 patch and ends up
breaking NUMA).

Peter
