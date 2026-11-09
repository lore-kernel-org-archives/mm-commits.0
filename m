Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257617;
	b=Z8ab1qHLrnqXQvo/2N9q3LXco+Z9TPqeQIU8WxiHeD2/yMNTWAy+7oigL5FF4ORLj6hl
	 k9mxAEkdhYQSpOxxKtGo/WBwDrDPSV/SAPALS5peagKUMJKABFT0M148bRFpdBayqrfyS
	 ZU8klEKMaWmusHTf7hfzdtRWHXX4P5gI+Y4b2A92H3zdxBQij9FyLWDnZGLkFK1CaxEmm
	 tzvZ0Woc2UgfFXpt3nKzIfcxqAQOtaZGpnl8nC8nyYMK0JRsTdplK0joX2FLUoE6v6nRq
	 Ep6QivW2xScyzCb7kYY75S3mh7rzPgzim+0QKex0+rvoivSxVlSPehSs5J0dkyhSyyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257617;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NEttv7d2hTq6vy1UnUljgJnKaxVXIgNKINj2Pg1E0Rk=;
	b=hiHNzYFL2AkcrOZgCzjVnQkUDtub58ruO7suT6nPOKAU8m+z0IP4m8McT6x8qVMAd8Zs
	 qRlUEVtu5Gtkg+5yE6G+ghLcXUYL1w9HK/GhKc2n6ncuZTNPRoLmZw3NYjkRWTCJjXeZ7
	 mNwzYBHroX4CbXkWDSA8Ixk9Su+08l+R2exdu7+zVNFOFEB7ixS1dmxltAMaQPxbhX/2k
	 f3l/zLy5DYnYXP3rVQQd1kzurfokdLO2XgJAx41//T6JLMzMD522FcoF4/qkyLs3uDYAy
	 yjFvrxeduMRlFzuf2pxZzBXRKxJbF0J/w67IWpYWz9CDYMjq6T4eGFM5N8WPT6CSflg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Pgrq7Reg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21529606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Pgrq7Reg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF93E1F0089F;
	Mon,  9 Nov 2026 20:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257617;
	bh=NEttv7d2hTq6vy1UnUljgJnKaxVXIgNKINj2Pg1E0Rk=;
	h=Date:To:From:Subject;
	b=Pgrq7Reg2ui3rbBSAMKdRldcPBzfeoHspXYPzkzv0JPVUDoYHVXZO1mb1OoFF7QtY
	 vPDfXhCuUu+cg9npXCcWohksW909n3T3SyobIHQECxYUukqN/GiiyQrQAV0L7mkQYf
	 0AO3/ogN3401658IIihkPLq7DNCW0/WfQl2c+Y8M=
Date: Mon, 09 Nov 2026 12:53:36 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-fast-symlink-dinodes-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205336.DF93E1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check fast symlink dinodes in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-fast-symlink-dinodes-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-fast-symlink-dinodes-in-online-filecheck.patch

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
Subject: ocfs2: check fast symlink dinodes in online filecheck
Date: Mon, 09 Nov 2026 20:21:18 +0800

Wire the fast symlink guard and its two sub-checks into the filecheck
validator: an i_size beyond the space available for id2.i_symlink, and a
target that is not NUL-terminated at i_size.

ocfs2_dinode_has_unterminated_fast_symlink() bounds its own strnlen()
against ocfs2_fast_symlink_chars(), so this caller does not have to rely
on the size check having run first to stay inside the inode block.

Link: https://lore.kernel.org/20261109122121.21473-29-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-fast-symlink-dinodes-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2141,6 +2141,30 @@ static int ocfs2_filecheck_validate_inod
 		}
 	}
 
+	if (ocfs2_dinode_is_fast_symlink(di)) {
+		int max_inline = ocfs2_fast_symlink_chars(sb);
+		u64 i_size = le64_to_cpu(di->i_size);
+
+		if (ocfs2_dinode_has_oversized_fast_symlink(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: fast symlink i_size %llu exceeds max %d\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)i_size,
+			     max_inline - 1);
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_unterminated_fast_symlink(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: fast symlink is not NUL-terminated at i_size %llu\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)i_size);
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+	}
+
 bail:
 	return rc;
 }
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

