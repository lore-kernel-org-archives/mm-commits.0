From: akpm@linux-foundation.org
Subject: + make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch added to -mm tree
Date: Mon, 09 Apr 2007 22:21:40 -0700
Message-ID: <200704100521.l3A5Lebw032155@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966084AbXDJFVo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 01:21:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, clameter@sgi.com


The patch titled
     make-page-private-usable-in-compound-pages-v1 hugetlb fix
has been added to the -mm tree.  Its filename is
     make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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

make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
