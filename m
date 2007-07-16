From: akpm@linux-foundation.org
Subject: - hugetlbfs-use-lib-parser-fix-docs.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:17 -0700
Message-ID: <200707162056.l6GKuHNs002085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761540AbXGPV3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:29:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, agl@us.ibm.com, david@gibson.dropbear.id.au, hugh@veritas.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: use lib/parser, fix docs
has been removed from the -mm tree.  Its filename was
     hugetlbfs-use-lib-parser-fix-docs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlbfs: use lib/parser, fix docs
From: Randy Dunlap <randy.dunlap@oracle.com>

Use lib/parser.c to parse hugetlbfs mount options.  Correct docs in
hugetlbpage.txt.

old size of hugetlbfs_fill_super:  675 bytes
new size of hugetlbfs_fill_super:  686 bytes
(hugetlbfs_parse_options() is inlined)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Adam Litke <agl@us.ibm.com>
Acked-by: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hugetlbpage.txt |   10 +--
 fs/hugetlbfs/inode.c             |   94 ++++++++++++++++++++---------
 2 files changed, 73 insertions(+), 31 deletions(-)

diff -puN Documentation/vm/hugetlbpage.txt~hugetlbfs-use-lib-parser-fix-docs Documentation/vm/hugetlbpage.txt
--- a/Documentation/vm/hugetlbpage.txt~hugetlbfs-use-lib-parser-fix-docs
+++ a/Documentation/vm/hugetlbpage.txt
@@ -77,8 +77,9 @@ If the user applications are going to re
 call, then it is required that system administrator mount a file system of
 type hugetlbfs:
 
-	mount none /mnt/huge -t hugetlbfs <uid=value> <gid=value> <mode=value>
-		 <size=value> <nr_inodes=value>
+  mount -t hugetlbfs \
+	-o uid=<value>,gid=<value>,mode=<value>,size=<value>,nr_inodes=<value> \
+	none /mnt/huge
 
 This command mounts a (pseudo) filesystem of type hugetlbfs on the directory
 /mnt/huge.  Any files created on /mnt/huge uses hugepages.  The uid and gid
@@ -88,11 +89,10 @@ mode of root of file system to value & 0
 By default the value 0755 is picked. The size option sets the maximum value of
 memory (huge pages) allowed for that filesystem (/mnt/huge). The size is
 rounded down to HPAGE_SIZE.  The option nr_inodes sets the maximum number of
-inodes that /mnt/huge can use.  If the size or nr_inodes options are not
+inodes that /mnt/huge can use.  If the size or nr_inodes option is not
 provided on command line then no limits are set.  For size and nr_inodes
 options, you can use [G|g]/[M|m]/[K|k] to represent giga/mega/kilo. For
-example, size=2K has the same meaning as size=2048. An example is given at
-the end of this document.
+example, size=2K has the same meaning as size=2048.
 
 read and write system calls are not supported on files that reside on hugetlb
 file systems.
diff -puN fs/hugetlbfs/inode.c~hugetlbfs-use-lib-parser-fix-docs fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-use-lib-parser-fix-docs
+++ a/fs/hugetlbfs/inode.c
@@ -13,15 +13,18 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/file.h>
+#include <linux/kernel.h>
 #include <linux/writeback.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/capability.h>
+#include <linux/ctype.h>
 #include <linux/backing-dev.h>
 #include <linux/hugetlb.h>
 #include <linux/pagevec.h>
+#include <linux/parser.h>
 #include <linux/mman.h>
 #include <linux/quotaops.h>
 #include <linux/slab.h>
@@ -47,6 +50,21 @@ static struct backing_dev_info hugetlbfs
 
 int sysctl_hugetlb_shm_group;
 
+enum {
+	Opt_size, Opt_nr_inodes,
+	Opt_mode, Opt_uid, Opt_gid,
+	Opt_err,
+};
+
+static match_table_t tokens = {
+	{Opt_size,	"size=%s"},
+	{Opt_nr_inodes,	"nr_inodes=%s"},
+	{Opt_mode,	"mode=%o"},
+	{Opt_uid,	"uid=%u"},
+	{Opt_gid,	"gid=%u"},
+	{Opt_err,	NULL},
+};
+
 static void huge_pagevec_release(struct pagevec *pvec)
 {
 	int i;
@@ -594,46 +612,70 @@ static const struct super_operations hug
 static int
 hugetlbfs_parse_options(char *options, struct hugetlbfs_config *pconfig)
 {
-	char *opt, *value, *rest;
+	char *p, *rest;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
 
 	if (!options)
 		return 0;
-	while ((opt = strsep(&options, ",")) != NULL) {
-		if (!*opt)
-			continue;
 
-		value = strchr(opt, '=');
-		if (!value || !*value)
-			return -EINVAL;
-		else
-			*value++ = '\0';
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_uid:
+			if (match_int(&args[0], &option))
+ 				goto bad_val;
+			pconfig->uid = option;
+			break;
+
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+ 				goto bad_val;
+			pconfig->gid = option;
+			break;
+
+		case Opt_mode:
+			if (match_octal(&args[0], &option))
+ 				goto bad_val;
+			pconfig->mode = option & 0777U;
+			break;
 
-		if (!strcmp(opt, "uid"))
-			pconfig->uid = simple_strtoul(value, &value, 0);
-		else if (!strcmp(opt, "gid"))
-			pconfig->gid = simple_strtoul(value, &value, 0);
-		else if (!strcmp(opt, "mode"))
-			pconfig->mode = simple_strtoul(value,&value,0) & 0777U;
-		else if (!strcmp(opt, "size")) {
-			unsigned long long size = memparse(value, &rest);
+		case Opt_size: {
+ 			unsigned long long size;
+			/* memparse() will accept a K/M/G without a digit */
+			if (!isdigit(*args[0].from))
+				goto bad_val;
+			size = memparse(args[0].from, &rest);
 			if (*rest == '%') {
 				size <<= HPAGE_SHIFT;
 				size *= max_huge_pages;
 				do_div(size, 100);
-				rest++;
 			}
 			pconfig->nr_blocks = (size >> HPAGE_SHIFT);
-			value = rest;
-		} else if (!strcmp(opt,"nr_inodes")) {
-			pconfig->nr_inodes = memparse(value, &rest);
-			value = rest;
-		} else
-			return -EINVAL;
+			break;
+		}
 
-		if (*value)
-			return -EINVAL;
+		case Opt_nr_inodes:
+			/* memparse() will accept a K/M/G without a digit */
+			if (!isdigit(*args[0].from))
+				goto bad_val;
+			pconfig->nr_inodes = memparse(args[0].from, &rest);
+			break;
+
+		default:
+			printk(KERN_ERR "hugetlbfs: Bad mount option: %s\n", p);
+ 			return 1;
+			break;
+		}
 	}
 	return 0;
+
+bad_val:
+ 	printk(KERN_ERR "hugetlbfs: Bad value '%s' for mount option '%s'\n",
+	       args[0].from, p);
+ 	return 1;
 }
 
 static int
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
docbook-dont-reference-file-without-kernel-doc.patch
profile-likely-unlikely-macros.patch
