From: akpm@linux-foundation.org
Subject: [merged] mm-change-highmem_zone-macro-definition.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:15:55 -0800
Message-ID: <563d0a7b.oeCzERlMAUseuBvj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033404AbbKFUP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:15:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/vm_event_item.h: change HIGHMEM_ZONE macro definition
has been removed from the -mm tree.  Its filename was
     mm-change-highmem_zone-macro-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: yalin wang <yalin.wang2010@gmail.com>
Subject: include/linux/vm_event_item.h: change HIGHMEM_ZONE macro definition

Change HIGHMEM_ZONE to be the same as the DMA_ZONE macro.

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-change-highmem_zone-macro-definition include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-change-highmem_zone-macro-definition
+++ a/include/linux/vm_event_item.h
@@ -14,12 +14,12 @@
 #endif
 
 #ifdef CONFIG_HIGHMEM
-#define HIGHMEM_ZONE(xx) , xx##_HIGH
+#define HIGHMEM_ZONE(xx) xx##_HIGH,
 #else
 #define HIGHMEM_ZONE(xx)
 #endif
 
-#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
+#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL, HIGHMEM_ZONE(xx) xx##_MOVABLE
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
_

Patches currently in -mm which might be from yalin.wang2010@gmail.com are

mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix-2.patch

