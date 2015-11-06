From: akpm@linux-foundation.org
Subject: [merged] 9p-do-not-overwrite-return-code-when-locking-fails.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:01 -0800
Message-ID: <563d0829.82eoMZUvCRJ7YgmX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161823AbbKFUGC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dominique.martinet@cea.fr, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     Subject: 9p: do not overwrite return code when locking fails
has been removed from the -mm tree.  Its filename was
     9p-do-not-overwrite-return-code-when-locking-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dominique Martinet <dominique.martinet@cea.fr>
Subject: 9p: do not overwrite return code when locking fails

If the remote locking fail, we run a local vfs unlock that should work and
return success to userland when we didn't actually lock at all.  We need
to tell the application that tried to lock that it didn't get it, not that
all went well.

Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/9p/vfs_file.c~9p-do-not-overwrite-return-code-when-locking-fails fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~9p-do-not-overwrite-return-code-when-locking-fails
+++ a/fs/9p/vfs_file.c
@@ -231,7 +231,8 @@ out_unlock:
 	if (res < 0 && fl->fl_type != F_UNLCK) {
 		fl_type = fl->fl_type;
 		fl->fl_type = F_UNLCK;
-		res = posix_lock_file_wait(filp, fl);
+		/* Even if this fails we want to return the remote error */
+		posix_lock_file_wait(filp, fl);
 		fl->fl_type = fl_type;
 	}
 out:
_

Patches currently in -mm which might be from dominique.martinet@cea.fr are


