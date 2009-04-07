From: akpm@linux-foundation.org
Subject: [merged] nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:29 -0700
Message-ID: <200904071909.n37J9TWi012388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758474AbZDGTLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: fix buggy behavior seen in enumerating checkpoints
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: fix buggy behavior seen in enumerating checkpoints
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This will fix the weird behavior of lscp command in listing continuously
created checkpoints; the output of lscp is rewinded regularly for the
recent nilfs.  As a result of debugging, a defect was found in
nilfs_cpfile_do_get_cpinfo() function.

Though the function can be repeatedly called to enumerate checkpoints and
it can skip invalid checkpoint entries, the index value was not carried
between successive calls.

The bug has long been present, and came to surface after applying a bugfix
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch, which increased
frequency of calling the function.  The similar bugfix was already applied
for ``snapshots'' by
nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch.

This fixes the problem by making the index argument bidirectional on the
function.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/nilfs2/cpfile.c~nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints
+++ a/fs/nilfs2/cpfile.c
@@ -382,13 +382,13 @@ static void nilfs_cpfile_checkpoint_to_c
 	ci->ci_next = le64_to_cpu(cp->cp_snapshot_list.ssl_next);
 }
 
-static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 cno,
+static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
 					  struct nilfs_cpinfo *ci, size_t nci)
 {
 	struct nilfs_checkpoint *cp;
 	struct buffer_head *bh;
 	size_t cpsz = NILFS_MDT(cpfile)->mi_entry_size;
-	__u64 cur_cno = nilfs_mdt_cno(cpfile);
+	__u64 cur_cno = nilfs_mdt_cno(cpfile), cno = *cnop;
 	void *kaddr;
 	int n, ret;
 	int ncps, i;
@@ -416,6 +416,8 @@ static ssize_t nilfs_cpfile_do_get_cpinf
 	}
 
 	ret = n;
+	if (n > 0)
+		*cnop = ci[n - 1].ci_cno + 1;
 
  out:
 	up_read(&NILFS_MDT(cpfile)->mi_sem);
@@ -510,7 +512,7 @@ ssize_t nilfs_cpfile_get_cpinfo(struct i
 {
 	switch (mode) {
 	case NILFS_CHECKPOINT:
-		return nilfs_cpfile_do_get_cpinfo(cpfile, *cnop, ci, nci);
+		return nilfs_cpfile_do_get_cpinfo(cpfile, cnop, ci, nci);
 	case NILFS_SNAPSHOT:
 		return nilfs_cpfile_do_get_ssinfo(cpfile, cnop, ci, nci);
 	default:
@@ -526,13 +528,14 @@ ssize_t nilfs_cpfile_get_cpinfo(struct i
 int nilfs_cpfile_delete_checkpoint(struct inode *cpfile, __u64 cno)
 {
 	struct nilfs_cpinfo ci;
+	__u64 tcno = cno;
 	ssize_t nci;
 	int ret;
 
 	/* checkpoint number 0 is invalid */
 	if (cno == 0)
 		return -ENOENT;
-	nci = nilfs_cpfile_do_get_cpinfo(cpfile, cno, &ci, 1);
+	nci = nilfs_cpfile_do_get_cpinfo(cpfile, &tcno, &ci, 1);
 	if (nci < 0)
 		return nci;
 	else if (nci == 0 || ci.ci_cno != cno)
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

