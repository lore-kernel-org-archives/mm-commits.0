From: akpm@linux-foundation.org
Subject: [merged]
 drivers-base-memoryc-drop-pages_correctly_probed.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 18:58:36 -0700
Message-ID: <20200408015836.2-ZHqsp8R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB6h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, rafael@kernel.org


The patch titled
     Subject: drivers/base/memory.c: drop pages_correctly_probed()
has been removed from the -mm tree.  Its filename was
     drivers-base-memoryc-drop-pages_correctly_probed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory.c: drop pages_correctly_probed()

pages_correctly_probed() is a leftover from ancient times.  It dates back
to commit 3947be1969a9 ("[PATCH] memory hotplug: sysfs and add/remove
functions"), where Pg_reserved checks were added as a sfety net:

	/*
	 * The probe routines leave the pages reserved, just
	 * as the bootmem code does.  Make sure they're still
	 * that way.
	 */

The checks were refactored quite a bit over the years, especially in
commit b77eab7079d9 ("mm/memory_hotplug: optimize probe routine"), where
checks for present, valid, and online sections were added.

Hotplugged memory is added via add_memory(), which will create the full
memmap for the hotplugged memory, and mark all sections valid and present.

Only full memory blocks are onlined/offlined, so we also cannot have an
inconsistency in that regard (especially, memory blocks with some sections
being online and some being offline).

1. Boot memory always starts online.  Since commit c5e79ef561b0
   ("mm/memory_hotplug.c: don't allow to online/offline memory blocks with
   holes") we disallow to offline any memory with holes.  Therefore, we
   never online memory with holes.  Present and validity checks are
   superfluous.

2. Only complete memory blocks are onlined/offlined (and especially,
   the state - online or offline - is stored for whole memory blocks). 
   Besides the core, only arch/powerpc/platforms/powernv/memtrace.c
   manually calls offline_pages() and fiddels with memory block states. 
   But it also only offlines complete memory blocks.

3. To make any of these conditions trigger, something would have to be
   terribly messed up in the core.  (e.g., online/offline only some
   sections of a memory block).

4. Memory unplug properly makes sure that all sysfs attributes were
   removed (and therefore, that all threads left the sysfs handlers).  We
   don't have to worry about zombie devices at this point.

5. The valid_section_nr(section_nr) check is actually dead code, as it
   would never have been reached due to the WARN_ON_ONCE(!pfn_valid(pfn)).

No wonder we haven't seen any of these errors in a long time (or even
   ever, according to my search).  Let's just get rid of them.  Now, all
   checks that could hinder onlining and offlining are completely
   contained in online_pages()/offline_pages().

Link: http://lkml.kernel.org/r/20200127110424.5757-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   42 ----------------------------------------
 1 file changed, 42 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memoryc-drop-pages_correctly_probed
+++ a/drivers/base/memory.c
@@ -145,45 +145,6 @@ int memory_notify(unsigned long val, voi
 }
 
 /*
- * The probe routines leave the pages uninitialized, just as the bootmem code
- * does. Make sure we do not access them, but instead use only information from
- * within sections.
- */
-static bool pages_correctly_probed(unsigned long start_pfn)
-{
-	unsigned long section_nr = pfn_to_section_nr(start_pfn);
-	unsigned long section_nr_end = section_nr + sections_per_block;
-	unsigned long pfn = start_pfn;
-
-	/*
-	 * memmap between sections is not contiguous except with
-	 * SPARSEMEM_VMEMMAP. We lookup the page once per section
-	 * and assume memmap is contiguous within each section
-	 */
-	for (; section_nr < section_nr_end; section_nr++) {
-		if (WARN_ON_ONCE(!pfn_valid(pfn)))
-			return false;
-
-		if (!present_section_nr(section_nr)) {
-			pr_warn("section %ld pfn[%lx, %lx) not present\n",
-				section_nr, pfn, pfn + PAGES_PER_SECTION);
-			return false;
-		} else if (!valid_section_nr(section_nr)) {
-			pr_warn("section %ld pfn[%lx, %lx) no valid memmap\n",
-				section_nr, pfn, pfn + PAGES_PER_SECTION);
-			return false;
-		} else if (online_section_nr(section_nr)) {
-			pr_warn("section %ld pfn[%lx, %lx) is already online\n",
-				section_nr, pfn, pfn + PAGES_PER_SECTION);
-			return false;
-		}
-		pfn += PAGES_PER_SECTION;
-	}
-
-	return true;
-}
-
-/*
  * MEMORY_HOTPLUG depends on SPARSEMEM in mm/Kconfig, so it is
  * OK to have direct references to sparsemem variables in here.
  */
@@ -199,9 +160,6 @@ memory_block_action(unsigned long start_
 
 	switch (action) {
 	case MEM_ONLINE:
-		if (!pages_correctly_probed(start_pfn))
-			return -EBUSY;
