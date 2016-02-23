From: akpm@linux-foundation.org
Subject: [merged]
 thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma.patch removed from -mm tree
Date: Tue, 23 Feb 2016 12:49:35 -0800
Message-ID: <56ccc5df.sOmjbnSQP4MLgBe0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbcBWUth (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 15:49:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, dax: do not try to withdraw pgtable from non-anon VMA
has been removed from the -mm tree.  Its filename was
     thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp, dax: do not try to withdraw pgtable from non-anon VMA

DAX doesn't deposit pgtables when it maps huge pages: nothing to
withdraw. It can lead to crash.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma mm/huge_memory.c
--- a/mm/huge_memory.c~thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma
+++ a/mm/huge_memory.c
@@ -1700,7 +1700,8 @@ bool move_huge_pmd(struct vm_area_struct
 		pmd = pmdp_huge_get_and_clear(mm, old_addr, old_pmd);
 		VM_BUG_ON(!pmd_none(*new_pmd));
 
-		if (pmd_move_must_withdraw(new_ptl, old_ptl)) {
+		if (pmd_move_must_withdraw(new_ptl, old_ptl) &&
+				vma_is_anonymous(vma)) {
 			pgtable_t pgtable;
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-tracing-refresh-__def_vmaflag_names.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

