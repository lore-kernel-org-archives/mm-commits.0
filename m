From: akpm@osdl.org
Subject: + uml-watchdog-driver-formatting.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:55:38 -0800
Message-ID: <200701022255.l02MtdkE032689@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965017AbXABWz6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:55:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: watchdog driver formatting
has been added to the -mm tree.  Its filename is
     uml-watchdog-driver-formatting.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: watchdog driver formatting
From: Jeff Dike <jdike@addtoit.com>

Whitespace and style fixes.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
