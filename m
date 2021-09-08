Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0657C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1D361102
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243156AbhIHDAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347433AbhIHDAb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8716F6113C;
        Wed,  8 Sep 2021 02:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069963;
        bh=CJdDU0fTPrADMkER6IWt42fc7gNSTJbhYE5OsB5kH14=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=r81JDX2pKll1ApTeqqGXFCYGJMuE/y4Emqz7bvM0OPdrqDlzvX0kouIzI6Lry9wia
         9OIPL98ZdBPqRG9uSNL0XqesqvngyNUW5CIRxdmbpbl5t/f6hjecDSR+ekpNCaELgX
         4R92Fg713hCBL388O/hD9xVSFwekqgCIQCWEuK+M=
Date:   Tue, 07 Sep 2021 19:59:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 115/147] cpumask: replace cpumask_next_* with
 cpumask_first_* where appropriate
Message-ID: <20210908025923.mBbgVxKU3%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: cpumask: replace cpumask_next_* with cpumask_first_* where appropriate

cpumask_first() is a more effective analogue of 'next' version if n == -1
(which means start == 0).  This patch replaces 'next' with 'first' where
things look trivial.

There's no cpumask_first_zero() function, so create it.

Link: https://lkml.kernel.org/r/20210814211713.180533-10-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/cputhreads.h |    2 +-
 block/blk-mq.c                        |    2 +-
 drivers/net/virtio_net.c              |    2 +-
 drivers/soc/fsl/qbman/bman_portal.c   |    2 +-
 drivers/soc/fsl/qbman/qman_portal.c   |    2 +-
 include/linux/cpumask.h               |   16 ++++++++++++++++
 kernel/time/clocksource.c             |    4 ++--
 7 files changed, 23 insertions(+), 7 deletions(-)

--- a/arch/powerpc/include/asm/cputhreads.h~cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate
+++ a/arch/powerpc/include/asm/cputhreads.h
@@ -52,7 +52,7 @@ static inline cpumask_t cpu_thread_mask_
 	for (i = 0; i < NR_CPUS; i += threads_per_core) {
 		cpumask_shift_left(&tmp, &threads_core_mask, i);
 		if (cpumask_intersects(threads, &tmp)) {
-			cpu = cpumask_next_and(-1, &tmp, cpu_online_mask);
+			cpu = cpumask_first_and(&tmp, cpu_online_mask);
 			if (cpu < nr_cpu_ids)
 				cpumask_set_cpu(cpu, &res);
 		}
--- a/block/blk-mq.c~cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate
+++ a/block/blk-mq.c
@@ -2524,7 +2524,7 @@ static bool blk_mq_hctx_has_requests(str
 static inline bool blk_mq_last_cpu_in_hctx(unsigned int cpu,
 		struct blk_mq_hw_ctx *hctx)
 {
-	if (cpumask_next_and(-1, hctx->cpumask, cpu_online_mask) != cpu)
+	if (cpumask_first_and(hctx->cpumask, cpu_online_mask) != cpu)
 		return false;
 	if (cpumask_next_and(cpu, hctx->cpumask, cpu_online_mask) < nr_cpu_ids)
 		return false;
--- a/drivers/net/virtio_net.c~cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate
+++ a/drivers/net/virtio_net.c
@@ -2091,7 +2091,7 @@ static void virtnet_set_affinity(struct
 	stragglers = num_cpu >= vi->curr_queue_pairs ?
 			num_cpu % vi->curr_queue_pairs :
 			0;
-	cpu = cpumask_next(-1, cpu_online_mask);
+	cpu = cpumask_first(cpu_online_mask);
 
 	for (i = 0; i < vi->curr_queue_pairs; i++) {
 		group_size = stride + (i < stragglers ? 1 : 0);
--- a/drivers/soc/fsl/qbman/bman_portal.c~cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate
+++ a/drivers/soc/fsl/qbman/bman_portal.c
@@ -155,7 +155,7 @@ static int bman_portal_probe(struct plat
 	}
 
 	spin_lock(&bman_lock);
-	cpu = cpumask_next_zero(-1, &portal_cpus);
+	cpu = cpumask_first_zero(&portal_cpus);
 	if (cpu >= nr_cpu_ids) {
 		__bman_portals_probed = 1;
 		/* unassigned portal, skip init */
--- a/drivers/soc/fsl/qbman/qman_portal.c~cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate
+++ a/drivers/soc/fsl/qbman/qman_portal.c
@@ -248,7 +248,7 @@ static int qman_portal_probe(struct plat
 	pcfg->pools = qm_get_pools_sdqcr();
 
 	spin_lock(&qman_lock);
-	cpu = cpumask_next_zero(-1, &portal_cpus);
+	cpu = cpumask_first_zero(&portal_cpus);
 	if (cpu >= nr_cpu_ids) {
 		__qman_portals_probed = 1;
 		/* unassigned portal, skip init */
--- a/include/linux/cpumask.h~cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate
+++ a/include/linux/cpumask.h
@@ -123,6 +123,11 @@ static inline unsigned int cpumask_first
 	return 0;
 }
 
+static inline unsigned int cpumask_first_zero(const struct cpumask *srcp)
+{
+	return 0;
+}
+
 static inline unsigned int cpumask_first_and(const struct cpumask *srcp1,
 					     const struct cpumask *srcp2)
 {
@@ -202,6 +207,17 @@ static inline unsigned int cpumask_first
 }
 
 /**
+ * cpumask_first_zero - get the first unset cpu in a cpumask
+ * @srcp: the cpumask pointer
+ *
+ * Returns >= nr_cpu_ids if all cpus are set.
+ */
+static inline unsigned int cpumask_first_zero(const struct cpumask *srcp)
+{
+	return find_first_zero_bit(cpumask_bits(srcp), nr_cpumask_bits);
+}
+
+/**
  * cpumask_first_and - return the first cpu from *srcp1 & *srcp2
  * @src1p: the first input
  * @src2p: the second input
--- a/kernel/time/clocksource.c~cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate
+++ a/kernel/time/clocksource.c
@@ -257,7 +257,7 @@ static void clocksource_verify_choose_cp
 		return;
 
 	/* Make sure to select at least one CPU other than the current CPU. */
-	cpu = cpumask_next(-1, cpu_online_mask);
+	cpu = cpumask_first(cpu_online_mask);
 	if (cpu == smp_processor_id())
 		cpu = cpumask_next(cpu, cpu_online_mask);
 	if (WARN_ON_ONCE(cpu >= nr_cpu_ids))
@@ -279,7 +279,7 @@ static void clocksource_verify_choose_cp
 		cpu = prandom_u32() % nr_cpu_ids;
 		cpu = cpumask_next(cpu - 1, cpu_online_mask);
 		if (cpu >= nr_cpu_ids)
-			cpu = cpumask_next(-1, cpu_online_mask);
+			cpu = cpumask_first(cpu_online_mask);
 		if (!WARN_ON_ONCE(cpu >= nr_cpu_ids))
 			cpumask_set_cpu(cpu, &cpus_chosen);
 	}
_
