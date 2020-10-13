Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42484C2D0A4
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12D4C22227
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633144;
	bh=/fdoNhxiOJQ/kEZscwhofi3rNubpgATjvRN5LA1G1vk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=P6KCSfPKfvrR9Relt2h8D+oYmeIFRZO6djoIeImIqtg3XgofPsiI37TVbIlMOqc//
	 C9p2PquycjoNxnaVljAzLw3Rl4rnF3uZEJ5LToHqMnCYzkby+L/BjP2KIIvS9iKT2d
	 SA/A2ZP2BTpnP7CMHQ81Oyd7GoDO+sVMbD50qPMQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgJMXwX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgJMXvq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37D1521D81;
        Tue, 13 Oct 2020 23:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633105;
        bh=/fdoNhxiOJQ/kEZscwhofi3rNubpgATjvRN5LA1G1vk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nkxN3bMH+Hqs3xupsBBM9WHw+Vp3Alspah9/Md4V4PjAZ3uePNmM1TxcllSHwui/J
         9OBnDDdj3Ioe+3kH2y6nhfO3KqBlpy0B8RewxSDvhU8amP932WWMPywOIA6RBWjOni
         lVGOKIdldaldgmLyrKoElgHb3A8PqutADUM1GXgs=
Date:   Tue, 13 Oct 2020 16:51:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [patch 062/181] mm/filemap: fix filemap_map_pages for THP
Message-ID: <20201013235144.xM9ujgUdf%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: fix filemap_map_pages for THP

We dereference page->mapping and page->index directly after calling
find_subpage() and these fields are not valid for tail pages.  While
commit 4101196b19d7 ("mm: page cache: store only head pages in i_pages")
introduced the call to find_subpage(), the problem existed prior to this;
I'm going to suggest all the way back to when THPs first existed.

The user-visible effects of this are almost negligible.  To hit it, you
have to mmap a tmpfs file at an unaligned address and then it's only a
disabled optimisation causing page faults to happen more frequently than
they otherwise would.

Fix this by keeping both head and page pointers and checking the
appropriate one.  We could use page_mapping() and page_to_index(), but
that's higher overhead.

Link: https://lkml.kernel.org/r/20200911012532.24761-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-filemap_map_pages-for-thp
+++ a/mm/filemap.c
@@ -2793,42 +2793,42 @@ void filemap_map_pages(struct vm_fault *
 	pgoff_t last_pgoff = start_pgoff;
 	unsigned long max_idx;
 	XA_STATE(xas, &mapping->i_pages, start_pgoff);
-	struct page *page;
+	struct page *head, *page;
 	unsigned int mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, end_pgoff) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, head, end_pgoff) {
+		if (xas_retry(&xas, head))
 			continue;
-		if (xa_is_value(page))
+		if (xa_is_value(head))
 			goto next;
 
 		/*
 		 * Check for a locked page first, as a speculative
 		 * reference may adversely influence page migration.
 		 */
-		if (PageLocked(page))
+		if (PageLocked(head))
 			goto next;
-		if (!page_cache_get_speculative(page))
+		if (!page_cache_get_speculative(head))
 			goto next;
 
 		/* Has the page moved or been split? */
-		if (unlikely(page != xas_reload(&xas)))
+		if (unlikely(head != xas_reload(&xas)))
 			goto skip;
-		page = find_subpage(page, xas.xa_index);
+		page = find_subpage(head, xas.xa_index);
 
-		if (!PageUptodate(page) ||
+		if (!PageUptodate(head) ||
 				PageReadahead(page) ||
 				PageHWPoison(page))
 			goto skip;
-		if (!trylock_page(page))
+		if (!trylock_page(head))
 			goto skip;
 
-		if (page->mapping != mapping || !PageUptodate(page))
+		if (head->mapping != mapping || !PageUptodate(head))
 			goto unlock;
 
 		max_idx = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
-		if (page->index >= max_idx)
+		if (xas.xa_index >= max_idx)
 			goto unlock;
 
 		if (mmap_miss > 0)
@@ -2840,12 +2840,12 @@ void filemap_map_pages(struct vm_fault *
 		last_pgoff = xas.xa_index;
 		if (alloc_set_pte(vmf, page))
 			goto unlock;
-		unlock_page(page);
+		unlock_page(head);
 		goto next;
 unlock:
-		unlock_page(page);
+		unlock_page(head);
 skip:
-		put_page(page);
+		put_page(head);
 next:
 		/* Huge page is mapped? No need to proceed. */
 		if (pmd_trans_huge(*vmf->pmd))
_
