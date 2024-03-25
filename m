Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8815845037
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 20:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711397207; cv=none; b=cU2ohtCHWJ2MRMScoZUE/mqXs3WDZZtF9d15tlTSYnEMDCUicxGKY+G+iOZidQgmRfON4grHLaVQKsUoSBYKOFU4G2Tvo8qNccXjpGK0ewgFLoRneLUDzDpzl+vYQx6RrJ5D5djo+7iyPQfr3RPo24hJ+PZlRWJ62Z4CgI1Hjs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711397207; c=relaxed/simple;
	bh=iPDhoLbjgXIH1SJLQ0jOZ4yHpRpT5Pp2Ko0192Zdmow=;
	h=Date:To:From:Subject:Message-Id; b=gbzqIXO8Fe1PRYoFg7JMlcRWCN7Q0q04HOKevjl+tWf7pe+N+AvfUoLyK/YeOHAikZcnOFJkTkfIdwyNP6pasZ0W4I1D/hnUAmFTdBDrYZEMz/jZEX57NA4q26kWW0dgnGsiOl3/trZIjyFuIpFb9f7bXXXO71EndVSbeMOPFjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aaN4URQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aaN4URQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AC4C433F1;
	Mon, 25 Mar 2024 20:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711397207;
	bh=iPDhoLbjgXIH1SJLQ0jOZ4yHpRpT5Pp2Ko0192Zdmow=;
	h=Date:To:From:Subject:From;
	b=aaN4URQdP6GajgMUa8ebEWP8L7Yto09OVadA6C23jkEtpWQKg9JXXcGMWLuOuoiSe
	 qWOsiArbj2/hS2NRQ5OXkvWJ8S01GilWtcucXJXEM1dDKaMwrIre0y//mFcVdDV15l
	 2/TB38paS/gpbNsdwEoF8XjVodwlg/FPi38JFf+s=
Date: Mon, 25 Mar 2024 13:06:46 -0700
To: mm-commits@vger.kernel.org,dennis@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch added to mm-unstable branch
Message-Id: <20240325200647.13AC4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: backing-dev: use group allocation/free of per-cpu counters API
has been added to the -mm mm-unstable branch.  Its filename is
     mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch

This patch will later appear in the mm-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: backing-dev: use group allocation/free of per-cpu counters API
Date: Mon, 25 Mar 2024 11:56:35 +0800

Use group allocation/free of per-cpu counters api to accelerate
wb_init/exit() and simplify code.

Link: https://lkml.kernel.org/r/20240325035635.49342-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

--- a/mm/backing-dev.c~mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api
+++ a/mm/backing-dev.c
@@ -388,7 +388,7 @@ static void wb_update_bandwidth_workfn(s
 static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
 		   gfp_t gfp)
 {
-	int i, err;
+	int err;
 
 	memset(wb, 0, sizeof(*wb));
 
@@ -416,18 +416,10 @@ static int wb_init(struct bdi_writeback
 	if (err)
 		return err;
 
-	for (i = 0; i < NR_WB_STAT_ITEMS; i++) {
-		err = percpu_counter_init(&wb->stat[i], 0, gfp);
-		if (err)
-			goto out_destroy_stat;
-	}
-
-	return 0;
+	err = percpu_counter_init_many(wb->stat, 0, gfp, NR_WB_STAT_ITEMS);
+	if (err)
+		fprop_local_destroy_percpu(&wb->completions);
 
-out_destroy_stat:
-	while (i--)
-		percpu_counter_destroy(&wb->stat[i]);
-	fprop_local_destroy_percpu(&wb->completions);
 	return err;
 }
 
@@ -460,13 +452,8 @@ static void wb_shutdown(struct bdi_write
 
 static void wb_exit(struct bdi_writeback *wb)
 {
-	int i;
-
 	WARN_ON(delayed_work_pending(&wb->dwork));
-
-	for (i = 0; i < NR_WB_STAT_ITEMS; i++)
-		percpu_counter_destroy(&wb->stat[i]);
-
+	percpu_counter_destroy_many(wb->stat, NR_WB_STAT_ITEMS);
 	fprop_local_destroy_percpu(&wb->completions);
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch

