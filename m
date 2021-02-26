Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE86C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C755F64F17
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBZBRF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhBZBQ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:16:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 479E564F21;
        Fri, 26 Feb 2021 01:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302175;
        bh=97QdFBMZzCEot3CJxtzrI+ZETh+NRHWbJ872ktQ83yA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NeBVXVTV6YGAngfu4X3VOfzZ0cL+cc9LPL9nHyA3I4kg1o+L22927BfxIirepNu8G
         opsbkT8JMvPDAImzlF2Q2NIP2BmDAAr0G8NuZ6JZbLvTegZMgd3/zulY95oAjNCmlM
         ytKbzb/vcd59dVPgFL7ZFWoh5eBycrQqALTP6AjE=
Date:   Thu, 25 Feb 2021 17:16:14 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 014/118] mm: remove pagevec_lookup_entries
Message-ID: <20210226011614.OAuNbfFXc%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove pagevec_lookup_entries

pagevec_lookup_entries() is now just a wrapper around find_get_entries()
so remove it and convert all its callers.

Link: https://lkml.kernel.org/r/20201112212641.27837-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    3 ---
 mm/swap.c               |   36 ++----------------------------------
 mm/truncate.c           |    4 ++--
 3 files changed, 4 insertions(+), 39 deletions(-)

--- a/include/linux/pagevec.h~mm-remove-pagevec_lookup_entries
+++ a/include/linux/pagevec.h
@@ -25,9 +25,6 @@ struct pagevec {
 
 void __pagevec_release(struct pagevec *pvec);
 void __pagevec_lru_add(struct pagevec *pvec);
-unsigned pagevec_lookup_entries(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t start, pgoff_t end,
-		pgoff_t *indices);
 void pagevec_remove_exceptionals(struct pagevec *pvec);
 unsigned pagevec_lookup_range(struct pagevec *pvec,
 			      struct address_space *mapping,
--- a/mm/swap.c~mm-remove-pagevec_lookup_entries
+++ a/mm/swap.c
@@ -1018,43 +1018,11 @@ void __pagevec_lru_add(struct pagevec *p
 }
 
 /**
- * pagevec_lookup_entries - gang pagecache lookup
- * @pvec:	Where the resulting entries are placed
- * @mapping:	The address_space to search
- * @start:	The starting entry index
- * @end:	The highest index to return (inclusive).
- * @nr_entries:	The maximum number of pages
- * @indices:	The cache indices corresponding to the entries in @pvec
- *
- * pagevec_lookup_entries() will search for and return a group of up
- * to @nr_pages pages and shadow entries in the mapping.  All
- * entries are placed in @pvec.  pagevec_lookup_entries() takes a
- * reference against actual pages in @pvec.
- *
- * The search returns a group of mapping-contiguous entries with
- * ascending indexes.  There may be holes in the indices due to
- * not-present entries.
- *
- * Only one subpage of a Transparent Huge Page is returned in one call:
- * allowing truncate_inode_pages_range() to evict the whole THP without
- * cycling through a pagevec of extra references.
- *
- * pagevec_lookup_entries() returns the number of entries which were
- * found.
- */
-unsigned pagevec_lookup_entries(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t start, pgoff_t end,
-		pgoff_t *indices)
-{
-	return find_get_entries(mapping, start, end, pvec, indices);
-}
-
-/**
  * pagevec_remove_exceptionals - pagevec exceptionals pruning
  * @pvec:	The pagevec to prune
  *
- * pagevec_lookup_entries() fills both pages and exceptional radix
- * tree entries into the pagevec.  This function prunes all
+ * find_get_entries() fills both pages and XArray value entries (aka
+ * exceptional entries) into the pagevec.  This function prunes all
  * exceptionals from @pvec without leaving holes, so that it can be
  * passed on to page-only pagevec operations.
  */
--- a/mm/truncate.c~mm-remove-pagevec_lookup_entries
+++ a/mm/truncate.c
@@ -376,7 +376,7 @@ void truncate_inode_pages_range(struct a
 	index = start;
 	for ( ; ; ) {
 		cond_resched();
-		if (!pagevec_lookup_entries(&pvec, mapping, index, end - 1,
+		if (!find_get_entries(mapping, index, end - 1, &pvec,
 				indices)) {
 			/* If all gone from start onwards, we're done */
 			if (index == start)
@@ -638,7 +638,7 @@ int invalidate_inode_pages2_range(struct
 
 	pagevec_init(&pvec);
 	index = start;
-	while (pagevec_lookup_entries(&pvec, mapping, index, end, indices)) {
+	while (find_get_entries(mapping, index, end, &pvec, indices)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
_
