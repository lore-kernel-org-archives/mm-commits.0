Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F3E4C6D
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908172; cv=none; b=ssBSUT0az1fmMlBcYOnODRTDNy03WsElvN9DiNkUQgMzwgnMzJ2jSlHnpdoijweIYteTCbXPCQDsPpu9jiC/msFD4E3rKVumCgB6BuGLinjX5eC2EhS2t0CATubt+GFw/81C6ubGAEISGsHwBHsCdFUIC17cja1O0CPOrpiGZNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908172; c=relaxed/simple;
	bh=iS8HAFPq3O0Wo85Tl7m+tGMoczGGrNQ5+htiPsOEJfQ=;
	h=Date:To:From:Subject:Message-Id; b=Yyr3t20zENRSyfy7TRnvfk0ucT9qHzscFOaadmZ9ApzhEYYiAtSBP49Qie8nRcg9jEIgOUqlI1vKM6hVgT0qVQbhXI3ZxX4auO2PrOarl9RySJcbLjTdRx1RMAZEUWF7bMQhN6GYPebD9LtlrzuCTgu4o4rBFHo48kcy4sXx2H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hQr0b6rB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hQr0b6rB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E625C19423;
	Wed, 12 Nov 2025 00:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908171;
	bh=iS8HAFPq3O0Wo85Tl7m+tGMoczGGrNQ5+htiPsOEJfQ=;
	h=Date:To:From:Subject:From;
	b=hQr0b6rBkhIGFdhRtTO/8G8eFRbomTKh1FUxZoKYQ83q1H2Vdcsw91zIbhdNAsQqt
	 5pxK/gOqjDh9jRdYlmph3CZ5B2e2ePhgLh8+kgx1H3dZMc8Ribzl78sOZ0rdoWnEtE
	 psBJF1LfqbvSVeS5nJdzxMtBnjMWI3FgMGgP5nN4=
Date: Tue, 11 Nov 2025 16:42:50 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch removed from -mm tree
Message-Id: <20251112004251.7E625C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix __counted_by_le() usage in ocfs2_expand_inline_dx_root()
has been removed from the -mm tree.  Its filename was
     ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix.patch

This patch was dropped because it was folded into ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: fix __counted_by_le() usage in ocfs2_expand_inline_dx_root()
Date: Tue, 14 Oct 2025 10:03:24 +0300

After annotating 'l_recs[]' VLA member of 'struct ocfs2_extent_list'
with '__counted_by_le(l_count)', 'l_count' should be initialized
before touching 'l_recs[]' with 'memset()' to avoid false positives
from buffer overflow guards when CONFIG_UBSAN_BOUNDS is enabled.

Link: https://lkml.kernel.org/r/20251014070324.130313-1-dmantipov@yandex.ru
Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-annotate-flexible-array-members-with-__counted_by_le-fix
+++ a/fs/ocfs2/dir.c
@@ -4104,10 +4104,15 @@ static int ocfs2_expand_inline_dx_root(s
 	}
 
 	dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
-	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
-	       offsetof(struct ocfs2_dx_root_block, dr_list));
+
+	dx_root->dr_list.l_tree_depth = 0;
 	dx_root->dr_list.l_count =
 		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
+	dx_root->dr_list.l_next_free_rec = 0;
+	memset(&dx_root->dr_list.l_recs, 0,
+	       osb->sb->s_blocksize -
+	       (offsetof(struct ocfs2_dx_root_block, dr_list) +
+		offsetof(struct ocfs2_extent_list, l_recs)));
 
 	/* This should never fail considering we start with an empty
 	 * dx_root. */
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-add-extra-flags-check-in-ocfs2_ioctl_move_extents.patch
ocfs2-relax-bug-to-ocfs2_error-in-__ocfs2_move_extent.patch
ocfs2-annotate-flexible-array-members-with-__counted_by_le.patch
ocfs2-add-extra-consistency-check-to-ocfs2_dx_dir_lookup_rec.patch
ocfs2-add-directory-size-check-to-ocfs2_find_dir_space_id.patch
ocfs2-add-boundary-check-to-ocfs2_check_dir_entry.patch
ocfs2-add-inline-inode-consistency-check-to-ocfs2_validate_inode_block.patch
ocfs2-add-extra-consistency-checks-for-chain-allocator-dinodes.patch

