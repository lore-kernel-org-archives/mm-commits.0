Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EF6C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08CE42075D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 21:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594417015;
	bh=ojsXxwdClUFQWGGQExet4zQ23LnBzQRhyr82X1sIKt4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=k5VaHkOSkUYDiB77ff9muWUnG9T56lZZwOAVUQHn5m7wH5HfLOqbCUyJbJzhyKsn9
	 aFeni2c+id+go48iGVxZJHsRqEMlcyIjqHpLk02sQ1r04jCankZlmqJUw/g4Wn0jz2
	 vKfkCJsE8n9Locmu+IdTD/KOqPZvElGfaM/bFAyA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgGJVgy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 17:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgGJVgy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 17:36:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A39E206C3;
        Fri, 10 Jul 2020 21:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594417013;
        bh=ojsXxwdClUFQWGGQExet4zQ23LnBzQRhyr82X1sIKt4=;
        h=Date:From:To:Subject:From;
        b=sSNNu8R3IeZ7RRKXoThz1L160OTSKPahgkru/SIbINxg40IjDiXgG2fCpEhLM9Yjl
         eXScksGDLJEDvYjXSBZ3XXpr8scEPeyqXQDjfbgMmGgtsCJIzYHmahN6WTY4bUYsHO
         erFE/QqtR/Dh6O/WDkJUEzf0gkyhxlKj4ggBtSSc=
Date:   Fri, 10 Jul 2020 14:36:53 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, laoar.shao@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com
Subject:  +
 mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch added to
 -mm tree
Message-ID: <20200710213653.psMezsOK8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3
has been added to the -mm tree.  Its filename is
     mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1666,7 +1666,6 @@ static bool mem_cgroup_out_of_memory(str
 		.memcg = memcg,
 		.gfp_mask = gfp_mask,
 		.order = order,
-		.chosen_points = LONG_MIN,
 	};
 	bool ret;
 
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
@@ -3915,7 +3915,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = order,
-		.chosen_points = LONG_MIN,
 	};
 	struct page *page;
 
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch
mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch

