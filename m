Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795577093;
	b=Ql58UBqroRBSjv9OUk2wGUKdqvgx5y3CvmWY0GC+Ul0LPX4MlaZmCGPIdMfd9JS1DWrG
	 3JFABQ6VuAnWbdriSOQR8EUxz1E/kN1cWXV/j/NTL8ocjAu2LoOkukcpX2CNNrwKzr7Xt
	 y/RQ+hw6B6Qj7HgpPGTBgsD3F9n5egRUQwmgrgVmt2yPgZ0jP7BS7NYuFy9fqn5MfFEcc
	 7DVNBrvWSHNwmYncIG26NktW4JN5Qd6JyrijvQ7qprCQpXSDjZfdfcVEw8fSrZYb0LEKe
	 UGAo05oWU+RRtqQ4pQ5nZby1ef7gujD5y5BStFocZ9UqKbgRdCQSThUA9TWt6H9aHLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795577093;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Y9M7i3JbIFxFIWF6cyz3xjZXi4uykzTrTLXOmooj3DI=;
	b=qCHhu65I3IFc7D2rucI8K+gVYj/GyfWWY7alfn6espgsLJBv20dMtJjawbTj03ctOvju
	 5K+9OyYjKfsWI5x0bN0iptBTZbQSjRRRZOtFiK79+mWxRHabw1/46g/MvH7b/lOqCcfPL
	 fdcLjOsloQdledzEZv/mopLGWFnv53sPMrGQSuHybemNFj6Mlc2/QqfM17GqSl7wu4rXW
	 DHovKfaSBfOURoWzb/0NQ/nc/6JlkeXxqfXVOWrLpNaxsvM9I24JoqAPlvj5fZ5NSYXI0
	 14JUUMoNZGcieAOI62uLGJ+HDTDjGqnasR/TdmVA0zH2+dRDqv5SZadqjOk8endevgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="bf/zA03m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295D3606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 03:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bf/zA03m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8451F000CA;
	Wed, 25 Nov 2026 03:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795577092;
	bh=Y9M7i3JbIFxFIWF6cyz3xjZXi4uykzTrTLXOmooj3DI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=bf/zA03md9Se34Oo7dj/cmMVEgoaNXy6Zc5Wj7u5RdpLtQra3mX+Os6Y8k0q1PQEI
	 c2PLCUsBjDcjiRqz7Ot+LyC5kmcF1BOMb6bKFpxAiSi3xlrLcdnFzAN2gcPmWH/4Sv
	 NwEl/3A7UbaOkpZZ9aZdxiS5kxB62CFs0c4Bsytc=
Date: Tue, 24 Nov 2026 19:24:51 -0800
To: mm-commits@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,
	heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125025505.343454-3-joseph.qi@linux.alibaba.com>
References: <20261125025505.343454-3-joseph.qi@linux.alibaba.com>
Subject: + ocfs2-check-chain-allocator-clusters-per-group-in-online-filecheck.patch added to mm-nonmm-unstable branch
Message-Id: <20261125032452.5B8451F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: check chain allocator clusters per group in online filecheck
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-chain-allocator-clusters-per-group-in-online-filecheck.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-chain-allocator-clusters-per-group-in-online-filecheck.patch

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
Subject: ocfs2: check chain allocator clusters per group in online filecheck
Date: Wed, 25 Nov 2026 10:55:05 +0800

The online filecheck validator reports every dinode condition that
ocfs2_validate_inode_block() checks, with its own message and an
-OCFS2_FILECHECK_ERR_INVALIDINO code instead of ocfs2_error().

Add the clusters per group check there too, so a corrupt cl_cpg is
reported by the filecheck interface as well rather than only being
discovered when the suballocator extends the allocator.  As for the
other chain list conditions this is not repairable, so it reports
INVALIDINO and leaves the block untouched.

Link: https://patch.msgid.link/20261125025505.343454-3-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>

 fs/ocfs2/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-check-chain-allocator-clusters-per-group-in-online-filecheck
+++ a/fs/ocfs2/inode.c
@@ -2221,6 +2221,15 @@ static int ocfs2_filecheck_validate_inod
 			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 			goto bail;
 		}
+
+		if (ocfs2_dinode_has_bad_chain_cpg(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: clusters per group %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(cl->cl_cpg));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
 	}
 
 	if (ocfs2_dinode_has_refcount_without_loc(di)) {
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
ocfs2-dont-bug_on-when-a-group-extend-leaves-too-few-free-bits.patch
ocfs2-validate-chain-allocator-clusters-per-group.patch
ocfs2-check-chain-allocator-clusters-per-group-in-online-filecheck.patch

