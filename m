Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB0B1E486
	for <mm-commits@vger.kernel.org>; Thu, 18 Jan 2024 22:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616169; cv=none; b=QjwI5oxaJ4th6euU84hpycBv1wphNs8PkapWhBBgqzXSJF96dmwYwxZcI9naLqhpZrOJctV+d8s/Rvl3gzlTnCT5H0WMabUbyjl1TOFhmjlTuOmqDEX084gXYBT2bdhYyclXHVEiEJJE1NGAh2x3gyvSV4m6aKl1P/BCKwGjrWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616169; c=relaxed/simple;
	bh=HLWnimBR9jFFOsHKCbtrqp9qMOiztCPBvjJpTSSooZw=;
	h=Date:To:From:Subject:Message-Id; b=dmetMi57iLuFf78zkeub//S4VFCtDuQMH6XUaMoVFimrl/y09CS5TkGuBz1JivzJ9EZmmOC9t/au+wwnaWxpPcj3YqwTs5iosq0WoSCKVl3m6+QLRrhWmqF/Bm9qtGgQIdfe1V6V8MIMqoaOHRu9YKe/PyMPycw6Bu7JaLNt9DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s4uuQDH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s4uuQDH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818EDC43390;
	Thu, 18 Jan 2024 22:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705616168;
	bh=HLWnimBR9jFFOsHKCbtrqp9qMOiztCPBvjJpTSSooZw=;
	h=Date:To:From:Subject:From;
	b=s4uuQDH/Nv6wG1j8CL8uuXwDmTeAsy/WB63SIUMytqJYjmn+pDVK5i7QjNNIj1xIB
	 gvhdaOOPzYvWjDcj2qiRmu2azJsVycMD1dtZv4SPkAx2bweQIBToSJwR4LhCg6Xn6O
	 /tXNofmFW8VVn18XYx0KEKzY8JT6fAQsFJp0KzL4=
Date: Thu, 18 Jan 2024 14:16:06 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ak@linux.intel.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-add-stats-counters-exported-via-debugfs.patch added to mm-hotfixes-unstable branch
Message-Id: <20240118221608.818EDC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stackdepot: add stats counters exported via debugfs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     stackdepot-add-stats-counters-exported-via-debugfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-add-stats-counters-exported-via-debugfs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Marco Elver <elver@google.com>
Subject: stackdepot: add stats counters exported via debugfs
Date: Thu, 18 Jan 2024 12:01:29 +0100

Add a few basic stats counters for stack depot that can be used to derive
if stack depot is working as intended.  This is a snapshot of the new
stats after booting a system with a KASAN-enabled kernel:

 $ cat /sys/kernel/debug/stackdepot/stats
 pools: 838
 allocations: 29861
 frees: 6561
 in_use: 23300
 freelist_size: 1840

Generally, "pools" should be well below the max; once the system is
booted, "in_use" should remain relatively steady.

Link: https://lkml.kernel.org/r/20240118110216.2539519-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   53 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

--- a/lib/stackdepot.c~stackdepot-add-stats-counters-exported-via-debugfs
+++ a/lib/stackdepot.c
@@ -14,6 +14,7 @@
 
 #define pr_fmt(fmt) "stackdepot: " fmt
 
+#include <linux/debugfs.h>
 #include <linux/gfp.h>
 #include <linux/jhash.h>
 #include <linux/kernel.h>
@@ -115,6 +116,23 @@ static bool new_pool_required = true;
 /* Lock that protects the variables above. */
 static DEFINE_RWLOCK(pool_rwlock);
 
+/* Statistics counters for debugfs. */
+enum depot_counter_id {
+	DEPOT_COUNTER_ALLOCS,
+	DEPOT_COUNTER_FREES,
+	DEPOT_COUNTER_INUSE,
+	DEPOT_COUNTER_FREELIST_SIZE,
+	DEPOT_COUNTER_COUNT,
+};
+static long counters[DEPOT_COUNTER_COUNT];
+static const char *const counter_names[] = {
+	[DEPOT_COUNTER_ALLOCS]		= "allocations",
+	[DEPOT_COUNTER_FREES]		= "frees",
+	[DEPOT_COUNTER_INUSE]		= "in_use",
+	[DEPOT_COUNTER_FREELIST_SIZE]	= "freelist_size",
+};
+static_assert(ARRAY_SIZE(counter_names) == DEPOT_COUNTER_COUNT);
+
 static int __init disable_stack_depot(char *str)
 {
 	return kstrtobool(str, &stack_depot_disabled);
@@ -277,6 +295,7 @@ static void depot_init_pool(void *pool)
 		stack->handle.extra = 0;
 
 		list_add(&stack->list, &free_stacks);
+		counters[DEPOT_COUNTER_FREELIST_SIZE]++;
 	}
 
 	/* Save reference to the pool to be used by depot_fetch_stack(). */
@@ -376,6 +395,7 @@ depot_alloc_stack(unsigned long *entries
 	/* Get and unlink the first entry from the freelist. */
 	stack = list_first_entry(&free_stacks, struct stack_record, list);
 	list_del(&stack->list);
+	counters[DEPOT_COUNTER_FREELIST_SIZE]--;
 
 	/* Limit number of saved frames to CONFIG_STACKDEPOT_MAX_FRAMES. */
 	if (size > CONFIG_STACKDEPOT_MAX_FRAMES)
@@ -394,6 +414,8 @@ depot_alloc_stack(unsigned long *entries
 	 */
 	kmsan_unpoison_memory(stack, DEPOT_STACK_RECORD_SIZE);
 
+	counters[DEPOT_COUNTER_ALLOCS]++;
+	counters[DEPOT_COUNTER_INUSE]++;
 	return stack;
 }
 
@@ -426,6 +448,10 @@ static void depot_free_stack(struct stac
 	lockdep_assert_held_write(&pool_rwlock);
 
 	list_add(&stack->list, &free_stacks);
+
+	counters[DEPOT_COUNTER_FREELIST_SIZE]++;
+	counters[DEPOT_COUNTER_FREES]++;
+	counters[DEPOT_COUNTER_INUSE]--;
 }
 
 /* Calculates the hash for a stack. */
@@ -690,3 +716,30 @@ unsigned int stack_depot_get_extra_bits(
 	return parts.extra;
 }
 EXPORT_SYMBOL(stack_depot_get_extra_bits);
+
+static int stats_show(struct seq_file *seq, void *v)
+{
+	/*
+	 * data race ok: These are just statistics counters, and approximate
+	 * statistics are ok for debugging.
+	 */
+	seq_printf(seq, "pools: %d\n", data_race(pools_num));
+	for (int i = 0; i < DEPOT_COUNTER_COUNT; i++)
+		seq_printf(seq, "%s: %ld\n", counter_names[i], data_race(counters[i]));
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(stats);
+
+static int depot_debugfs_init(void)
+{
+	struct dentry *dir;
+
+	if (stack_depot_disabled)
+		return 0;
+
+	dir = debugfs_create_dir("stackdepot", NULL);
+	debugfs_create_file("stats", 0444, dir, NULL, &stats_fops);
+	return 0;
+}
+late_initcall(depot_debugfs_init);
_

Patches currently in -mm which might be from elver@google.com are

stackdepot-add-stats-counters-exported-via-debugfs.patch
stackdepot-make-fast-paths-lock-less-again.patch

