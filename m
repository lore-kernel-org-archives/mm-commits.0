Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257619;
	b=g1PxRrDPHUvD7pPOYG5zOfhFRARey+F8eno+36gApC/fIYXbgUhq2ksX8+R1VoUJaHjX
	 5j9RD22C1UNVoe3/ML58V3SueupgPqZMPQ6/ZpUQVswWKNrlXyJZJMWkZ50OK2gxfxfXr
	 hYtja+scJJxqXGEylAfu39IoYxFed7e8hWDLTbnFrld/vawRoPG3Q3m4eVjr3DcNSKlSy
	 FrQHT246oOmPWrARn416pqlViSMEs90U7+2d/KXcSpwRCIxB7Px+ynRM7k/wZ4buRZhK3
	 DOSByrjgF4YXDkNGoLFYC8Mt89XfvKNzn/oyoDWCDk59XChSP3pqkAv9KyXWxTArUgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257619;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FhDBRqCmXm8gOp8Dx4eRM+6+3icdJrJSRvnc6dy0BVM=;
	b=f/qa/wZ68FSr1csBC+GfXwDwmvbeWW1nfVYzeAtD0w0n6TSBGOvyfBSwc1ZJ3XHhpM2p
	 tOkBWboC8+TXo1t/kUfjlR6ffq1mXbG2eQUmqHMCXI3Q/Z3pXL1qlHwsSYNY9Edu20tQE
	 EvjL0yOK8xqfCO0bdaHrgpPEia+hMrRV7MHNmnMK6LUPhnkpwTRDrYKmhGV9cJ5NyRjW+
	 Pth7bNs2dao3bTK4rEOPcMtHuqwTCdxFPiVQeZnUxgP/xSpYZgYlRZvNLmc0uScF0hSRG
	 BzbZ9KUYXCpX0JnDRLPtRhMhnAqMF39DR/FnVqfKj0bKSdCGUNDBU7hpMNDNWYmiNpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lPVNi5IZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF0B606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lPVNi5IZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298CA1F0089F;
	Mon,  9 Nov 2026 20:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257619;
	bh=FhDBRqCmXm8gOp8Dx4eRM+6+3icdJrJSRvnc6dy0BVM=;
	h=Date:To:From:Subject;
	b=lPVNi5IZHXLqeyuiMfwENbq09QNOThQsNrbTgWfMrezNMniyH+SJRNyA9AAV5Qa77
	 +R1LSH3P3JUg2cBmm2nSFfnxq2HgbyJBrxJVcPlFK8rLRr+NMFr/5vtbWrcJ9/MS1J
	 3h8SagjpWzzlDkZNE5hVTJlovl20DFFBrNplHHgI=
Date: Mon, 09 Nov 2026 12:53:38 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-chain-list-dinodes-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205339.298CA1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check chain list dinodes in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-chain-list-dinodes-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-chain-list-dinodes-in-online-filecheck.patch

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
Subject: ocfs2: check chain list dinodes in online filecheck
Date: Mon, 09 Nov 2026 20:21:19 +0800

Wire the chain-list guard and its three sub-checks into the filecheck
validator: cl_count against ocfs2_chain_recs_per_inode(),
cl_next_free_rec against cl_count, and cl_bpc against the cluster to
block size ratio.

The bits-per-cluster predicate keeps the two bitmap_blkno conditions, so
the global bitmap inode itself remains exempt.

Link: https://lore.kernel.org/20261109122121.21473-30-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-chain-list-dinodes-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2165,6 +2165,37 @@ static int ocfs2_filecheck_validate_inod
 		}
 	}
 
+	if (ocfs2_dinode_has_chain_list(di)) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+		if (ocfs2_dinode_has_bad_chain_count(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: chain list count %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(cl->cl_count));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_bad_chain_next_free(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: chain list index %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(cl->cl_next_free_rec));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_bad_chain_bpc(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: bits per cluster %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(cl->cl_bpc));
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

