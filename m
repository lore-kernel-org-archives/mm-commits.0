Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07853C3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 05:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjANFZo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjANFZ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 00:25:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59EA3A85
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 21:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 515CB60AFC
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 05:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CA9C433D2;
        Sat, 14 Jan 2023 05:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673673927;
        bh=aDz1liYbhemYseNBjlhEc11v6fSFeRG0sXflFJn28wo=;
        h=Date:To:From:Subject:From;
        b=I0/9scrLSO+EfzAKIJPvPkq+u9axWCfvMF0Me5N0ySYTWFJtyWAx/vUzAlk/SkWQz
         qHwg3oqj4f1UsAEm1MQAF2EYXep/pAl5igWc9fZgCu33YTxiBQp3v8dZU7TeGe0OrN
         pxcgNWD07kN42wL6YBWNb1thWPyIRUVWJx9wUch0=
Date:   Fri, 13 Jan 2023 21:25:27 -0800
To:     mm-commits@vger.kernel.org, jlayton@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ceph-convert-ceph_writepages_start-to-use-filemap_get_folios_tag.patch added to mm-unstable branch
Message-Id: <20230114052527.A8CA9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ceph: convert ceph_writepages_start() to use filemap_get_folios_tag()
has been added to the -mm mm-unstable branch.  Its filename is
     ceph-convert-ceph_writepages_start-to-use-filemap_get_folios_tag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ceph-convert-ceph_writepages_start-to-use-filemap_get_folios_tag.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: ceph: convert ceph_writepages_start() to use filemap_get_folios_tag()
Date: Wed, 4 Jan 2023 13:14:33 -0800

Convert function to use a folio_batch instead of pagevec.  This is in
preparation for the removal of find_get_pages_range_tag().

Also some minor renaming for consistency.

Link: https://lkml.kernel.org/r/20230104211448.4804-9-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/ceph/addr.c~ceph-convert-ceph_writepages_start-to-use-filemap_get_folios_tag
+++ a/fs/ceph/addr.c
@@ -792,7 +792,7 @@ static int ceph_writepages_start(struct
 	struct ceph_vino vino = ceph_vino(inode);
 	pgoff_t index, start_index, end = -1;
 	struct ceph_snap_context *snapc = NULL, *last_snapc = NULL, *pgsnapc;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	int rc = 0;
 	unsigned int wsize = i_blocksize(inode);
 	struct ceph_osd_request *req = NULL;
@@ -821,7 +821,7 @@ static int ceph_writepages_start(struct
 	if (fsc->mount_options->wsize < wsize)
 		wsize = fsc->mount_options->wsize;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 
 	start_index = wbc->range_cyclic ? mapping->writeback_index : 0;
 	index = start_index;
@@ -869,7 +869,7 @@ retry:
 
 	while (!done && index <= end) {
 		int num_ops = 0, op_idx;
-		unsigned i, pvec_pages, max_pages, locked_pages = 0;
+		unsigned i, nr_folios, max_pages, locked_pages = 0;
 		struct page **pages = NULL, **data_pages;
 		struct page *page;
 		pgoff_t strip_unit_end = 0;
@@ -879,13 +879,13 @@ retry:
 		max_pages = wsize >> PAGE_SHIFT;
 
 get_more_pages:
-		pvec_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
-						end, PAGECACHE_TAG_DIRTY);
-		dout("pagevec_lookup_range_tag got %d\n", pvec_pages);
-		if (!pvec_pages && !locked_pages)
+		nr_folios = filemap_get_folios_tag(mapping, &index,
+				end, PAGECACHE_TAG_DIRTY, &fbatch);
+		dout("pagevec_lookup_range_tag got %d\n", nr_folios);
+		if (!nr_folios && !locked_pages)
 			break;
-		for (i = 0; i < pvec_pages && locked_pages < max_pages; i++) {
-			page = pvec.pages[i];
+		for (i = 0; i < nr_folios && locked_pages < max_pages; i++) {
+			page = &fbatch.folios[i]->page;
 			dout("? %p idx %lu\n", page, page->index);
 			if (locked_pages == 0)
 				lock_page(page);  /* first page */
@@ -995,7 +995,7 @@ get_more_pages:
 				len = 0;
 			}
 
-			/* note position of first page in pvec */
+			/* note position of first page in fbatch */
 			dout("%p will write page %p idx %lu\n",
 			     inode, page, page->index);
 
@@ -1005,30 +1005,30 @@ get_more_pages:
 				fsc->write_congested = true;
 
 			pages[locked_pages++] = page;
-			pvec.pages[i] = NULL;
+			fbatch.folios[i] = NULL;
 
 			len += thp_size(page);
 		}
 
 		/* did we get anything? */
 		if (!locked_pages)
-			goto release_pvec_pages;
+			goto release_folios;
 		if (i) {
 			unsigned j, n = 0;
-			/* shift unused page to beginning of pvec */
-			for (j = 0; j < pvec_pages; j++) {
-				if (!pvec.pages[j])
+			/* shift unused page to beginning of fbatch */
+			for (j = 0; j < nr_folios; j++) {
+				if (!fbatch.folios[j])
 					continue;
 				if (n < j)
-					pvec.pages[n] = pvec.pages[j];
+					fbatch.folios[n] = fbatch.folios[j];
 				n++;
 			}
-			pvec.nr = n;
+			fbatch.nr = n;
 
-			if (pvec_pages && i == pvec_pages &&
+			if (nr_folios && i == nr_folios &&
 			    locked_pages < max_pages) {
-				dout("reached end pvec, trying for more\n");
-				pagevec_release(&pvec);
+				dout("reached end fbatch, trying for more\n");
+				folio_batch_release(&fbatch);
 				goto get_more_pages;
 			}
 		}
@@ -1164,10 +1164,10 @@ new_request:
 		if (wbc->nr_to_write <= 0 && wbc->sync_mode == WB_SYNC_NONE)
 			done = true;
 
-release_pvec_pages:
-		dout("pagevec_release on %d pages (%p)\n", (int)pvec.nr,
-		     pvec.nr ? pvec.pages[0] : NULL);
-		pagevec_release(&pvec);
+release_folios:
+		dout("folio_batch release on %d folios (%p)\n", (int)fbatch.nr,
+		     fbatch.nr ? fbatch.folios[0] : NULL);
+		folio_batch_release(&fbatch);
 	}
 
 	if (should_loop && !done) {
@@ -1184,15 +1184,17 @@ release_pvec_pages:
 			unsigned i, nr;
 			index = 0;
 			while ((index <= end) &&
-			       (nr = pagevec_lookup_tag(&pvec, mapping, &index,
-						PAGECACHE_TAG_WRITEBACK))) {
+			       (nr = filemap_get_folios_tag(mapping, &index,
+						(pgoff_t)-1,
+						PAGECACHE_TAG_WRITEBACK,
+						&fbatch))) {
 				for (i = 0; i < nr; i++) {
-					page = pvec.pages[i];
+					page = &fbatch.folios[i]->page;
 					if (page_snap_context(page) != snapc)
 						continue;
 					wait_on_page_writeback(page);
 				}
-				pagevec_release(&pvec);
+				folio_batch_release(&fbatch);
 				cond_resched();
 			}
 		}
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-add-vm_normal_folio.patch
madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch
mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch
ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch
mm-khugepaged-introduce-release_pte_folio-to-replace-release_pte_page.patch
mm-khugepaged-convert-release_pte_pages-to-use-folios.patch
pagemap-add-filemap_grab_folio.patch
filemap-added-filemap_get_folios_tag.patch
filemap-convert-__filemap_fdatawait_range-to-use-filemap_get_folios_tag.patch
page-writeback-convert-write_cache_pages-to-use-filemap_get_folios_tag.patch
afs-convert-afs_writepages_region-to-use-filemap_get_folios_tag.patch
btrfs-convert-btree_write_cache_pages-to-use-filemap_get_folio_tag.patch
btrfs-convert-extent_write_cache_pages-to-use-filemap_get_folios_tag.patch
ceph-convert-ceph_writepages_start-to-use-filemap_get_folios_tag.patch
cifs-convert-wdata_alloc_and_fillpages-to-use-filemap_get_folios_tag.patch
ext4-convert-mpage_prepare_extent_to_map-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_fsync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_flush_inline_data-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_node_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_write_cache_pages-to-use-filemap_get_folios_tag.patch
f2fs-convert-last_fsync_dnode-to-use-filemap_get_folios_tag.patch
f2fs-convert-f2fs_sync_meta_pages-to-use-filemap_get_folios_tag.patch
gfs2-convert-gfs2_write_cache_jdata-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_lookup_dirty_node_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_btree_lookup_dirty_buffers-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_copy_dirty_pages-to-use-filemap_get_folios_tag.patch
nilfs2-convert-nilfs_clear_dirty_pages-to-use-filemap_get_folios_tag.patch
filemap-remove-find_get_pages_range_tag.patch

