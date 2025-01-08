Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA4220B20
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736309502; cv=none; b=piSIhKvUd1s887RL3KZYu+anw7tCCBsLx6H8C5PwLtl5z10BV5AiET8CEdozuCDKrq/ZGev6wZIQgTmDyhXE8yu3nrUBz12FJ0VeyAcztnDl6NQdlr8noK+dVQ5+/hduph17vIrSbI7CXKCfXuzwUd6SdonPNL+kmF8QNndwp1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736309502; c=relaxed/simple;
	bh=tXtynqy/VgVrVqx+kuxzUlWo/ei/V9HW3rsSvzgUyzU=;
	h=Date:To:From:Subject:Message-Id; b=Zpr3/OCpKH7/D+mp5F/qE2pG/k50hiP+Eut1Oe2kdv8G8YIAD45pKwTuyjBnMy5aFou3tcjmSrawSTdbmk2qMXbLscmrNzQd5w0lU/M5iqxMkU1+x9VC9Qclr3zs9Wp4jUgVAOQR1mQSucoq9AHpG5y2j6ODFe3U917uea+IYAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sZUuVKCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sZUuVKCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4303C4CED0;
	Wed,  8 Jan 2025 04:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736309501;
	bh=tXtynqy/VgVrVqx+kuxzUlWo/ei/V9HW3rsSvzgUyzU=;
	h=Date:To:From:Subject:From;
	b=sZUuVKCLBWEMtwPQy2ufa04mgXY/6frRvQSJUoGm+K+35aibnFCJ3z8JJE7uND/xo
	 +0/vy3/BaF6pRC/o3VvQk+PpsUZdTgL4WAKbLdFRqQuoHSw/MiUna+1UqTOv7TukCP
	 qn4JEcVj6pZKwGCh5UgIXa/8NhlS6ceAzqsAcgHQ=
Date: Tue, 07 Jan 2025 20:11:41 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-parameter-parent_fe_bh-from-__ocfs2_mknod_locked.patch added to mm-nonmm-unstable branch
Message-Id: <20250108041141.D4303C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove parameter parent_fe_bh from __ocfs2_mknod_locked
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-parameter-parent_fe_bh-from-__ocfs2_mknod_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-parameter-parent_fe_bh-from-__ocfs2_mknod_locked.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: remove parameter parent_fe_bh from __ocfs2_mknod_locked
Date: Mon, 6 Jan 2025 22:06:34 +0800

The parameter is not used in __ocfs2_mknod_locked().  So remove it.

No functional change.

Link: https://lkml.kernel.org/r/20250106140634.92241-1-glass.su@suse.com
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-remove-parameter-parent_fe_bh-from-__ocfs2_mknod_locked
+++ a/fs/ocfs2/namei.c
@@ -508,7 +508,6 @@ static int __ocfs2_mknod_locked(struct i
 				struct inode *inode,
 				dev_t dev,
 				struct buffer_head **new_fe_bh,
-				struct buffer_head *parent_fe_bh,
 				handle_t *handle,
 				struct ocfs2_alloc_context *inode_ac,
 				u64 fe_blkno, u64 suballoc_loc, u16 suballoc_bit)
@@ -641,8 +640,8 @@ static int ocfs2_mknod_locked(struct ocf
 	}
 
 	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
-				    parent_fe_bh, handle, inode_ac,
-				    fe_blkno, suballoc_loc, suballoc_bit);
+				    handle, inode_ac, fe_blkno,
+				    suballoc_loc, suballoc_bit);
 }
 
 static int ocfs2_mkdir(struct mnt_idmap *idmap,
@@ -2576,7 +2575,7 @@ int ocfs2_create_inode_in_orphan(struct
 	clear_nlink(inode);
 	/* do the real work now. */
 	status = __ocfs2_mknod_locked(dir, inode,
-				      0, &new_di_bh, parent_di_bh, handle,
+				      0, &new_di_bh, handle,
 				      inode_ac, di_blkno, suballoc_loc,
 				      suballoc_bit);
 	if (status < 0) {
_

Patches currently in -mm which might be from glass.su@suse.com are

ocfs2-check-tl-count-of-truncate-log-inode-in-ocfs2_get_truncate_log_info.patch
ocfs2-mark-dquot-as-inactive-if-failed-to-start-trans-while-releasing-dquot.patch
ocfs2-remove-parameter-parent_fe_bh-from-__ocfs2_mknod_locked.patch

