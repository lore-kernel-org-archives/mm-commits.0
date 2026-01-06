Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE10E236435
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 01:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767663443; cv=none; b=kzJqWikM6ENtDlcEpvK8Rp82nomtQeWyJHi2vC+rO5wVrQPZwW5lufpm2HdTM9VAKHc8X9v/8HE00OH/UKgS1Tqy6UWq8ne6yM2jI58bmdxGljQoW2HymHaonnjQsKXmfZjr9bpco8K8vFLhLVq1aXeX/MlZSOIXHoGx8baCQq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767663443; c=relaxed/simple;
	bh=qlv7VP2rEJm/vwlWPyxTRdXDLseuv+sUKLCRlQ7yP6E=;
	h=Date:To:From:Subject:Message-Id; b=cZQ3wpEaltOfPltrAZPswBoNt3lS9LHNpoqE+Taj2OAi3bTrz6QitBM82SpuBUlLcbin0ggM1eZ569mGFkGFgUWPpvyAd8k2hHWSzrwLUGLAzwC5Aq1Odhwv06Wd+1X+s9A/2CxyHYguNAnEdWcwsj7niaccK8y/qC+glGXVyCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PgfLVHLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PgfLVHLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4E0C19421;
	Tue,  6 Jan 2026 01:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767663442;
	bh=qlv7VP2rEJm/vwlWPyxTRdXDLseuv+sUKLCRlQ7yP6E=;
	h=Date:To:From:Subject:From;
	b=PgfLVHLQxswgYMhr3sDa+5dkhWqQMPjE4h0y3yqhX+JkLubmq8cxBmQqV4kmsDbJf
	 F/AvITzirf9y5AU31+GZiObFB6QzfCxKeDJd8q7zg+zge3ZFgMfBlyGF9QQ+V+TP3l
	 b5As+vsJ7qIypm5mL09OT6p40PJliQgGIQv0zvZw=
Date: Mon, 05 Jan 2026 17:37:21 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,swilczek.lx@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch added to mm-nonmm-unstable branch
Message-Id: <20260106013722.6F4E0C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch

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
From: Szymon Wilczek <swilczek.lx@gmail.com>
Subject: ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
Date: Sat, 27 Dec 2025 18:42:51 +0100

Move ocfs2_extend_no_holes() to execute before ocfs2_lock_global_qf() to
fix a circular locking dependency reported by syzbot.

The issue occurs because ocfs2_extend_no_holes() internally calls
ocfs2_extend_allocation() which starts a transaction (acquiring
sb_start_intwrite).  When called while holding the global quota file lock,
this conflicts with mount-time operations that acquire sb_internal first,
creating the following circular dependency:

  sb_internal -> ocfs2_sysfile_lock_key -> ocfs2_quota_ip_alloc_sem_key

By moving the quota file extension before acquiring the global quota file
lock, we ensure that any internal transactions complete before quota locks
are held, breaking the circular dependency.

Link: https://lkml.kernel.org/r/20251227174251.121668-1-swilczek.lx@gmail.com
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Tested-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot
+++ a/fs/ocfs2/quota_global.c
@@ -822,6 +822,19 @@ static int ocfs2_acquire_dquot(struct dq
 				  type);
 	mutex_lock(&dquot->dq_lock);
 	/*
+	 * Extend global quota file before acquiring global qf lock to avoid
+	 * lock inversion with sb_internal (via ocfs2_start_trans).
+	 */
+	if (need_alloc) {
+		WARN_ON(journal_current_handle());
+		status = ocfs2_extend_no_holes(gqinode, NULL,
+			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
+			i_size_read(gqinode));
+		if (status < 0)
+			goto out;
+	}
+
+	/*
 	 * We need an exclusive lock, because we're going to update use count
 	 * and instantiate possibly new dquot structure
 	 */
@@ -843,19 +856,8 @@ static int ocfs2_acquire_dquot(struct dq
 	OCFS2_DQUOT(dquot)->dq_use_count++;
 	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
 	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
-	if (!dquot->dq_off) {	/* No real quota entry? */
+	if (!dquot->dq_off)	/* No real quota entry? */
 		ex = 1;
-		/*
-		 * Add blocks to quota file before we start a transaction since
-		 * locking allocators ranks above a transaction start
-		 */
-		WARN_ON(journal_current_handle());
-		status = ocfs2_extend_no_holes(gqinode, NULL,
-			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
-			i_size_read(gqinode));
-		if (status < 0)
-			goto out_dq;
-	}
 
 	handle = ocfs2_start_trans(osb,
 				   ocfs2_calc_global_qinit_credits(sb, type));
_

Patches currently in -mm which might be from swilczek.lx@gmail.com are

mailmap-update-email-address-for-szymon-wilczek.patch
ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch

