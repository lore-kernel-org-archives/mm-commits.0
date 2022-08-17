Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A9AC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 20:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbiHQU6P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 16:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242130AbiHQU51 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 16:57:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25956A99DE
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 13:57:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F966B81F6A
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 20:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EB2C433C1;
        Wed, 17 Aug 2022 20:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769836;
        bh=wdV5QUQQPEWYlWXnWxbklugSbDEVIU8sTkJdqICH4Rk=;
        h=Date:To:From:Subject:From;
        b=PUAApSmkPKiqkAl32wW87Pf/Uh/GMIkYT1a+DKxy5Dp92J/Io8ar0hIodRKzhTbFN
         +8wmWiNlI/pDCq8Dux/BOCJ1hwIH/UD2jIgIycMAM5jU3EsluuKXwkjwXmsGupARUO
         aoeaRvQ70wKz8uc8Om1UGnwXu60K/FGAw/mybE4k=
Date:   Wed, 17 Aug 2022 13:57:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        rburny@google.com, djwong@kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-fix-chattr-fsflags-support-in-tmpfs.patch removed from -mm tree
Message-Id: <20220817205715.F0EB2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: fix chattr fsflags support in tmpfs
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-chattr-fsflags-support-in-tmpfs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: fix chattr fsflags support in tmpfs
Date: Wed, 10 Aug 2022 21:51:09 -0700 (PDT)

ext[234] have always allowed unimplemented chattr flags to be set, but
other filesystems have tended to be stricter.  Follow the stricter
approach for tmpfs: I don't want to have to explain why csu attributes
don't actually work, and we won't need to update the chattr(1) manpage;
and it's never wrong to start off strict, relaxing later if persuaded. 
Allow only a (append only) i (immutable) A (no atime) and d (no dump).

Although lsattr showed 'A' inherited, the NOATIME behavior was not being
inherited: because nothing sync'ed FS_NOATIME_FL to S_NOATIME.  Add
shmem_set_inode_flags() to sync the flags, using inode_set_flags() to
avoid that instant of lost immutablility during fileattr_set().

But that change switched generic/079 from passing to failing: because
FS_IMMUTABLE_FL and FS_APPEND_FL had been unconventionally included in the
INHERITED fsflags: remove them and generic/079 is back to passing.

Link: https://lkml.kernel.org/r/2961dcb0-ddf3-b9f0-3268-12a4ff996856@google.com
Fixes: e408e695f5f1 ("mm/shmem: support FS_IOC_[SG]ETFLAGS in tmpfs")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Radoslaw Burny <rburny@google.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   13 ++------
 mm/shmem.c               |   54 +++++++++++++++++++++----------------
 2 files changed, 35 insertions(+), 32 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-fix-chattr-fsflags-support-in-tmpfs
+++ a/include/linux/shmem_fs.h
@@ -29,15 +29,10 @@ struct shmem_inode_info {
 	struct inode		vfs_inode;
 };
 
-#define SHMEM_FL_USER_VISIBLE FS_FL_USER_VISIBLE
-#define SHMEM_FL_USER_MODIFIABLE FS_FL_USER_MODIFIABLE
-#define SHMEM_FL_INHERITED FS_FL_USER_MODIFIABLE
-
-/* Flags that are appropriate for regular files (all but dir-specific ones). */
-#define SHMEM_REG_FLMASK (~(FS_DIRSYNC_FL | FS_TOPDIR_FL))
-
-/* Flags that are appropriate for non-directories/regular files. */
-#define SHMEM_OTHER_FLMASK (FS_NODUMP_FL | FS_NOATIME_FL)
+#define SHMEM_FL_USER_VISIBLE		FS_FL_USER_VISIBLE
+#define SHMEM_FL_USER_MODIFIABLE \
+	(FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL | FS_NOATIME_FL)
+#define SHMEM_FL_INHERITED		(FS_NODUMP_FL | FS_NOATIME_FL)
 
 struct shmem_sb_info {
 	unsigned long max_blocks;   /* How many blocks are allowed */
--- a/mm/shmem.c~mm-shmem-fix-chattr-fsflags-support-in-tmpfs
+++ a/mm/shmem.c
@@ -2281,16 +2281,34 @@ static int shmem_mmap(struct file *file,
 	return 0;
 }
 
-/* Mask out flags that are inappropriate for the given type of inode. */
-static unsigned shmem_mask_flags(umode_t mode, __u32 flags)
+#ifdef CONFIG_TMPFS_XATTR
+static int shmem_initxattrs(struct inode *, const struct xattr *, void *);
+
+/*
+ * chattr's fsflags are unrelated to extended attributes,
+ * but tmpfs has chosen to enable them under the same config option.
+ */
+static void shmem_set_inode_flags(struct inode *inode, unsigned int fsflags)
+{
+	unsigned int i_flags = 0;
+
+	if (fsflags & FS_NOATIME_FL)
+		i_flags |= S_NOATIME;
+	if (fsflags & FS_APPEND_FL)
+		i_flags |= S_APPEND;
+	if (fsflags & FS_IMMUTABLE_FL)
+		i_flags |= S_IMMUTABLE;
+	/*
+	 * But FS_NODUMP_FL does not require any action in i_flags.
+	 */
+	inode_set_flags(inode, i_flags, S_NOATIME | S_APPEND | S_IMMUTABLE);
+}
+#else
+static void shmem_set_inode_flags(struct inode *inode, unsigned int fsflags)
 {
-	if (S_ISDIR(mode))
-		return flags;
-	else if (S_ISREG(mode))
-		return flags & SHMEM_REG_FLMASK;
-	else
-		return flags & SHMEM_OTHER_FLMASK;
 }
+#define shmem_initxattrs NULL
+#endif
 
 static struct inode *shmem_get_inode(struct super_block *sb, struct inode *dir,
 				     umode_t mode, dev_t dev, unsigned long flags)
@@ -2319,7 +2337,8 @@ static struct inode *shmem_get_inode(str
 		info->i_crtime = inode->i_mtime;
 		info->fsflags = (dir == NULL) ? 0 :
 			SHMEM_I(dir)->fsflags & SHMEM_FL_INHERITED;
-		info->fsflags = shmem_mask_flags(mode, info->fsflags);
+		if (info->fsflags)
+			shmem_set_inode_flags(inode, info->fsflags);
 		INIT_LIST_HEAD(&info->shrinklist);
 		INIT_LIST_HEAD(&info->swaplist);
 		simple_xattrs_init(&info->xattrs);
@@ -2468,12 +2487,6 @@ out_unacct_blocks:
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_short_symlink_operations;
 
-#ifdef CONFIG_TMPFS_XATTR
-static int shmem_initxattrs(struct inode *, const struct xattr *, void *);
-#else
-#define shmem_initxattrs NULL
-#endif
-
 static int
 shmem_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len,
@@ -3179,18 +3192,13 @@ static int shmem_fileattr_set(struct use
 
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
+	if (fa->flags & ~SHMEM_FL_USER_MODIFIABLE)
+		return -EOPNOTSUPP;
 
 	info->fsflags = (info->fsflags & ~SHMEM_FL_USER_MODIFIABLE) |
 		(fa->flags & SHMEM_FL_USER_MODIFIABLE);
 
-	inode->i_flags &= ~(S_APPEND | S_IMMUTABLE | S_NOATIME);
-	if (info->fsflags & FS_APPEND_FL)
-		inode->i_flags |= S_APPEND;
-	if (info->fsflags & FS_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
-	if (info->fsflags & FS_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
-
+	shmem_set_inode_flags(inode, info->fsflags);
 	inode->i_ctime = current_time(inode);
 	return 0;
 }
_

Patches currently in -mm which might be from hughd@google.com are


