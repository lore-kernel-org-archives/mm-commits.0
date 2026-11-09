Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257621;
	b=rP1j+YrEgZhggvSM7wZ7BMJUik4/0uIjQczZXeBjI0VxNOp786vDkqB2DsNyg6205CTX
	 as/NWfAC0cee+VXSsq4iEpgVNli/UDc5xUh/fBvcXJ/N7UvrpDk1ISlgvW4ovIh9alHZv
	 rOSv+P5/mdxUnXKADi6yoK6hIPoJdtp1Ko9erdgaIx3pNytBZUxGAKaX+PB79cEUnlHlJ
	 c6okI5/VfR00h+Q+ejQ0g+Emvqce/qmZh9Zt8qGqh/cVnFJnYtEy7XnpVEAL4rlyCEs9h
	 Pn8eQvu8zHUoOPbz+PbHqLWC85NXVBM9pffSgBs6a98IvbVIQ+AgRQnaurLIIhCzPYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257621;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cm0VeSenNIx7b6h9lH+UWWdug13KGten0Q9IPgXZDWI=;
	b=n3IGZBSVUEhwAylFf9talVifLYsxKGe7786rUpA5HoWgb7bdvA0jqw95vpoOfszx5N/h
	 b+NHEdgwsUk0Hi6DNg9Io8l1rw7N7UIIrmbQoZtrzqw5z7ioASVw5w3ongN7R+50/jEsQ
	 nKx/IQHB7KB+F2lTPL+kmbcvUD5qHBMfgtf6a4XyvJ+6cz9Z5JoqmaPlIKw7oERAdEUWE
	 NRSAZBzIjvDTfccRQsww804EAf6itXHSwxQ7DmhOA7rkuoZMGCSiMjx10hevCfGVAeKK3
	 gmH9Ok+CMQmZyDOgX6TM5qEg9Ooc5Sh9J4TK8RX9zHzn+jKkLaSHt1z+1/eE4iKz8NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FcPY3Y79;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2FF606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FcPY3Y79
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666FD1F0089F;
	Mon,  9 Nov 2026 20:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257621;
	bh=cm0VeSenNIx7b6h9lH+UWWdug13KGten0Q9IPgXZDWI=;
	h=Date:To:From:Subject;
	b=FcPY3Y79Pi7xKjRYiMJgsdgrp2guvj22u6KX5Tc+luaLQ8LUlJVW7pZB+WVqrai2s
	 0sQOYk/aYtwfLMXg5jfn1eUwI/BXztMFDwr2F0X/jcE37R/SbnSOaISggqd6swl1zJ
	 KnWkyhnGYh2FF5O6lIX4cRs1TMBEwvbQ0NtI6XQk=
Date: Mon, 09 Nov 2026 12:53:41 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-dinode-refcount-location-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205341.666FD1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check dinode refcount location in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-dinode-refcount-location-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-dinode-refcount-location-in-online-filecheck.patch

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
Subject: ocfs2: check dinode refcount location in online filecheck
Date: Mon, 09 Nov 2026 20:21:20 +0800

Wire the OCFS2_HAS_REFCOUNT_FL without i_refcount_loc predicate into the
filecheck validator.  A reflink-capable inode with no refcount tree
location cannot be reflinked or have its refcount tree removed cleanly.

Link: https://lore.kernel.org/20261109122121.21473-31-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-dinode-refcount-location-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2196,6 +2196,14 @@ static int ocfs2_filecheck_validate_inod
 		}
 	}
 
+	if (ocfs2_dinode_has_refcount_without_loc(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: inode #%llu has refcount flag but no i_refcount_loc\n",
+		     (unsigned long long)bh->b_blocknr);
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
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

