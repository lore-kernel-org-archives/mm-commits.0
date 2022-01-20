Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8692DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377943AbiATVbq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348034AbiATVbp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:31:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56778C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:31:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1267FB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E84AC340E0;
        Thu, 20 Jan 2022 21:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714302;
        bh=edps+MnUzrJZH1S0LwSxtb9ME9cUYEcBHNy+khxCXOU=;
        h=Date:From:To:Subject:From;
        b=ee7RoXfwGqn+Y+WAVqIbiwIM1YYq5aj7WAQEpeDYz4QGjoXGE2+QbxFGh2+Mi7NsY
         PebSJ9yRP13SG8asLcGroWFeRj6gJKzYiBA5znz0MGYj0QoTuB6wKxepBEqKTIae47
         QbhbwF6DR0JhLYXnlNQJM8zkP0K+BJ3naEf8e6H8=
Date:   Thu, 20 Jan 2022 13:31:41 -0800
From:   akpm@linux-foundation.org
To:     bsingharora@gmail.com, jiang.xuexin@zte.com.cn,
        mm-commits@vger.kernel.org, wang.yong12@zte.com.cn,
        yang.yang29@zte.com.cn, zhang.wenya1@zte.com.cn
Subject:  [merged] delayacct-track-delays-from-memory-compact.patch
 removed from -mm tree
Message-ID: <20220120213141.hHcuU0VxV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: delayacct: track delays from memory compact
has been removed from the -mm tree.  Its filename was
     delayacct-track-delays-from-memory-compact.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: wangyong <wang.yong12@zte.com.cn>
Subject: delayacct: track delays from memory compact

Delay accounting does not track the delay of memory compact.  When there
is not enough free memory, tasks can spend a amount of their time waiting
for compact.

To get the impact of tasks in direct memory compact, measure the delay
when allocating memory through memory compact.

Also update tools/accounting/getdelays.c:
/ # ./getdelays_next  -di -p 304
print delayacct stats ON
printing IO accounting
PID     304

CPU             count     real total  virtual total    delay total  delay average
                  277      780000000      849039485       18877296          0.068ms
IO              count    delay total  delay average
                    0              0              0ms
SWAP            count    delay total  delay average
                    0              0              0ms
RECLAIM         count    delay total  delay average
                    5    11088812685           2217ms
THRASHING       count    delay total  delay average
                    0              0              0ms
COMPACT         count    delay total  delay average
                    3          72758              0ms
watch: read=0, write=0, cancelled_write=0

Link: https://lkml.kernel.org/r/1638619795-71451-1-git-send-email-wang.yong12@zte.com.cn
Signed-off-by: wangyong <wang.yong12@zte.com.cn>
Reviewed-by: Jiang Xuexin <jiang.xuexin@zte.com.cn>
Reviewed-by: Zhang Wenya <zhang.wenya1@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delayacct.h      |   28 ++++++++++++++++++++++++++++
 include/uapi/linux/taskstats.h |    6 +++++-
 kernel/delayacct.c             |   15 +++++++++++++++
 mm/page_alloc.c                |    3 +++
 tools/accounting/getdelays.c   |    8 +++++++-
 5 files changed, 58 insertions(+), 2 deletions(-)

--- a/include/linux/delayacct.h~delayacct-track-delays-from-memory-compact
+++ a/include/linux/delayacct.h
@@ -42,8 +42,12 @@ struct task_delay_info {
 	u64 thrashing_start;
 	u64 thrashing_delay;	/* wait for thrashing page */
 
+	u64 compact_start;
+	u64 compact_delay;	/* wait for memory compact */
+
 	u32 freepages_count;	/* total count of memory reclaim */
 	u32 thrashing_count;	/* total count of thrash waits */
+	u32 compact_count;	/* total count of memory compact */
 };
 #endif
 
@@ -72,6 +76,8 @@ extern void __delayacct_thrashing_start(
 extern void __delayacct_thrashing_end(void);
 extern void __delayacct_swapin_start(void);
 extern void __delayacct_swapin_end(void);
+extern void __delayacct_compact_start(void);
+extern void __delayacct_compact_end(void);
 
 static inline void delayacct_tsk_init(struct task_struct *tsk)
 {
@@ -170,6 +176,24 @@ static inline void delayacct_swapin_end(
 		__delayacct_swapin_end();
 }
 
+static inline void delayacct_compact_start(void)
+{
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
+	if (current->delays)
+		__delayacct_compact_start();
+}
+
+static inline void delayacct_compact_end(void)
+{
+	if (!static_branch_unlikely(&delayacct_key))
+		return;
+
+	if (current->delays)
+		__delayacct_compact_end();
+}
+
 #else
 static inline void delayacct_init(void)
 {}
@@ -200,6 +224,10 @@ static inline void delayacct_swapin_star
 {}
 static inline void delayacct_swapin_end(void)
 {}
+static inline void delayacct_compact_start(void)
+{}
+static inline void delayacct_compact_end(void)
+{}
 
 #endif /* CONFIG_TASK_DELAY_ACCT */
 
--- a/include/uapi/linux/taskstats.h~delayacct-track-delays-from-memory-compact
+++ a/include/uapi/linux/taskstats.h
@@ -34,7 +34,7 @@
  */
 
 
-#define TASKSTATS_VERSION	10
+#define TASKSTATS_VERSION	11
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -172,6 +172,10 @@ struct taskstats {
 
 	/* v10: 64-bit btime to avoid overflow */
 	__u64	ac_btime64;		/* 64-bit begin time */
+
+	/* Delay waiting for memory compact */
+	__u64	compact_count;
+	__u64	compact_delay_total;
 };
 
 
--- a/kernel/delayacct.c~delayacct-track-delays-from-memory-compact
+++ a/kernel/delayacct.c
@@ -155,10 +155,13 @@ int delayacct_add_tsk(struct taskstats *
 	d->freepages_delay_total = (tmp < d->freepages_delay_total) ? 0 : tmp;
 	tmp = d->thrashing_delay_total + tsk->delays->thrashing_delay;
 	d->thrashing_delay_total = (tmp < d->thrashing_delay_total) ? 0 : tmp;
+	tmp = d->compact_delay_total + tsk->delays->compact_delay;
+	d->compact_delay_total = (tmp < d->compact_delay_total) ? 0 : tmp;
 	d->blkio_count += tsk->delays->blkio_count;
 	d->swapin_count += tsk->delays->swapin_count;
 	d->freepages_count += tsk->delays->freepages_count;
 	d->thrashing_count += tsk->delays->thrashing_count;
+	d->compact_count += tsk->delays->compact_count;
 	raw_spin_unlock_irqrestore(&tsk->delays->lock, flags);
 
 	return 0;
@@ -214,3 +217,15 @@ void __delayacct_swapin_end(void)
 		      &current->delays->swapin_count);
 }
 
+void __delayacct_compact_start(void)
+{
+	current->delays->compact_start = local_clock();
+}
+
+void __delayacct_compact_end(void)
+{
+	delayacct_end(&current->delays->lock,
+		      &current->delays->compact_start,
+		      &current->delays->compact_delay,
+		      &current->delays->compact_count);
+}
--- a/mm/page_alloc.c~delayacct-track-delays-from-memory-compact
+++ a/mm/page_alloc.c
@@ -74,6 +74,7 @@
 #include <linux/padata.h>
 #include <linux/khugepaged.h>
 #include <linux/buffer_head.h>
+#include <linux/delayacct.h>
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -4365,6 +4366,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		return NULL;
 
 	psi_memstall_enter(&pflags);
+	delayacct_compact_start();
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
@@ -4372,6 +4374,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	psi_memstall_leave(&pflags);
+	delayacct_compact_end();
 
 	if (*compact_result == COMPACT_SKIPPED)
 		return NULL;
--- a/tools/accounting/getdelays.c~delayacct-track-delays-from-memory-compact
+++ a/tools/accounting/getdelays.c
@@ -205,6 +205,8 @@ static void print_delayacct(struct tasks
 	       "RECLAIM  %12s%15s%15s\n"
 	       "      %15llu%15llu%15llums\n"
 	       "THRASHING%12s%15s%15s\n"
+	       "      %15llu%15llu%15llums\n"
+	       "COMPACT  %12s%15s%15s\n"
 	       "      %15llu%15llu%15llums\n",
 	       "count", "real total", "virtual total",
 	       "delay total", "delay average",
@@ -228,7 +230,11 @@ static void print_delayacct(struct tasks
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->thrashing_count,
 	       (unsigned long long)t->thrashing_delay_total,
-	       average_ms(t->thrashing_delay_total, t->thrashing_count));
+	       average_ms(t->thrashing_delay_total, t->thrashing_count),
+	       "count", "delay total", "delay average",
+	       (unsigned long long)t->compact_count,
+	       (unsigned long long)t->compact_delay_total,
+	       average_ms(t->compact_delay_total, t->compact_count));
 }
 
 static void task_context_switch_counts(struct taskstats *t)
_

Patches currently in -mm which might be from wang.yong12@zte.com.cn are


