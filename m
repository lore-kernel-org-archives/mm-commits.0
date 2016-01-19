From: akpm@linux-foundation.org
Subject: [merged] memblock-fix-section-mismatch.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:14:01 -0800
Message-ID: <569e9909.P0vhdzd/LaOFsA7i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: fix section mismatch
has been removed from the -mm tree.  Its filename was
     memblock-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: memblock: fix section mismatch

allmodconfig produces following warning for me:

  WARNING: vmlinux.o(.text.unlikely+0x10314): Section mismatch in reference from the function movable_node_is_enabled() to the variable .meminit.data:movable_node_enabled
  The function movable_node_is_enabled() references
  the variable __meminitdata movable_node_enabled.
  This is often because movable_node_is_enabled lacks a __meminitdata
  annotation or the annotation of movable_node_enabled is wrong.

Let's mark the function with __meminit. It fixes the warning.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/memblock.h~memblock-fix-section-mismatch include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-fix-section-mismatch
+++ a/include/linux/memblock.h
@@ -61,6 +61,14 @@ extern int memblock_debug;
 extern bool movable_node_enabled;
 #endif /* CONFIG_MOVABLE_NODE */
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+#define __init_memblock __meminit
+#define __initdata_memblock __meminitdata
+#else
+#define __init_memblock
+#define __initdata_memblock
+#endif
+
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
@@ -166,7 +174,7 @@ static inline bool memblock_is_hotplugga
 	return m->flags & MEMBLOCK_HOTPLUG;
 }
 
-static inline bool movable_node_is_enabled(void)
+static inline bool __init_memblock movable_node_is_enabled(void)
 {
 	return movable_node_enabled;
 }
@@ -405,14 +413,6 @@ static inline unsigned long memblock_reg
 	for (idx = 0; idx < memblock_type->cnt;				\
 	     idx++,rgn = &memblock_type->regions[idx])
 
-#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
-#define __init_memblock __meminit
-#define __initdata_memblock __meminitdata
-#else
-#define __init_memblock
-#define __initdata_memblock
-#endif
