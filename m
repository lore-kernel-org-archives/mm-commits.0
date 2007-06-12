From: akpm@linux-foundation.org
Subject: - uml-get-declaration-of-simple_strtoul.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:06 -0700
Message-ID: <200706121857.l5CIv6gS018445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755994AbXFLS5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: get declaration of simple_strtoul
has been removed from the -mm tree.  Its filename was
     uml-get-declaration-of-simple_strtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: get declaration of simple_strtoul
From: Jeff Dike <jdike@addtoit.com>

Include linux/kernel.h wherever simple_strtoul is used.  This kills a
compile warning in stderr_console.c and potential ones in the other files.

This also fixes a bunch of style violations in exitcode.c.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c           |    1 
 arch/um/drivers/stderr_console.c |    1 
 arch/um/drivers/ubd_kern.c       |    1 
 arch/um/kernel/exitcode.c        |   39 ++++++++++++-----------------
 4 files changed, 20 insertions(+), 22 deletions(-)

diff -puN arch/um/drivers/line.c~uml-get-declaration-of-simple_strtoul arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-get-declaration-of-simple_strtoul
+++ a/arch/um/drivers/line.c
@@ -3,6 +3,7 @@
  * Licensed under the GPL
  */
 
+#include "linux/kernel.h"
 #include "linux/sched.h"
 #include "linux/slab.h"
 #include "linux/list.h"
diff -puN arch/um/drivers/stderr_console.c~uml-get-declaration-of-simple_strtoul arch/um/drivers/stderr_console.c
--- a/arch/um/drivers/stderr_console.c~uml-get-declaration-of-simple_strtoul
+++ a/arch/um/drivers/stderr_console.c
@@ -1,3 +1,4 @@
+#include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/console.h>
 
diff -puN arch/um/drivers/ubd_kern.c~uml-get-declaration-of-simple_strtoul arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-get-declaration-of-simple_strtoul
+++ a/arch/um/drivers/ubd_kern.c
@@ -20,6 +20,7 @@
 #define MAJOR_NR UBD_MAJOR
 #define UBD_SHIFT 4
 
+#include "linux/kernel.h"
 #include "linux/module.h"
 #include "linux/blkdev.h"
 #include "linux/hdreg.h"
diff -puN arch/um/kernel/exitcode.c~uml-get-declaration-of-simple_strtoul arch/um/kernel/exitcode.c
--- a/arch/um/kernel/exitcode.c~uml-get-declaration-of-simple_strtoul
+++ a/arch/um/kernel/exitcode.c
@@ -1,8 +1,9 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
 
+#include "linux/kernel.h"
 #include "linux/init.h"
 #include "linux/ctype.h"
 #include "linux/proc_fs.h"
@@ -24,11 +25,14 @@ static int read_proc_exitcode(char *page
 	val = uml_exitcode;
 	len = sprintf(page, "%d\n", val);
 	len -= off;
-	if(len <= off+count) *eof = 1;
+	if(len <= off+count)
+		*eof = 1;
 	*start = page + off;
-	if(len > count) len = count;
-	if(len < 0) len = 0;
-	return(len);
+	if(len > count)
+		len = count;
+	if(len < 0)
+		len = 0;
+	return len;
 }
 
 static int write_proc_exitcode(struct file *file, const char __user *buffer,
@@ -38,12 +42,14 @@ static int write_proc_exitcode(struct fi
 	int tmp;
 
 	if(copy_from_user(buf, buffer, count))
-		return(-EFAULT);
+		return -EFAULT;
+
 	tmp = simple_strtol(buf, &end, 0);
 	if((*end != '\0') && !isspace(*end))
-		return(-EINVAL);
+		return -EINVAL;
+
 	uml_exitcode = tmp;
-	return(count);
+	return count;
 }
 
 static int make_proc_exitcode(void)
@@ -54,24 +60,13 @@ static int make_proc_exitcode(void)
 	if(ent == NULL){
 		printk(KERN_WARNING "make_proc_exitcode : Failed to register "
 		       "/proc/exitcode\n");
-		return(0);
+		return 0;
 	}
 
 	ent->read_proc = read_proc_exitcode;
 	ent->write_proc = write_proc_exitcode;
-	
-	return(0);
+
+	return 0;
 }
 
 __initcall(make_proc_exitcode);
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
uml-fix-request-sector-update.patch
