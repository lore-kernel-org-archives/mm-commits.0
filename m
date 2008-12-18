From: akpm@linux-foundation.org
Subject: + nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch added to -mm tree
Date: Wed, 17 Dec 2008 22:08:28 -0800
Message-ID: <200812180608.mBI68Sl5028424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbYLRGJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 01:09:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, 20081215.155840.105124170.ryusuke@osrg.net


The patch titled
     nilfs2: fix gc failure on volumes keeping numerous snapshots
has been added to the -mm tree.  Its filename is
     nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch

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
Subject: nilfs2: fix gc failure on volumes keeping numerous snapshots
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This resolves the following failure of nilfs2 cleaner daemon:

 nilfs_cleanerd[20670]: cannot clean segments: No such file or directory
 nilfs_cleanerd[20670]: shutdown

When creating thousands of snapshots, the cleaner daemon had rarely died
as above due to an error returned from the kernel code.

After applying the recent patch which fixed memory allocation problems in
ioctl (Message-Id: <20081215.155840.105124170.ryusuke@osrg.net>), the
problem gets more frequent.

It turned out to be a bug of nilfs_ioctl_wrap_copy function and one of its
callback routines to read out information of snapshots; if the
nilfs_ioctl_wrap_copy function divided a large read request into multiple
requests, the second and later requests have failed since a restart
position on snapshot meta data was not properly set forward.

It's a deficiency of the callback interface that cannot pass the restart
position among multiple requests.  This patch fixes the issue by allowing
nilfs_ioctl_wrap_copy and snapshot read functions to exchange a position
argument.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |   24 ++++++++++++++----------
 fs/nilfs2/cpfile.h |    2 +-
 fs/nilfs2/ioctl.c  |   38 +++++++++++++++++++++++---------------
 3 files changed, 38 insertions(+), 26 deletions(-)

diff -puN fs/nilfs2/cpfile.c~nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots
+++ a/fs/nilfs2/cpfile.c
@@ -422,20 +422,20 @@ static ssize_t nilfs_cpfile_do_get_cpinf
 	return ret;
 }
 
-static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 cno,
+static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 					  struct nilfs_cpinfo *ci, size_t nci)
 {
 	struct buffer_head *bh;
 	struct nilfs_cpfile_header *header;
 	struct nilfs_checkpoint *cp;
-	__u64 curr, next;
+	__u64 curr = *cnop, next;
 	unsigned long curr_blkoff, next_blkoff;
 	void *kaddr;
 	int n, ret;
 
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
-	if (cno == 0) {
+	if (curr == 0) {
 		ret = nilfs_cpfile_get_header_block(cpfile, &bh);
 		if (ret < 0)
 			goto out;
@@ -448,8 +448,11 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 			ret = 0;
 			goto out;
 		}
-	} else
-		curr = cno;
+	} else if (unlikely(curr == ~(__u64)0)) {
+		ret = 0;
+		goto out;
+	}
+
 	curr_blkoff = nilfs_cpfile_get_blkoff(cpfile, curr);
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr, 0, &bh);
 	if (ret < 0)
@@ -461,7 +464,7 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, &ci[n]);
 		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
 		if (next == 0) {
-			curr = next;
+			curr = ~(__u64)0; /* Terminator */
 			n++;
 			break;
 		}
@@ -480,6 +483,7 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 	}
 	kunmap_atomic(kaddr, KM_USER0);
 	brelse(bh);
+	*cnop = curr;
 	ret = n;
 
  out:
@@ -494,15 +498,15 @@ static ssize_t nilfs_cpfile_do_get_ssinf
  * @ci:
  * @nci:
  */
-ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile,
-				__u64 cno, int mode,
+
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *cpfile, __u64 *cnop, int mode,
 				struct nilfs_cpinfo *ci, size_t nci)
 {
 	switch (mode) {
 	case NILFS_CHECKPOINT:
-		return nilfs_cpfile_do_get_cpinfo(cpfile, cno, ci, nci);
+		return nilfs_cpfile_do_get_cpinfo(cpfile, *cnop, ci, nci);
 	case NILFS_SNAPSHOT:
-		return nilfs_cpfile_do_get_ssinfo(cpfile, cno, ci, nci);
+		return nilfs_cpfile_do_get_ssinfo(cpfile, cnop, ci, nci);
 	default:
 		return -EINVAL;
 	}
diff -puN fs/nilfs2/cpfile.h~nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots fs/nilfs2/cpfile.h
--- a/fs/nilfs2/cpfile.h~nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots
+++ a/fs/nilfs2/cpfile.h
@@ -39,7 +39,7 @@ int nilfs_cpfile_delete_checkpoint(struc
 int nilfs_cpfile_change_cpmode(struct inode *, __u64, int);
 int nilfs_cpfile_is_snapshot(struct inode *, __u64);
 int nilfs_cpfile_get_stat(struct inode *, struct nilfs_cpstat *);
-ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64, int,
+ssize_t nilfs_cpfile_get_cpinfo(struct inode *, __u64 *, int,
 				struct nilfs_cpinfo *, size_t);
 
 #endif	/* _NILFS_CPFILE_H */
diff -puN fs/nilfs2/ioctl.c~nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots
+++ a/fs/nilfs2/ioctl.c
@@ -37,13 +37,14 @@
 static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 				 struct nilfs_argv *argv, int dir,
 				 ssize_t (*dofunc)(struct the_nilfs *,
-						   int, int,
+						   __u64 *, int,
 						   void *, size_t, size_t))
 {
 	void *buf;
 	size_t maxmembs, total, n;
 	ssize_t nr;
 	int ret, i;
+	__u64 pos, ppos;
 
 	if (argv->v_nmembs == 0)
 		return 0;
@@ -58,6 +59,7 @@ static int nilfs_ioctl_wrap_copy(struct 
 
 	ret = 0;
 	total = 0;
+	pos = argv->v_index;
 	for (i = 0; i < argv->v_nmembs; i += n) {
 		n = (argv->v_nmembs - i < maxmembs) ?
 			argv->v_nmembs - i : maxmembs;
@@ -68,8 +70,9 @@ static int nilfs_ioctl_wrap_copy(struct 
 			ret = -EFAULT;
 			break;
 		}
-		nr = (*dofunc)(nilfs, argv->v_index + i, argv->v_flags, buf,
-			       argv->v_size, n);
+		ppos = pos;
+		nr = (*dofunc)(nilfs, &pos, argv->v_flags, buf, argv->v_size,
+			       n);
 		if (nr < 0) {
 			ret = nr;
 			break;
@@ -82,6 +85,10 @@ static int nilfs_ioctl_wrap_copy(struct 
 			break;
 		}
 		total += nr;
+		if ((size_t)nr < n)
+			break;
+		if (pos == ppos)
+			pos += n;
 	}
 	argv->v_nmembs = total;
 
@@ -138,10 +145,10 @@ nilfs_ioctl_delete_checkpoint(struct ino
 }
 
 static ssize_t
-nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
-	return nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, index, flags, buf,
+	return nilfs_cpfile_get_cpinfo(nilfs->ns_cpfile, posp, flags, buf,
 				       nmembs);
 }
 
@@ -186,10 +193,10 @@ static int nilfs_ioctl_get_cpstat(struct
 }
 
 static ssize_t
-nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
-	return nilfs_sufile_get_suinfo(nilfs->ns_sufile, index, buf, nmembs);
+	return nilfs_sufile_get_suinfo(nilfs->ns_sufile, *posp, buf, nmembs);
 }
 
 static int nilfs_ioctl_get_suinfo(struct inode *inode, struct file *filp,
@@ -233,7 +240,7 @@ static int nilfs_ioctl_get_sustat(struct
 }
 
 static ssize_t
-nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			 void *buf, size_t size, size_t nmembs)
 {
 	return nilfs_dat_get_vinfo(nilfs_dat_inode(nilfs), buf, nmembs);
@@ -262,7 +269,7 @@ static int nilfs_ioctl_get_vinfo(struct 
 }
 
 static ssize_t
-nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			  void *buf, size_t size, size_t nmembs)
 {
 	struct inode *dat = nilfs_dat_inode(nilfs);
@@ -341,7 +348,7 @@ static int nilfs_ioctl_move_inode_block(
 }
 
 static ssize_t
-nilfs_ioctl_do_move_blocks(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_move_blocks(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			   void *buf, size_t size, size_t nmembs)
 {
 	struct inode *inode;
@@ -413,7 +420,7 @@ static inline int nilfs_ioctl_move_block
 }
 
 static ssize_t
-nilfs_ioctl_do_delete_checkpoints(struct the_nilfs *nilfs, int index,
+nilfs_ioctl_do_delete_checkpoints(struct the_nilfs *nilfs, __u64 *posp,
 				  int flags, void *buf, size_t size,
 				  size_t nmembs)
 {
@@ -439,7 +446,7 @@ static inline int nilfs_ioctl_delete_che
 }
 
 static ssize_t
-nilfs_ioctl_do_free_vblocknrs(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_free_vblocknrs(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			      void *buf, size_t size, size_t nmembs)
 {
 	int ret = nilfs_dat_freev(nilfs_dat_inode(nilfs), buf, nmembs);
@@ -456,8 +463,9 @@ static inline int nilfs_ioctl_free_vbloc
 }
 
 static ssize_t
-nilfs_ioctl_do_mark_blocks_dirty(struct the_nilfs *nilfs, int index, int flags,
-				 void *buf, size_t size, size_t nmembs)
+nilfs_ioctl_do_mark_blocks_dirty(struct the_nilfs *nilfs, __u64 *posp,
+				 int flags, void *buf, size_t size,
+				 size_t nmembs)
 {
 	struct inode *dat = nilfs_dat_inode(nilfs);
 	struct nilfs_bmap *bmap = NILFS_I(dat)->i_bmap;
@@ -506,7 +514,7 @@ static inline int nilfs_ioctl_mark_block
 }
 
 static ssize_t
-nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, int index, int flags,
+nilfs_ioctl_do_free_segments(struct the_nilfs *nilfs, __u64 *posp, int flags,
 			     void *buf, size_t size, size_t nmembs)
 {
 	struct nilfs_sb_info *sbi = nilfs_get_writer(nilfs);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
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

