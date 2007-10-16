From: akpm@linux-foundation.org
Subject: - hugetlb-fix-dynamic-pool-resize-failure-case.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:06 -0700
Message-ID: <200710162036.l9GKa6bP015119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760124AbXJPVvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, lee.schermerhorn@hp.com, pbadari@us.ibm.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix dynamic pool resize failure case
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-dynamic-pool-resize-failure-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: fix dynamic pool resize failure case
From: Adam Litke <agl@us.ibm.com>

When gather_surplus_pages() fails to allocate enough huge pages to satisfy
the requested reservation, it frees what it did allocate back to the buddy
allocator.  put_page() should be called instead of update_and_free_page()
to ensure that pool counters are updated as appropriate and the page's
refcount is decremented.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-dynamic-pool-resize-failure-case mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-dynamic-pool-resize-failure-case
+++ a/mm/hugetlb.c
@@ -302,8 +302,17 @@ free:
 		list_del(&page->lru);
 		if ((--needed) >= 0)
 			enqueue_huge_page(page);
-		else
-			update_and_free_page(page);
+		else {
+			/*
+			 * Decrement the refcount and free the page using its
+			 * destructor.  This must be done with hugetlb_lock
+			 * unlocked which is safe because free_huge_page takes
+			 * hugetlb_lock before deciding how to free the page.
+			 */
+			spin_unlock(&hugetlb_lock);
+			put_page(page);
+			spin_lock(&hugetlb_lock);
+		}
 	}
 
 	return ret;
_

Patches currently in -mm which might be from agl@us.ibm.com are

origin.patch
