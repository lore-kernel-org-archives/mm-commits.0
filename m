Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13673C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjASBUP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjASBS0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7786D6C555
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CE09B81FBD
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE064C433F0;
        Thu, 19 Jan 2023 01:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090950;
        bh=ueKYTSD76DODU0zvaiWcUpML2uASoOY4b1+EQmG0VAI=;
        h=Date:To:From:Subject:From;
        b=tbNMlwkgR/qW3SSccyJpupQuEKetoigCVgqviUzqr8712gp5WOSKXo2+wEExrK0Yt
         ub94Y7eAspJhGygfHET+FWv+npHgbxTUso3tG2nj58u0UmuQdFdlSRXyuYYCL612QM
         t9tXwpYD3542qiDvnZOIVPiQZLlfbogr5WvC7fLs=
Date:   Wed, 18 Jan 2023 17:15:50 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-add-folio_memcg_check.patch removed from -mm tree
Message-Id: <20230119011550.BE064C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: add folio_memcg_check()
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-folio_memcg_check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm: memcg: add folio_memcg_check()
Date: Fri, 30 Dec 2022 15:08:42 +0800

Patch series "mm: convert page_idle/damon to use folios", v4.


This patch (of 8):

Convert page_memcg_check() into folio_memcg_check() and add a
page_memcg_check() wrapper.  The behaviour of page_memcg_check() is
unchanged; tail pages always had a NULL ->memcg_data.

Link: https://lkml.kernel.org/r/20221230070849.63358-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20221230070849.63358-2-wangkefeng.wang@huawei.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   40 ++++++++++++++++++++++-------------
 mm/memcontrol.c            |    6 ++---
 2 files changed, 29 insertions(+), 17 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-add-folio_memcg_check
+++ a/include/linux/memcontrol.h
@@ -466,34 +466,34 @@ static inline struct mem_cgroup *folio_m
 }
 
 /*
- * page_memcg_check - get the memory cgroup associated with a page
- * @page: a pointer to the page struct
+ * folio_memcg_check - Get the memory cgroup associated with a folio.
+ * @folio: Pointer to the folio.
  *
- * Returns a pointer to the memory cgroup associated with the page,
- * or NULL. This function unlike page_memcg() can take any page
- * as an argument. It has to be used in cases when it's not known if a page
+ * Returns a pointer to the memory cgroup associated with the folio,
+ * or NULL. This function unlike folio_memcg() can take any folio
+ * as an argument. It has to be used in cases when it's not known if a folio
  * has an associated memory cgroup pointer or an object cgroups vector or
  * an object cgroup.
  *
- * For a non-kmem page any of the following ensures page and memcg binding
+ * For a non-kmem folio any of the following ensures folio and memcg binding
  * stability:
  *
- * - the page lock
+ * - the folio lock
  * - LRU isolation
- * - lock_page_memcg()
+ * - lock_folio_memcg()
  * - exclusive reference
  * - mem_cgroup_trylock_pages()
  *
- * For a kmem page a caller should hold an rcu read lock to protect memcg
- * associated with a kmem page from being released.
+ * For a kmem folio a caller should hold an rcu read lock to protect memcg
+ * associated with a kmem folio from being released.
  */
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 {
 	/*
-	 * Because page->memcg_data might be changed asynchronously
-	 * for slab pages, READ_ONCE() should be used here.
+	 * Because folio->memcg_data might be changed asynchronously
+	 * for slabs, READ_ONCE() should be used here.
 	 */
-	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+	unsigned long memcg_data = READ_ONCE(folio->memcg_data);
 
 	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
@@ -508,6 +508,13 @@ static inline struct mem_cgroup *page_me
 	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
+static inline struct mem_cgroup *page_memcg_check(struct page *page)
+{
+	if (PageTail(page))
+		return NULL;
+	return folio_memcg_check((struct folio *)page);
+}
+
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
@@ -1170,6 +1177,11 @@ static inline struct mem_cgroup *folio_m
 	return NULL;
 }
 
+static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+{
+	return NULL;
+}
+
 static inline struct mem_cgroup *page_memcg_check(struct page *page)
 {
 	return NULL;
--- a/mm/memcontrol.c~mm-memcg-add-folio_memcg_check
+++ a/mm/memcontrol.c
@@ -2952,13 +2952,13 @@ struct mem_cgroup *mem_cgroup_from_obj_f
 	}
 
 	/*
-	 * page_memcg_check() is used here, because in theory we can encounter
+	 * folio_memcg_check() is used here, because in theory we can encounter
 	 * a folio where the slab flag has been cleared already, but
 	 * slab->memcg_data has not been freed yet
-	 * page_memcg_check(page) will guarantee that a proper memory
+	 * folio_memcg_check() will guarantee that a proper memory
 	 * cgroup pointer or NULL will be returned.
 	 */
-	return page_memcg_check(folio_page(folio, 0));
+	return folio_memcg_check(folio);
 }
 
 /*
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

