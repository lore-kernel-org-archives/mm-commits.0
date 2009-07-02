From: akpm@linux-foundation.org
Subject: + 9p-fix-incorrect-parameters-to-v9fs_file_readn.patch added to -mm tree
Date: Thu, 02 Jul 2009 15:54:19 -0700
Message-ID: <200907022254.n62MsJet024686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857AbZGBWy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 18:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adkulkar@umail.iu.edu, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov


The patch titled
     9p: fix incorrect parameters to v9fs_file_readn()
has been added to the -mm tree.  Its filename is
     9p-fix-incorrect-parameters-to-v9fs_file_readn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

9p-fix-incorrect-parameters-to-v9fs_file_readn.patch
net-9p-fix-crash-due-to-bad-mount-parameters.patch

