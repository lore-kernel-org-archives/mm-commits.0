Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDDCC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B7F564F33
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 22:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhCQWzt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 18:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCQWz0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Mar 2021 18:55:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F755C06174A
        for <mm-commits@vger.kernel.org>; Wed, 17 Mar 2021 15:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SgJLfrj6HD8ejBgvR/ef5TW8PL3j9dV5ggG6QSsU24U=; b=DE9eOH0f8mbSKThSuDub1th4dt
        POPaOW0Vq+GA+hWDUJ2KZEX8M0NTtpJBtZg0jJoCNeB/bOtmSqZBftnhJkFAgEI6KSLF503RPVJl0
        tr+KvBjCPkU9jvPPvwIt3be/1SfjuKzCwfPtlVPIPJe37yeg7A2U/3CWtqMmQwm2Ehezy5u6x/tu3
        818N1RM49XMMCsPf4+VS3bWw4nyysYanuQMuZlKV08N1pRKW8n1fMmzBRcgqhpvukJEB2WX6UspvE
        jRsqyNZw7CjzNYbRxaatnbYQt6EJtSYVjv8xoVJ7aQXaAf1YFn4xauY1ucKTqMw+sZkzpcD9RyE94
        FzYqc8ww==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lMf3C-002EAH-60; Wed, 17 Mar 2021 22:54:08 +0000
Date:   Wed, 17 Mar 2021 22:54:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     akpm@linux-foundation.org
Cc:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, guro@fb.com,
        hagen@jauu.net, hpa@zytor.com, jejb@linux.ibm.com,
        kirill@shutemov.name, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org
Subject: Re: + mm-add-definition-of-pmd_page_order.patch added to -mm tree
Message-ID: <20210317225402.GH3420@casper.infradead.org>
References: <20210317221512.A39Ft3LQk%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317221512.A39Ft3LQk%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Mar 17, 2021 at 03:15:12PM -0700, akpm@linux-foundation.org wrote:
> Several architectures already have definition of PMD_ORDER as the size of
> second level page table, so to avoid conflict with these definitions use
> PMD_PAGE_ORDER name and update DAX respectively.

I thought I NACKed this patch already?

The architectures should be updated to not use PMD_ORDER.  PMD_ORDER is
clearly the right name for what is now PMD_PAGE_ORDER.  The architectures
should be using PMD_ALLOC_ORDER or some such.
