Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDB773440
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925700; cv=none; b=NlgokoU+77I6dO81U5PTT4tBrQetgHRuxcXYdhhBt+sBy/VGbYpyKC9RdkxnE8GRYLzynAU+odclBzH2c88V9c9N9N25LpCxBq4s72SeAQ7VSwYoo6Kb0iCQqvmvc9J42LGVISchI75S0IPsw7B8OjTy5fr6aeqTEsjryvdumnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925700; c=relaxed/simple;
	bh=biah86QP7jzBujq6LLgHFkA4VG9dz2U9vLTTvMuYf/k=;
	h=Date:To:From:Subject:Message-Id; b=aX0LgC7Gs38JF45PnB5hMca8X8l7X1zkQlDP4JrKcvqpdryaBuRmj3kthTvS/hjOnmPf08Y0glY9KZADK4QOeQZRgETWHISw8wHSrvD9WndrcRDthX9gFXqA8AQcsVNewOB+H9+nUBLDM1G2Sx8IYlr2dwbevL7fI5Eb2ieBrF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qol11AjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qol11AjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A1DC4CEC5;
	Mon,  9 Sep 2024 23:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925700;
	bh=biah86QP7jzBujq6LLgHFkA4VG9dz2U9vLTTvMuYf/k=;
	h=Date:To:From:Subject:From;
	b=Qol11AjYQ+kBFX0vyw5P09CUpq0rPNB0D7YRulaTNU2wo7zHLTMEkmS7B21KHZg40
	 reAG4kFJFt9S4sE3Ep9adVpsBAkNrrUFo9a5D6abXeKKJQGfs3d9TtPGxOJeGH/fjR
	 3XEqq5m7N4iMxe6bf3PEjd+WwjEMk4AafcQ27dIY=
Date: Mon, 09 Sep 2024 16:48:19 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cleanup-return-value-and-mlog-in-ocfs2_global_read_info.patch removed from -mm tree
Message-Id: <20240909234820.68A1DC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: cleanup return value and mlog in ocfs2_global_read_info()
has been removed from the -mm tree.  Its filename was
     ocfs2-cleanup-return-value-and-mlog-in-ocfs2_global_read_info.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


