From: akpm@linux-foundation.org
Subject: - locks-kill-redundant-local-variable.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:08:10 -0700
Message-ID: <200708081908.l78J8AKt025851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36360 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932647AbXHHTSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:18:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, Trond.Myklebust@netapp.com, bfields@citi.umich.edu, mm-commits@vger.kernel.org


The patch titled
     locks: kill redundant local variable
has been removed from the -mm tree.  Its filename was
     locks-kill-redundant-local-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: locks: kill redundant local variable
From: "J. Bruce Fields" <bfields@fieldses.org>

There's no need for another variable local to this loop; we can use the
variable (of the same name!) already declared at the top of the function,
and not used till later (at which point it's initialized, so this is safe).

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/locks.c~locks-kill-redundant-local-variable fs/locks.c
--- a/fs/locks.c~locks-kill-redundant-local-variable
+++ a/fs/locks.c
@@ -819,7 +819,7 @@ static int __posix_lock_file(struct inod
 	lock_kernel();
 	if (request->fl_type != F_UNLCK) {
 		for_each_lock(inode, before) {
-			struct file_lock *fl = *before;
+			fl = *before;
 			if (!IS_POSIX(fl))
 				continue;
 			if (!posix_locks_conflict(request, fl))
_

Patches currently in -mm which might be from bfields@fieldses.org are

64-bit-ino-support-for-nfs-client.patch
git-nfsd.patch
fs-nfsd-exportc-make-3-functions-static.patch
