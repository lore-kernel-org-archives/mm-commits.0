Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD43CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 12:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850DD610FD
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 12:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245385AbhIXMOw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 08:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbhIXMOw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Sep 2021 08:14:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F334C061574
        for <mm-commits@vger.kernel.org>; Fri, 24 Sep 2021 05:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GgW0GvnokLjku9AJnSodEihBkOdE/1jhYJQC0NGl+sg=; b=vkWGfN9waykNU3+C1QXNmY2r1d
        eK9sK8ZliSadEtJBpyX8/enPHhKH/ZhYNCGLVPkStdQQlEBzIAf4w3nMUTJ58rJoIuJN8Boq+IzWF
        3M5c0gA+wlWn9y+BxGgZPoo3kstXAug19JWdVAcCiQxxXw396HX43hiyHnOfo3tchjwML7UMcTSEe
        7KRMCREizEDkUpzksvx1Io8O+R6OQKW5UwC9/bVT/L4mArGcc4tXyLOc1meH5Pci2weJz413RUBe1
        Ry/Gw4AJnSX+zImLfOetCkoBK1Kcl9Xll10TMhQ2HkPSlSAFbSAOYdNSxA7N7CBaWT6ir+6Jprv65
        s75JgFWQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTk4B-007ALy-Q1; Fri, 24 Sep 2021 12:12:51 +0000
Date:   Fri, 24 Sep 2021 13:12:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     konishi.ryusuke@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        torvalds@linux-foundation.org
Subject: Re: [patch 136/147] nilfs2: use refcount_dec_and_lock() to fix
 potential UAF
Message-ID: <YU3As8r6AY5vGTi5@casper.infradead.org>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908030026.2dLZCmkE4%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908030026.2dLZCmkE4%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Sep 07, 2021 at 08:00:26PM -0700, Andrew Morton wrote:
> From: Zhen Lei <thunder.leizhen@huawei.com>
> Subject: nilfs2: use refcount_dec_and_lock() to fix potential UAF
> 
> When the refcount is decreased to 0, the resource reclamation branch is
> entered.  Before CPU0 reaches the race point (1), CPU1 may obtain the
> spinlock and traverse the rbtree to find 'root', see nilfs_lookup_root(). 
> Although CPU1 will call refcount_inc() to increase the refcount, it is
> obviously too late.  CPU0 will release 'root' directly, CPU1 then accesses
> 'root' and triggers UAF.
> 
> Use refcount_dec_and_lock() to ensure that both the operations of decrease
> refcount to 0 and link deletion are lock protected eliminates this risk.
> 
>      CPU0                      CPU1
> nilfs_put_root():
> 			    <-------- (1)
> spin_lock(&nilfs->ns_cptree_lock);
> rb_erase(&root->rb_node, &nilfs->ns_cptree);
> spin_unlock(&nilfs->ns_cptree_lock);
> 
> kfree(root);
> 			    <-------- use-after-free

I don't know where this happened, but the leading whitespace has been
eaten at some point, making this description of the race completely
unreadable as everything appears to be done by CPU 0.
