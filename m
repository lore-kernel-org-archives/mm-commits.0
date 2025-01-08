Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FF620B20
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736309462; cv=none; b=mcJdsdrbrsCZKU9BvmaAlhcEKD8kCbaFr4FGqJhFRvzdfu6XsW9PhkYhesIy61zxWsrc9kMNT9gwtgifulB4KrEiGpOEuad7cOvievolG2ygHIrp4TnQZk2+hV5oT5RyvSseWUIgNHpCe9ynRaLKbqeiYhln8eIyBTmB/KfPaQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736309462; c=relaxed/simple;
	bh=rqkk9EZz7huksU+khQElxPOWBQpd4TgiCwrgDjl9eek=;
	h=Date:To:From:Subject:Message-Id; b=eqF9cH/z8OJ6eDvENPjP06eJ8B55RNmoIFI4CRg6XAvN+KCnz48MjfBWim1cr+M4fQZ1fkjd9UppvfTvZYCbljzov+kD+hSD95RrtvE6nGb21Z6A2T54eikS01V+bSuYQdyZO76kJRzFficLrNtQQs0J7KfmHC2qbMat4wjq/RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mMmeOIoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mMmeOIoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DD9C4CED0;
	Wed,  8 Jan 2025 04:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736309461;
	bh=rqkk9EZz7huksU+khQElxPOWBQpd4TgiCwrgDjl9eek=;
	h=Date:To:From:Subject:From;
	b=mMmeOIoGNtSeteWjzMDtDYQKGHfWBdxs34U69ic0VDSXuWQ+Sw4HyYwDXHSHqDh88
	 +S5CdCmCAfa7rSws0xgMxcjFljULYvItVEuCJ5s4N9X7pwmKTQayLz5/d6sTB6NH/d
	 zZgcn89VGyXoPMSe2ESyF0WgziBEy8uyB0QhoHao=
Date: Tue, 07 Jan 2025 20:11:01 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-mark-dquot-as-inactive-if-failed-to-start-trans-while-releasing-dquot.patch added to mm-nonmm-unstable branch
Message-Id: <20250108041101.B4DD9C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: mark dquot as inactive if failed to start trans while releasing dquot
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-mark-dquot-as-inactive-if-failed-to-start-trans-while-releasing-dquot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-mark-dquot-as-inactive-if-failed-to-start-trans-while-releasing-dquot.patch

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

ocfs2-check-tl-count-of-truncate-log-inode-in-ocfs2_get_truncate_log_info.patch
ocfs2-mark-dquot-as-inactive-if-failed-to-start-trans-while-releasing-dquot.patch

