From: akpm@linux-foundation.org
Subject: + const-make-struct-super_block-dq_op-const.patch added to -mm tree
Date: Fri, 11 Sep 2009 13:27:11 -0700
Message-ID: <200909112027.n8BKRBvZ018419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbZIKU1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 16:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     const: make struct super_block::dq_op const
has been added to the -mm tree.  Its filename is
     const-make-struct-super_block-dq_op-const.patch

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
Subject: const: make struct super_block::dq_op const
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c          |    2 +-
 fs/ext4/super.c          |    2 +-
 fs/ocfs2/quota.h         |    2 +-
 fs/ocfs2/quota_global.c  |    2 +-
 fs/quota/dquot.c         |    2 +-
 fs/reiserfs/super.c      |    2 +-
 include/linux/fs.h       |    2 +-
 include/linux/quotaops.h |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ext3/super.c~const-make-struct-super_block-dq_op-const fs/ext3/super.c
--- a/fs/ext3/super.c~const-make-struct-super_block-dq_op-const
+++ a/fs/ext3/super.c
@@ -720,7 +720,7 @@ static ssize_t ext3_quota_read(struct su
 static ssize_t ext3_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
 
-static struct dquot_operations ext3_quota_operations = {
+static const struct dquot_operations ext3_quota_operations = {
 	.initialize	= dquot_initialize,
 	.drop		= dquot_drop,
 	.alloc_space	= dquot_alloc_space,
diff -puN fs/ext4/super.c~const-make-struct-super_block-dq_op-const fs/ext4/super.c
--- a/fs/ext4/super.c~const-make-struct-super_block-dq_op-const
+++ a/fs/ext4/super.c
@@ -977,7 +977,7 @@ static ssize_t ext4_quota_read(struct su
 static ssize_t ext4_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
 
-static struct dquot_operations ext4_quota_operations = {
+static const struct dquot_operations ext4_quota_operations = {
 	.initialize	= dquot_initialize,
 	.drop		= dquot_drop,
 	.alloc_space	= dquot_alloc_space,
diff -puN fs/ocfs2/quota.h~const-make-struct-super_block-dq_op-const fs/ocfs2/quota.h
--- a/fs/ocfs2/quota.h~const-make-struct-super_block-dq_op-const
+++ a/fs/ocfs2/quota.h
@@ -109,7 +109,7 @@ void ocfs2_unlock_global_qf(struct ocfs2
 int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 			   struct buffer_head **bh);
 
-extern struct dquot_operations ocfs2_quota_operations;
+extern const struct dquot_operations ocfs2_quota_operations;
 extern struct quota_format_type ocfs2_quota_format;
 
 int ocfs2_quota_setup(void);
diff -puN fs/ocfs2/quota_global.c~const-make-struct-super_block-dq_op-const fs/ocfs2/quota_global.c
--- a/fs/ocfs2/quota_global.c~const-make-struct-super_block-dq_op-const
+++ a/fs/ocfs2/quota_global.c
@@ -850,7 +850,7 @@ static void ocfs2_destroy_dquot(struct d
 	kmem_cache_free(ocfs2_dquot_cachep, dquot);
 }
 
-struct dquot_operations ocfs2_quota_operations = {
+const struct dquot_operations ocfs2_quota_operations = {
 	.initialize	= dquot_initialize,
 	.drop		= dquot_drop,
 	.alloc_space	= dquot_alloc_space,
diff -puN fs/quota/dquot.c~const-make-struct-super_block-dq_op-const fs/quota/dquot.c
--- a/fs/quota/dquot.c~const-make-struct-super_block-dq_op-const
+++ a/fs/quota/dquot.c
@@ -1839,7 +1839,7 @@ EXPORT_SYMBOL(dquot_commit_info);
 /*
  * Definitions of diskquota operations.
  */
-struct dquot_operations dquot_operations = {
+const struct dquot_operations dquot_operations = {
 	.initialize	= dquot_initialize,
 	.drop		= dquot_drop,
 	.alloc_space	= dquot_alloc_space,
diff -puN fs/reiserfs/super.c~const-make-struct-super_block-dq_op-const fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~const-make-struct-super_block-dq_op-const
+++ a/fs/reiserfs/super.c
@@ -615,7 +615,7 @@ static int reiserfs_mark_dquot_dirty(str
 static int reiserfs_write_info(struct super_block *, int);
 static int reiserfs_quota_on(struct super_block *, int, int, char *, int);
 
-static struct dquot_operations reiserfs_quota_operations = {
+static const struct dquot_operations reiserfs_quota_operations = {
 	.initialize = dquot_initialize,
 	.drop = dquot_drop,
 	.alloc_space = dquot_alloc_space,
diff -puN include/linux/fs.h~const-make-struct-super_block-dq_op-const include/linux/fs.h
--- a/include/linux/fs.h~const-make-struct-super_block-dq_op-const
+++ a/include/linux/fs.h
@@ -1320,7 +1320,7 @@ struct super_block {
 	loff_t			s_maxbytes;	/* Max file size */
 	struct file_system_type	*s_type;
 	const struct super_operations	*s_op;
-	struct dquot_operations	*dq_op;
+	const struct dquot_operations	*dq_op;
  	struct quotactl_ops	*s_qcop;
 	const struct export_operations *s_export_op;
 	unsigned long		s_flags;
diff -puN include/linux/quotaops.h~const-make-struct-super_block-dq_op-const include/linux/quotaops.h
--- a/include/linux/quotaops.h~const-make-struct-super_block-dq_op-const
+++ a/include/linux/quotaops.h
@@ -135,7 +135,7 @@ static inline int sb_any_quota_active(st
 /*
  * Operations supported for diskquotas.
  */
-extern struct dquot_operations dquot_operations;
+extern const struct dquot_operations dquot_operations;
 extern struct quotactl_ops vfs_quotactl_ops;
 
 #define sb_dquot_ops (&dquot_operations)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
const-make-struct-super_block-dq_op-const.patch
const-make-struct-super_block-s_qcop-const.patch
const-mark-remaining-super_operations-const.patch
const-mark-remaining-export_operations-const.patch
const-mark-remaining-address_space_operations-const.patch
const-mark-remaining-inode_operations-as-const.patch
const-make-file_lock_operations-const.patch
const-make-lock_manager_operations-const.patch
const-make-block_device_operations-const.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
viafb-switch-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch

