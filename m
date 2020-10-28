Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C705C4363A
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B99C6207CD
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603927862;
	bh=X7vmz9CDphvvk10dVNlLebRu8glKxduQAGyQMdVorZA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CG1a53uDEkDrDjxcIfwvHfAM9CSc9Nxwlc9sk5GkVhAVe9HZVlT+/MYPlweRupBmB
	 WyilfbRqjt2on9vXRMtfBDTyo177CMM9/TTPyWbMZAV8u8fACQWX8MiLQ9K6mIvcaG
	 mqyug/QqNCb3cwA4Bx60oIeoa5XBnKgZwQZsHewk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgJ1XbB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 19:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390419AbgJ1X3Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 19:29:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B7F620796;
        Wed, 28 Oct 2020 23:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603927755;
        bh=X7vmz9CDphvvk10dVNlLebRu8glKxduQAGyQMdVorZA=;
        h=Date:From:To:Subject:From;
        b=fTDc2irqiOvCeaqlG3VitZIiiV9A5NI2To5fYwR5PU7IuSWDyv2DQWjsbFGAbLB3X
         V/FSO+a+ZxI+DDX3W1qGWRy4ltEtt2J4QHh9X9hO6k4fsx3Ymk/p6gf6GvTvYPI+VQ
         kKXJRXjuQfZ8SXMFjDDoqncsqejgw3TZhQIWO8kE=
Date:   Wed, 28 Oct 2020 16:29:14 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
 added to -mm tree
Message-ID: <20201028232914.LfXO1aXet%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page kmemcg type to a page memcg flag
has been added to the -mm tree.  Its filename is
     mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -346,8 +346,10 @@ extern struct mem_cgroup *root_mem_cgrou
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
@@ -369,8 +371,12 @@ enum page_memcg_data_flags {
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
@@ -387,7 +393,8 @@ static inline struct mem_cgroup *page_me
 	VM_BUG_ON_PAGE(PageSlab(page), page);
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	return (struct mem_cgroup *)READ_ONCE(page->memcg_data);
+	return (struct mem_cgroup *)(READ_ONCE(page->memcg_data) &
+				     ~MEMCG_DATA_FLAGS_MASK);
 }
 
 /*
@@ -416,7 +423,21 @@ static inline struct mem_cgroup *page_me
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
@@ -435,6 +456,7 @@ static inline struct obj_cgroup **page_o
 	unsigned long memcg_data = READ_ONCE(page->memcg_data);
 
 	VM_BUG_ON_PAGE(memcg_data && !(memcg_data & MEMCG_DATA_OBJCGS), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
 
 	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
@@ -454,6 +476,8 @@ static inline struct obj_cgroup **page_o
 	if (!memcg_data || !(memcg_data & MEMCG_DATA_OBJCGS))
 		return NULL;
 
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
+
 	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
@@ -1107,6 +1131,11 @@ static inline struct mem_cgroup *page_me
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
@@ -715,9 +715,8 @@ PAGEFLAG_FALSE(DoubleMap)
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
@@ -769,12 +768,6 @@ PAGE_TYPE_OPS(Buddy, buddy)
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
@@ -3078,8 +3078,8 @@ int __memcg_kmem_charge_page(struct page
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
@@ -3104,10 +3104,6 @@ void __memcg_kmem_uncharge_page(struct p
 	__memcg_kmem_uncharge(memcg, nr_pages);
 	page->memcg_data = 0;
 	css_put(&memcg->css);
-
-	/* slab pages do not have PageKmemcg flag set */
-	if (PageKmemcg(page))
-		__ClearPageKmemcg(page);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
@@ -6860,12 +6856,10 @@ static void uncharge_page(struct page *p
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
@@ -1214,7 +1214,7 @@ static __always_inline bool free_pages_p
 		 * Do not let hwpoison pages hit pcplists/buddy
 		 * Untie memcg state and reset page's owner
 		 */
-		if (memcg_kmem_enabled() && PageKmemcg(page))
+		if (memcg_kmem_enabled() && PageMemcgKmem(page))
 			__memcg_kmem_uncharge_page(page, order);
 		reset_page_owner(page, order);
 		return false;
@@ -1244,7 +1244,7 @@ static __always_inline bool free_pages_p
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

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

