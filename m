From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-remove-bug_on-checks-for-vma-inside-mpol_misplaced.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:40:34 -0700
Message-ID: <20170911194034.X3N3L0l19%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdIKTkf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm/mempolicy.c: remove BUG_ON() checks for VMA inside mpol_misplaced()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-remove-bug_on-checks-for-vma-inside-mpol_misplaced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/mempolicy.c: remove BUG_ON() checks for VMA inside mpol_misplaced()

VMA and its address bounds checks are too late in this function.  They
must have been verified earlier in the page fault sequence.  Hence just
remove them.

Link: http://lkml.kernel.org/r/20170901130137.7617-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-remove-bug_on-checks-for-vma-inside-mpol_misplaced mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-remove-bug_on-checks-for-vma-inside-mpol_misplaced
+++ a/mm/mempolicy.c
@@ -2233,17 +2233,12 @@ int mpol_misplaced(struct page *page, st
 	int polnid = -1;
 	int ret = -1;
 
-	BUG_ON(!vma);
-
 	pol = get_vma_policy(vma, addr);
 	if (!(pol->flags & MPOL_F_MOF))
 		goto out;
 
 	switch (pol->mode) {
 	case MPOL_INTERLEAVE:
-		BUG_ON(addr >= vma->vm_end);
-		BUG_ON(addr < vma->vm_start);
