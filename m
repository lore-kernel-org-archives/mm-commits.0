Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E558386329
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 21:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751663393; cv=none; b=k0EXWKmpkMET3v6laXouSJKVRGeW/T13RFSINSOSZB4fYshmD0DZJx2dlY33w42VzhVJwXhTgrU28WT25o1/e9pz2phqyZliC/xwNQVO4oMFnNjttpsq0awSp7oW4IIjjD1DbrIC1fkvDAAg/p0zjbgY/hOa47H+Vm0oCUBEgcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751663393; c=relaxed/simple;
	bh=h8TdUzAIzaayThDs8DRModAbUkSYGgfw0jpHwDqzjLg=;
	h=Date:To:From:Subject:Message-Id; b=piUSANLvkLpgFQgjO3oqvv672NE1dnAbN8R6f6eXFanJiiPtFLuiJ86eAxFFhMHUhbvDpUMCdNrP7F+DoL1+5Qxu/HJYgoEvUf5FT4Z+V+JS/Q8rbPYkm94glxBT9ZCa9dxGbgqYtRMJC2rb79ryaNMs29rPvJiPJZn2zjGOLJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wy8L1wl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wy8L1wl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FFEC4CEE3;
	Fri,  4 Jul 2025 21:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751663392;
	bh=h8TdUzAIzaayThDs8DRModAbUkSYGgfw0jpHwDqzjLg=;
	h=Date:To:From:Subject:From;
	b=wy8L1wl3N+SSW0BRQD3kr3wXyDiqnMnPHqFn6WbtXip20gzub6BTZ1a5LH82iBlJT
	 EoVMJwhP6HtSUrAOkapjUX8d0OGksLt6OWe4r0lp3oiWuVS047AhEDYNF3VO7df6Jn
	 +vY3+7cdhKd9WGngQQuSkpZC07zgy2aH7XAv/FWQ=
Date: Fri, 04 Jul 2025 14:09:51 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dev.jain@arm.com,raghavendra.kt@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-introduce-xfail-for-failing-tests.patch added to mm-new branch
Message-Id: <20250704210952.71FFEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc.c: introduce xfail for failing tests
has been added to the -mm mm-new branch.  Its filename is
     lib-test_vmallocc-introduce-xfail-for-failing-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-introduce-xfail-for-failing-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Raghavendra K T <raghavendra.kt@amd.com>
Subject: lib/test_vmalloc.c: introduce xfail for failing tests
Date: Wed, 2 Jul 2025 06:43:19 +0000

The test align_shift_alloc_test is expected to fail.  Reporting the test
as fail confuses to be a genuine failure.  Introduce widely used xfail
sematics to address the issue.

Note: a warn_alloc dump similar to below is still expected:

 Call Trace:
  <TASK>
  dump_stack_lvl+0x64/0x80
  warn_alloc+0x137/0x1b0
  ? __get_vm_area_node+0x134/0x140

Snippet of dmesg after change:

Summary: random_size_align_alloc_test passed: 1 failed: 0 xfailed: 0 ..
Summary: align_shift_alloc_test passed: 0 failed: 0 xfailed: 1 ..
Summary: pcpu_alloc_test passed: 1 failed: 0 xfailed: 0 ..

Link: https://lkml.kernel.org/r/20250702064319.885-1-raghavendra.kt@amd.com
Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-introduce-xfail-for-failing-tests
+++ a/lib/test_vmalloc.c
@@ -396,25 +396,27 @@ cleanup:
 struct test_case_desc {
 	const char *test_name;
 	int (*test_func)(void);
+	bool xfail;
 };
 
 static struct test_case_desc test_case_array[] = {
-	{ "fix_size_alloc_test", fix_size_alloc_test },
-	{ "full_fit_alloc_test", full_fit_alloc_test },
-	{ "long_busy_list_alloc_test", long_busy_list_alloc_test },
-	{ "random_size_alloc_test", random_size_alloc_test },
-	{ "fix_align_alloc_test", fix_align_alloc_test },
-	{ "random_size_align_alloc_test", random_size_align_alloc_test },
-	{ "align_shift_alloc_test", align_shift_alloc_test },
-	{ "pcpu_alloc_test", pcpu_alloc_test },
-	{ "kvfree_rcu_1_arg_vmalloc_test", kvfree_rcu_1_arg_vmalloc_test },
-	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test },
-	{ "vm_map_ram_test", vm_map_ram_test },
+	{ "fix_size_alloc_test", fix_size_alloc_test, },
+	{ "full_fit_alloc_test", full_fit_alloc_test, },
+	{ "long_busy_list_alloc_test", long_busy_list_alloc_test, },
+	{ "random_size_alloc_test", random_size_alloc_test, },
+	{ "fix_align_alloc_test", fix_align_alloc_test, },
+	{ "random_size_align_alloc_test", random_size_align_alloc_test, },
+	{ "align_shift_alloc_test", align_shift_alloc_test, true },
+	{ "pcpu_alloc_test", pcpu_alloc_test, },
+	{ "kvfree_rcu_1_arg_vmalloc_test", kvfree_rcu_1_arg_vmalloc_test, },
+	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
+	{ "vm_map_ram_test", vm_map_ram_test, },
 	/* Add a new test case here. */
 };
 
 struct test_case_data {
 	int test_failed;
+	int test_xfailed;
 	int test_passed;
 	u64 time;
 };
@@ -444,7 +446,7 @@ static int test_func(void *private)
 {
 	struct test_driver *t = private;
 	int random_array[ARRAY_SIZE(test_case_array)];
-	int index, i, j;
+	int index, i, j, ret;
 	ktime_t kt;
 	u64 delta;
 
@@ -468,11 +470,14 @@ static int test_func(void *private)
 		 */
 		if (!((run_test_mask & (1 << index)) >> index))
 			continue;
-
 		kt = ktime_get();
 		for (j = 0; j < test_repeat_count; j++) {
-			if (!test_case_array[index].test_func())
+			ret = test_case_array[index].test_func();
+
+			if (!ret && !test_case_array[index].xfail)
 				t->data[index].test_passed++;
+			else if (ret && test_case_array[index].xfail)
+				t->data[index].test_xfailed++;
 			else
 				t->data[index].test_failed++;
 		}
@@ -576,10 +581,11 @@ static void do_concurrent_test(void)
 				continue;
 
 			pr_info(
-				"Summary: %s passed: %d failed: %d repeat: %d loops: %d avg: %llu usec\n",
+				"Summary: %s passed: %d failed: %d xfailed: %d repeat: %d loops: %d avg: %llu usec\n",
 				test_case_array[j].test_name,
 				t->data[j].test_passed,
 				t->data[j].test_failed,
+				t->data[j].test_xfailed,
 				test_repeat_count, test_loop_count,
 				t->data[j].time);
 		}
_

Patches currently in -mm which might be from raghavendra.kt@amd.com are

lib-test_vmallocc-introduce-xfail-for-failing-tests.patch

