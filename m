From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:51 -0700
Message-ID: <5535511b.IuA24zY13Exq4zAj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbbDTTMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: improve execution time of NILFS_IOCTL_GET_CPINFO ioctl
has been removed from the -mm tree.  Its filename was
     nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: improve execution time of NILFS_IOCTL_GET_CPINFO ioctl

The older a filesystem gets, the slower lscp command becomes.  This is
because nilfs_cpfile_do_get_cpinfo() function meets more hole blocks
as the start offset of valid checkpoint numbers gets bigger.

This reduces the overhead by skipping hole blocks efficiently with
nilfs_mdt_find_block() helper.

A measurement result of this patch is as follows:

Before:
$ time lscp
                 CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
             5769303  2015-02-22 19:31:33   cp    -          108          1
             5769304  2015-02-22 19:38:54   cp    -          108          1

real    0m0.182s
user    0m0.003s
sys     0m0.180s

After:
$ time lscp
                 CNO        DATE     TIME  MODE  FLG      BLKCNT       ICNT
             5769303  2015-02-22 19:31:33   cp    -          108          1
             5769304  2015-02-22 19:38:54   cp    -          108          1

real    0m0.003s
user    0m0.001s
sys     0m0.002s

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |   58 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 6 deletions(-)

diff -puN fs/nilfs2/cpfile.c~nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl
+++ a/fs/nilfs2/cpfile.c
@@ -53,6 +53,13 @@ nilfs_cpfile_get_offset(const struct ino
 	return do_div(tcno, nilfs_cpfile_checkpoints_per_block(cpfile));
 }
 
+static __u64 nilfs_cpfile_first_checkpoint_in_block(const struct inode *cpfile,
+						    unsigned long blkoff)
+{
+	return (__u64)nilfs_cpfile_checkpoints_per_block(cpfile) * blkoff
+		+ 1 - NILFS_MDT(cpfile)->mi_first_entry_offset;
+}
+
 static unsigned long
 nilfs_cpfile_checkpoints_in_block(const struct inode *cpfile,
 				  __u64 curr,
@@ -146,6 +153,44 @@ static inline int nilfs_cpfile_get_check
 				   create, nilfs_cpfile_block_init, bhp);
 }
 
+/**
+ * nilfs_cpfile_find_checkpoint_block - find and get a buffer on cpfile
+ * @cpfile: inode of cpfile
+ * @start_cno: start checkpoint number (inclusive)
+ * @end_cno: end checkpoint number (inclusive)
+ * @cnop: place to store the next checkpoint number
+ * @bhp: place to store a pointer to buffer_head struct
+ *
+ * Return Value: On success, it returns 0. On error, the following negative
+ * error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ *
+ * %-EIO - I/O error
+ *
+ * %-ENOENT - no block exists in the range.
+ */
+static int nilfs_cpfile_find_checkpoint_block(struct inode *cpfile,
+					      __u64 start_cno, __u64 end_cno,
+					      __u64 *cnop,
+					      struct buffer_head **bhp)
+{
+	unsigned long start, end, blkoff;
+	int ret;
+
+	if (unlikely(start_cno > end_cno))
+		return -ENOENT;
+
+	start = nilfs_cpfile_get_blkoff(cpfile, start_cno);
+	end = nilfs_cpfile_get_blkoff(cpfile, end_cno);
+
+	ret = nilfs_mdt_find_block(cpfile, start, end, &blkoff, bhp);
+	if (!ret)
+		*cnop = (blkoff == start) ? start_cno :
+			nilfs_cpfile_first_checkpoint_in_block(cpfile, blkoff);
+	return ret;
+}
+
 static inline int nilfs_cpfile_delete_checkpoint_block(struct inode *cpfile,
 						       __u64 cno)
 {
@@ -403,14 +448,15 @@ static ssize_t nilfs_cpfile_do_get_cpinf
 		return -ENOENT; /* checkpoint number 0 is invalid */
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
-	for (n = 0; cno < cur_cno && n < nci; cno += ncps) {
-		ncps = nilfs_cpfile_checkpoints_in_block(cpfile, cno, cur_cno);
-		ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
+	for (n = 0; n < nci; cno += ncps) {
+		ret = nilfs_cpfile_find_checkpoint_block(
+			cpfile, cno, cur_cno - 1, &cno, &bh);
 		if (ret < 0) {
-			if (ret != -ENOENT)
-				goto out;
-			continue; /* skip hole */
+			if (likely(ret == -ENOENT))
+				break;
+			goto out;
 		}
+		ncps = nilfs_cpfile_checkpoints_in_block(cpfile, cno, cur_cno);
 
 		kaddr = kmap_atomic(bh->b_page);
 		cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

