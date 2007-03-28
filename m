From: akpm@linux-foundation.org
Subject: - fix-sysfs-reclaim-crash.patch removed from -mm tree
Date: Wed, 28 Mar 2007 13:45:56 -0700
Message-ID: <200703282045.l2SKjuGl019703@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59207 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809AbXC1UqN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 16:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maneesh@in.ibm.com, dipankar@in.ibm.com, greg@kroah.com, hch@lst.de, mbligh@google.com, rohitseth@google.com, solo@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix sysfs reclaim crash
has been removed from the -mm tree.  Its filename was
     fix-sysfs-reclaim-crash.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: fix sysfs reclaim crash
From: Maneesh Soni <maneesh@in.ibm.com>

Maybe.

  happens without i_mutex. It also nullifies s_dentry just to indicate that
  the associated dentry is evicted. sysfs_readdir() access the s_dentry,
  and gets the inode number from the associated dentry, if there is one, else
  it invokes iunique(). This can create a race situation, and crash while
  accessing the dentry/inode in sysfs_readdir().

o The following patch always use i_unique() to get the inode number. This
  is ok as sysfs doesnot have permanent inode numbering. It could be slower
  but avoids the above mentioned race.

o This also avoids the now unnecessary s_dentry in sysfs_d_iput().

Signed-off-by: Maneesh Soni <maneesh@in.ibm.com>
Cc: Ethan Solomita <solo@google.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/sysfs/dir.c~fix-sysfs-reclaim-crash fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~fix-sysfs-reclaim-crash
+++ a/fs/sysfs/dir.c
@@ -20,7 +20,6 @@ static void sysfs_d_iput(struct dentry *
 
 	if (sd) {
 		BUG_ON(sd->s_dentry != dentry);
-		sd->s_dentry = NULL;
 		sysfs_put(sd);
 	}
 	iput(inode);
@@ -538,10 +537,7 @@ static int sysfs_readdir(struct file * f
 
 				name = sysfs_get_name(next);
 				len = strlen(name);
-				if (next->s_dentry)
-					ino = next->s_dentry->d_inode->i_ino;
-				else
-					ino = iunique(sysfs_sb, 2);
+				ino = iunique(sysfs_sb, 2);
 
 				if (filldir(dirent, name, len, filp->f_pos, ino,
 						 dt_type(next)) < 0)
_

Patches currently in -mm which might be from maneesh@in.ibm.com are

fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-sysfs-reclaim-crash.patch
