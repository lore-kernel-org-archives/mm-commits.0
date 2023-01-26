Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FFEC54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjAZXCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbjAZXCl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:02:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1944953986
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:02:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B526B81DE6
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264F5C4339B;
        Thu, 26 Jan 2023 23:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674774156;
        bh=MmYZt/m4IChYHl+YfXeSyJ6YCaYSc/9zCi4ClUDbAt8=;
        h=Date:To:From:Subject:From;
        b=aHLTEUqaz6XumZCX8wKIeEgeD7ELEcVUBPWAVPRrYPc6k/t/r4CG8CSSQXaD8FGOy
         DNPxy+BkTxYxekX5LP3D3Ppv+iMp5xme6ABESElImdKG0oZ1L1go3KaJdBGHmNlo1g
         aGPVtkgefpPIkScV6CAI6Bjtl8jkCk00FrtTIPPA=
Date:   Thu, 26 Jan 2023 15:02:35 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-convert-writepage_t-callback-to-pass-a-folio.patch added to mm-unstable branch
Message-Id: <20230126230236.264F5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: convert writepage_t callback to pass a folio
has been added to the -mm mm-unstable branch.  Its filename is
     fs-convert-writepage_t-callback-to-pass-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-convert-writepage_t-callback-to-pass-a-folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: convert writepage_t callback to pass a folio
Date: Thu, 26 Jan 2023 20:12:54 +0000

Patch series "Convert writepage_t to use a folio".

More folioisation.  I split out the mpage work from everything else
because it completely dominated the patch, but some implementations I just
converted outright.


This patch (of 2):

We always write back an entire folio, but that's currently passed as the
head page.  Convert all filesystems that use write_cache_pages() to expect
a folio instead of a page.

Link: https://lkml.kernel.org/r/20230126201255.1681189-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230126201255.1681189-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c            |    8 ++++----
 fs/ext4/inode.c           |    4 ++--
 fs/ext4/super.c           |    6 +++---
 fs/fuse/file.c            |   18 +++++++++---------
 fs/iomap/buffered-io.c    |    5 ++---
 fs/mpage.c                |    3 ++-
 fs/nfs/write.c            |    7 ++++---
 fs/ntfs3/inode.c          |    6 +++---
 fs/orangefs/inode.c       |   23 +++++++++++------------
 include/linux/writeback.h |    2 +-
 mm/page-writeback.c       |    6 +++---
 11 files changed, 44 insertions(+), 44 deletions(-)

--- a/fs/cifs/file.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/fs/cifs/file.c
@@ -2675,14 +2675,14 @@ wdata_send_pages(struct cifs_writedata *
 static int
 cifs_writepage_locked(struct page *page, struct writeback_control *wbc);
 
-static int cifs_write_one_page(struct page *page, struct writeback_control *wbc,
-		void *data)
+static int cifs_write_one_page(struct folio *folio,
+		struct writeback_control *wbc, void *data)
 {
 	struct address_space *mapping = data;
 	int ret;
 
-	ret = cifs_writepage_locked(page, wbc);
-	unlock_page(page);
+	ret = cifs_writepage_locked(&folio->page, wbc);
+	folio_unlock(folio);
 	mapping_set_error(mapping, ret);
 	return ret;
 }
--- a/fs/ext4/inode.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/fs/ext4/inode.c
@@ -2711,10 +2711,10 @@ out:
 	return err;
 }
 
-static int ext4_writepage_cb(struct page *page, struct writeback_control *wbc,
+static int ext4_writepage_cb(struct folio *folio, struct writeback_control *wbc,
 			     void *data)
 {
-	return ext4_writepage(page, wbc);
+	return ext4_writepage(&folio->page, wbc);
 }
 
 static int ext4_do_writepages(struct mpage_da_data *mpd)
--- a/fs/ext4/super.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/fs/ext4/super.c
@@ -482,7 +482,7 @@ static void ext4_journal_commit_callback
  *
  * However, we may have to redirty a page (see below.)
  */
-static int ext4_journalled_writepage_callback(struct page *page,
+static int ext4_journalled_writepage_callback(struct folio *folio,
 					      struct writeback_control *wbc,
 					      void *data)
 {
@@ -490,7 +490,7 @@ static int ext4_journalled_writepage_cal
 	struct buffer_head *bh, *head;
 	struct journal_head *jh;
 
-	bh = head = page_buffers(page);
+	bh = head = folio_buffers(folio);
 	do {
 		/*
 		 * We have to redirty a page in these cases:
@@ -509,7 +509,7 @@ static int ext4_journalled_writepage_cal
 		if (buffer_dirty(bh) ||
 		    (jh && (jh->b_transaction != transaction ||
 			    jh->b_next_transaction))) {
-			redirty_page_for_writepage(wbc, page);
+			folio_redirty_for_writepage(wbc, folio);
 			goto out;
 		}
 	} while ((bh = bh->b_this_page) != head);
--- a/fs/fuse/file.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/fs/fuse/file.c
@@ -2184,7 +2184,7 @@ static bool fuse_writepage_need_send(str
 	return false;
 }
 
-static int fuse_writepages_fill(struct page *page,
+static int fuse_writepages_fill(struct folio *folio,
 		struct writeback_control *wbc, void *_data)
 {
 	struct fuse_fill_wb_data *data = _data;
@@ -2203,7 +2203,7 @@ static int fuse_writepages_fill(struct p
 			goto out_unlock;
 	}
 
-	if (wpa && fuse_writepage_need_send(fc, page, ap, data)) {
+	if (wpa && fuse_writepage_need_send(fc, &folio->page, ap, data)) {
 		fuse_writepages_send(data);
 		data->wpa = NULL;
 	}
@@ -2238,7 +2238,7 @@ static int fuse_writepages_fill(struct p
 		data->max_pages = 1;
 
 		ap = &wpa->ia.ap;
-		fuse_write_args_fill(&wpa->ia, data->ff, page_offset(page), 0);
+		fuse_write_args_fill(&wpa->ia, data->ff, folio_pos(folio), 0);
 		wpa->ia.write.in.write_flags |= FUSE_WRITE_CACHE;
 		wpa->next = NULL;
 		ap->args.in_pages = true;
@@ -2246,13 +2246,13 @@ static int fuse_writepages_fill(struct p
 		ap->num_pages = 0;
 		wpa->inode = inode;
 	}
-	set_page_writeback(page);
+	folio_start_writeback(folio);
 
-	copy_highpage(tmp_page, page);
+	copy_highpage(tmp_page, &folio->page);
 	ap->pages[ap->num_pages] = tmp_page;
 	ap->descs[ap->num_pages].offset = 0;
 	ap->descs[ap->num_pages].length = PAGE_SIZE;
-	data->orig_pages[ap->num_pages] = page;
+	data->orig_pages[ap->num_pages] = &folio->page;
 
 	inc_wb_stat(&inode_to_bdi(inode)->wb, WB_WRITEBACK);
 	inc_node_page_state(tmp_page, NR_WRITEBACK_TEMP);
@@ -2266,13 +2266,13 @@ static int fuse_writepages_fill(struct p
 		spin_lock(&fi->lock);
 		ap->num_pages++;
 		spin_unlock(&fi->lock);
-	} else if (fuse_writepage_add(wpa, page)) {
+	} else if (fuse_writepage_add(wpa, &folio->page)) {
 		data->wpa = wpa;
 	} else {
-		end_page_writeback(page);
+		folio_end_writeback(folio);
 	}
 out_unlock:
-	unlock_page(page);
+	folio_unlock(folio);
 
 	return err;
 }
--- a/fs/iomap/buffered-io.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/fs/iomap/buffered-io.c
@@ -1685,10 +1685,9 @@ done:
  * For unwritten space on the page, we need to start the conversion to
  * regular allocated space.
  */
-static int
-iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
+static int iomap_do_writepage(struct folio *folio,
+		struct writeback_control *wbc, void *data)
 {
-	struct folio *folio = page_folio(page);
 	struct iomap_writepage_ctx *wpc = data;
 	struct inode *inode = folio->mapping->host;
 	u64 end_pos, isize;
--- a/fs/mpage.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/fs/mpage.c
@@ -440,9 +440,10 @@ void clean_page_buffers(struct page *pag
 	clean_buffers(page, ~0U);
 }
 
-static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
+static int __mpage_writepage(struct folio *folio, struct writeback_control *wbc,
 		      void *data)
 {
+	struct page *page = &folio->page;
 	struct mpage_data *mpd = data;
 	struct bio *bio = mpd->bio;
 	struct address_space *mapping = page->mapping;
--- a/fs/nfs/write.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/fs/nfs/write.c
@@ -689,13 +689,14 @@ int nfs_writepage(struct page *page, str
 	return ret;
 }
 
-static int nfs_writepages_callback(struct page *page, struct writeback_control *wbc, void *data)
+static int nfs_writepages_callback(struct folio *folio,
+		struct writeback_control *wbc, void *data)
 {
 	int ret;
 
-	ret = nfs_do_writepage(page, wbc, data);
+	ret = nfs_do_writepage(&folio->page, wbc, data);
 	if (ret != AOP_WRITEPAGE_ACTIVATE)
-		unlock_page(page);
+		folio_unlock(folio);
 	return ret;
 }
 
--- a/fs/ntfs3/inode.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/fs/ntfs3/inode.c
@@ -832,7 +832,7 @@ out:
 	return err;
 }
 
-static int ntfs_resident_writepage(struct page *page,
+static int ntfs_resident_writepage(struct folio *folio,
 		struct writeback_control *wbc, void *data)
 {
 	struct address_space *mapping = data;
@@ -840,11 +840,11 @@ static int ntfs_resident_writepage(struc
 	int ret;
 
 	ni_lock(ni);
-	ret = attr_data_write_resident(ni, page);
+	ret = attr_data_write_resident(ni, &folio->page);
 	ni_unlock(ni);
 
 	if (ret != E_NTFS_NONRESIDENT)
-		unlock_page(page);
+		folio_unlock(folio);
 	mapping_set_error(mapping, ret);
 	return ret;
 }
--- a/fs/orangefs/inode.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/fs/orangefs/inode.c
@@ -154,21 +154,20 @@ static int orangefs_writepages_work(stru
 	return ret;
 }
 
-static int orangefs_writepages_callback(struct page *page,
-    struct writeback_control *wbc, void *data)
+static int orangefs_writepages_callback(struct folio *folio,
+		struct writeback_control *wbc, void *data)
 {
 	struct orangefs_writepages *ow = data;
-	struct orangefs_write_range *wr;
+	struct orangefs_write_range *wr = folio->private;
 	int ret;
 
-	if (!PagePrivate(page)) {
-		unlock_page(page);
+	if (!wr) {
+		folio_unlock(folio);
 		/* It's not private so there's nothing to write, right? */
 		printk("writepages_callback not private!\n");
 		BUG();
 		return 0;
 	}
-	wr = (struct orangefs_write_range *)page_private(page);
 
 	ret = -1;
 	if (ow->npages == 0) {
@@ -176,7 +175,7 @@ static int orangefs_writepages_callback(
 		ow->len = wr->len;
 		ow->uid = wr->uid;
 		ow->gid = wr->gid;
-		ow->pages[ow->npages++] = page;
+		ow->pages[ow->npages++] = &folio->page;
 		ret = 0;
 		goto done;
 	}
@@ -188,7 +187,7 @@ static int orangefs_writepages_callback(
 	}
 	if (ow->off + ow->len == wr->pos) {
 		ow->len += wr->len;
-		ow->pages[ow->npages++] = page;
+		ow->pages[ow->npages++] = &folio->page;
 		ret = 0;
 		goto done;
 	}
@@ -198,10 +197,10 @@ done:
 			orangefs_writepages_work(ow, wbc);
 			ow->npages = 0;
 		}
-		ret = orangefs_writepage_locked(page, wbc);
-		mapping_set_error(page->mapping, ret);
-		unlock_page(page);
-		end_page_writeback(page);
+		ret = orangefs_writepage_locked(&folio->page, wbc);
+		mapping_set_error(folio->mapping, ret);
+		folio_unlock(folio);
+		folio_end_writeback(folio);
 	} else {
 		if (ow->npages == ow->maxpages) {
 			orangefs_writepages_work(ow, wbc);
--- a/include/linux/writeback.h~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/include/linux/writeback.h
@@ -366,7 +366,7 @@ int balance_dirty_pages_ratelimited_flag
 
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
 
-typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
+typedef int (*writepage_t)(struct folio *folio, struct writeback_control *wbc,
 				void *data);
 
 void tag_pages_for_writeback(struct address_space *mapping,
--- a/mm/page-writeback.c~fs-convert-writepage_t-callback-to-pass-a-folio
+++ a/mm/page-writeback.c
@@ -2470,7 +2470,7 @@ continue_unlock:
 				goto continue_unlock;
 
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
-			error = writepage(&folio->page, wbc, data);
+			error = writepage(folio, wbc, data);
 			if (unlikely(error)) {
 				/*
 				 * Handle errors according to the type of
@@ -2528,11 +2528,11 @@ continue_unlock:
 }
 EXPORT_SYMBOL(write_cache_pages);
 
-static int writepage_cb(struct page *page, struct writeback_control *wbc,
+static int writepage_cb(struct folio *folio, struct writeback_control *wbc,
 		void *data)
 {
 	struct address_space *mapping = data;
-	int ret = mapping->a_ops->writepage(page, wbc);
+	int ret = mapping->a_ops->writepage(&folio->page, wbc);
 	mapping_set_error(mapping, ret);
 	return ret;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch
rmap-add-folio-parameter-to-__page_set_anon_rmap.patch
filemap-convert-filemap_map_pmd-to-take-a-folio.patch
filemap-convert-filemap_range_has_page-to-use-a-folio.patch
readahead-convert-readahead_expand-to-use-a-folio.patch
mm-add-memcpy_from_file_folio.patch
fs-convert-writepage_t-callback-to-pass-a-folio.patch
mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch

