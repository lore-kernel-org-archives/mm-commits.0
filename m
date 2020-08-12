Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A9DC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE6F20829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597193918;
	bh=uqSYf6WM6E3S3usNq+HYUW+skTHocfCgW7nC3VVJPQc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BshWeF9r+e+5D3Ep2+WRyktmqDRUelyFekPQGsX0JT0xeU0S5ZR+YpkxBxNFzZ/kV
	 mTvd0hY8dWWRmhnqLQHrZHu7yXSdGMc3GMnyOmytYInGPiLSdqd272T3eHCVVg9NMX
	 C+yCZOrH1IVrEhMOCHra6iqAIowbVHHO9+9Dw0Fo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHLA6i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLA6i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 20:58:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AAAA207DA;
        Wed, 12 Aug 2020 00:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597193917;
        bh=uqSYf6WM6E3S3usNq+HYUW+skTHocfCgW7nC3VVJPQc=;
        h=Date:From:To:Subject:From;
        b=vOpS7uhLVlWeekNHapa0r4HSFwkiGTj5s3EmpV9/po9Ty5UPPO3Cs0FpXusiYibqr
         +DCDFg09lXJeFkdoWV8SXEedvWttaF4N7iL/d8der1Y/H3NGjYaroXUC3sihei0w0X
         lSUHzh+xffscko3QHiV1KrLRaN53JMmzEfBl1k0E=
Date:   Tue, 11 Aug 2020 17:58:36 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, laoar.shao@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com
Subject:  [folded-merged]
 mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch removed
 from -mm tree
Message-ID: <20200812005836.Vdu2wBoH1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3
has been removed from the -mm tree.  Its filename was
     mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch

This patch was dropped because it was folded into mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3

- fix the type of variable 'point' in oom_evaluate_task()
- initialize oom_control->chosen_points in select_bad_process() per Michal
- update the comment in proc_oom_score() per Michal

Link: http://lkml.kernel.org/r/1594396651-9931-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |    1 -
 fs/proc/base.c      |   10 +++++++---
 mm/memcontrol.c     |    1 -
 mm/oom_kill.c       |    5 +++--
 mm/page_alloc.c     |    1 -
 5 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/tty/sysrq.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3
+++ a/drivers/tty/sysrq.c
@@ -382,7 +382,6 @@ static void moom_callback(struct work_st
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = -1,
-		.chosen_points = LONG_MIN,
 	};
 
 	mutex_lock(&oom_lock);
--- a/fs/proc/base.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3
+++ a/fs/proc/base.c
@@ -554,10 +554,14 @@ static int proc_oom_score(struct seq_fil
 	long badness;
 
 	badness = oom_badness(task, totalpages);
-	if (badness != LONG_MIN) {
-		/* Let's keep the range of points as [0, 2000]. */
+	/*
+	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
+	 * badness value into [0, 2000] range which we have been
+	 * exporting for a long time so userspace might depend on it.
+	 */
+	if (badness != LONG_MIN)
 		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
-	}
+
 	seq_printf(m, "%lu\n", points);
 
 	return 0;
--- a/mm/memcontrol.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3
+++ a/mm/memcontrol.c
@@ -1670,7 +1670,6 @@ static bool mem_cgroup_out_of_memory(str
 		.memcg = memcg,
 		.gfp_mask = gfp_mask,
 		.order = order,
-		.chosen_points = LONG_MIN,
 	};
 	bool ret = true;
 
--- a/mm/oom_kill.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3
+++ a/mm/oom_kill.c
@@ -306,7 +306,7 @@ static enum oom_constraint constrained_a
 static int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
-	unsigned long points;
+	long points;
 
 	if (oom_unkillable_task(task))
 		goto next;
@@ -361,6 +361,8 @@ abort:
  */
 static void select_bad_process(struct oom_control *oc)
 {
+	oc->chosen_points = LONG_MIN;
+
 	if (is_memcg_oom(oc))
 		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
 	else {
@@ -1124,7 +1126,6 @@ void pagefault_out_of_memory(void)
 		.memcg = NULL,
 		.gfp_mask = 0,
 		.order = 0,
-		.chosen_points = LONG_MIN,
 	};
 
 	if (mem_cgroup_oom_synchronize(true))
--- a/mm/page_alloc.c~mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3
+++ a/mm/page_alloc.c
@@ -3929,7 +3929,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = order,
-		.chosen_points = LONG_MIN,
 	};
 	struct page *page;
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch
mm-oom-show-process-exiting-information-in-__oom_kill_process.patch

