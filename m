Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19293C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiLAAAO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLAAAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FC558034
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7315B61E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF014C433C1;
        Thu,  1 Dec 2022 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852811;
        bh=dmtf7z5koPgtzs469dizvQHUPKW0vJkO6ATM0s7Z17U=;
        h=Date:To:From:Subject:From;
        b=i+krrGFhSJpsNpKI833UQ44lYp7yRgLLQNmr0evcZl01PKiUjkbjPLO7slUYYvHIr
         XrX72HTswxxzBN4EmHOt+K0YfKvJ+Z+2B0y+R43CZx7wj1S4hsi3z10w7JUV2jjvLn
         kms9/uaQ5DOq/UFpn6Vtyfs83ke82mhNAWBE+A0M=
Date:   Wed, 30 Nov 2022 16:00:11 -0800
To:     mm-commits@vger.kernel.org, m.szyprowski@samsung.com,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu_counter-add-percpu_counter_sum_all-interface.patch removed from -mm tree
Message-Id: <20221201000011.BF014C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: percpu_counter: add percpu_counter_sum_all interface
has been removed from the -mm tree.  Its filename was
     percpu_counter-add-percpu_counter_sum_all-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: percpu_counter: add percpu_counter_sum_all interface
Date: Wed, 9 Nov 2022 01:20:11 +0000

The percpu_counter is used for scenarios where performance is more
important than the accuracy.  For percpu_counter users, who want more
accurate information in their slowpath, percpu_counter_sum is provided
which traverses all the online CPUs to accumulate the data.  The reason it
only needs to traverse online CPUs is because percpu_counter does
implement CPU offline callback which syncs the local data of the offlined
CPU.

However there is a small race window between the online CPUs traversal of
percpu_counter_sum and the CPU offline callback.  The offline callback has
to traverse all the percpu_counters on the system to flush the CPU local
data which can be a lot.  During that time, the CPU which is going offline
has already been published as offline to all the readers.  So, as the
offline callback is running, percpu_counter_sum can be called for one
counter which has some state on the CPU going offline.  Since
percpu_counter_sum only traverses online CPUs, it will skip that specific
CPU and the offline callback might not have flushed the state for that
specific percpu_counter on that offlined CPU.

Normally this is not an issue because percpu_counter users can deal with
some inaccuracy for small time window.  However a new user i.e.  mm_struct
on the cleanup path wants to check the exact state of the percpu_counter
through check_mm().  For such users, this patch introduces
percpu_counter_sum_all() which traverses all possible CPUs and it is used
in fork.c:check_mm() to avoid the potential race.

This issue is exposed by the later patch "mm: convert mm's rss stats into
percpu_counter".

Link: https://lkml.kernel.org/r/20221109012011.881058-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    6 ++++++
 kernel/fork.c                  |    5 +++++
 lib/percpu_counter.c           |   29 +++++++++++++++++++++++------
 3 files changed, 34 insertions(+), 6 deletions(-)

--- a/include/linux/percpu_counter.h~percpu_counter-add-percpu_counter_sum_all-interface
+++ a/include/linux/percpu_counter.h
@@ -45,6 +45,7 @@ void percpu_counter_set(struct percpu_co
 void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount,
 			      s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
+s64 percpu_counter_sum_all(struct percpu_counter *fbc);
 int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch);
 void percpu_counter_sync(struct percpu_counter *fbc);
 
@@ -192,6 +193,11 @@ static inline s64 percpu_counter_sum(str
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
--- a/kernel/fork.c~percpu_counter-add-percpu_counter_sum_all-interface
+++ a/kernel/fork.c
@@ -755,6 +755,11 @@ static void check_mm(struct mm_struct *m
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		long x = percpu_counter_sum(&mm->rss_stat[i]);
 
+		if (likely(!x))
+			continue;
+
+		/* Making sure this is not due to race with CPU offlining. */
+		x = percpu_counter_sum_all(&mm->rss_stat[i]);
 		if (unlikely(x))
 			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld\n",
 				 mm, resident_page_types[i], x);
--- a/lib/percpu_counter.c~percpu_counter-add-percpu_counter_sum_all-interface
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
@@ -129,15 +126,35 @@ s64 __percpu_counter_sum(struct percpu_c
 
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
 
+/*
+ * This is slower version of percpu_counter_sum as it traverses all possible
+ * cpus. Use this only in the cases where accurate data is needed in the
+ * presense of CPUs getting offlined.
+ */
+s64 percpu_counter_sum_all(struct percpu_counter *fbc)
+{
+	return __percpu_counter_sum_mask(fbc, cpu_possible_mask);
+}
+EXPORT_SYMBOL(percpu_counter_sum_all);
+
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount, gfp_t gfp,
 			  struct lock_class_key *key)
 {
_

Patches currently in -mm which might be from shakeelb@google.com are


