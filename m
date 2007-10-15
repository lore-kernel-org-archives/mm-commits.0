From: akpm@linux-foundation.org
Subject: + hugetlb-fix-dynamic-pool-resize-failure-case.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:52:19 -0700
Message-ID: <200710151952.l9FJqJAH021879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765606AbXJOTwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, lee.schermerhorn@hp.com, pbadari@us.ibm.com, wli@holomorphy.com


The patch titled
     hugetlb: fix dynamic pool resize failure case
has been added to the -mm tree.  Its filename is
     hugetlb-fix-dynamic-pool-resize-failure-case.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: fix dynamic pool resize failure case
From: Adam Litke <agl@us.ibm.com>

When gather_surplus_pages() fails to allocate enough huge pages to satisfy
the requested reservation, it frees what it did allocate back to the buddy
allocator.  put_page() should be called instead of update_and_free_page()
to ensure that pool counters are updated as appropriate and the page's
refcount is decremented.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-dynamic-pool-resize-failure-case mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-dynamic-pool-resize-failure-case
+++ a/mm/hugetlb.c
@@ -302,8 +302,11 @@ free:
 		list_del(&page->lru);
 		if ((--needed) >= 0)
 			enqueue_huge_page(page);
-		else
-			update_and_free_page(page);
+		else {
+			spin_unlock(&hugetlb_lock);
+			put_page(page);
+			spin_lock(&hugetlb_lock);
+		}
 	}
 
 	return ret;
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
