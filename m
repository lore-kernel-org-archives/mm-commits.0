Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9AE3C108B
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791650907; cv=none; b=SFopvLWItx9fM/chjFjUyxha6jKEa0VvpUe0FptBckYtkJW6/Jz9U0mZZHP4ShkmVIK3SHgW2EVbmGyPAYzggIY3vg3dZoToyFBpx08/Ae6QMJLxX1YrfMIahgKvbowDH0+K18qWSfy7mmvKpO7lYEF1tXjzfQwi99ZUDemT4Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791650907; c=relaxed/simple;
	bh=iOPG20iEluLZSdVs2+gglk+l2rqhdfgTyAO21n9Cxvw=;
	h=Date:To:From:Subject:Message-Id; b=M26tt/nUcWNz9I/KQGU5IHgOfbpQ4mnVqtJoc7ZAc5hKbWfcSU71bY/p9DqSmBdyjVBKGlu6KqRyPH4xVlFl+aPUi/DCxVqfI9ShCanlvu3leNd+VZVIlNSs5GZAgud1Q5EqvPmyyrHYSVMMlTNPdQadSRpJBS7LvoG5uuq7Sos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T98C8jM9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T98C8jM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FC51F000FF;
	Sat, 10 Oct 2026 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791650905;
	bh=DiwxFHQ8kw6jzyoEJM88/0f2ZmmxVH1J37zFlZ8xOps=;
	h=Date:To:From:Subject;
	b=T98C8jM9cbJB6ocZaDz26cAf+yIXW9zALAuns4zs5k4b1L8UJ0oBh1Giy3FnTDy3g
	 PA1fj3FAtkTuvCW7cKmix+zf0e9SnRHKp1GlSjw1Ene+SaE9I7fINLVsosarStILIO
	 yauGhs3Vlj9QtqaF7iYc0K4GaGWoQQBs/yhkqo1A=
Date: Sat, 10 Oct 2026 09:48:25 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reserve-xattr-value-tree-metadata-only-once.patch added to mm-nonmm-unstable branch
Message-Id: <20261010164825.C1FC51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reserve xattr value tree metadata only once
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reserve-xattr-value-tree-metadata-only-once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reserve-xattr-value-tree-metadata-only-once.patch

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
@@ -3527,12 +3527,21 @@ static int ocfs2_calc_xattr_set_need(str
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
@@ -3584,6 +3593,10 @@ meta_guess:
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

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch
ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch
ocfs2-deal-with-legacy-signed-xattr-name-hash-values.patch
ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch
ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch
ocfs2-reserve-xattr-value-tree-metadata-only-once.patch

