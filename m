From: akpm@linux-foundation.org
Subject: - hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:43 -0700
Message-ID: <200807242323.m6ONNhqk010707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbYGXXYM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, apw@shadowen.org, hannes@saeurebad.de, hugh@veritas.com, mel@csn.ul.ie, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: quota is not freed for unused reserved private huge pages
has been removed from the -mm tree.  Its filename was
     hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: quota is not freed for unused reserved private huge pages
From: Adam Litke <agl@us.ibm.com>

With shared reservations (and now also with private reservations), we reserve
huge pages at mmap time.  We also account for the mapping against fs quota to
prevent a reservation from being preempted by quota exhaustion.

When testing with the libhugetlbfs test suite, I found a problem with quota
accounting.  FS quota for allocated pages is handled correctly but we are not
releasing quota for private pages that were reserved but never allocated.  Do
this in hugetlb_vm_op_close() at the same time as unused page reservations are
released.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages
+++ a/mm/hugetlb.c
@@ -1562,8 +1562,10 @@ static void hugetlb_vm_op_close(struct v
 
 		kref_put(&reservations->refs, resv_map_release);
 
-		if (reserve)
+		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
+			hugetlb_put_quota(vma->vm_file->f_mapping, reserve);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from agl@us.ibm.com are

origin.patch

