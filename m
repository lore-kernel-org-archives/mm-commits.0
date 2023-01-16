Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996EFC678D4
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjAPUF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjAPUFx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:05:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE17234DE
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABF306111C
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECE1C433D2;
        Mon, 16 Jan 2023 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899551;
        bh=shwVLCBAn2h3xwReKoIWQCJQYuvU7YJAoxgcO8JjFNc=;
        h=Date:To:From:Subject:From;
        b=lF6dq01z9ADCcU5q63z5ItFWVivdMUprZTnWADDLORF1PooUSLSUFs+T7ShycJiFH
         DcslcxfMR0bwfFD+7rJUBFvo4OmlAuDsBBm2uusPd0BTvi2PDc2fR1uRldmcOCkL6B
         pWEeTV3Gnknn9m2Yyic1gazHz9w+VzbrxwYco9fE=
Date:   Mon, 16 Jan 2023 12:05:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fs-convert-inode_attach_wb-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230116200551.0ECE1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fs: convert inode_attach_wb() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fs-convert-inode_attach_wb-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fs-convert-inode_attach_wb-to-take-a-folio.patch

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
Subject: mm/fs: convert inode_attach_wb() to take a folio
Date: Mon, 16 Jan 2023 19:25:06 +0000

Patch series "Writeback folio conversions".

Remove more calls to compound_head() by passing folios around instead of
pages.


This patch (of 2):

The only caller of inode_attach_wb() which doesn't pass NULL already has a
folio, so convert the whole call-chain to take folios.

Link: https://lkml.kernel.org/r/20230116192507.2146150-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230116192507.2146150-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/fs-writeback.c~mm-fs-convert-inode_attach_wb-to-take-a-folio
+++ a/fs/fs-writeback.c
@@ -237,7 +237,7 @@ void wb_wait_for_completion(struct wb_co
 static atomic_t isw_nr_in_flight = ATOMIC_INIT(0);
 static struct workqueue_struct *isw_wq;
 
-void __inode_attach_wb(struct inode *inode, struct page *page)
+void __inode_attach_wb(struct inode *inode, struct folio *folio)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct bdi_writeback *wb = NULL;
@@ -245,8 +245,8 @@ void __inode_attach_wb(struct inode *ino
 	if (inode_cgwb_enabled(inode)) {
 		struct cgroup_subsys_state *memcg_css;
 
-		if (page) {
-			memcg_css = mem_cgroup_css_from_page(page);
+		if (folio) {
+			memcg_css = mem_cgroup_css_from_page(&folio->page);
 			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
 		} else {
 			/* must pin memcg_css, see wb_get_create() */
--- a/include/linux/writeback.h~mm-fs-convert-inode_attach_wb-to-take-a-folio
+++ a/include/linux/writeback.h
@@ -207,7 +207,7 @@ static inline void wait_on_inode(struct
 #include <linux/cgroup.h>
 #include <linux/bio.h>
 
-void __inode_attach_wb(struct inode *inode, struct page *page);
+void __inode_attach_wb(struct inode *inode, struct folio *folio);
 void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
 				 struct inode *inode)
 	__releases(&inode->i_lock);
@@ -222,16 +222,16 @@ bool cleanup_offline_cgwb(struct bdi_wri
 /**
  * inode_attach_wb - associate an inode with its wb
  * @inode: inode of interest
- * @page: page being dirtied (may be NULL)
+ * @folio: folio being dirtied (may be NULL)
  *
  * If @inode doesn't have its wb, associate it with the wb matching the
- * memcg of @page or, if @page is NULL, %current.  May be called w/ or w/o
+ * memcg of @folio or, if @folio is NULL, %current.  May be called w/ or w/o
  * @inode->i_lock.
  */
-static inline void inode_attach_wb(struct inode *inode, struct page *page)
+static inline void inode_attach_wb(struct inode *inode, struct folio *folio)
 {
 	if (!inode->i_wb)
-		__inode_attach_wb(inode, page);
+		__inode_attach_wb(inode, folio);
 }
 
 /**
@@ -290,7 +290,7 @@ static inline void wbc_init_bio(struct w
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
-static inline void inode_attach_wb(struct inode *inode, struct page *page)
+static inline void inode_attach_wb(struct inode *inode, struct folio *folio)
 {
 }
 
--- a/mm/page-writeback.c~mm-fs-convert-inode_attach_wb-to-take-a-folio
+++ a/mm/page-writeback.c
@@ -2652,7 +2652,7 @@ static void folio_account_dirtied(struct
 		struct bdi_writeback *wb;
 		long nr = folio_nr_pages(folio);
 
-		inode_attach_wb(inode, &folio->page);
+		inode_attach_wb(inode, folio);
 		wb = inode_to_wb(inode);
 
 		__lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch
mm-memcg-add-folio_memcg_check.patch
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

