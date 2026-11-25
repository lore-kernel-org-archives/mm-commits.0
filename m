Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795577090;
	b=lNsv5SO6OZCqHy4JX3W73N7i3y0BGjTzy/DtrIksGRZOq0WLckPm6S7czXd61RPv4On1
	 93pI0VH3WZ15tq06rht2xAikwXgwQWXVq83VWvkSceUwW/rEM5Ue/LOWD4SuSee7KW7jE
	 wfB+/njTXYmWQ7oQcVz3k2+6pbL7RDsoBP4sGDewIn1tRIVV8uCcz4wxW6ftECH40Vzqo
	 7sWWgGJI+Wqv1NELP9h2Y0fZXcPuYtWOyj6nzOyUVHKxSynjsyH6qaeDjO80jRawSuG7G
	 plt4Z8iXBmePiHG6/GFszrg3EnJB5iQrhzr16tdn2OiVsOYNKCBazbHujFFVriaMtIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795577090;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=adQhotf6LXRdLzlNCGfUmzLg18BIGlShXH0ca8Nrl9M=;
	b=01XiosEL3wRYuUrv0LRvUEY7zEIN4oa8tp4IOfwmHSKrWBSvLQm6bkhw7YSLi3KyCZVe
	 DK0in3JrJ8DUXEHQdvyWnUfC71gRL24QP4qTszkC9f/Mk0IczEbGCnoZlVmo7lKGJz0l2
	 mGoUsoJPl06o/xmBtJkCpURP6mmd+NOSFdYTbaaNwi3EGR1kQAKlDosfFqugBLqjhs0E3
	 HkBYdCFpx6S/rGE70bNUVM5Hb4zOd8kLHzURRFvgDmS6jpMqcImvsNGltvbWkBU3fp4fT
	 Erk80/cZkkrf82DCOfmDFEzFLGhxwVgfm0gzKoNdNF+90xXppGL19O0SsRRiQ1tq0Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rw9cjGuo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DA7606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 03:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rw9cjGuo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1821F000C4;
	Wed, 25 Nov 2026 03:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795577089;
	bh=adQhotf6LXRdLzlNCGfUmzLg18BIGlShXH0ca8Nrl9M=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=rw9cjGuoz/BbDIYHOleFcigB6oZtGBadyoGJ3pWryQzC5FTzw2rvAZxiAyISyr9UF
	 mUVnJZGBLzs841mkh+hO7vY+960Dr9MKOZedUyFJWVRT8VeHmm2X8973bvaM+3QHqL
	 o+10Fma4LxvDvSX+7uu9ozrDgrvSm5bOAkqJxbCU=
Date: Tue, 24 Nov 2026 19:24:49 -0800
To: mm-commits@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,
	heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125025505.343454-2-joseph.qi@linux.alibaba.com>
References: <20261125025505.343454-2-joseph.qi@linux.alibaba.com>
Subject: + ocfs2-validate-chain-allocator-clusters-per-group.patch added to mm-nonmm-unstable branch
Message-Id: <20261125032449.CC1821F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: validate chain allocator clusters per group
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-chain-allocator-clusters-per-group.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-chain-allocator-clusters-per-group.patch

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
Subject: ocfs2: validate chain allocator clusters per group
Date: Wed, 25 Nov 2026 10:55:04 +0800

ocfs2_validate_inode_block() checks cl_count, cl_next_free_rec and
cl_bpc on a chain allocator dinode, but never cl_cpg, even though the
suballocator reads it straight off disk to size every new block group.
A crafted value therefore survives all of the read time checks.

cl_cpg of 0 makes ocfs2_bits_per_group() return 0.  The cluster
reservation then succeeds with ac_bits_wanted of 0, and
__ocfs2_claim_clusters() trips BUG_ON(ac->ac_bits_given >=
ac->ac_bits_wanted) on the same open(O_CREAT) path that extends a
metadata allocator.

Reject a bits_per_group below 2 or above
ocfs2_suballoc_bits_per_block(sb) on every chain allocator but the
global bitmap, which is exempted exactly as in
ocfs2_dinode_has_bad_chain_bpc().  The lower bound is the invariant
the group extend relies on: bit 0 of a new group is its own
descriptor, so a group of fewer than two bits has nothing to hand
out.

The upper bound is the bitmap a suballocator group descriptor can
actually hold, the same limit ocfs2_validate_gd_parent() enforces on
bg_bits.  A larger product still fits the u16 bg_bits store, but lets
ocfs2_test_suballoc_bit() index past the end of the single-block group
buffer, since it bounds i_suballoc_bit by ocfs2_bits_per_group() alone,
and makes ocfs2_block_group_fill() commit a descriptor that
ocfs2_validate_gd_parent() then rejects.

No valid volume is affected.  mkfs writes the same cl_cpg into the
initial groups it creates, and geometry that did not fit the group
bitmap or left no allocatable bit would have made the allocator
unusable from the start.

The dinode is now rejected at read time, so iget fails and the
operation returns an error instead of reaching the suballocator.

Link: https://patch.msgid.link/20261125025505.343454-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>

 fs/ocfs2/inode.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-validate-chain-allocator-clusters-per-group
+++ a/fs/ocfs2/inode.c
@@ -254,6 +254,27 @@ static bool ocfs2_dinode_has_bad_chain_b
 		le16_to_cpu(di->id2.i_chain.cl_bpc) != bpc;
 }
 
+static bool ocfs2_dinode_has_bad_chain_cpg(struct super_block *sb,
+					   struct ocfs2_dinode *di)
+{
+	u32 bits_per_group = (u32)le16_to_cpu(di->id2.i_chain.cl_cpg) *
+		(u32)le16_to_cpu(di->id2.i_chain.cl_bpc);
+
+	/*
+	 * A block group holds cl_cpg * cl_bpc bits, the first of which is its
+	 * own descriptor, so fewer than two leaves nothing to allocate.  A
+	 * suballocator group descriptor is a single block, so the count must
+	 * also fit the bitmap size ocfs2_validate_gd_parent() enforces on
+	 * bg_bits.  The global bitmap is exempt as in the bits-per-cluster
+	 * check above: it never grows, and its group size comes from
+	 * ocfs2_group_bitmap_size() rather than from cl_cpg.
+	 */
+	return OCFS2_SB(sb)->bitmap_blkno &&
+		OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
+		(bits_per_group < 2 ||
+		 bits_per_group > ocfs2_suballoc_bits_per_block(sb));
+}
+
 static bool ocfs2_dinode_has_refcount_without_loc(struct ocfs2_dinode *di)
 {
 	return (le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
@@ -1919,6 +1940,12 @@ int ocfs2_validate_inode_block(struct su
 					 le16_to_cpu(cl->cl_bpc));
 			goto bail;
 		}
+		if (ocfs2_dinode_has_bad_chain_cpg(sb, di)) {
+			rc = ocfs2_error(sb, "Invalid dinode %llu: clusters per group %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(cl->cl_cpg));
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

