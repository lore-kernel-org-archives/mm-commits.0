Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257577;
	b=qCt0yzBOPORpRQiuFBFfdXACSoJuohOm7gbg6jLfMWBtVQpmHVQYNPhtbIg2qWcsaew1
	 VmlAbYdJK5lzP/pTvQHXqkwBMc8b1sEJNNYXKAr+k3rwVPCtszNE6MXNQkxEmF42nNYP5
	 F6ma3AfMGWdQaTrMdeTH90jhVctEFlfIFhAxTW7oXqJKeEMStw51NZ/yHQxWzQh6Tin3/
	 K7c7KjpcxExCwENm8KIngoAoHwDA0z05USDezciofejoyY0DHCIXGWJbOG7g47XUv8Nkg
	 dD+X+GqjUjDYwg3Mt8QRb2lCrSob1gQhbTH3CLxi7v2VnT/iPxCjANtRNOpRgM+0IzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257577;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zW7jYhKl7onqUgtT7FskFAHVXPQ5lMgl3nXDiwrNGMw=;
	b=UZl0kfz4TB07Xck7Um+VwgwRLCa2dOs+h3mPx+cu7D8trWXLkBscx3K7RVm/R2zrcG7K
	 vUM7n1VfQ4qOLi4xerBo39E3oiyBoKEIEydY4sjeQdcTYc97NWA9icoJ1ChO4InePVQDI
	 p2PINB6XEEsg2TDoccS2H1xN5uFmLTJGl4YoY1pHgZuLB8hJ8RJfQdGxZcfIfAAnywrcn
	 EWXu+q+FWh1pNZi753HxR8mIJwiLDDu2ET9J0K3PnfaVRdjt4K8vQ/ZbLhTx+0pOdHv7o
	 mBNZ6Dt+edifZNYmlkTInftptFHF+e8RPIJO5JG1/nhAJrloWtIzJveY0kv/9x/xVGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=upi6seSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E0E606A326
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=upi6seSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44321F0089F;
	Mon,  9 Nov 2026 20:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257576;
	bh=zW7jYhKl7onqUgtT7FskFAHVXPQ5lMgl3nXDiwrNGMw=;
	h=Date:To:From:Subject;
	b=upi6seSE8H9jX+LJpkt58fkhsj9KFMffRdBqqszaosPlay9Mfd2Mep7KfXetB3KH0
	 YGnkcDsClxGvL17pfGZJj9TFz1eYcN44e9DcWb1sh4Hf5ZkT9X4dKrfZp445hSxt2D
	 sZzxmq/4iP/eOjr+ElmD6GN132ZZqTSRUdNU/UjY=
Date: Mon, 09 Nov 2026 12:52:56 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-inline-data-dinode-guard-and-cluster-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205256.C44321F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the inline data dinode guard and cluster check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-inline-data-dinode-guard-and-cluster-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-inline-data-dinode-guard-and-cluster-check.patch

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
Subject: ocfs2: abstract the inline data dinode guard and cluster check
Date: Mon, 09 Nov 2026 20:21:00 +0800

Introduce ocfs2_dinode_has_inline_data() for the OCFS2_INLINE_DATA_FL
test that selects the id2.i_data union arm, and
ocfs2_dinode_has_inline_clusters() for the rule that an inline-data
inode must not also have allocated clusters.

The guard stays above the sub-checks: reading id_count or i_clusters
against the wrong id2 arm would produce false positives on valid inodes.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-11-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-inline-data-dinode-guard-and-cluster-check
+++ a/fs/ocfs2/inode.c
@@ -164,6 +164,16 @@ static bool ocfs2_dinode_has_size_withou
 	return !ocfs2_sparse_alloc(OCFS2_SB(sb)) && S_ISREG(mode);
 }
 
+static bool ocfs2_dinode_has_inline_data(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL;
+}
+
+static bool ocfs2_dinode_has_inline_clusters(struct ocfs2_dinode *di)
+{
+	return le32_to_cpu(di->i_clusters) != 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1726,10 +1736,10 @@ int ocfs2_validate_inode_block(struct su
 	if (rc)
 		goto bail;
 
-	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
+	if (ocfs2_dinode_has_inline_data(di)) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
-		if (le32_to_cpu(di->i_clusters)) {
+		if (ocfs2_dinode_has_inline_clusters(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: %u clusters\n",
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

