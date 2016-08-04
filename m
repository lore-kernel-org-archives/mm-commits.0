From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve.patch added to
 -mm tree
Date: Thu, 04 Aug 2016 14:01:41 -0700
Message-ID: <57a3ad35.QqW1Yke0YVk3QAWF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbcHDVDN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 17:03:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srikar@linux.vnet.ibm.com, bsingharora@gmail.com, dave.hansen@intel.com, hbathini@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, mpe@ellerman.id.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: replace set_dma_reserve to set_memory_reserve
has been added to the -mm tree.  Its filename is
     mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: mm/page_alloc.c: replace set_dma_reserve to set_memory_reserve

Expand the scope of the existing dma_reserve to accommodate other memory
reserves too.  Accordingly rename variable dma_reserve to
nr_memory_reserve.

set_memory_reserve() also takes a new parameter that helps to identify if
the current value needs to be incremented.

Link: http://lkml.kernel.org/r/1470330729-6273-1-git-send-email-srikar@linux.vnet.ibm.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Hari Bathini <hbathini@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c |    2 +-
 include/linux/mm.h     |    2 +-
 mm/page_alloc.c        |   20 ++++++++++++--------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/e820.c~mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve
+++ a/arch/x86/kernel/e820.c
@@ -1188,6 +1188,6 @@ void __init memblock_find_dma_reserve(vo
 			nr_free_pages += end_pfn - start_pfn;
 	}
 
-	set_dma_reserve(nr_pages - nr_free_pages);
+	set_memory_reserve(nr_pages - nr_free_pages, false);
 #endif
 }
diff -puN include/linux/mm.h~mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve include/linux/mm.h
--- a/include/linux/mm.h~mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve
+++ a/include/linux/mm.h
@@ -1913,7 +1913,7 @@ extern int __meminit __early_pfn_to_nid(
 					struct mminit_pfnnid_cache *state);
 #endif
 
-extern void set_dma_reserve(unsigned long new_dma_reserve);
+extern void set_memory_reserve(unsigned long nr_reserve, bool inc);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
 extern void setup_per_zone_wmarks(void);
diff -puN mm/page_alloc.c~mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve
+++ a/mm/page_alloc.c
@@ -254,7 +254,7 @@ int watermark_scale_factor = 10;
 
 static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
-static unsigned long __meminitdata dma_reserve;
+static unsigned long __meminitdata nr_memory_reserve;
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
@@ -5861,10 +5861,10 @@ static void __paginginit free_area_init_
 		}
 
 		/* Account for reserved pages */
-		if (j == 0 && freesize > dma_reserve) {
-			freesize -= dma_reserve;
+		if (j == 0 && freesize > nr_memory_reserve) {
+			freesize -= nr_memory_reserve;
 			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
-					zone_names[0], dma_reserve);
+					zone_names[0], nr_memory_reserve);
 		}
 
 		if (!is_highmem_idx(j))
@@ -6553,8 +6553,9 @@ void __init mem_init_print_info(const ch
 }
 
 /**
- * set_dma_reserve - set the specified number of pages reserved in the first zone
- * @new_dma_reserve: The number of pages to mark reserved
+ * set_memory_reserve - set number of pages reserved in the first zone
+ * @nr_reserve: The number of pages to mark reserved
+ * @inc: true increment to existing value; false set new value.
  *
  * The per-cpu batchsize and zone watermarks are determined by managed_pages.
  * In the DMA zone, a significant percentage may be consumed by kernel image
@@ -6563,9 +6564,12 @@ void __init mem_init_print_info(const ch
  * first zone (e.g., ZONE_DMA). The effect will be lower watermarks and
  * smaller per-cpu batchsize.
  */
-void __init set_dma_reserve(unsigned long new_dma_reserve)
+void __init set_memory_reserve(unsigned long nr_reserve, bool inc)
 {
-	dma_reserve = new_dma_reserve;
+	if (inc)
+		nr_memory_reserve += nr_reserve;
+	else
+		nr_memory_reserve = nr_reserve;
 }
 
 void __init free_area_init(unsigned long *zones_size)
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are

mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve.patch
fadump-register-the-memory-reserved-by-fadump.patch

