Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A902CC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 03:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiKJD07 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiKJD0z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 22:26:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFE312D19
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 19:26:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEF5BB82083
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 03:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6963EC433C1;
        Thu, 10 Nov 2022 03:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668050811;
        bh=2tbm/3dLnKBpq0iLFJikml4A4JcW1dDuhtI1/n0Uem0=;
        h=Date:To:From:Subject:From;
        b=hrigQIQhzZIwvny8F7Tth7zmOVaKH6caOiWTY0K/qU/ngWXu8XOVr8/YD9fdtKF+Q
         7Xhurwm8RgJ2p0KW9sTDIQnM7jYkBcdadq+XwjzS9rIqUcnqLxiZZ5uXj67L+gBLlF
         7eS0/SV7RrZEc32Pl7aO4eVZ7iRN8xjMxOkXVzkU=
Date:   Wed, 09 Nov 2022 19:26:50 -0800
To:     mm-commits@vger.kernel.org, m.szyprowski@samsung.com,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-convert-mms-rss-stats-into-percpu_counter-fix.patch removed from -mm tree
Message-Id: <20221110032651.6963EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Date: Thu, 3 Nov 2022 06:05:13 +0000
has been removed from the -mm tree.  Its filename was
     mm-convert-mms-rss-stats-into-percpu_counter-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Date: Thu, 3 Nov 2022 06:05:13 +0000
Subject: mm: percpu_counter: use race free percpu_counter sum interface

percpu_counter_sum can race with cpu offlining.  Add a new interface which
does not race with it and use that for check_mm().

Link: https://lkml.kernel.org/r/20221103171407.ydubp43x7tzahriq@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   11 +++++++++++
 kernel/fork.c                  |    2 +-
 lib/percpu_counter.c           |   24 ++++++++++++++++++------
 3 files changed, 30 insertions(+), 7 deletions(-)

--- a/include/linux/percpu_counter.h~mm-convert-mms-rss-stats-into-percpu_counter-fix
+++ a/include/linux/percpu_counter.h
@@ -45,6 +45,7 @@ void percpu_counter_set(struct percpu_co
 void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount,
 			      s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
+s64 __percpu_counter_sum_all(struct percpu_counter *fbc);
 int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch);
 void percpu_counter_sync(struct percpu_counter *fbc);
 
@@ -85,6 +86,11 @@ static inline s64 percpu_counter_sum(str
 	return __percpu_counter_sum(fbc);
 }
 
+static inline s64 percpu_counter_sum_all(struct percpu_counter *fbc)
+{
+	return __percpu_counter_sum_all(fbc);
+}
+
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
 	return fbc->count;
@@ -192,6 +198,11 @@ static inline s64 percpu_counter_sum(str
 {
 	return percpu_counter_read(fbc);
 }
+
+static inline s64 percpu_counter_sum_all(struct percpu_counter *fbc)
+{
+	return percpu_counter_read(fbc);
+}
 
 static inline bool percpu_counter_initialized(struct percpu_counter *fbc)
 {
--- a/kernel/fork.c~mm-convert-mms-rss-stats-into-percpu_counter-fix
+++ a/kernel/fork.c
@@ -753,7 +753,7 @@ static void check_mm(struct mm_struct *m
 			 "Please make sure 'struct resident_page_types[]' is updated as well");
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		long x = percpu_counter_sum(&mm->rss_stat[i]);
+		long x = percpu_counter_sum_all(&mm->rss_stat[i]);
 
 		if (unlikely(x))
 			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld\n",
--- a/lib/percpu_counter.c~mm-convert-mms-rss-stats-into-percpu_counter-fix
+++ a/lib/percpu_counter.c
@@ -117,11 +117,8 @@ void percpu_counter_sync(struct percpu_c
 }
 EXPORT_SYMBOL(percpu_counter_sync);
 
-/*
- * Add up all the per-cpu counts, return the result.  This is a more accurate
- * but much slower version of percpu_counter_read_positive()
- */
-s64 __percpu_counter_sum(struct percpu_counter *fbc)
+static s64 __percpu_counter_sum_mask(struct percpu_counter *fbc,
+			      const struct cpumask *cpu_mask)
 {
 	s64 ret;
 	int cpu;
@@ -129,15 +126,30 @@ s64 __percpu_counter_sum(struct percpu_c
 
 	raw_spin_lock_irqsave(&fbc->lock, flags);
 	ret = fbc->count;
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, cpu_mask) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
 	raw_spin_unlock_irqrestore(&fbc->lock, flags);
 	return ret;
 }
+
+/*
+ * Add up all the per-cpu counts, return the result.  This is a more accurate
+ * but much slower version of percpu_counter_read_positive()
+ */
+s64 __percpu_counter_sum(struct percpu_counter *fbc)
+{
+	return __percpu_counter_sum_mask(fbc, cpu_online_mask);
+}
 EXPORT_SYMBOL(__percpu_counter_sum);
 
+s64 __percpu_counter_sum_all(struct percpu_counter *fbc)
+{
+	return __percpu_counter_sum_mask(fbc, cpu_possible_mask);
+}
+EXPORT_SYMBOL(__percpu_counter_sum_all);
+
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount, gfp_t gfp,
 			  struct lock_class_key *key)
 {
_

Patches currently in -mm which might be from shakeelb@google.com are

percpu_counter-add-percpu_counter_sum_all-interface.patch
mm-convert-mms-rss-stats-into-percpu_counter.patch

