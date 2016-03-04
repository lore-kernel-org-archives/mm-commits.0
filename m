From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch removed
 from -mm tree
Date: Fri, 04 Mar 2016 15:59:06 -0800
Message-ID: <56da214a.9U4C+xfsepGEEqaJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760458AbcCDX7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 18:59:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, dave.hansen@intel.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, minipli@googlemail.com, nasa4836@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poison.c: enable PAGE_POISONING as a separate option
has been removed from the -mm tree.  Its filename was
     mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Laura Abbott <labbott@fedoraproject.org>
Subject: mm/page_poison.c: enable PAGE_POISONING as a separate option

Page poisoning is currently set up as a feature if architectures don't
have architecture debug page_alloc to allow unmapping of pages.  It has
uses apart from that though.  Clearing of the pages on free provides an
increase in security as it helps to limit the risk of information leaks. 
Allow page poisoning to be enabled as a separate option independent of any
other debug feature.  Because of how hiberanation is implemented, the
checks on alloc cannot occur if hibernation is enabled.  This option can
also be set on !HIBERNATION as well.

Credit to Mathias Krause and grsecurity for original work

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    3 +++
 mm/Kconfig.debug     |   22 +++++++++++++++++++++-
 mm/debug-pagealloc.c |    8 +-------
 mm/page_alloc.c      |    2 ++
 mm/page_poison.c     |   14 ++++++++++++++
 5 files changed, 41 insertions(+), 8 deletions(-)

diff -puN include/linux/mm.h~mm-page_poisonc-enable-page_poisoning-as-a-separate-option include/linux/mm.h
--- a/include/linux/mm.h~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/include/linux/mm.h
@@ -2179,10 +2179,13 @@ extern int apply_to_page_range(struct mm
 extern void poison_pages(struct page *page, int n);
 extern void unpoison_pages(struct page *page, int n);
 extern bool page_poisoning_enabled(void);
+extern void kernel_poison_pages(struct page *page, int numpages, int enable);
 #else
 static inline void poison_pages(struct page *page, int n) { }
 static inline void unpoison_pages(struct page *page, int n) { }
 static inline bool page_poisoning_enabled(void) { return false; }
+static inline void kernel_poison_pages(struct page *page, int numpages,
+					int enable) { }
 #endif
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
diff -puN mm/Kconfig.debug~mm-page_poisonc-enable-page_poisoning-as-a-separate-option mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/mm/Kconfig.debug
@@ -41,4 +41,24 @@ config DEBUG_PAGEALLOC_ENABLE_DEFAULT
 	  can be overridden by debug_pagealloc=off|on.
 
 config PAGE_POISONING
-	bool
+	bool "Poisson pages after freeing"
+	select PAGE_EXTENSION
+	select PAGE_POISONING_NO_SANITY if HIBERNATION
+	---help---
+	  Fill the pages with poison patterns after free_pages() and verify
+	  the patterns before alloc_pages. The filling of the memory helps
+	  reduce the risk of information leaks from freed data. This does
+	  have a potential performance impact.
+
+	  If unsure, say N
+
+config PAGE_POISONING_NO_SANITY
+	depends on PAGE_POISONING
+	bool "Only poison, don't sanity check"
+	---help---
+	   Skip the sanity checking on alloc, only fill the pages with
+	   poison on free. This reduces some of the overhead of the
+	   poisoning feature.
+
+	   If you are only interested in sanitization, say Y. Otherwise
+	   say N.
diff -puN mm/debug-pagealloc.c~mm-page_poisonc-enable-page_poisoning-as-a-separate-option mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/mm/debug-pagealloc.c
@@ -8,11 +8,5 @@
 
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
-	if (!page_poisoning_enabled())
-		return;
-
-	if (enable)
-		unpoison_pages(page, numpages);
-	else
-		poison_pages(page, numpages);
+	kernel_poison_pages(page, numpages, enable);
 }
diff -puN mm/page_alloc.c~mm-page_poisonc-enable-page_poisoning-as-a-separate-option mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/mm/page_alloc.c
@@ -1007,6 +1007,7 @@ static bool free_pages_prepare(struct pa
 					   PAGE_SIZE << order);
 	}
 	arch_free_page(page, order);
+	kernel_poison_pages(page, 1 << order, 0);
 	kernel_map_pages(page, 1 << order, 0);
 
 	return true;
@@ -1401,6 +1402,7 @@ static int prep_new_page(struct page *pa
 	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
+	kernel_poison_pages(page, 1 << order, 1);
 	kernel_map_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 
diff -puN mm/page_poison.c~mm-page_poisonc-enable-page_poisoning-as-a-separate-option mm/page_poison.c
--- a/mm/page_poison.c~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/mm/page_poison.c
@@ -101,6 +101,9 @@ static void check_poison_mem(unsigned ch
 	unsigned char *start;
 	unsigned char *end;
 
+	if (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY))
+		return;
+
 	start = memchr_inv(mem, PAGE_POISON, bytes);
 	if (!start)
 		return;
@@ -142,3 +145,14 @@ void unpoison_pages(struct page *page, i
 	for (i = 0; i < n; i++)
 		unpoison_page(page + i);
 }
+
+void kernel_poison_pages(struct page *page, int numpages, int enable)
+{
+	if (!page_poisoning_enabled())
+		return;
+
+	if (enable)
+		unpoison_pages(page, numpages);
+	else
+		poison_pages(page, numpages);
+}
_

Patches currently in -mm which might be from labbott@fedoraproject.org are

slub-drop-lock-at-the-end-of-free_debug_processing.patch
slub-fix-clean-free_debug_processing-return-paths.patch
slub-convert-slab_debug_free-to-slab_consistency_checks.patch
slub-relax-cmpxchg-consistency-restrictions.patch
mm-page_poisoningc-allow-for-zero-poisoning.patch

