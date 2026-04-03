Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027B53D0917
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775236471; cv=none; b=G91sUDJRglCzb5CLqeBvQKzRIRbFFlqrBAZhNAeaQ0cfxuGPupoEPQIv9AG+ESikSmJOTjDYIlQHp3bLH0tVSem+Of3x1PobCkbBP9TQfpqNDFnDSHmothSWeBGEm04QxQCV0roaJt+w4Fu9nttRa61itN/J0zT6Ik79TW05EP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775236471; c=relaxed/simple;
	bh=fNaJbPaZkhVMcd1GSrJVsevNOVzPM71LQDggduuIrWY=;
	h=Date:To:From:Subject:Message-Id; b=KbeVUN3BPvYLvZQzKzFdoYbud1PTeaSlXhKIXjL3TFAG7/tQcqS5INK78RJowHphwhjS162j5/inHNLhbefgdndFtUDuw8xvBB2By/UC9rWtAREnlRLnHhW8kkSL3IGDs45fT1Ty1xWHEN4SDj3tYnmeNdnUnr/fpzs9jZSn/ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UGQJXSvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UGQJXSvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91682C4CEF7;
	Fri,  3 Apr 2026 17:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775236470;
	bh=fNaJbPaZkhVMcd1GSrJVsevNOVzPM71LQDggduuIrWY=;
	h=Date:To:From:Subject:From;
	b=UGQJXSvSYb92E8eHuVXaop5Y0iaANLqre31XuaCW4PjgYmCcRI/iB8a6lnEaJkXXC
	 jWr4Bz5nhKPsKeHrDLXkxZCkW7irtFWu2PRbtc3Aw+xgdC7MISXV4nj39Emx/lOk8/
	 U8v/QGkzenOwOusO8M4Lhp09oegGzG90Uje4IWJs=
Date: Fri, 03 Apr 2026 10:14:30 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path.patch added to mm-nonmm-unstable branch
Message-Id: <20260403171430.91682C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove redundant l_next_free_rec check in __ocfs2_find_path()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path.patch

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
Subject: ocfs2: remove redundant l_next_free_rec check in __ocfs2_find_path()
Date: Fri, 3 Apr 2026 17:08:03 +0800

The l_next_free_rec > l_count check after ocfs2_read_extent_block() in
__ocfs2_find_path() is now redundant, as ocfs2_validate_extent_block()
already performs this validation at block read time.

Remove the duplicate check to avoid maintaining the same validation in two
places.

Link: https://lkml.kernel.org/r/20260403090803.3860971-5-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path
+++ a/fs/ocfs2/alloc.c
@@ -1878,18 +1878,6 @@ static int __ocfs2_find_path(struct ocfs
 		eb = (struct ocfs2_extent_block *) bh->b_data;
 		el = &eb->h_list;
 
-		if (le16_to_cpu(el->l_next_free_rec) >
-		    le16_to_cpu(el->l_count)) {
-			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has bad count in extent list at block %llu (next free=%u, count=%u)\n",
-				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
-				    (unsigned long long)bh->b_blocknr,
-				    le16_to_cpu(el->l_next_free_rec),
-				    le16_to_cpu(el->l_count));
-			ret = -EROFS;
-			goto out;
-		}
-
 		if (func)
 			func(data, bh);
 	}
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-out-of-bounds-write-in-ocfs2_write_end_inline.patch
ocfs2-validate-dx_root-extent-list-fields-during-block-read.patch
ocfs2-remove-empty-extent-list-check-in-ocfs2_dx_dir_lookup_rec.patch
ocfs2-validate-extent-block-list-fields-during-block-read.patch
ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path.patch

