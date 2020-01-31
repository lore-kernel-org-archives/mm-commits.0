From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 051/118] mm/early_ioremap.c: use %pa to print
 resource_size_t variables
Date: Thu, 30 Jan 2020 22:13:54 -0800
Message-ID: <20200131061354.U0FKFGfMC%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGN4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:13:56 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
