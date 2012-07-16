From: akpm@linux-foundation.org
Subject: + nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls.patch added to -mm tree
Date: Mon, 16 Jul 2012 14:29:33 -0700
Message-ID: <20120716212934.443941E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46877 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2GPV3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jul 2012 17:29:38 -0400
Received: by qabg24 with SMTP id g24so320779qab.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Jul 2012 14:29:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, fernando@oss.ntt.co.jp


The patch titled
     Subject: nilfs2: fix timing issue between rmcp and chcp ioctls
has been added to the -mm tree.  Its filename is
     nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: nilfs2: fix timing issue between rmcp and chcp ioctls

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-omitted-comment-for-ns_mount_state-field-of-the_nilfs-structure.patch
nilfs2-remove-references-to-long-gone-super-operations.patch
nilfs2-fix-timing-issue-between-rmcp-and-chcp-ioctls.patch
nilfs2-fix-deadlock-issue-between-chcp-and-thaw-ioctls.patch

