Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450B9C4167B
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 22:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D1A22D50
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 22:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgLDWzx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 17:55:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgLDWzx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 17:55:53 -0500
Date:   Fri, 04 Dec 2020 14:55:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607122512;
        bh=bhILEaaLtH/Pgla4gu3uUeDeUpAmhT1csHQDIANXtQw=;
        h=From:To:Subject:From;
        b=h7Anlxx0FfIc9lW2wf+v/730QTLrN+80GQV9VeoUv71aCsnwwxZhyOTQamTdoPpNL
         KFhnlg3+wERJCnWwjntCXdcOPYYdFfZikGVTdmVTjWO9dsFIBfV+7v86sLp8x2XEWY
         98aeTOzbmTlOZQdDfXYjF0YesPLGrftbqMCoG7ts=
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch removed from -mm
 tree
Message-ID: <20201204225512.KjwbT_ZeB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page kmemcg type to a page memcg flag
has been removed from the -mm tree.  Its filename was
     mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: convert page kmemcg type to a page memcg flag

PageKmemcg flag is currently defined as a page type (like buddy, offline,
table and guard).  Semantically it means that the page was accounted as a
kernel memory by the page allocator and has to be uncharged on the
release.

As a side effect of defining the flag as a page type, the accounted page
can't be mapped to userspace (look at page_has_type() and comments above).
In particular, this blocks the accounting of vmalloc-backed memory used
by some bpf maps, because these maps do map the memory to userspace.

One option is to fix it by complicating the access to page->mapcount,
which provides some free bits for page->page_type.

But it's way better to move this flag into page->memcg_data flags. 
Indeed, the flag makes no sense without enabled memory cgroups and memory
cgroup pointer set in particular.

This commit replaces PageKmemcg() and __SetPageKmemcg() with
PageMemcgKmem() and an open-coded OR operation setting the memcg pointer
with the MEMCG_DATA_KMEM bit.  __ClearPageKmemcg() can be simple deleted,
as the whole memcg_data is zeroed at once.

As a bonus, on !CONFIG_MEMCG build the PageMemcgKmem() check will be
compiled out.

Link: https://lkml.kernel.org/r/20201027001657.3398190-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   37 +++++++++++++++++++++++++++++++----
 include/linux/page-flags.h |   11 +---------
 mm/memcontrol.c            |   16 ++++-----------
 mm/page_alloc.c            |    4 +--
 4 files changed, 42 insertions(+), 26 deletions(-)

--- a/include/linux/memcontrol.h~mm-convert-page-kmemcg-type-to-a-page-memcg-flag
+++ a/include/linux/memcontrol.h
@@ -340,8 +340,10 @@ extern struct mem_cgroup *root_mem_cgrou
 enum page_memcg_data_flags {
 	/* page->memcg_data is a pointer to an objcgs vector */
 	MEMCG_DATA_OBJCGS = (1UL << 0),
+	/* page has been accounted as a non-slab kernel page */
+	MEMCG_DATA_KMEM = (1UL << 1),
 	/* the next bit after the last actual flag */
-	__NR_MEMCG_DATA_FLAGS  = (1UL << 1),
+	__NR_MEMCG_DATA_FLAGS  = (1UL << 2),
 };
 
 #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
@@ -363,8 +365,12 @@ enum page_memcg_data_flags {
  */
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
+	unsigned long memcg_data = page->memcg_data;
+
 	VM_BUG_ON_PAGE(PageSlab(page), page);
-	return (struct mem_cgroup *)page->memcg_data;
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+
+	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
 /*
@@ -381,7 +387,8 @@ static inline struct mem_cgroup *page_me
 	VM_BUG_ON_PAGE(PageSlab(page), page);
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	return (struct mem_cgroup *)READ_ONCE(page->memcg_data);
+	return (struct mem_cgroup *)(READ_ONCE(page->memcg_data) &
+				     ~MEMCG_DATA_FLAGS_MASK);
 }
 
 /*
@@ -410,7 +417,21 @@ static inline struct mem_cgroup *page_me
 	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
 
-	return (struct mem_cgroup *)memcg_data;
+	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+}
+
+/*
+ * PageMemcgKmem - check if the page has MemcgKmem flag set
+ * @page: a pointer to the page struct
+ *
+ * Checks if the page has MemcgKmem flag set. The caller must ensure that
+ * the page has an associated memory cgroup. It's not safe to call this function
+ * against some types of pages, e.g. slab pages.
+ */
+static inline bool PageMemcgKmem(struct page *page)
+{
+	VM_BUG_ON_PAGE(page->memcg_data & MEMCG_DATA_OBJCGS, page);
+	return page->memcg_data & MEMCG_DATA_KMEM;
 }
 
 #ifdef CONFIG_MEMCG_KMEM
@@ -429,6 +450,7 @@ static inline struct obj_cgroup **page_o
 	unsigned long memcg_data = READ_ONCE(page->memcg_data);
 
 	VM_BUG_ON_PAGE(memcg_data && !(memcg_data & MEMCG_DATA_OBJCGS), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
 
 	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
@@ -448,6 +470,8 @@ static inline struct obj_cgroup **page_o
 	if (!memcg_data || !(memcg_data & MEMCG_DATA_OBJCGS))
 		return NULL;
 
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
+
 	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
@@ -1095,6 +1119,11 @@ static inline struct mem_cgroup *page_me
 	return NULL;
 }
 
+static inline bool PageMemcgKmem(struct page *page)
+{
+	return false;
+}
+
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
 	return true;
--- a/include/linux/page-flags.h~mm-convert-page-kmemcg-type-to-a-page-memcg-flag
+++ a/include/linux/page-flags.h
@@ -714,9 +714,8 @@ PAGEFLAG_FALSE(DoubleMap)
 #define PAGE_MAPCOUNT_RESERVE	-128
 #define PG_buddy	0x00000080
 #define PG_offline	0x00000100
-#define PG_kmemcg	0x00000200
-#define PG_table	0x00000400
-#define PG_guard	0x00000800
+#define PG_table	0x00000200
+#define PG_guard	0x00000400
 
 #define PageType(page, flag)						\
 	((page->page_type & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
@@ -768,12 +767,6 @@ PAGE_TYPE_OPS(Buddy, buddy)
 PAGE_TYPE_OPS(Offline, offline)
 
 /*
- * If kmemcg is enabled, the buddy allocator will set PageKmemcg() on
- * pages allocated with __GFP_ACCOUNT. It gets cleared on page free.
- */
-PAGE_TYPE_OPS(Kmemcg, kmemcg)
-
-/*
  * Marks pages in use as page tables.
  */
 PAGE_TYPE_OPS(Table, table)
--- a/mm/memcontrol.c~mm-convert-page-kmemcg-type-to-a-page-memcg-flag
+++ a/mm/memcontrol.c
@@ -3192,8 +3192,8 @@ int __memcg_kmem_charge_page(struct page
 	if (memcg && !mem_cgroup_is_root(memcg)) {
 		ret = __memcg_kmem_charge(memcg, gfp, 1 << order);
 		if (!ret) {
-			page->memcg_data = (unsigned long)memcg;
-			__SetPageKmemcg(page);
+			page->memcg_data = (unsigned long)memcg |
+				MEMCG_DATA_KMEM;
 			return 0;
 		}
 		css_put(&memcg->css);
@@ -3218,10 +3218,6 @@ void __memcg_kmem_uncharge_page(struct p
 	__memcg_kmem_uncharge(memcg, nr_pages);
 	page->memcg_data = 0;
 	css_put(&memcg->css);
-
-	/* slab pages do not have PageKmemcg flag set */
-	if (PageKmemcg(page))
-		__ClearPageKmemcg(page);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
@@ -6903,12 +6899,10 @@ static void uncharge_page(struct page *p
 	nr_pages = compound_nr(page);
 	ug->nr_pages += nr_pages;
 
-	if (!PageKmemcg(page)) {
-		ug->pgpgout++;
-	} else {
+	if (PageMemcgKmem(page))
 		ug->nr_kmem += nr_pages;
-		__ClearPageKmemcg(page);
-	}
+	else
+		ug->pgpgout++;
 
 	ug->dummy_page = page;
 	page->memcg_data = 0;
--- a/mm/page_alloc.c~mm-convert-page-kmemcg-type-to-a-page-memcg-flag
+++ a/mm/page_alloc.c
@@ -1223,7 +1223,7 @@ static __always_inline bool free_pages_p
 		 * Do not let hwpoison pages hit pcplists/buddy
 		 * Untie memcg state and reset page's owner
 		 */
-		if (memcg_kmem_enabled() && PageKmemcg(page))
+		if (memcg_kmem_enabled() && PageMemcgKmem(page))
 			__memcg_kmem_uncharge_page(page, order);
 		reset_page_owner(page, order);
 		return false;
@@ -1253,7 +1253,7 @@ static __always_inline bool free_pages_p
 	}
 	if (PageMappingFlags(page))
 		page->mapping = NULL;
-	if (memcg_kmem_enabled() && PageKmemcg(page))
+	if (memcg_kmem_enabled() && PageMemcgKmem(page))
 		__memcg_kmem_uncharge_page(page, order);
 	if (check_free)
 		bad += check_free_page(page);
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-memcg-deprecate-the-non-hierarchical-mode.patch
docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch
cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

