From: akpm@linux-foundation.org
Subject: + fix-sysfs_readdir-oops.patch added to -mm tree
Date: Tue, 03 Apr 2007 17:25:40 -0700
Message-ID: <200704040025.l340PevR007618@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49996 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992519AbXDDAZw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 20:25:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maneesh@in.ibm.com, dipankar@in.ibm.com, greg@kroah.com, mbligh@google.com, rohitseth@google.com, solo@google.com


The patch titled
     fix sysfs_readdir oops
has been added to the -mm tree.  Its filename is
     fix-sysfs_readdir-oops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix sysfs_readdir oops
From: Maneesh Soni <maneesh@in.ibm.com>

o sysfs_d_iput() is invoked in dentry reclaim path under memory pressure. This
  happens without i_mutex. It also nullifies s_dentry to indicate that
  the associated dentry is evicted. sysfs_readdir() accesses the s_dentry,
  and gets the inode number from the associated dentry->d_inode, if
  there is one, else it invokes iunique(). This can create a race situation,
  and crash while accessing the d_inode in sysfs_readdir().

o The race happens when the dentry is getting reclaimed and detached from
  the corresponding sysfs_dirent though sysfs_dirent is still a valid
  node. Accessing dentry fields are ok as it is under RCU but the inode is
  not hence we may see oops accessing dentry->d_inode->i_no.

o The following patch always use i_unique() to get the inode number in
  sysfs_readdir. This is ok as sysfs doesnot have permanent inode numbering.
  It could be slower but avoids the oops.

Signed-off-by: Maneesh Soni <maneesh@in.ibm.com>

Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Ethan Solomita <solo@google.com>
Cc: Greg KH <greg@kroah.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Rohit Seth <rohitseth@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/sysfs/dir.c~fix-sysfs_readdir-oops fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~fix-sysfs_readdir-oops
+++ a/fs/sysfs/dir.c
@@ -538,10 +538,7 @@ static int sysfs_readdir(struct file * f
 
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

fix-sysfs_readdir-oops.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
kprobes-print-details-of-kretprobe-on-assertion-failure.patch
