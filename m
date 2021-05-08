Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FD8C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D5486141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhEHWod (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWo3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0D72613EA;
        Sat,  8 May 2021 22:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513806;
        bh=bhSzJQlO1PtgRY6XuGkfuZY8jSnOVRG6TQ+IjdceDVU=;
        h=Date:From:To:Subject:From;
        b=KZhsexSzpAS80rELcaZYGm720Ks4dlPA3Zc5NX3/okSjud7fICsr6rVlCHPiZr7J/
         L+X1EqDQuML30yCuB09AdPW45Zov8BDTREHsV+n8lj6CSbO90cfhxWtdY1m6iAiK6T
         qhHN6YZF7+5l9nngZQ73HEd+kgem4+Kvz/R1cODI=
Date:   Sat, 08 May 2021 15:43:26 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, urezki@gmail.com, willy@infradead.org
Subject:  [merged]
 lib-test_vmallocc-add-a-new-nr_threads-parameter.patch removed from -mm
 tree
Message-ID: <20210508224326.ssXLBkXSI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: add a new 'nr_threads' parameter
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-add-a-new-nr_threads-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: add a new 'nr_threads' parameter

By using this parameter we can specify how many workers are created to
perform vmalloc tests.  By default it is one CPU.  The maximum value is
set to 1024.

As a result of this change a 'single_cpu_test' one becomes obsolete,
therefore it is no longer needed.

[urezki@gmail.com: extend max value of nr_threads parameter]
  Link: https://lkml.kernel.org/r/20210406124536.19658-1-urezki@gmail.com
Link: https://lkml.kernel.org/r/20210402202237.20334-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   88 +++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 48 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-add-a-new-nr_threads-parameter
+++ a/lib/test_vmalloc.c
@@ -23,8 +23,8 @@
 	module_param(name, type, 0444);			\
 	MODULE_PARM_DESC(name, msg)				\
 
-__param(bool, single_cpu_test, false,
-	"Use single first online CPU to run tests");
+__param(int, nr_threads, 0,
+	"Number of workers to perform tests(min: 1 max: USHRT_MAX)");
 
 __param(bool, sequential_test_order, false,
 	"Use sequential stress tests order");
@@ -51,13 +51,6 @@ __param(int, run_test_mask, INT_MAX,
 );
 
 /*
- * Depends on single_cpu_test parameter. If it is true, then
- * use first online CPU to trigger a test on, otherwise go with
- * all online CPUs.
- */
-static cpumask_t cpus_run_test_mask = CPU_MASK_NONE;
-
-/*
  * Read write semaphore for synchronization of setup
  * phase that is done in main thread and workers.
  */
@@ -386,16 +379,13 @@ struct test_case_data {
 	u64 time;
 };
 
-/* Split it to get rid of: WARNING: line over 80 characters */
-static struct test_case_data
-	per_cpu_test_data[NR_CPUS][ARRAY_SIZE(test_case_array)];
-
 static struct test_driver {
 	struct task_struct *task;
+	struct test_case_data data[ARRAY_SIZE(test_case_array)];
+
 	unsigned long start;
 	unsigned long stop;
-	int cpu;
-} per_cpu_test_driver[NR_CPUS];
+} *tdriver;
 
 static void shuffle_array(int *arr, int n)
 {
@@ -423,9 +413,6 @@ static int test_func(void *private)
 	ktime_t kt;
 	u64 delta;
 
-	if (set_cpus_allowed_ptr(current, cpumask_of(t->cpu)) < 0)
-		pr_err("Failed to set affinity to %d CPU\n", t->cpu);
-
 	for (i = 0; i < ARRAY_SIZE(test_case_array); i++)
 		random_array[i] = i;
 
@@ -450,9 +437,9 @@ static int test_func(void *private)
 		kt = ktime_get();
 		for (j = 0; j < test_repeat_count; j++) {
 			if (!test_case_array[index].test_func())
-				per_cpu_test_data[t->cpu][index].test_passed++;
+				t->data[index].test_passed++;
 			else
-				per_cpu_test_data[t->cpu][index].test_failed++;
+				t->data[index].test_failed++;
 		}
 
 		/*
@@ -461,7 +448,7 @@ static int test_func(void *private)
 		delta = (u64) ktime_us_delta(ktime_get(), kt);
 		do_div(delta, (u32) test_repeat_count);
 
-		per_cpu_test_data[t->cpu][index].time = delta;
+		t->data[index].time = delta;
 	}
 	t->stop = get_cycles();
 
@@ -477,53 +464,56 @@ static int test_func(void *private)
 	return 0;
 }
 
-static void
+static int
 init_test_configurtion(void)
 {
 	/*
-	 * Reset all data of all CPUs.
+	 * A maximum number of workers is defined as hard-coded
+	 * value and set to USHRT_MAX. We add such gap just in
+	 * case and for potential heavy stressing.
 	 */
-	memset(per_cpu_test_data, 0, sizeof(per_cpu_test_data));
+	nr_threads = clamp(nr_threads, 1, (int) USHRT_MAX);
 
-	if (single_cpu_test)
-		cpumask_set_cpu(cpumask_first(cpu_online_mask),
-			&cpus_run_test_mask);
-	else
-		cpumask_and(&cpus_run_test_mask, cpu_online_mask,
-			cpu_online_mask);
+	/* Allocate the space for test instances. */
+	tdriver = kvcalloc(nr_threads, sizeof(*tdriver), GFP_KERNEL);
+	if (tdriver == NULL)
+		return -1;
 
 	if (test_repeat_count <= 0)
 		test_repeat_count = 1;
 
 	if (test_loop_count <= 0)
 		test_loop_count = 1;
+
+	return 0;
 }
 
 static void do_concurrent_test(void)
 {
-	int cpu, ret;
+	int i, ret;
 
 	/*
 	 * Set some basic configurations plus sanity check.
 	 */
-	init_test_configurtion();
+	ret = init_test_configurtion();
+	if (ret < 0)
+		return;
 
 	/*
 	 * Put on hold all workers.
 	 */
 	down_write(&prepare_for_test_rwsem);
 
-	for_each_cpu(cpu, &cpus_run_test_mask) {
-		struct test_driver *t = &per_cpu_test_driver[cpu];
+	for (i = 0; i < nr_threads; i++) {
+		struct test_driver *t = &tdriver[i];
 
-		t->cpu = cpu;
-		t->task = kthread_run(test_func, t, "vmalloc_test/%d", cpu);
+		t->task = kthread_run(test_func, t, "vmalloc_test/%d", i);
 
 		if (!IS_ERR(t->task))
 			/* Success. */
 			atomic_inc(&test_n_undone);
 		else
-			pr_err("Failed to start kthread for %d CPU\n", cpu);
+			pr_err("Failed to start %d kthread\n", i);
 	}
 
 	/*
@@ -541,29 +531,31 @@ static void do_concurrent_test(void)
 		ret = wait_for_completion_timeout(&test_all_done_comp, HZ);
 	} while (!ret);
 
-	for_each_cpu(cpu, &cpus_run_test_mask) {
-		struct test_driver *t = &per_cpu_test_driver[cpu];
-		int i;
+	for (i = 0; i < nr_threads; i++) {
+		struct test_driver *t = &tdriver[i];
+		int j;
 
 		if (!IS_ERR(t->task))
 			kthread_stop(t->task);
 
-		for (i = 0; i < ARRAY_SIZE(test_case_array); i++) {
-			if (!((run_test_mask & (1 << i)) >> i))
+		for (j = 0; j < ARRAY_SIZE(test_case_array); j++) {
+			if (!((run_test_mask & (1 << j)) >> j))
 				continue;
 
 			pr_info(
 				"Summary: %s passed: %d failed: %d repeat: %d loops: %d avg: %llu usec\n",
-				test_case_array[i].test_name,
-				per_cpu_test_data[cpu][i].test_passed,
-				per_cpu_test_data[cpu][i].test_failed,
+				test_case_array[j].test_name,
+				t->data[j].test_passed,
+				t->data[j].test_failed,
 				test_repeat_count, test_loop_count,
-				per_cpu_test_data[cpu][i].time);
+				t->data[j].time);
 		}
 
-		pr_info("All test took CPU%d=%lu cycles\n",
-			cpu, t->stop - t->start);
+		pr_info("All test took worker%d=%lu cycles\n",
+			i, t->stop - t->start);
 	}
+
+	kvfree(tdriver);
 }
 
 static int vmalloc_test_init(void)
_

Patches currently in -mm which might be from urezki@gmail.com are


