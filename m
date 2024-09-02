Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6251114F10F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248835; cv=none; b=Er5fCK0OeQk/CvknZbCcjw4q2MfEqgLa44vTNJIMIM+GoqAFEQJ1DUkdHAkouutFqYfW+P8sKGGNrczD9yWpiSE3F4jnXnHmBu6wZMnsJAQZU70C+9PuWjauhGeXFjobIgV+rpf0734gj412286PnmWalOpWU9pSFbQ8OmUks7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248835; c=relaxed/simple;
	bh=YbGvbQQ1vfRjnxx6Bw9nhrZOKSwCmLmMv6EVFmoHme8=;
	h=Date:To:From:Subject:Message-Id; b=LTkFEa7Ved/IWkN8RHfzFZU9zc+FU/jDMRkPIh1xLYQBjRKl1Q0jHDw0mTI0ZOnK0ElO7f/mu4nNnLqU07aoVPe7dO48HC2xhx5ASLxHsAsxWhXVqs9uNPXxHnFL1TXWnfdobixV8fXl3x2Cm/5nWXKglJ64OfkrT8Ik0dcxb14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iwo94KM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iwo94KM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2D2C4CEC2;
	Mon,  2 Sep 2024 03:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248835;
	bh=YbGvbQQ1vfRjnxx6Bw9nhrZOKSwCmLmMv6EVFmoHme8=;
	h=Date:To:From:Subject:From;
	b=iwo94KM5OjTY5x08p0Jo8el9/RqJFDvSzqt48izr3jh1xlnFMUkL0V7D2KSxEbWql
	 rsNsY+IBrHm7IxqT9lZWz5inICtZJGIGERBH+OIECbXJRhCujBV2qRR341cO0Wf8lm
	 FbwquSIfolaX6kgFu63Ip4rr0FN08YbRl7kOnomw=
Date: Sun, 01 Sep 2024 20:47:14 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-max-to-improve-ocfs2_dlm_seq_show.patch removed from -mm tree
Message-Id: <20240902034715.3C2D2C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use max() to improve ocfs2_dlm_seq_show()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-max-to-improve-ocfs2_dlm_seq_show.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: ocfs2: use max() to improve ocfs2_dlm_seq_show()
Date: Tue, 20 Aug 2024 04:16:07 +0200

Use the max() macro to simplify the ocfs2_dlm_seq_show() function and
improve its readability.

Link: https://lkml.kernel.org/r/20240820021605.97887-3-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-use-max-to-improve-ocfs2_dlm_seq_show
+++ a/fs/ocfs2/dlmglue.c
@@ -3151,11 +3151,8 @@ static int ocfs2_dlm_seq_show(struct seq
 #ifdef CONFIG_OCFS2_FS_STATS
 	if (!lockres->l_lock_wait && dlm_debug->d_filter_secs) {
 		now = ktime_to_us(ktime_get_real());
-		if (lockres->l_lock_prmode.ls_last >
-		    lockres->l_lock_exmode.ls_last)
-			last = lockres->l_lock_prmode.ls_last;
-		else
-			last = lockres->l_lock_exmode.ls_last;
+		last = max(lockres->l_lock_prmode.ls_last,
+			   lockres->l_lock_exmode.ls_last);
 		/*
 		 * Use d_filter_secs field to filter lock resources dump,
 		 * the default d_filter_secs(0) value filters nothing,
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write.patch

