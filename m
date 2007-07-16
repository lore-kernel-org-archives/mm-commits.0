From: akpm@linux-foundation.org
Subject: - uml-pty-channel-tidying.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:51:16 -0700
Message-ID: <200707162051.l6GKpGML001387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756416AbXGPVdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: pty channel tidying
has been removed from the -mm tree.  Its filename was
     uml-pty-channel-tidying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: pty channel tidying
From: Jeff Dike <jdike@addtoit.com>

Cleanup, mostly style violations.

Tidied the includes.

getmaster returns a real errno, which pty_open returns if there's a
problem.

The printks now have severity.

Changed os_* calls to call libc directly.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/pty.c |   76 +++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 36 deletions(-)

diff -puN arch/um/drivers/pty.c~uml-pty-channel-tidying arch/um/drivers/pty.c
--- a/arch/um/drivers/pty.c~uml-pty-channel-tidying
+++ a/arch/um/drivers/pty.c
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -7,12 +7,14 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
+#include <fcntl.h>
 #include <errno.h>
 #include <termios.h>
+#include <sys/stat.h>
 #include "chan_user.h"
-#include "user.h"
-#include "kern_util.h"
 #include "os.h"
+#include "user.h"
+#include "kern_constants.h"
 #include "um_malloc.h"
 
 struct pty_chan {
@@ -28,11 +30,13 @@ static void *pty_chan_init(char *str, in
 	struct pty_chan *data;
 
 	data = um_kmalloc(sizeof(*data));
-	if(data == NULL) return(NULL);
+	if (data == NULL)
+		return NULL;
+
 	*data = ((struct pty_chan) { .announce  	= opts->announce, 
 				     .dev  		= device,
 				     .raw  		= opts->raw });
-	return(data);
+	return data;
 }
 
 static int pts_open(int input, int output, int primary, void *d,
@@ -43,31 +47,35 @@ static int pts_open(int input, int outpu
 	int fd, err;
 
 	fd = get_pty();
-	if(fd < 0){
+	if (fd < 0) {
 		err = -errno;
-		printk("open_pts : Failed to open pts\n");
+		printk(UM_KERN_ERR "open_pts : Failed to open pts\n");
 		return err;
 	}
-	if(data->raw){
+
+	if (data->raw) {
 		CATCH_EINTR(err = tcgetattr(fd, &data->tt));
-		if(err)
-			return(err);
+		if (err)
+			return err;
 
 		err = raw(fd);
-		if(err)
-			return(err);
+		if (err)
+			return err;
 	}
 
 	dev = ptsname(fd);
 	sprintf(data->dev_name, "%s", dev);
 	*dev_out = data->dev_name;
+
 	if (data->announce)
 		(*data->announce)(dev, data->dev);
-	return(fd);
+
+	return fd;
 }
 
 static int getmaster(char *line)
 {
+	struct stat buf;
 	char *pty, *bank, *cp;
 	int master, err;
 
@@ -75,24 +83,29 @@ static int getmaster(char *line)
 	for (bank = "pqrs"; *bank; bank++) {
 		line[strlen("/dev/pty")] = *bank;
 		*pty = '0';
-		if (os_stat_file(line, NULL) < 0)
+		/* Did we hit the end ? */
+		if ((stat(line, &buf) < 0) && (errno == ENOENT))
 			break;
+
 		for (cp = "0123456789abcdef"; *cp; cp++) {
 			*pty = *cp;
-			master = os_open_file(line, of_rdwr(OPENFLAGS()), 0);
+			master = open(line, O_RDWR);
 			if (master >= 0) {
 				char *tp = &line[strlen("/dev/")];
 
 				/* verify slave side is usable */
 				*tp = 't';
-				err = os_access(line, OS_ACC_RW_OK);
+				err = access(line, R_OK | W_OK);
 				*tp = 'p';
-				if(err == 0) return(master);
-				(void) os_close_file(master);
+				if(!err)
+					return master;
+				close(master);
 			}
 		}
 	}
-	return(-1);
+
+	printk(UM_KERN_ERR "getmaster - no usable host pty devices\n");
+	return -ENOENT;
 }
 
 static int pty_open(int input, int output, int primary, void *d,
@@ -103,20 +116,22 @@ static int pty_open(int input, int outpu
 	char dev[sizeof("/dev/ptyxx\0")] = "/dev/ptyxx";
 
 	fd = getmaster(dev);
-	if(fd < 0)
-		return(-errno);
+	if (fd < 0)
+		return fd;
 
 	if(data->raw){
 		err = raw(fd);
-		if(err)
-			return(err);
+		if (err)
+			return err;
 	}
 	
-	if(data->announce) (*data->announce)(dev, data->dev);
+	if (data->announce)
+		(*data->announce)(dev, data->dev);
 
 	sprintf(data->dev_name, "%s", dev);
 	*dev_out = data->dev_name;
-	return(fd);
+
+	return fd;
 }
 
 const struct chan_ops pty_ops = {
@@ -144,14 +159,3 @@ const struct chan_ops pts_ops = {
 	.free		= generic_free,
 	.winch		= 0,
 };
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
hostfs-convert-to-new-aops.patch
