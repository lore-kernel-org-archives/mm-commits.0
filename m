From: akpm@linux-foundation.org
Subject: - mm-rewrite-some-tests-with-is_power_of_2-for-clarity.patch removed from -mm tree
Date: Mon, 27 Apr 2009 12:59:11 -0700
Message-ID: <200904271959.n3RJxBY8031092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755933AbZD0UCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 16:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, cl@linux-foundation.org, hannes@cmpxchg.org, matthew@wil.cx, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     mm: rewrite some tests with is_power_of_2() for clarity.
has been removed from the -mm tree.  Its filename was
     mm-rewrite-some-tests-with-is_power_of_2-for-clarity.patch

This patch was dropped because the align==0 case is scary

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: rewrite some tests with is_power_of_2() for clarity.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Replace some conditional tests with the semantically clearer call to
is_power_of_2().

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    3 ++-
 mm/dmapool.c |    5 +++--
 mm/slub.c    |    3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/bootmem.c~mm-rewrite-some-tests-with-is_power_of_2-for-clarity mm/bootmem.c
--- a/mm/bootmem.c~mm-rewrite-some-tests-with-is_power_of_2-for-clarity
+++ a/mm/bootmem.c
@@ -12,6 +12,7 @@
 #include <linux/pfn.h>
 #include <linux/bootmem.h>
 #include <linux/module.h>
+#include <linux/log2.h>
 
 #include <asm/bug.h>
 #include <asm/io.h>
@@ -438,7 +439,7 @@ static void * __init alloc_bootmem_core(
 		align, goal, limit);
 
 	BUG_ON(!size);
-	BUG_ON(align & (align - 1));
+	BUG_ON(!is_power_of_2(align));
 	BUG_ON(limit && goal + size > limit);
 
 	if (!bdata->node_bootmem_map)
diff -puN mm/dmapool.c~mm-rewrite-some-tests-with-is_power_of_2-for-clarity mm/dmapool.c
--- a/mm/dmapool.c~mm-rewrite-some-tests-with-is_power_of_2-for-clarity
+++ a/mm/dmapool.c
@@ -36,6 +36,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/log2.h>
 
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB_DEBUG_ON)
 #define DMAPOOL_DEBUG 1
@@ -135,7 +136,7 @@ struct dma_pool *dma_pool_create(const c
 
 	if (align == 0) {
 		align = 1;
-	} else if (align & (align - 1)) {
+	} else if (!is_power_of_2(align)) {
 		return NULL;
 	}
 
@@ -152,7 +153,7 @@ struct dma_pool *dma_pool_create(const c
 
 	if (!boundary) {
 		boundary = allocation;
-	} else if ((boundary < size) || (boundary & (boundary - 1))) {
+	} else if ((boundary < size) || !is_power_of_2(boundary)) {
 		return NULL;
 	}
 
diff -puN mm/slub.c~mm-rewrite-some-tests-with-is_power_of_2-for-clarity mm/slub.c
--- a/mm/slub.c~mm-rewrite-some-tests-with-is_power_of_2-for-clarity
+++ a/mm/slub.c
@@ -27,6 +27,7 @@
 #include <linux/memory.h>
 #include <linux/math64.h>
 #include <linux/fault-inject.h>
+#include <linux/log2.h>
 
 /*
  * Lock order:
@@ -3060,7 +3061,7 @@ void __init kmem_cache_init(void)
 	 * around with ARCH_KMALLOC_MINALIGN
 	 */
 	BUILD_BUG_ON(KMALLOC_MIN_SIZE > 256 ||
-		(KMALLOC_MIN_SIZE & (KMALLOC_MIN_SIZE - 1)));
+		(!is_power_of_2(KMALLOC_MIN_SIZE)));
 
 	for (i = 8; i < KMALLOC_MIN_SIZE; i += 8)
 		size_index[(i - 1) / 8] = KMALLOC_SHIFT_LOW;
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
drm-simplify-kcalloc-call-to-kzalloc.patch
makefile-make-prepare-should-be-make-modules_prepare.patch
kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch
mm-rewrite-some-tests-with-is_power_of_2-for-clarity.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch

