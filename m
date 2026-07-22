Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36246466B08;
	Wed, 22 Jul 2026 23:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763846; cv=none; b=hn0OMGX8q0DNDwi7eiZLUObmsct8IW+GFTFDNZSO4xr+XkAtk52orU2fkrCgDQkYogjoQFtOOxeBPekcrKvaetEo7k8U4z/m0sr6P0px+RXG6ZKXCjCVNLgpsDwHUA/ZxAnSd448lE2y3Qq80HRGBLlfa09HPoBS86tpHlnM+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763846; c=relaxed/simple;
	bh=A87aOddfW5lx0pTeRGADvAIsJIgk17MmBeQ4du4uA2U=;
	h=Date:To:From:Subject:Message-Id; b=ATNsVne5WRLKtFthrqpcC/9EsqUze7utUQGJo33VnQ2FlQu6qj3vTxX01sW3DkA9AtGJmgmTGaqAAM6ShMWzPvTXJlNnl2DQA8DRGdUctbW2krBVMaYgFqvCYvCwNZDIWQxRLp7Fhuu/7YdY6IiTD+7kmjYEh13D6hLQHDWfXCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wmoNBuKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wmoNBuKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ADB1F000E9;
	Wed, 22 Jul 2026 23:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784763845;
	bh=bmDYBm7ax2ZdcvvYahzjONSkYvqDg9Xb/8r8owjlMVM=;
	h=Date:To:From:Subject;
	b=wmoNBuKKWlKGeP1pXWuC3wZ8Jb7X28XtfE7OPruOcB5kFzfr5AXr8AF6OHNlHDw64
	 MM78zewH5qP32t5HmUhUicF060qKHP6yYIVnkcMqPjdF4attkqipBnsY5OTQ0SpeVE
	 AHNHzBRQ5I0K34I055rigL3cKf9oYmD2Hfxwvf/I=
Date: Wed, 22 Jul 2026 16:44:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure.patch added to mm-nonmm-unstable branch
Message-Id: <20260722234404.D7ADB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: cluster: fix o2hb_dependent_users leak on pin failure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure.patch

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
Subject: ocfs2: cluster: fix o2hb_dependent_users leak on pin failure
Date: Wed, 22 Jul 2026 20:49:33 +0800

In o2hb_region_inc_user(), o2hb_dependent_users is incremented
unconditionally before calling o2hb_region_pin().  If the pin fails, the
counter is never decremented and any partially-pinned regions are never
unpinned, since the caller does not call o2hb_region_dec_user() on error.

The leaked counter causes subsequent o2hb_region_inc_user() calls to skip
pinning entirely (the > 1 check), leaving heartbeat regions unprotected.

Fix by rolling back on failure: call o2hb_region_unpin(NULL) to release
any partially-pinned regions and decrement o2hb_dependent_users to restore
the pre-increment state.

Link: https://lore.kernel.org/20260722124933.430554-4-joseph.qi@linux.alibaba.com
Fixes: 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2499,8 +2499,13 @@ static int o2hb_region_inc_user(const ch
 		goto unlock;
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
-			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
+			  O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF) {
 		ret = o2hb_region_pin(NULL, false);
+		if (ret) {
+			o2hb_region_unpin(NULL);
+			o2hb_dependent_users--;
+		}
+	}
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-cluster-use-gfp_nofs-for-heartbeat-bio-allocation.patch
ocfs2-cluster-use-an-on-stack-bio-for-the-heartbeat-write.patch
ocfs2-cluster-dont-sleep-while-holding-o2hb_live_lock-in-o2hb_region_pin.patch
ocfs2-cluster-avoid-lock-order-inversion-in-o2hb_region_pin-from-drop_item.patch
ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure.patch

