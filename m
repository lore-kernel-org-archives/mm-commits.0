From: akpm@linux-foundation.org
Subject: + numa-fix-proc-pid-numa_maps-for-hugetlbfs-on-s390.patch added
 to -mm tree
Date: Mon, 25 Jan 2016 14:50:37 -0800
Message-ID: <56a6a6bd.GGHCGdFra33rip5f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024AbcAYWui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 17:50:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holzheu@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: numa: fix /proc/<pid>/numa_maps for hugetlbfs on s390
has been added to the -mm tree.  Its filename is
     numa-fix-proc-pid-numa_maps-for-hugetlbfs-on-s390.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/numa-fix-proc-pid-numa_maps-for-hugetlbfs-on-s390.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/numa-fix-proc-pid-numa_maps-for-hugetlbfs-on-s390.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: numa: fix /proc/<pid>/numa_maps for hugetlbfs on s390

When working with hugetlbfs ptes (which are actually pmds) is not valid to
directly use pte functions like pte_present() because the hardware bit
layout of pmds and ptes can be different.  This is the case on s390. 
Therefore we have to convert the hugetlbfs ptes first into a valid pte
encoding with huge_ptep_get().

Currently the /proc/<pid>/numa_maps code uses hugetlbfs ptes without
huge_ptep_get().  On s390 this leads to the following two problems:

1) The pte_present() function returns false (instead of true) for
   PROT_NONE hugetlb ptes. Therefore PROT_NONE vmas are missing
   completely in the "numa_maps" output.

2) The pte_dirty() function always returns false for all hugetlb ptes.
   Therefore these pages are reported as "mapped=xxx" instead of
   "dirty=xxx".

Therefore use huge_ptep_get() to correctly convert the hugetlb ptes.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~numa-fix-proc-pid-numa_maps-for-hugetlbfs-on-s390 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~numa-fix-proc-pid-numa_maps-for-hugetlbfs-on-s390
+++ a/fs/proc/task_mmu.c
@@ -1552,18 +1552,19 @@ static int gather_pte_stats(pmd_t *pmd,
 static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
+	pte_t huge_pte = huge_ptep_get(pte);
 	struct numa_maps *md;
 	struct page *page;
 
-	if (!pte_present(*pte))
+	if (!pte_present(huge_pte))
 		return 0;
 
-	page = pte_page(*pte);
+	page = pte_page(huge_pte);
 	if (!page)
 		return 0;
 
 	md = walk->private;
-	gather_stats(page, md, pte_dirty(*pte), 1);
+	gather_stats(page, md, pte_dirty(huge_pte), 1);
 	return 0;
 }
 
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

numa-fix-proc-pid-numa_maps-for-hugetlbfs-on-s390.patch

