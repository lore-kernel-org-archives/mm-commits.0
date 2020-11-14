Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E362C64E7B
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF1F822261
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6moN84l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgKNBqB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgKNBqB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:46:01 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04A6822276;
        Sat, 14 Nov 2020 01:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318359;
        bh=aY+YKMp8S+lpyAvfuxnG5jr99UeJC+agR37yov0RvyM=;
        h=Date:From:To:Subject:From;
        b=U6moN84l8kRXu0HwQD5TwzOAzw7foQwoXJWifmFxjibTqh/GIIY0kXSBbBz//7Bxf
         /TX2b9z8K9uWSLZMDaHuBhIBQV72MicpjNwmzekP+tdZrPCQvXcktnMCXSFNV3wvUl
         FOoEIysdQ9eDoKxT8tI8bO/MLmdQBgGtkqfSbWk0=
Date:   Fri, 13 Nov 2020 17:45:58 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  +
 mm-filemap-return-only-head-pages-from-find_get_entries.patch added to -mm
 tree
Message-ID: <20201114014558.K-fK3ra3G%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: return only head pages from find_get_entries
has been added to the -mm tree.  Its filename is
     mm-filemap-return-only-head-pages-from-find_get_entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-return-only-head-pages-from-find_get_entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-return-only-head-pages-from-find_get_entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: return only head pages from find_get_entries

All callers now expect head (and base) pages, and can handle multiple head
pages in a single batch, so make find_get_entries() behave that way.  Also
take the opportunity to make it use the pagevec infrastructure instead of
open-coding how pvecs behave.  This has the side-effect of being able to
append to a pagevec with existing contents, although we don't make use of
that functionality anywhere yet.

Link: https://lkml.kernel.org/r/20201112212641.27837-17-willy@infradead.org
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

 include/linux/pagemap.h |    2 --
 mm/filemap.c            |   36 ++++++++----------------------------
 mm/internal.h           |    2 ++
 3 files changed, 10 insertions(+), 30 deletions(-)

--- a/include/linux/pagemap.h~mm-filemap-return-only-head-pages-from-find_get_entries
+++ a/include/linux/pagemap.h
@@ -450,8 +450,6 @@ static inline struct page *find_subpage(
 	return head + (index & (thp_nr_pages(head) - 1));
 }
 
-unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
-		pgoff_t end, struct pagevec *pvec, pgoff_t *indices);
 unsigned find_get_pages_range(struct address_space *mapping, pgoff_t *start,
 			pgoff_t end, unsigned int nr_pages,
 			struct page **pages);
--- a/mm/filemap.c~mm-filemap-return-only-head-pages-from-find_get_entries
+++ a/mm/filemap.c
@@ -1878,49 +1878,29 @@ reset:
  * the mapping.  The entries are placed in @pvec.  find_get_entries()
  * takes a reference on any actual pages it returns.
  *
- * The search returns a group of mapping-contiguous page cache entries
- * with ascending indexes.  There may be holes in the indices due to
- * not-present pages.
+ * The entries have ascending indexes.  The indices may not be consecutive
+ * due to not-present entries or THPs.
  *
  * Any shadow entries of evicted pages, or swap entries from
  * shmem/tmpfs, are included in the returned array.
  *
- * If it finds a Transparent Huge Page, head or tail, find_get_entries()
- * stops at that page: the caller is likely to have a better way to handle
- * the compound page as a whole, and then skip its extent, than repeatedly
- * calling find_get_entries() to return all its tails.
- *
- * Return: the number of pages and shadow entries which were found.
+ * Return: The number of entries which were found.
  */
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
 		pgoff_t end, struct pagevec *pvec, pgoff_t *indices)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
-	unsigned int ret = 0;
-	unsigned nr_entries = PAGEVEC_SIZE;
 
 	rcu_read_lock();
 	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
-		/*
-		 * Terminate early on finding a THP, to allow the caller to
-		 * handle it all at once; but continue if this is hugetlbfs.
-		 */
-		if (!xa_is_value(page) && PageTransHuge(page) &&
-				!PageHuge(page)) {
-			page = find_subpage(page, xas.xa_index);
-			nr_entries = ret + 1;
-		}
-
-		indices[ret] = xas.xa_index;
-		pvec->pages[ret] = page;
-		if (++ret == nr_entries)
+		indices[pvec->nr] = xas.xa_index;
+		if (!pagevec_add(pvec, page))
 			break;
 	}
 	rcu_read_unlock();
 
-	pvec->nr = ret;
-	return ret;
+	return pagevec_count(pvec);
 }
 
 /**
@@ -1939,8 +1919,8 @@ unsigned find_get_entries(struct address
  * not returned.
  *
  * The entries have ascending indexes.  The indices may not be consecutive
- * due to not-present entries, THP pages, pages which could not be locked
- * or pages under writeback.
+ * due to not-present entries, THPs, pages which could not be locked or
+ * pages under writeback.
  *
  * Return: The number of entries which were found.
  */
--- a/mm/internal.h~mm-filemap-return-only-head-pages-from-find_get_entries
+++ a/mm/internal.h
@@ -60,6 +60,8 @@ static inline void force_page_cache_read
 	force_page_cache_ra(&ractl, &file->f_ra, nr_to_read);
 }
 
+unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
+		pgoff_t end, struct pagevec *pvec, pgoff_t *indices);
 unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 		pgoff_t end, struct pagevec *pvec, pgoff_t *indices);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch
mm-fix-madvise-willneed-performance-problem.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-mapping_seek_hole_data.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

