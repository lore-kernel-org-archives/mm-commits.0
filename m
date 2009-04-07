From: akpm@linux-foundation.org
Subject: [merged] nilfs2-use-fixed-sized-types-for-ioctl-structures.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:33 -0700
Message-ID: <200904071909.n37J9XnE012397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbZDGTL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: use fixed sized types for ioctl structures
has been removed from the -mm tree.  Its filename was
     nilfs2-use-fixed-sized-types-for-ioctl-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

