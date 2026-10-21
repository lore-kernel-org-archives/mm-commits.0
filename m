Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560626;
	b=qDPV8qM/nhjlsHHGtzW8MFODD5UWVRYfOe5HMDVS6qtwq2DZoDKp9/t9/b9sM+8CZsQg
	 Vdulwx2lSDJ8VVo51vQyKL+aEXA53Bop/3vEoyBcrapJa7VzKNXLnKIHGuOfZ9kok7naZ
	 ts3W6aqzU81KHGektuWcOlFKLAIQKHhQ0VTI60bFnCi5U1vYEp5SmRH6v9TZqrQgHpNBd
	 iuwD51JKUkq9lstQdeMQ2pcwUA3SgqzrAqyRhXU3TguqavXcYRytvSs/aeP47jcx4+zOF
	 hktS+8ZuCuvHRi8t2as0Dvuad92Dxay950DG1AWvPe+l5RiJfQBv/S+EYwCyO1MHAKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560626;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FAlx6RviHCyh2TI/XBL4gsB7g/Zon2vEpuJDcou8a3w=;
	b=3T0Tt8D0Ptx869QSyWp89gIwNKwH2lZrlQnKQ8wuDXdsdNQtfhCU266hDrknhZmdhLoc
	 X3UnWylk2aOhXRdsA2bH26x8vBwgFMzb1KeEc7/JLI8SlOXryIITTtrii6VFQkaQjarIE
	 n5UXv2EGwf6S/bKZB/wDF7D1gAZKfvKw10IbCayjLB6BaCBLIyfxPhxwyztVABi9LMcQ8
	 3+Pg0SbYXABkfYZL36hcTZaozjPLj5eG7iPUGOiwX7WwJY9aVJ7hI1yMIKOckAFhfgtQF
	 mtnP5aQpV4YOfos689fzv3J0NLXBouDamYGUbfb4/CiUlkiXnqwzb/pJFrvLdh+VzPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="oVYB/FI4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8D7606A31A;
	Wed, 21 Oct 2026 05:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oVYB/FI4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EEF1F000C9;
	Wed, 21 Oct 2026 05:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560625;
	bh=FAlx6RviHCyh2TI/XBL4gsB7g/Zon2vEpuJDcou8a3w=;
	h=Date:To:From:Subject;
	b=oVYB/FI4/tb55J9yzDLBfDPdgSknVL6d3MlqD69vpeIKQ+ZtgHouVnO214YcCL9XG
	 uj11Ym2mnvfUYr3dJyKFRvg2/gGc/mftn1skThftQOYOe9vXbBqL42vWBd5K95Rx66
	 Oe2HyfhYIQrJioZacbgN+4yyAj4uRE/C6AQhNPQE=
Date: Tue, 20 Oct 2026 22:30:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch removed from -mm tree
Message-Id: <20261021053025.D6EEF1F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: reserve metadata for a new xattr block and its value tree
has been removed from the -mm tree.  Its filename was
     ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: reserve metadata for a new xattr block and its value tree
Date: Sat, 10 Oct 2026 19:34:52 +0800

Patch series "ocfs2: fix metadata reservation for xattr value trees".

ocfs2_calc_xattr_set_need() reserves too little metadata for a new xattr
value's extent tree on three paths.  The reservation cannot be topped up
once the transaction has started, so ocfs2_add_clusters_in_btree() gives
up with RESTART_META when the value root fills and nothing is left. 
ocfs2_xattr_extend_allocation() turns that into -ENOSPC, after
ocfs2_xa_cleanup_value_truncate() has dropped the entry and leaked the
clusters already handed out; before commit 0cdc7dde00ec ("ocfs2: fix
missing metadata reservation for large xattrs") it was a BUG_ON() instead.
It takes a fragmented cluster allocator to get there, since the first
extent always fits in the root.

Patch 1 fixes the create side of meta_guess: commit 3ed2be719eb9 ("ocfs2:
allow for more than one data extent when creating xattr") replaced the
block reserved for the new xattr block with the two the value tree needs
instead of adding them together.

Patch 2 fixes the arm that moves an xattr back into the inode, which
charges credits for a value tree but no metadata for one.

Patch 3 drops a second copy of the same reservation on the path that falls
through to meta_guess.  That one is cleanup rather than a fix and is not
for stable, and it must not be backported without patch 1: the duplicate
it removes is what currently covers the shortfall patch 1 fixes.


This patch (of 3):

The create side of meta_guess in ocfs2_calc_xattr_set_need() reserves
metadata for the new value's extent tree and nothing for the xattr block
that will hold it:

        } else {
                credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
                if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
                        struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
                        meta_add += ocfs2_extend_meta_needed(el);
                        ...

Commit 3ed2be719eb9 ("ocfs2: allow for more than one data extent when
creating xattr") meant to add that tree on top of the meta_add += 1 the
branch already had, but it moved the 1 into the else arm instead, so the
external-value case lost it.  The 1 is not optional: it is what
ocfs2_create_xattr_block() takes from meta_ac through
ocfs2_claim_metadata(), and it is spent before the value tree exists.

ocfs2_extend_meta_needed() on the empty def_xv list returns 2, so the
branch reserves 2 where 3 are needed.  The xattr block consumes one, and
when the cluster allocator is fragmented enough that the value needs more
than one extent, ocfs2_add_clusters_in_btree() comes back around with a
full value root and ocfs2_alloc_context_bits_left() of 1 against a
threshold of 2.  It answers RESTART_META, which
ocfs2_xattr_extend_allocation() turns into a BUG_ON().  Commit
0cdc7dde00ec ("ocfs2: fix missing metadata reservation for large xattrs")
downgraded that to -ENOSPC, at the cost of leaking the clusters already
handed out: ocfs2_xa_cleanup_value_truncate() takes its !orig_clusters
arm, drops the entry and leaves the clusters for fsck.ocfs2 to reclaim.

Reserve for the block and the tree separately.

Link: https://lore.kernel.org/20261010113454.1420939-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20261010113454.1420939-2-joseph.qi@linux.alibaba.com
Fixes: 3ed2be719eb9 ("ocfs2: allow for more than one data extent when creating xattr")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/xattr.c~ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree
+++ a/fs/ocfs2/xattr.c
@@ -3580,7 +3580,13 @@ meta_guess:
 		credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
 		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 			struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
-			meta_add += ocfs2_extend_meta_needed(el);
+			/*
+			 * One block for the xattr block we may have to
+			 * allocate, the rest for growing the value tree it
+			 * would hold.  If ocfs2_xattr_ibody_set() succeeds
+			 * instead, that first block goes unused.
+			 */
+			meta_add += 1 + ocfs2_extend_meta_needed(el);
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
 							     el);
 		} else {
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


