Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257597;
	b=nx24L0/kZzmizLv4iN+yZWYXpUUmeSpMQ7zirMuUS0H+pjUAuzB0dEAcpdssHKBb0dR5
	 i2T48Pw60SC55jRENetGMOxxy8E+7Z2q3xRejrIID5N7hGDPfPBIVEjHpRSvbhzxxTeTf
	 jMxQFCdjLbNrqnoyW3s02mBrmVDCktSym2Y72KmrwBy05nHwwSbytyOyCdFplxJjVO+Vd
	 hjni4++kQMo2xmcsqhfpjQC8nqyb0J/VqpBt/g3RQ6qHbRh9sW2ALgw1rQEzHMN3SceVj
	 WpIqJtg4O0+HO7GSpS7IrrXZ0LOJJH41LqIo1mj/jGz+qWNXV7necFg8uRpyGcX/bTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257597;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xlfxb3cAsHDX7ztnGfd8/lFgcqSgFMOT18YUgcp56pA=;
	b=1VKzrgjb988LddLSvi5/kbOW1+ZsDT9wNYrQvHr+AqLzX51Yw0PjEMtEnLUw/RuLjKXS
	 4X3M0cd6PuDWS4SlJqcvhHnIDtmrRXwwjvUZA+tD+VT6SRWEOwDAn1gFaftnaF1EmK4Vj
	 0qleQEsNslbPbjA3titcTywbunVEmd24WyYO74V06AMJ1Y8Rvj0a52EbJvFkvLXUfTNL2
	 5mIliE/q7H73TMjf/689yvkUpSZkYZBh/OmYkshk2b1FsVL6zq+KIfF6CPIvmaTVfYbJq
	 +xJ66RVoBZLq9MtgvH0rJtdBKFG8AYf8T8OEyeCbcGhza8Fk3rRjob/5/RWY1ouvpwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V9EV0Kp+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16B6606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=V9EV0Kp+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB65E1F0089F;
	Mon,  9 Nov 2026 20:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257596;
	bh=xlfxb3cAsHDX7ztnGfd8/lFgcqSgFMOT18YUgcp56pA=;
	h=Date:To:From:Subject;
	b=V9EV0Kp+4w398sknTKvZoyeHnyeJxp4UobMKZVuV39EkHz8/2EHWocZQZA07RXAW6
	 qLjR5j48mhG+tyQTYa6oXzUufCeq8q4boqD9NNDd/q5PGyCg6vTyulZdRxP2xkjRt4
	 ibN8szpS/W3wJdthMIoMCT49JwOUfovj0QNX+PtQ=
Date: Mon, 09 Nov 2026 12:53:16 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-zero-extent-list-count-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205316.AB65E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the zero extent list count check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-zero-extent-list-count-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-zero-extent-list-count-check.patch

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
Subject: ocfs2: abstract the zero extent list count check
Date: Mon, 09 Nov 2026 20:21:09 +0800

Fold the l_count == 0 test into a predicate, the first of the extent list
group guarded by ocfs2_dinode_has_extents().

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-20-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-zero-extent-list-count-check
+++ a/fs/ocfs2/inode.c
@@ -260,6 +260,11 @@ static bool ocfs2_dinode_has_refcount_wi
 		!di->i_refcount_loc;
 }
 
+static bool ocfs2_dinode_has_zero_extent_count(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->id2.i_list.l_count) == 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1908,7 +1913,7 @@ int ocfs2_validate_inode_block(struct su
 		u16 count = le16_to_cpu(el->l_count);
 		u16 next_free = le16_to_cpu(el->l_next_free_rec);
 
-		if (count == 0) {
+		if (ocfs2_dinode_has_zero_extent_count(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: extent list l_count is zero\n",
 					 (unsigned long long)bh->b_blocknr);
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

