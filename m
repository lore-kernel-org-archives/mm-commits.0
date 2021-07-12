Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19D3C07E99
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jul 2021 19:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD2286120A
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jul 2021 19:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhGLTbj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jul 2021 15:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236324AbhGLTbj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jul 2021 15:31:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6100C0613DD
        for <mm-commits@vger.kernel.org>; Mon, 12 Jul 2021 12:28:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id j3so7858955plx.7
        for <mm-commits@vger.kernel.org>; Mon, 12 Jul 2021 12:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FmIDY8hHNnQKhNhQRKdfZdOGxTgagDg80VlsDRH7tUs=;
        b=Fb6ObhGVTV8Eve1qYpY5Vu/womcVxh50hdm2PVvzL0G53GAg0r0/ORdBXKo3ypo5BL
         qjoKVL/aqXOCi/Qn9Lr0rRSXIBUNYXzMfvxweSQM8xF1l/kXXCsNKjsV2yoPJKk2DGnc
         +Cl482KNkyW9h9NZVyduAwmkvsuGMzmHJeZVfkeHAIpdFg6r6FnpZB86/1KTHXv4SOcG
         k1VcTYuSWNe4r5LrsWcJ5K61NayLvOxN8PZLKMhGK4Nff5t3bflFaQZOTm5FVr3UXoYa
         EFYFsRHY3yZfNCxdVX6s+CzG1tzFSzlhwTZZtqHSj5D4bhYSsg06HuT+pJ4BZN3bz5Fg
         oMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FmIDY8hHNnQKhNhQRKdfZdOGxTgagDg80VlsDRH7tUs=;
        b=oyC6s2L7AqQwfKVM5lPLgyVQghM1y+sP5leL023B7WrCwg/TJEoD1hNuxeaba35Iox
         wmE7UnTvV7jZ+MD81QWmZobVmj7dQX9O/dBtVEfkfQ4NpC58AvHutG/z3x6HRNp/an9r
         ZQj018Mt7+d0s6/0orHiDqNUhcOC910EDR5qd8hfTZw/qa4xR5eTLw+xD7fdY0KhKF6f
         aFDHUlx6clSflkhppxFfzXGRczrjtOebiXvAWA6ucjjdcn77EgoAhwNXCqf2PdFvXmaM
         d9dH9eGgc9e8c2hc4Sv2Dr24qvnb5rYbcsN2ERhJUlLapIoRi4Jt7Sg1bmjjH/3ZQ6FA
         VhCQ==
X-Gm-Message-State: AOAM5323XimQaJtwwgZBEsd2A0dVXWJ/11aT89KRZM+FxmmUSkE7Ybsw
        ipM8/QTcxY9+Nh0dDlxWJHDR++3aYvBN5HTrlm4Z4g==
X-Google-Smtp-Source: ABdhPJzkK68Lknjw3XqbJtX1Oq85B/8BuENNuJWi+e2tfxeSpsSwyX3WNoKmjw+YNmj3D0rcQghvDtgc5S7vPcbf8cE=
X-Received: by 2002:a17:90a:9b03:: with SMTP id f3mr493877pjp.184.1626118130145;
 Mon, 12 Jul 2021 12:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701014819.Vm-gaPGHW%akpm@linux-foundation.org> <YOxWI2imZq5/e8VW@casper.infradead.org>
 <45b03dc4-a5ad-928b-313e-0f2ee8904a5a@oracle.com>
In-Reply-To: <45b03dc4-a5ad-928b-313e-0f2ee8904a5a@oracle.com>
From:   Mina Almasry <almasrymina@google.com>
Date:   Mon, 12 Jul 2021 12:28:36 -0700
Message-ID: <CAHS8izNTr+-tu6Z3O4U1d5cNm9fGub87-eaDPRDpUBuFy7F=WQ@mail.gmail.com>
Subject: Re: [patch 023/192] mm, hugetlb: fix racy resv_huge_pages underflow
 on UFFDIO_COPY
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        axelrasmussen@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Jul 12, 2021 at 9:58 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> On 7/12/21 7:48 AM, Matthew Wilcox wrote:
> > On Wed, Jun 30, 2021 at 06:48:19PM -0700, Andrew Morton wrote:
> >> From: Mina Almasry <almasrymina@google.com>
> >> Subject: mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY
> >>
> >> On UFFDIO_COPY, if we fail to copy the page contents while holding the
> >> hugetlb_fault_mutex, we will drop the mutex and return to the caller after
> >> allocating a page that consumed a reservation.  In this case there may be
> >> a fault that double consumes the reservation.  To handle this, we free the
> >> allocated page, fix the reservations, and allocate a temporary hugetlb
> >> page and return that to the caller.  When the caller does the copy outside
> >> of the lock, we again check the cache, and allocate a page consuming the
> >> reservation, and copy over the contents.
> >
> > But you only copy over the contents *IF* CONFIG_MIGRATION is enabled!
> > Now, maybe there aren't many configs out there that enable HUGETLBFS
> > and disable MIGRATION, but this is sloppy.
> >
>
> Thanks Matthew!
>
> Not copying the contents is also a security exposure.  We rely on copying
> the contents to clear the page's previous contents.
>
> I suggested using copy_huge_page here as a previous version of the patch
> replicated the code.  The NULL function slipped by me when reviewing.
> Perhaps it would be best to move those copy_huge_page routines to
> huge_memory.c as it is used by both THP and hugetlbfs.
>
> Mina, can you look into fixing this?

Gah, sorry, I missed that the function is a no-op if CONFIG_MIGRATION
is not set. I'll send a follow up fix to this. Thanks for catching!

> --
> Mike Kravetz
