From: akpm@linux-foundation.org
Subject: - mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:51 -0700
Message-ID: <200807242322.m6ONMprE010600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756426AbYGXX2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: remove mm_init compilation dependency on CONFIG_DEBUG_MEMORY_INIT
has been removed from the -mm tree.  Its filename was
     mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove mm_init compilation dependency on CONFIG_DEBUG_MEMORY_INIT
From: Nishanth Aravamudan <nacc@us.ibm.com>

Towards the end of putting all core mm initialization in mm_init.c, I
plan on putting the creation of a mm kobject in a function in that file.
However, the file is currently only compiled if CONFIG_DEBUG_MEMORY_INIT
is set. Remove this dependency, but put the code under an #ifdef on the
same config option. This should result in no functional changes.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile  |    3 +--
 mm/mm_init.c |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/Makefile~mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init mm/Makefile
--- a/mm/Makefile~mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init
+++ a/mm/Makefile
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   maccess.o page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o $(mmu-y)
+			   page_isolation.o mm_init.o $(mmu-y)
 
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
@@ -26,7 +26,6 @@ obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_a
 obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_SLAB) += slab.o
-obj-$(CONFIG_DEBUG_MEMORY_INIT) += mm_init.o
 obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
diff -puN mm/mm_init.c~mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init mm/mm_init.c
--- a/mm/mm_init.c~mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init
+++ a/mm/mm_init.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include "internal.h"
 
+#ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
 
 /* The zonelists are simply reported, validation is manual. */
@@ -132,3 +133,4 @@ static __init int set_mminit_loglevel(ch
 	return 0;
 }
 early_param("mminit_loglevel", set_mminit_loglevel);
+#endif /* CONFIG_DEBUG_MEMORY_INIT */
_

Patches currently in -mm which might be from nacc@us.ibm.com are

origin.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch

