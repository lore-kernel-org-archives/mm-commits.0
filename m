From: akpm@linux-foundation.org
Subject: + fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh.patch added to -mm tree
Date: Tue, 05 Feb 2008 02:01:37 -0800
Message-ID: <200802051001.m15A1Ig5015167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050AbYBEKB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 05:01:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com


The patch titled
     fs/char_dev.c: chrdev_open marked static and removed from fs.h
has been added to the -mm tree.  Its filename is
     fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/char_dev.c: chrdev_open marked static and removed from fs.h
From: Denis Cheng <crquan@gmail.com>

There is an outdated comment in serial_core.c also fixed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    4 ++--
 fs/char_dev.c                |    2 +-
 include/linux/fs.h           |    1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/serial/serial_core.c~fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh
+++ a/drivers/serial/serial_core.c
@@ -1560,8 +1560,8 @@ static struct uart_state *uart_get(struc
 }
 
 /*
- * In 2.4.5, calls to uart_open are serialised by the BKL in
- *   linux/fs/devices.c:chrdev_open()
+ * calls to uart_open are serialised by the BKL in
+ *   fs/char_dev.c:chrdev_open()
  * Note that if this fails, then uart_close() _will_ be called.
  *
  * In time, we want to scrap the "opening nonpresent ports"
diff -puN fs/char_dev.c~fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh fs/char_dev.c
--- a/fs/char_dev.c~fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh
+++ a/fs/char_dev.c
@@ -357,7 +357,7 @@ void cdev_put(struct cdev *p)
 /*
  * Called every time a character special file is opened
  */
-int chrdev_open(struct inode * inode, struct file * filp)
+static int chrdev_open(struct inode *inode, struct file *filp)
 {
 	struct cdev *p;
 	struct cdev *new = NULL;
diff -puN include/linux/fs.h~fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh include/linux/fs.h
--- a/include/linux/fs.h~fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh
+++ a/include/linux/fs.h
@@ -1627,7 +1627,6 @@ extern int register_chrdev(unsigned int,
 			   const struct file_operations *);
 extern void unregister_chrdev(unsigned int, const char *);
 extern void unregister_chrdev_region(dev_t, unsigned);
-extern int chrdev_open(struct inode *, struct file *);
 extern void chrdev_show(struct seq_file *,off_t);
 
 /* fs/block_dev.c */
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
git-md-accel.patch
3w-raid-drivers-memset-not-needed-in-probe.patch
drivers-char-use-list_head-instead-of-list_head_init.patch
drivers-char-ipmi-ipmi_msghandlerc-use-list_head-instead-of-list_head_init.patch
fs-reiserfs-xattrc-use-list_head-instead-of-list_head_init.patch
fs-char_devc-chrdev_open-marked-static-and-removed-from-fsh.patch
