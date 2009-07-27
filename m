From: akpm@linux-foundation.org
Subject: + fs-char_devc-remove-useless-loop.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:07:36 -0700
Message-ID: <200907272107.n6RL7anJ004107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbZG0VKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: renzo@cs.unibo.it, viro@zeniv.linux.org.uk


The patch titled
     fs/char_dev.c: remove useless loop
has been added to the -mm tree.  Its filename is
     fs-char_devc-remove-useless-loop.patch

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

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/char_dev.c~fs-char_devc-remove-useless-loop fs/char_dev.c
--- a/fs/char_dev.c~fs-char_devc-remove-useless-loop
+++ a/fs/char_dev.c
@@ -278,8 +278,6 @@ int register_chrdev(unsigned int major, 
 	cdev->owner = fops->owner;
 	cdev->ops = fops;
 	kobject_set_name(&cdev->kobj, "%s", name);
-	for (s = strchr(kobject_name(&cdev->kobj),'/'); s; s = strchr(s, '/'))
-		*s = '!';
 		
 	err = cdev_add(cdev, MKDEV(cd->major, 0), 256);
 	if (err)
_

Patches currently in -mm which might be from renzo@cs.unibo.it are

fs-char_devc-remove-useless-loop.patch

