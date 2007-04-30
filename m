From: akpm@linux-foundation.org
Subject: - make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:56:00 -0700
Message-ID: <200704301856.l3UIu1Qh012037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423647AbXD3S4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     make-page-private-usable-in-compound-pages-v1 hugetlb fix
has been removed from the -mm tree.  Its filename was
     make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch

This patch was dropped because it was folded into make-page-private-usable-in-compound-pages-v1.patch

------------------------------------------------------
Subject: make-page-private-usable-in-compound-pages-v1 hugetlb fix
From: Nishanth Aravamudan <nacc@us.ibm.com>

Christoph Lameter's rework of the use of private member of struct page
missed the hugetlbfs dirtying function.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~make-page-private-usable-in-compound-pages-v1-hugetlb-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~make-page-private-usable-in-compound-pages-v1-hugetlb-fix
+++ a/fs/hugetlbfs/inode.c
@@ -450,7 +450,7 @@ static int hugetlbfs_symlink(struct inod
  */
 static int hugetlbfs_set_page_dirty(struct page *page)
 {
-	struct page *head = (struct page *)page_private(page);
+	struct page *head = compound_head(page);
 
 	SetPageDirty(head);
 	return 0;
_

Patches currently in -mm which might be from nacc@us.ibm.com are

make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
