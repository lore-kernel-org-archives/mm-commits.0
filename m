From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:25 -0700
Message-ID: <200904071909.n37J9PSl012322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067AbZDGT0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:26:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: fix improper return values of nilfs_get_cpinfo ioctl
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: fix improper return values of nilfs_get_cpinfo ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

A few tool developers gave me requests for fixing inconvenient return
value of nilfs_get_cpinfo() ioctl; if the requested mode is NILFS_SNAPSHOT
and the specified start entry is not a snapshot, the ioctl unnaturally
returns one as the number of acquired snapshot item.

In addition, the ioctl function returns an ENOENT error for checkpoints
within blocks deleted by garbage collection.

These behaviors require corrections for programs which enumerate
snapshots.  This resolves the inconvenience by changing the return values
to zero for the above cases.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN fs/nilfs2/cpfile.c~nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl
+++ a/fs/nilfs2/cpfile.c
@@ -431,7 +431,7 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 	__u64 curr = *cnop, next;
 	unsigned long curr_blkoff, next_blkoff;
 	void *kaddr;
-	int n, ret;
+	int n = 0, ret;
 
 	down_read(&NILFS_MDT(cpfile)->mi_sem);
 
@@ -455,27 +455,33 @@ static ssize_t nilfs_cpfile_do_get_ssinf
 
 	curr_blkoff = nilfs_cpfile_get_blkoff(cpfile, curr);
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr, 0, &bh);
-	if (ret < 0)
+	if (unlikely(ret < 0)) {
+		if (ret == -ENOENT)
+			ret = 0; /* No snapshots (started from a hole block) */
 		goto out;
+	}
 	kaddr = kmap_atomic(bh->b_page, KM_USER0);
-	for (n = 0; n < nci; n++) {
-		cp = nilfs_cpfile_block_get_checkpoint(
-			cpfile, curr, bh, kaddr);
-		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, &ci[n]);
-		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
-		if (next == 0) {
-			curr = ~(__u64)0; /* Terminator */
-			n++;
+	while (n < nci) {
+		cp = nilfs_cpfile_block_get_checkpoint(cpfile, curr, bh, kaddr);
+		curr = ~(__u64)0; /* Terminator */
+		if (unlikely(nilfs_checkpoint_invalid(cp) ||
+			     !nilfs_checkpoint_snapshot(cp)))
 			break;
-		}
+		nilfs_cpfile_checkpoint_to_cpinfo(cpfile, cp, &ci[n++]);
+		next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
+		if (next == 0)
+			break; /* reach end of the snapshot list */
+
 		next_blkoff = nilfs_cpfile_get_blkoff(cpfile, next);
 		if (curr_blkoff != next_blkoff) {
 			kunmap_atomic(kaddr, KM_USER0);
 			brelse(bh);
 			ret = nilfs_cpfile_get_checkpoint_block(cpfile, next,
 								0, &bh);
-			if (ret < 0)
+			if (unlikely(ret < 0)) {
+				WARN_ON(ret == -ENOENT);
 				goto out;
+			}
 			kaddr = kmap_atomic(bh->b_page, KM_USER0);
 		}
 		curr = next;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

