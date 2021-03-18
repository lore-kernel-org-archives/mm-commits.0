Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7954AC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 07:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A3EC64F18
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 07:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbhCRH3e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Mar 2021 03:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhCRH3e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Mar 2021 03:29:34 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9705C06174A
        for <mm-commits@vger.kernel.org>; Thu, 18 Mar 2021 00:29:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gb6so2476141pjb.0
        for <mm-commits@vger.kernel.org>; Thu, 18 Mar 2021 00:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WLr0CF7jYnQXnHlANrx44KA9fdCAWZZGRrvYL2PJBDU=;
        b=vYTfFdYF19++rHVGFghqSG3AqpT0vmmTAe3/Y6vjOWHdvkKPBDth/IrequL5GulcTx
         wXs481iOan4EHTnTn4uMIbBmnbDJbyt226HJAn7WR9lNkW6qBfRYItzXPSyn2iKhNAFT
         rAoyB9L2hFJuxuaVEzawC1YioOtMdtsbqLgcyxXr9/B48SsK6Va8r3w2wMnnB/mFM3qd
         VJrhsUd7uOSsnoo0vhu7BqMGzgDq+Sewfbj5XD10sXWqIc2N0HIWArSsgKRxI9O+dZl6
         Cij+PRq8nfHzDLzd5UaZi/z9RRNMW8D5AfSti0y4K3jIh03f/rEfQYno83dJQxalKVie
         yoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WLr0CF7jYnQXnHlANrx44KA9fdCAWZZGRrvYL2PJBDU=;
        b=aP22Sk+R13gbcg91IFL5fgwUCNYV8mjsnY4TD08h4ctMYPkrmCGsfkrHpCP03kd9Q9
         1ic8vxbOjURETFV+GTRdfFJA4eNH0OWjpaCzfRASPBRHClMVTlTE/FpCR4pHtahC4vQf
         ESFEobapRL1bpD9fTtZoapfsihcPnZ56KDJf/zMn8tV9FYMOqvUX3LDuCOGazXfQfAMw
         G14cGHK+PZz1dFTYRAmRKgerRK3P8/cK8UWNh9topInwfTF0HmBB43H+UP/ryGGrNh9/
         umjV4fjWEbNRtxJWQ7cfD13Yj5taAQ4Io5ZtGSgmx6jwgDGSgdsa2Ll1pKZL/OFaemkk
         i8CA==
X-Gm-Message-State: AOAM530FIPHyM8l0WR7yfs/84iZYxMIorB/lftGlKNzNwxZmz3hUk9Bx
        xcjNwQoE9Zt9LBk67nCeY7sa5JNoqgnpOx5lNXOE8g==
X-Google-Smtp-Source: ABdhPJwiFRbH6LDZtQxaMyJ0JDxzvAozOI0XKs2+XzA6iooImvtS+JGW2ijS1Z3/DEriCQZSlBwqI/0ZnoAwMA/QODE=
X-Received: by 2002:a17:90a:f008:: with SMTP id bt8mr2951042pjb.13.1616052570899;
 Thu, 18 Mar 2021 00:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210315204819.8xAywsXO5%akpm@linux-foundation.org>
 <YFCHbGtshunwQxyc@dhcp22.suse.cz> <f9901048-4ee1-85af-82f4-e3c2c71309bc@oracle.com>
In-Reply-To: <f9901048-4ee1-85af-82f4-e3c2c71309bc@oracle.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Thu, 18 Mar 2021 15:28:54 +0800
Message-ID: <CAMZfGtX-NEnGQrhuFUiTVgC7vdEHRhZiC94KQZXDCz8stvw6QQ@mail.gmail.com>
Subject: Re: [External] Re: + mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
 added to -mm tree
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mina Almasry <almasrymina@google.com>,
        anshuman.khandual@arm.com,
        "Bodeddula, Balasubramaniam" <bodeddub@amazon.com>, bp@alien8.de,
        "Singh, Balbir" <bsingharora@gmail.com>,
        Chen Huang <chenhuang5@huawei.com>,
        Jonathan Corbet <corbet@lwn.net>, dave.hansen@linux.intel.com,
        David Hildenbrand <david@redhat.com>, hpa@zytor.com,
        Joao Martins <joao.m.martins@oracle.com>, jroedel@suse.de,
        Miaohe Lin <linmiaohe@huawei.com>, luto@kernel.org,
        mchehab+huawei@kernel.org, Ingo Molnar <mingo@redhat.com>,
        mm-commits@vger.kernel.org,
        =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>, oneukum@suse.com,
        Oscar Salvador <osalvador@suse.de>, paulmck@kernel.org,
        pawan.kumar.gupta@linux.intel.com,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>,
        "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Mar 17, 2021 at 12:55 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> On 3/16/21 3:24 AM, Michal Hocko wrote:
> > Andrew,
> > this patchset is still not ready for mmotm. Hugetlb freeing path needs a
> > major surgery because it can be called from atomic contexts and a simple
> > fix http://lkml.kernel.org/r/20210311021321.127500-1-mike.kravetz@oracle.com
> > has been nacked by Peter. Until this is handled properly this has to
> > wait and build on top.
> >
>
> Unfortunately, I tend to agree.
>
> Technically, this patchset does not add anything 'new' WRT challenges
> with the put_page path.  It will add a new condition where that path
> could sleep.  However, handling the possibility is an issue with the
> existing code.  What this patchset does add is additional complexity
> to the existing code paths.  It would be better to wait for modifications
> that take into account put_page/free_huge_page can be called from any
> context.
>
> I am working on such changes and it is a priority.  However, this is
> going to require quite a bit of code change.

Thanks Mike. Waiting for your good news, if there is anything I can
help, please let me know.

> --
> Mike Kravetz
