From: akpm@linux-foundation.org
Subject: [merged]
 autofs-use-unsigned-int-long-instead-of-uint-ulong-for-ioctl-args.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:43:25 -0700
Message-ID: <20170911194325.v4G--gQ8W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50524 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdIKTn0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raven@themaw.net, tkusumi@tuxera.com


The patch titled
     Subject: autofs: use unsigned int/long instead of uint/ulong for ioctl args
has been removed from the -mm tree.  Its filename was
     autofs-use-unsigned-int-long-instead-of-uint-ulong-for-ioctl-args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: use unsigned int/long instead of uint/ulong for ioctl args

The standard types unsigned int and unsigned long should be used for
.compat_ioctl.  autofs is the only fs using uing/ulong for this, and these
are even the only uint/ulong in the entire autofs code.

Drop unneeded long cast in return value of autofs_dev_ioctl_compat(). 
It's already long.

Link: http://lkml.kernel.org/r/150285069709.4670.3884827966280147529.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-use-unsigned-int-long-instead-of-uint-ulong-for-ioctl-args fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-use-unsigned-int-long-instead-of-uint-ulong-for-ioctl-args
+++ a/fs/autofs4/dev-ioctl.c
@@ -93,7 +93,7 @@ static int check_dev_ioctl_version(int c
  * at the end of the struct.
  */
 static struct autofs_dev_ioctl *
-		copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
+copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
 {
 	struct autofs_dev_ioctl tmp, *res;
 
@@ -705,7 +705,8 @@ out:
 	return err;
 }
 
-static long autofs_dev_ioctl(struct file *file, uint command, ulong u)
+static long autofs_dev_ioctl(struct file *file, unsigned int command,
+			     unsigned long u)
 {
 	int err;
 
@@ -714,9 +715,10 @@ static long autofs_dev_ioctl(struct file
 }
 
 #ifdef CONFIG_COMPAT
-static long autofs_dev_ioctl_compat(struct file *file, uint command, ulong u)
+static long autofs_dev_ioctl_compat(struct file *file, unsigned int command,
+				    unsigned long u)
 {
-	return (long) autofs_dev_ioctl(file, command, (ulong) compat_ptr(u));
+	return autofs_dev_ioctl(file, command, (unsigned long) compat_ptr(u));
 }
 #else
 #define autofs_dev_ioctl_compat NULL
_

Patches currently in -mm which might be from tkusumi@tuxera.com are


