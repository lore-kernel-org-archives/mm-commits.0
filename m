Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB45C05027
	for <mm-commits@archiver.kernel.org>; Thu,  9 Feb 2023 03:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbjBID75 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Feb 2023 22:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbjBID7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2023 22:59:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED792E810
        for <mm-commits@vger.kernel.org>; Wed,  8 Feb 2023 19:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AEFA61881
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 03:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC6FC433EF;
        Thu,  9 Feb 2023 03:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675915192;
        bh=ghCym8aUHlqe6s95x5ctYpcq5NFtxPRPm2qr49GnhKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R8UmICs3b4KxcgbiFKK/GOU/N3koF1m8GgC1gqZLmWErgJ59dMLei/jasn0rsZwqF
         ddVB4vhSnkzRypqXYsgl5DEIZi4VjJG/FEbcmhwTOVtQKQIthry3Sze+JkJDgQp9kv
         UPemB4rVgShHKUaAzcTwSA1pp8tKBiDTGaxPKa60=
Date:   Wed, 8 Feb 2023 19:59:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com
Subject: Re: + shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch
 added to mm-unstable branch
Message-Id: <20230208195951.9bf2f8a61c096ce4660793d5@linux-foundation.org>
In-Reply-To: <Y+QdJTuzxeBYejw2@casper.infradead.org>
References: <20230207010408.34435C433EF@smtp.kernel.org>
        <Y+QdJTuzxeBYejw2@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 8 Feb 2023 22:07:33 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Feb 06, 2023 at 05:04:07PM -0800, Andrew Morton wrote:
> > +struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
> > +					 pgoff_t index, gfp_t gfp)
> > +{
> > +	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
> > +	struct page *page = folio_file_page(folio, index);
> > +
> 
> Ugh, insufficiently cautious.
> 
> This should have been
> 
> 	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
> 	struct page *page;
> 
> 	if (IS_ERR(folio))
> 		return &folio->page;
> 	page = folio_file_page(folio, index);
> 
> Unfortunately I have to go out now, but that's the solution to the
> latest syzbot splat I saw.  I'll do you a proper -fix patch later
> if you don't get to it first.
> 

No probs, thanks.

(although that trick of doing &randomgarbagepointeroftypefoliostar->page
still makes my brain bleed)



From: Andrew Morton <akpm@linux-foundation.org>
Subject: shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix
Date: Wed Feb  8 07:54:45 PM PST 2023

fix shmem_read_mapping_page_gfp(), per Matthew

Link: https://lkml.kernel.org/r/Y+QdJTuzxeBYejw2@casper.infradead.org
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mark Hemment <markhemm@googlemail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shmem.c~shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix
+++ a/mm/shmem.c
@@ -4354,8 +4354,12 @@ struct page *shmem_read_mapping_page_gfp
 					 pgoff_t index, gfp_t gfp)
 {
 	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
-	struct page *page = folio_file_page(folio, index);
+	struct page *page;
 
+	if (IS_ERR(folio))
+		return &folio->page;
+
+	page = folio_file_page(folio, index);
 	if (PageHWPoison(page)) {
 		folio_put(folio);
 		return ERR_PTR(-EIO);
_

