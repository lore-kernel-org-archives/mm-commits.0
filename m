From: akpm@linux-foundation.org
Subject: [merged] fs-ocfs2-ioctlc-add-static-to-local-functions.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:42:48 -0700
Message-ID: <5390c838.aUvAj447OseDpHUx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaFETmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, fabf@skynet.be

Subject: [merged] fs-ocfs2-ioctlc-add-static-to-local-functions.patch removed from -mm tree
To: fabf@skynet.be,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:48 -0700


The patch titled
     Subject: fs/ocfs2/ioctl.c: add static to local functions
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-ioctlc-add-static-to-local-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ocfs2/ioctl.c: add static to local functions

ocfs_info_foo() and ocfs2_get_request_ptr functions are only used in ioctl.c

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c |   81 ++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 40 deletions(-)

diff -puN fs/ocfs2/ioctl.c~fs-ocfs2-ioctlc-add-static-to-local-functions fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~fs-ocfs2-ioctlc-add-static-to-local-functions
+++ a/fs/ocfs2/ioctl.c
@@ -143,8 +143,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_blocksize(struct inode *inode,
-				struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_blocksize(struct inode *inode,
+				       struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_blocksize oib;
@@ -167,8 +167,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_clustersize(struct inode *inode,
-				  struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_clustersize(struct inode *inode,
+					 struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_clustersize oic;
@@ -192,8 +192,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_maxslots(struct inode *inode,
-			       struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_maxslots(struct inode *inode,
+				      struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_maxslots oim;
@@ -217,8 +217,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_label(struct inode *inode,
-			    struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_label(struct inode *inode,
+				   struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_label oil;
@@ -242,8 +242,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_uuid(struct inode *inode,
-			   struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_uuid(struct inode *inode,
+				  struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_uuid oiu;
@@ -267,8 +267,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_fs_features(struct inode *inode,
-				  struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_fs_features(struct inode *inode,
+					 struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_fs_features oif;
@@ -294,8 +294,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_journal_size(struct inode *inode,
-				   struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_journal_size(struct inode *inode,
+					  struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_journal_size oij;
@@ -319,9 +319,10 @@ bail:
 	return status;
 }
 
-int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
-				struct inode *inode_alloc, u64 blkno,
-				struct ocfs2_info_freeinode *fi, u32 slot)
+static int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
+				       struct inode *inode_alloc, u64 blkno,
+				       struct ocfs2_info_freeinode *fi,
+				       u32 slot)
 {
 	int status = 0, unlock = 0;
 
@@ -366,8 +367,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_freeinode(struct inode *inode,
-				struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_freeinode(struct inode *inode,
+				       struct ocfs2_info_request __user *req)
 {
 	u32 i;
 	u64 blkno = -1;
@@ -462,19 +463,19 @@ static void o2ffg_update_stats(struct oc
 	stats->ffs_free_chunks_real++;
 }
 
-void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg,
-			   unsigned int chunksize)
+static void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg,
+				  unsigned int chunksize)
 {
 	o2ffg_update_histogram(&(ffg->iff_ffs.ffs_fc_hist), chunksize);
 	o2ffg_update_stats(&(ffg->iff_ffs), chunksize);
 }
 
-int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
-				   struct inode *gb_inode,
-				   struct ocfs2_dinode *gb_dinode,
-				   struct ocfs2_chain_rec *rec,
-				   struct ocfs2_info_freefrag *ffg,
-				   u32 chunks_in_group)
+static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
+					  struct inode *gb_inode,
+					  struct ocfs2_dinode *gb_dinode,
+					  struct ocfs2_chain_rec *rec,
+					  struct ocfs2_info_freefrag *ffg,
+					  u32 chunks_in_group)
 {
 	int status = 0, used;
 	u64 blkno;
@@ -572,9 +573,9 @@ bail:
 	return status;
 }
 
-int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
-				    struct inode *gb_inode, u64 blkno,
-				    struct ocfs2_info_freefrag *ffg)
+static int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
+					   struct inode *gb_inode, u64 blkno,
+					   struct ocfs2_info_freefrag *ffg)
 {
 	u32 chunks_in_group;
 	int status = 0, unlock = 0, i;
@@ -652,8 +653,8 @@ bail:
 	return status;
 }
 
-int ocfs2_info_handle_freefrag(struct inode *inode,
-			       struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_freefrag(struct inode *inode,
+				      struct ocfs2_info_request __user *req)
 {
 	u64 blkno = -1;
 	char namebuf[40];
@@ -723,8 +724,8 @@ out_err:
 	return status;
 }
 
-int ocfs2_info_handle_unknown(struct inode *inode,
-			      struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_unknown(struct inode *inode,
+				     struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_request oir;
@@ -752,8 +753,8 @@ bail:
  * - distinguish different requests.
  * - validate size of different requests.
  */
-int ocfs2_info_handle_request(struct inode *inode,
-			      struct ocfs2_info_request __user *req)
+static int ocfs2_info_handle_request(struct inode *inode,
+				     struct ocfs2_info_request __user *req)
 {
 	int status = -EFAULT;
 	struct ocfs2_info_request oir;
@@ -811,8 +812,8 @@ bail:
 	return status;
 }
 
-int ocfs2_get_request_ptr(struct ocfs2_info *info, int idx,
-			  u64 *req_addr, int compat_flag)
+static int ocfs2_get_request_ptr(struct ocfs2_info *info, int idx,
+				 u64 *req_addr, int compat_flag)
 {
 	int status = -EFAULT;
 	u64 __user *bp = NULL;
@@ -849,8 +850,8 @@ bail:
  * a better backward&forward compatibility, since a small piece of
  * request will be less likely to be broken if disk layout get changed.
  */
-int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
-		      int compat_flag)
+static int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
+			     int compat_flag)
 {
 	int i, status = 0;
 	u64 req_addr;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

