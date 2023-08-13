Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F45C001B0
	for <mm-commits@archiver.kernel.org>; Sun, 13 Aug 2023 19:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjHMTek (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Aug 2023 15:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjHMTek (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 13 Aug 2023 15:34:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BEEE7E
        for <mm-commits@vger.kernel.org>; Sun, 13 Aug 2023 12:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=akWiuf4+G0wP3M/XUhC2542wWc85XJ3RfDo21f69DBE=; b=arH/O9wkY80AVv8mJKO2M61D7v
        MkgC8p7aaD5Oi+FwsosmFsC+Cw/I/spU6PItEBJmPCQvFDQ88EijY1U+Rm0rrgdQ5PAJ27SSvzKwr
        cKPZCjBFgwgGVWp62xaGwExT7ubLYjWQhuMlx4sIwyQZSw/hXQvlegHxj/+j2QHfIAD+mKBAPPMIg
        ZGds24O6g8CfqjGyFFh2cSK4Wguo7gb9U+j1w5kXGToUbWimBVu/OLaSC0DK7AOD8V7oL3ueaYW7H
        +ildFcLd3s6Eh38weWPB1UlmG4NELcY3RO70eRvei3h/Cqgx95ID2LmkX2NgtdHIlQod8ggc9ZRHp
        mght0EaA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVGrF-00FFD8-Me; Sun, 13 Aug 2023 19:34:38 +0000
Date:   Sun, 13 Aug 2023 20:34:37 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Vineet Gupta <vgupta@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, rppt@kernel.org
Subject: Re: + arc-implement-the-new-page-table-range-api.patch added to
 mm-unstable branch
Message-ID: <ZNkwTYcxN07/P5aO@casper.infradead.org>
References: <20230802185154.87EEDC433C7@smtp.kernel.org>
 <39b817e5-9d80-511c-d4c7-471df0aa07dd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b817e5-9d80-511c-d4c7-471df0aa07dd@kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Aug 13, 2023 at 12:08:35PM -0700, Vineet Gupta wrote:
> > ------------------------------------------------------
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > Subject: arc: implement the new page table range API
> > Date: Wed, 2 Aug 2023 16:13:36 +0100
> > 
> > Add PFN_PTE_SHIFT, update_mmu_cache_range(), flush_dcache_folio()
> > and flush_icache_pages().
> > 
> > Change the PG_dc_clean flag from being per-page to per-folio (which means
> > it cannot always be set as we don't know that all pages in this folio were
> > cleaned).  Enhance the internal flush routines to take the number of pages
> > to flush.
> > 
> > Link: https://lkml.kernel.org/r/20230802151406.3735276-9-willy@infradead.org
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
> > Cc: Vineet Gupta <vgupta@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Is this slated for merge already. Sorry for getting to this so late, but if
> possible I'd like to drop the VIPT aliasing support first so that the
> changes here are fewer.

It went into mm-stable on Friday.
