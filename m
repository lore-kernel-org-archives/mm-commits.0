From: akpm@linux-foundation.org
Subject: [merged]
 mm-early_remap-use-%pa-to-print-resource_size_t-variables.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:18:25 -0800
Message-ID: <20200131231825.VC7kFBTcN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXS0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, david@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap.c: use %pa to print resource_size_t variables
has been removed from the -mm tree.  Its filename was
     mm-early_remap-use-%pa-to-print-resource_size_t-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm/early_ioremap.c: use %pa to print resource_size_t variables

%pa takes into consideration the special types such as resource_size_t. 
Use this specifier %instead of explicit casting.

Link: http://lkml.kernel.org/r/20191209165413.56263-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/early_ioremap.c~mm-early_remap-use-%pa-to-print-resource_size_t-variables
+++ a/mm/early_ioremap.c
@@ -121,8 +121,8 @@ __early_ioremap(resource_size_t phys_add
 		}
 	}
 
-	if (WARN(slot < 0, "%s(%08llx, %08lx) not found slot\n",
-		 __func__, (u64)phys_addr, size))
+	if (WARN(slot < 0, "%s(%pa, %08lx) not found slot\n",
+		 __func__, &phys_addr, size))
 		return NULL;
 
 	/* Don't allow wraparound or zero size */
@@ -158,8 +158,8 @@ __early_ioremap(resource_size_t phys_add
 		--idx;
 		--nrpages;
 	}
-	WARN(early_ioremap_debug, "%s(%08llx, %08lx) [%d] => %08lx + %08lx\n",
-	     __func__, (u64)phys_addr, size, slot, offset, slot_virt[slot]);
+	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
+	     __func__, &phys_addr, size, slot, offset, slot_virt[slot]);
 
 	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
 	return prev_map[slot];
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-add-test-for-bitmap_parse-fix-2.patch
