From: akpm@linux-foundation.org
Subject: [merged] mm-cma-allocation-trigger.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:09:22 -0700
Message-ID: <552eb762.NFUcuGs+qZWJzjm9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbbDOTJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, iamjoonsoo.kim@lge.com, konrad.wilk@oracle.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: allocation trigger
has been removed from the -mm tree.  Its filename was
     mm-cma-allocation-trigger.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: cma: allocation trigger

Provides a userspace interface to trigger a CMA allocation.

Usage:

	echo [pages] > alloc

This would provide testing/fuzzing access to the CMA allocation paths.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c       |    6 +++++
 mm/cma.h       |    4 +++
 mm/cma_debug.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 63 insertions(+), 1 deletion(-)

diff -puN mm/cma.c~mm-cma-allocation-trigger mm/cma.c
--- a/mm/cma.c~mm-cma-allocation-trigger
+++ a/mm/cma.c
@@ -123,6 +123,12 @@ static int __init cma_activate_area(stru
 	} while (--i);
 
 	mutex_init(&cma->lock);
+
+#ifdef CONFIG_CMA_DEBUGFS
+	INIT_HLIST_HEAD(&cma->mem_head);
+	spin_lock_init(&cma->mem_head_lock);
+#endif
+
 	return 0;
 
 err:
diff -puN mm/cma.h~mm-cma-allocation-trigger mm/cma.h
--- a/mm/cma.h~mm-cma-allocation-trigger
+++ a/mm/cma.h
@@ -7,6 +7,10 @@ struct cma {
 	unsigned long   *bitmap;
 	unsigned int order_per_bit; /* Order of pages represented by one bit */
 	struct mutex    lock;
+#ifdef CONFIG_CMA_DEBUGFS
+	struct hlist_head mem_head;
+	spinlock_t mem_head_lock;
+#endif
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
diff -puN mm/cma_debug.c~mm-cma-allocation-trigger mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-allocation-trigger
+++ a/mm/cma_debug.c
@@ -7,9 +7,18 @@
 
 #include <linux/debugfs.h>
 #include <linux/cma.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
 
 #include "cma.h"
 
+struct cma_mem {
+	struct hlist_node node;
+	struct page *p;
+	unsigned long n;
+};
+
 static struct dentry *cma_debugfs_root;
 
 static int cma_debugfs_get(void *data, u64 *val)
@@ -23,6 +32,46 @@ static int cma_debugfs_get(void *data, u
 
 DEFINE_SIMPLE_ATTRIBUTE(cma_debugfs_fops, cma_debugfs_get, NULL, "%llu\n");
 
+static void cma_add_to_cma_mem_list(struct cma *cma, struct cma_mem *mem)
+{
+	spin_lock(&cma->mem_head_lock);
+	hlist_add_head(&mem->node, &cma->mem_head);
+	spin_unlock(&cma->mem_head_lock);
+}
+
+static int cma_alloc_mem(struct cma *cma, int count)
+{
+	struct cma_mem *mem;
+	struct page *p;
+
+	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+
+	p = cma_alloc(cma, count, CONFIG_CMA_ALIGNMENT);
+	if (!p) {
+		kfree(mem);
+		return -ENOMEM;
+	}
+
+	mem->p = p;
+	mem->n = count;
+
+	cma_add_to_cma_mem_list(cma, mem);
+
+	return 0;
+}
+
+static int cma_alloc_write(void *data, u64 val)
+{
+	int pages = val;
+	struct cma *cma = data;
+
+	return cma_alloc_mem(cma, pages);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_alloc_fops, NULL, cma_alloc_write, "%llu\n");
+
 static void cma_debugfs_add_one(struct cma *cma, int idx)
 {
 	struct dentry *tmp;
@@ -33,12 +82,15 @@ static void cma_debugfs_add_one(struct c
 
 	tmp = debugfs_create_dir(name, cma_debugfs_root);
 
+	debugfs_create_file("alloc", S_IWUSR, cma_debugfs_root, cma,
+				&cma_alloc_fops);
+
 	debugfs_create_file("base_pfn", S_IRUGO, tmp,
 				&cma->base_pfn, &cma_debugfs_fops);
 	debugfs_create_file("count", S_IRUGO, tmp,
 				&cma->count, &cma_debugfs_fops);
 	debugfs_create_file("order_per_bit", S_IRUGO, tmp,
-			&cma->order_per_bit, &cma_debugfs_fops);
+				&cma->order_per_bit, &cma_debugfs_fops);
 
 	u32s = DIV_ROUND_UP(cma_bitmap_maxno(cma), BITS_PER_BYTE * sizeof(u32));
 	debugfs_create_u32_array("bitmap", S_IRUGO, tmp, (u32*)cma->bitmap, u32s);
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

