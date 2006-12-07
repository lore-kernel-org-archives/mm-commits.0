From: akpm@osdl.org
Subject: - hpfs-bring-hpfs_error-into-shape.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:44 -0800
Message-ID: <200612072303.kB7N3ia0029988@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163828AbWLGXDr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hpfs: bring hpfs_error() into shape
has been removed from the -mm tree.  Its filename was
     hpfs-bring-hpfs_error-into-shape.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hpfs: bring hpfs_error() into shape
From: Alexey Dobriyan <adobriyan@gmail.com>

*) switch to error message buffer in .bss
*) missing va_end() (htf it worked before?)
*) use vsnprintf()
*) rename variables to understandable "fmt", "args".
*) "const char *fmt", yes.
*) add __attribute__((format ...

Still, put that coffee down before reading more.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/hpfs/hpfs_fn.h |    3 ++-
 fs/hpfs/super.c   |   23 +++++++++--------------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff -puN fs/hpfs/hpfs_fn.h~hpfs-bring-hpfs_error-into-shape fs/hpfs/hpfs_fn.h
--- a/fs/hpfs/hpfs_fn.h~hpfs-bring-hpfs_error-into-shape
+++ a/fs/hpfs/hpfs_fn.h
@@ -317,7 +317,8 @@ static inline struct hpfs_sb_info *hpfs_
 
 /* super.c */
 
-void hpfs_error(struct super_block *, char *, ...);
+void hpfs_error(struct super_block *, const char *, ...)
+	__attribute__((format (printf, 2, 3)));
 int hpfs_stop_cycles(struct super_block *, int, int *, int *, char *);
 unsigned hpfs_count_one_bitmap(struct super_block *, secno);
 
diff -puN fs/hpfs/super.c~hpfs-bring-hpfs_error-into-shape fs/hpfs/super.c
--- a/fs/hpfs/super.c~hpfs-bring-hpfs_error-into-shape
+++ a/fs/hpfs/super.c
@@ -46,21 +46,17 @@ static void unmark_dirty(struct super_bl
 }
 
 /* Filesystem error... */
+static char err_buf[1024];
 
-#define ERR_BUF_SIZE 1024
-
-void hpfs_error(struct super_block *s, char *m,...)
+void hpfs_error(struct super_block *s, const char *fmt, ...)
 {
-	char *buf;
-	va_list l;
-	va_start(l, m);
-	if (!(buf = kmalloc(ERR_BUF_SIZE, GFP_KERNEL)))
-		printk("HPFS: No memory for error message '%s'\n",m);
-	else if (vsprintf(buf, m, l) >= ERR_BUF_SIZE)
-		printk("HPFS: Grrrr... Kernel memory corrupted ... going on, but it'll crash very soon :-(\n");
-	printk("HPFS: filesystem error: ");
-	if (buf) printk("%s", buf);
-	else printk("%s\n",m);
+	va_list args;
+
+	va_start(args, fmt);
+	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
+	va_end(args);
+
+	printk("HPFS: filesystem error: %s", err_buf);
 	if (!hpfs_sb(s)->sb_was_error) {
 		if (hpfs_sb(s)->sb_err == 2) {
 			printk("; crashing the system because you wanted it\n");
@@ -76,7 +72,6 @@ void hpfs_error(struct super_block *s, c
 		} else if (s->s_flags & MS_RDONLY) printk("; going on - but anything won't be destroyed because it's read-only\n");
 		else printk("; corrupted filesystem mounted read/write - your computer will explode within 20 seconds ... but you wanted it so!\n");
 	} else printk("\n");
-	kfree(buf);
 	hpfs_sb(s)->sb_was_error = 1;
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-cpufreq.patch
git-ieee1394.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-isdn-trivial-vsnprintf-conversion.patch
drivers-video-use-kmemdup.patch

