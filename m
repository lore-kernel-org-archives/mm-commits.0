From: akpm@linux-foundation.org
Subject: [merged] mm-mmzone-memmap_valid_within-can-be-boolean.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:04 -0800
Message-ID: <569973a0.ibxXTnrLP9Za/3qI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbcAOWdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmzone.c: memmap_valid_within() can be boolean
has been removed from the -mm tree.  Its filename was
     mm-mmzone-memmap_valid_within-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: mm/mmzone.c: memmap_valid_within() can be boolean

Make memmap_valid_within return bool due to this particular function only
using either one or zero as its return value.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++---
 mm/mmzone.c            |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/mmzone.h~mm-mmzone-memmap_valid_within-can-be-boolean include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-mmzone-memmap_valid_within-can-be-boolean
+++ a/include/linux/mmzone.h
@@ -1200,13 +1200,13 @@ unsigned long __init node_memmap_size_by
  * the zone and PFN linkages are still valid. This is expensive, but walkers
  * of the full memmap are extremely rare.
  */
-int memmap_valid_within(unsigned long pfn,
+bool memmap_valid_within(unsigned long pfn,
 					struct page *page, struct zone *zone);
 #else
-static inline int memmap_valid_within(unsigned long pfn,
+static inline bool memmap_valid_within(unsigned long pfn,
 					struct page *page, struct zone *zone)
 {
-	return 1;
+	return true;
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
 
diff -puN mm/mmzone.c~mm-mmzone-memmap_valid_within-can-be-boolean mm/mmzone.c
--- a/mm/mmzone.c~mm-mmzone-memmap_valid_within-can-be-boolean
+++ a/mm/mmzone.c
@@ -72,16 +72,16 @@ struct zoneref *next_zones_zonelist(stru
 }
 
 #ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
-int memmap_valid_within(unsigned long pfn,
+bool memmap_valid_within(unsigned long pfn,
 					struct page *page, struct zone *zone)
 {
 	if (page_to_pfn(page) != pfn)
-		return 0;
+		return false;
 
 	if (page_zone(page) != zone)
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
 
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
init-mainc-obsolete_checksetup-can-be-boolean.patch
init-do_mounts-initrd_load-can-be-boolean.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

