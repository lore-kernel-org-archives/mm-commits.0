From: akpm@linux-foundation.org
Subject: + nilfs2-use-fixed-sized-types-for-ioctl-structures.patch added to -mm tree
Date: Wed, 18 Feb 2009 15:39:32 -0800
Message-ID: <200902182339.n1INdWjB022203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbZBRXj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 18:39:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: use fixed sized types for ioctl structures
has been added to the -mm tree.  Its filename is
     nilfs2-use-fixed-sized-types-for-ioctl-structures.patch

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
Subject: nilfs2: use fixed sized types for ioctl structures
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Nilfs ioctl had structures not having fixed sized types such as:

  struct nilfs_argv {
         void *v_base;
         size_t v_nmembs;
         size_t v_size;
         int v_index;
         int v_flags;
  };

Further, some of them are wrongly aligned:

  e.g.

  struct nilfs_cpmode {
        __u64 cm_cno;
        int cm_mode;
  };

The size of wrongly aligned structures varies depending on
architectures, and it breaks the identity of ioctl commands, which
leads to arch dependent errors.

Previously, these are compensated by using compat_ioctl.

This fixes these problems and allows removal of compat ioctl.

Since this will change sizes of those structures, binary compatibility
for the past utilities will once break; new utilities have to be used
instead.  However, it would be helpful to avoid platform dependent
problems in the long term.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c         |   11 +++++------
 include/linux/nilfs2_fs.h |   23 ++++++++++++++---------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff -puN fs/nilfs2/ioctl.c~nilfs2-use-fixed-sized-types-for-ioctl-structures fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-use-fixed-sized-types-for-ioctl-structures
+++ a/fs/nilfs2/ioctl.c
@@ -41,6 +41,7 @@ static int nilfs_ioctl_wrap_copy(struct 
 						   void *, size_t, size_t))
 {
 	void *buf;
+	void __user *base = (void __user *)(unsigned long)argv->v_base;
 	size_t maxmembs, total, n;
 	ssize_t nr;
 	int ret, i;
@@ -64,9 +65,8 @@ static int nilfs_ioctl_wrap_copy(struct 
 		n = (argv->v_nmembs - i < maxmembs) ?
 			argv->v_nmembs - i : maxmembs;
 		if ((dir & _IOC_WRITE) &&
-		    copy_from_user(buf,
-			    (void __user *)argv->v_base + argv->v_size * i,
-			    argv->v_size * n)) {
+		    copy_from_user(buf, base + argv->v_size * i,
+				   argv->v_size * n)) {
 			ret = -EFAULT;
 			break;
 		}
@@ -78,9 +78,8 @@ static int nilfs_ioctl_wrap_copy(struct 
 			break;
 		}
 		if ((dir & _IOC_READ) &&
-		    copy_to_user(
-			    (void __user *)argv->v_base + argv->v_size * i,
-			    buf, argv->v_size * nr)) {
+		    copy_to_user(base + argv->v_size * i, buf,
+				 argv->v_size * nr)) {
 			ret = -EFAULT;
 			break;
 		}
diff -puN include/linux/nilfs2_fs.h~nilfs2-use-fixed-sized-types-for-ioctl-structures include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-use-fixed-sized-types-for-ioctl-structures
+++ a/include/linux/nilfs2_fs.h
@@ -499,6 +499,7 @@ NILFS_CHECKPOINT_FNS(SKETCH, sketch)
 /**
  * struct nilfs_cpinfo - checkpoint information
  * @ci_flags: flags
+ * @ci_pad: padding
  * @ci_cno: checkpoint number
  * @ci_create: creation timestamp
  * @ci_nblk_inc: number of blocks incremented by this checkpoint
@@ -508,6 +509,7 @@ NILFS_CHECKPOINT_FNS(SKETCH, sketch)
  */
 struct nilfs_cpinfo {
 	__u32 ci_flags;
+	__u32 ci_pad;
 	__u64 ci_cno;
 	__u64 ci_create;
 	__u64 ci_nblk_inc;
@@ -668,7 +670,8 @@ enum {
  */
 struct nilfs_cpmode {
 	__u64 cm_cno;
-	int cm_mode;
+	__u32 cm_mode;
+	__u32 cm_pad;
 };
 
 /**
@@ -676,15 +679,15 @@ struct nilfs_cpmode {
  * @v_base:
  * @v_nmembs:
  * @v_size:
- * @v_index:
  * @v_flags:
+ * @v_index:
  */
 struct nilfs_argv {
-	void *v_base;
-	size_t v_nmembs;	/* number of members */
-	size_t v_size;		/* size of members */
-	int v_index;
-	int v_flags;
+	__u64 v_base;
+	__u32 v_nmembs;	/* number of members */
+	__u16 v_size;	/* size of members */
+	__u16 v_flags;
+	__u64 v_index;
 };
 
 /**
@@ -721,8 +724,8 @@ struct nilfs_sustat {
 	__u64 ss_nsegs;
 	__u64 ss_ncleansegs;
 	__u64 ss_ndirtysegs;
-	time_t ss_ctime;
-	time_t ss_nongc_ctime;
+	__u64 ss_ctime;
+	__u64 ss_nongc_ctime;
 };
 
 /**
@@ -750,6 +753,7 @@ struct nilfs_vdesc {
 	__u64 vd_blocknr;
 	__u64 vd_offset;
 	__u32 vd_flags;
+	__u32 vd_pad;
 };
 
 /**
@@ -761,6 +765,7 @@ struct nilfs_bdesc {
 	__u64 bd_blocknr;
 	__u64 bd_offset;
 	__u32 bd_level;
+	__u32 bd_pad;
 };
 
 #define NILFS_IOCTL_IDENT		'n'
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

