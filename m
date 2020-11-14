Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2286BC55ABD
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D303A2225D
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjDANCAL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgKNBpO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:45:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKNBpO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:45:14 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0D9A2225F;
        Sat, 14 Nov 2020 01:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318312;
        bh=4LfH+fZYxLFXbxq5KyqMuIW5vMRL2c9KpemR+uBDQ+E=;
        h=Date:From:To:Subject:From;
        b=bjDANCAL0VvHFxHlXsP2/V6eDZ5sXIVA+ksynKiXuMDrXRs97vwucQccyQW9mgonA
         Wqrf/wPoI7V14gEnmJLN0ThUMAsLUXJdvOf7MkaG1bbIMGbAQoIGEeblET/uMcd5f0
         AaQVmpvbj0bdLdEZDGmJpSnFnSkMgsS3pF4nW3xo=
Date:   Fri, 13 Nov 2020 17:45:11 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  +
 mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch added to -mm tree
Message-ID: <20201114014511.QK1byLxmJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: use pagevec_lookup in shmem_unlock_mapping
has been added to the -mm tree.  Its filename is
     mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch

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
Subject: mm/shmem: use pagevec_lookup in shmem_unlock_mapping

The comment shows that the reason for using find_get_entries() is now
stale; find_get_pages() will not return 0 if it hits a consecutive run of
swap entries, and I don't believe it has since 2011.  pagevec_lookup() is
a simpler function to use than find_get_pages(), so use it instead.

Link: https://lkml.kernel.org/r/20201112212641.27837-3-willy@infradead.org
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

 mm/shmem.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping
+++ a/mm/shmem.c
@@ -842,7 +842,6 @@ unsigned long shmem_swap_usage(struct vm
 void shmem_unlock_mapping(struct address_space *mapping)
 {
 	struct pagevec pvec;
-	pgoff_t indices[PAGEVEC_SIZE];
 	pgoff_t index = 0;
 
 	pagevec_init(&pvec);
@@ -850,16 +849,8 @@ void shmem_unlock_mapping(struct address
 	 * Minor point, but we might as well stop if someone else SHM_LOCKs it.
 	 */
 	while (!mapping_unevictable(mapping)) {
-		/*
-		 * Avoid pagevec_lookup(): find_get_pages() returns 0 as if it
-		 * has finished, if it hits a row of PAGEVEC_SIZE swap entries.
-		 */
-		pvec.nr = find_get_entries(mapping, index,
-					   PAGEVEC_SIZE, pvec.pages, indices);
-		if (!pvec.nr)
+		if (!pagevec_lookup(&pvec, mapping, &index))
 			break;
-		index = indices[pvec.nr - 1] + 1;
-		pagevec_remove_exceptionals(&pvec);
 		check_move_unevictable_pages(&pvec);
 		pagevec_release(&pvec);
 		cond_resched();
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

