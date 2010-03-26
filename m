From: akpm@linux-foundation.org
Subject: [merged] ecryptfs-fix-oops-after-umount.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:37:51 -0400
Message-ID: <201003261938.o2QJco5H016709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572Ab0CZTjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lk@c--e.de, eparis@redhat.com, kirkland@canonical.com, rjw@sisk.pl, tyhicks@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: fix OOPs after umount
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-oops-after-umount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: fix OOPs after umount
From: Christian Ehrhardt <lk@c--e.de>

Remove a d_drop in ecryptfs that is bogus IMHO.  This d_drop unhashes a
perfectly valid and reachable dentry in the lower FS.  The patch fixes
this perfectly reproducible kernel oops:

    https://bugzilla.kernel.org/show_bug.cgi?id=10907

It and may or may not be related to this ecryptfs bug:

   https://bugs.launchpad.net/ecryptfs/+bug/363734

At least the BUG_ON is on a dentry that should not be unhashed but is.

      regards   Christian

Signed-off-by: Christian Ehrhardt <lk@c--e.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Eric Paris <eparis@redhat.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/super.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ecryptfs/super.c~ecryptfs-fix-oops-after-umount fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-fix-oops-after-umount
+++ a/fs/ecryptfs/super.c
@@ -85,7 +85,6 @@ static void ecryptfs_destroy_inode(struc
 		if (lower_dentry->d_inode) {
 			fput(inode_info->lower_file);
 			inode_info->lower_file = NULL;
-			d_drop(lower_dentry);
 		}
 	}
 	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
_

Patches currently in -mm which might be from lk@c--e.de are


