Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257566;
	b=X8Wegd2E3dn7ejRqACaOKYyuh07J5EEAySd/BB3wyN69alElwuNjg2IUsvgdeE29f4Ld
	 LB4LxXp2AAxMOXtWaYN+j7yPSiWNSG9nPBXCcGSWm6d/sF1qTJth7XcX/nOzB+7MY/sk4
	 MkwgRYvZ/bo0Mfi3PAuTQRXNRwiXKvs6KmLqJJxthunYoelN0dh5gLsP4TkcRyalHJwVQ
	 eHfyyl/PlvIQpVD4OORGUbLj4VY28HC4UgR6Po75XcO3cgcxxDNrfyOo4nOoBjm8iz5HH
	 j4TJ82lOIfNobehbc/E0RnX0kmO0iwVjJGVpgcz/uR7I5pl2uRQXUacev3YdzZEvNmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257566;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Jlj4uFOS/6m+KwME0euULCeltO9SnN/NuYGA5cfUAec=;
	b=w9EoR8oVuaf5C+8KHya/vcwJkS7oYwzsI68XwQqyWNODslwLW8Bp55LtDyZiSkHAJ5cl
	 MFx4wNM3TuMbstSgr62hIoooFhgciovtmV9/8SPhVQUJ4VBwQeLF3lmVyAzt+RSh8EP5g
	 kgBBHaIem8J0I3/u/zUCUJTaceWG4Tc1qUiYCCx8m3WY3y43/KjmJ77rbkuyNpaEFeIO0
	 PEgP4D5Gxcl9Twlm84HuxArcQot20J80jnzka8uaJuX81s9JMAwPcGipTxcLlYzFC2ctK
	 RkQXSiZcmD3ySuRuYaoiqZvJYsss2yJVUj2j/H5KOZ/hssHJvZV6Fq061fTkSEJWAhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rV92+pSH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4615606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rV92+pSH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6AC1F0089F;
	Mon,  9 Nov 2026 20:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257565;
	bh=Jlj4uFOS/6m+KwME0euULCeltO9SnN/NuYGA5cfUAec=;
	h=Date:To:From:Subject;
	b=rV92+pSHHGeQ1ETaSf/Mu2LZ0NqK+ItC5Umknf7RZdkSGXehTYtIQCcI+JPTX8qFS
	 d0wqQNHKt6G/5NKAdWs92nGcr8l0X7xmzwomSAgfuZoKx7asAafl8vErLPoKShKZRR
	 KfRsoW9E/hRCOrAELqJwqFVjQwrWlWVhPVTAvouI=
Date: Mon, 09 Nov 2026 12:52:45 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-dinode-fs_generation-mismatch-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205245.AE6AC1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the dinode fs_generation mismatch check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-dinode-fs_generation-mismatch-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-dinode-fs_generation-mismatch-check.patch

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
Subject: ocfs2: abstract the dinode fs_generation mismatch check
Date: Mon, 09 Nov 2026 20:20:55 +0800

The comparison against OCFS2_SB(sb)->fs_generation is open-coded in the
normal validator, the filecheck validator and the repair path.  Fold it
into a shared predicate.

Each call site keeps its own log message and return code: the normal
validator escalates through ocfs2_error(), filecheck reports
OCFS2_FILECHECK_ERR_GENERATION, and repair rewrites the field.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-6-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-dinode-fs_generation-mismatch-check
+++ a/fs/ocfs2/inode.c
@@ -92,6 +92,12 @@ static bool ocfs2_dinode_has_no_valid_fl
 	return !(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL);
 }
 
+static bool ocfs2_dinode_has_wrong_fs_generation(struct super_block *sb,
+						 struct ocfs2_dinode *di)
+{
+	return le32_to_cpu(di->i_fs_generation) != OCFS2_SB(sb)->fs_generation;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1542,8 +1548,7 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if (le32_to_cpu(di->i_fs_generation) !=
-	    OCFS2_SB(sb)->fs_generation) {
+	if (ocfs2_dinode_has_wrong_fs_generation(sb, di)) {
 		rc = ocfs2_error(sb,
 				 "Invalid dinode #%llu: fs_generation is %u\n",
 				 (unsigned long long)bh->b_blocknr,
@@ -1868,8 +1873,7 @@ static int ocfs2_filecheck_validate_inod
 		goto bail;
 	}
 
-	if (le32_to_cpu(di->i_fs_generation) !=
-	    OCFS2_SB(sb)->fs_generation) {
+	if (ocfs2_dinode_has_wrong_fs_generation(sb, di)) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: fs_generation is %u\n",
 		     (unsigned long long)bh->b_blocknr,
@@ -1964,8 +1968,7 @@ static int ocfs2_filecheck_repair_inode_
 		     (unsigned long long)le64_to_cpu(di->i_blkno));
 	}
 
-	if (le32_to_cpu(di->i_fs_generation) !=
-	    OCFS2_SB(sb)->fs_generation) {
+	if (ocfs2_dinode_has_wrong_fs_generation(sb, di)) {
 		di->i_fs_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
 		changed = 1;
 		mlog(ML_ERROR,
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

