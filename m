From: akpm@linux-foundation.org
Subject: [merged] btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:32 -0700
Message-ID: <20120731184932.B8B211E007E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2GaStd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:33 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, chris.mason@oracle.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: use printk_get_level and printk_skip_level, add __printf, fix fallout
has been removed from the -mm tree.  Its filename was
     btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: btrfs: use printk_get_level and printk_skip_level, add __printf, fix fallout

Use the generic printk_get_level() to search a message for a kern_level. 
Add __printf to verify format and arguments.  Fix a few messages that had
mismatches in format and arguments.  Add #ifdef CONFIG_PRINTK blocks to
shrink the object size a bit when not using printk.

[akpm@linux-foundation.org: whitespace tweak]
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/ctree.h      |   13 ++++++++++++
 fs/btrfs/disk-io.c    |    2 -
 fs/btrfs/relocation.c |    2 -
 fs/btrfs/super.c      |   41 ++++++++++++++++++++++++++++++++++------
 4 files changed, 50 insertions(+), 8 deletions(-)

diff -puN fs/btrfs/ctree.h~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout
+++ a/fs/btrfs/ctree.h
@@ -3342,10 +3342,22 @@ ssize_t btrfs_listxattr(struct dentry *d
 /* super.c */
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+
+#ifdef CONFIG_PRINTK
+__printf(2, 3)
 void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...);
+#else
+static inline __printf(2, 3)
+void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
+{
+}
+#endif
+
+__printf(5, 6)
 void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		     unsigned int line, int errno, const char *fmt, ...);
 
+
 void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno);
@@ -3386,6 +3398,7 @@ do {								\
 			  (errno), fmt, ##args);		\
 } while (0)
 
+__printf(5, 6)
 void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 		   unsigned int line, int errno, const char *fmt, ...);
 
diff -puN fs/btrfs/disk-io.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout
+++ a/fs/btrfs/disk-io.c
@@ -1114,7 +1114,7 @@ void clean_tree_block(struct btrfs_trans
 				spin_unlock(&root->fs_info->delalloc_lock);
 				btrfs_panic(root->fs_info, -EOVERFLOW,
 					  "Can't clear %lu bytes from "
-					  " dirty_mdatadata_bytes (%lu)",
+					  " dirty_mdatadata_bytes (%llu)",
 					  buf->len,
 					  root->fs_info->dirty_metadata_bytes);
 			}
diff -puN fs/btrfs/relocation.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout fs/btrfs/relocation.c
--- a/fs/btrfs/relocation.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout
+++ a/fs/btrfs/relocation.c
@@ -1241,7 +1241,7 @@ static int __must_check __add_reloc_root
 	if (rb_node) {
 		btrfs_panic(root->fs_info, -EEXIST, "Duplicate root found "
 			    "for start=%llu while inserting into relocation "
-			    "tree\n");
+			    "tree\n", node->bytenr);
 		kfree(node);
 		return -EEXIST;
 	}
diff -puN fs/btrfs/super.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout fs/btrfs/super.c
--- a/fs/btrfs/super.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout
+++ a/fs/btrfs/super.c
@@ -125,6 +125,7 @@ static void btrfs_handle_error(struct bt
 	}
 }
 
+#ifdef CONFIG_PRINTK
 /*
  * __btrfs_std_error decodes expected errors from the caller and
  * invokes the approciate error response.
@@ -167,7 +168,7 @@ void __btrfs_std_error(struct btrfs_fs_i
 	va_end(args);
 }
 
-const char *logtypes[] = {
+static const char * const logtypes[] = {
 	"emergency",
 	"alert",
 	"critical",
@@ -185,22 +186,50 @@ void btrfs_printk(struct btrfs_fs_info *
 	struct va_format vaf;
 	va_list args;
 	const char *type = logtypes[4];
+	int kern_level;
 
 	va_start(args, fmt);
 
-	if (fmt[0] == '<' && isdigit(fmt[1]) && fmt[2] == '>') {
-		memcpy(lvl, fmt, 3);
-		lvl[3] = '\0';
-		fmt += 3;
-		type = logtypes[fmt[1] - '0'];
+	kern_level = printk_get_level(fmt);
+	if (kern_level) {
+		size_t size = printk_skip_level(fmt) - fmt;
+		memcpy(lvl, fmt,  size);
+		lvl[size] = '\0';
+		fmt += size;
+		type = logtypes[kern_level - '0'];
 	} else
 		*lvl = '\0';
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
+
 	printk("%sBTRFS %s (device %s): %pV", lvl, type, sb->s_id, &vaf);
+
+	va_end(args);
 }
 
+#else
+
+void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
+		       unsigned int line, int errno, const char *fmt, ...)
+{
+	struct super_block *sb = fs_info->sb;
+
+	/*
+	 * Special case: if the error is EROFS, and we're already
+	 * under MS_RDONLY, then it is safe here.
+	 */
+	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
+		return;
+
+	/* Don't go through full error handling during mount */
+	if (sb->s_flags & MS_BORN) {
+		save_error_info(fs_info);
+		btrfs_handle_error(fs_info);
+	}
+}
+#endif
+
 /*
  * We only mark the transaction aborted and then set the file system read-only.
  * This will prevent new transactions from starting or trying to join this
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch
linux-next.patch
thermal-add-renesas-r-car-thermal-sensor-support.patch

