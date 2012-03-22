From: akpm@linux-foundation.org
Subject: [merged] hugetlb-cleanup-hugetlbh.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:59 -0700
Message-ID: <20120322201859.B4855A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:49633 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759235Ab2CVUTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:01 -0400
Received: by vcbfk26 with SMTP id fk26so402291vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@gibson.dropbear.id.au, abarry@cray.com, dhillf@gmail.com, hughd@google.com, mgorman@suse.de, minchan.kim@gmail.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: cleanup hugetlb.h
has been removed from the -mm tree.  Its filename was
     hugetlb-cleanup-hugetlbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Gibson <david@gibson.dropbear.id.au>
Subject: hugetlb: cleanup hugetlb.h

Make a couple of small cleanups to linux/include/hugetlb.h.  The
set_file_hugepages() function, which was not used anywhere is removed, and
the hugetlbfs_config and hugetlbfs_inode_info structures with its
HUGETLBFS_I helper function are moved into inode.c, the only place they
were used.

These structures are really linked to the hugetlbfs filesystem
specifically not to hugepage mm handling in general, so they belong in the
filesystem code not in a generally available header.  It would be nice to
move the hugetlbfs_sb_info (superblock) structure in there as well, but
it's currently needed in a number of places via the hstate_vma() and
hstate_inode().

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Cc: Hugh Dickins <hughd@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Andrew Barry <abarry@cray.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   19 +++++++++++++++++++
 include/linux/hugetlb.h |   25 -------------------------
 2 files changed, 19 insertions(+), 25 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-cleanup-hugetlbh fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-cleanup-hugetlbh
+++ a/fs/hugetlbfs/inode.c
@@ -41,6 +41,25 @@ const struct file_operations hugetlbfs_f
 static const struct inode_operations hugetlbfs_dir_inode_operations;
 static const struct inode_operations hugetlbfs_inode_operations;
 
+struct hugetlbfs_config {
+	uid_t   uid;
+	gid_t   gid;
+	umode_t mode;
+	long	nr_blocks;
+	long	nr_inodes;
+	struct hstate *hstate;
+};
+
+struct hugetlbfs_inode_info {
+	struct shared_policy policy;
+	struct inode vfs_inode;
+};
+
+static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
+{
+	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
+}
+
 static struct backing_dev_info hugetlbfs_backing_dev_info = {
 	.name		= "hugetlbfs",
 	.ra_pages	= 0,	/* No readahead */
diff -puN include/linux/hugetlb.h~hugetlb-cleanup-hugetlbh include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-cleanup-hugetlbh
+++ a/include/linux/hugetlb.h
@@ -128,15 +128,6 @@ enum {
 };
 
 #ifdef CONFIG_HUGETLBFS
-struct hugetlbfs_config {
-	uid_t   uid;
-	gid_t   gid;
-	umode_t mode;
-	long	nr_blocks;
-	long	nr_inodes;
-	struct hstate *hstate;
-};
-
 struct hugetlbfs_sb_info {
 	long	max_blocks;   /* blocks allowed */
 	long	free_blocks;  /* blocks free */
@@ -146,17 +137,6 @@ struct hugetlbfs_sb_info {
 	struct hstate *hstate;
 };
 
-
-struct hugetlbfs_inode_info {
-	struct shared_policy policy;
-	struct inode vfs_inode;
-};
-
-static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
-{
-	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
-}
-
 static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
@@ -179,14 +159,9 @@ static inline int is_file_hugepages(stru
 	return 0;
 }
 
-static inline void set_file_hugepages(struct file *file)
-{
-	file->f_op = &hugetlbfs_file_operations;
-}
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			0
-#define set_file_hugepages(file)		BUG()
 static inline struct file *hugetlb_file_setup(const char *name, size_t size,
 		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
 {
_

Patches currently in -mm which might be from david@gibson.dropbear.id.au are

origin.patch
linux-next.patch

