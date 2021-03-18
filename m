Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36572C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D642A64F26
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCRARU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 20:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhCRARM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Mar 2021 20:17:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BCEC06174A
        for <mm-commits@vger.kernel.org>; Wed, 17 Mar 2021 17:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lif+v0yHkV6xRw9T4mgxqZSAri1CRvC2yk/GyFhNt/c=; b=p1x3RwKh+UufHQei5P+IwcoFFa
        dzvBiCJMnkOq1lP6Rl661HbDG4BSllAqwhi/l0EcS2QDJVYVF06NprQwGp2O23lzO5DWfYZIAG5ud
        2i0ZcsEZpXIpHKsrFdmsxm5X9s5/3ORJKQn83EwUr3McEqcbaHI2pYMKjW9uVQZYE5UkLBbiA4td5
        PvHU5x/MJiIdEic3vr+0fN3lN3N5qNorNHHrONeNrAVr/wXVXMOT+EDgVEjck7U/Ew88ZrK2m3cgJ
        80+O6DdJpD/8eedLvaRyTfalACNAnbAKQYGhCVxmYQr09I1srsJk52c3dd77R0LePUm5WOG/0j2K5
        a8sfyhYg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lMgKA-002IRH-OK; Thu, 18 Mar 2021 00:15:48 +0000
Date:   Thu, 18 Mar 2021 00:15:38 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com,
        elena.reshetova@intel.com, guro@fb.com, hagen@jauu.net,
        hpa@zytor.com, kirill@shutemov.name, luto@kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org
Subject: Re: + mm-add-definition-of-pmd_page_order.patch added to -mm tree
Message-ID: <20210318001538.GI3420@casper.infradead.org>
References: <20210317221512.A39Ft3LQk%akpm@linux-foundation.org>
 <20210317225402.GH3420@casper.infradead.org>
 <42da5805da8dad56818d2047b2e64c20ec7d030d.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42da5805da8dad56818d2047b2e64c20ec7d030d.camel@linux.ibm.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Mar 17, 2021 at 04:19:06PM -0700, James Bottomley wrote:
> On Wed, 2021-03-17 at 22:54 +0000, Matthew Wilcox wrote:
> > On Wed, Mar 17, 2021 at 03:15:12PM -0700, akpm@linux-foundation.org
> > wrote:
> > > Several architectures already have definition of PMD_ORDER as the
> > > size of second level page table, so to avoid conflict with these
> > > definitions use PMD_PAGE_ORDER name and update DAX respectively.
> > 
> > I thought I NACKed this patch already?
> 
> I don't think anyone understands why.  DAX won't build on several
> architectures, including parisc, because of this existing symbol clash.
> 
> > The architectures should be updated to not use PMD_ORDER.  PMD_ORDER
> > is clearly the right name for what is now PMD_PAGE_ORDER.  The
> > architectures should be using PMD_ALLOC_ORDER or some such.

https://lore.kernel.org/linux-fsdevel/20201204034843.GM11935@casper.infradead.org/
was where I said what I wanted.

> Well I had a patch renaming the dax specific one to DAX_PMD_ORDER which
> you also didn't like.  Why don't you just propose the patch you do like
> because this is a build failure on several architectures currently.
> 
> I don't really care what colour the bike shed is ... I do care that my
> builds fail.

I was expecting you to do the rename, since it's inconveniencing you.
It doesn't cause me any trouble at all.
