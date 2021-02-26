Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4974C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F5E464F14
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhBZBRD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhBZBQw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:16:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97E3564F13;
        Fri, 26 Feb 2021 01:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302161;
        bh=K19jRJQe19OMZgOkDTzw8ulwRRnYAknzPep/KGYh7mU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iofx/vM07pql59nJhXMG4KOdJVfXNIesZGQEumoMr4HkqzeS+UeuaftC0Lhet6Fri
         aTPFXYPPryKwcvhhXbMpqOcJCPcEjD3udIIUc7vgFDKVMG/gLcdsX2zDQQBNr6LoRF
         fhbHvOefXqvZTcHQJhfKrkHJJMsbvfS2KfePYz0E=
Date:   Thu, 25 Feb 2021 17:16:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 010/118] mm: add an 'end' parameter to
 find_get_entries
Message-ID: <20210226011600.leBM4FAbV%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add an 'end' parameter to find_get_entries

This simplifies the callers and leads to a more efficient implementation
since the XArray has this functionality already.

Link: https://lkml.kernel.org/r/20201112212641.27837-11-willy@infradead.org
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

 include/linux/pagemap.h |    4 ++--
 mm/filemap.c            |    9 +++++----
 mm/shmem.c              |   10 ++--------
 mm/swap.c               |    2 +-
 4 files changed, 10 insertions(+), 15 deletions(-)

--- a/include/linux/pagemap.h~mm-add-an-end-parameter-to-find_get_entries
+++ a/include/linux/pagemap.h
@@ -451,8 +451,8 @@ static inline struct page *find_subpage(
 }
 
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
-			  unsigned int nr_entries, struct page **entries,
-			  pgoff_t *indices);
+		pgoff_t end, unsigned int nr_entries, struct page **entries,
+		pgoff_t *indices);
 unsigned find_get_pages_range(struct address_space *mapping, pgoff_t *start,
 			pgoff_t end, unsigned int nr_pages,
 			struct page **pages);
--- a/mm/filemap.c~mm-add-an-end-parameter-to-find_get_entries
+++ a/mm/filemap.c
@@ -1865,6 +1865,7 @@ reset:
  * find_get_entries - gang pagecache lookup
  * @mapping:	The address_space to search
  * @start:	The starting page cache index
+ * @end:	The final page index (inclusive).
  * @nr_entries:	The maximum number of entries
  * @entries:	Where the resulting entries are placed
  * @indices:	The cache indices corresponding to the entries in @entries
@@ -1888,9 +1889,9 @@ reset:
  *
  * Return: the number of pages and shadow entries which were found.
  */
-unsigned find_get_entries(struct address_space *mapping,
-			  pgoff_t start, unsigned int nr_entries,
-			  struct page **entries, pgoff_t *indices)
+unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
+		pgoff_t end, unsigned int nr_entries, struct page **entries,
+		pgoff_t *indices)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
@@ -1900,7 +1901,7 @@ unsigned find_get_entries(struct address
 		return 0;
 
 	rcu_read_lock();
-	while ((page = find_get_entry(&xas, ULONG_MAX, XA_PRESENT))) {
+	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
 		/*
 		 * Terminate early on finding a THP, to allow the caller to
 		 * handle it all at once; but continue if this is hugetlbfs.
--- a/mm/shmem.c~mm-add-an-end-parameter-to-find_get_entries
+++ a/mm/shmem.c
@@ -913,8 +913,6 @@ static void shmem_undo_range(struct inod
 			struct page *page = pvec.pages[i];
 
 			index = indices[i];
-			if (index >= end)
-				break;
 
 			if (xa_is_value(page)) {
 				if (unfalloc)
@@ -967,9 +965,8 @@ static void shmem_undo_range(struct inod
 	while (index < end) {
 		cond_resched();
 
-		pvec.nr = find_get_entries(mapping, index,
-				min(end - index, (pgoff_t)PAGEVEC_SIZE),
-				pvec.pages, indices);
+		pvec.nr = find_get_entries(mapping, index, end - 1,
+				PAGEVEC_SIZE, pvec.pages, indices);
 		if (!pvec.nr) {
 			/* If all gone or hole-punch or unfalloc, we're done */
 			if (index == start || end != -1)
@@ -982,9 +979,6 @@ static void shmem_undo_range(struct inod
 			struct page *page = pvec.pages[i];
 
 			index = indices[i];
-			if (index >= end)
-				break;
-
 			if (xa_is_value(page)) {
 				if (unfalloc)
 					continue;
--- a/mm/swap.c~mm-add-an-end-parameter-to-find_get_entries
+++ a/mm/swap.c
@@ -1046,7 +1046,7 @@ unsigned pagevec_lookup_entries(struct p
 				pgoff_t start, unsigned nr_entries,
 				pgoff_t *indices)
 {
-	pvec->nr = find_get_entries(mapping, start, nr_entries,
+	pvec->nr = find_get_entries(mapping, start, ULONG_MAX, nr_entries,
 				    pvec->pages, indices);
 	return pagevec_count(pvec);
 }
_
