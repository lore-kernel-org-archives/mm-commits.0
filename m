From: akpm@linux-foundation.org
Subject: [merged] page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:05 -0800
Message-ID: <20130225205305.B229D5A42BF@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:40814 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab3BYUxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:06 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so347881ggn.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: psz@maths.usyd.edu.au, fengguang.wu@intel.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-writeback.c: subtract min_free_kbytes from dirtyable memory
has been removed from the -mm tree.  Its filename was
     page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Szabo <psz@maths.usyd.edu.au>
Subject: page-writeback.c: subtract min_free_kbytes from dirtyable memory

When calculating amount of dirtyable memory, min_free_kbytes should be
subtracted because it is not intended for dirty pages.

Addresses http://bugs.debian.org/695182

[akpm@linux-foundation.org: fix up min_free_kbytes extern declarations]
[akpm@linux-foundation.org: fix min() warning]
Signed-off-by: Paul Szabo <psz@maths.usyd.edu.au>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    3 +++
 kernel/sysctl.c     |    1 -
 mm/huge_memory.c    |    1 -
 mm/page-writeback.c |    3 +++
 4 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory include/linux/mm.h
--- a/include/linux/mm.h~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory
+++ a/include/linux/mm.h
@@ -1393,6 +1393,9 @@ extern void setup_per_cpu_pageset(void);
 extern void zone_pcp_update(struct zone *zone);
 extern void zone_pcp_reset(struct zone *zone);
 
+/* page_alloc.c */
+extern int min_free_kbytes;
+
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
diff -puN kernel/sysctl.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory kernel/sysctl.c
--- a/kernel/sysctl.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory
+++ a/kernel/sysctl.c
@@ -105,7 +105,6 @@ extern char core_pattern[];
 extern unsigned int core_pipe_limit;
 #endif
 extern int pid_max;
-extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
diff -puN mm/huge_memory.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory mm/huge_memory.c
--- a/mm/huge_memory.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory
+++ a/mm/huge_memory.c
@@ -105,7 +105,6 @@ static int set_recommended_min_free_kbyt
 	struct zone *zone;
 	int nr_zones = 0;
 	unsigned long recommended_min;
-	extern int min_free_kbytes;
 
 	if (!khugepaged_enabled())
 		return 0;
diff -puN mm/page-writeback.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -241,6 +241,9 @@ static unsigned long global_dirtyable_me
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
 
+	/* Subtract min_free_kbytes */
+	x -= min_t(unsigned long, x, min_free_kbytes >> (PAGE_SHIFT - 10));
+
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
_

Patches currently in -mm which might be from psz@maths.usyd.edu.au are

origin.patch
linux-next.patch

