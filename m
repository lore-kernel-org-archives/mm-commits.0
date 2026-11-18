Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794983319;
	b=sGBSq+Q/0EfiougwihohKxiqlWQ9nNvMUccQ7APY2PCkBz6VuWkpwpC/zmWBha0NoJKk
	 QtkJwz4DjEMrlngp//5LdiaIBsw4XIXb1nnxqldJJ0cjUpiTI7/8QVENQkUzMIUdXc882
	 j7uznrGhGaGPgxFD3DDp/mN7bCTjbHwUL1g157x71Kk4hDshpl2lecCYy0h03bYZGKlLl
	 iOBd1fnqHrLz9LcXm6GdpXYQlisuOLwHjeVvQC91lmDi4p8DwWe+WrTUXtEwDqTENhX6H
	 Jno5V6wi64lbmMDhwKgyqujZtgSG7noF/QlqJm6ooo/Yi8P/LPqt9PJLcEbkv2JY+wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794983319;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MyEZaWqlgASDDik7tvemg79cl/wb4swPWM6F+118CkQ=;
	b=A1FlXnZtMC05kbs3xgj+sT00rvlNa9RqIC8/7Kk6x4r4IcTMw8KmFoPlO2hxg6KBfNKA
	 enuq/9FKkqcsefATRkolKn2rcihsLqc18vZXVzObL8nw2iGUgqKHtR2v1JG9roz/28ZD6
	 yOHCvQ4dHTK+xtlLWolzsNAD3itzhEgPLMWLTblQc8t6cN3WeiE2InMgN2MhWmPiN8Z/4
	 M7c8LoMyNUpUeIixoaYJWhUQtlt4XDrhiTAvOkkS1vL8CVM8NSPhzCeOoCF/FLE5QaA/m
	 r3d6Cl3Jb7Fjw7tlL2uXKgVNVvJh1WbGT1Q7c4n47HGmgQu2FXaotAGY5EJsnA7wZHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GyAzWaCw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A98606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 06:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GyAzWaCw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2681F000C4;
	Wed, 18 Nov 2026 06:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794983319;
	bh=MyEZaWqlgASDDik7tvemg79cl/wb4swPWM6F+118CkQ=;
	h=Date:To:From:Subject;
	b=GyAzWaCwzZA/dULYQpMuisrRckixHU7DjNkKeR8tL9Lg+z25s3ak1XhpdPrVBmi/8
	 4BRzjOW+Xlu/J6nCdXIUma4xH4blmK5MXLEW9zldLMmfR7rzYzIo9jb84eRVrJuBD9
	 I8AWa8yIcp00FZXDu86hRIjj4AQSJPmCi7Jt71u8=
Date: Tue, 17 Nov 2026 22:28:38 -0800
To: mm-commits@vger.kernel.org,mark@fasheh.com,joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,heming.zhao@suse.com,zhiyuanzhang912@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-local_alloc_bh-leak-in-ocfs2_shutdown_local_alloc.patch added to mm-nonmm-unstable branch
Message-Id: <20261118062839.2B2681F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: fix local_alloc_bh leak in ocfs2_shutdown_local_alloc()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-local_alloc_bh-leak-in-ocfs2_shutdown_local_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-local_alloc_bh-leak-in-ocfs2_shutdown_local_alloc.patch

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
From: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
Subject: ocfs2: fix local_alloc_bh leak in ocfs2_shutdown_local_alloc()
Date: Tue, 17 Nov 2026 14:58:30 +0000

ocfs2_shutdown_local_alloc() owns the buffer_head reference stored in
osb->local_alloc_bh, but only its success path drops it: after clearing
and journalling the local alloc inode it calls brelse() and clears the
pointer.  Every error exit after the local allocator has been enabled
returns with the reference still held:

  - failure to look up the local alloc or global bitmap system inode
  - ocfs2_inode_lock() failure on the global bitmap
  - ocfs2_start_trans() failure, e.g. on an aborted journal
  - kmemdup() of the local alloc dinode returning NULL
  - ocfs2_journal_access_di() failure

Nothing else releases it, so the buffer_head and its page stay pinned
after the unmount.

Drop the reference at the common out: label and clear the pointer there. 
The success path has already set osb->local_alloc_bh to NULL before it
reaches out:, so nothing is released twice.  The reservation path is not
affected: it takes its own reference with get_bh() and drops it in
ocfs2_free_ac_resource().  Also mark the local allocator unused when the
buffer is dropped, so that a NULL local_alloc_bh is never left behind with
the allocator still marked as in use.

Link: https://lore.kernel.org/20261117145830.59864-1-zhiyuanzhang912@gmail.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Zhiyuan Zhang <zhiyuanzhang912@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>

 fs/ocfs2/localalloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/ocfs2/localalloc.c~ocfs2-fix-local_alloc_bh-leak-in-ocfs2_shutdown_local_alloc
+++ a/fs/ocfs2/localalloc.c
@@ -462,6 +462,17 @@ out_mutex:
 	iput(main_bm_inode);
 
 out:
+	/*
+	 * The success path has already dropped the reference and cleared
+	 * the pointer, so this is a no-op there.  Every error exit after
+	 * the local allocator was enabled used to leak local_alloc_bh.
+	 */
+	if (osb->local_alloc_bh) {
+		brelse(osb->local_alloc_bh);
+		osb->local_alloc_bh = NULL;
+		osb->local_alloc_state = OCFS2_LA_UNUSED;
+	}
+
 	iput(local_alloc_inode);
 
 	kfree(alloc_copy);
_

Patches currently in -mm which might be from zhiyuanzhang912@gmail.com are

ocfs2-fix-local_alloc_bh-leak-in-ocfs2_shutdown_local_alloc.patch

