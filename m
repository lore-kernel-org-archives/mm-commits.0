From: akpm@linux-foundation.org
Subject: + hugetlb-fix-dynamic-pool-resize-failure-case-update.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:59:37 -0700
Message-ID: <200710152159.l9FLxbUd027224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758259AbXJOV7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:59:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, haveblue@us.ibm.com


The patch titled
     hugetlb: Fix dynamic pool resize failure case (update)
has been added to the -mm tree.  Its filename is
     hugetlb-fix-dynamic-pool-resize-failure-case-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: Fix dynamic pool resize failure case (update)
From: Adam Litke <agl@us.ibm.com>

Added a comment explaining the free logic in gather_surplus_pages.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-fix-dynamic-pool-resize-failure-case-update mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-dynamic-pool-resize-failure-case-update
+++ a/mm/hugetlb.c
@@ -303,6 +303,12 @@ free:
 		if ((--needed) >= 0)
 			enqueue_huge_page(page);
 		else {
+			/*
+			 * Decrement the refcount and free the page using its
+			 * destructor.  This must be done with hugetlb_lock
+			 * unlocked which is safe because free_huge_page takes
+			 * hugetlb_lock before deciding how to free the page.
+			 */
 			spin_unlock(&hugetlb_lock);
 			put_page(page);
 			spin_lock(&hugetlb_lock);
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-move-update_and_free_page.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch
hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
hugetlbfs-read-support-fix-2-fix.patch
hugetlb-fix-pool-resizing-corner-case-v2.patch
hugetlb-fix-hugepage-allocation-with-memoryless-nodes.patch
hugetlb-fix-dynamic-pool-resize-failure-case.patch
hugetlb-fix-dynamic-pool-resize-failure-case-update.patch
