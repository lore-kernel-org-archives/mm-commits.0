From: akpm@linux-foundation.org
Subject: - random-use-unlocked_ioctl.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:09 -0700
Message-ID: <200804300548.m3U5m9kk029858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757350AbYD3GKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:10:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: use unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     random-use-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: use unlocked_ioctl
From: Matt Mackall <mpm@selenic.com>

No locking actually needed.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/char/random.c~random-use-unlocked_ioctl drivers/char/random.c
--- a/drivers/char/random.c~random-use-unlocked_ioctl
+++ a/drivers/char/random.c
@@ -1062,8 +1062,7 @@ static ssize_t random_write(struct file 
 	return (ssize_t)count;
 }
 
-static int random_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	int size, ent_count;
 	int __user *p = (int __user *)arg;
@@ -1071,8 +1070,8 @@ static int random_ioctl(struct inode *in
 
 	switch (cmd) {
 	case RNDGETENTCNT:
-		ent_count = input_pool.entropy_count;
-		if (put_user(ent_count, p))
+		/* inherently racy, no point locking */
+		if (put_user(input_pool.entropy_count, p))
 			return -EFAULT;
 		return 0;
 	case RNDADDTOENTCNT:
@@ -1115,13 +1114,13 @@ const struct file_operations random_fops
 	.read  = random_read,
 	.write = random_write,
 	.poll  = random_poll,
-	.ioctl = random_ioctl,
+	.unlocked_ioctl = random_ioctl,
 };
 
 const struct file_operations urandom_fops = {
 	.read  = urandom_read,
 	.write = random_write,
-	.ioctl = random_ioctl,
+	.unlocked_ioctl = random_ioctl,
 };
 
 /***************************************************************
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch

