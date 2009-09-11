From: akpm@linux-foundation.org
Subject: + const-make-struct-super_block-s_qcop-const.patch added to -mm tree
Date: Fri, 11 Sep 2009 13:27:13 -0700
Message-ID: <200909112027.n8BKRDQx018478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbZIKU13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 16:27:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     const: make struct super_block::s_qcop const
has been added to the -mm tree.  Its filename is
     const-make-struct-super_block-s_qcop-const.patch

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
Subject: const: make struct super_block::s_qcop const
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c                |    4 ++--
 fs/ext3/super.c                 |    2 +-
 fs/ext4/super.c                 |    2 +-
 fs/ocfs2/super.c                |    2 +-
 fs/quota/dquot.c                |    2 +-
 fs/reiserfs/super.c             |    2 +-
 fs/xfs/linux-2.6/xfs_quotaops.c |    2 +-
 fs/xfs/linux-2.6/xfs_super.h    |    2 +-
 include/linux/fs.h              |    2 +-
 include/linux/quotaops.h        |    2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/cifs/cifsfs.c~const-make-struct-super_block-s_qcop-const fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~const-make-struct-super_block-s_qcop-const
+++ a/fs/cifs/cifsfs.c
@@ -50,7 +50,7 @@
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
 
 #ifdef CONFIG_CIFS_QUOTA
-static struct quotactl_ops cifs_quotactl_ops;
+static const struct quotactl_ops cifs_quotactl_ops;
 #endif /* QUOTA */
 
 int cifsFYI = 0;
@@ -517,7 +517,7 @@ int cifs_xstate_get(struct super_block *
 	return rc;
 }
 
-static struct quotactl_ops cifs_quotactl_ops = {
+static const struct quotactl_ops cifs_quotactl_ops = {
 	.set_xquota	= cifs_xquota_set,
 	.get_xquota	= cifs_xquota_get,
 	.set_xstate	= cifs_xstate_set,
diff -puN fs/ext3/super.c~const-make-struct-super_block-s_qcop-const fs/ext3/super.c
--- a/fs/ext3/super.c~const-make-struct-super_block-s_qcop-const
+++ a/fs/ext3/super.c
@@ -737,7 +737,7 @@ static const struct dquot_operations ext
 	.destroy_dquot	= dquot_destroy,
 };
 
-static struct quotactl_ops ext3_qctl_operations = {
+static const struct quotactl_ops ext3_qctl_operations = {
 	.quota_on	= ext3_quota_on,
 	.quota_off	= vfs_quota_off,
 	.quota_sync	= vfs_quota_sync,
diff -puN fs/ext4/super.c~const-make-struct-super_block-s_qcop-const fs/ext4/super.c
--- a/fs/ext4/super.c~const-make-struct-super_block-s_qcop-const
+++ a/fs/ext4/super.c
@@ -998,7 +998,7 @@ static const struct dquot_operations ext
 	.destroy_dquot	= dquot_destroy,
 };
 
-static struct quotactl_ops ext4_qctl_operations = {
+static const struct quotactl_ops ext4_qctl_operations = {
 	.quota_on	= ext4_quota_on,
 	.quota_off	= vfs_quota_off,
 	.quota_sync	= vfs_quota_sync,
diff -puN fs/ocfs2/super.c~const-make-struct-super_block-s_qcop-const fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~const-make-struct-super_block-s_qcop-const
+++ a/fs/ocfs2/super.c
@@ -966,7 +966,7 @@ static int ocfs2_quota_off(struct super_
 	return vfs_quota_disable(sb, type, DQUOT_LIMITS_ENABLED);
 }
 
-static struct quotactl_ops ocfs2_quotactl_ops = {
+static const struct quotactl_ops ocfs2_quotactl_ops = {
 	.quota_on	= ocfs2_quota_on,
 	.quota_off	= ocfs2_quota_off,
 	.quota_sync	= vfs_quota_sync,
diff -puN fs/quota/dquot.c~const-make-struct-super_block-s_qcop-const fs/quota/dquot.c
--- a/fs/quota/dquot.c~const-make-struct-super_block-s_qcop-const
+++ a/fs/quota/dquot.c
@@ -2461,7 +2461,7 @@ out:
 }
 EXPORT_SYMBOL(vfs_set_dqinfo);
 
-struct quotactl_ops vfs_quotactl_ops = {
+const struct quotactl_ops vfs_quotactl_ops = {
 	.quota_on	= vfs_quota_on,
 	.quota_off	= vfs_quota_off,
 	.quota_sync	= vfs_quota_sync,
diff -puN fs/reiserfs/super.c~const-make-struct-super_block-s_qcop-const fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~const-make-struct-super_block-s_qcop-const
+++ a/fs/reiserfs/super.c
@@ -632,7 +632,7 @@ static const struct dquot_operations rei
 	.destroy_dquot	= dquot_destroy,
 };
 
-static struct quotactl_ops reiserfs_qctl_operations = {
+static const struct quotactl_ops reiserfs_qctl_operations = {
 	.quota_on = reiserfs_quota_on,
 	.quota_off = vfs_quota_off,
 	.quota_sync = vfs_quota_sync,
diff -puN fs/xfs/linux-2.6/xfs_quotaops.c~const-make-struct-super_block-s_qcop-const fs/xfs/linux-2.6/xfs_quotaops.c
--- a/fs/xfs/linux-2.6/xfs_quotaops.c~const-make-struct-super_block-s_qcop-const
+++ a/fs/xfs/linux-2.6/xfs_quotaops.c
@@ -150,7 +150,7 @@ xfs_fs_set_xquota(
 	return -xfs_qm_scall_setqlim(mp, id, xfs_quota_type(type), fdq);
 }
 
-struct quotactl_ops xfs_quotactl_operations = {
+const struct quotactl_ops xfs_quotactl_operations = {
 	.quota_sync		= xfs_fs_quota_sync,
 	.get_xstate		= xfs_fs_get_xstate,
 	.set_xstate		= xfs_fs_set_xstate,
diff -puN fs/xfs/linux-2.6/xfs_super.h~const-make-struct-super_block-s_qcop-const fs/xfs/linux-2.6/xfs_super.h
--- a/fs/xfs/linux-2.6/xfs_super.h~const-make-struct-super_block-s_qcop-const
+++ a/fs/xfs/linux-2.6/xfs_super.h
@@ -93,7 +93,7 @@ extern void xfs_blkdev_issue_flush(struc
 
 extern const struct export_operations xfs_export_operations;
 extern struct xattr_handler *xfs_xattr_handlers[];
-extern struct quotactl_ops xfs_quotactl_operations;
+extern const struct quotactl_ops xfs_quotactl_operations;
 
 #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
 
diff -puN include/linux/fs.h~const-make-struct-super_block-s_qcop-const include/linux/fs.h
--- a/include/linux/fs.h~const-make-struct-super_block-s_qcop-const
+++ a/include/linux/fs.h
@@ -1321,7 +1321,7 @@ struct super_block {
 	struct file_system_type	*s_type;
 	const struct super_operations	*s_op;
 	const struct dquot_operations	*dq_op;
- 	struct quotactl_ops	*s_qcop;
+	const struct quotactl_ops	*s_qcop;
 	const struct export_operations *s_export_op;
 	unsigned long		s_flags;
 	unsigned long		s_magic;
diff -puN include/linux/quotaops.h~const-make-struct-super_block-s_qcop-const include/linux/quotaops.h
--- a/include/linux/quotaops.h~const-make-struct-super_block-s_qcop-const
+++ a/include/linux/quotaops.h
@@ -136,7 +136,7 @@ static inline int sb_any_quota_active(st
  * Operations supported for diskquotas.
  */
 extern const struct dquot_operations dquot_operations;
-extern struct quotactl_ops vfs_quotactl_ops;
+extern const struct quotactl_ops vfs_quotactl_ops;
 
 #define sb_dquot_ops (&dquot_operations)
 #define sb_quotactl_ops (&vfs_quotactl_ops)
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

