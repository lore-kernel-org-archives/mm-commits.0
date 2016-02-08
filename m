From: akpm@linux-foundation.org
Subject: + mm-dax-check-for-pmd_none-after-split_huge_pmd.patch added to
 -mm tree
Date: Mon, 08 Feb 2016 15:56:12 -0800
Message-ID: <56b92b1c.KW2gVL7j8lRZZP+2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbcBHX4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 18:56:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: check for pmd_none() after split_huge_pmd()
has been added to the -mm tree.  Its filename is
     mm-dax-check-for-pmd_none-after-split_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-check-for-pmd_none-after-split_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-check-for-pmd_none-after-split_huge_pmd.patch

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
Subject: mm, dax: check for pmd_none() after split_huge_pmd()

DAX implements split_huge_pmd() by clearing pmd.  This simple approach
reduces memory overhead, as we don't need to deposit page table on huge
page mapping to make split_huge_pmd() never-fail.  PTE table can be
allocated and populated later on page fault from backing store.

But one side effect is that have to check if pmd is pmd_none() after
split_huge_pmd().  In most places we do this already to deal with parallel
MADV_DONTNEED.

But I found two call sites which is not affected by MADV_DONTNEED (due
down_write(mmap_sem)), but need to have the check to work with DAX
properly.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    6 ++++--
 mm/mremap.c   |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/mprotect.c~mm-dax-check-for-pmd_none-after-split_huge_pmd mm/mprotect.c
--- a/mm/mprotect.c~mm-dax-check-for-pmd_none-after-split_huge_pmd
+++ a/mm/mprotect.c
@@ -160,9 +160,11 @@ static inline unsigned long change_pmd_r
 		}
 
 		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
-			if (next - addr != HPAGE_PMD_SIZE)
+			if (next - addr != HPAGE_PMD_SIZE) {
 				split_huge_pmd(vma, pmd, addr);
-			else {
+				if (pmd_none(*pmd))
+					continue;
+			} else {
 				int nr_ptes = change_huge_pmd(vma, pmd, addr,
 						newprot, prot_numa);
 
diff -puN mm/mremap.c~mm-dax-check-for-pmd_none-after-split_huge_pmd mm/mremap.c
--- a/mm/mremap.c~mm-dax-check-for-pmd_none-after-split_huge_pmd
+++ a/mm/mremap.c
@@ -210,6 +210,8 @@ unsigned long move_page_tables(struct vm
 				}
 			}
 			split_huge_pmd(vma, old_pmd, old_addr);
+			if (pmd_none(*old_pmd))
+				continue;
 			VM_BUG_ON(pmd_trans_huge(*old_pmd));
 		}
 		if (pmd_none(*new_pmd) && __pte_alloc(new_vma->vm_mm, new_vma,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-dax-check-for-pmd_none-after-split_huge_pmd.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
thp-cleanup-split_huge_page.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

