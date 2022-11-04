Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7070BC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Nov 2022 23:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiKDXGY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiKDXGV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2022 19:06:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253D111A1F
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 16:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4B2B62262
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 23:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A7DC433D6;
        Fri,  4 Nov 2022 23:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667603179;
        bh=oyN+VrzbXOWhuotGY06Pw5H4qKxGmYlXGnkuCmVTCjU=;
        h=Date:To:From:Subject:From;
        b=mxxM1VqAz4xQhj4gRc/2XOj3a42RAF/dZuLiVD761G4DmkXjmxwUGsmg1HqRcl7F5
         mfB14JNmOcCdY0JRfHrsKFBz8ZZbUtWX2YXbwiwfWpmEfNXOxDK+XxyPVipRVgU3K3
         YhvBeupptO4jBwdHx66d1Ky4jZ75e2Zux1mqTsx4=
Date:   Fri, 04 Nov 2022 16:06:18 -0700
To:     mm-commits@vger.kernel.org, m.szyprowski@samsung.com,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-mms-rss-stats-into-percpu_counter-fix.patch added to mm-unstable branch
Message-Id: <20221104230619.17A7DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Thu, 3 Nov 2022 06:05:13 +0000
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-mms-rss-stats-into-percpu_counter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-mms-rss-stats-into-percpu_counter-fix.patch

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

mm-convert-mms-rss-stats-into-percpu_counter.patch
mm-convert-mms-rss-stats-into-percpu_counter-fix.patch

