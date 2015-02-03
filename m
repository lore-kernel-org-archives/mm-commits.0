From: akpm@linux-foundation.org
Subject: + mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
 added to -mm tree
Date: Tue, 03 Feb 2015 15:05:00 -0800
Message-ID: <54d1541c.Rmhhh4TkW+s/ga7d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbbBCXFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 18:05:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: add kasan hooks on alloc and free paths
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: page_alloc: add kasan hooks on alloc and free paths

Add kernel address sanitizer hooks to mark allocated page's addresses as
accessible in corresponding shadow region.  Mark freed pages as
inaccessible.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    6 ++++++
 mm/compaction.c       |    2 ++
 mm/kasan/kasan.c      |   14 ++++++++++++++
 mm/kasan/kasan.h      |    2 ++
 mm/kasan/report.c     |   11 +++++++++++
 mm/page_alloc.c       |    3 +++
 6 files changed, 38 insertions(+)

diff -puN include/linux/kasan.h~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths include/linux/kasan.h
--- a/include/linux/kasan.h~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths
+++ a/include/linux/kasan.h
@@ -34,6 +34,9 @@ static inline void kasan_disable_current
 
 void kasan_unpoison_shadow(const void *address, size_t size);
 
+void kasan_alloc_pages(struct page *page, unsigned int order);
+void kasan_free_pages(struct page *page, unsigned int order);
+
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
@@ -41,6 +44,9 @@ static inline void kasan_unpoison_shadow
 static inline void kasan_enable_current(void) {}
 static inline void kasan_disable_current(void) {}
 
+static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
+static inline void kasan_free_pages(struct page *page, unsigned int order) {}
+
 #endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
diff -puN mm/compaction.c~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths mm/compaction.c
--- a/mm/compaction.c~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths
+++ a/mm/compaction.c
@@ -16,6 +16,7 @@
 #include <linux/sysfs.h>
 #include <linux/balloon_compaction.h>
 #include <linux/page-isolation.h>
+#include <linux/kasan.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -61,6 +62,7 @@ static void map_pages(struct list_head *
 	list_for_each_entry(page, list, lru) {
 		arch_alloc_page(page, 0);
 		kernel_map_pages(page, 1, 1);
+		kasan_alloc_pages(page, 0);
 	}
 }
 
diff -puN mm/kasan/kasan.c~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths
+++ a/mm/kasan/kasan.c
@@ -254,6 +254,20 @@ static __always_inline void check_memory
 	kasan_report(addr, size, write, _RET_IP_);
 }
 
+void kasan_alloc_pages(struct page *page, unsigned int order)
+{
+	if (likely(!PageHighMem(page)))
+		kasan_unpoison_shadow(page_address(page), PAGE_SIZE << order);
+}
+
+void kasan_free_pages(struct page *page, unsigned int order)
+{
+	if (likely(!PageHighMem(page)))
+		kasan_poison_shadow(page_address(page),
+				PAGE_SIZE << order,
+				KASAN_FREE_PAGE);
+}
+
 #define DEFINE_ASAN_LOAD_STORE(size)				\
 	void __asan_load##size(unsigned long addr)		\
 	{							\
diff -puN mm/kasan/kasan.h~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths
+++ a/mm/kasan/kasan.h
@@ -6,6 +6,8 @@
 #define KASAN_SHADOW_SCALE_SIZE (1UL << KASAN_SHADOW_SCALE_SHIFT)
 #define KASAN_SHADOW_MASK       (KASAN_SHADOW_SCALE_SIZE - 1)
 
+#define KASAN_FREE_PAGE         0xFF  /* page was freed */
+
 struct kasan_access_info {
 	const void *access_addr;
 	const void *first_bad_addr;
diff -puN mm/kasan/report.c~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths mm/kasan/report.c
--- a/mm/kasan/report.c~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths
+++ a/mm/kasan/report.c
@@ -54,6 +54,9 @@ static void print_error_description(stru
 	shadow_val = *(u8 *)kasan_mem_to_shadow(info->first_bad_addr);
 
 	switch (shadow_val) {
+	case KASAN_FREE_PAGE:
+		bug_type = "use after free";
+		break;
 	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
 		bug_type = "out of bounds access";
 		break;
@@ -69,6 +72,14 @@ static void print_error_description(stru
 
 static void print_address_description(struct kasan_access_info *info)
 {
+	const void *addr = info->access_addr;
+
+	if ((addr >= (void *)PAGE_OFFSET) &&
+		(addr < high_memory)) {
+		struct page *page = virt_to_head_page(addr);
+		dump_page(page, "kasan: bad access detected");
+	}
+
 	dump_stack();
 }
 
diff -puN mm/page_alloc.c~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths
+++ a/mm/page_alloc.c
@@ -25,6 +25,7 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/kmemcheck.h>
+#include <linux/kasan.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
 #include <linux/pagevec.h>
@@ -807,6 +808,7 @@ static bool free_pages_prepare(struct pa
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
+	kasan_free_pages(page, order);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -985,6 +987,7 @@ static int prep_new_page(struct page *pa
 
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
+	kasan_alloc_pages(page, order);
 
 	if (gfp_flags & __GFP_ZERO)
 		prep_zero_page(page, order, gfp_flags);
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch
hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
linux-next.patch

