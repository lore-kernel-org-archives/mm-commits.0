From: akpm@linux-foundation.org
Subject: + nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch added to -mm tree
Date: Tue, 10 Feb 2009 16:27:34 -0800
Message-ID: <200902110027.n1B0RY6I001603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755600AbZBKA1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 19:27:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: fix buggy behavior seen in enumerating checkpoints
has been added to the -mm tree.  Its filename is
     nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch

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
@@ -504,7 +506,7 @@ ssize_t nilfs_cpfile_get_cpinfo(struct i
 {
 	switch (mode) {
 	case NILFS_CHECKPOINT:
-		return nilfs_cpfile_do_get_cpinfo(cpfile, *cnop, ci, nci);
+		return nilfs_cpfile_do_get_cpinfo(cpfile, cnop, ci, nci);
 	case NILFS_SNAPSHOT:
 		return nilfs_cpfile_do_get_ssinfo(cpfile, cnop, ci, nci);
 	default:
@@ -520,13 +522,14 @@ ssize_t nilfs_cpfile_get_cpinfo(struct i
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

