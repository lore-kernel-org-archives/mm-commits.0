From: akpm@linux-foundation.org
Subject: - hugetlb-remove-unnecessary-nid-initialization.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:42 -0700
Message-ID: <200707162048.l6GKmgmI001087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172AbXGPUxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: remove unnecessary nid initialization
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-unnecessary-nid-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: remove unnecessary nid initialization
From: Nishanth Aravamudan <nacc@us.ibm.com>

nid is initialized to numa_node_id() but will either be overwritten in
the loop or not used in the conditional. So remove the initialization.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-remove-unnecessary-nid-initialization mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-remove-unnecessary-nid-initialization
+++ a/mm/hugetlb.c
@@ -66,7 +66,7 @@ static void enqueue_huge_page(struct pag
 static struct page *dequeue_huge_page(struct vm_area_struct *vma,
 				unsigned long address)
 {
-	int nid = numa_node_id();
+	int nid;
 	struct page *page = NULL;
 	struct zonelist *zonelist = huge_zonelist(vma, address);
 	struct zone **z;
_

Patches currently in -mm which might be from nacc@us.ibm.com are

origin.patch
