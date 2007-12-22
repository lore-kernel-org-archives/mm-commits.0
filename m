From: akpm@linux-foundation.org
Subject: + driver-base-memory-semaphore-to-mutex.patch added to -mm tree
Date: Fri, 21 Dec 2007 20:12:00 -0800
Message-ID: <200712220412.lBM4C0Li016508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXLVEMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 23:12:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, greg@kroah.com


The patch titled
     driver base: memory: semaphore to mutex
has been added to the -mm tree.  Its filename is
     driver-base-memory-semaphore-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ps3-vuart-fix-error-path-locking.patch
driver-base-memory-semaphore-to-mutex.patch
git-dvb.patch
git-x86.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
amiga-serial-driver-port_write_mutex-fixup.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
