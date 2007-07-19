From: akpm@linux-foundation.org
Subject: + vfs-fix-a-race-in-lease-breaking-during-truncate.patch added to -mm tree
Date: Wed, 18 Jul 2007 19:49:32 -0700
Message-ID: <200707190249.l6J2nWqZ010062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbXGSCtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 22:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richterd@citi.umich.edu, bfields@citi.umich.edu


The patch titled
     VFS: fix a race in lease-breaking during truncate
has been added to the -mm tree.  Its filename is
     vfs-fix-a-race-in-lease-breaking-during-truncate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VFS: fix a race in lease-breaking during truncate
From: david m. richter <richterd@citi.umich.edu>

It is possible that another process could acquire a new file lease right
after break_lease() is called during a truncate, but before lease-granting
is disabled by the subsequent get_write_access().  Merely switching the
order of the break_lease() and get_write_access() calls prevents this race.

Signed-off-by: David M. Richter <richterd@citi.umich.edu>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/open.c~vfs-fix-a-race-in-lease-breaking-during-truncate fs/open.c
--- a/fs/open.c~vfs-fix-a-race-in-lease-breaking-during-truncate
+++ a/fs/open.c
@@ -256,24 +256,26 @@ static long do_sys_truncate(const char _
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		goto dput_and_out;
 
-	/*
-	 * Make sure that there are no leases.
-	 */
-	error = break_lease(inode, FMODE_WRITE);
+	error = get_write_access(inode);
 	if (error)
 		goto dput_and_out;
 
-	error = get_write_access(inode);
+	/*
+	 * Make sure that there are no leases.  get_write_access() protects
+	 * against the truncate racing with a lease-granting setlease().
+	 */
+	error = break_lease(inode, FMODE_WRITE);
 	if (error)
-		goto dput_and_out;
+		goto put_write_and_out;
 
 	error = locks_verify_truncate(inode, NULL, length);
 	if (!error) {
 		DQUOT_INIT(inode);
 		error = do_truncate(nd.dentry, length, 0, NULL);
 	}
-	put_write_access(inode);
 
+put_write_and_out:
+	put_write_access(inode);
 dput_and_out:
 	path_release(&nd);
 out:
_

Patches currently in -mm which might be from richterd@citi.umich.edu are

git-vfs-lease-api.patch
vfs-fix-a-race-in-lease-breaking-during-truncate.patch
