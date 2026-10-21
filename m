Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560628;
	b=jq3o7TS26p67Z/dWHD4Qd/mDoFphInDP31r160bJft3ODXWqnN23gyobJNdFzHzezbBy
	 WaRA7gqC/+CL9VE1NXtvtCPSMKvrkyRG3GSMmeapHU1+O4mhKjVWXe0ES+xNSpFFYM+ia
	 RayQc7lfBdM2zp0aFof1ZrL1evxjAbP0IcnRSu3PJCj+RRwxAbUZSsvX5ahRn8UPfzXHJ
	 gZPQ9jd1O1wBPJNqQC0K16nJ3Fy1j3Em24uo2/6cafVTofV7pFqHpr+TujJlCwIEmEULN
	 88AesGrevEjrN1jBJHBb2J+agzA64Jh2ukdZYThcI8EoIh6HgwvQp7DWgKFcZbvM9QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560628;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=aiikYOZfnFWixi7Z7rJ7TrZKJwMLtSBmaDgz9NbJP9Q=;
	b=11tDE/v67dStJfC5gsMVw9mDqBPHJNO83DNyiVWHrj2qsjXeBZpm54GxrpJfSk6JoLLz
	 nBSLHxYeSWUHV7gc+TA47YZ24/ZLSH3qFUyQBz/sp9CpIXMZ6pks/FVKYL22B2xBmEoMj
	 ehKcA4KsNXalVoG+LQBUqu5mXewNiUgHjDMoAsnQdsziCn46WVlgRQFUckwuNAH3wMWXH
	 xHSFc/YIuTT4rVzQjCmH/dz9aalQ4Ql1XL3Vr+u0VbNnIMlKFfa/2GRJRu/Mu1QO/ssKB
	 S1y+R3AG4VpZIQe+4OZiiCKsmW05eKrtMymroVyvg0zVHLGbMBOtt6mlwdGa3TCoiEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qbvmkWPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903A1606A319
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qbvmkWPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1E31F000C9;
	Wed, 21 Oct 2026 05:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560628;
	bh=aiikYOZfnFWixi7Z7rJ7TrZKJwMLtSBmaDgz9NbJP9Q=;
	h=Date:To:From:Subject;
	b=qbvmkWPcYWLIYS2BirDlBBfQDkyerFRh4f7lxR2Dt7q97xA4UjT60vszY5UxZwSDg
	 UriM93aK0xXQ0MBjt4I6We+Sdb5NJbZ4cmeLIfO43Dl8JxNIcc/v02jrPoRe1FK37T
	 TjGWdu0ckWH5N9PN9TbktelclkxZrCxKm6V1IwXs=
Date: Tue, 20 Oct 2026 22:30:27 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-reserve-xattr-value-tree-metadata-only-once.patch removed from -mm tree
Message-Id: <20261021053028.2C1E31F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: reserve xattr value tree metadata only once
has been removed from the -mm tree.  Its filename was
     ocfs2-reserve-xattr-value-tree-metadata-only-once.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: reserve xattr value tree metadata only once
Date: Sat, 10 Oct 2026 19:34:54 +0800

ocfs2_calc_xattr_set_need() asks for the new value's extent tree twice
when it replaces an inline value smaller than a value root with one large
enough to be stored outside.  The "stored outside" branch reserves the
tree and then falls through to meta_guess instead of going out:

        if (!ocfs2_xattr_is_local(xe)) {
                ...
                xv = (struct ocfs2_xattr_value_root *)
                     (base + name_offset + name_len);
                value_size = OCFS2_XATTR_ROOT_SIZE;
        } else
                xv = &def_xv.xv;

        if (old_clusters >= new_clusters) {
                ...
                goto out;
        } else {
                meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
                ...
                if (value_size >= OCFS2_XATTR_ROOT_SIZE)
                        goto out;
        }

On the fall-through xv is def_xv, so what gets added here is the two
blocks ocfs2_extend_meta_needed() wants for an empty value root -- and
both sides of meta_guess reserve that same tree again.  The create side
has done so since commit 3ed2be719eb9 ("ocfs2: allow for more than one
data extent when creating xattr"), which ported this reservation to the
create case without noticing it was already on the way in, and the
existing-block side since commit 0cdc7dde00ec ("ocfs2: fix missing
metadata reservation for large xattrs").  Both were chasing the same
RESTART_META failure in ocfs2_xattr_extend_allocation(), for xattr create
and then for xattr update.

ocfs2_init_xattr_set_ctxt() hands the total straight to
ocfs2_reserve_new_metadata_blocks(), so the surplus is two blocks held for
the whole transaction.  A setxattr that would otherwise fit can come back
-ENOSPC on a filesystem whose metadata allocator is nearly exhausted.

Move the reservation into the branch that stops there, leaving meta_guess
as the only place that reserves for a value tree the fall through is about
to create.  The paths that do go out keep reserving against the value root
they already have, which for an external old value is the on-disk one and
so can legitimately ask for more than two blocks.

Both sides of meta_guess have to come out even on their own now that the
copy covering for them is gone.  The existing-block side only started
reserving the value tree in the commit this one is tagged against.  The
create side has reserved the tree since 3ed2be719eb9, but only the tree:
the block ocfs2_create_xattr_block() claims came out of the same two, and
on the fall-through it was the duplicate removed here that made up the
difference.  So "ocfs2: reserve metadata for a new xattr block and its
value tree" has to land first -- without it the create side reserves 2
where 3 are needed and the value tree is back to RESTART_META.  That one
fixes a shortfall of its own on the path that reaches meta_guess directly,
where there was never a duplicate to cover it, so it is worth taking
alone; this patch is not.

Link: https://lore.kernel.org/20261010113454.1420939-4-joseph.qi@linux.alibaba.com
Fixes: 0cdc7dde00ec ("ocfs2: fix missing metadata reservation for large xattrs")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/xattr.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-reserve-xattr-value-tree-metadata-only-once
+++ a/fs/ocfs2/xattr.c
@@ -3509,12 +3509,21 @@ static int ocfs2_calc_xattr_set_need(str
 			credits += ocfs2_remove_extent_credits(inode->i_sb);
 			goto out;
 		} else {
-			meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
 			clusters_add += new_clusters - old_clusters;
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
 							     &xv->xr_list);
-			if (value_size >= OCFS2_XATTR_ROOT_SIZE)
+			/*
+			 * The old value occupies at least as much room as a
+			 * value root, whether it sat outside or inline, so the
+			 * new root fits where it was and no new xattr block or
+			 * bucket is needed -- only the metadata to extend the
+			 * tree hanging off it.  A smaller one is replaced
+			 * outright, which meta_guess below reserves for.
+			 */
+			if (value_size >= OCFS2_XATTR_ROOT_SIZE) {
+				meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
 				goto out;
+			}
 		}
 	} else {
 		/*
@@ -3566,6 +3575,10 @@ meta_guess:
 		 * Reserve metadata for the new xattr's value extent tree.
 		 * The not_found path above adds credits for this tree but
 		 * omits meta_add, leaving meta_ac NULL for large values.
+		 *
+		 * This is all of meta_ac on this side beyond the xattr tree
+		 * above: no xattr block is allocated here, and a new bucket or
+		 * index block is paid for out of data_ac.
 		 */
 		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
 			meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


