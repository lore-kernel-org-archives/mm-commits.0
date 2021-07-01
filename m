Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF02C11F64
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 03:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 417726144D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 03:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhGADtT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 23:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhGADtT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jun 2021 23:49:19 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65155C061756
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 20:46:48 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i5so6307400eds.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 20:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQMzHfxy7j73eeBAznsJUCDuAy6t9VofCTaFX648xqA=;
        b=TfqMEHCarXH6/wt58F4195JwJqCI6EI44GHoRr9aNxZI/TKJP7i9XSJjdrPX/bvj4H
         RUFal4pHdwsCScLgWwosxUl/2T+Gbq5kFP7SJ7AcO+kEVK1UqsCYtjrYnvC65I8cikZ4
         yp8PKay777CVomTxeSZuYuFvtIyPVCbPt6SKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQMzHfxy7j73eeBAznsJUCDuAy6t9VofCTaFX648xqA=;
        b=TROt7qvNWSxz5yV3dv5SPH7Fh/M7sxnVtnNpPTq94klQ33s0b3pMjqkbnzWuu8QiEr
         4MKXtP5QUgREmQ6sgR7vTNLX3saSP9mf+duMwncnkL2DkltnW8HBFSpAeBrDk3KcDZ7F
         Ic4YKdguexCQvNOlSgHlEWBe30XaTStJ9L5ko7POtR9MFhHJLTXo6PP2O6iD/zB8mCxJ
         MZFjBHpCCPQ+O7eYtEIvxX3J+InvUMVVdwsl/ODi6B/lLJRqtCELgmpZkKYCtygI618c
         DyOr93tyWcqtp6tDXst1NWDijGUg62LLQD3VLWAE0GWFm1Kj+YN5Wjwm6l+9/67grvPt
         MYOg==
X-Gm-Message-State: AOAM532wzIHGDXq42v78OvGcxTEeDadnQKZlYxE8TlytAOl5ugjqW+iU
        1xqCpPUowPSO1TtK0hzhiaT0Z7aXBrj6sldUxQ4=
X-Google-Smtp-Source: ABdhPJy9FdNKsZCHvMRo7mRSgsk/qoY1wzM3ceQwtqcFUZUUcbJmylQk430ZsUli4MD4D8u+sxJmSQ==
X-Received: by 2002:a05:6402:706:: with SMTP id w6mr50377862edx.176.1625111206919;
        Wed, 30 Jun 2021 20:46:46 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id de33sm10257744ejc.38.2021.06.30.20.46.46
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 20:46:46 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id o5so7993641ejy.7
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 20:46:46 -0700 (PDT)
X-Received: by 2002:a05:6512:15a2:: with SMTP id bp34mr28560422lfb.40.1625111195625;
 Wed, 30 Jun 2021 20:46:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org> <20210701014713.b42x8Nm1B%akpm@linux-foundation.org>
In-Reply-To: <20210701014713.b42x8Nm1B%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Jun 2021 20:46:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjDoH4S56eeJBD3L0PptvmbaUrE9eFFxswTPxyO-nKNiw@mail.gmail.com>
Message-ID: <CAHk-=wjDoH4S56eeJBD3L0PptvmbaUrE9eFFxswTPxyO-nKNiw@mail.gmail.com>
Subject: Re: [patch 004/192] mm: hugetlb: free the vmemmap pages associated
 with each HugeTLB page
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Mina Almasry <almasrymina@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        bodeddub@amazon.com, Borislav Petkov <bp@alien8.de>,
        bsingharora@gmail.com, chenhuang5@huawei.com,
        Jonathan Corbet <corbet@lwn.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        duanxiongchun@bytedance.com, Peter Anvin <hpa@zytor.com>,
        joao.m.martins@oracle.com, Joerg Roedel <jroedel@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, oneukum@suse.com,
        Oscar Salvador <osalvador@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>,
        song.bao.hua@hisilicon.com, Muchun Song <songmuchun@bytedance.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 6:47 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Muchun Song <songmuchun@bytedance.com>
> Subject: mm: hugetlb: free the vmemmap pages associated with each HugeTLB page
>
> Every HugeTLB has more than one struct page structure.  We __know__ that
> we only use the first 4 (__NR_USED_SUBPAGE) struct page structures to
> store metadata associated with each HugeTLB.
>
> There are a lot of struct page structures associated with each HugeTLB
> page.  For tail pages, the value of compound_head is the same.  So we can
> reuse first page of tail page structures.   [..]

I think this means to say that we can reuse the _second_ page of the
tail page structures, since the first page is special and also
contains the first (non-tail) 'struct page'.

Or maybe the intent is to say that that second page is the "first page
of purely tail page structures"?

Anyway, this HugeTLB 'struct page' vmemmap patch-series doesn't look
_wrong_ to me, but it does look like it is a nightmare to debug if
something ever goes wrong. And it looks like a lot of things _could_
go wrong. It all looks very subtle.

Put another way: I'm not objecting to this series, but it does make me
nervous, and I just want to give a heads-up that if we start seeing
problems with this, I think people need to be ready to very
aggressively revert it unless the fixes are obvious.

How much testing has this series gotten on loads that are heavy users
of hugetlb?

                Linus
