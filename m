From: akpm@linux-foundation.org
Subject: + btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch added to -mm tree
Date: Wed, 06 Jun 2012 14:45:15 -0700
Message-ID: <20120606214516.008D3A02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52214 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab2FFVpR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 17:45:17 -0400
Received: by qabg24 with SMTP id g24so11515qab.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 14:45:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, chris.mason@oracle.com, kay.sievers@vrfy.org


The patch titled
     Subject: btrfs: use printk_get_level and printk_skip_level, add __printf, fix fallout
has been added to the -mm tree.  Its filename is
     btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: btrfs: use printk_get_level and printk_skip_level, add __printf, fix fallout

Use the generic printk_get_level() to search a message for a kern_level. 
Add __printf to verify format and arguments.  Fix a few messages that had
mismatches in format and arguments.  Add #ifdef CONFIG_PRINTK blocks to
shrink the object size a bit when not using printk.

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
@@ -3046,10 +3046,22 @@ ssize_t btrfs_listxattr(struct dentry *d
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
@@ -3073,6 +3085,7 @@ do {								\
 			  (errno), fmt, ##args);		\
 } while (0)
 
+__printf(5, 6)
 void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 		   unsigned int line, int errno, const char *fmt, ...);
 
diff -puN fs/btrfs/disk-io.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout
+++ a/fs/btrfs/disk-io.c
@@ -1113,7 +1113,7 @@ void clean_tree_block(struct btrfs_trans
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
@@ -1242,7 +1242,7 @@ static int __must_check __add_reloc_root
 		kfree(node);
 		btrfs_panic(root->fs_info, -EEXIST, "Duplicate root found "
 			    "for start=%llu while inserting into relocation "
-			    "tree\n");
+			    "tree\n", node->bytenr);
 	}
 
 	list_add_tail(&root->root_list, &rc->reloc_roots);
diff -puN fs/btrfs/super.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout fs/btrfs/super.c
--- a/fs/btrfs/super.c~btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout
+++ a/fs/btrfs/super.c
@@ -124,6 +124,7 @@ static void btrfs_handle_error(struct bt
 	}
 }
 
+#ifdef CONFIG_PRINTK
 /*
  * __btrfs_std_error decodes expected errors from the caller and
  * invokes the approciate error response.
@@ -166,7 +167,7 @@ void __btrfs_std_error(struct btrfs_fs_i
 	va_end(args);
 }
 
-const char *logtypes[] = {
+static const char *logtypes[] = {
 	"emergency",
 	"alert",
 	"critical",
@@ -184,22 +185,50 @@ void btrfs_printk(struct btrfs_fs_info *
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
+		size_t size = printk_skip_level(fmt)  - fmt;
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
Subject: Subject: btrfs: use printk_get_level and printk_skip_level, add __printf, fix fallout

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-whitespace-fixes.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
sound-use-printk_get_level-and-printk_skip_level.patch
staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch

