From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-optimize-probe-routine.patch added to -mm
 tree
Date: Thu, 15 Feb 2018 14:46:33 -0800
Message-ID: <5a860dc9.npptnC+UTJl5lSZU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41986 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756369AbeBOWrE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 17:47:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, bharata@linux.vnet.ibm.com, bhe@redhat.com, daniel.m.jordan@oracle.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, hpa@zytor.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@kernel.org, steven.sistare@oracle.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: optimize probe routine
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-optimize-probe-routine.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-optimize-probe-routine.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-optimize-probe-routine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm/memory_hotplug: optimize probe routine

When memory is hotplugged pages_correctly_reserved() is called to verify
that the added memory is present, this routine traverses through every
struct page and verifies that PageReserved() is set.  This is a slow
operation especially if a large amount of memory is added.

Instead of checking every page, it is enough to simply check that the
section is present, has mapping (struct page array is allocated), and the
mapping is online.

In addition, we should not excpect that probe routine sets flags in struct
page, as the struct pages have not yet been initialized.  The
initialization should be done in __init_single_page(), the same as during
boot.

Link: http://lkml.kernel.org/r/20180215165920.8570-5-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff -puN drivers/base/memory.c~mm-memory_hotplug-optimize-probe-routine drivers/base/memory.c
--- a/drivers/base/memory.c~mm-memory_hotplug-optimize-probe-routine
+++ a/drivers/base/memory.c
@@ -187,13 +187,14 @@ int memory_isolate_notify(unsigned long
 }
 
 /*
- * The probe routines leave the pages reserved, just as the bootmem code does.
- * Make sure they're still that way.
+ * The probe routines leave the pages uninitialized, just as the bootmem code
+ * does. Make sure we do not access them, but instead use only information from
+ * within sections.
  */
-static bool pages_correctly_reserved(unsigned long start_pfn)
+static bool pages_correctly_probed(unsigned long start_pfn)
 {
-	int i, j;
-	struct page *page;
+	unsigned long section_nr = pfn_to_section_nr(start_pfn);
+	unsigned long section_nr_end = section_nr + sections_per_block;
 	unsigned long pfn = start_pfn;
 
 	/*
@@ -201,21 +202,24 @@ static bool pages_correctly_reserved(uns
 	 * SPARSEMEM_VMEMMAP. We lookup the page once per section
 	 * and assume memmap is contiguous within each section
 	 */
-	for (i = 0; i < sections_per_block; i++, pfn += PAGES_PER_SECTION) {
+	for (; section_nr < section_nr_end; section_nr++) {
 		if (WARN_ON_ONCE(!pfn_valid(pfn)))
 			return false;
-		page = pfn_to_page(pfn);
-
-		for (j = 0; j < PAGES_PER_SECTION; j++) {
-			if (PageReserved(page + j))
-				continue;
-
-			printk(KERN_WARNING "section number %ld page number %d "
-				"not reserved, was it already online?\n",
-				pfn_to_section_nr(pfn), j);
 
+		if (!present_section_nr(section_nr)) {
+			pr_warn("section %ld pfn[%lx, %lx) not present",
+				section_nr, pfn, pfn + PAGES_PER_SECTION);
+			return false;
+		} else if (!valid_section_nr(section_nr)) {
+			pr_warn("section %ld pfn[%lx, %lx) no valid memmap",
+				section_nr, pfn, pfn + PAGES_PER_SECTION);
+			return false;
+		} else if (online_section_nr(section_nr)) {
+			pr_warn("section %ld pfn[%lx, %lx) is already online",
+				section_nr, pfn, pfn + PAGES_PER_SECTION);
 			return false;
 		}
+		pfn += PAGES_PER_SECTION;
 	}
 
 	return true;
@@ -237,7 +241,7 @@ memory_block_action(unsigned long phys_i
 
 	switch (action) {
 	case MEM_ONLINE:
-		if (!pages_correctly_reserved(start_pfn))
+		if (!pages_correctly_probed(start_pfn))
 			return -EBUSY;
 
 		ret = online_pages(start_pfn, nr_pages, online_type);
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix-3.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch
mm-memory_hotplug-optimize-probe-routine.patch
mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch
mm-memory_hotplug-optimize-memory-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

