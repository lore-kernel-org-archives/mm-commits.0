Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257562;
	b=hFsV6ZlKEjq8YCKUE9gkp/0HVcPOKP4SAQjDTXtvDC7oGha6aczjDcPZxY2k++aQW/uW
	 0YETdH47yFOpoWvzzudYHEhhWlFWWQDPfFuwQ2He0zvC7MjS4YApS0BJKaivfBNDN+h6O
	 Q/cCLa47UxBX9jyoZSmy9s+6RzkgwgLYyq7UPXMDKrhHJ6OYu2j8uXqpbnqw5HkfZbl0d
	 q5wp3AdAfGdv3IRUo4/LCUEGUJqRsbyoez6XLW8u0HYr/vgIpAehH8sCAEcfJQgGhFxGi
	 kKIJfwEGtfaNkgmDlDxBN6vNDlo8pPbBPVjetZ+Vq38XsLiK1cq5PEQyCDOLByri6eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257562;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ywElBmq9amRK/NR6jHg8TOn1E2Mb+/+6KFykPMfvnvA=;
	b=L1LrWFXamRLWDnsiQXHGiPKd9d33jA7uMBgWcr3BWP76yiOTutPnZcuAtPg1Q9C5kGJ4
	 VZkxmYyhMhlAyzPeyxu3wVDi0MjHSefhCqpbmFHf5pHiXAXiSJskNQRiSHOnQzJu+fwQu
	 jke55Ma+xEm9DtJ99sjRsley1EdJXAOWLkBpE14J6RWwYthcx30YR8d2pOBRxhZurXann
	 RmxNR4xp3Y64qcv67Ap60D4FNzMAZm+fxF6Va5VZesu8x+uaCHhObNCWMtlSwnX7M1/5p
	 ZhnBwm4MHZ6Gb4je2W68FE1XbQ+wS2M8VQITMkgw7L/zWHdpHZf/4ea7nz6NJy4w9Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lEngVLsD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FB6606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lEngVLsD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519DE1F0089F;
	Mon,  9 Nov 2026 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257561;
	bh=ywElBmq9amRK/NR6jHg8TOn1E2Mb+/+6KFykPMfvnvA=;
	h=Date:To:From:Subject;
	b=lEngVLsDmRtwGoyv+6w8YooOKQ43Hvwk2mboqnvrgiuI0U+Rnx1y2bTzg68cy+SJq
	 qdJXV05cU5/DpDohQ1kD7s5axtNHPefGfzVNCMFsFKJfWMVlfVZKnQbLx0+I01+Vno
	 iShJ0nZJSBoPrFkDTVCXaxBfQT7VJk9d9WykwlDU=
Date: Mon, 09 Nov 2026 12:52:40 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-dinode-i_blkno-mismatch-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205241.519DE1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the dinode i_blkno mismatch check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-dinode-i_blkno-mismatch-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-dinode-i_blkno-mismatch-check.patch

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
Subject: ocfs2: abstract the dinode i_blkno mismatch check
Date: Mon, 09 Nov 2026 20:20:53 +0800

The same i_blkno against b_blocknr comparison is open-coded in
ocfs2_validate_inode_block(), ocfs2_filecheck_validate_inode_block() and
ocfs2_filecheck_repair_inode_block().  Fold it into a shared predicate.

Each call site keeps its own log message and return code: the normal
validator escalates through ocfs2_error(), filecheck reports
OCFS2_FILECHECK_ERR_BLOCKNO, and repair rewrites the field.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-4-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-dinode-i_blkno-mismatch-check
+++ a/fs/ocfs2/inode.c
@@ -82,6 +82,11 @@ static bool ocfs2_dinode_has_zero_nlink_
 	return !ocfs2_read_links_count(di) || !di->i_mode;
 }
 
+static bool ocfs2_dinode_has_wrong_blkno(struct ocfs2_dinode *di, u64 blkno)
+{
+	return le64_to_cpu(di->i_blkno) != blkno;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1518,7 +1523,7 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		rc = ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
 				 (unsigned long long)bh->b_blocknr,
 				 (unsigned long long)le64_to_cpu(di->i_blkno));
@@ -1840,7 +1845,7 @@ static int ocfs2_filecheck_validate_inod
 	} else if (rc)
 		goto bail;
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: i_blkno is %llu\n",
 		     (unsigned long long)bh->b_blocknr,
@@ -1945,7 +1950,7 @@ static int ocfs2_filecheck_repair_inode_
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
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

