Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795577088;
	b=k1YJ8H0vyU+T1qKryQfDI3VHtGXX/VzuBbaMEeV1LNdz5YzxywAPmfV/+kQu9TpsikN7
	 OlngnLcabwDD15RQKq2SaElS0pHwBQWw1NI+lD+fL0eqrJdyQaxcjzqXnRftS/3eeBV0L
	 +o1C+UYipCbzblOU6Va+E4N63yHeKqS9Q3mPtVyzBiwNnw3oYK2aQFFmvGNgrnUHR+Bsm
	 k3gQiIMzhitajMHEsiDVqJZpDmHrummXM6F1SGPYUkZbYit+baR8WwpycdF0SubJ5kzXN
	 aQqMSoWdM1B8KVFx1aibRE+c0NJslP9S4mAvHuu9/fK6pHcyrORKhAoXMIUcrv/EQvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795577088;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=5suKI1FZCJIGZvx2Wse2R/N+TBCBfJMEXMDElTxOhsw=;
	b=2aldDsg6jBHSfvbZHReQv5vJJLV9T8SeH9hwZx5OEpNJx4BD4Roxaze14hgMekVRti0C
	 D3VOEYxgiDZ/uEMitIve2krG0Uf47Zle8R1NB9ABOevJnUmLHp6kIYFXJaf0Hls3P8gYc
	 7mTpdot4Vy49iz8/38FziqJmFZToOwQNVjycPKatTX+pIBvNv9VD/lNWio+s7Xn/ktLjP
	 PpX8pQRSSO58YxeISwqWDu6oe4kqS767R5QnFqp6HgRJ7TKR/489w+P3AuIsG3CIbCGoY
	 o6TW3VXKc4shLcLweHEG/2OqDGze+4+rWnd/VZ04Wh06CsuQDFcIuGY09KrwCRuWfzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jLiK2EUL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B08606A31E;
	Wed, 25 Nov 2026 03:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jLiK2EUL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667CC1F000CA;
	Wed, 25 Nov 2026 03:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795577087;
	bh=5suKI1FZCJIGZvx2Wse2R/N+TBCBfJMEXMDElTxOhsw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=jLiK2EULRkzaO1GqE+KHkjsIRh9ecl2lv9dVCeSccJ3OyeXPw9cOeOWHtHvlMEUUo
	 hdcfhQOaeCl7VC2TLGXw65gO3lPmbib+uxm03LZQgHAcwkmfDbt/hxa5zzeM1o762+
	 q6OJeoFU9M0Lo5Ej9JRxbgjHhUuPNFZXgNBXiOXM=
Date: Tue, 24 Nov 2026 19:24:46 -0800
To: mm-commits@vger.kernel.org,
	syzbot+487e39304129321dd253@syzkaller.appspotmail.com,stable@vger.kernel.org,
	mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,firefly0158@163.com,
	joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125025505.343454-1-joseph.qi@linux.alibaba.com>
References: <20261125025505.343454-1-joseph.qi@linux.alibaba.com>
Subject: + ocfs2-dont-bug_on-when-a-group-extend-leaves-too-few-free-bits.patch added to mm-nonmm-unstable branch
Message-Id: <20261125032447.667CC1F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: don't BUG_ON when a group extend leaves too few free bits
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dont-bug_on-when-a-group-extend-leaves-too-few-free-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dont-bug_on-when-a-group-extend-leaves-too-few-free-bits.patch

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
Subject: ocfs2: don't BUG_ON when a group extend leaves too few free bits
Date: Wed, 25 Nov 2026 10:55:03 +0800

ocfs2_reserve_suballoc_bits() extends a metadata chain allocator by
one block group when it holds fewer free bits than the caller wants,
then asserts that the extend satisfied the request.

That assertion trusts the on-disk allocator geometry.  With
id2.i_chain.cl_cpg and cl_bpc both set to 1, ocfs2_bits_per_group()
returns 1, so the only bit of the new group is consumed by its own
descriptor and ocfs2_block_group_fill() leaves bg_free_bits_count at
0.  The extend then adds 1 to both i_total and i_used, free_bits
stays 0, and BUG_ON(bits_wanted > i_total - i_used) fires on a plain
open(O_CREAT):

    ocfs2_reserve_suballoc_bits
    ocfs2_reserve_new_metadata_blocks
    ocfs2_mknod
    ocfs2_create
    path_openat

The reservation runs before ocfs2_start_trans(), so no transaction is
open and no dquot is charged when it fires.

Report the volume as errored instead, the way the missing
OCFS2_CHAIN_FL check just above already does.  The status is not
-ENOSPC, so callers propagate it rather than falling back to stealing
from another slot.  No new unwind is needed: ac->ac_bh is not set yet
on this path, so the bail label only releases the local bh, and the
allocation context is freed by the callers' existing error paths.
ocfs2_block_group_alloc() has already committed its own transaction,
so the degenerate group stays on disk - which is what every other
ocfs2_error() corruption path leaves behind.

Link: https://patch.msgid.link/20261125025505.343454-1-joseph.qi@linux.alibaba.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+487e39304129321dd253@syzkaller.appspotmail.com>
Cc: CJ <firefly0158@163.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>

 fs/ocfs2/suballoc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/suballoc.c~ocfs2-dont-bug_on-when-a-group-extend-leaves-too-few-free-bits
+++ a/fs/ocfs2/suballoc.c
@@ -957,10 +957,16 @@ static int ocfs2_reserve_suballoc_bits(s
 		}
 		atomic_inc(&osb->alloc_stats.bg_extends);
 
-		/* You should never ask for this much metadata */
-		BUG_ON(bits_wanted >
-		       (le32_to_cpu(fe->id1.bitmap1.i_total)
-			- le32_to_cpu(fe->id1.bitmap1.i_used)));
+		/* Corrupt geometry can extend by a group with no usable bits. */
+		free_bits = le32_to_cpu(fe->id1.bitmap1.i_total) -
+			le32_to_cpu(fe->id1.bitmap1.i_used);
+		if (bits_wanted > free_bits) {
+			status = ocfs2_error(alloc_inode->i_sb,
+					     "Invalid chain allocator %llu: %u free bits after group extend, %u wanted\n",
+					     (unsigned long long)le64_to_cpu(fe->i_blkno),
+					     free_bits, bits_wanted);
+			goto bail;
+		}
 	}
 
 	get_bh(bh);
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

