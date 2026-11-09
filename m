Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257573;
	b=kpPSFhwhsmb0AWW/wOBQcgL5UZaK+Aivcx+c+MREYoAz+gmaQsX+qSOUBiCJS6jgpMiS
	 GBCFP2ANdZKFZmsP07vDW4R0y1v5SyKNWOcxyOfW4pONV6vAZkLHyPB6lnfh3nkuYmRCb
	 ywIDPTkhz5qHqzycpwYdI3Ks+xwL33cm9ZDkDrfjDmgi0WkzNHTGJeR2hOFah5rKp3RBL
	 K+2Rlc+lko/UBSI9XI/B4OLytZP3rmtCAaSad8E0tSpkDwqNPMFe9fYxafVgCPetrhnS1
	 ezddPHUZLub2fjmSN9Ssefau4YrqPv2YF+hwLN/cPWOsgx2O23kwOWT42rkySHEFPWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257573;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=joI3V5eZl3/z+JFBIO5gHa1Q7KzgLkLn54OxEJmtCAk=;
	b=rnMbUlL6uPkvX6jP+hpS7BO74heNIm1495VfSY/DiwkswK3MD7BpDQsodNF5zf7iEHNl
	 QF4WZnRkrS4psIoJrHp3YlWfLkv1xEer9qigetVWeRwYqNK4b5kHlrl7sBoQSaI7KDC3x
	 s9ExAsYQyy7kNMpozdfM1NzSeJpsSx/KCDyh7oVZXUpbteV8bUbeWhaUxn87HaxlNPQ7O
	 vXzNRXX3j7FzcEG8ptNJGU5DRCkpSzcHE1a1zPR0SkvtgZgORdLPWLacYq7pfjVFHvxQq
	 y6CuHkr64xy4m29+O6Y+sIV4y8OITty6kA/2vr9nbgUsIvUud73w0QusuBBB6xWT6IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WcDXGACK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6064606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WcDXGACK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688E41F0089F;
	Mon,  9 Nov 2026 20:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257572;
	bh=joI3V5eZl3/z+JFBIO5gHa1Q7KzgLkLn54OxEJmtCAk=;
	h=Date:To:From:Subject;
	b=WcDXGACKYJsPaNmxN72iBgxdZtSznMp0L/ScZm6Dl/UrQsgaLhVLH763+gpTm+nhv
	 /oFGiui3iWjbZydUEhTkWQifdOp6B2o8PLUB5sL68kWBWQfaUCln7NL86aQOkU4kIx
	 f0iXDBrIIq8Ai5WRkzStL9dzjT4AJAaamiryWGi4=
Date: Mon, 09 Nov 2026 12:52:52 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-dinode-orphaned-slot-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205252.688E41F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the dinode orphaned slot check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-dinode-orphaned-slot-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-dinode-orphaned-slot-check.patch

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
Subject: ocfs2: abstract the dinode orphaned slot check
Date: Mon, 09 Nov 2026 20:20:58 +0800

Fold the OCFS2_ORPHANED_FL guarded i_orphaned_slot range test into a
predicate.  The flag test stays inside it: i_orphaned_slot is only
meaningful when the inode is actually orphaned, so a bare range test
would reject valid inodes whose orphaned slot field is stale.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-9-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-dinode-orphaned-slot-check
+++ a/fs/ocfs2/inode.c
@@ -117,6 +117,13 @@ static bool ocfs2_dinode_has_bad_suballo
 	return le16_to_cpu(di->i_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb);
 }
 
+static bool ocfs2_dinode_has_bad_orphaned_slot(struct super_block *sb,
+					       struct ocfs2_dinode *di)
+{
+	return (le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+		le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1614,8 +1621,7 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
-	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+	if (ocfs2_dinode_has_bad_orphaned_slot(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_orphaned_slot));
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

