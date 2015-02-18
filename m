From: akpm@linux-foundation.org
Subject: + mm-cma-debugfs-interface.patch added to -mm tree
Date: Wed, 18 Feb 2015 14:18:28 -0800
Message-ID: <54e50fb4.puvwoVGPuJvMAhMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbbBRWS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 17:18:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, iamjoonsoo.kim@lge.com, konrad.wilk@oracle.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: debugfs interface
has been added to the -mm tree.  Its filename is
     mm-cma-debugfs-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-debugfs-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-debugfs-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: cma: debugfs interface

I've noticed that there is no interfaces exposed by CMA which would let me
fuzz what's going on in there.

This small patchset exposes some information out to userspace, plus adds
the ability to trigger allocation and freeing from userspace.



This patch (of 3):

Implement a simple debugfs interface to expose information about CMA areas
in the system.

Useful for testing/sanity checks for CMA since it was impossible to
previously retrieve this information in userspace.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig     |    6 ++++
 mm/Makefile    |    1 
 mm/cma.c       |   17 ++-----------
 mm/cma.h       |   20 +++++++++++++++
 mm/cma_debug.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 91 insertions(+), 14 deletions(-)

diff -puN mm/Kconfig~mm-cma-debugfs-interface mm/Kconfig
--- a/mm/Kconfig~mm-cma-debugfs-interface
+++ a/mm/Kconfig
@@ -517,6 +517,12 @@ config CMA_DEBUG
 	  processing calls such as dma_alloc_from_contiguous().
 	  This option does not affect warning and error messages.
 
+config CMA_DEBUGFS
+	bool "CMA debugfs interface"
+	depends on CMA && DEBUG_FS
+	help
+	  Turns on the DebugFS interface for CMA.
+
 config CMA_AREAS
 	int "Maximum count of the CMA areas"
 	depends on CMA
diff -puN mm/Makefile~mm-cma-debugfs-interface mm/Makefile
--- a/mm/Makefile~mm-cma-debugfs-interface
+++ a/mm/Makefile
@@ -76,3 +76,4 @@ obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += e
 obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
+obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
diff -puN mm/cma.c~mm-cma-debugfs-interface mm/cma.c
--- a/mm/cma.c~mm-cma-debugfs-interface
+++ a/mm/cma.c
@@ -35,16 +35,10 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 
-struct cma {
-	unsigned long	base_pfn;
-	unsigned long	count;
-	unsigned long	*bitmap;
-	unsigned int order_per_bit; /* Order of pages represented by one bit */
-	struct mutex	lock;
-};
+#include "cma.h"
 
-static struct cma cma_areas[MAX_CMA_AREAS];
-static unsigned cma_area_count;
+struct cma cma_areas[MAX_CMA_AREAS];
+unsigned cma_area_count;
 static DEFINE_MUTEX(cma_mutex);
 
 phys_addr_t cma_get_base(struct cma *cma)
@@ -75,11 +69,6 @@ static unsigned long cma_bitmap_aligned_
 		(cma->base_pfn >> cma->order_per_bit);
 }
 
-static unsigned long cma_bitmap_maxno(struct cma *cma)
-{
-	return cma->count >> cma->order_per_bit;
-}
-
 static unsigned long cma_bitmap_pages_to_bits(struct cma *cma,
 						unsigned long pages)
 {
diff -puN /dev/null mm/cma.h
--- /dev/null
+++ a/mm/cma.h
@@ -0,0 +1,20 @@
+#ifndef __MM_CMA_H__
+#define __MM_CMA_H__
+
+struct cma {
+	unsigned long   base_pfn;
+	unsigned long   count;
+	unsigned long   *bitmap;
+	unsigned int order_per_bit; /* Order of pages represented by one bit */
+	struct mutex    lock;
+};
+
+extern struct cma cma_areas[MAX_CMA_AREAS];
+extern unsigned cma_area_count;
+
+static unsigned long cma_bitmap_maxno(struct cma *cma)
+{
+	return cma->count >> cma->order_per_bit;
+}
+
+#endif
diff -puN /dev/null mm/cma_debug.c
--- /dev/null
+++ a/mm/cma_debug.c
@@ -0,0 +1,61 @@
+/*
+ * CMA DebugFS Interface
+ *
+ * Copyright (c) 2015 Sasha Levin <sasha.levin@oracle.com>
+ */
+
+
+#include <linux/debugfs.h>
+#include <linux/cma.h>
+
+#include "cma.h"
+
+static struct dentry *cma_debugfs_root;
+
+static int cma_debugfs_get(void *data, u64 *val)
+{
+	unsigned long *p = data;
+
+	*val = *p;
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_debugfs_fops, cma_debugfs_get, NULL, "%llu\n");
+
+static void cma_debugfs_add_one(struct cma *cma, int idx)
+{
+	struct dentry *tmp;
+	char name[16];
+	int u32s;
+
+	sprintf(name, "cma-%d", idx);
+
+	tmp = debugfs_create_dir(name, cma_debugfs_root);
+
+	debugfs_create_file("base_pfn", S_IRUGO, tmp,
+				&cma->base_pfn, &cma_debugfs_fops);
+	debugfs_create_file("count", S_IRUGO, tmp,
+				&cma->count, &cma_debugfs_fops);
+	debugfs_create_file("order_per_bit", S_IRUGO, tmp,
+			&cma->order_per_bit, &cma_debugfs_fops);
+
+	u32s = DIV_ROUND_UP(cma_bitmap_maxno(cma), BITS_PER_BYTE * sizeof(u32));
+	debugfs_create_u32_array("bitmap", S_IRUGO, tmp, (u32*)cma->bitmap, u32s);
+}
+
+static int __init cma_debugfs_init(void)
+{
+	int i;
+
+	cma_debugfs_root = debugfs_create_dir("cma", NULL);
+	if (!cma_debugfs_root)
+		return -ENOMEM;
+
+	for (i = 0; i < cma_area_count; i++)
+		cma_debugfs_add_one(&cma_areas[i], i);
+
+	return 0;
+}
+late_initcall(cma_debugfs_init);
+
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
mm-cma-debugfs-interface.patch
mm-cma-allocation-trigger.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

