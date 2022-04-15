Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543A6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 22:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356275AbiDOWYu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Apr 2022 18:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiDOWYr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2022 18:24:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9304483010
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 15:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VWttemmYmEPUy7Q/HkVa6sf6rzJveyLzUrMwvc/JWPQ=; b=mT+ITuZLciLAcdPsjY0wXlZdbw
        P6qe0EHNXsCNZXI0d/8fl80ra7jV55RaHszNhV2r8BGJrylE6mIJUGKu/AyMrtpbwv0C+LetFdFaI
        xOvHhgXnewi1YUa3036aza7mj2ts2OSKZan0E+E8irWf1uaoCUQFjgSEVl1YzxAu82ol4IIpjD9mz
        0kzqwmdlZFONzaccnbM1TRoxiuHwW/HlLej6YX5oUric2HHSLfFXWdypI7nuvXugZkWIPYBTqzw9W
        xVM2YcwtEFIc5uf7ukLlankm21Uw06cj/OnWvsnNIwygrjlSokP02UEqmYSIZgaFQ1XaBbl3LrwGz
        eXPIwrfA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nfUK7-00GX2I-1D; Fri, 15 Apr 2022 22:21:51 +0000
Date:   Fri, 15 Apr 2022 23:21:51 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, patrice.chotard@foss.st.com,
        Mikulas Patocka <mpatocka@redhat.com>, markhemm@googlemail.com,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-ID: <Ylnv/9hiO+g4X9i5@casper.infradead.org>
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org>
 <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 15, 2022 at 03:10:51PM -0700, Linus Torvalds wrote:
> On Thu, Apr 14, 2022 at 7:13 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Revert shmem_file_read_iter() to using ZERO_PAGE for holes only when
> > iter_is_iovec(); in other cases, use the more natural iov_iter_zero()
> > instead of copy_page_to_iter().  We would use iov_iter_zero() throughout,
> > but the x86 clear_user() is not nearly so well optimized as copy to user
> > (dd of 1T sparse tmpfs file takes 57 seconds rather than 44 seconds).
> 
> Ugh.
> 
> I've applied this patch, but honestly, the proper course of action
> should just be to improve on clear_user().
> 
> If it really is important enough that we should care about that
> performance, then we just should fix clear_user().
> 
> It's a very odd special thing right now (at least on x86-64) using
> some strange handcrafted inline asm code.
> 
> I assume that 'rep stosb' is the fastest way to clear things on modern
> CPU's that have FSRM, and then we have the usual fallbacks (ie ERMS ->
> "rep stos" except for small areas, and probably that "store zeros by
> hand" for older CPUs).
> 
> Adding PeterZ and Borislav (who seem to be the last ones to have
> worked on the copy and clear_page stuff respectively) and the x86
> maintainers in case somebody gets the urge to just fix this.

Perhaps the x86 maintainers would like to start from
https://lore.kernel.org/lkml/20210523180423.108087-1-sneves@dei.uc.pt/
instead of pushing that work off on the submitter.
