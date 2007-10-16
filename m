From: akpm@linux-foundation.org
Subject: - sparsemem-record-when-a-section-has-a-valid-mem_map.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:21 -0700
Message-ID: <200710162030.l9GKULVC014395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965765AbXJPV4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, ak@suse.de, benh@kernel.crashing.org, clameter@sgi.com, davem@davemloft.net, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, paulus@samba.org, tony.luck@intel.com, mm


The patch titled
     sparsemem: record when a section has a valid mem_map
has been removed from the -mm tree.  Its filename was
     sparsemem-record-when-a-section-has-a-valid-mem_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sparsemem: record when a section has a valid mem_map
From: Andy Whitcroft <apw@shadowen.org>

We have flags to indicate whether a section actually has a valid mem_map
associated with it.  This is never set and we rely solely on the present bit
to indicate a section is valid.  By definition a section is not valid if it
has no mem_map and there is a window during init where the present bit is set
but there is no mem_map, during which pfn_valid() will return true
incorrectly.

Use the existing SECTION_HAS_MEM_MAP flag to indicate the presence of a valid
mem_map.  Switch valid_section{,_nr} and pfn_valid() to this bit.  Add a new
present_section{,_nr} and pfn_present() interfaces for those users who care to
know that a section is going to be valid.

[akpm@linux-foundation.org: coding-syle fixes]
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |    6 +++---
 include/linux/mmzone.h |   16 ++++++++++++++--
 mm/sparse.c            |    9 +++++----
 3 files changed, 22 insertions(+), 9 deletions(-)

diff -puN drivers/base/memory.c~sparsemem-record-when-a-section-has-a-valid-mem_map drivers/base/memory.c
--- a/drivers/base/memory.c~sparsemem-record-when-a-section-has-a-valid-mem_map
+++ a/drivers/base/memory.c
@@ -238,7 +238,7 @@ store_mem_state(struct sys_device *dev, 
 	mem = container_of(dev, struct memory_block, sysdev);
 	phys_section_nr = mem->phys_index;
 
-	if (!valid_section_nr(phys_section_nr))
+	if (!present_section_nr(phys_section_nr))
 		goto out;
 
 	if (!strncmp(buf, "online", min((int)count, 6)))
@@ -418,7 +418,7 @@ int register_new_memory(struct mem_secti
 
 int unregister_memory_section(struct mem_section *section)
 {
-	if (!valid_section(section))
+	if (!present_section(section))
 		return -EINVAL;
 
 	return remove_memory_block(0, section, 0);
@@ -443,7 +443,7 @@ int __init memory_dev_init(void)
 	 * during boot and have been initialized
 	 */
 	for (i = 0; i < NR_MEM_SECTIONS; i++) {
-		if (!valid_section_nr(i))
+		if (!present_section_nr(i))
 			continue;
 		err = add_memory_block(0, __nr_to_section(i), MEM_ONLINE, 0);
 		if (!ret)
diff -puN include/linux/mmzone.h~sparsemem-record-when-a-section-has-a-valid-mem_map include/linux/mmzone.h
--- a/include/linux/mmzone.h~sparsemem-record-when-a-section-has-a-valid-mem_map
+++ a/include/linux/mmzone.h
@@ -771,12 +771,17 @@ static inline struct page *__section_mem
 	return (struct page *)map;
 }
 
-static inline int valid_section(struct mem_section *section)
+static inline int present_section(struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
 }
 
-static inline int section_has_mem_map(struct mem_section *section)
+static inline int present_section_nr(unsigned long nr)
+{
+	return present_section(__nr_to_section(nr));
+}
+
+static inline int valid_section(struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
 }
@@ -798,6 +803,13 @@ static inline int pfn_valid(unsigned lon
 	return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
 }
 
+static inline int pfn_present(unsigned long pfn)
+{
+	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
+		return 0;
+	return present_section(__nr_to_section(pfn_to_section_nr(pfn)));
+}
+
 /*
  * These are _only_ used during initialisation, therefore they
  * can use __initdata ...  They could have names to indicate
diff -puN mm/sparse.c~sparsemem-record-when-a-section-has-a-valid-mem_map mm/sparse.c
--- a/mm/sparse.c~sparsemem-record-when-a-section-has-a-valid-mem_map
+++ a/mm/sparse.c
@@ -176,7 +176,7 @@ unsigned long __init node_memmap_size_by
 		if (nid != early_pfn_to_nid(pfn))
 			continue;
 
-		if (pfn_valid(pfn))
+		if (pfn_present(pfn))
 			nr_pages += PAGES_PER_SECTION;
 	}
 
@@ -206,11 +206,12 @@ struct page *sparse_decode_mem_map(unsig
 static int __meminit sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map)
 {
-	if (!valid_section(ms))
+	if (!present_section(ms))
 		return -EINVAL;
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum);
+	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum) |
+							SECTION_HAS_MEM_MAP;
 
 	return 1;
 }
@@ -256,7 +257,7 @@ void __init sparse_init(void)
 	struct page *map;
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		if (!valid_section_nr(pnum))
+		if (!present_section_nr(pnum))
 			continue;
 
 		map = sparse_early_mem_map_alloc(pnum);
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
update-checkpatchpl-to-version-010.patch
printk-add-kern_cont-annotation.patch
page-owner-tracking-leak-detector.patch
