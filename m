Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257570;
	b=wAK/heVNURlMLXAUbz6B3bAj1doP6KIafHCROlERXXlE7HsRN9xEVEcU06WGL0IVRff9
	 R+xOpAGY/P3ifD/ir7K27PcI+DjKdqi4SNhEz3oUyOFZt9jgTNzxZ4YTEjVg9D1bLA+tV
	 ewqGB+0Lw8r6qGXp9DzV7IPWg2ZICGl+bubFsf8rpWsrn6zrgBvEVHTOs/4Ka5NMtCD8F
	 ZYzzzl47n4J9HcPvUQojemCb6ESeL8OktLbuekO1j74rfF7yvU8ON9wwcSz/c/xcJHPz7
	 tD6KlUD0Fuz/0iuMgbnpc8YKX20R4stus+WsjRmwRa4Kt1vpkICjtwVhFxj3o8d2w9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257570;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ty9cCmHoHG2AMz4PyrSbgUzXErm4Ky/QzNIu3+BY4Zw=;
	b=VZf3LP8Q5nuLVM35B8AGk/3j6I2v0zKtEOXgtadQOPuzmoKEYKSV625dXjl+0zbSGGK9
	 ofs1oktPGd74g1VEKKJyy6tvBmVgdkddL5mFLBzUpJuLDabE+QFTeJPbytVM7VhfwF8Gp
	 unBrJDcNlp6y8coe3PKhrayAmzIfNq+Yu7ZQMZ6lCG063YXMSWoNzeP1H1owsxLQA5XNk
	 cKgnOkExRXIKQ3CviCUestaIjQsnvySTF8PBtwWtaZQGiy0FnuHUpZ/DXoABlIRZpqFPF
	 35A+gs+LU43yXUzNc/LtGPoePhYQEQsk4NiRSbJkfxW7pwQQ3ndo4sKOqjf+QG7Elpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SBOBwHpH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778FA606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SBOBwHpH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312AA1F0089F;
	Mon,  9 Nov 2026 20:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257570;
	bh=ty9cCmHoHG2AMz4PyrSbgUzXErm4Ky/QzNIu3+BY4Zw=;
	h=Date:To:From:Subject;
	b=SBOBwHpHqkKBw0R69sCgr36Th07dO0J9XfIRtNH205yprInaH7uIMQGy35gM0CSZa
	 Ozt/hjVgx/43KGccUZUqGxVHfwDvi55mqX5NuhYVcIIhFSaWLQWXkOoqDd2MdwQ8lo
	 FYDbK1Bh8dTaJA5A1CVDlvZFGM3ODvHmPEsQskWw=
Date: Mon, 09 Nov 2026 12:52:49 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-dinode-suballoc-bit-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205250.312AA1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the dinode suballoc bit check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-dinode-suballoc-bit-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-dinode-suballoc-bit-check.patch

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
Subject: ocfs2: abstract the dinode suballoc bit check
Date: Mon, 09 Nov 2026 20:20:57 +0800

Fold the i_suballoc_bit against ocfs2_suballoc_bits_per_block() test into
a predicate.  The rationale comment stays at the call site, next to the
error it explains.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-8-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-dinode-suballoc-bit-check
+++ a/fs/ocfs2/inode.c
@@ -111,6 +111,12 @@ static bool ocfs2_dinode_has_out_of_rang
 		(u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1;
 }
 
+static bool ocfs2_dinode_has_bad_suballoc_bit(struct super_block *sb,
+					      struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->i_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb);
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1601,7 +1607,7 @@ int ocfs2_validate_inode_block(struct su
 	 * BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl)), since any
 	 * group holds at most ocfs2_suballoc_bits_per_block() bits.
 	 */
-	if (le16_to_cpu(di->i_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+	if (ocfs2_dinode_has_bad_suballoc_bit(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc bit %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_suballoc_bit));
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

