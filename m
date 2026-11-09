Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257575;
	b=aefLVO0rRLSO2rDJSB+sj3PTKE1x8MJ3M4EfVOa79Yt8AO+K+oTL45rwzZ92oVFSSNFB
	 9tq4hcr1LPJfLjqeEC6qXoxUr1LpcwAiUOlJzVSnuPcGFWO3qmP0hP33EgtZtFJV9rRor
	 6W51jZWHZKSvM3/BfTvpMeEH0xA7hvLgVebLD4nO55YB/Bl1fcNwJMG+rMLKY1CeMnwoG
	 eYUM1WLET2QE4xZUPhFndu0E5KwpDE6zYWcKjof4tydLqz4r7jgh0aC4gMO/w/rQ7HmsK
	 e3RrqeF9pjQ4Td5F2jc+j3CilVcyTFmTZVefwK6qUIAAK2XXVjMBjHYSe2yS2whLyHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257575;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9oU+I/FNUpmA/gTKq1lGugoFkTbyOC5qufwx1L6xnn0=;
	b=At7nskaDUiBgCCH2Bw1yPzEKu3UnmCKxZnhqKWQiGFZAvOaNuIQhfBJI2BLR3OJlvjDI
	 DKsF2v6G4URBHyIW/yCG/FKUMKKn3pMpOEGW9ZBRpweNytCq7Ns0gsb3l0ngBDE5Fm3/z
	 EsVm3nVh/yGJyd19OSRfYxyYs2uHHnDIHdx0+tjIfOT9fUWHBJeKxOFeSAi3TYWKcfDEd
	 xTY3qgdzpdwOvmipX/zPHKyPe7ozCniZvMdFP1jx79f6nKENPJLNISo6fGEdAHSqz1YKh
	 iOlaUz5YjT/dCCLGTyFbxonYNEv7yUPlZNAhgjCNibP1RLQIa+dbUrBO6uL/7ywax1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GIJDlwM5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16654606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GIJDlwM5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDDC1F0089F;
	Mon,  9 Nov 2026 20:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257574;
	bh=9oU+I/FNUpmA/gTKq1lGugoFkTbyOC5qufwx1L6xnn0=;
	h=Date:To:From:Subject;
	b=GIJDlwM5M9RSRmKH/2G6KC1Th3fjLa6rQxClomXG9VTwj28MO/uDgt246o8EmdLr5
	 LyIRju+vjSq786rG2LnwzbHsjEp/CLdYyOG/2+/YcG6/GzY8Mn2CGoLPjKtGpTJ43q
	 DGWyP/pv//vwRajixgxajAsac8zsK74mHxViq7Fk=
Date: Mon, 09 Nov 2026 12:52:54 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-dinode-dio-orphaned-slot-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205254.9CDDC1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the dinode DIO orphaned slot check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-dinode-dio-orphaned-slot-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-dinode-dio-orphaned-slot-check.patch

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
Subject: ocfs2: abstract the dinode DIO orphaned slot check
Date: Mon, 09 Nov 2026 20:20:59 +0800

Fold the OCFS2_DIO_ORPHANED_FL guarded i_dio_orphaned_slot range test
into a predicate, mirroring the orphaned slot one.  The flag test stays
inside it for the same reason: the slot field is only meaningful while
the inode is DIO orphaned.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-10-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-dinode-dio-orphaned-slot-check
+++ a/fs/ocfs2/inode.c
@@ -124,6 +124,13 @@ static bool ocfs2_dinode_has_bad_orphane
 		le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots;
 }
 
+static bool ocfs2_dinode_has_bad_dio_orphaned_slot(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	return (le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+		le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1628,8 +1635,7 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
-	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+	if (ocfs2_dinode_has_bad_dio_orphaned_slot(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_dio_orphaned_slot));
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

