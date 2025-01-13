Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7DF170A0B
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742265; cv=none; b=CmgtFz4gHu/PS4ceFIiRkX2k0a5T3l82DRp7IjLVQnf6G6kBrnv6zzWQwfrdzsT3f4fHewntW5aPog/TQzF9m8evEvUKmeZpHBFE8HL2QMZaTc3a1CsMRMt8Lr0RMzgfggU48jD7QncgJFkTAuFHV/+fZfAQLX2VOgaYNu0Y7J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742265; c=relaxed/simple;
	bh=l2Ixf8URuInBEDx4Gz+Kjm7NDerqT8KQZ839LmfBrl4=;
	h=Date:To:From:Subject:Message-Id; b=ewD0kwr/D34MGbojZwo1yPoIKalV4Z3UFZjtkkOoXwMXsNRiJCCYWdBj9G7JGVb07HzFCqFwjlSc3enV2Mjo7BmZ7IhZHCzhY1ccwy2H44+Y8DUWZgusjLtHXdVN999aMNQgLjgiSd05q68dEf1EpW5U/Amv6LKD7tAIdLodueg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=abft0DQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="abft0DQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADFEC4CED6;
	Mon, 13 Jan 2025 04:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742265;
	bh=l2Ixf8URuInBEDx4Gz+Kjm7NDerqT8KQZ839LmfBrl4=;
	h=Date:To:From:Subject:From;
	b=abft0DQH9zcx/Qfl/aSQlrsidKx7+zJ0AGb+//6Ako70Z1i2WRn3d1yZIEIpj+S2b
	 NZGI+KACzTYh1jzMSK8yDnHZIWcnXIIhxP9WAFPDKayvtpCmg7AboA/6UY6+uipFrP
	 Ky87IrqV65TAB30/Pn03ENP/TDmrLvJzK5uCTwGo=
Date: Sun, 12 Jan 2025 20:24:24 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-mark-dquot-as-inactive-if-failed-to-start-trans-while-releasing-dquot.patch removed from -mm tree
Message-Id: <20250113042425.3ADFEC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: mark dquot as inactive if failed to start trans while releasing dquot
has been removed from the -mm tree.  Its filename was
     ocfs2-mark-dquot-as-inactive-if-failed-to-start-trans-while-releasing-dquot.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: mark dquot as inactive if failed to start trans while releasing dquot
Date: Mon, 6 Jan 2025 22:06:53 +0800

While running fstests generic/329, the kernel workqueue
quota_release_workfn is dead looping in calling ocfs2_release_dquot().
The ocfs2 state is already readonly but ocfs2_release_dquot wants to
start a transaction but fails and returns.

=====================================================================
[ 2918.123602 ][  T275 ] On-disk corruption discovered. Please run
fsck.ocfs2 once the filesystem is unmounted.
[ 2918.124034 ][  T275 ] (kworker/u135:1,275,11):ocfs2_release_dquot:765
ERROR: status = -30
[ 2918.124452 ][  T275 ] (kworker/u135:1,275,11):ocfs2_release_dquot:795
ERROR: status = -30
[ 2918.124883 ][  T275 ] (kworker/u135:1,275,11):ocfs2_start_trans:357
ERROR: status = -30
[ 2918.125276 ][  T275 ] OCFS2: abort (device dm-0): ocfs2_start_trans:
Detected aborted journal
[ 2918.125710 ][  T275 ] On-disk corruption discovered. Please run
fsck.ocfs2 once the filesystem is unmounted.
=====================================================================

ocfs2_release_dquot() is much like dquot_release(), which is called by
ext4 to handle similar situation.  So here fix it by marking the dquot as
inactive like what dquot_release() does.

Link: https://lkml.kernel.org/r/20250106140653.92292-1-glass.su@suse.com
Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/ocfs2/quota_global.c~ocfs2-mark-dquot-as-inactive-if-failed-to-start-trans-while-releasing-dquot
+++ a/fs/ocfs2/quota_global.c
@@ -761,6 +761,11 @@ static int ocfs2_release_dquot(struct dq
 	handle = ocfs2_start_trans(osb,
 		ocfs2_calc_qdel_credits(dquot->dq_sb, dquot->dq_id.type));
 	if (IS_ERR(handle)) {
+		/*
+		 * Mark dquot as inactive to avoid endless cycle in
+		 * quota_release_workfn().
+		 */
+		clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 		status = PTR_ERR(handle);
 		mlog_errno(status);
 		goto out_ilock;
_

Patches currently in -mm which might be from glass.su@suse.com are


