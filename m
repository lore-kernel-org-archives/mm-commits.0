From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-introduce-for_each_memblock_type.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:14 -0800
Message-ID: <569973e6.Zq+qVUctRdl/kjH1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: introduce for_each_memblock_type()
has been removed from the -mm tree.  Its filename was
     mm-memblock-introduce-for_each_memblock_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock: introduce for_each_memblock_type()

We already have the for_each_memblock() macro in <linux/memblock.h> which
provides ability to iterate over memblock regions of a known type.  The
for_each_memblock() macro allows us to pass the pointer to the struct
memblock_type, instead we need to pass name of the type.

This patch introduces a new macro for_each_memblock_type() which allows us
iterate over memblock regions with the given type when the type is
unknown.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    5 +++++
 mm/memblock.c            |   32 ++++++++++++++++----------------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-introduce-for_each_memblock_type include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-introduce-for_each_memblock_type
+++ a/include/linux/memblock.h
@@ -399,6 +399,11 @@ static inline unsigned long memblock_reg
 	     region < (memblock.memblock_type.regions + memblock.memblock_type.cnt);	\
 	     region++)
 
+#define for_each_memblock_type(memblock_type, rgn)			\
+	idx = 0;							\
+	rgn = &memblock_type->regions[idx];				\
+	for (idx = 0; idx < memblock_type->cnt;				\
+	     idx++,rgn = &memblock_type->regions[idx])
 
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
 #define __init_memblock __meminit
diff -puN mm/memblock.c~mm-memblock-introduce-for_each_memblock_type mm/memblock.c
--- a/mm/memblock.c~mm-memblock-introduce-for_each_memblock_type
+++ a/mm/memblock.c
@@ -525,7 +525,8 @@ int __init_memblock memblock_add_range(s
 	bool insert = false;
 	phys_addr_t obase = base;
 	phys_addr_t end = base + memblock_cap_size(base, &size);
-	int i, nr_new;
+	int idx, nr_new;
+	struct memblock_region *rgn;
 
 	if (!size)
 		return 0;
@@ -549,8 +550,7 @@ repeat:
 	base = obase;
 	nr_new = 0;
 
-	for (i = 0; i < type->cnt; i++) {
-		struct memblock_region *rgn = &type->regions[i];
+	for_each_memblock_type(type, rgn) {
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -569,7 +569,7 @@ repeat:
 			WARN_ON(flags != rgn->flags);
 			nr_new++;
 			if (insert)
-				memblock_insert_region(type, i++, base,
+				memblock_insert_region(type, idx++, base,
 						       rbase - base, nid,
 						       flags);
 		}
@@ -581,7 +581,7 @@ repeat:
 	if (base < end) {
 		nr_new++;
 		if (insert)
-			memblock_insert_region(type, i, base, end - base,
+			memblock_insert_region(type, idx, base, end - base,
 					       nid, flags);
 	}
 
@@ -648,7 +648,8 @@ static int __init_memblock memblock_isol
 					int *start_rgn, int *end_rgn)
 {
 	phys_addr_t end = base + memblock_cap_size(base, &size);
-	int i;
+	int idx;
+	struct memblock_region *rgn;
 
 	*start_rgn = *end_rgn = 0;
 
@@ -660,8 +661,7 @@ static int __init_memblock memblock_isol
 		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
-	for (i = 0; i < type->cnt; i++) {
-		struct memblock_region *rgn = &type->regions[i];
+	for_each_memblock_type(type, rgn) {
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -678,7 +678,7 @@ static int __init_memblock memblock_isol
 			rgn->base = base;
 			rgn->size -= base - rbase;
 			type->total_size -= base - rbase;
-			memblock_insert_region(type, i, rbase, base - rbase,
+			memblock_insert_region(type, idx, rbase, base - rbase,
 					       memblock_get_region_node(rgn),
 					       rgn->flags);
 		} else if (rend > end) {
@@ -689,14 +689,14 @@ static int __init_memblock memblock_isol
 			rgn->base = end;
 			rgn->size -= end - rbase;
 			type->total_size -= end - rbase;
-			memblock_insert_region(type, i--, rbase, end - rbase,
+			memblock_insert_region(type, idx--, rbase, end - rbase,
 					       memblock_get_region_node(rgn),
 					       rgn->flags);
 		} else {
 			/* @rgn is fully contained, record it */
 			if (!*end_rgn)
-				*start_rgn = i;
-			*end_rgn = i + 1;
+				*start_rgn = idx;
+			*end_rgn = idx + 1;
 		}
 	}
 
@@ -1638,12 +1638,12 @@ static void __init_memblock memblock_dum
 {
 	unsigned long long base, size;
 	unsigned long flags;
-	int i;
+	int idx;
+	struct memblock_region *rgn;
 
 	pr_info(" %s.cnt  = 0x%lx\n", name, type->cnt);
 
-	for (i = 0; i < type->cnt; i++) {
-		struct memblock_region *rgn = &type->regions[i];
+	for_each_memblock_type(type, rgn) {
 		char nid_buf[32] = "";
 
 		base = rgn->base;
@@ -1655,7 +1655,7 @@ static void __init_memblock memblock_dum
 				 memblock_get_region_node(rgn));
 #endif
 		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes%s flags: %#lx\n",
-			name, i, base, base + size - 1, size, nid_buf, flags);
+			name, idx, base, base + size - 1, size, nid_buf, flags);
 	}
 }
 
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-page_alloc-remove-unused-struct-zone-z-variable.patch

