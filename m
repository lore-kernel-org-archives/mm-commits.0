Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F38188713
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 01:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750209484; cv=none; b=LroJMNEb2PA30uHjRmVdB04pI3vR40EU+BXf/tpUKAKfnOWMEmW4IAE9DvH60s6pfen86xmE+nViHnor5zBEkOyOmwa1JbEdpUqFo2gNW3soiQrdn8oIgA9UsfXS3XOpK/pkaWtKcm+mgEOcp2EaFxQV5iIUvxpDbEoPhQncOFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750209484; c=relaxed/simple;
	bh=OHiJY5dVLHtb79/JCkQvCxmTicfG2aQFlIIbJP4bbOs=;
	h=Date:To:From:Subject:Message-Id; b=Z4rHVnCatufjIKe9psXykT0VIAWHQ7Mt9uPVpG24a0cCzhRwnHEMaepsJAyR4cRt4nrJPw4AZmMpk5Xm53+2aS3oRMfQuwjsMQOKO/1e2HHLcKWP8OblWUrT9d0wve2KlEV6z5XeOAHmct1MaOfH/4nzq4iRNXOLGZegt+hyUjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OJacyKo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OJacyKo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F6EC4CEE7;
	Wed, 18 Jun 2025 01:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750209483;
	bh=OHiJY5dVLHtb79/JCkQvCxmTicfG2aQFlIIbJP4bbOs=;
	h=Date:To:From:Subject:From;
	b=OJacyKo7Fu9x8towzccjoRsV6iGJiFLgOecC8q2UJcCVMYNrb5J6tnS6lhCvCgLGq
	 XhpvSbMs1PML7g+FpAflzXPS17b2tDNNDQ71BRKqP368AJcsfNnKw4yRxK4xbTKEDi
	 Lc3eM0tGj42i7nTTeOJ7iMmhbNElGC9VIktdduc0=
Date: Tue, 17 Jun 2025 18:18:03 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,glass.su@suse.com,gechangwei@live.cn,leo.lilong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-redundant-null-check-in-rename-path.patch added to mm-nonmm-unstable branch
Message-Id: <20250618011803.C3F6EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove redundant NULL check in rename path
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-redundant-null-check-in-rename-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-redundant-null-check-in-rename-path.patch

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
From: Long Li <leo.lilong@huawei.com>
Subject: ocfs2: remove redundant NULL check in rename path
Date: Tue, 17 Jun 2025 09:25:34 +0800

The code checks newfe_bh for NULL after it has already been dereferenced
to access b_data.  This NULL check is unnecessary for two reasons:

1. If ocfs2_inode_lock() succeeds (returns >= 0), newfe_bh is guaranteed
   to be valid.
2. We've already dereferenced newfe_bh to access b_data, so it must be
   non-NULL at this point.

Remove the redundant NULL check in the trace_ocfs2_rename_over_existing()
call to improve code clarity.

Link: https://lkml.kernel.org/r/20250617012534.3458669-1-leo.lilong@huawei.com
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-remove-redundant-null-check-in-rename-path
+++ a/fs/ocfs2/namei.c
@@ -1452,8 +1452,8 @@ static int ocfs2_rename(struct mnt_idmap
 		newfe = (struct ocfs2_dinode *) newfe_bh->b_data;
 
 		trace_ocfs2_rename_over_existing(
-		     (unsigned long long)newfe_blkno, newfe_bh, newfe_bh ?
-		     (unsigned long long)newfe_bh->b_blocknr : 0ULL);
+		     (unsigned long long)newfe_blkno, newfe_bh,
+		     (unsigned long long)newfe_bh->b_blocknr);
 
 		if (S_ISDIR(new_inode->i_mode) || (new_inode->i_nlink == 1)) {
 			status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
_

Patches currently in -mm which might be from leo.lilong@huawei.com are

ocfs2-remove-redundant-null-check-in-rename-path.patch

