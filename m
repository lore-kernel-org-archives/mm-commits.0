From: akpm@linux-foundation.org
Subject: [merged] fix-virt_to_phys-warnings.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:32:47 -0700
Message-ID: <200907142032.n6EKWlHl012446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756442AbZGNUdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cernekee@gmail.com, andi@firstfloor.org, mingo@elte.hu, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Fix virt_to_phys() warnings
has been removed from the -mm tree.  Its filename was
     fix-virt_to_phys-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix virt_to_phys() warnings
From: Kevin Cernekee <cernekee@gmail.com>

These warnings were observed on MIPS32 using 2.6.31-rc1 and gcc-4.2.0:

mm/page_alloc.c: In function 'alloc_pages_exact':
mm/page_alloc.c:1986: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast

drivers/usb/mon/mon_bin.c: In function 'mon_alloc_buff':
drivers/usb/mon/mon_bin.c:1264: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast

[akpm@linux-foundation.org: fix kernel/perf_counter.c too]
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/mon/mon_bin.c |    2 +-
 kernel/perf_counter.c     |    2 +-
 mm/page_alloc.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/usb/mon/mon_bin.c~fix-virt_to_phys-warnings drivers/usb/mon/mon_bin.c
--- a/drivers/usb/mon/mon_bin.c~fix-virt_to_phys-warnings
+++ a/drivers/usb/mon/mon_bin.c
@@ -1261,7 +1261,7 @@ static int mon_alloc_buff(struct mon_pgm
 			return -ENOMEM;
 		}
 		map[n].ptr = (unsigned char *) vaddr;
-		map[n].pg = virt_to_page(vaddr);
+		map[n].pg = virt_to_page((void *) vaddr);
 	}
 	return 0;
 }
diff -puN kernel/perf_counter.c~fix-virt_to_phys-warnings kernel/perf_counter.c
--- a/kernel/perf_counter.c~fix-virt_to_phys-warnings
+++ a/kernel/perf_counter.c
@@ -2020,7 +2020,7 @@ fail:
 
 static void perf_mmap_free_page(unsigned long addr)
 {
-	struct page *page = virt_to_page(addr);
+	struct page *page = virt_to_page((void *)addr);
 
 	page->mapping = NULL;
 	__free_page(page);
diff -puN mm/page_alloc.c~fix-virt_to_phys-warnings mm/page_alloc.c
--- a/mm/page_alloc.c~fix-virt_to_phys-warnings
+++ a/mm/page_alloc.c
@@ -1983,7 +1983,7 @@ void *alloc_pages_exact(size_t size, gfp
 		unsigned long alloc_end = addr + (PAGE_SIZE << order);
 		unsigned long used = addr + PAGE_ALIGN(size);
 
-		split_page(virt_to_page(addr), order);
+		split_page(virt_to_page((void *)addr), order);
 		while (used < alloc_end) {
 			free_page(used);
 			used += PAGE_SIZE;
_

Patches currently in -mm which might be from cernekee@gmail.com are

linux-next.patch

