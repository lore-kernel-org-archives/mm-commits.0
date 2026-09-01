Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A01748822D;
	Tue,  1 Sep 2026 17:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283335; cv=none; b=aSlhPLLEjzMNggro3P86gHKJzVYRHlaIJp/rKT0drO/NIpR/o9HeEitax01p3zEvl/xu3xG+kgGS8CHWPHbVXSYP3vyECrTnD4CTT8qtFweNyu9Orh4XnVjFXciSvvjChel4aSJdYF4CXS6P1h9BOawnAA6tAA5RykN93CQqh7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283335; c=relaxed/simple;
	bh=9unBUaZaf0htxmKEriMfDuhViwVlkmHR05o3hKR4QXA=;
	h=Date:To:From:Subject:Message-Id; b=b570m1EWSFxv7bbJ8tVjMIqi1A6e2GsnOY5Ke7XqjvqtDay8lF8VSUNh3gbq6xQmPOvprHjQaotarUHp8Wr6juJ5hLrsbT7tJhNsR+nkOi/E0zl+lKTHzRyPLqlKbgG/a3nPTyjUraQruFCAEpvNYQhSqfxkBhAR3v46QHg0ntY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHHIJn6m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHHIJn6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417221F000E9;
	Tue,  1 Sep 2026 17:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283333;
	bh=5VC9Wc33hEadvCsBxhOk95iNrTbUDm1o0XCFT2ShQ+U=;
	h=Date:To:From:Subject;
	b=AHHIJn6mjA+B5X4rDkShHuQzhU1Tp1SOJI7MOc4GEa2NNOg7v50O8Njq9aU1KgXnl
	 5CVUb+Iun9cHAKPr5m5xno0VF1xNownPPFOywTVJex0cRrpererZAwcNqQRU84eNAm
	 RsVmXOXeNnIUrpqTKcDNaHelabSqihzwzm75KRNA=
Date: Tue, 01 Sep 2026 10:22:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch added to mm-nonmm-unstable branch
Message-Id: <20260901172213.417221F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch

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
Subject: ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes
Date: Tue, 1 Sep 2026 20:52:18 +0800

Patch series "ocfs2: validate suballoc slot and bit of metadata blocks", v3.

The ocfs2 metadata validators trust the on-disk suballoc slot and bit
without checking them against the slot range of the mounted filesystem and
the capacity of the block group bitmap.  A corrupted image can carry
OCFS2_INVALID_SLOT or another out-of-range slot, or a suballoc bit beyond
the bitmap, and once the corresponding inode, extent block, xattr block,
dir index root or refcount block gets freed, the bad value goes straight
into ocfs2_get_system_file_inode() or _ocfs2_free_suballoc_bits() and hits
a BUG_ON() or runs off the end of local_system_inodes[].

This series rejects such values at read time, in the existing validators,
so corrupted objects fail with -EROFS (and a read-only remount) instead of
crashing:

  patch 1 restricts OCFS2_INVALID_SLOT dinodes to system inodes,
        completing fe7a283b3916 ("ocfs2: add suballoc slot check in
        ocfs2_validate_inode_block()"), and turns the "system file
        state is ambiguous" BUG_ON() in ocfs2_read_locked_inode() into
        an ocfs2_error();
  patch 2 rejects oversized dinode suballoc bits;
  patch 3 validates the suballoc slot and bit of xattr and dir index
        blocks;
  patch 4 validates the suballoc slot and bit of extent and refcount
        blocks.

The checks only enforce what the kernel and mkfs.ocfs2 already write: a
valid slot from meta_ac->ac_alloc_slot and a bit within the block group
bitmap, with system inodes carrying OCFS2_INVALID_SLOT plus
OCFS2_SYSTEM_FL and extent blocks using slot 0.  Nothing changes for
healthy filesystems.

Each new check was exercised under QEMU by corrupting the field in
question with an out-of-range value; with the series applied the access
fails with -EROFS and the filesystem remounts read-only instead of hitting
the BUG_ON().


This patch (of 4):

ocfs2_validate_inode_block() currently permits i_suballoc_slot to be
OCFS2_INVALID_SLOT for any dinode.  Only system inodes created by
mkfs.ocfs2 are allocated from the global allocator and thus legitimately
carry this value; regular inodes are always allocated from a per-slot
suballocator and hence must have a valid slot.

If a corrupted regular inode with OCFS2_INVALID_SLOT is accepted,
ocfs2_remove_inode() will pass the slot to ocfs2_get_system_file_inode()
and get_local_system_inode() will hit BUG_ON(slot == OCFS2_INVALID_SLOT)
when the inode is deleted.  This can be triggered by an unprivileged user
unlinking such a corrupted file.

Reject OCFS2_INVALID_SLOT for non-system dinodes during validation, while
still accepting it for system inodes.  Note that a crafted dinode carrying
OCFS2_SYSTEM_FL passes the check above, yet a plain lookup of it still
used to BUG() in ocfs2_read_locked_inode() ("system file state is
ambiguous").  Since i_flags comes from disk, handle that mismatch with
ocfs2_error() instead of BUG_ON() as well.

Link: https://lore.kernel.org/20260901125221.1634686-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20260901125221.1634686-2-joseph.qi@linux.alibaba.com
Fixes: fe7a283b3916 ("ocfs2: add suballoc slot check in ocfs2_validate_inode_block()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes
+++ a/fs/ocfs2/inode.c
@@ -638,14 +638,18 @@ static int ocfs2_read_locked_inode(struc
 	fe = (struct ocfs2_dinode *) bh->b_data;
 
 	/*
-	 * This is a code bug. Right now the caller needs to
-	 * understand whether it is asking for a system file inode or
-	 * not so the proper lock names can be built.
-	 */
-	mlog_bug_on_msg(!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
-			!!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE),
-			"Inode %llu: system file state is ambiguous\n",
-			(unsigned long long)args->fi_blkno);
+	 * The caller must know whether it is asking for a system file inode
+	 * or not so the proper lock names can be built.  Since i_flags comes
+	 * from disk, a mismatch is filesystem corruption instead of a code
+	 * bug, so handle it with ocfs2_error() rather than BUG_ON().
+	 */
+	if (!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
+	    !!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE)) {
+		status = ocfs2_error(osb->sb,
+				     "Inode %llu: system file state is ambiguous\n",
+				     (unsigned long long)args->fi_blkno);
+		goto bail;
+	}
 
 	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
 	    S_ISBLK(le16_to_cpu(fe->i_mode)))
@@ -1520,8 +1524,23 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
-	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+	/*
+	 * Only system inodes created by mkfs.ocfs2 are allocated from the
+	 * global allocator and thus legitimately carry OCFS2_INVALID_SLOT.
+	 * Regular inodes are always allocated from a per-slot suballocator.
+	 * If a regular inode with OCFS2_INVALID_SLOT was accepted here,
+	 * deleting it would pass the slot to get_local_system_inode() via
+	 * ocfs2_remove_inode() and trigger BUG_ON(slot == OCFS2_INVALID_SLOT).
+	 */
+	if (le16_to_cpu(di->i_suballoc_slot) == (u16)OCFS2_INVALID_SLOT) {
+		if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: suballoc slot %u for non-system inode\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(di->i_suballoc_slot));
+			goto bail;
+		}
+	} else if ((u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_suballoc_slot));
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch

