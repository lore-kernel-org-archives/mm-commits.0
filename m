Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF27C11F64
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 18:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FFF56141F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 18:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhGAS2w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jul 2021 14:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhGAS2v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2021 14:28:51 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56D5C061762
        for <mm-commits@vger.kernel.org>; Thu,  1 Jul 2021 11:26:17 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id w19so13474582lfk.5
        for <mm-commits@vger.kernel.org>; Thu, 01 Jul 2021 11:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JBoBayL33cw9iKNS64XOIcWjPQDnw5eR3JSYkQC/+/Q=;
        b=EZkYlhCfYNOE4Hf9ipMoyOd2r439szD3t/ZJdiZFkrA6LDyKjK0ji0BN+fQa1nGC/T
         OqTaajiz/53/hUiZc+xUtTOxl34CMl5ql6/3RbSG5cvjeGjIrS3LJYo4JwaguJirhMty
         GBUBCJ6sDujgylrC8NycqTs/QjID+yzqg9hhI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JBoBayL33cw9iKNS64XOIcWjPQDnw5eR3JSYkQC/+/Q=;
        b=jbrWFDaCOd1NLXL0X5+xZzVW93eZL6kXxpOicIgtikDM4Ww+kAagOVhdx0pbciZhuh
         OzOb+VS7vmDwQj6hrMka6LE7Nay1O50c0web5PdhJkDfUd0EqEoD2NFKmhj60ol6Ex86
         CZmv9yI+x5y1JmfFxYJV8badu0esVN+JYH0zsvZNbZoq6Yz+j8jisUiBL0aHEU57/tf5
         dICwQ93L/YN/JtDw6MtfANSYsDruxAmpkZfv/hSfJrg5izIV1BSuF6z6PGaKgHQbPWmk
         0piSzZ+5KathGdx9dTAyLmCwRYnd0Yhb8IY1zoJY2e0AkTi05zkMxk84mashHD3sn1a9
         kkGQ==
X-Gm-Message-State: AOAM533lscOgJUbldPQOX603d12U7aITkk3GNNH/Ylljkvxfu0nRpI9K
        HjaL3C9/PVRG7r6CyHr3ZLGcrS3zCE2hBH/VmRI=
X-Google-Smtp-Source: ABdhPJwsCAve3FT4/9hAkhIknVpZucqyp5Yb4muF0vd4afieTL0uE8G5NSNBRc6XcvW865ByaASaZA==
X-Received: by 2002:a05:6512:228d:: with SMTP id f13mr711787lfu.229.1625163975997;
        Thu, 01 Jul 2021 11:26:15 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id a17sm40775lfs.59.2021.07.01.11.26.15
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 11:26:15 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id q16so13497590lfr.4
        for <mm-commits@vger.kernel.org>; Thu, 01 Jul 2021 11:26:15 -0700 (PDT)
X-Received: by 2002:a2e:9f11:: with SMTP id u17mr706019ljk.48.1625163964601;
 Thu, 01 Jul 2021 11:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701014713.b42x8Nm1B%akpm@linux-foundation.org> <CAHk-=wjDoH4S56eeJBD3L0PptvmbaUrE9eFFxswTPxyO-nKNiw@mail.gmail.com>
 <CAMZfGtWtJY=FauQBXU6RBCtTC0QZr72=HVH6+KAyWf7H3k3iCg@mail.gmail.com>
In-Reply-To: <CAMZfGtWtJY=FauQBXU6RBCtTC0QZr72=HVH6+KAyWf7H3k3iCg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 1 Jul 2021 11:25:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiGeDcUNJbZtDgha4pRT94P3At4y+S=vryte_GNtQhZ7w@mail.gmail.com>
Message-ID: <CAHk-=wiGeDcUNJbZtDgha4pRT94P3At4y+S=vryte_GNtQhZ7w@mail.gmail.com>
Subject: Re: [External] Re: [patch 004/192] mm: hugetlb: free the vmemmap
 pages associated with each HugeTLB page
To:     Muchun Song <songmuchun@bytedance.com>
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

On Wed, Jun 30, 2021 at 11:30 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> On Thu, Jul 1, 2021 at 11:46 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Anyway, this HugeTLB 'struct page' vmemmap patch-series doesn't look
> > _wrong_ to me, but it does look like it is a nightmare to debug if
> > something ever goes wrong. And it looks like a lot of things _could_
> > go wrong. It all looks very subtle.
>
> In order to make things work well, some addresses of vmemmap are
> also mapped with read only to catch invalid usage from other modules
> (e.g. write operation). I didn't get the point of "a lot of things _could_ go
> wrong". Would you like to describe the details? Thanks.

I just worry about the subtlety.

Things like "oh, now I can't free the page because I need allocations
for the mapping pages" is a very new condition for hugetlb pages.

And if the page table mapping ever gets out-of-sync, debugging it
sounds nightmarish. The real horror: missed TLB invalidates or things
like that, where even if the page tables themselves updated, the CPU
actually uses something else.

So I didn't see any bugs, but honestly, while I read through all the
patches that was really just that: "reading patches". I just want
people to be very ready to revert, because I suspect that any
potential bugs will just result in very subtle behavior problems.

                  Linus
