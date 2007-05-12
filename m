From: akpm@linux-foundation.org
Subject: - ocfs2-use-zero_user_page.patch removed from -mm tree
Date: Fri, 11 May 2007 22:37:08 -0700
Message-ID: <200705120537.l4C5b8Yp002438@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756706AbXELFhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:37:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, mark.fasheh@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ocfs2: use zero_user_page
has been removed from the -mm tree.  Its filename was
     ocfs2-use-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ocfs2: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-use-zero_user_page fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-use-zero_user_page
+++ a/fs/ocfs2/aops.c
@@ -235,10 +235,7 @@ static int ocfs2_readpage(struct file *f
 	 * XXX sys_readahead() seems to get that wrong?
 	 */
 	if (start >= i_size_read(inode)) {
-		char *addr = kmap(page);
-		memset(addr, 0, PAGE_SIZE);
-		flush_dcache_page(page);
-		kunmap(page);
+		zero_user_page(page, 0, PAGE_SIZE, KM_USER0);
 		SetPageUptodate(page);
 		ret = 0;
 		goto out_alloc;
_

Patches currently in -mm which might be from nate.diller@gmail.com are

origin.patch
ntfs-use-zero_user_page.patch
cifs-use-simple_prepare_write-to-zero-page-data.patch
git-gfs2-nmw.patch
nfs-use-zero_user_page.patch
git-ocfs2.patch
xfs-use-zero_user_page.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-zero_user_page.patch
ecryptfs-use-zero_user_page.patch
reiser4.patch
reiser4-use-zero_user_page.patch
