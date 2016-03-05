From: akpm@linux-foundation.org
Subject: + mm-page_poisoningc-allow-for-zero-poisoning.patch added to -mm
 tree
Date: Fri, 04 Mar 2016 16:08:08 -0800
Message-ID: <56da2368.eeIeWDAodR24fNIT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760491AbcCEAIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 19:08:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, dave.hansen@intel.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, minipli@googlemail.com, nasa4836@gmail.com, rjw@rjwysocki.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poisoning.c: allow for zero poisoning
has been added to the -mm tree.  Its filename is
     mm-page_poisoningc-allow-for-zero-poisoning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_poisoningc-allow-for-zero-poisoning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poisoningc-allow-for-zero-poisoning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@fedoraproject.org>
Subject: mm/page_poisoning.c: allow for zero poisoning

By default, page poisoning uses a poison value (0xaa) on free.  If this is
changed to 0, the page is not only sanitized but zeroing on alloc with
__GFP_ZERO can be skipped as well.  The tradeoff is that detecting
corruption from the poisoning is harder to detect.  This feature also
cannot be used with hibernation since pages are not guaranteed to be
zeroed after hibernation.

Credit to Grsecurity/PaX team for inspiring this work

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    2 ++
 include/linux/poison.h   |    4 ++++
 kernel/power/hibernate.c |   17 +++++++++++++++++
 mm/Kconfig.debug         |   14 ++++++++++++++
 mm/page_alloc.c          |   11 ++++++++++-
 mm/page_ext.c            |   10 ++++++++--
 mm/page_poison.c         |    7 +++++--
 7 files changed, 60 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~mm-page_poisoningc-allow-for-zero-poisoning include/linux/mm.h
--- a/include/linux/mm.h~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/include/linux/mm.h
@@ -2178,10 +2178,12 @@ extern int apply_to_page_range(struct mm
 #ifdef CONFIG_PAGE_POISONING
 extern bool page_poisoning_enabled(void);
 extern void kernel_poison_pages(struct page *page, int numpages, int enable);
+extern bool page_is_poisoned(struct page *page);
 #else
 static inline bool page_poisoning_enabled(void) { return false; }
 static inline void kernel_poison_pages(struct page *page, int numpages,
 					int enable) { }
+static inline bool page_is_poisoned(struct page *page) { return false; }
 #endif
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
diff -puN include/linux/poison.h~mm-page_poisoningc-allow-for-zero-poisoning include/linux/poison.h
--- a/include/linux/poison.h~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/include/linux/poison.h
@@ -30,7 +30,11 @@
 #define TIMER_ENTRY_STATIC	((void *) 0x300 + POISON_POINTER_DELTA)
 
 /********** mm/debug-pagealloc.c **********/
+#ifdef CONFIG_PAGE_POISONING_ZERO
+#define PAGE_POISON 0x00
+#else
 #define PAGE_POISON 0xaa
+#endif
 
 /********** mm/page_alloc.c ************/
 
diff -puN kernel/power/hibernate.c~mm-page_poisoningc-allow-for-zero-poisoning kernel/power/hibernate.c
--- a/kernel/power/hibernate.c~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/kernel/power/hibernate.c
@@ -1158,6 +1158,22 @@ static int __init kaslr_nohibernate_setu
 	return nohibernate_setup(str);
 }
 
+static int __init page_poison_nohibernate_setup(char *str)
+{
+#ifdef CONFIG_PAGE_POISONING_ZERO
+	/*
+	 * The zeroing option for page poison skips the checks on alloc.
+	 * since hibernation doesn't save free pages there's no way to
+	 * guarantee the pages will still be zeroed.
+	 */
+	if (!strcmp(str, "on")) {
+		pr_info("Disabling hibernation due to page poisoning\n");
+		return nohibernate_setup(str);
+	}
+#endif
+	return 1;
+}
+
 __setup("noresume", noresume_setup);
 __setup("resume_offset=", resume_offset_setup);
 __setup("resume=", resume_setup);
@@ -1166,3 +1182,4 @@ __setup("resumewait", resumewait_setup);
 __setup("resumedelay=", resumedelay_setup);
 __setup("nohibernate", nohibernate_setup);
 __setup("kaslr", kaslr_nohibernate_setup);
+__setup("page_poison=", page_poison_nohibernate_setup);
diff -puN mm/Kconfig.debug~mm-page_poisoningc-allow-for-zero-poisoning mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/mm/Kconfig.debug
@@ -65,3 +65,17 @@ config PAGE_POISONING_NO_SANITY
 
 	   If you are only interested in sanitization, say Y. Otherwise
 	   say N.
+
+config PAGE_POISONING_ZERO
+	bool "Use zero for poisoning instead of random data"
+	depends on PAGE_POISONING
+	---help---
+	   Instead of using the existing poison value, fill the pages with
+	   zeros. This makes it harder to detect when errors are occurring
+	   due to sanitization but the zeroing at free means that it is
+	   no longer necessary to write zeros when GFP_ZERO is used on
+	   allocation.
+
+	   Enabling page poisoning with this option will disable hibernation
+
+	   If unsure, say N
diff -puN mm/page_alloc.c~mm-page_poisoningc-allow-for-zero-poisoning mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/mm/page_alloc.c
@@ -1405,15 +1405,24 @@ static inline int check_new_page(struct
 	return 0;
 }
 
+static inline bool free_pages_prezeroed(bool poisoned)
+{
+	return IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
+		page_poisoning_enabled() && poisoned;
+}
+
 static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
 								int alloc_flags)
 {
 	int i;
+	bool poisoned = true;
 
 	for (i = 0; i < (1 << order); i++) {
 		struct page *p = page + i;
 		if (unlikely(check_new_page(p)))
 			return 1;
+		if (poisoned)
+			poisoned &= page_is_poisoned(p);
 	}
 
 	set_page_private(page, 0);
@@ -1424,7 +1433,7 @@ static int prep_new_page(struct page *pa
 	kernel_poison_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 
-	if (gfp_flags & __GFP_ZERO)
+	if (!free_pages_prezeroed(poisoned) && (gfp_flags & __GFP_ZERO))
 		for (i = 0; i < (1 << order); i++)
 			clear_highpage(page + i);
 
diff -puN mm/page_ext.c~mm-page_poisoningc-allow-for-zero-poisoning mm/page_ext.c
--- a/mm/page_ext.c~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/mm/page_ext.c
@@ -106,12 +106,15 @@ struct page_ext *lookup_page_ext(struct
 	struct page_ext *base;
 
 	base = NODE_DATA(page_to_nid(page))->node_page_ext;
-#ifdef CONFIG_DEBUG_VM
+#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_PAGE_POISONING)
 	/*
 	 * The sanity checks the page allocator does upon freeing a
 	 * page can reach here before the page_ext arrays are
 	 * allocated when feeding a range of pages to the allocator
 	 * for the first time during bootup or memory hotplug.
+	 *
+	 * This check is also necessary for ensuring page poisoning
+	 * works as expected when enabled
 	 */
 	if (unlikely(!base))
 		return NULL;
@@ -180,12 +183,15 @@ struct page_ext *lookup_page_ext(struct
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
-#ifdef CONFIG_DEBUG_VM
+#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_PAGE_POISONING)
 	/*
 	 * The sanity checks the page allocator does upon freeing a
 	 * page can reach here before the page_ext arrays are
 	 * allocated when feeding a range of pages to the allocator
 	 * for the first time during bootup or memory hotplug.
+	 *
+	 * This check is also necessary for ensuring page poisoning
+	 * works as expected when enabled
 	 */
 	if (!section->page_ext)
 		return NULL;
diff -puN mm/page_poison.c~mm-page_poisoningc-allow-for-zero-poisoning mm/page_poison.c
--- a/mm/page_poison.c~mm-page_poisoningc-allow-for-zero-poisoning
+++ a/mm/page_poison.c
@@ -71,11 +71,14 @@ static inline void clear_page_poison(str
 	__clear_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
 }
 
-static inline bool page_poison(struct page *page)
+bool page_is_poisoned(struct page *page)
 {
 	struct page_ext *page_ext;
 
 	page_ext = lookup_page_ext(page);
+	if (!page_ext)
+		return false;
+
 	return test_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
 }
 
@@ -137,7 +140,7 @@ static void unpoison_page(struct page *p
 {
 	void *addr;
 
-	if (!page_poison(page))
+	if (!page_is_poisoned(page))
 		return;
 
 	addr = kmap_atomic(page);
_

Patches currently in -mm which might be from labbott@fedoraproject.org are

slub-drop-lock-at-the-end-of-free_debug_processing.patch
slub-fix-clean-free_debug_processing-return-paths.patch
slub-convert-slab_debug_free-to-slab_consistency_checks.patch
slub-relax-cmpxchg-consistency-restrictions.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch
mm-page_poisoningc-allow-for-zero-poisoning.patch

