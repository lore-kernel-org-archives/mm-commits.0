From: akpm@linux-foundation.org
Subject: [merged] mm-setup-pageblock_order-before-its-used-by-sparsemem.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:26 -0700
Message-ID: <20120801201427.00EAE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:28 -0400
Received: by obbwc20 with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, benh@kernel.crashing.org, chenkeping@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, rientjes@google.com, stable@vger.kernel.org, tony.luck@intel.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: setup pageblock_order before it's used by sparsemem
has been removed from the -mm tree.  Its filename was
     mm-setup-pageblock_order-before-its-used-by-sparsemem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: setup pageblock_order before it's used by sparsemem

On architectures with CONFIG_HUGETLB_PAGE_SIZE_VARIABLE set, such as
Itanium, pageblock_order is a variable with default value of 0.  It's set
to the right value by set_pageblock_order() in function
free_area_init_core().

But pageblock_order may be used by sparse_init() before free_area_init_core()
is called along path:
sparse_init()
    ->sparse_early_usemaps_alloc_node()
	->usemap_size()
	    ->SECTION_BLOCKFLAGS_BITS
		->((1UL << (PFN_SECTION_SHIFT - pageblock_order)) *
NR_PAGEBLOCK_BITS)

The uninitialized pageblock_size will cause memory wasting because
usemap_size() returns a much bigger value then it's really needed.

For example, on an Itanium platform,
sparse_init() pageblock_order=0 usemap_size=24576
free_area_init_core() before pageblock_order=0, usemap_size=24576
free_area_init_core() after pageblock_order=12, usemap_size=8

That means 24K memory has been wasted for each section, so fix it by calling
set_pageblock_order() from sparse_init().

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Keping Chen <chenkeping@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    2 ++
 mm/page_alloc.c |    4 ++--
 mm/sparse.c     |    3 +++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/internal.h~mm-setup-pageblock_order-before-its-used-by-sparsemem mm/internal.h
--- a/mm/internal.h~mm-setup-pageblock_order-before-its-used-by-sparsemem
+++ a/mm/internal.h
@@ -353,3 +353,5 @@ extern u32 hwpoison_filter_enable;
 extern unsigned long vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
+
+extern void set_pageblock_order(void);
diff -puN mm/page_alloc.c~mm-setup-pageblock_order-before-its-used-by-sparsemem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-setup-pageblock_order-before-its-used-by-sparsemem
+++ a/mm/page_alloc.c
@@ -4304,7 +4304,7 @@ static inline void setup_usemap(struct p
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-static inline void __init set_pageblock_order(void)
+void __init set_pageblock_order(void)
 {
 	unsigned int order;
 
@@ -4332,7 +4332,7 @@ static inline void __init set_pageblock_
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-static inline void set_pageblock_order(void)
+void __init set_pageblock_order(void)
 {
 }
 
diff -puN mm/sparse.c~mm-setup-pageblock_order-before-its-used-by-sparsemem mm/sparse.c
--- a/mm/sparse.c~mm-setup-pageblock_order-before-its-used-by-sparsemem
+++ a/mm/sparse.c
@@ -493,6 +493,9 @@ void __init sparse_init(void)
 	struct page **map_map;
 #endif
 
+	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
+	set_pageblock_order();
+
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
 	 * usemap is less one page (aka 24 bytes)
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch

