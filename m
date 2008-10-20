From: akpm@linux-foundation.org
Subject: - memory-hotplug-release-memory-regions-in-pages_per_section-chunks.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:05 -0700
Message-ID: <200810202034.m9KKY5FA010776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162AbYJTUqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nfont@austin.ibm.com, pbadari@us.ibm.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: release memory regions in PAGES_PER_SECTION chunks
has been removed from the -mm tree.  Its filename was
     memory-hotplug-release-memory-regions-in-pages_per_section-chunks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: release memory regions in PAGES_PER_SECTION chunks
From: Nathan Fontenot <nfont@austin.ibm.com>

During hotplug memory remove, memory regions should be released on a
PAGES_PER_SECTION size chunks.  This mirrors the code in add_memory where
resources are requested on a PAGES_PER_SECTION size.

Attempting to release the entire memory region fails because there is not
a single resource for the total number of pages being removed.  Instead
the resources for the pages are split in PAGES_PER_SECTION size chunks as
requested during memory add.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-release-memory-regions-in-pages_per_section-chunks mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-release-memory-regions-in-pages_per_section-chunks
+++ a/mm/memory_hotplug.c
@@ -324,11 +324,11 @@ int __remove_pages(struct zone *zone, un
 	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
 	BUG_ON(nr_pages % PAGES_PER_SECTION);
 
-	release_mem_region(phys_start_pfn << PAGE_SHIFT, nr_pages * PAGE_SIZE);
