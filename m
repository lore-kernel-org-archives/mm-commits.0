From: akpm@linux-foundation.org
Subject: + powerpc-update-lmb-for-hotplug-memory-add-remove.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:38:36 -0700
Message-ID: <200803312138.m2VLcbPN027300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756766AbYCaVjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:39:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, benh@kernel.crashing.org, davem@davemloft.net, paulus@samba.org, y-goto@jp.fujitsu.com


The patch titled
     powerpc: update lmb for hotplug memory add/remove
has been added to the -mm tree.  Its filename is
     powerpc-update-lmb-for-hotplug-memory-add-remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: update lmb for hotplug memory add/remove
From: Badari Pulavarty <pbadari@us.ibm.com>

ppc kernel maintains information about logical memory blocks in lmb.memory
structure at the boot time.  Its not updated for hotplug memory add/remove. 
hotplug memory notifier for memory add/remove now updates lmb.memory.

This information is useful for eHEA driver to find out the memory layout and
holes.

NOTE: No special locking is needed for lmb_add() and lmb_remove().
Calls to these are serialized by caller. (pSeries_reconfig_chain).

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>.25-rc3/lib/lmb.c
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |   43 +++++++++
 include/linux/lmb.h                             |    3 
 lib/lmb.c                                       |   66 ++++++++++++--
 3 files changed, 102 insertions(+), 10 deletions(-)

diff -puN arch/powerpc/platforms/pseries/hotplug-memory.c~powerpc-update-lmb-for-hotplug-memory-add-remove arch/powerpc/platforms/pseries/hotplug-memory.c
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~powerpc-update-lmb-for-hotplug-memory-add-remove
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/of.h>
+#include <linux/lmb.h>
 #include <asm/firmware.h>
 #include <asm/machdep.h>
 #include <asm/pSeries_reconfig.h>
@@ -58,6 +59,11 @@ static int pseries_remove_memory(struct 
 		return ret;
 
 	/*
+	 * Update memory regions for memory remove
+	 */
+	lmb_remove(start_pfn << PAGE_SHIFT, regs[3]);
+
+	/*
 	 * Remove htab bolted mappings for this section of memory
 	 */
  	start = (unsigned long)__va(start_pfn << PAGE_SHIFT);
@@ -65,6 +71,41 @@ static int pseries_remove_memory(struct 
 	return ret;
 }
 
+static int pseries_add_memory(struct device_node *np)
+{
+	const char *type;
+	const unsigned int *my_index;
+	const unsigned int *regs;
+	u64 start_pfn;
+	int ret = -EINVAL;
+
+	/*
+	 * Check to see if we are actually adding memory
+	 */
+	type = of_get_property(np, "device_type", NULL);
+	if (type == NULL || strcmp(type, "memory") != 0)
+		return 0;
+
+	/*
+	 * Find the memory index and size of the removing section
+	 */
+	my_index = of_get_property(np, "ibm,my-drc-index", NULL);
+	if (!my_index)
+		return ret;
+
+	regs = of_get_property(np, "reg", NULL);
+	if (!regs)
+		return ret;
+
+	start_pfn = section_nr_to_pfn(*my_index & 0xffff);
+
+	/*
+	 * Update memory region to represent the memory add
+	 */
+	lmb_add(start_pfn << PAGE_SHIFT, regs[3]);
+	return 0;
+}
+
 static int pseries_memory_notifier(struct notifier_block *nb,
 				unsigned long action, void *node)
 {
@@ -72,6 +113,8 @@ static int pseries_memory_notifier(struc
 
 	switch (action) {
 	case PSERIES_RECONFIG_ADD:
+		if (pseries_add_memory(node))
+			err = NOTIFY_BAD;
 		break;
 	case PSERIES_RECONFIG_REMOVE:
 		if (pseries_remove_memory(node))
diff -puN include/linux/lmb.h~powerpc-update-lmb-for-hotplug-memory-add-remove include/linux/lmb.h
--- a/include/linux/lmb.h~powerpc-update-lmb-for-hotplug-memory-add-remove
+++ a/include/linux/lmb.h
@@ -40,7 +40,8 @@ extern struct lmb lmb;
 
 extern void __init lmb_init(void);
 extern void __init lmb_analyze(void);
-extern long __init lmb_add(u64 base, u64 size);
+extern long lmb_add(u64 base, u64 size);
+extern long lmb_remove(u64 base, u64 size);
 extern long __init lmb_reserve(u64 base, u64 size);
 extern u64 __init lmb_alloc_nid(u64 size, u64 align, int nid,
 				u64 (*nid_range)(u64, u64, int *));
diff -puN lib/lmb.c~powerpc-update-lmb-for-hotplug-memory-add-remove lib/lmb.c
--- a/lib/lmb.c~powerpc-update-lmb-for-hotplug-memory-add-remove
+++ a/lib/lmb.c
@@ -54,14 +54,13 @@ void lmb_dump_all(void)
 #endif /* DEBUG */
 }
 
-static unsigned long __init lmb_addrs_overlap(u64 base1,
-		u64 size1, u64 base2, u64 size2)
+static unsigned long lmb_addrs_overlap(u64 base1, u64 size1, u64 base2,
+		u64 size2)
 {
 	return ((base1 < (base2+size2)) && (base2 < (base1+size1)));
 }
 
-static long __init lmb_addrs_adjacent(u64 base1, u64 size1,
-		u64 base2, u64 size2)
+static long lmb_addrs_adjacent(u64 base1, u64 size1, u64 base2, u64 size2)
 {
 	if (base2 == base1 + size1)
 		return 1;
@@ -71,7 +70,7 @@ static long __init lmb_addrs_adjacent(u6
 	return 0;
 }
 
-static long __init lmb_regions_adjacent(struct lmb_region *rgn,
+static long lmb_regions_adjacent(struct lmb_region *rgn,
 		unsigned long r1, unsigned long r2)
 {
 	u64 base1 = rgn->region[r1].base;
@@ -82,7 +81,7 @@ static long __init lmb_regions_adjacent(
 	return lmb_addrs_adjacent(base1, size1, base2, size2);
 }
 
-static void __init lmb_remove_region(struct lmb_region *rgn, unsigned long r)
+static void lmb_remove_region(struct lmb_region *rgn, unsigned long r)
 {
 	unsigned long i;
 
@@ -94,7 +93,7 @@ static void __init lmb_remove_region(str
 }
 
 /* Assumption: base addr of region 1 < base addr of region 2 */
-static void __init lmb_coalesce_regions(struct lmb_region *rgn,
+static void lmb_coalesce_regions(struct lmb_region *rgn,
 		unsigned long r1, unsigned long r2)
 {
 	rgn->region[r1].size += rgn->region[r2].size;
@@ -129,7 +128,7 @@ void __init lmb_analyze(void)
 }
 
 /* This routine called with relocation disabled. */
-static long __init lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
+static long lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
 {
 	unsigned long coalesced = 0;
 	long adjacent, i;
@@ -195,7 +194,7 @@ static long __init lmb_add_region(struct
 }
 
 /* This routine may be called with relocation disabled. */
-long __init lmb_add(u64 base, u64 size)
+long lmb_add(u64 base, u64 size)
 {
 	struct lmb_region *_rgn = &(lmb.memory);
 
@@ -207,6 +206,55 @@ long __init lmb_add(u64 base, u64 size)
 
 }
 
+long lmb_remove(u64 base, u64 size)
+{
+	struct lmb_region *rgn = &(lmb.memory);
+	u64 rgnbegin, rgnend;
+	u64 end = base + size;
+	int i;
+
+	rgnbegin = rgnend = 0; /* supress gcc warnings */
+
+	/* Find the region where (base, size) belongs to */
+	for (i=0; i < rgn->cnt; i++) {
+		rgnbegin = rgn->region[i].base;
+		rgnend = rgnbegin + rgn->region[i].size;
+
+		if ((rgnbegin <= base) && (end <= rgnend))
+			break;
+	}
+
+	/* Didn't find the region */
+	if (i == rgn->cnt)
+		return -1;
+
+	/* Check to see if we are removing entire region */
+	if ((rgnbegin == base) && (rgnend == end)) {
+		lmb_remove_region(rgn, i);
+		return 0;
+	}
+
+	/* Check to see if region is matching at the front */
+	if (rgnbegin == base) {
+		rgn->region[i].base = end;
+		rgn->region[i].size -= size;
+		return 0;
+	}
+
+	/* Check to see if the region is matching at the end */
+	if (rgnend == end) {
+		rgn->region[i].size -= size;
+		return 0;
+	}
+
+	/*
+	 * We need to split the entry -  adjust the current one to the
+	 * beginging of the hole and add the region after hole.
+	 */
+	rgn->region[i].size = base - rgn->region[i].base;
+	return lmb_add_region(rgn, end, rgnend - end);
+}
+
 long __init lmb_reserve(u64 base, u64 size)
 {
 	struct lmb_region *_rgn = &(lmb.reserved);
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

hotplug-memory-remove-generic-__remove_pages-support.patch
git-powerpc.patch
powerpc-htab_remove_mapping-error-handling.patch
powerpc-hotplug-memory-notifications-for-ppc.patch
powerpc-update-lmb-for-hotplug-memory-add-remove.patch
powerpc-provide-walk_memory_resource-for-ppc.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
fs-aioc-make-3-functions-static.patch

