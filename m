Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257606;
	b=MUK1p21fwyMOjCSNxIOPHUnE7nNajL6Exkzz/15NLTQtA06lDYeDMXVicIt1oWh+tMAM
	 F6lf1vMmNPFuBycuLHb6VKLhQNTAMCYtxuqrbYFNOwMfc4+0lUxdIirCa5T6H98neKC6o
	 U3KYx9i4QWPieh5Sr2Sece701xiAaQaTs2CNZO/Xjtoh0NSdDLwdRfsqOhNYZUGBVzWMA
	 QI1Gx7EhCqba3rlPIjtpZMUlGzEY6MJHNHhas5dZ3/oTAKRKKzBP5RaGavTBxmTjSGOtN
	 GEsGTLkaj8dBuQI4Se1B5sXv72T16/0m0CinB4HO7asowo/f3c58U+PjER+gu8jsxIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257606;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xSuQnDqJwmfKcX4EAfaxCSK0pCaPKW0ygRZUv1LJooA=;
	b=VowPImIcLORedH8StXC5PLn6og1y++mu8kWOADye/Ig4nAbVY0sP+wIFPImEH/ru8DCe
	 6Gbtqc8sb3BqTzO8CROykS79jL11RGkz9HhD8/l0PEhsYpvY0nJNROGRhHloOhmKfOV+/
	 9/Op30dJtN/lnLEKDQu1HPingmMQU+U7qqoxzF/hrvqTmwgIULjsA3r8yHOoepVOHgEAc
	 u0BRGSOE+JNObQRur4PoDf3HGMImb0ldG35acUeBuRmsGy3nXZjN/7fFKU3x7BIWu0oda
	 S6JNBL3n7OkZdnTIqi9r86ja+c36FEzydjMIUOdv6FbjaZQpSzIZPdAQwvImk5lZazg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=udhS3DMf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9342606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=udhS3DMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38A21F0089F;
	Mon,  9 Nov 2026 20:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257605;
	bh=xSuQnDqJwmfKcX4EAfaxCSK0pCaPKW0ygRZUv1LJooA=;
	h=Date:To:From:Subject;
	b=udhS3DMfUabKuxCKYbMFcZAVoUuevBZd4odbV1PYuzWOI8Hhv3qLeOW+TYz8jWfOw
	 Ewum8nNmQA3hslMmPcWEBfQBNG3Ekc6E5q+IbyB3e72WddSL6KlNypmufYUW46yCR6
	 Bxxg+EayIfS/qN0KaQV5IhTCVyNNLjn1O1Svu+1A=
Date: Mon, 09 Nov 2026 12:53:25 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-dinode-nlink-and-mode-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205325.B38A21F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check dinode nlink and mode in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-dinode-nlink-and-mode-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-dinode-nlink-and-mode-in-online-filecheck.patch

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
Subject: ocfs2: check dinode nlink and mode in online filecheck
Date: Mon, 09 Nov 2026 20:21:13 +0800

The filecheck validator shares most of its conditions with
ocfs2_validate_inode_block(), but skips the zero nlink or mode check.
Wire it in using the predicate the two now share.

Filecheck reports OCFS2_FILECHECK_ERR_INVALIDINO and logs with the
Filecheck prefix rather than calling ocfs2_error(), which would escalate
to ocfs2_handle_error() and could force the filesystem read-only while
an administrator is only asking for a diagnosis.

The check is placed after the ecc and signature gate so that the
existing coupling is preserved: a bad signature still overrides a
checksum failure with INVALIDINO, and every later check still runs only
on an ecc-clean block.

Link: https://lore.kernel.org/20261109122121.21473-24-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-dinode-nlink-and-mode-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2020,6 +2020,15 @@ static int ocfs2_filecheck_validate_inod
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_zero_nlink_or_mode(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: nlink = %u or mode = %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     ocfs2_read_links_count(di), le16_to_cpu(di->i_mode));
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

