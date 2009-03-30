From: akpm@linux-foundation.org
Subject: + nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:01:50 -0700
Message-ID: <200903302301.n2UN1oij016253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697AbZC3XDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: fix improper return values of nilfs_get_cpinfo ioctl
has been added to the -mm tree.  Its filename is
     nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl.patch

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
nilfs2-segment-buffer-fix.patch
nilfs2-segment-constructor.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault-fix-page_mkwrite-error-cases.patch
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
nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl.patch
nilfs2-clean-up-indirect-function-calling-conventions.patch
nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch
nilfs2-remove-timedwait-ioctl-command.patch
nilfs2-use-fixed-sized-types-for-ioctl-structures.patch
nilfs2-remove-compat-ioctl-code.patch
nilfs2-use-unlocked_ioctl.patch
nilfs2-extend-nilfs_sustat-ioctl-struct.patch
nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch
nilfs2-super-block-operations-fix-endian-bug.patch
nilfs2-clean-up-sketch-file.patch
nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch
nilfs2-simplify-handling-of-active-state-of-segments.patch
nilfs2-introduce-secondary-super-block.patch
nilfs2-introduce-secondary-super-block-fix.patch
nilfs2-support-nanosecond-timestamp.patch

