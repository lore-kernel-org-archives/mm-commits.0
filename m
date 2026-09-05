Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9819357D08
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 22:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788648388; cv=none; b=BGhJ+LIIRh0cFC3/05Pype/yahkhXrVPermNCQZoA2Tqan5V2PwOFs3nNgG96sHSdDDd27pZZ7mMS0nEtZXqtG5+65GC3sjsqVKjtdYZfj62Ax0LYcFNqANNZA2tfBH9L7k7hEslziv93nSx+zULN2UlFByR9i+qvwZ93ckeC4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788648388; c=relaxed/simple;
	bh=JaH9j/z8FE7NEG4mKRhG+Jbmfl01FtjdYMgcAiSYY5Y=;
	h=Date:To:From:Subject:Message-Id; b=ti6OIy35G2dUhqkyN31DTRGEXtKVMHvwIvJAouD5Ledr6d6B15ZpXPSTcUc6CXwDAnBs3p3QloBomvb3HDyJIlkoGo54eXGJ20CQNlr035zYjBrL6ZfVER07glu7rXOaKS1x7TI22c0jC9l/hm0fQReHSwKYmH8YpP0zebOgGwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TDm15tUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TDm15tUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6541F00A3D;
	Sat,  5 Sep 2026 22:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788648386;
	bh=bJa/N3Txziqf8h8pbnG6lh/dW2zcpyiJYKWbi+0DbYk=;
	h=Date:To:From:Subject;
	b=TDm15tUNnB386zMHCSN0fIbMiAS8Mv+xuthT2Se9UcoPrsjj/17o7qAfRQ7vQ/O/1
	 RlHMJjdkkmfoJpJ6f3tkRpA+Aa6nCy4SIbRrr1/Wno0dA1CJDu74y5wYjXw9M6KEvG
	 IcHfeDiFci9jzDuRimnqco9Os8fLGGwqa6nLOvWM=
Date: Sat, 05 Sep 2026 15:46:25 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20260905224626.4C6541F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate dl_blkno and dl_fs_generation of dir index leaf blocks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: validate dl_blkno and dl_fs_generation of dir index leaf blocks
Date: Sat, 5 Sep 2026 22:21:44 +0800

ocfs2_validate_dx_leaf() checks the checksum, the signature and the entry
list counts, but it never checks dl_blkno or dl_fs_generation.  The inode,
extent block, xattr block, refcount block and dir index root validators
all check the on-disk block number against bh->b_blocknr and the
generation against the superblock, and both dir index leaf fields are
documented as "Must match super block".

Without the checks, a stale dir index leaf block left on the device from a
previously formatted filesystem at the same physical block number can pass
validation as long as its signature, entry counts and checksum match.  Its
index entries would then be used in the new filesystem context.

Both fields are written unconditionally when a leaf block is formatted in
ocfs2_dx_dir_format_cluster(), from the live superblock generation and the
real block number, so a correctly formatted filesystem cannot trip the new
checks.  The leaf block number read back here comes from on-disk dir index
root extent records.

Reject dir index leaf blocks whose dl_blkno or dl_fs_generation does not
match, like the dir index root validator does.

Link: https://lore.kernel.org/20260905142144.2869105-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks
+++ a/fs/ocfs2/dir.c
@@ -733,6 +733,18 @@ static int ocfs2_validate_dx_leaf(struct
 		return ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
 				   7, dx_leaf->dl_signature);
 
+	if (le64_to_cpu(dx_leaf->dl_blkno) != bh->b_blocknr)
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has an invalid dl_blkno of %llu\n",
+				   (unsigned long long)bh->b_blocknr,
+				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno));
+
+	if (le32_to_cpu(dx_leaf->dl_fs_generation) != OCFS2_SB(sb)->fs_generation)
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has an invalid dl_fs_generation of #%u\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le32_to_cpu(dx_leaf->dl_fs_generation));
+
 	if (le16_to_cpu(dx_leaf->dl_list.de_count) !=
 	    ocfs2_dx_entries_per_leaf(sb))
 		return ocfs2_error(sb,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-make-ocfs2_calc_xattr_init-return-void.patch
ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch
ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch
ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch
ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch
ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch
ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch

