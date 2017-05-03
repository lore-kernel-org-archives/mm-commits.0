From: akpm@linux-foundation.org
Subject: [patch 061/102] mm: enable page poisoning early at boot
Date: Wed, 03 May 2017 14:54:42 -0700
Message-ID: <20170503215442.3T0qaYSkk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49832 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdECVzK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, labbott@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vinmenon@codeaurora.org

From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: mm: enable page poisoning early at boot

On SPARSEMEM systems page poisoning is enabled after buddy is up, because
of the dependency on page extension init.  This causes the pages released
by free_all_bootmem not to be poisoned.  This either delays or misses the
identification of some issues because the pages have to undergo another
cycle of alloc-free-alloc for any corruption to be detected.

Enable page poisoning early by getting rid of the PAGE_EXT_DEBUG_POISON
flag.  Since all the free pages will now be poisoned, the flag need not be
verified before checking the poison during an alloc.

[vinmenon@codeaurora.org: fix Kconfig]
  Link: http://lkml.kernel.org/r/1490878002-14423-1-git-send-email-vinmenon@codeaurora.org
Link: http://lkml.kernel.org/r/1490358246-11001-1-git-send-email-vinmenon@codeaurora.org
Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
Acked-by: Laura Abbott <labbott@redhat.com>
Tested-by: Laura Abbott <labbott@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/Kconfig.debug   |    1 
 mm/page_alloc.c    |   13 +------
 mm/page_ext.c      |   13 +------
 mm/page_poison.c   |   77 ++++++-------------------------------------
 5 files changed, 17 insertions(+), 88 deletions(-)

diff -puN include/linux/mm.h~mm-enable-page-poisoning-early-at-boot include/linux/mm.h
--- a/include/linux/mm.h~mm-enable-page-poisoning-early-at-boot
+++ a/include/linux/mm.h
@@ -2487,7 +2487,6 @@ extern long copy_huge_page_from_user(str
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 extern struct page_ext_operations debug_guardpage_ops;
-extern struct page_ext_operations page_poisoning_ops;
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 extern unsigned int _debug_guardpage_minorder;
diff -puN mm/Kconfig.debug~mm-enable-page-poisoning-early-at-boot mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-enable-page-poisoning-early-at-boot
+++ a/mm/Kconfig.debug
@@ -42,7 +42,6 @@ config DEBUG_PAGEALLOC_ENABLE_DEFAULT
 
 config PAGE_POISONING
 	bool "Poison pages after freeing"
-	select PAGE_EXTENSION
 	select PAGE_POISONING_NO_SANITY if HIBERNATION
 	---help---
 	  Fill the pages with poison patterns after free_pages() and verify
diff -puN mm/page_alloc.c~mm-enable-page-poisoning-early-at-boot mm/page_alloc.c
--- a/mm/page_alloc.c~mm-enable-page-poisoning-early-at-boot
+++ a/mm/page_alloc.c
@@ -1689,10 +1689,10 @@ static inline int check_new_page(struct
 	return 1;
 }
 
-static inline bool free_pages_prezeroed(bool poisoned)
+static inline bool free_pages_prezeroed(void)
 {
 	return IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
-		page_poisoning_enabled() && poisoned;
+		page_poisoning_enabled();
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -1746,17 +1746,10 @@ static void prep_new_page(struct page *p
 							unsigned int alloc_flags)
 {
 	int i;
-	bool poisoned = true;
-
-	for (i = 0; i < (1 << order); i++) {
-		struct page *p = page + i;
-		if (poisoned)
-			poisoned &= page_is_poisoned(p);
-	}
 
 	post_alloc_hook(page, order, gfp_flags);
 
-	if (!free_pages_prezeroed(poisoned) && (gfp_flags & __GFP_ZERO))
+	if (!free_pages_prezeroed() && (gfp_flags & __GFP_ZERO))
 		for (i = 0; i < (1 << order); i++)
 			clear_highpage(page + i);
 
diff -puN mm/page_ext.c~mm-enable-page-poisoning-early-at-boot mm/page_ext.c
--- a/mm/page_ext.c~mm-enable-page-poisoning-early-at-boot
+++ a/mm/page_ext.c
@@ -59,9 +59,6 @@
 
 static struct page_ext_operations *page_ext_ops[] = {
 	&debug_guardpage_ops,
-#ifdef CONFIG_PAGE_POISONING
-	&page_poisoning_ops,
-#endif
 #ifdef CONFIG_PAGE_OWNER
 	&page_owner_ops,
 #endif
@@ -127,15 +124,12 @@ struct page_ext *lookup_page_ext(struct
 	struct page_ext *base;
 
 	base = NODE_DATA(page_to_nid(page))->node_page_ext;
-#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_PAGE_POISONING)
+#if defined(CONFIG_DEBUG_VM)
 	/*
 	 * The sanity checks the page allocator does upon freeing a
 	 * page can reach here before the page_ext arrays are
 	 * allocated when feeding a range of pages to the allocator
 	 * for the first time during bootup or memory hotplug.
-	 *
-	 * This check is also necessary for ensuring page poisoning
-	 * works as expected when enabled
 	 */
 	if (unlikely(!base))
 		return NULL;
@@ -204,15 +198,12 @@ struct page_ext *lookup_page_ext(struct
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
-#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_PAGE_POISONING)
+#if defined(CONFIG_DEBUG_VM)
 	/*
 	 * The sanity checks the page allocator does upon freeing a
 	 * page can reach here before the page_ext arrays are
 	 * allocated when feeding a range of pages to the allocator
 	 * for the first time during bootup or memory hotplug.
-	 *
-	 * This check is also necessary for ensuring page poisoning
-	 * works as expected when enabled
 	 */
 	if (!section->page_ext)
 		return NULL;
diff -puN mm/page_poison.c~mm-enable-page-poisoning-early-at-boot mm/page_poison.c
--- a/mm/page_poison.c~mm-enable-page-poisoning-early-at-boot
+++ a/mm/page_poison.c
@@ -6,7 +6,6 @@
 #include <linux/poison.h>
 #include <linux/ratelimit.h>
 
-static bool __page_poisoning_enabled __read_mostly;
 static bool want_page_poisoning __read_mostly;
 
 static int early_page_poison_param(char *buf)
@@ -19,74 +18,21 @@ early_param("page_poison", early_page_po
 
 bool page_poisoning_enabled(void)
 {
-	return __page_poisoning_enabled;
-}
-
-static bool need_page_poisoning(void)
-{
-	return want_page_poisoning;
-}
-
-static void init_page_poisoning(void)
-{
 	/*
-	 * page poisoning is debug page alloc for some arches. If either
-	 * of those options are enabled, enable poisoning
+	 * Assumes that debug_pagealloc_enabled is set before
+	 * free_all_bootmem.
+	 * Page poisoning is debug page alloc for some arches. If
+	 * either of those options are enabled, enable poisoning.
 	 */
-	if (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC)) {
-		if (!want_page_poisoning && !debug_pagealloc_enabled())
-			return;
-	} else {
-		if (!want_page_poisoning)
-			return;
-	}
-
-	__page_poisoning_enabled = true;
-}
-
-struct page_ext_operations page_poisoning_ops = {
-	.need = need_page_poisoning,
-	.init = init_page_poisoning,
-};
-
-static inline void set_page_poison(struct page *page)
-{
-	struct page_ext *page_ext;
-
-	page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext))
-		return;
-
-	__set_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
-}
-
-static inline void clear_page_poison(struct page *page)
-{
-	struct page_ext *page_ext;
-
-	page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext))
-		return;
-
-	__clear_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
-}
-
-bool page_is_poisoned(struct page *page)
-{
-	struct page_ext *page_ext;
-
-	page_ext = lookup_page_ext(page);
-	if (unlikely(!page_ext))
-		return false;
-
-	return test_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
+	return (want_page_poisoning ||
+		(!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
+		debug_pagealloc_enabled()));
 }
 
 static void poison_page(struct page *page)
 {
 	void *addr = kmap_atomic(page);
 
-	set_page_poison(page);
 	memset(addr, PAGE_POISON, PAGE_SIZE);
 	kunmap_atomic(addr);
 }
@@ -140,12 +86,13 @@ static void unpoison_page(struct page *p
 {
 	void *addr;
 
-	if (!page_is_poisoned(page))
-		return;
