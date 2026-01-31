Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B0026F2A7
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 23:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769903767; cv=none; b=TRkGAbh0e8yed/rH39ezwEHCZxx2c4VT2j5FUPv9Ba1TueuvIoEkE2Ie4GLp6hIOjFLkzer/rnKZth3J1lHEc6ATRwKA7zBsLuIcW4s7Ls+c2cDLgesUDH+cO3mHxnh6qh7vv5E3/JILFZm6rSDWYEl9bz5tTJzRF+57plrgCJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769903767; c=relaxed/simple;
	bh=6fkzEfRjwCs9d25ecadGA4OUd+WKD6hjiNsx8z+cPrg=;
	h=Date:To:From:Subject:Message-Id; b=U3M1Pq3nzviOgrHA2eFyFXdIXoV77W2gHlwPfJvOnG05AeiiyBdHCrb3LLxyRF1yb2G7OhyXdFYWrBMcIT+wSBMF9ZFyNwEdAqSpwQe6UBw9g9SAuEk3pBTDddk8VOAb+hCh0ZOYo6beeJ43KE+OrA8pRYTOKO1ZD8fJE3bgjIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J0RPBTa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J0RPBTa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63592C4CEF1;
	Sat, 31 Jan 2026 23:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769903767;
	bh=6fkzEfRjwCs9d25ecadGA4OUd+WKD6hjiNsx8z+cPrg=;
	h=Date:To:From:Subject:From;
	b=J0RPBTa8Gr1DLCLNMGbXjwdfy7kwITbO8XtXgxhU4JM4m4TRWc9N8aZzBdJSXynfa
	 8qLnAEfuo7yJyRL7QonjJpTHp8qHAt5JN7txYnad4dBdf28L1Q3wci6zy9oieK2a1m
	 xw0ceCNJU3EBRS1F3In3P3LZh1ZZawhmDS8YT0sk=
Date: Sat, 31 Jan 2026 15:56:06 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,swilczek.lx@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch removed from -mm tree
Message-Id: <20260131235607.63592C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch

This patch was dropped because an updated version will be issued

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


