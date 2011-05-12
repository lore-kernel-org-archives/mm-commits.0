From: akpm@linux-foundation.org
Subject: [merged] mm-add-alloc_pages_exact_nid.patch removed from -mm tree
Date: Thu, 12 May 2011 11:54:47 -0700
Message-ID: <201105121847.p4CIlKdx025941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab1ELSrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 14:47:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, balbir@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: add alloc_pages_exact_nid()
has been removed from the -mm tree.  Its filename was
     mm-add-alloc_pages_exact_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add alloc_pages_exact_nid()
From: Andi Kleen <ak@linux.intel.com>

Add a alloc_pages_exact_nid() that allocates on a specific node.

The naming is quite broken, but fixing that would need a larger renaming
action.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: tweak comment]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +
 mm/page_alloc.c     |   49 +++++++++++++++++++++++++++++++-----------
 2 files changed, 39 insertions(+), 12 deletions(-)

diff -puN include/linux/gfp.h~mm-add-alloc_pages_exact_nid include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-alloc_pages_exact_nid
+++ a/include/linux/gfp.h
@@ -353,6 +353,8 @@ extern unsigned long get_zeroed_page(gfp
 
 void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
 void free_pages_exact(void *virt, size_t size);
+/* This is different from alloc_pages_exact_node !!! */
+void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask), 0)
diff -puN mm/page_alloc.c~mm-add-alloc_pages_exact_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-alloc_pages_exact_nid
+++ a/mm/page_alloc.c
@@ -2317,6 +2317,21 @@ void free_pages(unsigned long addr, unsi
 
 EXPORT_SYMBOL(free_pages);
 
+static void *make_alloc_exact(unsigned long addr, unsigned order, size_t size)
+{
+	if (addr) {
+		unsigned long alloc_end = addr + (PAGE_SIZE << order);
+		unsigned long used = addr + PAGE_ALIGN(size);
+
+		split_page(virt_to_page((void *)addr), order);
+		while (used < alloc_end) {
+			free_page(used);
+			used += PAGE_SIZE;
+		}
+	}
+	return (void *)addr;
+}
+
 /**
  * alloc_pages_exact - allocate an exact number physically-contiguous pages.
  * @size: the number of bytes to allocate
@@ -2336,22 +2351,32 @@ void *alloc_pages_exact(size_t size, gfp
 	unsigned long addr;
 
 	addr = __get_free_pages(gfp_mask, order);
-	if (addr) {
-		unsigned long alloc_end = addr + (PAGE_SIZE << order);
-		unsigned long used = addr + PAGE_ALIGN(size);
-
-		split_page(virt_to_page((void *)addr), order);
-		while (used < alloc_end) {
-			free_page(used);
-			used += PAGE_SIZE;
-		}
-	}
-
-	return (void *)addr;
+	return make_alloc_exact(addr, order, size);
 }
 EXPORT_SYMBOL(alloc_pages_exact);
 
 /**
+ * alloc_pages_exact_nid - allocate an exact number of physically-contiguous
+ *			   pages on a node.
+ * @size: the number of bytes to allocate
+ * @gfp_mask: GFP flags for the allocation
+ *
+ * Like alloc_pages_exact(), but try to allocate on node nid first before falling
+ * back.
+ * Note this is not alloc_pages_exact_node() which allocates on a specific node,
+ * but is not exact.
+ */
+void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
+{
+	unsigned order = get_order(size);
+	struct page *p = alloc_pages_node(nid, gfp_mask, order);
+	if (!p)
+		return NULL;
+	return make_alloc_exact((unsigned long)page_address(p), order, size);
+}
+EXPORT_SYMBOL(alloc_pages_exact_nid);
+
+/**
  * free_pages_exact - release memory allocated via alloc_pages_exact()
  * @virt: the value returned by alloc_pages_exact.
  * @size: size of allocation, same value as passed to alloc_pages_exact().
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
readahead-return-early-when-readahead-is-disabled.patch
readahead-reduce-unnecessary-mmap_miss-increases.patch
readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch

