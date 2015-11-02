From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch removed from -mm
 tree
Date: Mon, 02 Nov 2015 14:50:58 -0800
Message-ID: <5637e8d2.nQ0j7USfG+LRk6fP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbbKBWu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:50:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove lock validation check for MADV_FREE
has been removed from the -mm tree.  Its filename was
     mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

This patch was dropped because it was folded into mm-dont-split-thp-page-when-syscall-is-called.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove lock validation check for MADV_FREE

Currently, madvise_free_pte_range is called only madvise path which
already holds an mmap_sem so it's pointless to add the lock validation
check.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called-fix-2 mm/madvise.c
--- a/mm/madvise.c~mm-dont-split-thp-page-when-syscall-is-called-fix-2
+++ a/mm/madvise.c
@@ -274,18 +274,9 @@ static int madvise_free_pte_range(pmd_t
 
 	next = pmd_addr_end(addr, end);
 	if (pmd_trans_huge(*pmd)) {
-		if (next - addr != HPAGE_PMD_SIZE) {
-#ifdef CONFIG_DEBUG_VM
-			if (!rwsem_is_locked(&mm->mmap_sem)) {
-				pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
-					__func__, addr, end,
-					vma->vm_start,
-					vma->vm_end);
-				BUG();
-			}
-#endif
+		if (next - addr != HPAGE_PMD_SIZE)
 			split_huge_pmd(vma, addr, pmd);
-		} else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
+		else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
 			goto next;
 		/* fall through */
 	}
_

Patches currently in -mm which might be from minchan@kernel.org are

x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-mark-stable-page-dirty-in-ksm.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-5.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch

