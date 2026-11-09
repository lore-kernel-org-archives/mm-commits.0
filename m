Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257624;
	b=iR7sTRfnwhdOq+HWk5TMtzcEBpnX1NNdqkUxzMDn3M3IZTsj+MqECU0tIXHBpX67U+7b
	 CMvGIVB0Q5t3iiVpFqDE/VN6GMkReF21sTCKrfFfAy8QK1aMDJaiSKZJjvSCWYzwFQP1p
	 cXGc438KDoKZmyFtnV8g1kxpzTKON0anE02aIiCJ/NfPNvu4D6ROGbaO16PFmBL5+qohA
	 m2FkFQEZx7yi+sWFOget2ePuaJnlaU+ldBCGl8C92jp9uwF8k2pr0Ry1esgzqhBPSKLHZ
	 zO0PruVEDEmtqI5uhMdQ9Eu4AnKNfxh8ah+pYIowDMDcEfK13vzCVFtpxwgee0HnAxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257624;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2OzFgfbtxCJYt9PQAJJfhgCMX7+/MltF3EvM3+6eGCc=;
	b=xT39ogZ7rWZl+X9PUG+r5OMV7X/xU8HRGiOOPLrSiUlW96GxW7Tw3pp1doLZo/4XGkun
	 lixN3ItmV8uA1zYQ3nfl97mjfaKIlH097YaxVeZ0abAy9uQO0e0f+TYrRBBYLm/+ClEPy
	 jR7aJ4MXkDYx97LFdNgDnnLRbDsFhBTpRsfHInKlRKwesAqEtMQNlJEEKPm9awfgbricD
	 AQ69hSnWy0v1InaYv9ClIXm4UVqz7y8PIETckfjk4oFTmzwgL50J5yF1gx5ReRxE9/LCI
	 vdAPBGc93wyaVO6V+6gray+HDEACi8Do2OsQryz2aRwEbfymQ3DuqJHSWlsa3LztEGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1Pjab500;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75C2606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1Pjab500
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FA61F0089F;
	Mon,  9 Nov 2026 20:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257623;
	bh=2OzFgfbtxCJYt9PQAJJfhgCMX7+/MltF3EvM3+6eGCc=;
	h=Date:To:From:Subject;
	b=1Pjab500JoPDheVvTGA5/d6tn+zfNlp58VwfvxzKGx7bqoJbTT5DhUYYkGPYiDbyq
	 us9v6eKN4vhtooOeJkS5o5YVr0/sebfCUq/x2sjLJg1bT8gk57aeKc7TejFCQy3s+o
	 SRbVMioa7MzEfLOX+/bZRRpPUVdfm8BfNA42ynwo=
Date: Mon, 09 Nov 2026 12:53:43 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-extent-list-dinodes-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205343.A1FA61F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check extent list dinodes in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-extent-list-dinodes-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-extent-list-dinodes-in-online-filecheck.patch

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
Subject: ocfs2: check extent list dinodes in online filecheck
Date: Mon, 09 Nov 2026 20:21:21 +0800

Wire the extent list guard and its three sub-checks into the filecheck
validator: a zero l_count, an l_count beyond ocfs2_extent_recs_per_inode(),
and an l_next_free_rec beyond l_count.

This brings the filecheck validator to parity with
ocfs2_validate_inode_block() for every dinode check except the inline
xattr one.  ocfs2_validate_inode_xattr() calls ocfs2_error() through its
helpers in xattr.c, so sharing it would mean threading a reporting flag
down into that file; it is deliberately left out.

The l_next_free_rec predicate is already used by the repair path, which
fixes that field, so a repair of it now revalidates cleanly.

Link: https://lore.kernel.org/20261109122121.21473-32-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-extent-list-dinodes-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2204,6 +2204,37 @@ static int ocfs2_filecheck_validate_inod
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_extents(di)) {
+		struct ocfs2_extent_list *el = &di->id2.i_list;
+		u16 count = le16_to_cpu(el->l_count);
+		u16 next_free = le16_to_cpu(el->l_next_free_rec);
+
+		if (ocfs2_dinode_has_zero_extent_count(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: extent list l_count is zero\n",
+			     (unsigned long long)bh->b_blocknr);
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_oversized_extent_count(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: extent list l_count %u exceeds max %u\n",
+			     (unsigned long long)bh->b_blocknr, count,
+			     ocfs2_extent_recs_per_inode(sb));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_bad_extent_next_free(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: extent list l_next_free_rec %u exceeds l_count %u\n",
+			     (unsigned long long)bh->b_blocknr, next_free, count);
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

