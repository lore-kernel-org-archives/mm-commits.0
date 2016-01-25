From: akpm@linux-foundation.org
Subject: +
 mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch
 added to -mm tree
Date: Mon, 25 Jan 2016 14:40:18 -0800
Message-ID: <56a6a452.6ESgXIz/yNXZanV6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbcAYWkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 17:40:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, dave.hansen@intel.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, minipli@googlemail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug-pagealloc.c: split out page poisoning from debug page_alloc
has been added to the -mm tree.  Its filename is
     mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch

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
Subject: mm/debug-pagealloc.c: split out page poisoning from debug page_alloc

This is an implementation of page poisoning/sanitization for all arches. 
It takes advantage of the existing implementation for
!ARCH_SUPPORTS_DEBUG_PAGEALLOC arches.  This is a different approach than
what the Grsecurity patches were taking but should provide equivalent
functionality.

For those who aren't familiar with this, the goal of sanitization is to
reduce the severity of use after free and uninitialized data bugs.  Memory
is cleared on free so any sensitive data is no longer available. 
Discussion of sanitization was brough up in a thread about CVEs
(lkml.kernel.org/g/<20160119112812.GA10818@mwanda>)

I eventually expect Kconfig names will want to be changed and or moved if
this is going to be used for security but that can happen later.

Credit to Mathias Krause for the version in grsecurity


This patch (of 3):

For architectures that do not have debug page_alloc
(!ARCH_SUPPORTS_DEBUG_PAGEALLOC), page poisoning is used instead.  Even
architectures that do have DEBUG_PAGEALLOC may want to take advantage of
the poisoning feature.  Separate out page poisoning into a separate file. 
This does not change the default behavior for
!ARCH_SUPPORTS_DEBUG_PAGEALLOC.

Credit to Mathias Krause and grsecurity for original work

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 
 include/linux/mm.h                  |   10 +
 mm/Makefile                         |    5 
 mm/debug-pagealloc.c                |  121 ---------------------
 mm/page_poison.c                    |  144 ++++++++++++++++++++++++++
 5 files changed, 164 insertions(+), 121 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc
+++ a/Documentation/kernel-parameters.txt
@@ -2726,6 +2726,11 @@ bytes respectively. Such letter suffixes
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
diff -puN include/linux/mm.h~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc include/linux/mm.h
--- a/include/linux/mm.h~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc
+++ a/include/linux/mm.h
@@ -2173,6 +2173,16 @@ extern int apply_to_page_range(struct mm
 			       unsigned long size, pte_fn_t fn, void *data);
 
 
+#ifdef CONFIG_PAGE_POISONING
+extern void poison_pages(struct page *page, int n);
+extern void unpoison_pages(struct page *page, int n);
+extern bool page_poisoning_enabled(void);
+#else
+static inline void poison_pages(struct page *page, int n) { }
+static inline void unpoison_pages(struct page *page, int n) { }
+static inline bool page_poisoning_enabled(void) { return false; }
+#endif
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 extern bool _debug_pagealloc_enabled;
 extern void __kernel_map_pages(struct page *page, int numpages, int enable);
diff -puN mm/Makefile~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc mm/Makefile
--- a/mm/Makefile~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc
+++ a/mm/Makefile
@@ -48,7 +48,10 @@ obj-$(CONFIG_SPARSEMEM_VMEMMAP) += spars
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_KSM) += ksm.o
-obj-$(CONFIG_PAGE_POISONING) += debug-pagealloc.o
+ifndef CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	obj-$(CONFIG_DEBUG_PAGEALLOC) += debug-pagealloc.o
+endif
+obj-$(CONFIG_PAGE_POISONING) += page_poison.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
diff -puN mm/debug-pagealloc.c~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc
+++ a/mm/debug-pagealloc.c
@@ -6,128 +6,9 @@
 #include <linux/poison.h>
 #include <linux/ratelimit.h>
 
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
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
-	if (!page_poisoning_enabled)
+	if (!page_poisoning_enabled())
 		return;
 
 	if (enable)
diff -puN /dev/null mm/page_poison.c
--- /dev/null
+++ a/mm/page_poison.c
@@ -0,0 +1,144 @@
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/page_ext.h>
+#include <linux/poison.h>
+#include <linux/ratelimit.h>
+
+static bool __page_poisoning_enabled __read_mostly;
+static bool want_page_poisoning __read_mostly =
+	!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC);
+
+static int early_page_poison_param(char *buf)
+{
+        if (!buf)
+                return -EINVAL;
+
+        if (strcmp(buf, "on") == 0)
+                want_page_poisoning = true;
+	else if (strcmp(buf, "off") == 0)
+		want_page_poisoning = false;
+
+        return 0;
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
+	if (!want_page_poisoning)
+		return;
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
+void poison_pages(struct page *page, int n)
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
+		printk(KERN_ERR "pagealloc: single bit error\n");
+	else
+		printk(KERN_ERR "pagealloc: memory corruption\n");
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
+void unpoison_pages(struct page *page, int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		unpoison_page(page + i);
+}
_

Patches currently in -mm which might be from labbott@fedoraproject.org are

mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch
mm-page_poisoningc-allow-for-zero-poisoning.patch

