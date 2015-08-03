From: akpm@linux-foundation.org
Subject: + 9p-do-not-overwrite-return-code-when-locking-fails.patch added
 to -mm tree
Date: Mon, 03 Aug 2015 15:34:18 -0700
Message-ID: <55bfec6a.ppHqv5lBkuoUFMT1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbbHCWeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2015 18:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dominique.martinet@cea.fr, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     Subject: 9p: do not overwrite return code when locking fails
has been added to the -mm tree.  Its filename is
     9p-do-not-overwrite-return-code-when-locking-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/9p-do-not-overwrite-return-code-when-locking-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/9p-do-not-overwrite-return-code-when-locking-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

9p-do-not-overwrite-return-code-when-locking-fails.patch

