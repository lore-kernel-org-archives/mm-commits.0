From: akpm@linux-foundation.org
Subject: + mm-mmzone-memmap_valid_within-can-be-boolean.patch added to -mm tree
Date: Wed, 18 Nov 2015 13:06:12 -0800
Message-ID: <564ce844.FuoX42aTvmuA5VFM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbbKRVGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Nov 2015 16:06:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmzone.c: memmap_valid_within() can be boolean
has been added to the -mm tree.  Its filename is
     mm-mmzone-memmap_valid_within-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmzone-memmap_valid_within-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmzone-memmap_valid_within-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-is_file_hugepages-can-be-boolean.patch
mm-memblock-memblock_is_memory-reserved-can-be-boolean.patch
mm-lru-remove-unused-is_unevictable_lru-function.patch
mm-zonelist-enumerate-zonelists-array-index.patch
mm-mmzone-memmap_valid_within-can-be-boolean.patch
fs-statc-drop-the-last-new_valid_dev-check.patch
include-linux-kdev_th-remove-new_valid_dev.patch
init-mainc-obsolete_checksetup-can-be-boolean.patch
init-do_mounts-initrd_load-can-be-boolean.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

