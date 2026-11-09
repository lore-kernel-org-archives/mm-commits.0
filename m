Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257599;
	b=VdL/B5MuDNXmOE71ksQlAkKsCXi5KvDWIoE277QBff0uJxysAITyL5IriVdzNVbGFqGB
	 nBQtp7w+TdQxf2YXOJxLbtXbJ3DQ5XbDkN4rKZ4O33Noo4k8AcxKifAD+NZIXpUgMmPaa
	 2l9i3aHvuNJFlsGoNMFhtn7ZOPR5h1zJbU8KeFuqPkX02hm3Kwu4tSD4c0VNzhkO4rI2O
	 60QLE3gqeG8ibXHvu+mi0GwwLdeZxfBI+i8tMq4Gr4gVs7wMa3dvnqw7nMhTkRsCWqV/0
	 D0JuL/STg6pVbVK27FJjcvYcBatmoLQIb1gCTqiwfMcQWQS3/bpWwUbTqapGJirkDfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257599;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=tlNPFGPSo6enJ7s4OeEuAtdqhMSbgXH2w6kY8yOIzZE=;
	b=Cm/l1l9xk5kM/17USHVMLThnszySRVd8tp88hF5HEr35Mb5aKC7JmaVTXWg9w1NTAFe6
	 69hzMhatcozi0oMI54IEHSEFu1Fz5QPnS427H5iX+AnzHCs35lqiJUOgRHTanaU9cTYUW
	 0Az1ZCAQUiBwOpqp/mpbyw4X6sg2WAAX6Vs3Gl67dkADoGTNKo/ZL8yZLxIb467YsEd/f
	 L16C2/PHg0tAh5lzB8nJHDbU4H+5GAtDyykJJWCn+0ruZOwyEbEhQwcBgA1xp/AJjXjFS
	 x62LshN7tgRhYQyk2KqhDWcEcuDVBrCD8WZ7/DDDNFfBYOfAg58w/46QzX/jDYouY+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SeIxFWUM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64595606A321
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SeIxFWUM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8AA1F0089F;
	Mon,  9 Nov 2026 20:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257599;
	bh=tlNPFGPSo6enJ7s4OeEuAtdqhMSbgXH2w6kY8yOIzZE=;
	h=Date:To:From:Subject;
	b=SeIxFWUMcy6Ix4I7c6roM7FBeqwgJooFyoVmXZ0lkrqjzX4XerxaNdApwCFyj2eWZ
	 6qEWir05LdhrA6RFiXuoEZqqipPTVPu6tilG8iHqodQhnaWWS2EJaXtLdkyXrP2JK7
	 CYyqLYue/mng7wYGInSMxzwC5C6/z3x3hl5at5Sg=
Date: Mon, 09 Nov 2026 12:53:18 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-oversized-extent-list-count-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205318.DE8AA1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the oversized extent list count check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-oversized-extent-list-count-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-oversized-extent-list-count-check.patch

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
Subject: ocfs2: abstract the oversized extent list count check
Date: Mon, 09 Nov 2026 20:21:10 +0800

Fold the l_count against ocfs2_extent_recs_per_inode() test into a
predicate.

Move the rationale for using the no-xattr maximum into the predicate,
next to the bound it explains, rather than leaving it at the call site
where the bound is no longer computed.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-21-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-oversized-extent-list-count-check
+++ a/fs/ocfs2/inode.c
@@ -265,6 +265,19 @@ static bool ocfs2_dinode_has_zero_extent
 	return le16_to_cpu(di->id2.i_list.l_count) == 0;
 }
 
+static bool ocfs2_dinode_has_oversized_extent_count(struct super_block *sb,
+						    struct ocfs2_dinode *di)
+{
+	/*
+	 * The exact capacity depends on i_xattr_inline_size, another
+	 * unvalidated on-disk field. Inline xattrs only shrink the list, so
+	 * the no-xattr maximum is a safe upper bound that a valid l_count
+	 * never exceeds.
+	 */
+	return le16_to_cpu(di->id2.i_list.l_count) >
+		ocfs2_extent_recs_per_inode(sb);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1919,13 +1932,7 @@ int ocfs2_validate_inode_block(struct su
 					 (unsigned long long)bh->b_blocknr);
 			goto bail;
 		}
-		/*
-		 * The exact capacity depends on i_xattr_inline_size, another
-		 * unvalidated on-disk field. Inline xattrs only shrink the
-		 * list, so the no-xattr maximum is a safe upper bound that a
-		 * valid l_count never exceeds.
-		 */
-		if (count > ocfs2_extent_recs_per_inode(sb)) {
+		if (ocfs2_dinode_has_oversized_extent_count(sb, di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: extent list l_count %u exceeds max %u\n",
 					 (unsigned long long)bh->b_blocknr, count,
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

