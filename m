From: akpm@linux-foundation.org
Subject: - memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:30 -0700
Message-ID: <200807242324.m6ONOUpI010788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755284AbYGXXZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, apw@shadowen.org, davem@davemloft.net, heiko.carstens@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, pbadari@us.ibm.com, tony@bakeyournoodle.com, mm


The patch titled
     memory hotplug: allocate usemap on the section with pgdat
has been removed from the -mm tree.  Its filename was
     memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: allocate usemap on the section with pgdat
From: Yasunori Goto <y-goto@jp.fujitsu.com>

Usemaps are allocated on the section which has pgdat by this.

Because usemap size is very small, many other sections usemaps are
allocated on only one page.  If a section has usemap, it can't be removed
until removing other sections.  This dependency is not desirable for
memory removing.

Pgdat has similar feature.  When a section has pgdat area, it must be the
last section for removing on the node.  So, if section A has pgdat and
section B has usemap for section A, Both sections can't be removed due to
dependency each other.

To solve this issue, this patch collects usemap on same section with pgdat
as much as possible.  If other sections doesn't have any dependency, this
section will be able to be removed finally.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: David Miller <davem@davemloft.net>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff -puN mm/sparse.c~memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4 mm/sparse.c
--- a/mm/sparse.c~memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4
+++ a/mm/sparse.c
@@ -269,16 +269,92 @@ static unsigned long *__kmalloc_section_
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+static unsigned long * __init
+sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+{
+	unsigned long section_nr;
+
+	/*
+	 * A page may contain usemaps for other sections preventing the
+	 * page being freed and making a section unremovable while
+	 * other sections referencing the usemap retmain active. Similarly,
+	 * a pgdat can prevent a section being removed. If section A
+	 * contains a pgdat and section B contains the usemap, both
+	 * sections become inter-dependent. This allocates usemaps
+	 * from the same section as the pgdat where possible to avoid
+	 * this problem.
+	 */
+	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
+	return alloc_bootmem_section(usemap_size(), section_nr);
+}
+
+static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
+{
+	unsigned long usemap_snr, pgdat_snr;
+	static unsigned long old_usemap_snr = NR_MEM_SECTIONS;
+	static unsigned long old_pgdat_snr = NR_MEM_SECTIONS;
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	int usemap_nid;
+
+	usemap_snr = pfn_to_section_nr(__pa(usemap) >> PAGE_SHIFT);
+	pgdat_snr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
+	if (usemap_snr == pgdat_snr)
+		return;
+
+	if (old_usemap_snr == usemap_snr && old_pgdat_snr == pgdat_snr)
+		/* skip redundant message */
+		return;
+
+	old_usemap_snr = usemap_snr;
+	old_pgdat_snr = pgdat_snr;
+
+	usemap_nid = sparse_early_nid(__nr_to_section(usemap_snr));
+	if (usemap_nid != nid) {
+		printk(KERN_INFO
+		       "node %d must be removed before remove section %ld\n",
+		       nid, usemap_snr);
+		return;
+	}
+	/*
+	 * There is a circular dependency.
+	 * Some platforms allow un-removable section because they will just
+	 * gather other removable sections for dynamic partitioning.
+	 * Just notify un-removable section's number here.
+	 */
+	printk(KERN_INFO "Section %ld and %ld (node %d)", usemap_snr,
+	       pgdat_snr, nid);
+	printk(KERN_CONT
+	       " have a circular dependency on usemap and pgdat allocations\n");
+}
+#else
+static unsigned long * __init
+sparse_early_usemap_alloc_pgdat_section(struct pglist_data *pgdat)
+{
+	return NULL;
+}
+
+static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
+{
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
 static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 {
 	unsigned long *usemap;
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
 
-	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	usemap = sparse_early_usemap_alloc_pgdat_section(NODE_DATA(nid));
 	if (usemap)
 		return usemap;
 
+	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	if (usemap) {
+		check_usemap_section_nr(nid, usemap);
+		return usemap;
+	}
+
 	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
 	nid = 0;
 
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch

