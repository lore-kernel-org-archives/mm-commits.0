From: akpm@linux-foundation.org
Subject: - include-linux-fsh-put-declarations-in-__kernel__.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:10 -0800
Message-ID: <200901050641.n056fAg4005152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbZAEGlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@medozas.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     include: linux/fs.h: put declarations in __KERNEL__
has been removed from the -mm tree.  Its filename was
     include-linux-fsh-put-declarations-in-__kernel__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include: linux/fs.h: put declarations in __KERNEL__
From: Jan Engelhardt <jengelh@medozas.de>

An anonymous user tried to use symbols from /usr/include/linux/fs.h.
Since these however are not defined in libc, but are specific to the
kernel, they should be in an #ifdef __KERNEL__ section. Move them
there.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/fs.h~include-linux-fsh-put-declarations-in-__kernel__ include/linux/fs.h
--- a/include/linux/fs.h~include-linux-fsh-put-declarations-in-__kernel__
+++ a/include/linux/fs.h
@@ -21,7 +21,6 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-extern int sysctl_nr_open;
 #define INR_OPEN 1024		/* Initial setting for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
@@ -38,21 +37,13 @@ struct files_stat_struct {
 	int nr_free_files;	/* read only */
 	int max_files;		/* tunable */
 };
-extern struct files_stat_struct files_stat;
-extern int get_max_files(void);
 
 struct inodes_stat_t {
 	int nr_inodes;
 	int nr_unused;
 	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
-extern struct inodes_stat_t inodes_stat;
 
-extern int leases_enable, lease_break_time;
-
-#ifdef CONFIG_DNOTIFY
-extern int dir_notify_enable;
-#endif
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
@@ -321,6 +312,15 @@ extern void __init inode_init(void);
 extern void __init inode_init_early(void);
 extern void __init files_init(unsigned long);
 
+extern struct files_stat_struct files_stat;
+extern int get_max_files(void);
+extern int sysctl_nr_open;
+extern struct inodes_stat_t inodes_stat;
+extern int leases_enable, lease_break_time;
+#ifdef CONFIG_DNOTIFY
+extern int dir_notify_enable;
+#endif
+
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create);
_

Patches currently in -mm which might be from jengelh@medozas.de are

origin.patch

