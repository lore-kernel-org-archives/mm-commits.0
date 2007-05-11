From: akpm@linux-foundation.org
Subject: + locks-fix-f_getlk-regression-failure-to-find-conflicts.patch added to -mm tree
Date: Thu, 10 May 2007 19:28:10 -0700
Message-ID: <200705110228.l4B2SABl004251@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756851AbXEKC2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 22:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, doug.chapman@hp.com


The patch titled
     locks: fix F_GETLK regression (failure to find conflicts)
has been added to the -mm tree.  Its filename is
     locks-fix-f_getlk-regression-failure-to-find-conflicts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: locks: fix F_GETLK regression (failure to find conflicts)
From: "J. Bruce Fields" <bfields@fieldses.org>

In 9d6a8c5c213e34c475e72b245a8eb709258e968c we changed posix_test_lock to
modify its single file_lock argument instead of taking separate input and
output arguments.  This makes it no longer safe to set the output lock's
fl_type to F_UNLCK before looking for a conflict, since that means
searching for a conflict against a lock with type F_UNLCK.

This fixes a regression which causes F_GETLK to incorrectly report no
conflict on most filesystems (including any filesystem that doesn't do its
own locking).

Also fix posix_lock_to_flock() to copy the lock type.  This isn't strictly
necessary, since the caller already does this; but it seems less likely to
cause confusion in the future.

Thanks to Doug Chapman for the bug report.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Doug Chapman <doug.chapman@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/locks.c~locks-fix-f_getlk-regression-failure-to-find-conflicts fs/locks.c
--- a/fs/locks.c~locks-fix-f_getlk-regression-failure-to-find-conflicts
+++ a/fs/locks.c
@@ -669,7 +669,6 @@ posix_test_lock(struct file *filp, struc
 {
 	struct file_lock *cfl;
 
-	fl->fl_type = F_UNLCK;
 	lock_kernel();
 	for (cfl = filp->f_path.dentry->d_inode->i_flock; cfl; cfl = cfl->fl_next) {
 		if (!IS_POSIX(cfl))
@@ -681,7 +680,8 @@ posix_test_lock(struct file *filp, struc
 		__locks_copy_lock(fl, cfl);
 		unlock_kernel();
 		return 1;
-	}
+	} else
+		fl->fl_type = F_UNLCK;
 	unlock_kernel();
 	return 0;
 }
@@ -1632,6 +1632,7 @@ static int posix_lock_to_flock(struct fl
 	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
 		fl->fl_end - fl->fl_start + 1;
 	flock->l_whence = 0;
+	flock->l_type = fl->fl_type;
 	return 0;
 }
 
_

Patches currently in -mm which might be from bfields@fieldses.org are

origin.patch
locks-fix-f_getlk-regression-failure-to-find-conflicts.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
nfs-use-zero_user_page.patch
