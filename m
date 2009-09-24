From: akpm@linux-foundation.org
Subject: [merged] fs-char_devc-remove-useless-loop.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:11 -0700
Message-ID: <200909241936.n8OJaB56002008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbZIXTgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:36:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: renzo@cs.unibo.it, hidave.darkstar@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/char_dev.c: remove useless loop
has been removed from the -mm tree.  Its filename was
     fs-char_devc-remove-useless-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/char_dev.c: remove useless loop
From: Renzo Davoli <renzo@cs.unibo.it>

There are two useless lines in fs/char_dev.c.

In register_chrdev there is a loop to change all '/' into '!' in the
kernel object name.
This code is useless as the same substitution is in kobject_set_name_vargs in
lib/kobject.c:
228         /* ewww... some of these buggers have '/' in the name ... */
229         while ((s = strchr(kobj->name, '/')))
230                 s[0] = '!';

kobject_set_name_vargs is called by kobject_set_name.
kobject_set_name is called just above the useless loop.

[hidave.darkstar@gmail.com: fix warning, remove the unused char *s]
Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/char_dev.c~fs-char_devc-remove-useless-loop fs/char_dev.c
--- a/fs/char_dev.c~fs-char_devc-remove-useless-loop
+++ a/fs/char_dev.c
@@ -264,7 +264,6 @@ int __register_chrdev(unsigned int major
 {
 	struct char_device_struct *cd;
 	struct cdev *cdev;
-	char *s;
 	int err = -ENOMEM;
 
 	cd = __register_chrdev_region(major, baseminor, count, name);
@@ -278,8 +277,6 @@ int __register_chrdev(unsigned int major
 	cdev->owner = fops->owner;
 	cdev->ops = fops;
 	kobject_set_name(&cdev->kobj, "%s", name);
-	for (s = strchr(kobject_name(&cdev->kobj),'/'); s; s = strchr(s, '/'))
-		*s = '!';
 		
 	err = cdev_add(cdev, MKDEV(cd->major, baseminor), count);
 	if (err)
_

Patches currently in -mm which might be from renzo@cs.unibo.it are

origin.patch

