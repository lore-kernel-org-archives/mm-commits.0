From: akpm@linux-foundation.org
Subject: [merged] 9p-fix-incorrect-parameters-to-v9fs_file_readn.patch removed from -mm tree
Date: Tue, 21 Jul 2009 12:59:13 -0700
Message-ID: <200907211959.n6LJxDcn004483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145AbZGUT7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 15:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adkulkar@umail.iu.edu, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     9p: fix incorrect parameters to v9fs_file_readn()
has been removed from the -mm tree.  Its filename was
     9p-fix-incorrect-parameters-to-v9fs_file_readn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 9p: fix incorrect parameters to v9fs_file_readn()
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>

Fix v9fs_vfs_readpage.  The offset and size parameters to v9fs_file_readn
were interchanged and hence passed incorrectly.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/9p/vfs_addr.c~9p-fix-incorrect-parameters-to-v9fs_file_readn fs/9p/vfs_addr.c
--- a/fs/9p/vfs_addr.c~9p-fix-incorrect-parameters-to-v9fs_file_readn
+++ a/fs/9p/vfs_addr.c
@@ -57,7 +57,7 @@ static int v9fs_vfs_readpage(struct file
 	buffer = kmap(page);
 	offset = page_offset(page);
 
-	retval = v9fs_file_readn(filp, buffer, NULL, offset, PAGE_CACHE_SIZE);
+	retval = v9fs_file_readn(filp, buffer, NULL, PAGE_CACHE_SIZE, offset);
 	if (retval < 0)
 		goto done;
 
_

Patches currently in -mm which might be from adkulkar@umail.iu.edu are

origin.patch

