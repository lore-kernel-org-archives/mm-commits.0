Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257608;
	b=JAwQBZ2qQagt1+85kBnu5tD84piuXRDQk2EWmK29urUY/R4+gqlHXO7AHOhB0wrkMNjH
	 nR+fLKf4UpV/2EtP6TZ818iAP6sel2p9sNf8vjimC8RB219mk8lLZW7/QePRc4B3wizI+
	 0Zg47iSbOS3vqeLa4QzP83nXtQkCIYCwzwEzUGSxpo0uOB+TbW4eJgd+cwmsLj/mDwd5q
	 XIUiKQ1TRtuLWTltaaILZL6TCgn4eJSokrc/orcyYELsw+pZkHnwtI9q+qm8RBhcUaChy
	 62COFlMzFsPpQ+Len5e6Nz6VvUSM2d+H/XfH29Le3fOhPPargQv75IbEPzPdYVaUrRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257608;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YVrujieT+o4lCuCFGgth0py87n8i1NvZrdRgBSrid84=;
	b=R5ZTNiHly8J69Nl4qiPNQSyt4z/kCfQO5TSdPaJkPMxmeBABugNbVw2ETZ+2TPUVSAHz
	 T8gM7sAdHnKEFO8ZtR8pwnA3GIg/jbDfTIIQiZDspojanlsHfQ1LGQnwOqWeItIvGyZot
	 FVQnJeeVnY2r4mRpIVDST6MR+KYoiCZMMfFJgNmHfrDzgCxd+jnj+WzqbjKTmoP/5T4ha
	 FzvIKXES+d1k0bXVjQSaLOQ+vSvyFrowf9WHtd10kpka5CbMusfasjiSBHIal3sMtkqDk
	 0sNWlJDM7RJ0UdJWmHENmtMQYEKeQ78D1NTeabv1cisdm0/kwAZsQ7FxVK37N8tKbcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oO8KY8r9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634D6606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oO8KY8r9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81B11F0089F;
	Mon,  9 Nov 2026 20:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257608;
	bh=YVrujieT+o4lCuCFGgth0py87n8i1NvZrdRgBSrid84=;
	h=Date:To:From:Subject;
	b=oO8KY8r9dh8ILuaJbM9w/Vj+5GGJRmP5OJsR0q9G4PPU3dBiuLKZKKkewkU2YEgbR
	 W+gMBiJ3KucwBtQbTcntmAj3jpFULMWVeVuq7FZgPZ8HzbIdmTufTv02/Ho8tfCcJc
	 t3/Vf2WUxR6foa7OnHGs6fksuHujtvI58dOwXKmQ=
Date: Mon, 09 Nov 2026 12:53:27 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-dinode-suballoc-slot-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205327.E81B11F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check dinode suballoc slot in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-dinode-suballoc-slot-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-dinode-suballoc-slot-in-online-filecheck.patch

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
Subject: ocfs2: check dinode suballoc slot in online filecheck
Date: Mon, 09 Nov 2026 20:21:14 +0800

Wire both suballoc slot predicates into the filecheck validator.  An
OCFS2_INVALID_SLOT on a non-system inode and an out-of-range slot keep
their separate messages, so the log still distinguishes the two.

The range predicate excludes OCFS2_INVALID_SLOT, so system inodes
created by mkfs.ocfs2 from the global allocator are still accepted.

Link: https://lore.kernel.org/20261109122121.21473-25-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-dinode-suballoc-slot-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2029,6 +2029,24 @@ static int ocfs2_filecheck_validate_inod
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_invalid_suballoc_slot(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u for non-system inode\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_out_of_range_suballoc_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_slot));
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

