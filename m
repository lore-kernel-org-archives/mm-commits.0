Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC473BBFB7
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609818; cv=none; b=PJzsw7AGsTE/2JWFq2+iwI4m9twPn2sq6jfovQP0AsrsTb85h1oyJ/ML63vZvaJtU7b8zXO8xmOEyGEXxsJrYY0HQEIWzXGybWNIux0I4gKkGGmqsAK83ccnk1nNAgsjQBAWTbjOTx+rhJa4J/L5hQbFLMAmwJfAcpAWjEO6PFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609818; c=relaxed/simple;
	bh=DmV0rkUWoqOsrsHF+dyzmb3EBYyqS2NDUech/Iu2lCo=;
	h=Date:To:From:Subject:Message-Id; b=at3m6snegOCYsGpL+SJ/4t1R9yyv9d+MIXy6MxpIBB00pHymu6VdueX0t0OgcDlAjYrDuFDPkp0+jmVZXY5lzmk4gBp0LvyMnLvmTsBZpcD34l098E1ANN+QFuQTxgAu2Z0/aWw9FoniAog/d0ABXqwkY4EKUKEeMyYiS/pqPF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AhAxRlft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AhAxRlft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53F51F00899;
	Thu,  4 Jun 2026 21:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609816;
	bh=/aGxYBNsUDr6ppEGCOJhmnrs3IYABH8NHAp/6nEj+JU=;
	h=Date:To:From:Subject;
	b=AhAxRlftZcTFBOygJlaggp+BGQfZvoJQdU6eD8qz6+4FsnloP7ocFMHBYSi9hrnyV
	 iGKXTC0VMcsE0TPzix2Vq6bPvSCXgUn4m+j9d3oxfRwRIqRwKYWOoQNuSonem7d8fE
	 1T5qqQ2WBKRhzZjnSle6EMtRy0xlooSlX4nbfU/8=
Date: Thu, 04 Jun 2026 14:50:16 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,icb@fastmail.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-out-of-bounds-write-in-ocfs2_remove_refcount_extent.patch removed from -mm tree
Message-Id: <20260604215016.D53F51F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix out-of-bounds write in ocfs2_remove_refcount_extent
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-out-of-bounds-write-in-ocfs2_remove_refcount_extent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ian Bridges <icb@fastmail.org>
Subject: ocfs2: fix out-of-bounds write in ocfs2_remove_refcount_extent
Date: Mon, 1 Jun 2026 13:44:33 -0500

[BUG]
Unlinking a refcounted file whose refcount tree has leaf blocks
triggers a fortify panic due to an out-of-bounds write.

[CAUSE]
When the last leaf block is removed from a refcount tree,
ocfs2_remove_refcount_extent() converts the root back to leaf mode
with a bulk memset on &rb->rf_records. rf_records sits in an anonymous
union with rf_list. rf_list.l_tree_depth aliases rf_records.rl_count,
and is 0 for a single-level tree. With rl_count equal to 0, the memset
writes past the 16-byte declared size of rf_records, which the fortify
checker catches.

[FIX]
Replace the bulk memset on &rb->rf_records with a correctly-bounded
memset on rl_recs[] alone, after setting rl_count to the correct value.

Link: https://lore.kernel.org/ah3TESOsEO9j_JLU@dev
Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+3ef989aae096b30f1663@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3ef989aae096b30f1663
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-fix-out-of-bounds-write-in-ocfs2_remove_refcount_extent
+++ a/fs/ocfs2/refcounttree.c
@@ -2131,10 +2131,15 @@ static int ocfs2_remove_refcount_extent(
 		rb->rf_flags = 0;
 		rb->rf_parent = 0;
 		rb->rf_cpos = 0;
-		memset(&rb->rf_records, 0, sb->s_blocksize -
-		       offsetof(struct ocfs2_refcount_block, rf_records));
+		rb->rf_records.rl_used = 0;
+		rb->rf_records.rl_reserved2 = 0;
+		rb->rf_records.rl_reserved1 = 0;
+		/* rl_count determines the memset size and fortify object size. */
 		rb->rf_records.rl_count =
 				cpu_to_le16(ocfs2_refcount_recs_per_rb(sb));
+		memset(rb->rf_records.rl_recs, 0,
+		       le16_to_cpu(rb->rf_records.rl_count) *
+		       sizeof(*rb->rf_records.rl_recs));
 	}
 
 	ocfs2_journal_dirty(handle, ref_root_bh);
_

Patches currently in -mm which might be from icb@fastmail.org are


