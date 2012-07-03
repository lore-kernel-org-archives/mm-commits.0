From: akpm@linux-foundation.org
Subject: + mm-setup-pageblock_order-before-its-used-by-sparsemem.patch added to -mm tree
Date: Tue, 03 Jul 2012 14:07:23 -0700
Message-ID: <20120703210723.CFFB4A0158@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:65391 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2GCVH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2012 17:07:26 -0400
Received: by eaao13 with SMTP id o13so419327eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jul 2012 14:07:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiuxishi@huawei.com, benh@kernel.crashing.org, chenkeping@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, rientjes@google.com, stable@vger.kernel.org, tony.luck@intel.com, yinghai@kernel.org


The patch titled
     Subject: mm: setup pageblock_order before it's used by sparsemem
has been added to the -mm tree.  Its filename is
     mm-setup-pageblock_order-before-its-used-by-sparsemem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -349,3 +349,5 @@ extern u32 hwpoison_filter_enable;
 extern unsigned long vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
+
+extern void set_pageblock_order(void);
diff -puN mm/page_alloc.c~mm-setup-pageblock_order-before-its-used-by-sparsemem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-setup-pageblock_order-before-its-used-by-sparsemem
+++ a/mm/page_alloc.c
@@ -4303,7 +4303,7 @@ static inline void setup_usemap(struct p
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-static inline void __init set_pageblock_order(void)
+void __init set_pageblock_order(void)
 {
 	unsigned int order;
 
@@ -4331,7 +4331,7 @@ static inline void __init set_pageblock_
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
@@ -495,6 +495,9 @@ void __init sparse_init(void)
 	struct page **map_map;
 #endif
 
+	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
+	set_pageblock_order();
+
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
 	 * usemap is less one page (aka 24 bytes)
_
Subject: Subject: mm: setup pageblock_order before it's used by sparsemem

Patches currently in -mm which might be from qiuxishi@huawei.com are

memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch

