From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dont-split-thp-page-when-syscall-is-called-fix-5.patch removed from -mm
 tree
Date: Mon, 02 Nov 2015 14:51:06 -0800
Message-ID: <5637e8da.AxY45bMQyEt6JKrW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKBWvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:51:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: skip huge zero page in MADV_FREE
has been removed from the -mm tree.  Its filename was
     mm-dont-split-thp-page-when-syscall-is-called-fix-5.patch

This patch was dropped because it was folded into mm-dont-split-thp-page-when-syscall-is-called.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: skip huge zero page in MADV_FREE

It is pointless to mark huge zero page as freeable.
Let's skip it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called-fix-5 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dont-split-thp-page-when-syscall-is-called-fix-5
+++ a/mm/huge_memory.c
@@ -1542,6 +1542,9 @@ int madvise_free_huge_pmd(struct mmu_gat
 		struct page *page;
 		pmd_t orig_pmd;
 
+		if (is_huge_zero_pmd(*pmd))
+			goto out;
+
 		orig_pmd = pmdp_huge_get_and_clear(mm, addr, pmd);
 
 		/* No hugepage in swapcache */
@@ -1553,6 +1556,7 @@ int madvise_free_huge_pmd(struct mmu_gat
 
 		set_pmd_at(mm, addr, pmd, orig_pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+out:
 		spin_unlock(ptl);
 		ret = 0;
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
mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch

