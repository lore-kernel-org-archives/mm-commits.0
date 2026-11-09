Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257584;
	b=VmaVefWxk6xibCF//Bu3hmivALFQKAz1OQOAnIv4uAprU4soDhA5FGzUdD5qe9AODF2t
	 XBRwpsQBfoRCKm5xflsIZ8zmXZ03jGbysWzD5kTliqIri+O1vM0YH9UMsgYFDc8bz+MV8
	 sbc5h4ET2FMmwoJgaJ3t4Njmoo3Pce2PTRKiysNYBB3ZEEQcVbSuccxwcEiXUUN1yvygw
	 e15qbJWzOUkPm/CWjRoFtrr5e4LYAepxBUyKzqgxZhUQgl5s8tMQc7GTq1+WFRHT5x21k
	 DLVuH4amIg8+Ki/Q+3Miv9ppVTkrpe0YmAKtSqECE3+YvlQvZzrNIzDUmletlaefx1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257584;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gckdDPizhvv7o2xLFEsD5tmDubj0FqOPoDqI3NS7+A8=;
	b=rw0JQWrNtzFJ8BY+GjYB2XXlxBaLNY3Fysa0N4ZeU8P091U+10It2fA41xRlRgZV++M5
	 iDWqYjcAGpa3cCNqAvdBo32JAbH1n3bNOiZBl7L+JXStKzzlpk7+80kOz88akRfNkfkEN
	 shASyN/jP1TM/m9Hw9t1AgZjbb8H89As0cOc24VMWRla6Zyw+CZbYQW6qmTTX64qKnznZ
	 AsfLLqDdzY0nr9UoVuecYWWZA3m2ZbVIZ4MrJOpBSB1ziaef+RirLo9N/0PG6gYuk1Pnc
	 0mvGrB5J9nxSUToeVZcJ/gAHSa9vGyGdT8uGP3gzIvuwl07OI8AitM3DEaSxN6TmRmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="mLtUMNO/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21A1606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mLtUMNO/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA9E1F0089F;
	Mon,  9 Nov 2026 20:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257583;
	bh=gckdDPizhvv7o2xLFEsD5tmDubj0FqOPoDqI3NS7+A8=;
	h=Date:To:From:Subject;
	b=mLtUMNO/Ln5jgY7UNE4ljPRDZbwA8p64I2HW7qpG4l7g6DsTslI0bKa7Hr60DwLLj
	 tkV3c80spyYSn8I2spvgDojEjBX4F/WJApK74SunAWN33Fp0cc6dLqmBdblwa8SbWV
	 SmtuiNI5ArDWFGuRjAxmkoWdIvtN68E79MD9Kbaw=
Date: Mon, 09 Nov 2026 12:53:03 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-fast-symlink-dinode-guard-and-size-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205303.7CA9E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the fast symlink dinode guard and size check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-fast-symlink-dinode-guard-and-size-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-fast-symlink-dinode-guard-and-size-check.patch

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
Subject: ocfs2: abstract the fast symlink dinode guard and size check
Date: Mon, 09 Nov 2026 20:21:03 +0800

Introduce ocfs2_dinode_is_fast_symlink() for the S_ISLNK with no
allocated clusters test that selects the id2.i_symlink union arm, and
ocfs2_dinode_has_oversized_fast_symlink() for the i_size bound.

The guard is deliberately not shared with the similar test inside
ocfs2_dinode_has_extents(), which additionally requires a non-zero
i_size.  A zero-length, zero-cluster symlink currently falls through to
the extent list checks, and reusing one predicate for both would change
that.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-14-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-fast-symlink-dinode-guard-and-size-check
+++ a/fs/ocfs2/inode.c
@@ -192,6 +192,21 @@ static bool ocfs2_dinode_has_inline_size
 	return le64_to_cpu(di->i_size) > le16_to_cpu(di->id2.i_data.id_count);
 }
 
+/*
+ * Unlike the similar test in ocfs2_dinode_has_extents(), this does not require
+ * a non-zero i_size: a zero-length fast symlink is still validated here.
+ */
+static bool ocfs2_dinode_is_fast_symlink(struct ocfs2_dinode *di)
+{
+	return S_ISLNK(le16_to_cpu(di->i_mode)) && !le32_to_cpu(di->i_clusters);
+}
+
+static bool ocfs2_dinode_has_oversized_fast_symlink(struct super_block *sb,
+						    struct ocfs2_dinode *di)
+{
+	return le64_to_cpu(di->i_size) >= ocfs2_fast_symlink_chars(sb);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1784,12 +1799,11 @@ int ocfs2_validate_inode_block(struct su
 		}
 	}
 
-	if (S_ISLNK(le16_to_cpu(di->i_mode)) &&
-	    !le32_to_cpu(di->i_clusters)) {
+	if (ocfs2_dinode_is_fast_symlink(di)) {
 		int max_inline = ocfs2_fast_symlink_chars(sb);
 		u64 i_size = le64_to_cpu(di->i_size);
 
-		if (i_size >= max_inline) {
+		if (ocfs2_dinode_has_oversized_fast_symlink(sb, di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: fast symlink i_size %llu exceeds max %d\n",
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

