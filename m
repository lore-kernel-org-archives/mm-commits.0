From: akpm@linux-foundation.org
Subject: +
 mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch added to
 -mm tree
Date: Tue, 16 Aug 2016 13:40:05 -0700
Message-ID: <57b37a25.QDfG1H8Ca+/Lwxtl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbcHPUkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2016 16:40:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: support extra space allocation by page_ext user
has been added to the -mm tree.  Its filename is
     mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_ext: support extra space allocation by page_ext user

Until now, if some page_ext users want to use it's own field on page_ext,
it should be defined in struct page_ext by hard-coding.  It has a problem
that wastes memory in following situation.

struct page_ext {
 #ifdef CONFIG_A
	int a;
 #endif
 #ifdef CONFIG_B
	int b;
 #endif
};

Assume that kernel is built with both CONFIG_A and CONFIG_B.  Even if we
enable feature A and doesn't enable feature B at runtime, each entry of
struct page_ext takes two int rather than one int.  It's undesirable
result so this patch tries to fix it.

To solve above problem, this patch implements to support extra space
allocation at runtime.  When need() callback returns true, it's extra
memory requirement is summed to entry size of page_ext.  Also, offset for
each user's extra memory space is returned.  With this offset, user can
use this extra space and there is no need to define needed field on
page_ext by hard-coding.

This patch only implements an infrastructure.  Following patch will use it
for page_owner which is only user having it's own fields on page_ext.

Link: http://lkml.kernel.org/r/1471315879-32294-6-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    2 +
 mm/page_alloc.c          |    2 -
 mm/page_ext.c            |   41 +++++++++++++++++++++++++++----------
 3 files changed, 34 insertions(+), 11 deletions(-)

diff -puN include/linux/page_ext.h~mm-page_ext-support-extra-space-allocation-by-page_ext-user include/linux/page_ext.h
--- a/include/linux/page_ext.h~mm-page_ext-support-extra-space-allocation-by-page_ext-user
+++ a/include/linux/page_ext.h
@@ -7,6 +7,8 @@
 
 struct pglist_data;
 struct page_ext_operations {
+	size_t offset;
+	size_t size;
 	bool (*need)(void);
 	void (*init)(void);
 };
diff -puN mm/page_alloc.c~mm-page_ext-support-extra-space-allocation-by-page_ext-user mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_ext-support-extra-space-allocation-by-page_ext-user
+++ a/mm/page_alloc.c
@@ -687,7 +687,7 @@ static inline void clear_page_guard(stru
 		__mod_zone_freepage_state(zone, (1 << order), migratetype);
 }
 #else
-struct page_ext_operations debug_guardpage_ops = { NULL, };
+struct page_ext_operations debug_guardpage_ops;
 static inline bool set_page_guard(struct zone *zone, struct page *page,
 			unsigned int order, int migratetype) { return false; }
 static inline void clear_page_guard(struct zone *zone, struct page *page,
diff -puN mm/page_ext.c~mm-page_ext-support-extra-space-allocation-by-page_ext-user mm/page_ext.c
--- a/mm/page_ext.c~mm-page_ext-support-extra-space-allocation-by-page_ext-user
+++ a/mm/page_ext.c
@@ -42,6 +42,11 @@
  * and page extension core can skip to allocate memory. As result,
  * none of memory is wasted.
  *
+ * When need callback returns true, page_ext checks if there is a request for
+ * extra memory through size in struct page_ext_operations. If it is non-zero,
+ * extra space is allocated for each page_ext entry and offset is returned to
+ * user through offset in struct page_ext_operations.
+ *
  * The init callback is used to do proper initialization after page extension
  * is completely initialized. In sparse memory system, extra memory is
  * allocated some time later than memmap is allocated. In other words, lifetime
@@ -66,18 +71,24 @@ static struct page_ext_operations *page_
 };
 
 static unsigned long total_usage;
+static unsigned long extra_mem;
 
 static bool __init invoke_need_callbacks(void)
 {
 	int i;
 	int entries = ARRAY_SIZE(page_ext_ops);
+	bool need = false;
 
 	for (i = 0; i < entries; i++) {
-		if (page_ext_ops[i]->need && page_ext_ops[i]->need())
-			return true;
+		if (page_ext_ops[i]->need && page_ext_ops[i]->need()) {
+			page_ext_ops[i]->offset = sizeof(struct page_ext) +
+						extra_mem;
+			extra_mem += page_ext_ops[i]->size;
+			need = true;
+		}
 	}
 
-	return false;
+	return need;
 }
 
 static void __init invoke_init_callbacks(void)
@@ -91,6 +102,16 @@ static void __init invoke_init_callbacks
 	}
 }
 
+static unsigned long get_entry_size(void)
+{
+	return sizeof(struct page_ext) + extra_mem;
+}
+
+static inline struct page_ext *get_entry(void *base, unsigned long index)
+{
+	return base + get_entry_size() * index;
+}
+
 #if !defined(CONFIG_SPARSEMEM)
 
 
@@ -121,7 +142,7 @@ struct page_ext *lookup_page_ext(struct
 #endif
 	index = pfn - round_down(node_start_pfn(page_to_nid(page)),
 					MAX_ORDER_NR_PAGES);
-	return base + index;
+	return get_entry(base, index);
 }
 
 static int __init alloc_node_page_ext(int nid)
@@ -143,7 +164,7 @@ static int __init alloc_node_page_ext(in
 		!IS_ALIGNED(node_end_pfn(nid), MAX_ORDER_NR_PAGES))
 		nr_pages += MAX_ORDER_NR_PAGES;
 
-	table_size = sizeof(struct page_ext) * nr_pages;
+	table_size = get_entry_size() * nr_pages;
 
 	base = memblock_virt_alloc_try_nid_nopanic(
 			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
@@ -196,7 +217,7 @@ struct page_ext *lookup_page_ext(struct
 	if (!section->page_ext)
 		return NULL;
 #endif
-	return section->page_ext + pfn;
+	return get_entry(section->page_ext, pfn);
 }
 
 static void *__meminit alloc_page_ext(size_t size, int nid)
@@ -229,7 +250,7 @@ static int __meminit init_section_page_e
 	if (section->page_ext)
 		return 0;
 
-	table_size = sizeof(struct page_ext) * PAGES_PER_SECTION;
+	table_size = get_entry_size() * PAGES_PER_SECTION;
 	base = alloc_page_ext(table_size, nid);
 
 	/*
@@ -249,7 +270,7 @@ static int __meminit init_section_page_e
 	 * we need to apply a mask.
 	 */
 	pfn &= PAGE_SECTION_MASK;
-	section->page_ext = base - pfn;
+	section->page_ext = (void *)base - get_entry_size() * pfn;
 	total_usage += table_size;
 	return 0;
 }
@@ -262,7 +283,7 @@ static void free_page_ext(void *addr)
 		struct page *page = virt_to_page(addr);
 		size_t table_size;
 
-		table_size = sizeof(struct page_ext) * PAGES_PER_SECTION;
+		table_size = get_entry_size() * PAGES_PER_SECTION;
 
 		BUG_ON(PageReserved(page));
 		free_pages_exact(addr, table_size);
@@ -277,7 +298,7 @@ static void __free_page_ext(unsigned lon
 	ms = __pfn_to_section(pfn);
 	if (!ms || !ms->page_ext)
 		return;
-	base = ms->page_ext + pfn;
+	base = get_entry(ms->page_ext, pfn);
 	free_page_ext(base);
 	ms->page_ext = NULL;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-debug_pagealloc-clean-up-guard-page-handling-code.patch
mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch
mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch
mm-page_ext-rename-offset-to-index.patch
mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch
mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch

