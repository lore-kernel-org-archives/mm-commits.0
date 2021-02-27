Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1229C4332B
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD6D664F3E
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhB0C3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhB0C3b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:29:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7B0564F2A;
        Sat, 27 Feb 2021 02:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392914;
        bh=jkAtVXvDmta0jXrR2uo/HK6LxdxkhA0VEAA7WzbL8Bg=;
        h=Date:From:To:Subject:From;
        b=rbx2pStpWCpqKsRKLTgQGjjDNK+b+SBtc2MDdh4xMZjVMgp1uJC14eTRSdKbYR/Z9
         5PocQIfZBArjKQ2bs/Kl/9ky45cKkkItj2RxqPsW4rkOINN6g6HfiOUnuYDEYvpsZ2
         tLq9KJabsZKzVPk0cC81vr9ogOMs524vVjBvV9mE=
Date:   Fri, 26 Feb 2021 18:28:33 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-add-an-end-parameter-to-pagevec_lookup_entries.patch removed from -mm
 tree
Message-ID: <20210227022833.jWZK_yoD2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add an 'end' parameter to pagevec_lookup_entries
has been removed from the -mm tree.  Its filename was
     mm-add-an-end-parameter-to-pagevec_lookup_entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add an 'end' parameter to pagevec_lookup_entries

Simplifies the callers and uses the existing functionality in
find_get_entries().  We can also drop the final argument of
truncate_exceptional_pvec_entries() and simplify the logic in that
function.

Link: https://lkml.kernel.org/r/20201112212641.27837-12-willy@infradead.org
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

 include/linux/pagevec.h |    5 +---
 mm/swap.c               |    8 +++----
 mm/truncate.c           |   41 +++++++++-----------------------------
 3 files changed, 16 insertions(+), 38 deletions(-)

--- a/include/linux/pagevec.h~mm-add-an-end-parameter-to-pagevec_lookup_entries
+++ a/include/linux/pagevec.h
@@ -26,9 +26,8 @@ struct pagevec {
 void __pagevec_release(struct pagevec *pvec);
 void __pagevec_lru_add(struct pagevec *pvec);
 unsigned pagevec_lookup_entries(struct pagevec *pvec,
-				struct address_space *mapping,
-				pgoff_t start, unsigned nr_entries,
-				pgoff_t *indices);
+		struct address_space *mapping, pgoff_t start, pgoff_t end,
+		unsigned nr_entries, pgoff_t *indices);
 void pagevec_remove_exceptionals(struct pagevec *pvec);
 unsigned pagevec_lookup_range(struct pagevec *pvec,
 			      struct address_space *mapping,
--- a/mm/swap.c~mm-add-an-end-parameter-to-pagevec_lookup_entries
+++ a/mm/swap.c
@@ -1022,6 +1022,7 @@ void __pagevec_lru_add(struct pagevec *p
  * @pvec:	Where the resulting entries are placed
  * @mapping:	The address_space to search
  * @start:	The starting entry index
+ * @end:	The highest index to return (inclusive).
  * @nr_entries:	The maximum number of pages
  * @indices:	The cache indices corresponding to the entries in @pvec
  *
@@ -1042,11 +1043,10 @@ void __pagevec_lru_add(struct pagevec *p
  * found.
  */
 unsigned pagevec_lookup_entries(struct pagevec *pvec,
-				struct address_space *mapping,
-				pgoff_t start, unsigned nr_entries,
-				pgoff_t *indices)
+		struct address_space *mapping, pgoff_t start, pgoff_t end,
+		unsigned nr_entries, pgoff_t *indices)
 {
-	pvec->nr = find_get_entries(mapping, start, ULONG_MAX, nr_entries,
+	pvec->nr = find_get_entries(mapping, start, end, nr_entries,
 				    pvec->pages, indices);
 	return pagevec_count(pvec);
 }
--- a/mm/truncate.c~mm-add-an-end-parameter-to-pagevec_lookup_entries
+++ a/mm/truncate.c
@@ -57,11 +57,10 @@ static void clear_shadow_entry(struct ad
  * exceptional entries similar to what pagevec_remove_exceptionals does.
  */
 static void truncate_exceptional_pvec_entries(struct address_space *mapping,
-				struct pagevec *pvec, pgoff_t *indices,
-				pgoff_t end)
+				struct pagevec *pvec, pgoff_t *indices)
 {
 	int i, j;
-	bool dax, lock;
+	bool dax;
 
 	/* Handled by shmem itself */
 	if (shmem_mapping(mapping))
@@ -75,8 +74,7 @@ static void truncate_exceptional_pvec_en
 		return;
 
 	dax = dax_mapping(mapping);
-	lock = !dax && indices[j] < end;
-	if (lock)
+	if (!dax)
 		xa_lock_irq(&mapping->i_pages);
 
 	for (i = j; i < pagevec_count(pvec); i++) {
@@ -88,9 +86,6 @@ static void truncate_exceptional_pvec_en
 			continue;
 		}
 
-		if (index >= end)
-			continue;
-
 		if (unlikely(dax)) {
 			dax_delete_mapping_entry(mapping, index);
 			continue;
@@ -99,7 +94,7 @@ static void truncate_exceptional_pvec_en
 		__clear_shadow_entry(mapping, index, page);
 	}
 
-	if (lock)
+	if (!dax)
 		xa_unlock_irq(&mapping->i_pages);
 	pvec->nr = j;
 }
@@ -329,7 +324,7 @@ void truncate_inode_pages_range(struct a
 	while (index < end && find_lock_entries(mapping, index, end - 1,
 			&pvec, indices)) {
 		index = indices[pagevec_count(&pvec) - 1] + 1;
-		truncate_exceptional_pvec_entries(mapping, &pvec, indices, end);
+		truncate_exceptional_pvec_entries(mapping, &pvec, indices);
 		for (i = 0; i < pagevec_count(&pvec); i++)
 			truncate_cleanup_page(mapping, pvec.pages[i]);
 		delete_from_page_cache_batch(mapping, &pvec);
@@ -381,8 +376,8 @@ void truncate_inode_pages_range(struct a
 	index = start;
 	for ( ; ; ) {
 		cond_resched();
-		if (!pagevec_lookup_entries(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE), indices)) {
+		if (!pagevec_lookup_entries(&pvec, mapping, index, end - 1,
+				PAGEVEC_SIZE, indices)) {
 			/* If all gone from start onwards, we're done */
 			if (index == start)
 				break;
@@ -390,23 +385,12 @@ void truncate_inode_pages_range(struct a
 			index = start;
 			continue;
 		}
-		if (index == start && indices[0] >= end) {
-			/* All gone out of hole to be punched, we're done */
-			pagevec_remove_exceptionals(&pvec);
-			pagevec_release(&pvec);
-			break;
-		}
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
 			/* We rely upon deletion not changing page->index */
 			index = indices[i];
-			if (index >= end) {
-				/* Restart punch to make sure all gone */
-				index = start - 1;
-				break;
-			}
 
 			if (xa_is_value(page))
 				continue;
@@ -417,7 +401,7 @@ void truncate_inode_pages_range(struct a
 			truncate_inode_page(mapping, page);
 			unlock_page(page);
 		}
-		truncate_exceptional_pvec_entries(mapping, &pvec, indices, end);
+		truncate_exceptional_pvec_entries(mapping, &pvec, indices);
 		pagevec_release(&pvec);
 		index++;
 	}
@@ -513,8 +497,6 @@ static unsigned long __invalidate_mappin
 
 			/* We rely upon deletion not changing page->index */
 			index = indices[i];
-			if (index > end)
-				break;
 
 			if (xa_is_value(page)) {
 				invalidate_exceptional_entry(mapping, index,
@@ -656,16 +638,13 @@ int invalidate_inode_pages2_range(struct
 
 	pagevec_init(&pvec);
 	index = start;
-	while (index <= end && pagevec_lookup_entries(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
-			indices)) {
+	while (pagevec_lookup_entries(&pvec, mapping, index, end,
+			PAGEVEC_SIZE, indices)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
 			/* We rely upon deletion not changing page->index */
 			index = indices[i];
-			if (index > end)
-				break;
 
 			if (xa_is_value(page)) {
 				if (!invalidate_exceptional_entry2(mapping,
_

Patches currently in -mm which might be from willy@infradead.org are


