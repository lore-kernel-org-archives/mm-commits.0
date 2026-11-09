Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257604;
	b=2O6VVIMG6nIl/p8XKwZueb6Cj0lb4HUzk8gu5WtBBUuk95GspBaTBdutAkuVF5gHZwCk
	 k6kUedfYZRhbA+vaZW57E4fgTtuKgdOlP41dxRGRbjvPzmsYdxwp7yBD3EgIVBp+COnyk
	 Ev0Fe7Z3CxsZ4Pwq7rVc+jJsigqwLvEDeMX7s0ZaAilj4dwuf09gLY77qZIX4xeYjFA1n
	 yon1vn6xUGDr5lfZjbkRUZzlQvr2Tn154aep+ffIVuV+HXX3LP+VRXxEys/OWcKyzwzNw
	 kerI2ALMSyuSp7sJRfFGKnDfGs3+M70mJMGqO7Sm5lFxMJaK/eTi7uiFi0F0p2HM86Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257604;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=V5unIxjvMVBEpci/hVhiezUDOP43IanApQKsHJh4Fio=;
	b=AZZlLkZ/Tm0E9MSBke4OSAXtNVqc3atBNTY1NKZ52IRWcvIMIFvi8S/vWx+8Wl8XtKgR
	 ec5gowtShgD+Y1VYfjdwQPFN34ZZ8JGtLQeGbVUpA8FEF7muuHdqXq2Yr7MB68qDnY5Ep
	 C/y+zt4CgBKe7zVpW6qB6idD9fH7cs/pMhfMydJe3yxlEDSqZ6YuwKtCu+1Yyzxd0XYuK
	 YM7SuNMz8s8TTTJrq9VvtrfSl4QqtlCJ7HRLwmiGGS7Em41p6MKDITP3E2hKNyI6N3HEj
	 8A/IVkqkDiRMkX95GKMnVeOYaS02BiE8cLsCnhqyb5//pbeMea0Ls0EOcHoijQpf52g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Qr2C8aaZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94051606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Qr2C8aaZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0E11F0089F;
	Mon,  9 Nov 2026 20:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257603;
	bh=V5unIxjvMVBEpci/hVhiezUDOP43IanApQKsHJh4Fio=;
	h=Date:To:From:Subject;
	b=Qr2C8aaZFlSaZGpww0+JhlAqbK9HqaTSrcxbAS5P3IuwrWYCSd6PO/c82k0O9dPuz
	 oJj9UTMX3OnfNiVXZQT/wS01dKc4hcP8yvAoHO71YklOXFDskZEpI+iezr9DN4mpRM
	 /t081TA3j5vG83ofgeJen+DhI9QzzbAx8N+gRSmA=
Date: Mon, 09 Nov 2026 12:53:22 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-report-unrepairable-corruption-from-online-filecheck-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205323.5D0E11F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: report unrepairable corruption from online filecheck fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-report-unrepairable-corruption-from-online-filecheck-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-report-unrepairable-corruption-from-online-filecheck-fix.patch

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
Subject: ocfs2: report unrepairable corruption from online filecheck fix
Date: Mon, 09 Nov 2026 20:21:12 +0800

ocfs2_filecheck_repair_inode_block() proceeds when validation fails but
then returns 0 unconditionally, after repairing only i_blkno,
fs_generation and l_next_free_rec.  An inode failing any other check is
reported to userspace as SUCCESS while still corrupt.  Revalidate after
the repairs and return the residual code.
Documentation/filesystems/ocfs2-online-filecheck.rst already describes
this: "the inode must first be checked for errors before performing a
final fix".

Returning an error from the validate callback is not free, though.
ocfs2_read_blocks() clears BH_Uptodate on failure, and
ocfs2_read_locked_inode() bails out before upgrading the cluster lock to
exclusive and calling ocfs2_write_block().  Simply revalidating at the
end would therefore leave a dirty non-uptodate buffer in the block device
cache: the next OCFS2_BH_IGNORE_CACHE read of that block sees
buffer_dirty(), skips submitting the read, and then fails -EIO on
!buffer_uptodate(), so later filecheck requests report FAILED instead of
the real reason.  The half repaired dinode, stamped with a freshly
computed ecc, would also be flushed by generic writeback without the
exclusive cluster lock.

Snapshot the block instead and only mark it dirty once the repaired
dinode validates.  On residual failure restore the snapshot and return
the error with the buffer clean, so the next read goes to disk as usual.
Every early return restores it too, including the readonly and jbd gates.

Take the snapshot before the initial validation rather than after it.
ocfs2_validate_meta_ecc() -> ocfs2_block_check_validate() applies a
hamming fixup in place and restores only the ocfs2_block_check field on
the way out, so when the post-fix crc32 still fails the flipped bit stays
in bh->b_data and a later snapshot would record it.  Undo that flip
before repairing fields when the initial validation reported BLOCKECC:
the fixup did not produce a crc32 valid block, so the bit is bogus and
recomputing the ecc over it would stamp the corruption with a valid
checksum.  An ecc check that passed leaves good data behind, a successful
single bit fixup included, and is kept.

The ecc is recomputed before revalidating, otherwise a bad ecc would
always fail the revalidation and roll back the ecc repair itself.  Whether
it needs recomputing is taken from the initial validation's error code
rather than a second ocfs2_validate_meta_ecc() call, since any field
repair invalidates the ecc anyway.

Also guard the l_next_free_rec repair with a valid l_count.  Copying a
zero or oversized l_count into l_next_free_rec spread the corruption to a
second field and stamped it with a good ecc.

Inodes failing an unrepairable check now report INVALIDINO instead of
SUCCESS.  No new error code is introduced, so ocfs2_filecheck_errs[] and
its userspace-visible names are unchanged.  A failed repair no longer
leaves any modification behind, and revalidation runs the ecc check a
second time, which increments osb_ecc_stats again and emits a second
ocfs2_filecheck_validate_inode_block trace event per fix request.

Link: https://lore.kernel.org/20261109122121.21473-23-joseph.qi@linux.alibaba.com
Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/inode.c |   85 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-report-unrepairable-corruption-from-online-filecheck-fix
+++ a/fs/ocfs2/inode.c
@@ -2062,9 +2062,25 @@ static int ocfs2_filecheck_repair_inode_
 {
 	int changed = 0;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
+	void *orig;
+	int rc;
 
-	if (!ocfs2_filecheck_validate_inode_block(sb, bh))
-		return 0;
+	/*
+	 * Snapshot the whole block before validating it, and keep the snapshot
+	 * until the repair is known to be good.  ocfs2_validate_meta_ecc()
+	 * mutates the block in place while attempting a hamming fix and leaves
+	 * the flipped bit behind when the crc32 still fails, so a snapshot
+	 * taken afterwards would record that stray flip rather than what was
+	 * read from disk.  A field by field undo would not restore it either.
+	 */
+	orig = kmalloc(sb->s_blocksize, GFP_NOFS);
+	if (!orig)
+		return -OCFS2_FILECHECK_ERR_FAILED;
+	memcpy(orig, bh->b_data, sb->s_blocksize);
+
+	rc = ocfs2_filecheck_validate_inode_block(sb, bh);
+	if (!rc)
+		goto out_free;
 
 	trace_ocfs2_filecheck_repair_inode_block(
 		(unsigned long long)bh->b_blocknr);
@@ -2074,7 +2090,8 @@ static int ocfs2_filecheck_repair_inode_
 		     "Filecheck: cannot repair dinode #%llu "
 		     "on readonly filesystem\n",
 		     (unsigned long long)bh->b_blocknr);
-		return -OCFS2_FILECHECK_ERR_READONLY;
+		rc = -OCFS2_FILECHECK_ERR_READONLY;
+		goto out_restore;
 	}
 
 	if (buffer_jbd(bh)) {
@@ -2082,21 +2099,35 @@ static int ocfs2_filecheck_repair_inode_
 		     "Filecheck: cannot repair dinode #%llu, "
 		     "its buffer is in jbd\n",
 		     (unsigned long long)bh->b_blocknr);
-		return -OCFS2_FILECHECK_ERR_INJBD;
+		rc = -OCFS2_FILECHECK_ERR_INJBD;
+		goto out_restore;
 	}
 
 	if (!OCFS2_IS_VALID_DINODE(di)) {
 		/* Cannot fix invalid inode block */
-		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto out_restore;
 	}
 
 	if (ocfs2_dinode_has_no_valid_flag(di)) {
 		/* Cannot just add VALID_FL flag back as a fix,
 		 * need more things to check here.
 		 */
-		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
+		rc = -OCFS2_FILECHECK_ERR_VALIDFLAG;
+		goto out_restore;
 	}
 
+	/*
+	 * A failed ecc check means the hamming fixup did not produce a crc32
+	 * valid block, so the bit it flipped is bogus.  Undo that before
+	 * repairing fields, otherwise the ecc recompute below would stamp the
+	 * stray flip with a valid checksum and write it out.  An ecc check that
+	 * passed leaves good data behind, a successful single bit fixup
+	 * included, and must be kept.
+	 */
+	if (rc == -OCFS2_FILECHECK_ERR_BLOCKECC)
+		memcpy(bh->b_data, orig, sb->s_blocksize);
+
 	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
@@ -2115,7 +2146,14 @@ static int ocfs2_filecheck_repair_inode_
 		     le32_to_cpu(di->i_fs_generation));
 	}
 
+	/*
+	 * Only copy l_count into l_next_free_rec when l_count itself is
+	 * sane, otherwise the repair would spread the corruption to a
+	 * second field and stamp it with a freshly computed ecc.
+	 */
 	if (ocfs2_dinode_has_extents(di) &&
+	    !ocfs2_dinode_has_zero_extent_count(di) &&
+	    !ocfs2_dinode_has_oversized_extent_count(sb, di) &&
 	    ocfs2_dinode_has_bad_extent_next_free(di)) {
 		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
 		changed = 1;
@@ -2125,15 +2163,44 @@ static int ocfs2_filecheck_repair_inode_
 		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
 	}
 
-	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
+	/*
+	 * Recompute the ecc before revalidating, but do not mark the buffer
+	 * dirty yet.  The initial validation already told us whether the ecc
+	 * was bad, and any field repair above invalidates it anyway.
+	 */
+	if (changed || rc == -OCFS2_FILECHECK_ERR_BLOCKECC) {
 		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
-		mark_buffer_dirty(bh);
 		mlog(ML_ERROR,
 		     "Filecheck: reset dinode #%llu: compute meta ecc\n",
 		     (unsigned long long)bh->b_blocknr);
 	}
 
-	return 0;
+	/*
+	 * Only i_blkno, fs_generation and l_next_free_rec are repairable, so
+	 * report whatever is still wrong instead of claiming success.
+	 *
+	 * Validate before dirtying.  ocfs2_read_blocks() clears BH_Uptodate
+	 * when the validate callback fails, and a dirty non-uptodate buffer
+	 * left in the block device cache makes every later
+	 * OCFS2_BH_IGNORE_CACHE read of this block skip the disk read and
+	 * fail with -EIO.  ocfs2_read_locked_inode() also bails out before
+	 * upgrading to an exclusive cluster lock and writing the block, so
+	 * the repair would be flushed later without that lock.  Roll back
+	 * instead, leaving the buffer clean.
+	 */
+	rc = ocfs2_filecheck_validate_inode_block(sb, bh);
+	if (rc)
+		goto out_restore;
+
+	mark_buffer_dirty(bh);
+	goto out_free;
+
+out_restore:
+	/* Leave the buffer exactly as it was read from disk. */
+	memcpy(bh->b_data, orig, sb->s_blocksize);
+out_free:
+	kfree(orig);
+	return rc;
 }
 
 static int
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-exempt-orphaned-dinodes-from-the-zero-nlink-check.patch
ocfs2-abstract-the-zero-nlink-or-mode-dinode-check.patch
ocfs2-abstract-the-dinode-i_blkno-mismatch-check.patch
ocfs2-abstract-the-dinode-ocfs2_valid_fl-check.patch
ocfs2-abstract-the-dinode-fs_generation-mismatch-check.patch
ocfs2-abstract-the-dinode-suballoc-slot-checks.patch
ocfs2-abstract-the-dinode-suballoc-bit-check.patch
ocfs2-abstract-the-dinode-orphaned-slot-check.patch
ocfs2-abstract-the-dinode-dio-orphaned-slot-check.patch
ocfs2-abstract-the-inline-data-dinode-guard-and-cluster-check.patch
ocfs2-abstract-the-inline-data-id_count-bound-check.patch
ocfs2-abstract-the-inline-data-i_size-bound-check.patch
ocfs2-abstract-the-fast-symlink-dinode-guard-and-size-check.patch
ocfs2-abstract-the-fast-symlink-nul-termination-check.patch
ocfs2-abstract-the-chain-list-dinode-guard-and-count-check.patch
ocfs2-abstract-the-chain-list-next-free-record-check.patch
ocfs2-abstract-the-chain-list-bits-per-cluster-check.patch
ocfs2-abstract-the-dinode-refcount-location-check.patch
ocfs2-abstract-the-zero-extent-list-count-check.patch
ocfs2-abstract-the-oversized-extent-list-count-check.patch
ocfs2-abstract-the-extent-list-next-free-record-check.patch
ocfs2-report-unrepairable-corruption-from-online-filecheck-fix.patch
ocfs2-check-dinode-nlink-and-mode-in-online-filecheck.patch
ocfs2-check-dinode-suballoc-slot-in-online-filecheck.patch
ocfs2-check-dinode-suballoc-bit-in-online-filecheck.patch
ocfs2-check-dinode-orphaned-slots-in-online-filecheck.patch
ocfs2-check-inline-data-dinodes-in-online-filecheck.patch
ocfs2-check-fast-symlink-dinodes-in-online-filecheck.patch
ocfs2-check-chain-list-dinodes-in-online-filecheck.patch
ocfs2-check-dinode-refcount-location-in-online-filecheck.patch
ocfs2-check-extent-list-dinodes-in-online-filecheck.patch

