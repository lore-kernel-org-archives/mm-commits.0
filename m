From: akpm@linux-foundation.org
Subject: + thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma.patch
 added to -mm tree
Date: Thu, 11 Feb 2016 13:31:27 -0800
Message-ID: <56bcfdaf.yfebLzhWlTJ7P+zF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbcBKVb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Feb 2016 16:31:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, dax: do not try to withdraw pgtable from non-anon VMA
has been added to the -mm tree.  Its filename is
     thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dax-check-for-pmd_none-after-split_huge_pmd.patch
thp-dax-do-not-try-to-withdraw-pgtable-from-non-anon-vma.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

