From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-use-the-right-function-when-updating-access-flags.patch removed from -mm tree
Date: Tue, 25 Jun 2013 12:22:56 -0700
Message-ID: <51c9ee10.zMluoS2dsT/ACupC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYTW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com

Subject: [merged] mm-thp-use-the-right-function-when-updating-access-flags.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,aarcange@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:22:56 -0700


The patch titled
     Subject: mm/thp: use the correct function when updating access flags
has been removed from the -mm tree.  Its filename was
     mm-thp-use-the-right-function-when-updating-access-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/thp: use the correct function when updating access flags

We should use pmdp_set_access_flags to update access flags.  Archs like
powerpc use extra checks(_PAGE_BUSY) when updating a hugepage PTE.  A
set_pmd_at doesn't do those checks.  We should use set_pmd_at only when
updating a none hugepage PTE.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-thp-use-the-right-function-when-updating-access-flags mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-use-the-right-function-when-updating-access-flags
+++ a/mm/huge_memory.c
@@ -1265,7 +1265,9 @@ struct page *follow_trans_huge_pmd(struc
 		 * young bit, instead of the current set_pmd_at.
 		 */
 		_pmd = pmd_mkyoung(pmd_mkdirty(*pmd));
-		set_pmd_at(mm, addr & HPAGE_PMD_MASK, pmd, _pmd);
+		if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
+					  pmd, _pmd,  1))
+			update_mmu_cache_pmd(vma, addr, pmd);
 	}
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		if (page->mapping && trylock_page(page)) {
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code-define-hpage_pmd_-constants-as-build_bug-if-thp.patch

