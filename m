From: akpm@linux-foundation.org
Subject: +
 mm-mempolicy-remove-bug_on-checks-for-vma-inside-mpol_misplaced.patch added to -mm tree
Date: Tue, 05 Sep 2017 16:57:00 -0700
Message-ID: <59af39cc.9jOuL9hWHGSrIZXo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754565AbdIEX5B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 19:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: remove BUG_ON() checks for VMA inside mpol_misplaced()
has been added to the -mm tree.  Its filename is
     mm-mempolicy-remove-bug_on-checks-for-vma-inside-mpol_misplaced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-remove-bug_on-checks-for-vma-inside-mpol_misplaced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-remove-bug_on-checks-for-vma-inside-mpol_misplaced.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
