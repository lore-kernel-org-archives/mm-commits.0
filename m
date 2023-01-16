Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED498C54EBE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjAPUF7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjAPUF5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:05:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED5C23DB0
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:05:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99128B8109B
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F315C433D2;
        Mon, 16 Jan 2023 20:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899553;
        bh=FsqlV7BckKHv8TdaAe/C9ZyhIeYOq2hqaVH7CiYCAAQ=;
        h=Date:To:From:Subject:From;
        b=yYYhNF6KOFrgPr4D3kRtcY8ftktHMBwfXJRz9yXgeb7GuE6PjRt4M3yUkiCk4aRdd
         OYpzH1xlW+L1OdyuMRFEFlqtJWGLH7eI3esaTjhRHWkzUTJ3QPhJyjuJ0mMs7B0DTW
         8CECCD0IMIyekRt7hVVKSlPHKK1jPOUHpRJIGVEo=
Date:   Mon, 16 Jan 2023 12:05:52 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch added to mm-unstable branch
Message-Id: <20230116200553.3F315C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert mem_cgroup_css_from_page() to mem_cgroup_css_from_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch

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
Subject: mm: convert mem_cgroup_css_from_page() to mem_cgroup_css_from_folio()
Date: Mon, 16 Jan 2023 19:25:07 +0000

Only one caller doesn't have a folio, so move the page_folio() call to
that one caller from mem_cgroup_css_from_folio().

Link: https://lkml.kernel.org/r/20230116192507.2146150-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/fs-writeback.c~mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio
+++ a/fs/fs-writeback.c
@@ -246,7 +246,7 @@ void __inode_attach_wb(struct inode *ino
 		struct cgroup_subsys_state *memcg_css;
 
 		if (folio) {
-			memcg_css = mem_cgroup_css_from_page(&folio->page);
+			memcg_css = mem_cgroup_css_from_folio(folio);
 			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
 		} else {
 			/* must pin memcg_css, see wb_get_create() */
@@ -859,6 +859,7 @@ EXPORT_SYMBOL_GPL(wbc_detach_inode);
 void wbc_account_cgroup_owner(struct writeback_control *wbc, struct page *page,
 			      size_t bytes)
 {
+	struct folio *folio;
 	struct cgroup_subsys_state *css;
 	int id;
 
@@ -871,7 +872,8 @@ void wbc_account_cgroup_owner(struct wri
 	if (!wbc->wb || wbc->no_cgroup_owner)
 		return;
 
-	css = mem_cgroup_css_from_page(page);
+	folio = page_folio(page);
+	css = mem_cgroup_css_from_folio(folio);
 	/* dead cgroups shouldn't contribute to inode ownership arbitration */
 	if (!(css->flags & CSS_ONLINE))
 		return;
--- a/include/linux/memcontrol.h~mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio
+++ a/include/linux/memcontrol.h
@@ -890,7 +890,7 @@ static inline bool mm_match_cgroup(struc
 	return match;
 }
 
-struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
+struct cgroup_subsys_state *mem_cgroup_css_from_folio(struct folio *folio);
 ino_t page_cgroup_ino(struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
--- a/mm/memcontrol.c~mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio
+++ a/mm/memcontrol.c
@@ -350,21 +350,19 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
 #endif
 
 /**
- * mem_cgroup_css_from_page - css of the memcg associated with a page
- * @page: page of interest
+ * mem_cgroup_css_from_folio - css of the memcg associated with a folio
+ * @folio: folio of interest
  *
  * If memcg is bound to the default hierarchy, css of the memcg associated
- * with @page is returned.  The returned css remains associated with @page
+ * with @folio is returned.  The returned css remains associated with @folio
  * until it is released.
  *
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
  */
-struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
+struct cgroup_subsys_state *mem_cgroup_css_from_folio(struct folio *folio)
 {
-	struct mem_cgroup *memcg;
-
-	memcg = page_memcg(page);
+	struct mem_cgroup *memcg = folio_memcg(folio);
 
 	if (!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		memcg = root_mem_cgroup;
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

