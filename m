From: akpm@linux-foundation.org
Subject: + quota-move-quotaio_vh-from-include-linux-to-fs.patch added to -mm tree
Date: Mon, 27 Oct 2008 22:56:15 -0700
Message-ID: <200810280556.m9S5uFAt013481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbYJ1GA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     quota: move quotaio_v[12].h from include/linux/ to fs/
has been added to the -mm tree.  Its filename is
     quota-move-quotaio_vh-from-include-linux-to-fs.patch

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
Subject: quota: move quotaio_v[12].h from include/linux/ to fs/
From: Jan Kara <jack@suse.cz>

Since these include files are used only by implementation of quota
formats, there's no need to have them in include/linux/.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota_v1.c              |    3 -
 fs/quota_v2.c              |    7 +--
 fs/quotaio_v1.h            |   33 ++++++++++++++
 fs/quotaio_v2.h            |   79 +++++++++++++++++++++++++++++++++++
 include/linux/quotaio_v1.h |   33 --------------
 include/linux/quotaio_v2.h |   79 -----------------------------------
 6 files changed, 118 insertions(+), 116 deletions(-)

diff -puN fs/quota_v1.c~quota-move-quotaio_vh-from-include-linux-to-fs fs/quota_v1.c
--- a/fs/quota_v1.c~quota-move-quotaio_vh-from-include-linux-to-fs
+++ a/fs/quota_v1.c
@@ -3,13 +3,14 @@
 #include <linux/quota.h>
 #include <linux/quotaops.h>
 #include <linux/dqblk_v1.h>
-#include <linux/quotaio_v1.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
 
 #include <asm/byteorder.h>
 
+#include "quotaio_v1.h"
+
 MODULE_AUTHOR("Jan Kara");
 MODULE_DESCRIPTION("Old quota format support");
 MODULE_LICENSE("GPL");
diff -puN fs/quota_v2.c~quota-move-quotaio_vh-from-include-linux-to-fs fs/quota_v2.c
--- a/fs/quota_v2.c~quota-move-quotaio_vh-from-include-linux-to-fs
+++ a/fs/quota_v2.c
@@ -6,7 +6,6 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/dqblk_v2.h>
-#include <linux/quotaio_v2.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -15,6 +14,8 @@
 
 #include <asm/byteorder.h>
 
+#include "quotaio_v2.h"
+
 MODULE_AUTHOR("Jan Kara");
 MODULE_DESCRIPTION("Quota format v2 support");
 MODULE_LICENSE("GPL");
@@ -129,8 +130,8 @@ static void mem2diskdqb(struct v2_disk_d
 	d->dqb_isoftlimit = cpu_to_le32(m->dqb_isoftlimit);
 	d->dqb_curinodes = cpu_to_le32(m->dqb_curinodes);
 	d->dqb_itime = cpu_to_le64(m->dqb_itime);
-	d->dqb_bhardlimit = cpu_to_le32(v2_qbtos(m->dqb_bhardlimit));
-	d->dqb_bsoftlimit = cpu_to_le32(v2_qbtos(m->dqb_bsoftlimit));
+	d->dqb_bhardlimit = cpu_to_le32(v2_stoqb(m->dqb_bhardlimit));
+	d->dqb_bsoftlimit = cpu_to_le32(v2_stoqb(m->dqb_bsoftlimit));
 	d->dqb_curspace = cpu_to_le64(m->dqb_curspace);
 	d->dqb_btime = cpu_to_le64(m->dqb_btime);
 	d->dqb_id = cpu_to_le32(id);
diff -puN /dev/null fs/quotaio_v1.h
--- /dev/null
+++ a/fs/quotaio_v1.h
@@ -0,0 +1,33 @@
+#ifndef _LINUX_QUOTAIO_V1_H
+#define _LINUX_QUOTAIO_V1_H
+
+#include <linux/types.h>
+
+/*
+ * The following constants define the amount of time given a user
+ * before the soft limits are treated as hard limits (usually resulting
+ * in an allocation failure). The timer is started when the user crosses
+ * their soft limit, it is reset when they go below their soft limit.
+ */
+#define MAX_IQ_TIME  604800	/* (7*24*60*60) 1 week */
+#define MAX_DQ_TIME  604800	/* (7*24*60*60) 1 week */
+
+/*
+ * The following structure defines the format of the disk quota file
+ * (as it appears on disk) - the file is an array of these structures
+ * indexed by user or group number.
+ */
+struct v1_disk_dqblk {
+	__u32 dqb_bhardlimit;	/* absolute limit on disk blks alloc */
+	__u32 dqb_bsoftlimit;	/* preferred limit on disk blks */
+	__u32 dqb_curblocks;	/* current block count */
+	__u32 dqb_ihardlimit;	/* absolute limit on allocated inodes */
+	__u32 dqb_isoftlimit;	/* preferred inode limit */
+	__u32 dqb_curinodes;	/* current # allocated inodes */
+	time_t dqb_btime;	/* time limit for excessive disk use */
+	time_t dqb_itime;	/* time limit for excessive inode use */
+};
+
+#define v1_dqoff(UID)      ((loff_t)((UID) * sizeof (struct v1_disk_dqblk)))
+
+#endif	/* _LINUX_QUOTAIO_V1_H */
diff -puN /dev/null fs/quotaio_v2.h
--- /dev/null
+++ a/fs/quotaio_v2.h
@@ -0,0 +1,79 @@
+/*
+ *	Definitions of structures for vfsv0 quota format
+ */
+
+#ifndef _LINUX_QUOTAIO_V2_H
+#define _LINUX_QUOTAIO_V2_H
+
+#include <linux/types.h>
+#include <linux/quota.h>
+
+/*
+ * Definitions of magics and versions of current quota files
+ */
+#define V2_INITQMAGICS {\
+	0xd9c01f11,	/* USRQUOTA */\
+	0xd9c01927	/* GRPQUOTA */\
+}
+
+#define V2_INITQVERSIONS {\
+	0,		/* USRQUOTA */\
+	0		/* GRPQUOTA */\
+}
+
+/*
+ * The following structure defines the format of the disk quota file
+ * (as it appears on disk) - the file is a radix tree whose leaves point
+ * to blocks of these structures.
+ */
+struct v2_disk_dqblk {
+	__le32 dqb_id;		/* id this quota applies to */
+	__le32 dqb_ihardlimit;	/* absolute limit on allocated inodes */
+	__le32 dqb_isoftlimit;	/* preferred inode limit */
+	__le32 dqb_curinodes;	/* current # allocated inodes */
+	__le32 dqb_bhardlimit;	/* absolute limit on disk space (in QUOTABLOCK_SIZE) */
+	__le32 dqb_bsoftlimit;	/* preferred limit on disk space (in QUOTABLOCK_SIZE) */
+	__le64 dqb_curspace;	/* current space occupied (in bytes) */
+	__le64 dqb_btime;	/* time limit for excessive disk use */
+	__le64 dqb_itime;	/* time limit for excessive inode use */
+};
+
+/*
+ * Here are header structures as written on disk and their in-memory copies
+ */
+/* First generic header */
+struct v2_disk_dqheader {
+	__le32 dqh_magic;	/* Magic number identifying file */
+	__le32 dqh_version;	/* File version */
+};
+
+/* Header with type and version specific information */
+struct v2_disk_dqinfo {
+	__le32 dqi_bgrace;	/* Time before block soft limit becomes hard limit */
+	__le32 dqi_igrace;	/* Time before inode soft limit becomes hard limit */
+	__le32 dqi_flags;	/* Flags for quotafile (DQF_*) */
+	__le32 dqi_blocks;	/* Number of blocks in file */
+	__le32 dqi_free_blk;	/* Number of first free block in the list */
+	__le32 dqi_free_entry;	/* Number of block with at least one free entry */
+};
+
+/*
+ *  Structure of header of block with quota structures. It is padded to 16 bytes so
+ *  there will be space for exactly 21 quota-entries in a block
+ */
+struct v2_disk_dqdbheader {
+	__le32 dqdh_next_free;	/* Number of next block with free entry */
+	__le32 dqdh_prev_free;	/* Number of previous block with free entry */
+	__le16 dqdh_entries;	/* Number of valid entries in block */
+	__le16 dqdh_pad1;
+	__le32 dqdh_pad2;
+};
+
+#define V2_DQINFOOFF	sizeof(struct v2_disk_dqheader)	/* Offset of info header in file */
+#define V2_DQBLKSIZE_BITS	10
+#define V2_DQBLKSIZE	(1 << V2_DQBLKSIZE_BITS)	/* Size of block with quota structures */
+#define V2_DQTREEOFF	1		/* Offset of tree in file in blocks */
+#define V2_DQTREEDEPTH	4		/* Depth of quota tree */
+#define V2_DQSTRINBLK	((V2_DQBLKSIZE - sizeof(struct v2_disk_dqdbheader)) / sizeof(struct v2_disk_dqblk))	/* Number of entries in one blocks */
+
+#endif /* _LINUX_QUOTAIO_V2_H */
diff -puN include/linux/quotaio_v1.h~quota-move-quotaio_vh-from-include-linux-to-fs /dev/null
--- a/include/linux/quotaio_v1.h
+++ /dev/null
@@ -1,33 +0,0 @@
-#ifndef _LINUX_QUOTAIO_V1_H
-#define _LINUX_QUOTAIO_V1_H
-
-#include <linux/types.h>
-
-/*
- * The following constants define the amount of time given a user
- * before the soft limits are treated as hard limits (usually resulting
- * in an allocation failure). The timer is started when the user crosses
- * their soft limit, it is reset when they go below their soft limit.
- */
-#define MAX_IQ_TIME  604800	/* (7*24*60*60) 1 week */
-#define MAX_DQ_TIME  604800	/* (7*24*60*60) 1 week */
-
-/*
- * The following structure defines the format of the disk quota file
- * (as it appears on disk) - the file is an array of these structures
- * indexed by user or group number.
- */
-struct v1_disk_dqblk {
-	__u32 dqb_bhardlimit;	/* absolute limit on disk blks alloc */
-	__u32 dqb_bsoftlimit;	/* preferred limit on disk blks */
-	__u32 dqb_curblocks;	/* current block count */
-	__u32 dqb_ihardlimit;	/* absolute limit on allocated inodes */
-	__u32 dqb_isoftlimit;	/* preferred inode limit */
-	__u32 dqb_curinodes;	/* current # allocated inodes */
-	time_t dqb_btime;	/* time limit for excessive disk use */
-	time_t dqb_itime;	/* time limit for excessive inode use */
-};
-
-#define v1_dqoff(UID)      ((loff_t)((UID) * sizeof (struct v1_disk_dqblk)))
-
-#endif	/* _LINUX_QUOTAIO_V1_H */
diff -puN include/linux/quotaio_v2.h~quota-move-quotaio_vh-from-include-linux-to-fs /dev/null
--- a/include/linux/quotaio_v2.h
+++ /dev/null
@@ -1,79 +0,0 @@
-/*
- *	Definitions of structures for vfsv0 quota format
- */
-
-#ifndef _LINUX_QUOTAIO_V2_H
-#define _LINUX_QUOTAIO_V2_H
-
-#include <linux/types.h>
-#include <linux/quota.h>
-
-/*
- * Definitions of magics and versions of current quota files
- */
-#define V2_INITQMAGICS {\
-	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
-}
-
-#define V2_INITQVERSIONS {\
-	0,		/* USRQUOTA */\
-	0		/* GRPQUOTA */\
-}
-
-/*
- * The following structure defines the format of the disk quota file
- * (as it appears on disk) - the file is a radix tree whose leaves point
- * to blocks of these structures.
- */
-struct v2_disk_dqblk {
-	__le32 dqb_id;		/* id this quota applies to */
-	__le32 dqb_ihardlimit;	/* absolute limit on allocated inodes */
-	__le32 dqb_isoftlimit;	/* preferred inode limit */
-	__le32 dqb_curinodes;	/* current # allocated inodes */
-	__le32 dqb_bhardlimit;	/* absolute limit on disk space (in QUOTABLOCK_SIZE) */
-	__le32 dqb_bsoftlimit;	/* preferred limit on disk space (in QUOTABLOCK_SIZE) */
-	__le64 dqb_curspace;	/* current space occupied (in bytes) */
-	__le64 dqb_btime;	/* time limit for excessive disk use */
-	__le64 dqb_itime;	/* time limit for excessive inode use */
-};
-
-/*
- * Here are header structures as written on disk and their in-memory copies
- */
-/* First generic header */
-struct v2_disk_dqheader {
-	__le32 dqh_magic;	/* Magic number identifying file */
-	__le32 dqh_version;	/* File version */
-};
-
-/* Header with type and version specific information */
-struct v2_disk_dqinfo {
-	__le32 dqi_bgrace;	/* Time before block soft limit becomes hard limit */
-	__le32 dqi_igrace;	/* Time before inode soft limit becomes hard limit */
-	__le32 dqi_flags;	/* Flags for quotafile (DQF_*) */
-	__le32 dqi_blocks;	/* Number of blocks in file */
-	__le32 dqi_free_blk;	/* Number of first free block in the list */
-	__le32 dqi_free_entry;	/* Number of block with at least one free entry */
-};
-
-/*
- *  Structure of header of block with quota structures. It is padded to 16 bytes so
- *  there will be space for exactly 21 quota-entries in a block
- */
-struct v2_disk_dqdbheader {
-	__le32 dqdh_next_free;	/* Number of next block with free entry */
-	__le32 dqdh_prev_free;	/* Number of previous block with free entry */
-	__le16 dqdh_entries;	/* Number of valid entries in block */
-	__le16 dqdh_pad1;
-	__le32 dqdh_pad2;
-};
-
-#define V2_DQINFOOFF	sizeof(struct v2_disk_dqheader)	/* Offset of info header in file */
-#define V2_DQBLKSIZE_BITS	10
-#define V2_DQBLKSIZE	(1 << V2_DQBLKSIZE_BITS)	/* Size of block with quota structures */
-#define V2_DQTREEOFF	1		/* Offset of tree in file in blocks */
-#define V2_DQTREEDEPTH	4		/* Depth of quota tree */
-#define V2_DQSTRINBLK	((V2_DQBLKSIZE - sizeof(struct v2_disk_dqdbheader)) / sizeof(struct v2_disk_dqblk))	/* Number of entries in one blocks */
