Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64F9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 15:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A2B060EB4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 15:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346990AbhIXPLm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 11:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346962AbhIXPLl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Sep 2021 11:11:41 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EFCC061571
        for <mm-commits@vger.kernel.org>; Fri, 24 Sep 2021 08:10:07 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id g41so41540600lfv.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Sep 2021 08:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=co3PmFuKCIcHsj3pvj/B4T/OiVu8R01Eai9WLfmdlq8=;
        b=Bjrt0Rq7VPXOT3ycfENAR6ahmO3q368hhy2blwQAfkW0DIZ0c1pMsNlD5CtQitFJTx
         qH/NIP2KVRQW/48QpCjbwvdM2YGK5V44JFKsFMNOQYzI8lvqjfYmbaYASvSGl5nUmPKl
         gpWZXzPySuvTqio2vIERL174Lw61V3+jQaSsZp+2RSo8wixDGuZwkyd1Z1yYYf+DX/KA
         yieEqFqnNF9lzDF2iQXD0OqSPVwsQypESDyxq8xhrkCWNNgCfVfzoTHvx+8pe7uPAyYi
         +6kOP/AcGFryIPrl2D4MLYQ12sU1uO8ZInb9cYQqK0RZ88ePIrjJQTnFxxn1Cn5bfl1f
         9QIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=co3PmFuKCIcHsj3pvj/B4T/OiVu8R01Eai9WLfmdlq8=;
        b=UJMTbEy2aKD4MFoFFiaFWbizZ+AfzVi3Xx2xCJpb7YD0/umrcyiDscgllrGrWbHz0F
         7z/CIO+NMaJZ0aKpzO0Liv84DKFvUYgvyrIbz7sm+h/LlpU6chuaCBMQJUuV+NyzaiwM
         KoHFTDTf4KQTCk3wdacFPl2ovSWjNM2A/jlbDZQVIAd7fY9hRJVJpzNEXZfw8onIXmb9
         YN8Z0LOEiOWWYcCfPhgeQXrGSEkJSF64RHyzP5ODhzfqsGz8jcSQDcUNFn8hoW9dbFGf
         yI3V4Fyh6c0iUTAzVwxP4AUkvCor/YMRraqdZI5XqQdphkg5jb8v3aWB3lHiGH+EjOmZ
         TbhA==
X-Gm-Message-State: AOAM531NagjbO2gTGyT8AMAdwKNe5p2mURWUcF9bz7ghaSkO7a8aBaJP
        sFl1rr62i3w3gfo7jFtYoUwMlG+YXKajSNQoHzI8iVhjjKk=
X-Google-Smtp-Source: ABdhPJz2O26v2suId4UxB1yb6OJ3KWGBnRKuzsLVAjf3+8tGobqu38rrwjzswt4hkyfnBvwFgETgvkj8GbimtYX5XTM=
X-Received: by 2002:a05:6512:39d1:: with SMTP id k17mr220473lfu.390.1632496206181;
 Fri, 24 Sep 2021 08:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908030026.2dLZCmkE4%akpm@linux-foundation.org> <YU3As8r6AY5vGTi5@casper.infradead.org>
In-Reply-To: <YU3As8r6AY5vGTi5@casper.infradead.org>
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Sat, 25 Sep 2021 00:09:54 +0900
Message-ID: <CAKFNMokecmpFA16rqtzYc_5cT9wT2_FxUabF_fUYcH-p2-jYPw@mail.gmail.com>
Subject: Re: [patch 136/147] nilfs2: use refcount_dec_and_lock() to fix
 potential UAF
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi,

On Fri, Sep 24, 2021 at 9:13 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Sep 07, 2021 at 08:00:26PM -0700, Andrew Morton wrote:
> > From: Zhen Lei <thunder.leizhen@huawei.com>
> > Subject: nilfs2: use refcount_dec_and_lock() to fix potential UAF
> >
> > When the refcount is decreased to 0, the resource reclamation branch is
> > entered.  Before CPU0 reaches the race point (1), CPU1 may obtain the
> > spinlock and traverse the rbtree to find 'root', see nilfs_lookup_root().
> > Although CPU1 will call refcount_inc() to increase the refcount, it is
> > obviously too late.  CPU0 will release 'root' directly, CPU1 then accesses
> > 'root' and triggers UAF.
> >
> > Use refcount_dec_and_lock() to ensure that both the operations of decrease
> > refcount to 0 and link deletion are lock protected eliminates this risk.
> >
> >      CPU0                      CPU1
> > nilfs_put_root():
> >                           <-------- (1)
> > spin_lock(&nilfs->ns_cptree_lock);
> > rb_erase(&root->rb_node, &nilfs->ns_cptree);
> > spin_unlock(&nilfs->ns_cptree_lock);
> >
> > kfree(root);
> >                           <-------- use-after-free
>
> I don't know where this happened, but the leading whitespace has been
> eaten at some point, making this description of the race completely
> unreadable as everything appears to be done by CPU 0.

The diagram is the same as that in the original patch by author, and
I approved it without any discomfort because these five operations
(nilfs_put_root() ~ spin_lock(); rb_erase(); spin_unlock() ~ kfree() ) are
all done by CPU0.

But, yeah, an example of a function call might have been written on
the CPU1 side as well, for instance, a nilfs_lookup_root() call etc, to
clarify the race issue the message explains..

Regards,
Ryusuke Konishi
