From: akpm@linux-foundation.org
Subject: - uml-watchdog-driver-formatting.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:29 -0800
Message-ID: <200702112248.l1BMmTPi015632@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59725 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634AbXBKWsc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: watchdog driver formatting
has been removed from the -mm tree.  Its filename was
     uml-watchdog-driver-formatting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: watchdog driver formatting
From: Jeff Dike <jdike@addtoit.com>

Whitespace and style fixes.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/harddog_kern.c |   33 ++++++++++---------------------
 arch/um/drivers/harddog_user.c |   23 +++++----------------
 2 files changed, 17 insertions(+), 39 deletions(-)

diff -puN arch/um/drivers/harddog_kern.c~uml-watchdog-driver-formatting arch/um/drivers/harddog_kern.c
--- a/arch/um/drivers/harddog_kern.c~uml-watchdog-driver-formatting
+++ a/arch/um/drivers/harddog_kern.c
@@ -9,10 +9,10 @@
  *	modify it under the terms of the GNU General Public License
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
- *	
- *	Neither Alan Cox nor CymruNet Ltd. admit liability nor provide 
- *	warranty for any of this software. This material is provided 
- *	"AS-IS" and at no charge.	
+ *
+ *	Neither Alan Cox nor CymruNet Ltd. admit liability nor provide
+ *	warranty for any of this software. This material is provided
+ *	"AS-IS" and at no charge.
  *
  *	(c) Copyright 1995    Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
@@ -29,11 +29,11 @@
  *	Made SMP safe for 2.3.x
  *
  *  20011127 Joel Becker (jlbec@evilplan.org>
- *	Added soft_noboot; Allows testing the softdog trigger without 
+ *	Added soft_noboot; Allows testing the softdog trigger without
  *	requiring a recompile.
  *	Added WDIOC_GETTIMEOUT and WDIOC_SETTIMOUT.
  */
- 
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -58,7 +58,7 @@ static int harddog_out_fd = -1;
 /*
  *	Allow only one person to hold it open
  */
- 
+
 extern int start_watchdog(int *in_fd_ret, int *out_fd_ret, char *sock);
 
 static int harddog_open(struct inode *inode, struct file *file)
@@ -69,7 +69,7 @@ static int harddog_open(struct inode *in
 	spin_lock(&lock);
 	if(timer_alive)
 		goto err;
-#ifdef CONFIG_HARDDOG_NOWAYOUT	 
+#ifdef CONFIG_HARDDOG_NOWAYOUT
 	__module_get(THIS_MODULE);
 #endif
 
@@ -117,7 +117,7 @@ static ssize_t harddog_write(struct file
 	 *	Refresh the timer.
 	 */
 	if(len)
-		return(ping_watchdog(harddog_out_fd));
+		return ping_watchdog(harddog_out_fd);
 	return 0;
 }
 
@@ -141,7 +141,7 @@ static int harddog_ioctl(struct inode *i
 		case WDIOC_GETBOOTSTATUS:
 			return put_user(0,(int __user *)argp);
 		case WDIOC_KEEPALIVE:
-			return(ping_watchdog(harddog_out_fd));
+			return ping_watchdog(harddog_out_fd);
 	}
 }
 
@@ -172,7 +172,7 @@ static int __init harddog_init(void)
 
 	printk(banner);
 
-	return(0);
+	return 0;
 }
 
 static void __exit harddog_exit(void)
@@ -182,14 +182,3 @@ static void __exit harddog_exit(void)
 
 module_init(harddog_init);
 module_exit(harddog_exit);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/harddog_user.c~uml-watchdog-driver-formatting arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~uml-watchdog-driver-formatting
+++ a/arch/um/drivers/harddog_user.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
@@ -38,7 +38,7 @@ int start_watchdog(int *in_fd_ret, int *
 	int in_fds[2], out_fds[2], pid, n, err;
 	char pid_buf[sizeof("nnnnn\0")], c;
 	char *pid_args[] = { "/usr/bin/uml_watchdog", "-pid", pid_buf, NULL };
-	char *mconsole_args[] = { "/usr/bin/uml_watchdog", "-mconsole", NULL, 
+	char *mconsole_args[] = { "/usr/bin/uml_watchdog", "-mconsole", NULL,
 				  NULL };
 	char **args = NULL;
 
@@ -96,7 +96,7 @@ int start_watchdog(int *in_fd_ret, int *
 	}
 	*in_fd_ret = in_fds[0];
 	*out_fd_ret = out_fds[1];
-	return(0);
+	return 0;
 
  out_close_in:
 	os_close_file(in_fds[0]);
@@ -105,7 +105,7 @@ int start_watchdog(int *in_fd_ret, int *
 	os_close_file(out_fds[0]);
 	os_close_file(out_fds[1]);
  out:
-	return(err);
+	return err;
 }
 
 void stop_watchdog(int in_fd, int out_fd)
@@ -123,20 +123,9 @@ int ping_watchdog(int fd)
 	if(n != sizeof(c)){
 		printk("ping_watchdog - write failed, err = %d\n", -n);
 		if(n < 0)
-			return(n);
-		return(-EIO);
+			return n;
+		return -EIO;
 	}
 	return 1;
 
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
