From: akpm@linux-foundation.org
Subject: + thp-change-insert_pfns-return-type-to-void.patch added to -mm
 tree
Date: Tue, 04 Aug 2015 14:34:27 -0700
Message-ID: <55c12fe3.56NFTvp4FvEW/cLg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbbHDVe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: change insert_pfn's return type to void
has been added to the -mm tree.  Its filename is
     thp-change-insert_pfns-return-type-to-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-change-insert_pfns-return-type-to-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-change-insert_pfns-return-type-to-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: thp: change insert_pfn's return type to void

It would make more sense to have all the return values from
vmf_insert_pfn_pmd() encoded in one place instead of having to follow the
convention into insert_pfn().  Suggested by Jeff Moyer.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~thp-change-insert_pfns-return-type-to-void mm/huge_memory.c
--- a/mm/huge_memory.c~thp-change-insert_pfns-return-type-to-void
+++ a/mm/huge_memory.c
@@ -869,7 +869,7 @@ int do_huge_pmd_anonymous_page(struct mm
 					    flags);
 }
 
-static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
+static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, unsigned long pfn, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -887,7 +887,6 @@ static int insert_pfn_pmd(struct vm_area
 		update_mmu_cache_pmd(vma, addr, pmd);
 	}
 	spin_unlock(ptl);
-	return VM_FAULT_NOPAGE;
 }
 
 int vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
@@ -909,7 +908,8 @@ int vmf_insert_pfn_pmd(struct vm_area_st
 		return VM_FAULT_SIGBUS;
 	if (track_pfn_insert(vma, &pgprot, pfn))
 		return VM_FAULT_SIGBUS;
-	return insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write);
+	insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write);
+	return VM_FAULT_NOPAGE;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
_

Patches currently in -mm which might be from willy@linux.intel.com are

mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-move-dax-related-functions-to-a-new-header.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages.patch
thp-prepare-for-dax-huge-pages-fix.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
ext4-use-ext4_get_block_write-for-dax.patch
thp-change-insert_pfns-return-type-to-void.patch
dax-improve-comment-about-truncate-race.patch
ext4-add-ext4_get_block_dax.patch
ext4-start-transaction-before-calling-into-dax.patch
dax-fix-race-between-simultaneous-faults.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
dax-ensure-that-zero-pages-are-removed-from-other-processes.patch
dax-use-linear_page_index.patch

