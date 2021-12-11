Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A15C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Dec 2021 04:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbhLKEiT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 23:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbhLKEiT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 23:38:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157E5C061714
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 20:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BP+5jTWnImXiUjSg30yjDPKqR7eZGHECzzuNyxLLxHo=; b=GHLF41zaXlMjziJEOe6hcJlrYW
        yju9gl3Tg6cq+eeIeaJ6+eYOG9S43Ot/owf/FoOMNIoreHDfRcc7neeKx22GnchPkh+Hal8azNU1E
        W2DN0aoNAs4Q8w2U+9j2JimIZyUIvlLGs+xbqMY0271lfDdCLxiqWN8FbayStiz/GH5BtrwrxUNXp
        Or8r5RqnMFt27JrHt0YAI8QVXkWq41frx0qUvwq8dUtsAeOmudd6hLK8gvLeGiL714e2C40QhmAwJ
        ZeiTEz0fSA9Knrl7f9qLnS3dc/+i+rIs+GdEZ1kblhI8+HtZOZ2sTFfDklkdUExbCS9kQbecfj413
        lTA2UC1w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvu5k-00AxGl-Mr; Sat, 11 Dec 2021 04:34:36 +0000
Date:   Sat, 11 Dec 2021 04:34:36 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     akpm@linux-foundation.org
Cc:     apopple@nvidia.com, dhowells@redhat.com, hughd@google.com,
        jgg@nvidia.com, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com
Subject: Re: +
 mm-migratec-rework-migration_entry_wait-to-not-take-a-pageref.patch added to
 -mm tree
Message-ID: <YbQqXKrwVtr+HRLe@casper.infradead.org>
References: <20211118215427.csLE2tPWS%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118215427.csLE2tPWS%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Nov 18, 2021 at 01:54:27PM -0800, akpm@linux-foundation.org wrote:
> +++ a/mm/migrate.c
> @@ -305,15 +305,7 @@ void __migration_entry_wait(struct mm_st
>  	page = pfn_swap_entry_to_page(entry);
>  	page = compound_head(page);
>  
> -	/*
> -	 * Once page cache replacement of page migration started, page_count
> -	 * is zero; but we must not call put_and_wait_on_page_locked() without
> -	 * a ref. Use get_page_unless_zero(), and just fault again if it fails.
> -	 */
> -	if (!get_page_unless_zero(page))
> -		goto out;
> -	pte_unmap_unlock(ptep, ptl);
> -	put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
> +	migration_entry_wait_on_locked(page_folio(page), ptep, ptl);

This is clearly bogus.  The 'page = compound_head(page)' line should
be deleted.

But I think we should go further and turn this into:

	migration_entry_wait_on_locked(entry, ptep, ptl);

Neither caller has anything useful to do with the page any more.

