Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257557;
	b=sOK/cUkd7BsIEiqX4hpxPVPnPceAdqNbBwweJPTGUfFiwAkkro5o9lTxRKStvVVWdc8x
	 zMG3nILgbS0euTKuUABekk6ObrUVWcPgIM1JwllUewq+sebYUgpFiKFh0/rhPE71yLZDW
	 V8JSvPiqiUrjpyLLd5aQp1OyyB9G0NdZ8dZnQDnhcU4Kp69afvgBWyn0Gl/TyXf5tu38y
	 MkbQLc8npYmB81+ykpE6DErZsz6YBHC8ii5rhIAO8hBFsNn3Vy5vH7zyjhtU/YI+EuU0B
	 0a04xYaKTRH0WGo5zx6xYRybeMGBgvJl7WgUkMA+6Rhd3erotSwYxxLHY8au6P+bnnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257557;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jK3gW96S1wGDoHyQsd45k8iH1p1JFzQBS6eGY30RdsY=;
	b=fXwmwyZ5x5xh1B1AOQwYmSJIO2vfQr3nnAKmzTyziFfxPQhNWl1gkm0XqdSWE7xU1a21
	 2SzvxUIyZlG1z5YVdo6rJC1ENNJWFDnyUXWskj9A7dxFIHvMXe9+Ra7uRzf17bYdbgqIv
	 41DIRmCvAN+nr33mn6ZI4E6SlXlWFCwrV06+BX6MdZ62LlQ+ihAThOu0VuLDeCORW9jIR
	 DXnVpnntoKZgnVEGJmgzxWOdaeOM7+LHORMbMu9jMoqdh8UQrBmXlA6o+wQJrAo5V4VTq
	 4/N5u5k6ro4QdkZrZVG1Qi7F1MvtwfN0cg/rkT34woeK+m4M4Zu6kfObZ48R7tOfJAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E5Jdy7h5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D108606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E5Jdy7h5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86E01F0089F;
	Mon,  9 Nov 2026 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257556;
	bh=jK3gW96S1wGDoHyQsd45k8iH1p1JFzQBS6eGY30RdsY=;
	h=Date:To:From:Subject;
	b=E5Jdy7h5piIhy/Rwdq7srM+6RpcE7e0WUOWR4TyVOxAPuVJyP2Ot5XYF/0S2I+JpT
	 jGkwtxtIagV08U/h5GNIsVAaBeMzlypaJp7rNhJdW+AEU/5Cyv4AqQ3JHUWgbvSQfn
	 PcwSG8OVL4YxL6Gjxqt3V85Q+jcOL1dnxVYc6g40=
Date: Mon, 09 Nov 2026 12:52:36 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-exempt-orphaned-dinodes-from-the-zero-nlink-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205236.C86E01F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: exempt orphaned dinodes from the zero nlink check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-exempt-orphaned-dinodes-from-the-zero-nlink-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-exempt-orphaned-dinodes-from-the-zero-nlink-check.patch

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
Subject: ocfs2: exempt orphaned dinodes from the zero nlink check
Date: Mon, 09 Nov 2026 20:20:51 +0800

Patch series "ocfs2: split dinode validation into shared predicates", v3.

ocfs2_validate_inode_block() is a flat sequence of about twenty open-coded
dinode checks.  The filecheck variant duplicates eight of them but reports
differently: mlog() plus an OCFS2_FILECHECK_ERR_* code instead of
ocfs2_error(), which can force the filesystem read-only.  The duplicated
conditions had drifted apart, and filecheck silently skipped the rest.

Patch series summary

  01      Bug fix.  Exempt orphaned dinodes from the zero nlink check.
          An open-unlinked inode legitimately has nlink 0 on disk with
          OCFS2_VALID_FL still set, so the check rejects valid inodes.
          Orphan recovery then skips the resulting bad inode, so the
          orphan is never wiped and its space leaks.  Fixed at the root
          first, so the refactor stays behaviour preserving.

  02-21   Pure refactor, one check per commit.  Each condition becomes a
          static bool ocfs2_dinode_has_*() predicate, following the four
          helpers already in inode.c.  Return codes and log messages stay
          at the call sites, so no ocfs2_error() call site moves and the
          two reporting paths remain distinct.

  22      Bug fix.  filecheck fix reported SUCCESS on corruption it cannot
          repair.  Revalidate and return the residual code, snapshotting
          the block before validation so a failed repair rolls back to
          what was read from disk instead of leaving a dirty buffer or a
          stray ecc fixup behind.

  23-31   Wire the remaining predicates into filecheck.  All reuse
          OCFS2_FILECHECK_ERR_INVALIDINO, so no new error code and no
          change to the userspace-visible names in ocfs2_filecheck_errs[].

The inline xattr check is still not shared: ocfs2_validate_inode_xattr()
calls ocfs2_error() through its helpers in xattr.c, so reusing it needs a
reporting flag threaded into that file.  Left for a follow-up.

Testing

linux-next 20261105, in a QEMU guest running the series.  Block device
buffers are flushed and caches dropped before each remount and before
each on-disk comparison, otherwise a corruption test can read a stale
buffer and appear to pass.

  - Refactor is behaviour preserving: all 27 messages, all return codes
    and all ocfs2_error()/mlog() call sites in the normal validator are
    unchanged, each predicate body was compared against the condition it
    replaced, and filecheck's disassembly is instruction identical apart
    from __LINE__.  The normal validator's disassembly also shows block
    rescheduling, so equivalence there rests on the source comparison
    rather than an instruction by instruction proof.

  - No false positives on 4K blocks with inline-data, refcount, sparse,
    usrquota, grpquota, xattr and indexed-dirs, over seventeen inode types
    plus all system inodes during mount and I/O; and on 512-byte blocks
    over five types.  Forcing i_xattr_inline_size up on 512-byte blocks
    drove the inline maximum negative and gave "id_count 312 exceeds max
    -88", confirming the comparison stayed signed.

  - Seven corrupted dinodes on a nometaecc volume were each detected with
    the expected message, with no escalation and the filesystem still
    read-write.

  - With metaecc on: a repairable field alone gives SUCCESS and is really
    written to disk; an unrepairable field alone, and a repairable plus
    unrepairable pair, both give INVALIDINO with the on-disk block byte
    identical afterwards and repeated checks reporting a real filecheck
    code rather than FAILED.  An orphaned dinode with nlink 0 reports
    SUCCESS, while the same dinode without OCFS2_ORPHANED_FL still reports
    INVALIDINO, so the exemption did not disable the check.

  - The stray bit ocfs2_block_check_validate() leaves behind when its
    hamming fixup fails was tested with a python model of that fixup,
    validated by checking it predicts the exact bit and the exact restored
    block for 99 single bit corruptions.  With the flip aimed at an
    unchecked timestamp byte, fix gives SUCCESS and the on-disk block
    matches the predicted repair byte for byte, differing from the input
    image only in i_blkno and i_check.  With the flip aimed at
    i_suballoc_slot, fix gives SUCCESS and repairs the ecc.  A recoverable
    single bit gives SUCCESS, increments ecc_recoveries and writes nothing
    back, so the legitimate in-place fixup is kept rather than rolled
    back.

The ocfs2 testsuite and xfstests were not run.

Link to v1: https://lore.kernel.org/ocfs2-devel/20261105094926.3203416-1-joseph.qi@linux.alibaba.com/
Link to v2: https://lore.kernel.org/ocfs2-devel/20261106111458.1467464-1-joseph.qi@linux.alibaba.com/


This patch (of 31):

An open-unlinked inode legitimately has a zero link count on disk.
ocfs2_unlink() drops the last link and writes it out with
ocfs2_set_links_count(), ocfs2_orphan_add() then sets OCFS2_ORPHANED_FL,
and OCFS2_VALID_FL is only cleared much later by ocfs2_remove_inode().
The zero nlink check added by the commit below rejects such an inode as
-EFSCORRUPTED even though it is perfectly valid.

That commit describes its own change as a check for "(i_mode == 0,
i_nlink == 0, non-orphan)", but the code it added has no orphan exemption
and ORs the two conditions rather than ANDing them, so a zero link count
alone is enough to fail even when i_mode is valid.  Add the exemption the
changelog describes.

Orphan recovery hits this on every pass.  OCFS2_FI_FLAG_ORPHAN_RECOVERY
clears can_lock in ocfs2_read_locked_inode(), so the block is read with
ocfs2_read_blocks_sync() and then validated by the explicit
ocfs2_validate_inode_block() call in that branch.  The read helper having
no validate callback of its own does not mean the path skips validation.
ocfs2_orphan_filldir() then ignores the resulting ocfs2_iget() failure
("Skip bad inodes so that recovery can continue"), so the orphan is never
wiped: its space is leaked permanently and the "Corrupt state" message is
logged again on every mount.

The same applies to an orphaned dinode read through
ocfs2_read_inode_block(), for example from ocfs2_delete_inode() once the
buffer has been evicted.

Note that a zero i_mode is already rejected by the later
ocfs2_valid_inode_mode() check, since fs_umode_to_ftype(0) is FT_UNKNOWN,
so the nlink arm was not what protected against the zombie inode the
original commit was fixing.

DIO orphans need no exemption: ocfs2_add_inode_to_orphan() is the only
caller that passes dio=true to ocfs2_orphan_add(), and it never drops a
link, so those inodes keep a positive link count.

Link: https://lore.kernel.org/20261109122121.21473-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20261109122121.21473-2-joseph.qi@linux.alibaba.com
Fixes: 7efb45f9685f ("ocfs2: invalidate inode if i_mode is zero after block read")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/inode.c~ocfs2-exempt-orphaned-dinodes-from-the-zero-nlink-check
+++ a/fs/ocfs2/inode.c
@@ -1482,7 +1482,15 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
+	/*
+	 * An open-unlinked inode legitimately has a zero link count on disk:
+	 * ocfs2_unlink() drops the last link and ocfs2_orphan_add() sets
+	 * OCFS2_ORPHANED_FL, while OCFS2_VALID_FL is only cleared later by
+	 * ocfs2_remove_inode().  DIO orphans keep their link count, so they
+	 * need no exemption here.
+	 */
+	if (!(le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+	    ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode)) {
 		mlog(ML_ERROR, "Invalid dinode #%llu: "
 			"Corrupt state (nlink = %u or mode = %u) detected!\n",
 		        (unsigned long long)bh->b_blocknr,
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

