Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA54C35280
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387676AbiBHW0C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387008AbiBHVn2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 16:43:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F479C0612B8
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 13:43:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ADA1FCE1C6A
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 21:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE4EC004E1;
        Tue,  8 Feb 2022 21:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644356603;
        bh=RdRoyxpa4K9bn3ewc+RsC40RhsxRj1GCLpIFW+ksl60=;
        h=Date:To:From:Subject:From;
        b=TCi21HujUk1J7fVU42e/nbf1T+o6O8nflBfR7Y6vVm/N2ZME6Ulh1ibiIpDd4arst
         6CL/1fXq7kclIKDDfYVJIaKIC65xZ0WLtOFxLj8lEGZ/VFu3aZUtxvoph7vV8pBppC
         fZn+5t7rzYdPpCc0NpHdBzAAUv5epKN7qYYJqq8s=
Date:   Tue, 08 Feb 2022 13:43:23 -0800
To:     mm-commits@vger.kernel.org, sumit.semwal@linaro.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        corbet@lwn.net, christian.koenig@amd.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-make-test-case-compatible-with-run-time-set-sample-interval.patch added to -mm tree
Message-Id: <20220208214323.AEE4EC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: make test case compatible with run time set sample interval
has been added to the -mm tree.  Its filename is
     kfence-make-test-case-compatible-with-run-time-set-sample-interval.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-make-test-case-compatible-with-run-time-set-sample-interval.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-make-test-case-compatible-with-run-time-set-sample-interval.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peng Liu <liupeng256@huawei.com>
Subject: kfence: make test case compatible with run time set sample interval

The parameter kfence_sample_interval can be set via boot parameter and
late shell command, which is convenient for automated tests and KFENCE
parameter optimization.  However, KFENCE test case just uses compile-time
CONFIG_KFENCE_SAMPLE_INTERVAL, which will make KFENCE test case not run as
users desired.  Export kfence_sample_interval, so that KFENCE test case
can use run-time-set sample interval.

Link: https://lkml.kernel.org/r/20220207034432.185532-1-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Christian Knig <christian.koenig@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h  |    2 ++
 mm/kfence/core.c        |    3 ++-
 mm/kfence/kfence_test.c |    8 ++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/kfence.h~kfence-make-test-case-compatible-with-run-time-set-sample-interval
+++ a/include/linux/kfence.h
@@ -17,6 +17,8 @@
 #include <linux/atomic.h>
 #include <linux/static_key.h>
 
+extern unsigned long kfence_sample_interval;
+
 /*
  * We allocate an even number of pages, as it simplifies calculations to map
  * address to metadata indices; effectively, the very first page serves as an
--- a/mm/kfence/core.c~kfence-make-test-case-compatible-with-run-time-set-sample-interval
+++ a/mm/kfence/core.c
@@ -47,7 +47,8 @@
 
 static bool kfence_enabled __read_mostly;
 
-static unsigned long kfence_sample_interval __read_mostly = CONFIG_KFENCE_SAMPLE_INTERVAL;
+unsigned long kfence_sample_interval __read_mostly = CONFIG_KFENCE_SAMPLE_INTERVAL;
+EXPORT_SYMBOL_GPL(kfence_sample_interval); /* Export for test modules. */
 
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
--- a/mm/kfence/kfence_test.c~kfence-make-test-case-compatible-with-run-time-set-sample-interval
+++ a/mm/kfence/kfence_test.c
@@ -268,13 +268,13 @@ static void *test_alloc(struct kunit *te
 	 * 100x the sample interval should be more than enough to ensure we get
 	 * a KFENCE allocation eventually.
 	 */
-	timeout = jiffies + msecs_to_jiffies(100 * CONFIG_KFENCE_SAMPLE_INTERVAL);
+	timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
 	/*
 	 * Especially for non-preemption kernels, ensure the allocation-gate
 	 * timer can catch up: after @resched_after, every failed allocation
 	 * attempt yields, to ensure the allocation-gate timer is scheduled.
 	 */
-	resched_after = jiffies + msecs_to_jiffies(CONFIG_KFENCE_SAMPLE_INTERVAL);
+	resched_after = jiffies + msecs_to_jiffies(kfence_sample_interval);
 	do {
 		if (test_cache)
 			alloc = kmem_cache_alloc(test_cache, gfp);
@@ -608,7 +608,7 @@ static void test_gfpzero(struct kunit *t
 	int i;
 
 	/* Skip if we think it'd take too long. */
-	KFENCE_TEST_REQUIRES(test, CONFIG_KFENCE_SAMPLE_INTERVAL <= 100);
+	KFENCE_TEST_REQUIRES(test, kfence_sample_interval <= 100);
 
 	setup_test_cache(test, size, 0, NULL);
 	buf1 = test_alloc(test, size, GFP_KERNEL, ALLOCATE_ANY);
@@ -739,7 +739,7 @@ static void test_memcache_alloc_bulk(str
 	 * 100x the sample interval should be more than enough to ensure we get
 	 * a KFENCE allocation eventually.
 	 */
-	timeout = jiffies + msecs_to_jiffies(100 * CONFIG_KFENCE_SAMPLE_INTERVAL);
+	timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
 	do {
 		void *objects[100];
 		int i, num = kmem_cache_alloc_bulk(test_cache, GFP_ATOMIC, ARRAY_SIZE(objects),
_

Patches currently in -mm which might be from liupeng256@huawei.com are

kfence-make-test-case-compatible-with-run-time-set-sample-interval.patch

