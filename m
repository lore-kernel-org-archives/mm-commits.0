Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5653C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 19:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6257C2240A
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 19:34:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="D7fTRsyp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgKTTeN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 14:34:13 -0500
Received: from m12-16.163.com ([220.181.12.16]:36016 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbgKTTeN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 14:34:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=OCXdv
        bpLcHPqsyPAvHs2fAO+t2cUHARppytDiUNGqUs=; b=D7fTRsypZ5YlDOfASrJQA
        D+WmO6bKjNsNIfq3M1HO2ThNNCQt+BdXXOMm0f9JgRI43b1T4h4Ld5xdPuecUPti
        kG326WHvvDE3bASZ8HHIN6t8ejbayVpKDsgzx+odw19xA9/cc91qehauiGU+l9IM
        icFNHlB/5pQSz5fwHsvW2U=
Received: from localhost (unknown [101.86.213.141])
        by smtp12 (Coremail) with SMTP id EMCowAAHWzreGbhfZQJnNA--.32030S2;
        Sat, 21 Nov 2020 03:32:47 +0800 (CST)
Date:   Sat, 21 Nov 2020 03:32:46 +0800
From:   Hui Su <sh_def@163.com>
To:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     hughd@google.com, mm-commits@vger.kernel.org, sh_def@163.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: + mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
 added to -mm tree
Message-ID: <20201120193246.GA19677@rlk>
References: <20201116230526.NkEfmeDCH%akpm@linux-foundation.org>
 <alpine.LSU.2.11.2011162149210.1082@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2011162149210.1082@eggly.anvils>
X-CM-TRANSID: EMCowAAHWzreGbhfZQJnNA--.32030S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw4fWF1fAr4rKry3Zr1kKrg_yoW5ArW5pF
        WfG3Zayws8JryxKryxtw4kWry093yfKFWUta45Xr18Z3Z8Z3WkKr4vyr1rZryUCFy5WFy2
        vF4DGr48uF4UAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zinjjkUUUUU=
X-Originating-IP: [101.86.213.141]
X-CM-SenderInfo: xvkbvvri6rljoofrz/1tbifx-iX1r6mslkqAAAsi
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Nov 16, 2020 at 10:17:20PM -0800, Hugh Dickins wrote:
> On Mon, 16 Nov 2020, akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      Subject: mm/shmem: use kmem_cache_zalloc in shmem_alloc_inode()
> > has been added to the -mm tree.  Its filename is
> >      mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
> > 
> > This patch should soon appear at
> >     https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
> > and later at
> >     https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> > 
> > ------------------------------------------------------
> > From: Hui Su <sh_def@163.com>
> > Subject: mm/shmem: use kmem_cache_zalloc in shmem_alloc_inode()
> 
> Andrew, Stephen, please revert this untested "cleanup" from your
> trees a.s.a.p: it's a disaster for anyone using shmem/tmpfs.
> 
> > 
> > in shmem_get_inode():
> > new_inode();
> >   new_inode_pseudo();
> >     alloc_inode();
> >       ops->alloc_inode(); -> shmem_alloc_inode()
> >         kmem_cache_alloc();
> > 
> > memset(info, 0, (char *)inode - (char *)info);
> > 
> > So use kmem_cache_zalloc() in shmem_alloc_inode(),
> > and remove the memset in shmem_get_inode().
> 
> I could not follow that argument at all.  The shmem_inode_cachep
> uses a constructor, and the memset shown is of only a portion of
> the whole inode.  zeroing the entire inode quickly crashes the
> kernel, after showing errors.
> 
> (If you're lucky enough to have a readable display at that point:
> I did not, but got on better with framebuffer than drm/i915; and
> I wonder if there's a separate bug in that area too, because fixing
> this shmem issue is not enough to get my drm/i915 rc4-mm1 booting.)
> 

Sorry, I thought it was a small change before, so I forgot to test it.
It's SO STUPID. I'm really sorry.

> > 
> > Link: https://lkml.kernel.org/r/20201115174026.GA365412@rlk
> > Signed-off-by: Hui Su <sh_def@163.com>
> 
> NAK.  Hui Su, please test your "cleanups" before sending them.
> 

I will remember it, thanks.

I have spent two evenings building a patch automated test platform
using qemu and jenkins.

> I'm sorry for being slow to respond, but the priority appeared
> to be to get Matthew Wilcox's series running reliably, so I had not
> got around to checking the less urgent shmem patches before they
> slipped into mmotm - there may well be more that I want to NAK,
> but this is the dangerous one.
> 
> Thanks,
> Hugh
> 

