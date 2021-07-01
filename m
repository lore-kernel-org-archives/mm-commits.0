Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90292C11F64
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 06:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6496461490
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 06:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhGAGc6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jul 2021 02:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbhGAGc5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2021 02:32:57 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641C8C061756
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 23:30:26 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id i6so5040425pfq.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Jun 2021 23:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9W9X3HIG1hLG89FN3kWd5L5z/Xg3t0ZHjfLbkdqXSCE=;
        b=HiV/q2QWUbaIEue8W8Ob54+nUgSOmZa+UyqjUI4kPSJOyqbSeg7tZecK37xw0rVZOy
         uzrbhmQM/YLeVLjkDRZHipYsIK4ziA69JrxtgfQqExLSj6fNOUSsC1S1PWU2RtvEqd4u
         Y1qFmRPcFBYjeeeAefhk7gPx58/ZwzLldEq9YCUT879lrL0be6kQDpFWREh6iYkUewGX
         ECUGrb9pt2EMqhTzjUyErSS0F1c1oGbu9fOaCNrcBkn3fLWu1EUbnMAkGKNRxYKqEBqM
         H3jzMkXZvOyLZb0Cfjq4RC4wujouAy3xSiFknzf05QETJQrLro3bahXhXv3fNtMs578M
         Wdlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9W9X3HIG1hLG89FN3kWd5L5z/Xg3t0ZHjfLbkdqXSCE=;
        b=k+i206Xr2i/K9+dqsOGVWtCU0hwIfwfZT7VudZ0cJ+LSj6fWA4bl5GE65bJo4ShrZE
         Rf9pj2urJXLjzDz3EsaE8UbIPQgkbBlrXa5cvjhi5ES93lPvMoAqgaElxXVDZ1G51Y9f
         6xtXLbYXHEGw8zP0W03zJT4ZsHAtQ8dyu6GpQIyZ7wOKD+Nqx3zz/wD3SaSJh/1kmaqP
         ozVjCOHlbuEUM+USlH7GoZRU2JAkMRg/dq6Go9JVS8sTrwgPZy8rB5RBhZ9S9UL/iqRQ
         Uq+1eq7p0IJgVo7hlRLtd1LMxdrvkPMJKOeb7SI0+xA7LGgKHEtXBuS+sgq3IzWTcj/p
         R2qw==
X-Gm-Message-State: AOAM533UYH9n94ozlCgcxsE6js+eHd7oLqIn39EAU+RHc/dsXCw6OxGH
        hzkAzAGcNrIvltdXqa15oIuBCQiCHDa4tYlZShOxSg==
X-Google-Smtp-Source: ABdhPJzufIsN02JcjtZj6dgp9pqiobVudUiY7NFG/sVPoB5yIo6mDPQZIufvw7rQyAo6xZZkOewHi+tpLKYxCjr3D3k=
X-Received: by 2002:a65:63ce:: with SMTP id n14mr37653457pgv.273.1625121025670;
 Wed, 30 Jun 2021 23:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701014713.b42x8Nm1B%akpm@linux-foundation.org> <CAHk-=wjDoH4S56eeJBD3L0PptvmbaUrE9eFFxswTPxyO-nKNiw@mail.gmail.com>
In-Reply-To: <CAHk-=wjDoH4S56eeJBD3L0PptvmbaUrE9eFFxswTPxyO-nKNiw@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Thu, 1 Jul 2021 14:29:46 +0800
Message-ID: <CAMZfGtWtJY=FauQBXU6RBCtTC0QZr72=HVH6+KAyWf7H3k3iCg@mail.gmail.com>
Subject: Re: [External] Re: [patch 004/192] mm: hugetlb: free the vmemmap
 pages associated with each HugeTLB page
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mina Almasry <almasrymina@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        "Bodeddula, Balasubramaniam" <bodeddub@amazon.com>,
        Borislav Petkov <bp@alien8.de>,
        "Singh, Balbir" <bsingharora@gmail.com>,
        Chen Huang <chenhuang5@huawei.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Xiongchun duan <duanxiongchun@bytedance.com>,
        Peter Anvin <hpa@zytor.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <jroedel@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>, oneukum@suse.com,
        Oscar Salvador <osalvador@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>,
        "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jul 1, 2021 at 11:46 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Jun 30, 2021 at 6:47 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > From: Muchun Song <songmuchun@bytedance.com>
> > Subject: mm: hugetlb: free the vmemmap pages associated with each HugeTLB page
> >
> > Every HugeTLB has more than one struct page structure.  We __know__ that
> > we only use the first 4 (__NR_USED_SUBPAGE) struct page structures to
> > store metadata associated with each HugeTLB.
> >
> > There are a lot of struct page structures associated with each HugeTLB
> > page.  For tail pages, the value of compound_head is the same.  So we can
> > reuse first page of tail page structures.   [..]
>
> I think this means to say that we can reuse the _second_ page of the
> tail page structures, since the first page is special and also
> contains the first (non-tail) 'struct page'.
>
> Or maybe the intent is to say that that second page is the "first page
> of purely tail page structures"?

Hi Linus,

Right. This is what I mean. Evey 2MB hugepage has 8 vmemmap
pages (32KB), the 2nd vmemmap page is reused here. The remapping
details can refer to the head of mm/hugetlb_vmemmap.c.

>
> Anyway, this HugeTLB 'struct page' vmemmap patch-series doesn't look
> _wrong_ to me, but it does look like it is a nightmare to debug if
> something ever goes wrong. And it looks like a lot of things _could_
> go wrong. It all looks very subtle.

In order to make things work well, some addresses of vmemmap are
also mapped with read only to catch invalid usage from other modules
(e.g. write operation). I didn't get the point of "a lot of things _could_ go
wrong". Would you like to describe the details? Thanks.

>
> Put another way: I'm not objecting to this series, but it does make me
> nervous, and I just want to give a heads-up that if we start seeing
> problems with this, I think people need to be ready to very
> aggressively revert it unless the fixes are obvious.
>
> How much testing has this series gotten on loads that are heavy users
> of hugetlb?

This series was tested by Huawei, AWS and Bytedance. In our company,
this feature was proposed in 2020.03, we have tested several months on our
servers (we have a lot of virtual machines). We didn't find any issues.

Thanks.

>
>                 Linus
