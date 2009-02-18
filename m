From: akpm@linux-foundation.org
Subject: + nilfs2-use-unlocked_ioctl.patch added to -mm tree
Date: Wed, 18 Feb 2009 15:39:59 -0800
Message-ID: <200902182339.n1INdxek022692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbZBRXk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 18:40:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, penberg@cs.helsinki.fi


The patch titled
     nilfs2: use unlocked_ioctl
has been added to the -mm tree.  Its filename is
     nilfs2-use-unlocked_ioctl.patch

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
Subject: nilfs2: use unlocked_ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Pekka Enberg suggested converting ->ioctl operations to use
->unlocked_ioctl to avoid BKL.

The conversion was verified to be safe, so I will take it on this
occasion.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |    2 +-
 fs/nilfs2/file.c  |    2 +-
 fs/nilfs2/ioctl.c |    4 ++--
 fs/nilfs2/nilfs.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/nilfs2/dir.c~nilfs2-use-unlocked_ioctl fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c~nilfs2-use-unlocked_ioctl
+++ a/fs/nilfs2/dir.c
@@ -702,7 +702,7 @@ struct file_operations nilfs_dir_operati
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= nilfs_readdir,
-	.ioctl		= nilfs_ioctl,
+	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_ioctl,
 #endif	/* CONFIG_COMPAT */
diff -puN fs/nilfs2/file.c~nilfs2-use-unlocked_ioctl fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-use-unlocked_ioctl
+++ a/fs/nilfs2/file.c
@@ -138,7 +138,7 @@ struct file_operations nilfs_file_operat
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
-	.ioctl		= nilfs_ioctl,
+	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_ioctl,
 #endif	/* CONFIG_COMPAT */
diff -puN fs/nilfs2/ioctl.c~nilfs2-use-unlocked_ioctl fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-use-unlocked_ioctl
+++ a/fs/nilfs2/ioctl.c
@@ -600,9 +600,9 @@ static int nilfs_ioctl_sync(struct inode
 	return 0;
 }
 
-int nilfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		unsigned long arg)
+long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	void __user *argp = (void * __user *)arg;
 
 	switch (cmd) {
diff -puN fs/nilfs2/nilfs.h~nilfs2-use-unlocked_ioctl fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-use-unlocked_ioctl
+++ a/fs/nilfs2/nilfs.h
@@ -242,7 +242,7 @@ extern void nilfs_set_link(struct inode 
 extern int nilfs_sync_file(struct file *, struct dentry *, int);
 
 /* ioctl.c */
-int nilfs_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+long nilfs_ioctl(struct file *, unsigned int, unsigned long);
 int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, void __user *);
 
 /* inode.c */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments.patch
nilfs2-inode-operations.patch
nilfs2-inode-operations-fix.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-pathname-operations-fix.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-super-block-operations-fix.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
nilfs2-cleanup-nilfs_clear_inode.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-insert-explanations-in-gcinode-file.patch
nilfs2-add-maintainer.patch
nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
nilfs2-clean-up-indirect-function-calling-conventions.patch
nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch
nilfs2-remove-timedwait-ioctl-command.patch
nilfs2-use-fixed-sized-types-for-ioctl-structures.patch
nilfs2-remove-compat-ioctl-code.patch
nilfs2-use-unlocked_ioctl.patch
nilfs2-extend-nilfs_sustat-ioctl-struct.patch
nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch

