From: akpm@osdl.org
Subject: + procfs-build-fix.patch added to -mm tree
Date: Wed, 13 Dec 2006 10:58:19 -0800
Message-ID: <200612131858.kBDIwLnC016250@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965071AbWLMS6Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 13:58:25 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kBDIwNID018932
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2006 10:58:23 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, torvalds@osdl.org


The patch titled
     procfs build fix
has been added to the -mm tree.  Its filename is
     procfs-build-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: procfs build fix
From: Andrew Morton <akpm@osdl.org>

Builds fail after mrproper because fs/procfs/proc_misc.c needs compile.h,
which hasn't been made yet.

Compile the new SLES code in init/version.c, after we've created compile.h.

Cc: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/proc_misc.c     |   18 ------------------
 include/linux/proc_fs.h |    3 +++
 2 files changed, 3 insertions(+), 18 deletions(-)

diff -puN fs/proc/proc_misc.c~procfs-build-fix fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~procfs-build-fix
+++ a/fs/proc/proc_misc.c
@@ -47,7 +47,6 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
-#include <linux/compile.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -249,23 +248,6 @@ static struct file_operations proc_zonei
 	.release	= seq_release,
 };
 
-static int version_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	int len;
-
-	/* FIXED STRING! Don't touch! */
-	len = snprintf(page, PAGE_SIZE,
-		"%s version %s"
-		" (" LINUX_COMPILE_BY "@" LINUX_COMPILE_HOST ")"
-		" (" LINUX_COMPILER ")"
-		" %s\n",
-		utsname()->sysname,
-		utsname()->release,
-		utsname()->version);
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-
 extern struct seq_operations cpuinfo_op;
 static int cpuinfo_open(struct inode *inode, struct file *file)
 {
diff -puN init/main.c~procfs-build-fix init/main.c
diff -puN include/linux/proc_fs.h~procfs-build-fix include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~procfs-build-fix
+++ a/include/linux/proc_fs.h
@@ -275,4 +275,7 @@ struct proc_maps_private {
 #endif
 };
 
+int version_read_proc(char *page, char **start, off_t off,
+				 int count, int *eof, void *data);
+
 #endif /* _LINUX_PROC_FS_H */
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
x86-smp-export-smp_num_siblings-for-oprofile.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support.patch
optimize-o_direct-on-block-device-v3.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
procfs-build-fix.patch

