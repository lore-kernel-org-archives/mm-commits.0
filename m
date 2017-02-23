From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:16:13 -0800
Message-ID: <58af511d.EqeK4Sq4wT4e+Fk5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVQO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:16:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yasu.isimatu@gmail.com, dave.hansen@linux.intel.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@techsingularity.net, mingo@redhat.com, qiuxishi@huawei.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: set magic number to page->freelist instead of page->lru.next
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Subject: mm/memory_hotplug: set magic number to page->freelist instead of page->lru.next

To identify that pages of page table are allocated from bootmem allocator,
magic number sets to page->lru.next.  But page->lru list is initialized in
reserve_bootmem_region().  So when calling free_pagetable(), the function
cannot find the magic number of pages.  And free_pagetable() frees the
pages by free_reserved_page() not put_page_bootmem().

But if the pages are allocated from bootmem allocator and used as page
table, the pages have private flag.  So before freeing the pages, we
should clear the private flag by put_page_bootmem().

Before applying the commit 7bfec6f47bb0 ("mm, page_alloc: check multiple
page fields with a single branch"), we could find the following visible
issue:

  BUG: Bad page state in process kworker/u1024:1
  page:ffffea103cfd8040 count:0 mapcount:0 mappi
  flags: 0x6fffff80000800(private)
  page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
  bad because of flags: 0x800(private)
  <snip>
  Call Trace:
  [...] dump_stack+0x63/0x87
  [...] bad_page+0x114/0x130
  [...] free_pages_prepare+0x299/0x2d0
  [...] free_hot_cold_page+0x31/0x150
  [...] __free_pages+0x25/0x30
  [...] free_pagetable+0x6f/0xb4
  [...] remove_pagetable+0x379/0x7ff
  [...] vmemmap_free+0x10/0x20
  [...] sparse_remove_one_section+0x149/0x180
  [...] __remove_pages+0x2e9/0x4f0
  [...] arch_remove_memory+0x63/0xc0
  [...] remove_memory+0x8c/0xc0
  [...] acpi_memory_device_remove+0x79/0xa5
  [...] acpi_bus_trim+0x5a/0x8d
  [...] acpi_bus_trim+0x38/0x8d
  [...] acpi_device_hotplug+0x1b7/0x418
  [...] acpi_hotplug_work_fn+0x1e/0x29
  [...] process_one_work+0x152/0x400
  [...] worker_thread+0x125/0x4b0
  [...] ? __schedule+0x345/0x960
  [...] ? rescuer_thread+0x380/0x380
  [...] kthread+0xd8/0xf0
  [...] ret_from_fork+0x22/0x40
  [...] ? kthread_park+0x60/0x60

And the issue still silently occurs.

Until freeing the pages of page table allocated from bootmem allocator,
the page->freelist is never used.  So the patch sets magic number to
page->freelist instead of page->lru.next.

[isimatu.yasuaki@jp.fujitsu.com: fix merge issue]
  Link: http://lkml.kernel.org/r/722b1cc4-93ac-dd8b-2be2-7a7e313b3b0b@gmail.com
Link: http://lkml.kernel.org/r/2c29bd9f-5b67-02d0-18a3-8828e78bbb6f@gmail.com
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 +-
 mm/memory_hotplug.c   |    5 +++--
 mm/sparse.c           |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/init_64.c~mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext
+++ a/arch/x86/mm/init_64.c
@@ -679,7 +679,7 @@ static void __meminit free_pagetable(str
 	if (PageReserved(page)) {
 		__ClearPageReserved(page);
 
-		magic = (unsigned long)page->lru.next;
+		magic = (unsigned long)page->freelist;
 		if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext
+++ a/mm/memory_hotplug.c
@@ -179,7 +179,7 @@ static void release_memory_resource(stru
 void get_page_bootmem(unsigned long info,  struct page *page,
 		      unsigned long type)
 {
-	page->lru.next = (struct list_head *) type;
+	page->freelist = (void *)type;
 	SetPagePrivate(page);
 	set_page_private(page, info);
 	page_ref_inc(page);
@@ -189,11 +189,12 @@ void put_page_bootmem(struct page *page)
 {
 	unsigned long type;
 
-	type = (unsigned long) page->lru.next;
+	type = (unsigned long) page->freelist;
 	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
 	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
 
 	if (page_ref_dec_return(page) == 1) {
+		page->freelist = NULL;
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
diff -puN mm/sparse.c~mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext mm/sparse.c
--- a/mm/sparse.c~mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext
+++ a/mm/sparse.c
@@ -662,7 +662,7 @@ static void free_map_bootmem(struct page
 		>> PAGE_SHIFT;
 
 	for (i = 0; i < nr_pages; i++, page++) {
-		magic = (unsigned long) page->lru.next;
+		magic = (unsigned long) page->freelist;
 
 		BUG_ON(magic == NODE_INFO);
 
_

Patches currently in -mm which might be from yasu.isimatu@gmail.com are


