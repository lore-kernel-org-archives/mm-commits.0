From: akpm@linux-foundation.org
Subject: - powerpc-provide-walk_memory_resource-for-ppc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:32 -0700
Message-ID: <200804300551.m3U5pWwg030230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755458AbYD3F5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, benh@kernel.crashing.org, paulus@samba.org, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: provide walk_memory_resource() for ppc
has been removed from the -mm tree.  Its filename was
     powerpc-provide-walk_memory_resource-for-ppc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: provide walk_memory_resource() for ppc
From: Badari Pulavarty <pbadari@us.ibm.com>

Provide walk_memory_resource() for ppc64.  PPC maintains logic memory region
mapping in lmb.memory structures.  Walk through these structures and do the
callbacks for the contiguous chunks.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |   30 +++++++++++++++++++++++-------
 include/linux/lmb.h   |    1 +
 lib/lmb.c             |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/mm/mem.c~powerpc-provide-walk_memory_resource-for-ppc arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~powerpc-provide-walk_memory_resource-for-ppc
+++ a/arch/powerpc/mm/mem.c
@@ -139,19 +139,35 @@ out:
 
 /*
  * walk_memory_resource() needs to make sure there is no holes in a given
- * memory range. On PPC64, since this range comes from /sysfs, the range
- * is guaranteed to be valid, non-overlapping and can not contain any
- * holes. By the time we get here (memory add or remove), /proc/device-tree
- * is updated and correct. Only reason we need to check against device-tree
- * would be if we allow user-land to specify a memory range through a
- * system call/ioctl etc. instead of doing offline/online through /sysfs.
+ * memory range. PPC64 does not maintain the memory layout in /proc/iomem.
+ * Instead it maintains it in lmb.memory structures. Walk through the
+ * memory regions, find holes and callback for contiguous regions.
  */
 int
 walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
 			int (*func)(unsigned long, unsigned long, void *))
 {
-	return  (*func)(start_pfn, nr_pages, arg);
+	struct lmb_property res;
+	unsigned long pfn, len;
+	u64 end;
+	int ret = -1;
+
+	res.base = (u64) start_pfn << PAGE_SHIFT;
+	res.size = (u64) nr_pages << PAGE_SHIFT;
+
+	end = res.base + res.size - 1;
+	while ((res.base < end) && (lmb_find(&res) >= 0)) {
+		pfn = (unsigned long)(res.base >> PAGE_SHIFT);
+		len = (unsigned long)(res.size >> PAGE_SHIFT);
+		ret = (*func)(pfn, len, arg);
+		if (ret)
+			break;
+		res.base += (res.size + 1);
+		res.size = (end - res.base + 1);
+	}
+	return ret;
 }
+EXPORT_SYMBOL_GPL(walk_memory_resource);
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
diff -puN include/linux/lmb.h~powerpc-provide-walk_memory_resource-for-ppc include/linux/lmb.h
--- a/include/linux/lmb.h~powerpc-provide-walk_memory_resource-for-ppc
+++ a/include/linux/lmb.h
@@ -54,6 +54,7 @@ extern u64 __init lmb_phys_mem_size(void
 extern u64 __init lmb_end_of_DRAM(void);
 extern void __init lmb_enforce_memory_limit(u64 memory_limit);
 extern int __init lmb_is_reserved(u64 addr);
+extern int lmb_find(struct lmb_property *res);
 
 extern void lmb_dump_all(void);
 
diff -puN lib/lmb.c~powerpc-provide-walk_memory_resource-for-ppc lib/lmb.c
--- a/lib/lmb.c~powerpc-provide-walk_memory_resource-for-ppc
+++ a/lib/lmb.c
@@ -474,3 +474,36 @@ int __init lmb_is_reserved(u64 addr)
 	}
 	return 0;
 }
+
+/*
+ * Given a <base, len>, find which memory regions belong to this range.
+ * Adjust the request and return a contiguous chunk.
+ */
+int lmb_find(struct lmb_property *res)
+{
+	int i;
+	u64 rstart, rend;
+
+	rstart = res->base;
+	rend = rstart + res->size - 1;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		u64 start = lmb.memory.region[i].base;
+		u64 end = start + lmb.memory.region[i].size - 1;
+
+		if (start > rend)
+			return -1;
+
+		if ((end >= rstart) && (start < rend)) {
+			/* adjust the request */
+			if (rstart < start)
+				rstart = start;
+			if (rend > end)
+				rend = end;
+			res->base = rstart;
+			res->size = rend - rstart + 1;
+			return 0;
+		}
+	}
+	return -1;
+}
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch

