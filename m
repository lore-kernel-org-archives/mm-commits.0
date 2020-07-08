From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent.patch added
 to -mm tree
Date: Wed, 08 Jul 2020 16:16:49 -0700
Message-ID: <20200708231649.X9s1m9RFW%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgGHXQw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 19:16:52 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, digetx@gmail.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, peterx@redhat.com, richard.weiyang@linux.alibaba.com, sean.j.christopherson@intel.com, thellstrom@vmware.com, thomas_os@shipmail.org, vbabka@suse.cz, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/mremap: use pmd_addr_end to simplify the calculate of extent
has been added to the -mm tree.  Its filename is
     mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mremap: use pmd_addr_end to simplify the calculate of extent

The purpose of this code is to calculate the smaller extent in old and new
range.  Let's leverage pmd_addr_end() to do the calculation.

Hope this would make the code easier to read.

Link: http://lkml.kernel.org/r/20200708095028.41706-5-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dmitry Osipenko <digetx@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Thomas Hellstrom (VMware) <thomas_os@shipmail.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent
+++ a/mm/mremap.c
@@ -237,11 +237,12 @@ unsigned long move_page_tables(struct vm
 		unsigned long new_addr, unsigned long len,
 		bool need_rmap_locks)
 {
-	unsigned long extent, next, old_end;
+	unsigned long extent, old_next, new_next, old_end, new_end;
 	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
 
 	old_end = old_addr + len;
+	new_end = new_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
@@ -250,14 +251,11 @@ unsigned long move_page_tables(struct vm
 
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
-		next = (old_addr + PMD_SIZE) & PMD_MASK;
-		/* even if next overflowed, extent below will be ok */
-		extent = next - old_addr;
-		if (extent > old_end - old_addr)
-			extent = old_end - old_addr;
-		next = (new_addr + PMD_SIZE) & PMD_MASK;
-		if (extent > next - new_addr)
-			extent = next - new_addr;
+
+		old_next = pmd_addr_end(old_addr, old_end);
+		new_next = pmd_addr_end(new_addr, new_end);
+		extent = min(old_next - old_addr, new_next - new_addr);
+
 		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent.patch
mm-sparse-never-partially-remove-memmap-for-early-section.patch
mm-sparse-only-sub-section-aligned-range-would-be-populated.patch
mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
mm-page_alloc-fallbacks-at-most-has-3-elements.patch
