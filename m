From: akpm@linux-foundation.org
Subject: - romfs-prevent-romfs_lookup-from-always-failing.patch removed from -mm tree
Date: Fri, 14 Mar 2008 15:47:55 -0700
Message-ID: <200803142247.m2EMlu8I022939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309AbYCNWsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 18:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adam@yggdrasil.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     romfs: prevent romfs_lookup() from always failing
has been removed from the -mm tree.  Its filename was
     romfs-prevent-romfs_lookup-from-always-failing.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: romfs: prevent romfs_lookup() from always failing
From: "Adam J. Richter" <adam@yggdrasil.com>

romfs_lookup worked in 2.6.24.2, but always fails in linux-2.6.25-rc3-git3. 
fs/romfs/inode.c is the same in at least 2.6.25-rc3 through 2.6.25-rc3-git4
and the latest sources from git, so these versions almost certainly have the
same problem.

The bug appears to be from a well meaning but botched attempt to eliminate a
goto from romfs_lookup.  Previously, a goto statement was used to skip over
"inode = NULL;" when the lookup succeeded.  In the 2.6.25-rc3 version, inode
is set to NULL even when an inode was found, so the result is the the lookup
always appears to fail.

The attached patch fixes the problem while still eliminating the goto.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/romfs/inode.c~romfs-prevent-romfs_lookup-from-always-failing fs/romfs/inode.c
--- a/fs/romfs/inode.c~romfs-prevent-romfs_lookup-from-always-failing
+++ a/fs/romfs/inode.c
@@ -347,6 +347,7 @@ romfs_lookup(struct inode *dir, struct d
 	const char *name;		/* got from dentry */
 	int len;
 
+	inode = NULL;
 	res = -EACCES;			/* placeholder for "no data here" */
 	offset = dir->i_ino & ROMFH_MASK;
 	lock_kernel();
@@ -409,7 +410,7 @@ romfs_lookup(struct inode *dir, struct d
 	 * systems).
 	 */
 
-out0:	inode = NULL;
+out0:
 	res = 0;
 	d_add (dentry, inode);
 
_

Patches currently in -mm which might be from adam@yggdrasil.com are

romfs-prevent-romfs_lookup-from-always-failing.patch

