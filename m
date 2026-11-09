Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257590;
	b=2FrtGLC9v6gbuTQFVvb3tzj4WjX+3+j5PwO/fjDfHyZhgG5aDcYwqi78lr5/cfhtR3dy
	 d2xKD663mius+AXM/rtp0S4QIJFv1fqx+iMg36Fh61T5Jnfg/e7NODo7IRB7BU0mRhOFh
	 GhyiTA9AlsOSFW1OpWo0jldPoBapXbvS20TL/6wZVZSi24mHOrkcZJPmRvu6JPBGnRV0g
	 /yagI17Wbkxm4e3Vows8AamMzeKhLCH/7ZkztR8uRbcQAESVu+oc6WQlh0DE15P0CFkzS
	 5BIXkRYMMMsZb5XXi65RnJebAJG4tYfVdR0mUeg0vyTL2CtVFM6DIKVLRzsjvVjKp1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257590;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=UDTxuD9rjaD8bBxNDEGipT0bCDiVXv1nEOxb0xcSs5w=;
	b=YTqulYybFZ84S5v5ka4v/w/UXus5XbAzwSsoIxMcB7+GHTMhPNBSHnY8e2kYruukne+X
	 cfYecNdPtUvD4fqSpuDtO1E1nOydePALbrI6BaykL8NANWCVjmPIarZrAvUkOpPTQi4Cy
	 5LfEZCPaboxS6q93Apjr/YgJm/N9I9O/mEGlBrxSHQ8PLacLKXEgUTZdujB/RHq6xI/1v
	 XwKIrXIU8DvfHsY2Jf7dsgIRqJoZ4dOg2rFh0gT0n/+U8w2JSpiDZruXB/1voycsYNIwJ
	 NO69KEsdHvCvSNdFTGE75ob0bw+7SoBe1VKAlK2qiDvrEv3IqWp2e65gHjWb5oLUDWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qQxORsuo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF04606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qQxORsuo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199871F0089F;
	Mon,  9 Nov 2026 20:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257590;
	bh=UDTxuD9rjaD8bBxNDEGipT0bCDiVXv1nEOxb0xcSs5w=;
	h=Date:To:From:Subject;
	b=qQxORsuoNU4yHH/+huUROC/zBQQwHkuo8NhPqkmeaAVcCIdTQTjv57YWtrt1YTFxF
	 7K3gVzfJ3SOTmiN311rX8JCvLBXMULGCgQ+qSoA3yDAPv4WvpeZKcXpybJQqVqDwz0
	 jzSrx3AJH/MfieHHPT5V8eX8Q6KBbdLuqnSd6eIk=
Date: Mon, 09 Nov 2026 12:53:09 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-chain-list-next-free-record-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205310.199871F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the chain list next free record check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-chain-list-next-free-record-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-chain-list-next-free-record-check.patch

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
Subject: ocfs2: abstract the chain list next free record check
Date: Mon, 09 Nov 2026 20:21:06 +0800

Fold the cl_next_free_rec against cl_count test into a predicate.

ocfs2_claim_suballoc_bits() in suballoc.c open-codes a similar test that
also rejects cl_next_free_rec == 0.  It is left alone because this
predicate is not equivalent to it.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-17-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-chain-list-next-free-record-check
+++ a/fs/ocfs2/inode.c
@@ -238,6 +238,12 @@ static bool ocfs2_dinode_has_bad_chain_c
 		ocfs2_chain_recs_per_inode(sb);
 }
 
+static bool ocfs2_dinode_has_bad_chain_next_free(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->id2.i_chain.cl_next_free_rec) >
+		le16_to_cpu(di->id2.i_chain.cl_count);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1863,7 +1869,7 @@ int ocfs2_validate_inode_block(struct su
 					 le16_to_cpu(cl->cl_count));
 			goto bail;
 		}
-		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+		if (ocfs2_dinode_has_bad_chain_next_free(di)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
 					 (unsigned long long)bh->b_blocknr,
 					 le16_to_cpu(cl->cl_next_free_rec));
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

