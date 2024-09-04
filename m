Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4B713D28F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 21:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725484583; cv=none; b=cyaXZ+C1+7q9ZnPLnjQP3SGtsWQn5xfRMMLXVi4fnCdeMR8WbG9c96aCuwgKEHENo62EgdomAdzdxHJdEKw3cYTvX7bghZeDpl3QgtMiSsZyjkY27lXMBvOdWmTh0LfvAKBRL68oAGmZSX3ng3ZA8fPrLdRmXexUSS4p4TK7Akc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725484583; c=relaxed/simple;
	bh=PPLq4OzQkA+QheCt2DUVDuYGnT5Wd9ZH61WgZK+YBmU=;
	h=Date:To:From:Subject:Message-Id; b=O5p8NTtxBq7YUhHqE4i6dadslJ3an1j4cotPr5Dwogvl2G533pcqujmHFaJt1ObiL1wRDIfjct859kndXcByX/Vmg5x9z6SoljS7tXEGyayAupFwfoJ8GdNWq7xuLSYjAARyYEHyKF5dPZshCI3i+6Jk9sYok+1oCo1+Dwr/y+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=znEbyby1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="znEbyby1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD05C4CEC2;
	Wed,  4 Sep 2024 21:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725484583;
	bh=PPLq4OzQkA+QheCt2DUVDuYGnT5Wd9ZH61WgZK+YBmU=;
	h=Date:To:From:Subject:From;
	b=znEbyby145ZtrSlFsZ0ilS4nnN28uvp23fZ/hlFZ0/aTpp7nwL8Zgnf8jPE7PmbgP
	 /OxnpY+33asYggUbXBt3mvAywnlkZnhhK+XHbMELU8kLHPJ2CqqQ6DMWxG1d9ojjWq
	 d0sbxsbxXs13A9i0QvitmePRjGD21wy9wZjrgK2Y=
Date: Wed, 04 Sep 2024 14:16:22 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cleanup-return-value-and-mlog-in-ocfs2_global_read_info.patch added to mm-nonmm-unstable branch
Message-Id: <20240904211623.0CD05C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: cleanup return value and mlog in ocfs2_global_read_info()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cleanup-return-value-and-mlog-in-ocfs2_global_read_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cleanup-return-value-and-mlog-in-ocfs2_global_read_info.patch

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cleanup return value and mlog in ocfs2_global_read_info()
Date: Wed, 4 Sep 2024 15:10:04 +0800

Return 0 instead of sizeof(ocfs2_global_disk_dqinfo) that .quota_read
returns in normal case.  Also cleanup mlog to make code more readable.

Link: https://lkml.kernel.org/r/20240904071004.2067695-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-cleanup-return-value-and-mlog-in-ocfs2_global_read_info
+++ a/fs/ocfs2/quota_global.c
@@ -371,12 +371,16 @@ int ocfs2_global_read_info(struct super_
 
 	status = ocfs2_extent_map_get_blocks(oinfo->dqi_gqinode, 0, &oinfo->dqi_giblk,
 					     &pcount, NULL);
-	if (status < 0)
+	if (status < 0) {
+		mlog_errno(status);
 		goto out_unlock;
+	}
 
 	status = ocfs2_qinfo_lock(oinfo, 0);
-	if (status < 0)
+	if (status < 0) {
+		mlog_errno(status);
 		goto out_unlock;
+	}
 	status = sb->s_op->quota_read(sb, type, (char *)&dinfo,
 				      sizeof(struct ocfs2_global_disk_dqinfo),
 				      OCFS2_GLOBAL_INFO_OFF);
@@ -404,12 +408,11 @@ int ocfs2_global_read_info(struct super_
 	schedule_delayed_work(&oinfo->dqi_sync_work,
 			      msecs_to_jiffies(oinfo->dqi_syncms));
 
-out_err:
-	return status;
+	return 0;
 out_unlock:
 	ocfs2_unlock_global_qf(oinfo, 0);
-	mlog_errno(status);
-	goto out_err;
+out_err:
+	return status;
 }
 
 /* Write information to global quota file. Expects exclusive lock on quota
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-cancel-dqi_sync_work-before-freeing-oinfo.patch
ocfs2-cleanup-return-value-and-mlog-in-ocfs2_global_read_info.patch

