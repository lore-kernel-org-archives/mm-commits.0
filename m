Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257592;
	b=VpeqInDthfzL0nLMClVfHnO91U2FUjp9U8e8EjsFEA/K2vBUyX3UiTPse3dUNdEEDLDm
	 lTodYUccCa4ZoL7kX4UljOS+Ot4pIzxiPEc1aFzNOIaqmW/59FiJSceAD2pJfzO1YNRm8
	 sfpzz1rdeFKbqEUXn67exOnp4lBCqOQrO1bRE+zzD7s9MBvy2LEZLajnt237JOdeFclNG
	 YX6li4FPvaBFYmOPfREX6/4EQVq46DRgavSZslnq7Qm6zDlEdLa6wY0LDJaUOTeKnjHpL
	 hQQuu5b9LP+q7u5IA0jEn0XRxDgANMz806+M9en/I/1m6LxYPQ/mPMt69U5yKydqGtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257592;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0fVjDCNx1AloVt5kbOjKAujn9nx1llbZH5nWYoHL94E=;
	b=UM0qUah21uCY4sLMEAg6/e7ixtgrrBujyfUWXQV/juWVT/3c8ZTQuHw38fI8c1u+MeNZ
	 37NAeVy34sRZK9206CnEvfdhhwguY2gn3tHRXzKJaiMCpPL7auTcmCSwrs13gAg7KFDH9
	 QfggFSKNjnYrUSehr1Ohpf99dlR3csnW7fgzTyzcvEnm6M5Dy3uAr+uAY5mnq+Crooakl
	 AK7gFwbG3dEsFBNOBWCrewHYW3OFdczR6dJ28zD7UsiYFZ/v4j5CRO/UQMBnxUkVnu4fZ
	 iA0d7cQ9HqeZhlGqfiYkZMqL8u6xF2YHu1hKkGnoDcetzbxU+22X+CDLGsxH6aLYwgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kNfjVrL7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D658606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kNfjVrL7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4837E1F0089F;
	Mon,  9 Nov 2026 20:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257592;
	bh=0fVjDCNx1AloVt5kbOjKAujn9nx1llbZH5nWYoHL94E=;
	h=Date:To:From:Subject;
	b=kNfjVrL7L+v+FL4nnQwBsR5f4wyqFZ6vhYjwOwQ6J18CjQxx5ky1RQPg+IA6p6uyT
	 SDOzR2v8dnuDSWGjFOp94WK1N3c0fbrkcboQ2Gn9R7L4nIiYA5OenW9vMJST/sRsb3
	 I/2X5UeSQ3qxsOcH/7B97BUpCxCULk1r9mWl3COI=
Date: Mon, 09 Nov 2026 12:53:11 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-chain-list-bits-per-cluster-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205312.4837E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the chain list bits per cluster check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-chain-list-bits-per-cluster-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-chain-list-bits-per-cluster-check.patch

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
Subject: ocfs2: abstract the chain list bits per cluster check
Date: Mon, 09 Nov 2026 20:21:07 +0800

Fold the cl_bpc test into a predicate that computes the expected bits per
cluster itself, and drop the u16 bpc local from
ocfs2_validate_inode_block().  No log message prints it, so keeping it at
the call site would leave an unused variable.

The two bitmap_blkno conditions are preserved: the global bitmap inode
itself is exempt from the bits-per-cluster check.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-18-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-chain-list-bits-per-cluster-check
+++ a/fs/ocfs2/inode.c
@@ -244,6 +244,16 @@ static bool ocfs2_dinode_has_bad_chain_n
 		le16_to_cpu(di->id2.i_chain.cl_count);
 }
 
+static bool ocfs2_dinode_has_bad_chain_bpc(struct super_block *sb,
+					   struct ocfs2_dinode *di)
+{
+	u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits);
+
+	return OCFS2_SB(sb)->bitmap_blkno &&
+		OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
+		le16_to_cpu(di->id2.i_chain.cl_bpc) != bpc;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1860,8 +1870,6 @@ int ocfs2_validate_inode_block(struct su
 
 	if (ocfs2_dinode_has_chain_list(di)) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
-		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
-				sb->s_blocksize_bits);
 
 		if (ocfs2_dinode_has_bad_chain_count(sb, di)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
@@ -1875,9 +1883,7 @@ int ocfs2_validate_inode_block(struct su
 					 le16_to_cpu(cl->cl_next_free_rec));
 			goto bail;
 		}
-		if (OCFS2_SB(sb)->bitmap_blkno &&
-		    OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
-		    le16_to_cpu(cl->cl_bpc) != bpc) {
+		if (ocfs2_dinode_has_bad_chain_bpc(sb, di)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
 					 (unsigned long long)bh->b_blocknr,
 					 le16_to_cpu(cl->cl_bpc));
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

