From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:07 -0700
Message-ID: <20120731185308.1F8B9200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37887 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab2GaSxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:09 -0400
Received: by mail-ee0-f74.google.com with SMTP id d4so295599eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, fernando@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix timing issue between rmcp and chcp ioctls
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix timing issue between rmcp and chcp ioctls

The checkpoint deletion ioctl (rmcp ioctl) has potential for breaking
snapshot because it is not fully exclusive with checkpoint mode change
ioctl (chcp ioctl).

The rmcp ioctl first tests if the specified checkpoint is a snapshot or
not within nilfs_cpfile_delete_checkpoint function, and then calls
nilfs_cpfile_delete_checkpoints function to actually invalidate the
checkpoint only if it's not a snapshot.  However, the checkpoint can be
changed into a snapshot by the chcp ioctl between these two operations. 
In that case, calling nilfs_cpfile_delete_checkpoints() wrongly
invalidates the snapshot, which leads to snapshot list corruption and
snapshot count mismatch.

This fixes the issue by changing nilfs_cpfile_delete_checkpoints() so that
it reconfirms the target checkpoints are snapshot or not.

This second check is exclusive with the chcp operation since it is
protected by an existing semaphore.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/nilfs2/cpfile.c~nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls
+++ a/fs/nilfs2/cpfile.c
@@ -286,7 +286,7 @@ int nilfs_cpfile_delete_checkpoints(stru
 	__u64 cno;
 	void *kaddr;
 	unsigned long tnicps;
-	int ret, ncps, nicps, count, i;
+	int ret, ncps, nicps, nss, count, i;
 
 	if (unlikely(start == 0 || start > end)) {
 		printk(KERN_ERR "%s: invalid range of checkpoint numbers: "
@@ -301,6 +301,7 @@ int nilfs_cpfile_delete_checkpoints(stru
 	if (ret < 0)
 		goto out_sem;
 	tnicps = 0;
+	nss = 0;
 
 	for (cno = start; cno < end; cno += ncps) {
 		ncps = nilfs_cpfile_checkpoints_in_block(cpfile, cno, end);
@@ -318,8 +319,9 @@ int nilfs_cpfile_delete_checkpoints(stru
 			cpfile, cno, cp_bh, kaddr);
 		nicps = 0;
 		for (i = 0; i < ncps; i++, cp = (void *)cp + cpsz) {
-			WARN_ON(nilfs_checkpoint_snapshot(cp));
-			if (!nilfs_checkpoint_invalid(cp)) {
+			if (nilfs_checkpoint_snapshot(cp)) {
+				nss++;
+			} else if (!nilfs_checkpoint_invalid(cp)) {
 				nilfs_checkpoint_set_invalid(cp);
 				nicps++;
 			}
@@ -364,6 +366,8 @@ int nilfs_cpfile_delete_checkpoints(stru
 	}
 
 	brelse(header_bh);
+	if (nss > 0)
+		ret = -EBUSY;
 
  out_sem:
 	up_write(&NILFS_MDT(cpfile)->mi_sem);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

