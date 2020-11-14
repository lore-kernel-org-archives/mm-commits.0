Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA58C63798
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9989022275
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzdfhWu5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgKNBps (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgKNBps (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:45:48 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 062B122274;
        Sat, 14 Nov 2020 01:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318347;
        bh=uUqo+wk8Wt6Qg5osvTM7U+fD/1QjZNqgEihj0fn05Rk=;
        h=Date:From:To:Subject:From;
        b=jzdfhWu5GalcMJ+FiH+wmol0BQ+fX8Qa2p3JmDwX4iPjmBEcDZ+Zgi4Hph2HURZSP
         M/xS+JW91z2Jp4F7znymwuVXjXx09eMEt7BeIvcMCxwdT6Dz/OcKJ0XndHRxzSog7P
         IviZgIpyVnPigO426AHJpUu+fdzzEJvbQkch6wPY=
Date:   Fri, 13 Nov 2020 17:45:46 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  +
 mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch added to
 -mm tree
Message-ID: <20201114014546.dnV71Ah62%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove nr_entries parameter from pagevec_lookup_entries
has been added to the -mm tree.  Its filename is
     mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch

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
Subject: mm: remove nr_entries parameter from pagevec_lookup_entries

All callers want to fetch the full size of the pvec.

Link: https://lkml.kernel.org/r/20201112212641.27837-13-willy@infradead.org
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

 include/linux/pagevec.h |    2 +-
 mm/swap.c               |    4 ++--
 mm/truncate.c           |    5 ++---
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/include/linux/pagevec.h~mm-remove-nr_entries-parameter-from-pagevec_lookup_entries
+++ a/include/linux/pagevec.h
@@ -27,7 +27,7 @@ void __pagevec_release(struct pagevec *p
 void __pagevec_lru_add(struct pagevec *pvec);
 unsigned pagevec_lookup_entries(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t start, pgoff_t end,
-		unsigned nr_entries, pgoff_t *indices);
+		pgoff_t *indices);
 void pagevec_remove_exceptionals(struct pagevec *pvec);
 unsigned pagevec_lookup_range(struct pagevec *pvec,
 			      struct address_space *mapping,
--- a/mm/swap.c~mm-remove-nr_entries-parameter-from-pagevec_lookup_entries
+++ a/mm/swap.c
@@ -1100,9 +1100,9 @@ void __pagevec_lru_add(struct pagevec *p
  */
 unsigned pagevec_lookup_entries(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t start, pgoff_t end,
-		unsigned nr_entries, pgoff_t *indices)
+		pgoff_t *indices)
 {
-	pvec->nr = find_get_entries(mapping, start, end, nr_entries,
+	pvec->nr = find_get_entries(mapping, start, end, PAGEVEC_SIZE,
 				    pvec->pages, indices);
 	return pagevec_count(pvec);
 }
--- a/mm/truncate.c~mm-remove-nr_entries-parameter-from-pagevec_lookup_entries
+++ a/mm/truncate.c
@@ -377,7 +377,7 @@ void truncate_inode_pages_range(struct a
 	for ( ; ; ) {
 		cond_resched();
 		if (!pagevec_lookup_entries(&pvec, mapping, index, end - 1,
-				PAGEVEC_SIZE, indices)) {
+				indices)) {
 			/* If all gone from start onwards, we're done */
 			if (index == start)
 				break;
@@ -632,8 +632,7 @@ int invalidate_inode_pages2_range(struct
 
 	pagevec_init(&pvec);
 	index = start;
-	while (pagevec_lookup_entries(&pvec, mapping, index, end,
-			PAGEVEC_SIZE, indices)) {
+	while (pagevec_lookup_entries(&pvec, mapping, index, end, indices)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
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

