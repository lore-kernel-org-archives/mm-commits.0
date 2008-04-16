From: akpm@linux-foundation.org
Subject: - documentation-correct-overcommit-caveat-in-hugetlbpagetxt.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:10 -0700
Message-ID: <200804162255.m3GMtASH011091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758834AbYDPXB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Documentation: correct overcommit caveat in hugetlbpage.txt
has been removed from the -mm tree.  Its filename was
     documentation-correct-overcommit-caveat-in-hugetlbpagetxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: correct overcommit caveat in hugetlbpage.txt
From: Nishanth Aravamudan <nacc@us.ibm.com>

As shown by Gurudas Pai recently, we can put hugepages into the surplus
state (by echo 0 > /proc/sys/vm/nr_hugepages), even when
/proc/sys/vm/nr_overcommit_hugepages is 0. This is actually correct, to
allow the original goal (shrink the static pool to 0) to succeed (we are
converting hugepages to surplus because they are in use). However, the
documentation does not accurately reflect this case. Update it.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~documentation-correct-overcommit-caveat-in-hugetlbpagetxt Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~documentation-correct-overcommit-caveat-in-hugetlbpagetxt
+++ a/Documentation/vm/hugetlbpage.txt
@@ -88,10 +88,9 @@ hugepages from the buddy allocator, if t
 these surplus hugepages go out of use, they are freed back to the buddy
 allocator.
 
-Caveat: Shrinking the pool via nr_hugepages while a surplus is in effect
-will allow the number of surplus huge pages to exceed the overcommit
-value, as the pool hugepages (which must have been in use for a surplus
-hugepages to be allocated) will become surplus hugepages.  As long as
+Caveat: Shrinking the pool via nr_hugepages such that it becomes less
+than the number of hugepages in use will convert the balance to surplus
+huge pages even if it would exceed the overcommit value.  As long as
 this condition holds, however, no more surplus huge pages will be
 allowed on the system until one of the two sysctls are increased
 sufficiently, or the surplus huge pages go out of use and are freed.
_

Patches currently in -mm which might be from nacc@us.ibm.com are

origin.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-fix-misleading-__gfp_repeat-related-comments.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch

