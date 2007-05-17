From: akpm@linux-foundation.org
Subject: + hugetlb-remove-unnecessary-nid-initialization.patch added to -mm tree
Date: Thu, 17 May 2007 12:15:02 -0700
Message-ID: <200705171915.l4HJF2gU030862@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbXEQTQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com


The patch titled
     hugetlb: remove unnecessary nid initialization
has been added to the -mm tree.  Its filename is
     hugetlb-remove-unnecessary-nid-initialization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: remove unnecessary nid initialization
From: Nishanth Aravamudan <nacc@us.ibm.com>

nid is initialized to numa_node_id() but will either be overwritten in
the loop or not used in the conditional. So remove the initialization.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

hugetlb-remove-unnecessary-nid-initialization.patch
