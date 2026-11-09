Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257586;
	b=XNAFAOdNvAHK+v8UFhAh4dTv6zZ+XUtlg5VzVN7FcLVcTzZGAESPZSg2MsUvOmz8hAnK
	 9vH5MbvrLMk4NW63v6YShDhRdGCyb1TJAvFOQFDksCeXFe8pUYijeAOQXe8sld1GdblA/
	 uz5GP8ogLnCQ3C4KfluJhQKbquRpkzl71uDmU8+wDoYERbszADSAGNjjbkNh4z18v0Q2g
	 yuBJEgKfKhfnx1UUVK/MmD2xju8e9IeolPWv0pDKMs78n2r39Se4xbiCFlG31yRFKD/TW
	 oDX1/d6j9+NXp2jrda0OiAZQ2XCZ7TWgLLu8edT9/UYDIDjPV/FQ6Btko2wITmoJnHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257586;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nZNEINyIH8cDcULhln3XVyUQbCLXTS2Yar5dXagrJvg=;
	b=by0TWNKY5XuY2aFLoVn9ZUcP+sMsdgWQAD3ck2uhFhNlDl8uTh/l2QLVZFiXajKpdMwW
	 W/YGkqqldrKXoHg8NZSI9lI+d9l1ke8AIC4P3LIRbUsEHnz2OiaEMAkZklRqv82ncl+R0
	 94deZR1M2RsK/4Jnz8j0oTRpuhzYqAVO93A6LTh50nkgWsqp142fM26z+ptzVzKDFoeEL
	 o7ue4fqsLQy/RKd4mD91A9X03j+YbVgGAeB5LL4d619WCZYtGAgu8Ce5G5qQSgwVrTqQS
	 K92IDo67j5AoVLkwcP+CeGmTGxqMSQ1G0/1uMcNJzIP//0p8lKmsO1GcxPxoCxHoerA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F4o+xDRp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D42606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F4o+xDRp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A089E1F0089F;
	Mon,  9 Nov 2026 20:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257585;
	bh=nZNEINyIH8cDcULhln3XVyUQbCLXTS2Yar5dXagrJvg=;
	h=Date:To:From:Subject;
	b=F4o+xDRplbGBExSC6qQ4mXTKGS59BAAJpOEb7ZaXlqkce48xXkcDZJR87xvAZc8hl
	 SWN89c/r/zHPvOCLWxOT8gCNHRpn7AaD37tnYBpGXM4AnQBBUVrO8Djmv3A0VreF/B
	 q/tRHhJmIfT07uKgwr3fr3bMm55SyfXO4katDAu4=
Date: Mon, 09 Nov 2026 12:53:05 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-fast-symlink-nul-termination-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205305.A089E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the fast symlink NUL-termination check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-fast-symlink-nul-termination-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-fast-symlink-nul-termination-check.patch

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
Subject: ocfs2: abstract the fast symlink NUL-termination check
Date: Mon, 09 Nov 2026 20:21:04 +0800

Fold the strnlen() test into a predicate that bounds the read itself
against ocfs2_fast_symlink_chars(), which is exactly the space available
for id2.i_symlink in the inode block.

The open-coded version was only safe because the preceding i_size check
had already bailed: i_size comes from disk, so an unbounded strnlen() on
i_size + 1 bytes can run past the end of the buffer.  Keeping that
ordering dependency implicit in a helper would be fragile, especially
once the filecheck variant starts calling it, so the predicate returns
false for an oversized i_size and leaves that case to
ocfs2_dinode_has_oversized_fast_symlink().

At the existing call site the size check still runs first, so behaviour
is unchanged.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-15-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-fast-symlink-nul-termination-check
+++ a/fs/ocfs2/inode.c
@@ -207,6 +207,25 @@ static bool ocfs2_dinode_has_oversized_f
 	return le64_to_cpu(di->i_size) >= ocfs2_fast_symlink_chars(sb);
 }
 
+static bool ocfs2_dinode_has_unterminated_fast_symlink(struct super_block *sb,
+						       struct ocfs2_dinode *di)
+{
+	u64 i_size = le64_to_cpu(di->i_size);
+
+	/*
+	 * Bound the strnlen() here rather than relying on the caller having
+	 * rejected an oversized i_size first.  i_size comes from disk, and
+	 * ocfs2_fast_symlink_chars() is exactly the space available in the
+	 * inode block, so without this bound the read can run past it.
+	 * An oversized i_size is reported by
+	 * ocfs2_dinode_has_oversized_fast_symlink() instead.
+	 */
+	if (i_size >= ocfs2_fast_symlink_chars(sb))
+		return false;
+
+	return strnlen((char *)di->id2.i_symlink, i_size + 1) != i_size;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1812,7 +1831,7 @@ int ocfs2_validate_inode_block(struct su
 			goto bail;
 		}
 
-		if (strnlen((char *)di->id2.i_symlink, i_size + 1) != i_size) {
+		if (ocfs2_dinode_has_unterminated_fast_symlink(sb, di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: fast symlink is not NUL-terminated at i_size %llu\n",
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

