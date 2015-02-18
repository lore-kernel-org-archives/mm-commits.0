From: akpm@linux-foundation.org
Subject: + mm-cma-release-trigger.patch added to -mm tree
Date: Wed, 18 Feb 2015 14:18:32 -0800
Message-ID: <54e50fb8.B50Tu0uz73ICmpxh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbbBRWSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 17:18:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, iamjoonsoo.kim@lge.com, konrad.wilk@oracle.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: release trigger
has been added to the -mm tree.  Its filename is
     mm-cma-release-trigger.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-release-trigger.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-release-trigger.patch

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
Subject: mm: cma: release trigger

Provides a userspace interface to trigger a CMA release.

Usage:

	echo [pages] > free

This would provide testing/fuzzing access to the CMA release paths.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff -puN mm/cma_debug.c~mm-cma-release-trigger mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-release-trigger
+++ a/mm/cma_debug.c
@@ -39,6 +39,60 @@ static void cma_add_to_cma_mem_list(stru
 	spin_unlock(&cma->mem_head_lock);
 }
 
+static struct cma_mem *cma_get_entry_from_list(struct cma *cma)
+{
+	struct cma_mem *mem = NULL;
+
+	spin_lock(&cma->mem_head_lock);
+	if (!hlist_empty(&cma->mem_head)) {
+		mem = hlist_entry(cma->mem_head.first, struct cma_mem, node);
+		hlist_del_init(&mem->node);
+	}
+	spin_unlock(&cma->mem_head_lock);
+
+	return mem;
+}
+
+static int cma_free_mem(struct cma *cma, int count)
+{
+	struct cma_mem *mem = NULL;
+
+	while (count) {
+		mem = cma_get_entry_from_list(cma);
+		if (mem == NULL)
+			return 0;
+
+		if (mem->n <= count) {
+			cma_release(cma, mem->p, mem->n);
+			count -= mem->n;
+			kfree(mem);
+		} else if (cma->order_per_bit == 0) {
+			cma_release(cma, mem->p, count);
+			mem->p += count;
+			mem->n -= count;
+			count = 0;
+			cma_add_to_cma_mem_list(cma, mem);
+		} else {
+			pr_debug("cma: cannot release partial block when order_per_bit != 0\n");
+			cma_add_to_cma_mem_list(cma, mem);
+			break;
+		}
+	}
+
+	return 0;
+
+}
+
+static int cma_free_write(void *data, u64 val)
+{
+        int pages = val;
+	struct cma *cma = data;
+
+        return cma_free_mem(cma, pages);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_free_fops, NULL, cma_free_write, "%llu\n");
+
 static int cma_alloc_mem(struct cma *cma, int count)
 {
 	struct cma_mem *mem;
@@ -85,6 +139,9 @@ static void cma_debugfs_add_one(struct c
 	debugfs_create_file("alloc", S_IWUSR, cma_debugfs_root, cma,
 				&cma_alloc_fops);
 
+	debugfs_create_file("free", S_IWUSR, cma_debugfs_root, cma,
+				&cma_free_fops);
+
 	debugfs_create_file("base_pfn", S_IRUGO, tmp,
 				&cma->base_pfn, &cma_debugfs_fops);
 	debugfs_create_file("count", S_IRUGO, tmp,
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
mm-cma-debugfs-interface.patch
mm-cma-allocation-trigger.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

