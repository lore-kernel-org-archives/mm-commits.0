Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFA13546FC
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338693; cv=none; b=hbl5Wde9R7fuvUTeZJalIdu6xs6m6+tZsXoljMepNaPGwiF7jRaOFJ1GD2pN2bAotC4SZBjg3Imbt6hnfGn5T9j7DMB8jU7mUZ08tNSZ2Km402zhYIjdt69s6qFAJpbmRYrugI6xU4xyOtwWM8EE8WG67dmLoGUbUu+5aZjkyDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338693; c=relaxed/simple;
	bh=NgVl3NFoVmpBM5S1M0Q7it8LMO5H1y0i+NXlNFgrWvk=;
	h=Date:To:From:Subject:Message-Id; b=mp8+vMybiJ08VsxmSnD+OEH45PFsAO3hmqTTw7w4RL8FoHHtvkjRDVuApV4pZaIXwtgBEntaDAgJayI+Qw6QyaUsj/FmtiM7Mzy6EhlXABu2H77QkzieLIjxr8nGM08DEShTLzC298cPOcC6WJa0T2jUeYEBgEz8a8/c19Def0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BB8Gw/a7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BB8Gw/a7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5431F0089C;
	Wed,  7 Oct 2026 02:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338692;
	bh=WdEkWCKHc6OHHit37hIOu+TSbmorwa4G7RiLBFgx1y4=;
	h=Date:To:From:Subject;
	b=BB8Gw/a76rlgymtKHIzk5lc/kehEFjkMtMpkk6IzXpwW84Le8Q7NSFWryg0Xzg9xW
	 m7HbEb2ZdvoWQwTrBdFZBGJUeiy8MxJZTRXzjO53qzkb3lEClRS5g0yd6Zqcs10jfw
	 M3huk7o4/7Kb8JL4RW2bMya86WJJx1z0vXPbeMUM=
Date: Tue, 06 Oct 2026 19:04:52 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch removed from -mm tree
Message-Id: <20261007020452.AF5431F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate dr_fs_generation of dir index root blocks
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: validate dr_fs_generation of dir index root blocks
Date: Sat, 5 Sep 2026 22:21:43 +0800

ocfs2_validate_dx_root() does not verify dr_fs_generation against the
superblock generation, unlike the extent and xattr block validators which
check h_fs_generation and xb_fs_generation respectively.  The field is
documented as "Must match super block".

Without the check, a stale dir index root block left on the device from
a previously formatted filesystem at the same physical block number can
pass validation as long as its signature, dr_blkno and checksum match.
Its index entries and suballocator information would then be used in
the new filesystem context.

Reject dir index root blocks whose dr_fs_generation does not match the
mounted filesystem, like the extent and xattr block validators do.

Link: https://lore.kernel.org/20260905142144.2869105-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
---

 fs/ocfs2/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks
+++ a/fs/ocfs2/dir.c
@@ -613,6 +613,14 @@ static int ocfs2_validate_dx_root(struct
 		goto bail;
 	}
 
+	if (le32_to_cpu(dx_root->dr_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has an invalid dr_fs_generation of #%u\n",
+				  (unsigned long long)bh->b_blocknr,
+				  le32_to_cpu(dx_root->dr_fs_generation));
+		goto bail;
+	}
+
 	/*
 	 * Dir index root blocks are allocated from a per-slot suballocator,
 	 * so the slot must be in range.  Otherwise removing the index passes
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

