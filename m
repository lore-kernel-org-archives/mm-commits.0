From: akpm@linux-foundation.org
Subject: +
 mm-support-section-unaligned-zone_device-memory-ranges-fix-2.patch added to -mm tree
Date: Tue, 24 Jan 2017 13:18:07 -0800
Message-ID: <5887c48f.YC2cCO7nhYZ1c/wq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbdAXVSJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 16:18:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, akpm@linux-foundation.org, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix and clarify section_active_mask()
has been added to the -mm tree.  Its filename is
     mm-support-section-unaligned-zone_device-memory-ranges-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-support-section-unaligned-zone_device-memory-ranges-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-support-section-unaligned-zone_device-memory-ranges-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix and clarify section_active_mask()

section_active_mask() converts a range of pfns into a bitmask where each
bit represents a 2M sub-range of a 128MB section (on x86_64). Clarify
that we expect that the arguments do not cross a section boundary, fix
the case where the start pfn is section aligned, but nr_pages is less
than a section, and use ULONG_MAX instead of -1 to represent to the mask
full case.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/sparse.c~mm-support-section-unaligned-zone_device-memory-ranges-fix-2 mm/sparse.c
--- a/mm/sparse.c~mm-support-section-unaligned-zone_device-memory-ranges-fix-2
+++ a/mm/sparse.c
@@ -195,11 +195,18 @@ static unsigned long section_active_mask
 	int idx_start, idx_size;
 	phys_addr_t start, size;
 
+	WARN_ON((pfn & ~PAGE_SECTION_MASK) + nr_pages > PAGES_PER_SECTION);
 	if (!nr_pages)
 		return 0;
 
+	/*
+	 * The size is the number of pages left in the section or
+	 * nr_pages, whichever is smaller. The size will be rounded up
+	 * to the next SECTION_ACTIVE_SIZE boundary, the start will be
+	 * rounded down.
+	 */
 	start = PFN_PHYS(pfn);
-	size = PFN_PHYS(min(nr_pages, PAGES_PER_SECTION
+	size = PFN_PHYS(min_not_zero(nr_pages, PAGES_PER_SECTION
 				- (pfn & ~PAGE_SECTION_MASK)));
 	size = ALIGN(size, SECTION_ACTIVE_SIZE);
 
@@ -207,7 +214,7 @@ static unsigned long section_active_mask
 	idx_size = section_active_index(size);
 
 	if (idx_size == 0)
-		return -1;
+		return ULONG_MAX; /* full section */
 	return ((1UL << idx_size) - 1) << idx_start;
 }
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch
mm-devm_memremap_pages-use-multi-order-radix-for-zone_device-lookups.patch
mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch
mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch
mm-cleanup-sparse_init_one_section-return-value.patch
mm-track-active-portions-of-a-section-at-boot.patch
mm-fix-register_new_memory-zone-type-detection.patch
mm-convert-kmalloc_section_memmap-to-populate_section_memmap.patch
mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges-fix-2.patch
mm-enable-section-unaligned-devm_memremap_pages.patch
libnvdimm-pfn-dax-stop-padding-pmem-namespaces-to-section-alignment.patch

