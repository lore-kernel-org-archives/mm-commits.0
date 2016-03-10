From: akpm@linux-foundation.org
Subject: [merged] list-kill-list_force_poison.patch removed from -mm tree
Date: Thu, 10 Mar 2016 10:57:57 -0800
Message-ID: <56e1c3b5.ymVJAMgfeJIBvraR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbcCJS56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:57:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, eguan@redhat.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: list: kill list_force_poison()
has been removed from the -mm tree.  Its filename was
     list-kill-list_force_poison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: list: kill list_force_poison()

Given we have uninitialized list_heads being passed to list_add() it will
always be the case that those uninitialized values randomly trigger the
poison value.  Especially since a list_add() operation will seed the stack
with the poison value for later stack allocations to trip over.  For
example, see these two false positive reports:

 list_add attempted on force-poisoned entry
 WARNING: at lib/list_debug.c:34
 [..]
 NIP [c00000000043c390] __list_add+0xb0/0x150
 LR [c00000000043c38c] __list_add+0xac/0x150
 Call Trace:
 [c000000fb5fc3320] [c00000000043c38c] __list_add+0xac/0x150 (unreliable)
 [c000000fb5fc33a0] [c00000000081b454] __down+0x4c/0xf8
 [c000000fb5fc3410] [c00000000010b6f8] down+0x68/0x70
 [c000000fb5fc3450] [d0000000201ebf4c] xfs_buf_lock+0x4c/0x150 [xfs]

 list_add attempted on force-poisoned entry(0000000000000500),
  new->next == d0000000059ecdb0, new->prev == 0000000000000500
 WARNING: at lib/list_debug.c:33
 [..]
 NIP [c00000000042db78] __list_add+0xa8/0x140
 LR [c00000000042db74] __list_add+0xa4/0x140
 Call Trace:
 [c0000004c749f620] [c00000000042db74] __list_add+0xa4/0x140 (unreliable)
 [c0000004c749f6b0] [c0000000008010ec] rwsem_down_read_failed+0x6c/0x1a0
 [c0000004c749f760] [c000000000800828] down_read+0x58/0x60
 [c0000004c749f7e0] [d000000005a1a6bc] xfs_log_commit_cil+0x7c/0x600 [xfs]

Fixes: commit 5c2c2587b132 ("mm, dax, pmem: introduce {get|put}_dev_pagemap() for dax-gup")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Eryu Guan <eguan@redhat.com>
Tested-by: Eryu Guan <eguan@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   11 -----------
 kernel/memremap.c    |    9 +++++++--
 lib/list_debug.c     |    9 ---------
 3 files changed, 7 insertions(+), 22 deletions(-)

diff -puN include/linux/list.h~list-kill-list_force_poison include/linux/list.h
--- a/include/linux/list.h~list-kill-list_force_poison
+++ a/include/linux/list.h
@@ -113,17 +113,6 @@ extern void __list_del_entry(struct list
 extern void list_del(struct list_head *entry);
 #endif
 
-#ifdef CONFIG_DEBUG_LIST
-/*
- * See devm_memremap_pages() which wants DEBUG_LIST=y to assert if one
- * of the pages it allocates is ever passed to list_add()
- */
-extern void list_force_poison(struct list_head *entry);
-#else
-/* fallback to the less strict LIST_POISON* definitions */
-#define list_force_poison list_del
-#endif
-
 /**
  * list_replace - replace old entry by new one
  * @old : the element to be replaced
diff -puN kernel/memremap.c~list-kill-list_force_poison kernel/memremap.c
--- a/kernel/memremap.c~list-kill-list_force_poison
+++ a/kernel/memremap.c
@@ -351,8 +351,13 @@ void *devm_memremap_pages(struct device
 	for_each_device_pfn(pfn, page_map) {
 		struct page *page = pfn_to_page(pfn);
 
-		/* ZONE_DEVICE pages must never appear on a slab lru */
-		list_force_poison(&page->lru);
+		/*
+		 * ZONE_DEVICE pages union ->lru with a ->pgmap back
+		 * pointer.  It is a bug if a ZONE_DEVICE page is ever
+		 * freed or placed on a driver-private list.  Seed the
+		 * storage with LIST_POISON* values.
+		 */
+		list_del(&page->lru);
 		page->pgmap = pgmap;
 	}
 	devres_add(dev, page_map);
diff -puN lib/list_debug.c~list-kill-list_force_poison lib/list_debug.c
--- a/lib/list_debug.c~list-kill-list_force_poison
+++ a/lib/list_debug.c
@@ -12,13 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/rculist.h>
 
-static struct list_head force_poison;
-void list_force_poison(struct list_head *entry)
-{
-	entry->next = &force_poison;
-	entry->prev = &force_poison;
-}
