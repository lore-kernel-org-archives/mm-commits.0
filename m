Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257559;
	b=0OZFRdf149+33x9KxHjWPbqqdVy4ZXNnVqmz6wzhjeiiwJA1EouflevYXHesl4GXbCjz
	 fVbBvFeI/eAW0idcN0otq95e5YZQaNb4r7UaNJ4LNOo5y8UCQ4faGA7xc5x2rgttTBkoj
	 GFRrDwPvA2NLK68bMF8m+WET2L7KCQanx9xftbkoHIGMAs+VgWJz3sz5BYDQdhxozqtG/
	 UBZ0uGbqk3y0uIQF4OOgxqtGyt0N3sx4zMjKA2OYFxoEojjFGcsRJeqIL4FieRK+MgS3K
	 7GPLVai4OYJx6uxfqQGQ0+4AARinLmw2RBupJWJnldypjjPihNBDKwq63oNHy4cINAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257559;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=S82ERD+p7Bnx0De4ry5FjOtc/LklSi0SKzTnrnTGTZI=;
	b=UWLPNxycziDHKse8OvA8Owpk9I7z7R1zr5Ca0AOMhMsIRri6T4Xs9q+rJNvlya/czFcg
	 wnaDtWeRY7gwKQXiDY3rJCl/zbrzQp8Ve3A2iN50B5b//gEiLdwm+qpoYpXJMbW52SCq9
	 rSr7dX1Pgo1htspndbeyYulJlos2lLwXwV4BtvcmFBv4jJrnvQvgC1BsxaSLTyKKiwrST
	 WePmrjCax84zqfS1c9mNIY7n+O9Nm5L97ZMw9VuZrI7pl2mWeykSK/jdDqlJhZP//u92W
	 u5m/KaGdK34a7NGnjqBQxX5c1SkJH76a8LWJMYlX9GoyY0ZA/9i+GUp1FiN/vXy2SUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uRkI6VB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A91F606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uRkI6VB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167A01F008A1;
	Mon,  9 Nov 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257559;
	bh=S82ERD+p7Bnx0De4ry5FjOtc/LklSi0SKzTnrnTGTZI=;
	h=Date:To:From:Subject;
	b=uRkI6VB8IDni0Ym/u3MYrmkpOyHlgqVZ1diYsjmQRGvJhyGNbOPU3Fwvay6epbxd+
	 MgtR8dt1wBAJ1gQcNLnkhUkrxw3wkqhks8j/laWpn9iLEVvRzgV2KOpxjwdigt3HNy
	 11ICMJL1RjQkyKnAioBi+xpJ8aUjtMSARn7mG3z0=
Date: Mon, 09 Nov 2026 12:52:38 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-zero-nlink-or-mode-dinode-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205239.167A01F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the zero nlink or mode dinode check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-zero-nlink-or-mode-dinode-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-zero-nlink-or-mode-dinode-check.patch

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
Subject: ocfs2: abstract the zero nlink or mode dinode check
Date: Mon, 09 Nov 2026 20:20:52 +0800

ocfs2_validate_inode_block() open-codes the test for a dinode that has
no links or no mode.  Fold the condition into a predicate so it reads
like the neighbouring ocfs2_dinode_has_*() helpers, and so the filecheck
variant can share it.

Reuse ocfs2_read_links_count() rather than testing i_links_count and
i_links_count_hi separately.  OCFS2_LINKS_HI_SHIFT is 16 and both fields
are 16 bits wide, so the combined count is zero exactly when both raw
fields are zero.

The OCFS2_ORPHANED_FL carve-out moves into the predicate along with the
rest of the condition, in the same early-return style as
ocfs2_dinode_has_size_without_clusters().

The return code and the log message stay at the call site: filecheck
reports the same conditions with a different code and must not call
ocfs2_error().

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-3-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-zero-nlink-or-mode-dinode-check
+++ a/fs/ocfs2/inode.c
@@ -67,6 +67,21 @@ static int ocfs2_filecheck_validate_inod
 static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 						      struct buffer_head *bh);
 
+static bool ocfs2_dinode_has_zero_nlink_or_mode(struct ocfs2_dinode *di)
+{
+	/*
+	 * An open-unlinked inode legitimately has a zero link count on disk:
+	 * ocfs2_unlink() drops the last link and ocfs2_orphan_add() sets
+	 * OCFS2_ORPHANED_FL, while OCFS2_VALID_FL is only cleared later by
+	 * ocfs2_remove_inode().  DIO orphans keep their link count, so they
+	 * need no exemption here.
+	 */
+	if (le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL)
+		return false;
+
+	return !ocfs2_read_links_count(di) || !di->i_mode;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1482,15 +1497,7 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	/*
-	 * An open-unlinked inode legitimately has a zero link count on disk:
-	 * ocfs2_unlink() drops the last link and ocfs2_orphan_add() sets
-	 * OCFS2_ORPHANED_FL, while OCFS2_VALID_FL is only cleared later by
-	 * ocfs2_remove_inode().  DIO orphans keep their link count, so they
-	 * need no exemption here.
-	 */
-	if (!(le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
-	    ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode)) {
+	if (ocfs2_dinode_has_zero_nlink_or_mode(di)) {
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

