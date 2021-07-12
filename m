Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE6EC07E9A
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jul 2021 14:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6889611CD
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jul 2021 14:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhGLOvQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jul 2021 10:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhGLOvP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jul 2021 10:51:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5001C0613DD
        for <mm-commits@vger.kernel.org>; Mon, 12 Jul 2021 07:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IrfkZtyTnZQpIyer0CcC3C6fDw3PExEkEtu69JUtc0s=; b=U/SK4tSIHbq1WitEwAfv5g+wDp
        +4GzF6Rp3n25A5DbY7XwQ4nfYNAq6O5FJWKh4msl6Btk9Tz1zb4FUPs4vI969HMLHCB8KwVpyVFyK
        WKO4WqnJTvS7xMvQ162YQNq8R1Pfp0uEWEGTaILcWaCFtoecwCnEJuOpumWxm0XVct1l5hIU4x9Af
        cfGJEtn3ecLcm0jECeSKVjCUTYfUa2lkjHf+FJK72RrmifuHb+v/DUz99wPHgcP7R8NtmP3ByD9xM
        V1Md6kjxTwBqOc82R3m1ls9o2FjF0vfIiFC8RZTrUURQRa1We9YTOw7mvaQBz5TK61MIcDYe8nYp7
        2t4n0Aew==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2xE3-0008Dx-AH; Mon, 12 Jul 2021 14:48:05 +0000
Date:   Mon, 12 Jul 2021 15:48:03 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     almasrymina@google.com, axelrasmussen@google.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org, yuehaibing@huawei.com
Subject: Re: [patch 023/192] mm, hugetlb: fix racy resv_huge_pages underflow
 on UFFDIO_COPY
Message-ID: <YOxWI2imZq5/e8VW@casper.infradead.org>
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701014819.Vm-gaPGHW%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701014819.Vm-gaPGHW%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 06:48:19PM -0700, Andrew Morton wrote:
> From: Mina Almasry <almasrymina@google.com>
> Subject: mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY
> 
> On UFFDIO_COPY, if we fail to copy the page contents while holding the
> hugetlb_fault_mutex, we will drop the mutex and return to the caller after
> allocating a page that consumed a reservation.  In this case there may be
> a fault that double consumes the reservation.  To handle this, we free the
> allocated page, fix the reservations, and allocate a temporary hugetlb
> page and return that to the caller.  When the caller does the copy outside
> of the lock, we again check the cache, and allocate a page consuming the
> reservation, and copy over the contents.

But you only copy over the contents *IF* CONFIG_MIGRATION is enabled!
Now, maybe there aren't many configs out there that enable HUGETLBFS
and disable MIGRATION, but this is sloppy.

> +++ a/include/linux/migrate.h
> @@ -51,6 +51,7 @@ extern int migrate_huge_page_move_mappin
>  				  struct page *newpage, struct page *page);
>  extern int migrate_page_move_mapping(struct address_space *mapping,
>  		struct page *newpage, struct page *page, int extra_count);
> +extern void copy_huge_page(struct page *dst, struct page *src);
>  #else
>  
>  static inline void putback_movable_pages(struct list_head *l) {}
> @@ -77,6 +78,9 @@ static inline int migrate_huge_page_move
>  	return -ENOSYS;
>  }
>  
> +static inline void copy_huge_page(struct page *dst, struct page *src)
> +{
> +}
>  #endif /* CONFIG_MIGRATION */
>  
>  #ifdef CONFIG_COMPACTION
