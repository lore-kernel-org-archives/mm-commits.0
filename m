From: akpm@linux-foundation.org
Subject: [merged] mm-sparsemem-break-out-of-loops-early.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:08:09 -0700
Message-ID: <20170707190809.L_adHxy-I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdGGTIK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, sparsemem: break out of loops early
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-break-out-of-loops-early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm, sparsemem: break out of loops early

There are a number of times that we loop over NR_MEM_SECTIONS, looking for
section_present() on each section.  But, when we have very large physical
address spaces (large MAX_PHYSMEM_BITS), NR_MEM_SECTIONS becomes very
large, making the loops quite long.

With MAX_PHYSMEM_BITS=46 and a section size of 128MB, the current loops
are 512k iterations, which we barely notice on modern hardware.  But,
raising MAX_PHYSMEM_BITS higher (like we will see on systems that support
5-level paging) makes this 64x longer and we start to notice, especially
on slower systems like simulators.  A 10-second delay for 512k iterations
is annoying.  But, a 640- second delay is crippling.

This does not help if we have extremely sparse physical address spaces,
but those are quite rare.  We expect that most of the "slow" systems where
this matters will also be quite small and non-sparse.

To fix this, we track the highest section we've ever encountered.  This
lets us know when we will *never* see another section_present(), and lets
us break out of the loops earlier.

Doing the whole for_each_present_section_nr() macro is probably overkill,
but it will ensure that any future loop iterations that we grow are more
likely to be correct.

Kirrill said "It shaved almost 40 seconds from boot time in qemu with
5-level paging enabled for me".

Link: http://lkml.kernel.org/r/20170504174434.C45A4735@viggo.jf.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |    4 ++
 include/linux/mmzone.h |    2 +
 mm/sparse.c            |   60 +++++++++++++++++++++++++++++----------
 3 files changed, 52 insertions(+), 14 deletions(-)

diff -puN drivers/base/memory.c~mm-sparsemem-break-out-of-loops-early drivers/base/memory.c
--- a/drivers/base/memory.c~mm-sparsemem-break-out-of-loops-early
+++ a/drivers/base/memory.c
@@ -820,6 +820,10 @@ int __init memory_dev_init(void)
 	 */
 	mutex_lock(&mem_sysfs_mutex);
 	for (i = 0; i < NR_MEM_SECTIONS; i += sections_per_block) {
+		/* Don't iterate over sections we know are !present: */
+		if (i > __highest_present_section_nr)
+			break;
+
 		err = add_memory_block(i);
 		if (!ret)
 			ret = err;
diff -puN include/linux/mmzone.h~mm-sparsemem-break-out-of-loops-early include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-sparsemem-break-out-of-loops-early
+++ a/include/linux/mmzone.h
@@ -1180,6 +1180,8 @@ static inline struct mem_section *__pfn_
 	return __nr_to_section(pfn_to_section_nr(pfn));
 }
 
+extern int __highest_present_section_nr;
+
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 static inline int pfn_valid(unsigned long pfn)
 {
diff -puN mm/sparse.c~mm-sparsemem-break-out-of-loops-early mm/sparse.c
--- a/mm/sparse.c~mm-sparsemem-break-out-of-loops-early
+++ a/mm/sparse.c
@@ -168,6 +168,44 @@ void __meminit mminit_validate_memmodel_
 	}
 }
 
+/*
+ * There are a number of times that we loop over NR_MEM_SECTIONS,
+ * looking for section_present() on each.  But, when we have very
+ * large physical address spaces, NR_MEM_SECTIONS can also be
+ * very large which makes the loops quite long.
+ *
+ * Keeping track of this gives us an easy way to break out of
+ * those loops early.
+ */
+int __highest_present_section_nr;
+static void section_mark_present(struct mem_section *ms)
+{
+	int section_nr = __section_nr(ms);
+
+	if (section_nr > __highest_present_section_nr)
+		__highest_present_section_nr = section_nr;
+
+	ms->section_mem_map |= SECTION_MARKED_PRESENT;
+}
+
+static inline int next_present_section_nr(int section_nr)
+{
+	do {
+		section_nr++;
+		if (present_section_nr(section_nr))
+			return section_nr;
+	} while ((section_nr < NR_MEM_SECTIONS) &&
+		 (section_nr <= __highest_present_section_nr));
+
+	return -1;
+}
+#define for_each_present_section_nr(start, section_nr)		\
+	for (section_nr = next_present_section_nr(start-1);	\
+	     ((section_nr >= 0) &&				\
+	      (section_nr < NR_MEM_SECTIONS) &&			\
+	      (section_nr <= __highest_present_section_nr));	\
+	     section_nr = next_present_section_nr(section_nr))
+
 /* Record a memory area against a node. */
 void __init memory_present(int nid, unsigned long start, unsigned long end)
 {
@@ -183,9 +221,10 @@ void __init memory_present(int nid, unsi
 		set_section_nid(section, nid);
 
 		ms = __nr_to_section(section);
-		if (!ms->section_mem_map)
-			ms->section_mem_map = sparse_encode_early_nid(nid) |
-							SECTION_MARKED_PRESENT;
+		if (!ms->section_mem_map) {
+			ms->section_mem_map = sparse_encode_early_nid(nid);
+			section_mark_present(ms);
+		}
 	}
 }
 
@@ -476,23 +515,19 @@ static void __init alloc_usemap_and_memm
 	int nodeid_begin = 0;
 	unsigned long pnum_begin = 0;
 
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+	for_each_present_section_nr(0, pnum) {
 		struct mem_section *ms;
 
-		if (!present_section_nr(pnum))
-			continue;
 		ms = __nr_to_section(pnum);
 		nodeid_begin = sparse_early_nid(ms);
 		pnum_begin = pnum;
 		break;
 	}
 	map_count = 1;
-	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
+	for_each_present_section_nr(pnum_begin + 1, pnum) {
 		struct mem_section *ms;
 		int nodeid;
 
-		if (!present_section_nr(pnum))
-			continue;
 		ms = __nr_to_section(pnum);
 		nodeid = sparse_early_nid(ms);
 		if (nodeid == nodeid_begin) {
@@ -561,10 +596,7 @@ void __init sparse_init(void)
 							(void *)map_map);
 #endif
 
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		if (!present_section_nr(pnum))
-			continue;
