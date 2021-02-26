Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3BB0C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF8C64F0D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBZBRG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhBZBRA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B06A64EE1;
        Fri, 26 Feb 2021 01:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302172;
        bh=98kjZfB3cpKDQlBRCErfj55DCMG1L6dOyRH/cSVMDJw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jpbe16m8LjIU4HmTcrC9EOgwzpbL/9TeyH+PTVL2DsnDPRhLmV0jbDIeA7V4TrMei
         Hwft+qgKFP3K/uoDLScSv44FTy/XdtskIc2S5HxPqo/OPHJWyePCImyBRU83wkp9Uw
         Zyq+AhK6y51h53TaxicppL/lhSJus4dx0q15wl3M=
Date:   Thu, 25 Feb 2021 17:16:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 013/118] mm: pass pvec directly to
 find_get_entries
Message-ID: <20210226011611.EvqKH32-M%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: pass pvec directly to find_get_entries

All callers of find_get_entries() use a pvec, so pass it directly instead
of manipulating it in the caller.

Link: https://lkml.kernel.org/r/20201112212641.27837-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 +--
 mm/filemap.c            |   21 +++++++++------------
 mm/shmem.c              |    5 ++---
 mm/swap.c               |    4 +---
 4 files changed, 13 insertions(+), 20 deletions(-)

--- a/include/linux/pagemap.h~mm-pass-pvec-directly-to-find_get_entries
+++ a/include/linux/pagemap.h
@@ -451,8 +451,7 @@ static inline struct page *find_subpage(
 }
 
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
-		pgoff_t end, unsigned int nr_entries, struct page **entries,
-		pgoff_t *indices);
+		pgoff_t end, struct pagevec *pvec, pgoff_t *indices);
 unsigned find_get_pages_range(struct address_space *mapping, pgoff_t *start,
 			pgoff_t end, unsigned int nr_pages,
 			struct page **pages);
--- a/mm/filemap.c~mm-pass-pvec-directly-to-find_get_entries
+++ a/mm/filemap.c
@@ -1866,14 +1866,12 @@ reset:
  * @mapping:	The address_space to search
  * @start:	The starting page cache index
  * @end:	The final page index (inclusive).
- * @nr_entries:	The maximum number of entries
- * @entries:	Where the resulting entries are placed
+ * @pvec:	Where the resulting entries are placed.
  * @indices:	The cache indices corresponding to the entries in @entries
  *
- * find_get_entries() will search for and return a group of up to
- * @nr_entries entries in the mapping.  The entries are placed at
- * @entries.  find_get_entries() takes a reference against any actual
- * pages it returns.
+ * find_get_entries() will search for and return a batch of entries in
+ * the mapping.  The entries are placed in @pvec.  find_get_entries()
+ * takes a reference on any actual pages it returns.
  *
  * The search returns a group of mapping-contiguous page cache entries
  * with ascending indexes.  There may be holes in the indices due to
@@ -1890,15 +1888,12 @@ reset:
  * Return: the number of pages and shadow entries which were found.
  */
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
-		pgoff_t end, unsigned int nr_entries, struct page **entries,
-		pgoff_t *indices)
+		pgoff_t end, struct pagevec *pvec, pgoff_t *indices)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
 	unsigned int ret = 0;
-
-	if (!nr_entries)
-		return 0;
+	unsigned nr_entries = PAGEVEC_SIZE;
 
 	rcu_read_lock();
 	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
@@ -1913,11 +1908,13 @@ unsigned find_get_entries(struct address
 		}
 
 		indices[ret] = xas.xa_index;
-		entries[ret] = page;
+		pvec->pages[ret] = page;
 		if (++ret == nr_entries)
 			break;
 	}
 	rcu_read_unlock();
+
+	pvec->nr = ret;
 	return ret;
 }
 
--- a/mm/shmem.c~mm-pass-pvec-directly-to-find_get_entries
+++ a/mm/shmem.c
@@ -965,9 +965,8 @@ static void shmem_undo_range(struct inod
 	while (index < end) {
 		cond_resched();
 
-		pvec.nr = find_get_entries(mapping, index, end - 1,
-				PAGEVEC_SIZE, pvec.pages, indices);
-		if (!pvec.nr) {
+		if (!find_get_entries(mapping, index, end - 1, &pvec,
+				indices)) {
 			/* If all gone or hole-punch or unfalloc, we're done */
 			if (index == start || end != -1)
 				break;
--- a/mm/swap.c~mm-pass-pvec-directly-to-find_get_entries
+++ a/mm/swap.c
@@ -1046,9 +1046,7 @@ unsigned pagevec_lookup_entries(struct p
 		struct address_space *mapping, pgoff_t start, pgoff_t end,
 		pgoff_t *indices)
 {
-	pvec->nr = find_get_entries(mapping, start, end, PAGEVEC_SIZE,
-				    pvec->pages, indices);
-	return pagevec_count(pvec);
+	return find_get_entries(mapping, start, end, pvec, indices);
 }
 
 /**
_
