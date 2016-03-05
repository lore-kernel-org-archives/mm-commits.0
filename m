From: akpm@linux-foundation.org
Subject: +
 mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch added to
 -mm tree
Date: Fri, 04 Mar 2016 16:08:06 -0800
Message-ID: <56da2366.Yqy/pXji3Gv1M7OL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760491AbcCEAII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 19:08:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, dave.hansen@intel.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, minipli@googlemail.com, nasa4836@gmail.com, rjw@rjwysocki.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poison.c: enable PAGE_POISONING as a separate option
has been added to the -mm tree.  Its filename is
     mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch

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
Subject: mm/page_poison.c: enable PAGE_POISONING as a separate option

Page poisoning is currently set up as a feature if architectures don't
have architecture debug page_alloc to allow unmapping of pages.  It has
uses apart from that though.  Clearing of the pages on free provides an
increase in security as it helps to limit the risk of information leaks. 
Allow page poisoning to be enabled as a separate option independent of
kernel_map pages since the two features do separate work.  Because of how
hiberanation is implemented, the checks on alloc cannot occur if
hibernation is enabled.  The runtime alloc checks can also be enabled with
an option when !HIBERNATION.

Credit to Grsecurity/PaX team for inspiring this work

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 
 include/linux/mm.h                  |    9 +
 mm/Kconfig.debug                    |   25 +++
 mm/Makefile                         |    2 
 mm/debug-pagealloc.c                |  137 --------------------
 mm/page_alloc.c                     |    2 
 mm/page_poison.c                    |  173 ++++++++++++++++++++++++++
 7 files changed, 214 insertions(+), 139 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-page_poisonc-enable-page_poisoning-as-a-separate-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/Documentation/kernel-parameters.txt
@@ -2731,6 +2731,11 @@ bytes respectively. Such letter suffixes
 			we can turn it on.
 			on: enable the feature
 
+	page_poison=	[KNL] Boot-time parameter changing the state of
+			poisoning on the buddy allocator.
+			off: turn off poisoning
+			on: turn on poisoning
+
 	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
 			timeout > 0: seconds before rebooting
 			timeout = 0: wait forever
diff -puN include/linux/mm.h~mm-page_poisonc-enable-page_poisoning-as-a-separate-option include/linux/mm.h
--- a/include/linux/mm.h~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/include/linux/mm.h
@@ -2175,6 +2175,15 @@ extern int apply_to_page_range(struct mm
 			       unsigned long size, pte_fn_t fn, void *data);
 
 
+#ifdef CONFIG_PAGE_POISONING
+extern bool page_poisoning_enabled(void);
+extern void kernel_poison_pages(struct page *page, int numpages, int enable);
+#else
+static inline bool page_poisoning_enabled(void) { return false; }
+static inline void kernel_poison_pages(struct page *page, int numpages,
+					int enable) { }
+#endif
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 extern bool _debug_pagealloc_enabled;
 extern void __kernel_map_pages(struct page *page, int numpages, int enable);
diff -puN mm/Kconfig.debug~mm-page_poisonc-enable-page_poisoning-as-a-separate-option mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/mm/Kconfig.debug
@@ -41,4 +41,27 @@ config DEBUG_PAGEALLOC_ENABLE_DEFAULT
 	  can be overridden by debug_pagealloc=off|on.
 
 config PAGE_POISONING
-	bool
+	bool "Poison pages after freeing"
+	select PAGE_EXTENSION
+	select PAGE_POISONING_NO_SANITY if HIBERNATION
+	---help---
+	  Fill the pages with poison patterns after free_pages() and verify
+	  the patterns before alloc_pages. The filling of the memory helps
+	  reduce the risk of information leaks from freed data. This does
+	  have a potential performance impact.
+
+	  Note that "poison" here is not the same thing as the "HWPoison"
+	  for CONFIG_MEMORY_FAILURE. This is software poisoning only.
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
diff -puN mm/Makefile~mm-page_poisonc-enable-page_poisoning-as-a-separate-option mm/Makefile
--- a/mm/Makefile~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/mm/Makefile
@@ -48,7 +48,7 @@ obj-$(CONFIG_SPARSEMEM_VMEMMAP) += spars
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_KSM) += ksm.o
-obj-$(CONFIG_PAGE_POISONING) += debug-pagealloc.o
+obj-$(CONFIG_PAGE_POISONING) += page_poison.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
diff -puN mm/debug-pagealloc.c~mm-page_poisonc-enable-page_poisoning-as-a-separate-option /dev/null
--- a/mm/debug-pagealloc.c
+++ /dev/null
@@ -1,137 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/page_ext.h>
-#include <linux/poison.h>
-#include <linux/ratelimit.h>
-
-static bool page_poisoning_enabled __read_mostly;
-
-static bool need_page_poisoning(void)
-{
-	if (!debug_pagealloc_enabled())
-		return false;
-
-	return true;
-}
-
-static void init_page_poisoning(void)
-{
-	if (!debug_pagealloc_enabled())
-		return;
-
-	page_poisoning_enabled = true;
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
-	__set_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
-}
-
-static inline void clear_page_poison(struct page *page)
-{
-	struct page_ext *page_ext;
-
-	page_ext = lookup_page_ext(page);
-	__clear_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
-}
-
-static inline bool page_poison(struct page *page)
-{
-	struct page_ext *page_ext;
-
-	page_ext = lookup_page_ext(page);
-	return test_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
-}
-
-static void poison_page(struct page *page)
-{
-	void *addr = kmap_atomic(page);
-
-	set_page_poison(page);
-	memset(addr, PAGE_POISON, PAGE_SIZE);
-	kunmap_atomic(addr);
-}
-
-static void poison_pages(struct page *page, int n)
-{
-	int i;
-
-	for (i = 0; i < n; i++)
-		poison_page(page + i);
-}
-
-static bool single_bit_flip(unsigned char a, unsigned char b)
-{
-	unsigned char error = a ^ b;
-
-	return error && !(error & (error - 1));
-}
-
-static void check_poison_mem(unsigned char *mem, size_t bytes)
-{
-	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 10);
-	unsigned char *start;
-	unsigned char *end;
-
-	start = memchr_inv(mem, PAGE_POISON, bytes);
-	if (!start)
-		return;
-
-	for (end = mem + bytes - 1; end > start; end--) {
-		if (*end != PAGE_POISON)
-			break;
-	}
-
-	if (!__ratelimit(&ratelimit))
-		return;
-	else if (start == end && single_bit_flip(*start, PAGE_POISON))
-		printk(KERN_ERR "pagealloc: single bit error\n");
-	else
-		printk(KERN_ERR "pagealloc: memory corruption\n");
-
-	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1, start,
-			end - start + 1, 1);
-	dump_stack();
-}
-
-static void unpoison_page(struct page *page)
-{
-	void *addr;
-
-	if (!page_poison(page))
-		return;
-
-	addr = kmap_atomic(page);
-	check_poison_mem(addr, PAGE_SIZE);
-	clear_page_poison(page);
-	kunmap_atomic(addr);
-}
-
-static void unpoison_pages(struct page *page, int n)
-{
-	int i;
-
-	for (i = 0; i < n; i++)
-		unpoison_page(page + i);
-}
-
-void __kernel_map_pages(struct page *page, int numpages, int enable)
-{
-	if (!page_poisoning_enabled)
-		return;
-
-	if (enable)
-		unpoison_pages(page, numpages);
-	else
-		poison_pages(page, numpages);
-}
diff -puN mm/page_alloc.c~mm-page_poisonc-enable-page_poisoning-as-a-separate-option mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_poisonc-enable-page_poisoning-as-a-separate-option
+++ a/mm/page_alloc.c
@@ -1025,6 +1025,7 @@ static bool free_pages_prepare(struct pa
 					   PAGE_SIZE << order);
 	}
 	arch_free_page(page, order);
+	kernel_poison_pages(page, 1 << order, 0);
 	kernel_map_pages(page, 1 << order, 0);
 
 	return true;
@@ -1420,6 +1421,7 @@ static int prep_new_page(struct page *pa
 
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
+	kernel_poison_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 
 	if (gfp_flags & __GFP_ZERO)
diff -puN /dev/null mm/page_poison.c
--- /dev/null
+++ a/mm/page_poison.c
@@ -0,0 +1,173 @@
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/page_ext.h>
+#include <linux/poison.h>
+#include <linux/ratelimit.h>
+
+static bool __page_poisoning_enabled __read_mostly;
+static bool want_page_poisoning __read_mostly;
+
+static int early_page_poison_param(char *buf)
+{
+	if (!buf)
+		return -EINVAL;
+
+	if (strcmp(buf, "on") == 0)
+		want_page_poisoning = true;
+	else if (strcmp(buf, "off") == 0)
+		want_page_poisoning = false;
+
+	return 0;
+}
+early_param("page_poison", early_page_poison_param);
+
+bool page_poisoning_enabled(void)
+{
+	return __page_poisoning_enabled;
+}
+
+static bool need_page_poisoning(void)
+{
+	return want_page_poisoning;
+}
+
+static void init_page_poisoning(void)
+{
+	/*
+	 * page poisoning is debug page alloc for some arches. If either
+	 * of those options are enabled, enable poisoning
+	 */
+	if (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC)) {
+		if (!want_page_poisoning && !debug_pagealloc_enabled())
+			return;
+	} else {
+		if (!want_page_poisoning)
+			return;
+	}
+
+	__page_poisoning_enabled = true;
+}
+
+struct page_ext_operations page_poisoning_ops = {
+	.need = need_page_poisoning,
+	.init = init_page_poisoning,
+};
+
+static inline void set_page_poison(struct page *page)
+{
+	struct page_ext *page_ext;
+
+	page_ext = lookup_page_ext(page);
+	__set_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
+}
+
+static inline void clear_page_poison(struct page *page)
+{
+	struct page_ext *page_ext;
+
+	page_ext = lookup_page_ext(page);
+	__clear_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
+}
+
+static inline bool page_poison(struct page *page)
+{
+	struct page_ext *page_ext;
+
+	page_ext = lookup_page_ext(page);
+	return test_bit(PAGE_EXT_DEBUG_POISON, &page_ext->flags);
+}
+
+static void poison_page(struct page *page)
+{
+	void *addr = kmap_atomic(page);
+
+	set_page_poison(page);
+	memset(addr, PAGE_POISON, PAGE_SIZE);
+	kunmap_atomic(addr);
+}
+
+static void poison_pages(struct page *page, int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		poison_page(page + i);
+}
+
+static bool single_bit_flip(unsigned char a, unsigned char b)
+{
+	unsigned char error = a ^ b;
+
+	return error && !(error & (error - 1));
+}
+
+static void check_poison_mem(unsigned char *mem, size_t bytes)
+{
+	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 10);
+	unsigned char *start;
+	unsigned char *end;
+
+	if (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY))
+		return;
+
+	start = memchr_inv(mem, PAGE_POISON, bytes);
+	if (!start)
+		return;
+
+	for (end = mem + bytes - 1; end > start; end--) {
+		if (*end != PAGE_POISON)
+			break;
+	}
+
+	if (!__ratelimit(&ratelimit))
+		return;
+	else if (start == end && single_bit_flip(*start, PAGE_POISON))
+		pr_err("pagealloc: single bit error\n");
+	else
+		pr_err("pagealloc: memory corruption\n");
+
+	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1, start,
+			end - start + 1, 1);
+	dump_stack();
+}
+
+static void unpoison_page(struct page *page)
+{
+	void *addr;
+
+	if (!page_poison(page))
+		return;
+
+	addr = kmap_atomic(page);
+	check_poison_mem(addr, PAGE_SIZE);
+	clear_page_poison(page);
+	kunmap_atomic(addr);
+}
+
+static void unpoison_pages(struct page *page, int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		unpoison_page(page + i);
+}
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
+
+#ifndef CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC
+void __kernel_map_pages(struct page *page, int numpages, int enable)
+{
+	/* This function does nothing, all work is done via poison pages */
+}
+#endif
_

Patches currently in -mm which might be from labbott@fedoraproject.org are

slub-drop-lock-at-the-end-of-free_debug_processing.patch
slub-fix-clean-free_debug_processing-return-paths.patch
slub-convert-slab_debug_free-to-slab_consistency_checks.patch
slub-relax-cmpxchg-consistency-restrictions.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch
mm-page_poisoningc-allow-for-zero-poisoning.patch

