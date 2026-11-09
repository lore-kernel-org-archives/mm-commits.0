Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257595;
	b=L7P4ePlTZgjrVbsNRKo1nP/gaJmiWyb15wADYABPIBynMlJTEAe3qtBgyJ71UtRHZhwp
	 cS8dy+eyUiXWI1lhPM7vZ5KHivjKAdKh7PvaKQ2RoxbZutTURg934Gs6TMPByX6rW8yUi
	 t7bzUWggm9ReHnUOpXF5L7Z0bP2m6nqzZ7xVImGOoMrOxi7ulif13iemxUo5/ktqq9BIq
	 eRgSkZioPzlE8FxRtDp7b737eTJ/cRNWgGMZhHNvThcgKoHnMj1+8GnSYHnQNbwf9x5o4
	 vtuUjHJT84aWZ7EDwPl+Grn0lD7RnZEuF7dcqGgXekIeICD9xzAb/ezEbcYYlHzxx/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257595;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cVYhi7/88p+bsOE8e9smQX3u1NpKcI65AIXn+LGTgfo=;
	b=k8IqG9MY4Shy7ogvYqNvKi/FRQ279tJGoKegQzfrpiUCYUzZYzNVdPw0CPLUxHthjAml
	 xEM6ypJwCyFOwWFstGgraImIrT/mUaYo0IcYQH6rWPrF1RVoKXmaE/Bfok1qWOPtYGQ9G
	 ijLwgZH/YycRJE+lqOcKeGuWrUJWnYHRA59X+NnmoU5j5PU5u3rW/TVSNZUMA18KuvtnL
	 mxhKWtMfPN+WlAbHAt1vwsQhFL+ryBKbg1vuT3d27oXQPpjFSUfWqRKZdsAx+6CzKTwFf
	 k+BB0yOp5uS8tz+wEMbWloKxBWNZqw6nSUnPEKsBuheva5L6NGWQ8wNaac+b72ikPRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e6A1md+A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC835606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e6A1md+A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862341F0089F;
	Mon,  9 Nov 2026 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257594;
	bh=cVYhi7/88p+bsOE8e9smQX3u1NpKcI65AIXn+LGTgfo=;
	h=Date:To:From:Subject;
	b=e6A1md+AFXffuL2GGzFTxYaG7LxtJG3S09ipV9fXP8aVEjVoRD3CeTQu8S4CNXd1g
	 061e7hzY0xpHYu+Of5ESDGcx+EFc5tXU7vDTeAmcC8me2nhxIcMsKJ+ifHM48jxZjZ
	 7XLB9PMZlfydigqgPazi1DEgbkQANFyHGBot/Bvc=
Date: Mon, 09 Nov 2026 12:53:14 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-dinode-refcount-location-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205314.862341F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the dinode refcount location check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-dinode-refcount-location-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-dinode-refcount-location-check.patch

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
Subject: ocfs2: abstract the dinode refcount location check
Date: Mon, 09 Nov 2026 20:21:08 +0800

Fold the OCFS2_HAS_REFCOUNT_FL without i_refcount_loc test into a
predicate.  The flag test stays inside it, since i_refcount_loc is only
meaningful for a reflink-capable inode.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-19-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-dinode-refcount-location-check
+++ a/fs/ocfs2/inode.c
@@ -254,6 +254,12 @@ static bool ocfs2_dinode_has_bad_chain_b
 		le16_to_cpu(di->id2.i_chain.cl_bpc) != bpc;
 }
 
+static bool ocfs2_dinode_has_refcount_without_loc(struct ocfs2_dinode *di)
+{
+	return (le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
+		!di->i_refcount_loc;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1891,8 +1897,7 @@ int ocfs2_validate_inode_block(struct su
 		}
 	}
 
-	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
-	    !di->i_refcount_loc) {
+	if (ocfs2_dinode_has_refcount_without_loc(di)) {
 		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
 				(unsigned long long)bh->b_blocknr);
 		goto bail;
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

