From: akpm@linux-foundation.org
Subject: - driver-base-memory-semaphore-to-mutex.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:38 -0800
Message-ID: <200802232021.m1NKLchm013356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760101AbYBWUWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:22:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     driver base: memory: semaphore to mutex
has been removed from the -mm tree.  Its filename was
     driver-base-memory-semaphore-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver base: memory: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |    7 ++++---
 include/linux/memory.h |    5 ++---
 mm/memory_hotplug.c    |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/base/memory.c~driver-base-memory-semaphore-to-mutex drivers/base/memory.c
--- a/drivers/base/memory.c~driver-base-memory-semaphore-to-mutex
+++ a/drivers/base/memory.c
@@ -20,6 +20,7 @@
 #include <linux/kobject.h>
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
@@ -205,7 +206,7 @@ static int memory_block_change_state(str
 		unsigned long to_state, unsigned long from_state_req)
 {
 	int ret = 0;
-	down(&mem->state_sem);
+	mutex_lock(&mem->state_mutex);
 
 	if (mem->state != from_state_req) {
 		ret = -EINVAL;
@@ -217,7 +218,7 @@ static int memory_block_change_state(str
 		mem->state = to_state;
 
 out:
-	up(&mem->state_sem);
+	mutex_unlock(&mem->state_mutex);
 	return ret;
 }
 
@@ -341,7 +342,7 @@ static int add_memory_block(unsigned lon
 
 	mem->phys_index = __section_nr(section);
 	mem->state = state;
-	init_MUTEX(&mem->state_sem);
+	mutex_init(&mem->state_mutex);
 	mem->phys_device = phys_device;
 
 	ret = register_memory(mem, section, NULL);
diff -puN include/linux/memory.h~driver-base-memory-semaphore-to-mutex include/linux/memory.h
--- a/include/linux/memory.h~driver-base-memory-semaphore-to-mutex
+++ a/include/linux/memory.h
@@ -18,8 +18,7 @@
 #include <linux/sysdev.h>
 #include <linux/node.h>
 #include <linux/compiler.h>
-
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 struct memory_block {
 	unsigned long phys_index;
@@ -30,7 +29,7 @@ struct memory_block {
 	 * created long after the critical areas during
 	 * initialization.
 	 */
-	struct semaphore state_sem;
+	struct mutex state_mutex;
 	int phys_device;		/* to which fru does this belong? */
 	void *hw;			/* optional pointer to fw/hw data */
 	int (*phys_callback)(struct memory_block *);
diff -puN mm/memory_hotplug.c~driver-base-memory-semaphore-to-mutex mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~driver-base-memory-semaphore-to-mutex
+++ a/mm/memory_hotplug.c
@@ -208,7 +208,7 @@ int online_pages(unsigned long pfn, unsi
 	/*
 	 * This doesn't need a lock to do pfn_to_page().
 	 * The section can't be removed here because of the
-	 * memory_block->state_sem.
+	 * memory_block->state_mutex.
 	 */
 	zone = page_zone(pfn_to_page(pfn));
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
_

Patches currently in -mm which might be from dwalker@mvista.com are

profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
