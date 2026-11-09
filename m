Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257564;
	b=oFnGBxobS5AAgkiqVEP854VXG7L1S9qZmYlznH3AgbYMGGezGZvnB4p3LVxZ7sM0IDyx
	 6D8QhOUGkYKzQFG1Aa9eB2leKQqeteENTrUpNd8XRZAaTdXOI3WNyggxDr4qJL6zx6b6m
	 9yORfBtFPqN5z8Omp59r919v/3TFsB+xG50jqNHtUpGb8mGN/IjbqrcYKIOkRx3tXcLaQ
	 AcyQBjmqYwfBFbAjalMy5fiJY/HKY3dLGNs1MPxsPojPelT4uZ+u9g3fpDkr4xr6RAG4i
	 aH4vmhSm/wELhVPSk9PRSExScEYDCqsvRPezo1aOmr7/6PIzlSfpkHiKpZvEmVhlSTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257564;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GWyNdH/2xGc8m19kiO8qhkdxiV2oZ1MTckfgg0eXMfQ=;
	b=3Stpq1E3Fyav6elT0xEJjahwjITAEcuL4aTiah78Qisu50Y02wvc6AHDAPkob2NWtuVD
	 k6JS+aS0rDo8NQKJwGzni/C/9tDjkSbi7vBgtEaoJesajcKCD/cmVe7V6uu0XeOpsZnt4
	 Et1F87yqIsIZTjSB9pe/TD82s+0com/uH2dVO+DmqNcZ2I3tZgvbmljZmfB/hA6POypZd
	 BX0naLdM7rD5lulCTViiHYqMR+Zfp5wKTotWN/gVtkF4ZgKyjbcj/anl5dmH5cfqpgLYn
	 Es1oVzRGtw+3h0tI5NZ6taoKs9VE56mtUi5M89+4pfRPq39pvl2SmjFIxGacGH/hXGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=q5n+9Fxp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAEE606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=q5n+9Fxp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2AE1F0089F;
	Mon,  9 Nov 2026 20:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257563;
	bh=GWyNdH/2xGc8m19kiO8qhkdxiV2oZ1MTckfgg0eXMfQ=;
	h=Date:To:From:Subject;
	b=q5n+9Fxpc2qhPbUBEuh+bylVGtkgnEeDG9kWIrunJsrnokJ35RAtJ95Fh4koaRFcd
	 qYkoGvsCv7GqaIcXAd6Z9ONU/HyFWNUbyS41dzZ2RSj7rnrqlkPk6ov52JUDigS2Tb
	 Do+yZ/wOtwDIEM8bBg2eQQuw7uGiIakJYtGfwijw=
Date: Mon, 09 Nov 2026 12:52:43 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-dinode-ocfs2_valid_fl-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205243.7E2AE1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the dinode OCFS2_VALID_FL check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-dinode-ocfs2_valid_fl-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-dinode-ocfs2_valid_fl-check.patch

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
Subject: ocfs2: abstract the dinode OCFS2_VALID_FL check
Date: Mon, 09 Nov 2026 20:20:54 +0800

The test for a dinode without OCFS2_VALID_FL is open-coded three times,
and the two spellings have already drifted apart: the normal validator
uses le32_to_cpu(di->i_flags) & OCFS2_VALID_FL while filecheck and repair
use di->i_flags & cpu_to_le32(OCFS2_VALID_FL).  Fold them into one
predicate using the le32_to_cpu() form.

Byteswapping is a bit permutation, so both spellings test the same
on-disk bit on either endianness.  The BUG_ON() in ocfs2_populate_inode()
is left alone; it asserts an invariant the validator has already
established rather than validating on-disk state.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-5-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-dinode-ocfs2_valid_fl-check
+++ a/fs/ocfs2/inode.c
@@ -87,6 +87,11 @@ static bool ocfs2_dinode_has_wrong_blkno
 	return le64_to_cpu(di->i_blkno) != blkno;
 }
 
+static bool ocfs2_dinode_has_no_valid_flag(struct ocfs2_dinode *di)
+{
+	return !(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL);
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1530,7 +1535,7 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if (!(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL)) {
+	if (ocfs2_dinode_has_no_valid_flag(di)) {
 		rc = ocfs2_error(sb,
 				 "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
 				 (unsigned long long)bh->b_blocknr);
@@ -1854,7 +1859,7 @@ static int ocfs2_filecheck_validate_inod
 		goto bail;
 	}
 
-	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+	if (ocfs2_dinode_has_no_valid_flag(di)) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: OCFS2_VALID_FL "
 		     "not set\n",
@@ -1943,7 +1948,7 @@ static int ocfs2_filecheck_repair_inode_
 		return -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
-	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+	if (ocfs2_dinode_has_no_valid_flag(di)) {
 		/* Cannot just add VALID_FL flag back as a fix,
 		 * need more things to check here.
 		 */
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

