From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:13 -0700
Message-ID: <201106282041.p5SKftvd002939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115Ab1F1UmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mingo@elte.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix node_start/end_pfn() definition for mm/page_cgroup.c
has been removed from the -mm tree.  Its filename was
     memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix node_start/end_pfn() definition for mm/page_cgroup.c
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 37573e8c7182 ("memcg: fix init_page_cgroup nid with sparsemem")
uses node_start/end_pfn(nid) for detection start/end of nodes.  But, it's
not defined in linux/mmzone.h but defined in /arch/???/include/mmzone.h
which is included only under CONFIG_NEED_MULTIPLE_NODES=y.

Then, we see
mm/page_cgroup.c: In function 'page_cgroup_init':
mm/page_cgroup.c:308: error: implicit declaration of function 'node_start_pfn'
mm/page_cgroup.c:309: error: implicit declaration of function 'node_end_pfn'

So, fixing page_cgroup.c is an idea...

But node_start_pfn()/node_end_pfn() is a very generic macro and should be
implemented in the same manner for all archs.  (m32r has different
implementation...)

This patch removes definitions of node_start/end_pfn() in each archs and
defines a unified one in linux/mmzone.h.  It's not under
CONFIG_NEED_MULTIPLE_NODES, now.

A result of macro expansion is here (mm/page_cgroup.c)

for !NUMA
 start_pfn = ((&contig_page_data)->node_start_pfn);
  end_pfn = ({ pg_data_t *__pgdat = (&contig_page_data); __pgdat->node_start_pfn + __pgdat->node_spanned_pages;});

for NUMA (x86-64)
  start_pfn = ((node_data[nid])->node_start_pfn);
  end_pfn = ({ pg_data_t *__pgdat = (node_data[nid]); __pgdat->node_start_pfn + __pgdat->node_spanned_pages;});

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mmzone.h   |    1 -
 arch/m32r/include/asm/mmzone.h    |    8 +-------
 arch/parisc/include/asm/mmzone.h  |    7 -------
 arch/powerpc/include/asm/mmzone.h |    7 -------
 arch/sh/include/asm/mmzone.h      |    4 ----
 arch/sparc/include/asm/mmzone.h   |    2 --
 arch/tile/include/asm/mmzone.h    |   11 -----------
 arch/x86/include/asm/mmzone_32.h  |   11 -----------
 arch/x86/include/asm/mmzone_64.h  |    3 ---
 include/linux/mmzone.h            |    7 +++++++
 10 files changed, 8 insertions(+), 53 deletions(-)

diff -puN arch/alpha/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc arch/alpha/include/asm/mmzone.h
--- a/arch/alpha/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/arch/alpha/include/asm/mmzone.h
@@ -56,7 +56,6 @@ PLAT_NODE_DATA_LOCALNR(unsigned long p, 
  * Given a kernel address, find the home node of the underlying memory.
  */
 #define kvaddr_to_nid(kaddr)	pa_to_nid(__pa(kaddr))
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
 
 /*
  * Given a kaddr, LOCAL_BASE_ADDR finds the owning node of the memory
diff -puN arch/m32r/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc arch/m32r/include/asm/mmzone.h
--- a/arch/m32r/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/arch/m32r/include/asm/mmzone.h
@@ -14,12 +14,6 @@ extern struct pglist_data *node_data[];
 #define NODE_DATA(nid)		(node_data[nid])
 
 #define node_localnr(pfn, nid)	((pfn) - NODE_DATA(nid)->node_start_pfn)
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)						\
-({									\
-	pg_data_t *__pgdat = NODE_DATA(nid);				\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages - 1;	\
-})
 
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
 /*
@@ -44,7 +38,7 @@ static __inline__ int pfn_to_nid(unsigne
 	int node;
 
 	for (node = 0 ; node < MAX_NUMNODES ; node++)
-		if (pfn >= node_start_pfn(node) && pfn <= node_end_pfn(node))
+		if (pfn >= node_start_pfn(node) && pfn < node_end_pfn(node))
 			break;
 
 	return node;
diff -puN arch/parisc/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc arch/parisc/include/asm/mmzone.h
--- a/arch/parisc/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/arch/parisc/include/asm/mmzone.h
@@ -14,13 +14,6 @@ extern struct node_map_data node_data[];
 
 #define NODE_DATA(nid)          (&node_data[nid].pg_data)
 
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)						\
-({									\
-	pg_data_t *__pgdat = NODE_DATA(nid);				\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
-})
-
 /* We have these possible memory map layouts:
  * Astro: 0-3.75, 67.75-68, 4-64
  * zx1: 0-1, 257-260, 4-256
diff -puN arch/powerpc/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc arch/powerpc/include/asm/mmzone.h
--- a/arch/powerpc/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/arch/powerpc/include/asm/mmzone.h
@@ -38,13 +38,6 @@ u64 memory_hotplug_max(void);
 #define memory_hotplug_max() memblock_end_of_DRAM()
 #endif
 
-/*
- * Following are macros that each numa implmentation must define.
- */
-
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)	(NODE_DATA(nid)->node_end_pfn)
-
 #else
 #define memory_hotplug_max() memblock_end_of_DRAM()
 #endif /* CONFIG_NEED_MULTIPLE_NODES */
diff -puN arch/sh/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc arch/sh/include/asm/mmzone.h
--- a/arch/sh/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/arch/sh/include/asm/mmzone.h
@@ -9,10 +9,6 @@
 extern struct pglist_data *node_data[];
 #define NODE_DATA(nid)		(node_data[nid])
 
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)	(NODE_DATA(nid)->node_start_pfn + \
-				 NODE_DATA(nid)->node_spanned_pages)
-
 static inline int pfn_to_nid(unsigned long pfn)
 {
 	int nid;
diff -puN arch/sparc/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc arch/sparc/include/asm/mmzone.h
--- a/arch/sparc/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/arch/sparc/include/asm/mmzone.h
@@ -8,8 +8,6 @@
 extern struct pglist_data *node_data[];
 
 #define NODE_DATA(nid)		(node_data[nid])
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)	(NODE_DATA(nid)->node_end_pfn)
 
 extern int numa_cpu_lookup_table[];
 extern cpumask_t numa_cpumask_lookup_table[];
diff -puN arch/tile/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc arch/tile/include/asm/mmzone.h
--- a/arch/tile/include/asm/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/arch/tile/include/asm/mmzone.h
@@ -40,17 +40,6 @@ static inline int pfn_to_nid(unsigned lo
 	return highbits_to_node[__pfn_to_highbits(pfn)];
 }
 
-/*
- * Following are macros that each numa implmentation must define.
- */
-
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)						\
-({									\
-	pg_data_t *__pgdat = NODE_DATA(nid);				\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
-})
-
 #define kern_addr_valid(kaddr)	virt_addr_valid((void *)kaddr)
 
 static inline int pfn_valid(int pfn)
diff -puN arch/x86/include/asm/mmzone_32.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc arch/x86/include/asm/mmzone_32.h
--- a/arch/x86/include/asm/mmzone_32.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/arch/x86/include/asm/mmzone_32.h
@@ -48,17 +48,6 @@ static inline int pfn_to_nid(unsigned lo
 #endif
 }
 
-/*
- * Following are macros that each numa implmentation must define.
- */
-
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)						\
-({									\
-	pg_data_t *__pgdat = NODE_DATA(nid);				\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
-})
-
 static inline int pfn_valid(int pfn)
 {
 	int nid = pfn_to_nid(pfn);
diff -puN arch/x86/include/asm/mmzone_64.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc arch/x86/include/asm/mmzone_64.h
--- a/arch/x86/include/asm/mmzone_64.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/arch/x86/include/asm/mmzone_64.h
@@ -13,8 +13,5 @@ extern struct pglist_data *node_data[];
 
 #define NODE_DATA(nid)		(node_data[nid])
 
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn +	\
-				 NODE_DATA(nid)->node_spanned_pages)
 #endif
 #endif /* _ASM_X86_MMZONE_64_H */
diff -puN include/linux/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc include/linux/mmzone.h
--- a/include/linux/mmzone.h~memcg-fix-node_start-end_pfn-definition-for-mm-page_cgroupc
+++ a/include/linux/mmzone.h
@@ -647,6 +647,13 @@ typedef struct pglist_data {
 #endif
 #define nid_page_nr(nid, pagenr) 	pgdat_page_nr(NODE_DATA(nid),(pagenr))
 
+#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
+
+#define node_end_pfn(nid) ({\
+	pg_data_t *__pgdat = NODE_DATA(nid);\
+	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;\
+})
+
 #include <linux/memory_hotplug.h>
 
 extern struct mutex zonelists_mutex;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

