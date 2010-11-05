From: akpm@linux-foundation.org
Subject: [merged] fs-btrfs-use-memdup_user.patch removed from -mm tree
Date: Fri, 05 Nov 2010 11:29:09 -0700
Message-ID: <201011051830.oA5IUpG6025677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696Ab0KESbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 14:31:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs/btrfs: use memdup_user
has been removed from the -mm tree.  Its filename was
     fs-btrfs-use-memdup_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/btrfs: use memdup_user
From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/ioctl.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN fs/btrfs/ioctl.c~fs-btrfs-use-memdup_user fs/btrfs/ioctl.c
--- a/fs/btrfs/ioctl.c~fs-btrfs-use-memdup_user
+++ a/fs/btrfs/ioctl.c
@@ -1073,14 +1073,10 @@ static noinline int btrfs_ioctl_tree_sea
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	args = kmalloc(sizeof(*args), GFP_KERNEL);
-	if (!args)
-		return -ENOMEM;
+	args = memdup_user(argp, sizeof(*args));
+	if (IS_ERR(args))
+		return PTR_ERR(args);
 
-	if (copy_from_user(args, argp, sizeof(*args))) {
-		kfree(args);
-		return -EFAULT;
-	}
 	inode = fdentry(file)->d_inode;
 	ret = search_ioctl(inode, args);
 	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
@@ -1188,14 +1184,10 @@ static noinline int btrfs_ioctl_ino_look
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	args = kmalloc(sizeof(*args), GFP_KERNEL);
-	if (!args)
-		return -ENOMEM;
+	args = memdup_user(argp, sizeof(*args));
+	if (IS_ERR(args))
+		return PTR_ERR(args);
 
-	if (copy_from_user(args, argp, sizeof(*args))) {
-		kfree(args);
-		return -EFAULT;
-	}
 	inode = fdentry(file)->d_inode;
 
 	if (args->treeid == 0)
_

Patches currently in -mm which might be from julia@diku.dk are

fs-btrfs-inodec-eliminate-memory-leak.patch

