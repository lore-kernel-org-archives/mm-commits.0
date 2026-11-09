Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257610;
	b=nZrjvk/Qf4qPDibnYtG+BAWUcFJ7Pbi4evgKCwOMIZLcYilZdWbXkhsfgEo0VoBRjj+1
	 uLcXmeWdDjURlIbkdvCWCd4Egk+CKblIXQ7caydMEnjljL+6xk6xSHtcQwED/vfkp8SRg
	 HWTvQ4LUvF+HMuccty0R4UCX3WEjDraz6TPX5Uuof3w3cPH4DORQfhAeEYFAKJjV+iPRp
	 UxWhbS3fWnZop+yL2PBFfAqIwj9138GGp0p74GCnlVYRFHncH30E1td/GXtpwIw1+bM0K
	 Ye3yMO5V5XUGYGJCwktbhwpNsf7hvCnfG9sqxuvQpf8IFkCyjSsLApCezwudhjc79gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257610;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2IsusGvef5VDypat9O4hSQ1GOXt0tNi+5k3+tnRdA4I=;
	b=p1LXqVx/QHF+9cc7NX5Mm0syIvc5FzCLIWW7jwd8uzZqbuYqh5t+WygstI9pxRySCrG6
	 C0Xf353tC644Le1ZzgB0p4JkzqjoG+/2S40XAsvpU0u3p18UYgN8AOIUR8a1HTaSxYMEd
	 RwRVPF+cX7uOvp5lifmBrPEc5cIH1c/P0exzNYp5LBdSn+oJ4Z/AQmo22QlKcERjSJ8Vc
	 73wC6xUhnjS1KiSJWXS9Lb+7DtAJ2TA/bQnLjJTAxzpzRCfe4MGwKdI4BOg/NdTWP5r/b
	 LgBJQSrFLJEpAAZpLpZQ8Qn/mXZALlb7qQGisnfVxbD+nUC4JEjUDfLh8q26rY5uVsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uczOJDNp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A8D606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uczOJDNp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD361F0089F;
	Mon,  9 Nov 2026 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257610;
	bh=2IsusGvef5VDypat9O4hSQ1GOXt0tNi+5k3+tnRdA4I=;
	h=Date:To:From:Subject;
	b=uczOJDNpXPj12dRPrYcZYVw8Trh0vKhHVnGpGPt6dFyncQLtQB1ygOkAW4mmqgn6w
	 uh+1NNtmJdxeTrGVO89ZrUANlyRFbNorKSeLGgkNkc7aBZWY/vQvbUw7BCdx7m2/XD
	 u2St1o4zUVt8pG6fufyRB1sqGgPh9nw2epuBL7XA=
Date: Mon, 09 Nov 2026 12:53:29 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-dinode-suballoc-bit-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205330.2AD361F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check dinode suballoc bit in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-dinode-suballoc-bit-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-dinode-suballoc-bit-in-online-filecheck.patch

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
Subject: ocfs2: check dinode suballoc bit in online filecheck
Date: Mon, 09 Nov 2026 20:21:15 +0800

Wire the suballoc bit range predicate into the filecheck validator.  A
suballocator group bitmap lives in a single block, so a bit at or beyond
ocfs2_suballoc_bits_per_block() can never be valid; accepting it would
later trip the BUG_ON() in _ocfs2_free_suballoc_bits() when the inode is
deleted.

Link: https://lore.kernel.org/20261109122121.21473-26-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-dinode-suballoc-bit-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2047,6 +2047,15 @@ static int ocfs2_filecheck_validate_inod
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_bad_suballoc_bit(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc bit %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_bit));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
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

