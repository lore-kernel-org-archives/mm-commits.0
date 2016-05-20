From: akpm@linux-foundation.org
Subject: [patch 046/162] mm: use phys_addr_t for reserve_bootmem_region()
 arguments
Date: Fri, 20 May 2016 16:58:38 -0700
Message-ID: <573fa4ae.GG/cnYebdyYyeqDp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETX6k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:58:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, stefan.bader@canonical.com, stable@vger.kernel.org

From: Stefan Bader <stefan.bader@canonical.com>
Subject: mm: use phys_addr_t for reserve_bootmem_region() arguments

Since 92923ca3aacef63 ("mm: meminit: only set page reserved in the
memblock region") the reserved bit is set on reserved memblock regions. 
However start and end address are passed as unsigned long.  This is only
32bit on i386, so it can end up marking the wrong pages reserved for
ranges at 4GB and above.

This was observed on a 32bit Xen dom0 which was booted with initial memory
set to a value below 4G but allowing to balloon in memory (dom0_mem=1024M
for example).  This would define a reserved bootmem region for the
additional memory (for example on a 8GB system there was a reverved region
covering the 4GB-8GB range).  But since the addresses were passed on as
unsigned long, this was actually marking all pages from 0 to 4GB as
reserved.

Fixes: 92923ca3aacef63 ("mm: meminit: only set page reserved in the memblock region")
Link: http://lkml.kernel.org/r/1463491221-10573-1-git-send-email-stefan.bader@canonical.com
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: <stable@vger.kernel.org>	[4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/page_alloc.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-use-phys_addr_t-for-reserve_bootmem_region-arguments include/linux/mm.h
--- a/include/linux/mm.h~mm-use-phys_addr_t-for-reserve_bootmem_region-arguments
+++ a/include/linux/mm.h
@@ -1763,7 +1763,7 @@ extern void free_highmem_page(struct pag
 extern void adjust_managed_page_count(struct page *page, long count);
 extern void mem_init_print_info(const char *str);
 
-extern void reserve_bootmem_region(unsigned long start, unsigned long end);
+extern void reserve_bootmem_region(phys_addr_t start, phys_addr_t end);
 
 /* Free the reserved page into the buddy system, so it gets managed. */
 static inline void __free_reserved_page(struct page *page)
diff -puN mm/page_alloc.c~mm-use-phys_addr_t-for-reserve_bootmem_region-arguments mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-phys_addr_t-for-reserve_bootmem_region-arguments
+++ a/mm/page_alloc.c
@@ -1205,7 +1205,7 @@ static inline void init_reserved_page(un
  * marks the pages PageReserved. The remaining valid pages are later
  * sent to the buddy page allocator.
  */
-void __meminit reserve_bootmem_region(unsigned long start, unsigned long end)
+void __meminit reserve_bootmem_region(phys_addr_t start, phys_addr_t end)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long end_pfn = PFN_UP(end);
_
