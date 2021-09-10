Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AE6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 12:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 664A2611BF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhIJMBY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 08:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232613AbhIJMBY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Sep 2021 08:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B11A1610E9;
        Fri, 10 Sep 2021 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631275213;
        bh=tRwIMvcqHBtl6NN8nVb5EPlc3v7U/VgT8RGPiEAz7WI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CUnOlhdGFn45GDr5Z6t2czKozUb/+Y7u021g5sBBRnvMgpbfhfFes68G1dMEAfSdV
         UEKBNmLSJg2DXmnKCP+hG1txpqHw7zRFOUjgeJ42jsoL8V4kVxFlAgoWgIwhmIdCUu
         hDB/fGPMn99x9H00RK1aNOqOjWcY2z+ui+fuk+B8I7lT5D2SFwe5unD7w8IwC2Tzrb
         eL5XJM5TrgfelBfIDxqfhlQzQhtSW3epgYYCiYxMVJEp77VJ6a1GIqgj5CSx3fdC7G
         6tEWepPpijlR5L4DBIICsVHU3XAwBCqNk1+WiYXnbnvk/tutVXxBeB3tbadQsB//1f
         gyVni3bPTYiSA==
Date:   Fri, 10 Sep 2021 15:00:05 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, adobriyan@gmail.com,
        chenying.kernel@bytedance.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: Re: [patch 079/147] fs/proc/kcore.c: add mmap interface
Message-ID: <YTtIxZA3Arv6G93V@kernel.org>
References: <20210908025730.S88ylmikU%akpm@linux-foundation.org>
 <303e9a27-7495-1c94-64a1-a1149a39f0a9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <303e9a27-7495-1c94-64a1-a1149a39f0a9@redhat.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 10, 2021 at 12:08:17PM +0200, David Hildenbrand wrote:
> On 08.09.21 04:57, Andrew Morton wrote:
> > +
> > +	if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> > +		ret = -EPERM;
> > +		goto out;
> > +	}
> > +
> > +	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
> > +	vma->vm_flags |= VM_MIXEDMAP;
> > +	vma->vm_ops = &kcore_mmap_ops;
> > +
> 
> This breaks all my efforts to sanitize /proc/kore access for virtio-mem.
> 
> Is there still a way to nack this?

Already done:

https://lore.kernel.org/mm-commits/CAHk-=wgQ+8kmczLLKCY7yDsGHQBRcZESKd1dNaKbrjUgbWeb3A@mail.gmail.com

and down the same thread.
 
> Sorry I didn't spot this any sooner.
> 
> -- 
> Thanks,
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.
