Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257613;
	b=iD5y6Z3+V6Vc7wh/grQBf3fzc+eq1inlZ+44gOZF8iMs3rA9xJdiFtsV5ZGxfAbRGONl
	 ypYPyoMECJyGprtNrMRGFPNseuMcBoYUev/Z6ealj5Htwb6oPhNQOISwdvzGPgWDRsCmv
	 J6RqWscUuYNP1gHl1OSuu3xljk9P2r0QQ205bnfjUiNLQsq3z8piHG7g3S3soSs1D9Hz3
	 dTJWTA7LSYIzwt5cApenMFha3DiGOJwreF9Z4zizlQfCDz68EhNKl8GZH62CiPTLeYq5N
	 fELbbl1x2Ky38YUmO0KiG53SQCyd1UyXESH77M6APoSoeOBVjgC005ikwnal7w1bJ4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257613;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YVqwJhzBdkuU/qNI0bDVxQ4CXmEmCTzXY89jdhPVzpg=;
	b=yCwfnASXGUyeB1yOCVuMYBj1MhqkKVxBHKMAj5YOv1fpksTMgCHO3wWWY9Ul6ol04Anb
	 29bYFRNcbQVTXv2UL97G7GngcSmaOW1Re4CQ7RKyWRDNLB5KkMNsMrwrwq/PpG1ZZCJ7j
	 V+FU3EdqcmmLbeNqm0HZC38EWL7dTXO1SjtOzCj89hLiJcAbyIno6ieYgu+oqNa854EaU
	 pfz2PIsC8KF4LmEJ1+PCErbrn5Y1GKQJdDGeXYyJ1p1CKKzen261P6hXsJ/ykcT7GHV4C
	 AhpZoava5au8/dzYOPiU2xWpvvDCJxNrJbZA5BL0LV7JwRkuF5/CINVWjiCCA/7o5+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IgBqZAA0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9947606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IgBqZAA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566B21F0089F;
	Mon,  9 Nov 2026 20:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257612;
	bh=YVqwJhzBdkuU/qNI0bDVxQ4CXmEmCTzXY89jdhPVzpg=;
	h=Date:To:From:Subject;
	b=IgBqZAA0NPH7qyUJgiZHdlDWPEn0+ku4p2KZPSLoeP9EGCnzwtP3W/TdA5H3CczfQ
	 NWVRon7DcDOzDzW+CyX8J/rRbMYBhBu2TU/mRFjwuMX4XTgyZF+Q0oNaLnOPKBo6QN
	 sUG4BDuH9y2MbcCqcChrVZtwx+rZ85bXEOorfULw=
Date: Mon, 09 Nov 2026 12:53:31 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-dinode-orphaned-slots-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205332.566B21F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check dinode orphaned slots in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-dinode-orphaned-slots-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-dinode-orphaned-slots-in-online-filecheck.patch

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
Subject: ocfs2: check dinode orphaned slots in online filecheck
Date: Mon, 09 Nov 2026 20:21:16 +0800

Wire both orphaned slot predicates into the filecheck validator.  Each
predicate keeps its flag guard, so a stale slot field on an inode that
is not orphaned is still accepted.

Link: https://lore.kernel.org/20261109122121.21473-27-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-dinode-orphaned-slots-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2056,6 +2056,24 @@ static int ocfs2_filecheck_validate_inod
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_bad_orphaned_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: orphaned slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_orphaned_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_bad_dio_orphaned_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: DIO orphaned slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_dio_orphaned_slot));
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

