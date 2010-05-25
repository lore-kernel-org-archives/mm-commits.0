From: akpm@linux-foundation.org
Subject: + fs-btrfs-use-memdup_user.patch added to -mm tree
Date: Tue, 25 May 2010 15:36:29 -0700
Message-ID: <201005252236.o4PMaT0T019036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758698Ab0EYWhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 18:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, chris.mason@oracle.com


The patch titled
     fs/btrfs: use memdup_user
has been added to the -mm tree.  Its filename is
     fs-btrfs-use-memdup_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1096,14 +1096,10 @@ static noinline int btrfs_ioctl_tree_sea
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
@@ -1211,14 +1207,10 @@ static noinline int btrfs_ioctl_ino_look
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

origin.patch
linux-next.patch
drivers-scsi-aacraid-eliminate-use-after-free.patch
arch-x86-pci-use-kasprintf.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-char-ppdevc-use-kasprintf.patch
net-can-use-memdup_user.patch
drivers-net-use-memdup_user.patch
fs-btrfs-use-memdup_user.patch
drivers-video-via-use-memdup_user.patch
mm-use-memdup_user.patch
drivers-net-cxgb3-use-memdup_user.patch
drivers-net-wan-use-memdup_user.patch
drivers-block-use-memdup_user.patch
drivers-media-use-memdup_user.patch
drivers-infiniband-core-use-memdup_user.patch
drivers-i2c-use-memdup_user.patch
drivers-ieee1394-use-memdup_user.patch
fs-autofs4-use-memdup_user.patch
drivers-scsi-use-memdup_user.patch
drivers-char-applicomc-use-memdup_user.patch
drivers-char-vtc-use-memdup_user.patch
drivers-message-i2o-i2o_configc-use-memdup_user.patch
drivers-telephony-ixjc-use-memdup_user.patch
drivers-s390-net-use-memdup_user.patch
drivers-ide-use-memdup_user.patch
net-dccp-use-memdup_user.patch
drivers-net-wireless-prism54-use-memdup_user.patch
drivers-usb-gadget-use-memdup_user.patch
drivers-isdn-use-memdup_user.patch
drivers-staging-dream-camera-use-memdup_user.patch

