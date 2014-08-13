From: akpm@linux-foundation.org
Subject: + mm-actually-clear-pmd_numa-before-invalidating.patch added to
 -mm tree
Date: Wed, 13 Aug 2014 13:01:18 -0700
Message-ID: <53ebc40e.yPy03Bq8m9FY7Dwu%akpm__41998.4689135619$1407960088$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:35851 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHMUBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 16:01:19 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so79136pde.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 13:01:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, mgorman@suse.de, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: actually clear pmd_numa before invalidating
has been added to the -mm tree.  Its filename is
     mm-actually-clear-pmd_numa-before-invalidating.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-actually-clear-pmd_numa-before-invalidating.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-actually-clear-pmd_numa-before-invalidating.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: mm: actually clear pmd_numa before invalidating

Commit 67f87463d3 ("mm: clear pmd_numa before invalidating") cleared the
NUMA bit in a copy of the PMD entry, but then wrote back the original

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/pgtable-generic.c~mm-actually-clear-pmd_numa-before-invalidating mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-actually-clear-pmd_numa-before-invalidating
+++ a/mm/pgtable-generic.c
@@ -195,7 +195,7 @@ void pmdp_invalidate(struct vm_area_stru
 	pmd_t entry = *pmdp;
 	if (pmd_numa(entry))
 		entry = pmd_mknonnuma(entry);
-	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(*pmdp));
+	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(entry));
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

mm-actually-clear-pmd_numa-before-invalidating.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

