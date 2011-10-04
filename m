From: akpm@google.com
Subject: [merged] memory-hotplug-correct-page-reservation-checking.patch removed from -mm tree
Date: Tue, 04 Oct 2011 12:29:53 -0700
Message-ID: <201110041929.p94JTrPI017047@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:45869 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1JDTaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 15:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nfont@austin.ibm.com, dave@linux.vnet.ibm.com, greg@kroah.com, nfont@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: correct page reservation checking
has been removed from the -mm tree.  Its filename was
     memory-hotplug-correct-page-reservation-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Nathan Fontenot <nfont@austin.ibm.com>
Subject: memory hotplug: correct page reservation checking

The check to ensure that pages of recently added memory sections are
correctly marked as reserved before trying to online the memory is broken.
 The request to online the memory fails with the following:

kernel: section number XXX page number 256 not reserved, was it already online?

This updates the page reservation checking to check the pages of each
memory section of the memory block being onlined individually.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/base/memory.c |   60 ++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-correct-page-reservation-checking drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-correct-page-reservation-checking
+++ a/drivers/base/memory.c
@@ -227,41 +227,42 @@ int memory_isolate_notify(unsigned long 
  * MEMORY_HOTPLUG depends on SPARSEMEM in mm/Kconfig, so it is
  * OK to have direct references to sparsemem variables in here.
  */
+static int check_page_reservations(unsigned long phys_index)
+{
+	int i;
+	struct page *page;
+
+	page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
+
+	for (i = 0; i < PAGES_PER_SECTION; i++) {
+		if (PageReserved(page + i))
+			continue;
+
+		printk(KERN_WARNING "section number %ld page number %d "
+			"not reserved, was it already online?\n", phys_index, i);
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
 static int
 memory_block_action(unsigned long phys_index, unsigned long action)
 {
-	int i;
 	unsigned long start_pfn, start_paddr;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
-	struct page *first_page;
+	struct page *page;
 	int ret;
 
-	first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
-
-	/*
-	 * The probe routines leave the pages reserved, just
-	 * as the bootmem code does.  Make sure they're still
-	 * that way.
-	 */
-	if (action == MEM_ONLINE) {
-		for (i = 0; i < nr_pages; i++) {
-			if (PageReserved(first_page+i))
-				continue;
-
-			printk(KERN_WARNING "section number %ld page number %d "
-				"not reserved, was it already online?\n",
-				phys_index, i);
-			return -EBUSY;
-		}
-	}
+	page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
 
 	switch (action) {
 		case MEM_ONLINE:
-			start_pfn = page_to_pfn(first_page);
+			start_pfn = page_to_pfn(page);
 			ret = online_pages(start_pfn, nr_pages);
 			break;
 		case MEM_OFFLINE:
-			start_paddr = page_to_pfn(first_page) << PAGE_SHIFT;
+			start_paddr = page_to_pfn(page) << PAGE_SHIFT;
 			ret = remove_memory(start_paddr,
 					    nr_pages << PAGE_SHIFT);
 			break;
@@ -277,7 +278,7 @@ memory_block_action(unsigned long phys_i
 static int memory_block_change_state(struct memory_block *mem,
 		unsigned long to_state, unsigned long from_state_req)
 {
-	int ret = 0;
+	int i, ret = 0;
 
 	mutex_lock(&mem->state_mutex);
 
@@ -289,6 +290,19 @@ static int memory_block_change_state(str
 	if (to_state == MEM_OFFLINE)
 		mem->state = MEM_GOING_OFFLINE;
 
+	if (to_state == MEM_ONLINE) {
+		/*
+		 * The probe routines leave the pages reserved, just
+		 * as the bootmem code does.  Make sure they're still
+		 * that way.
+		 */
+		for (i = 0; i < sections_per_block; i++) {
+			ret = check_page_reservations(mem->start_section_nr + i);
+			if (ret)
+				return ret;
+		}
+	}
+
 	ret = memory_block_action(mem->start_section_nr, to_state);
 
 	if (ret)
_

Patches currently in -mm which might be from nfont@austin.ibm.com are

linux-next.patch

