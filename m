Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B25DC63697
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BDBD22276
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3Zyx+Ym"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgKNBpv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:45:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgKNBpv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:45:51 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7E2622273;
        Sat, 14 Nov 2020 01:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318350;
        bh=M8I13GMZvBrl/vneo5UP94cYKXk7ZhaUd+I7HtfUGk8=;
        h=Date:From:To:Subject:From;
        b=f3Zyx+Ymtg0NMCw0jykWakxw9b/X44X5Ok2ntLuxvaHi7twlTXwdpQlfE5SA+ye5B
         9jZSCtNc67DU63AkaoltGVudIUGwDPNuA6wL6PyT282GY0pNejUhOWHkvnvieJqrFO
         3+vLqhFsXmNXKAZTMjqXQYLSZxf+FvROPfEfPlDs=
Date:   Fri, 13 Nov 2020 17:45:49 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  + mm-pass-pvec-directly-to-find_get_entries.patch added
 to -mm tree
Message-ID: <20201114014549.I4t4L_mzo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pass pvec directly to find_get_entries
has been added to the -mm tree.  Its filename is
     mm-pass-pvec-directly-to-find_get_entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-pass-pvec-directly-to-find_get_entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-pass-pvec-directly-to-find_get_entries.patch

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
@@ -1871,14 +1871,12 @@ reset:
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
@@ -1895,15 +1893,12 @@ reset:
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
@@ -1918,11 +1913,13 @@ unsigned find_get_entries(struct address
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
@@ -1102,9 +1102,7 @@ unsigned pagevec_lookup_entries(struct p
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

