Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E8811712
	for <mm-commits@vger.kernel.org>; Fri, 18 Jul 2025 21:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752874174; cv=none; b=dg7YdyvlzjjUtHgBXJ6jv58ebU42mHXYrzaO7/cmDlIe3Yi+ak4lACRjo8BfKninZJ+Lb41OMlZf1EvGI0hvQPK9Jky+I8UtzgSBgEZjPoFS8FTlgC3Kd9ORAPF5/zib/uc1RewawCOBTX4atmyuPZ3/F4xgiYRx6tya6mHdZdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752874174; c=relaxed/simple;
	bh=Df/NEXolldqSR1WV9OIqu08FnAhO1kQ8hnl8Z0T5+nw=;
	h=Date:To:From:Subject:Message-Id; b=c3/0+YPbmJ+DT9MgxN6RSYAl+DRP73Iyi/ofIqM80QGArc3BnY38+sUrrRFa6A+plI7yc6GSqXqbzdWqly7rqMoIryMhnNPuRjBKVbZhz7nSce/32QJYO6Iyh5zR8m5bzkBG2sRYI2wNJ48CVfHROaZQjfoZPdAgtZCvFDxzjZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xOgeWpEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xOgeWpEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BA9C4CEEB;
	Fri, 18 Jul 2025 21:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752874174;
	bh=Df/NEXolldqSR1WV9OIqu08FnAhO1kQ8hnl8Z0T5+nw=;
	h=Date:To:From:Subject:From;
	b=xOgeWpEqkePZxGEpUbw+dUOceYsBNi3HpEev4FbWThBVqWfQQQxC+4kFvr5JYbMx8
	 vtoaXLYq5fAAiwzLzUPRIjvxNYz1bDNLXMYytPGUCd7bQnlqZUuUDaSA+pJEmNhI2k
	 IJeNNHsQmio+HRX/+9q2qCL2Ou6FQvEgAy0dF6r4=
Date: Fri, 18 Jul 2025 14:29:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-make-max-number-of-pools-boot-time-configurable.patch added to mm-nonmm-unstable branch
Message-Id: <20250718212934.10BA9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stackdepot: make max number of pools boot-time configurable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     stackdepot-make-max-number-of-pools-boot-time-configurable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-make-max-number-of-pools-boot-time-configurable.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Matt Fleming <mfleming@cloudflare.com>
Subject: stackdepot: make max number of pools boot-time configurable
Date: Fri, 18 Jul 2025 16:39:28 +0100

We're hitting the WARN in depot_init_pool() about reaching the stack depot
limit because we have long stacks that don't dedup very well.

Introduce a new start-up parameter to allow users to set the number of
maximum stack depot pools.

Link: https://lkml.kernel.org/r/20250718153928.94229-1-matt@readmodwrite.com
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Macro Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    5 +
 lib/stackdepot.c                                |   67 ++++++++++++--
 2 files changed, 63 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~stackdepot-make-max-number-of-pools-boot-time-configurable
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -7029,6 +7029,11 @@
 			consumed by the stack hash table. By default this is set
 			to false.
 
+	stack_depot_max_pools= [KNL,EARLY]
+			Specify the maximum number of pools to use for storing
+			stack traces. Pools are allocated on-demand up to this
+			limit. Default value is 8191 pools.
+
 	stacktrace	[FTRACE]
 			Enabled the stack tracer on boot up.
 
--- a/lib/stackdepot.c~stackdepot-make-max-number-of-pools-boot-time-configurable
+++ a/lib/stackdepot.c
@@ -36,11 +36,11 @@
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
 
-#define DEPOT_POOLS_CAP 8192
-/* The pool_index is offset by 1 so the first record does not have a 0 handle. */
-#define DEPOT_MAX_POOLS \
-	(((1LL << (DEPOT_POOL_INDEX_BITS)) - 1 < DEPOT_POOLS_CAP) ? \
-	 (1LL << (DEPOT_POOL_INDEX_BITS)) - 1 : DEPOT_POOLS_CAP)
+/*
+ * The pool_index is offset by 1 so the first record does not have a 0 handle.
+ */
+static unsigned int stack_max_pools __read_mostly =
+	MIN((1LL << DEPOT_POOL_INDEX_BITS) - 1, 8192);
 
 static bool stack_depot_disabled;
 static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
@@ -62,7 +62,7 @@ static unsigned int stack_bucket_number_
 static unsigned int stack_hash_mask;
 
 /* Array of memory regions that store stack records. */
-static void *stack_pools[DEPOT_MAX_POOLS];
+static void **stack_pools;
 /* Newly allocated pool that is not yet added to stack_pools. */
 static void *new_pool;
 /* Number of pools in stack_pools. */
@@ -101,6 +101,34 @@ static int __init disable_stack_depot(ch
 }
 early_param("stack_depot_disable", disable_stack_depot);
 
+static int __init parse_max_pools(char *str)
+{
+	const long long limit = (1LL << (DEPOT_POOL_INDEX_BITS)) - 1;
+	unsigned int max_pools;
+	int rv;
+
+	rv = kstrtouint(str, 0, &max_pools);
+	if (rv)
+		return rv;
+
+	if (max_pools < 1024) {
+		pr_err("stack_depot_max_pools below 1024, using default of %u\n",
+		       stack_max_pools);
+		goto out;
+	}
+
+	if (max_pools > limit) {
+		pr_err("stack_depot_max_pools exceeds %lld, using default of %u\n",
+		       limit, stack_max_pools);
+		goto out;
+	}
+
+	stack_max_pools = max_pools;
+out:
+	return 0;
+}
+early_param("stack_depot_max_pools", parse_max_pools);
+
 void __init stack_depot_request_early_init(void)
 {
 	/* Too late to request early init now. */
@@ -182,6 +210,17 @@ int __init stack_depot_early_init(void)
 	}
 	init_stack_table(entries);
 
+	pr_info("allocating space for %u stack pools via memblock\n",
+		stack_max_pools);
+	stack_pools =
+		memblock_alloc(stack_max_pools * sizeof(void *), PAGE_SIZE);
+	if (!stack_pools) {
+		pr_err("stack pools allocation failed, disabling\n");
+		memblock_free(stack_table, entries * sizeof(struct list_head));
+		stack_depot_disabled = true;
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -231,6 +270,16 @@ int stack_depot_init(void)
 	stack_hash_mask = entries - 1;
 	init_stack_table(entries);
 
+	pr_info("allocating space for %u stack pools via kvcalloc\n",
+		stack_max_pools);
+	stack_pools = kvcalloc(stack_max_pools, sizeof(void *), GFP_KERNEL);
+	if (!stack_pools) {
+		pr_err("stack pools allocation failed, disabling\n");
+		kvfree(stack_table);
+		stack_depot_disabled = true;
+		ret = -ENOMEM;
+	}
+
 out_unlock:
 	mutex_unlock(&stack_depot_init_mutex);
 
@@ -245,9 +294,9 @@ static bool depot_init_pool(void **preal
 {
 	lockdep_assert_held(&pool_lock);
 
-	if (unlikely(pools_num >= DEPOT_MAX_POOLS)) {
+	if (unlikely(pools_num >= stack_max_pools)) {
 		/* Bail out if we reached the pool limit. */
-		WARN_ON_ONCE(pools_num > DEPOT_MAX_POOLS); /* should never happen */
+		WARN_ON_ONCE(pools_num > stack_max_pools); /* should never happen */
 		WARN_ON_ONCE(!new_pool); /* to avoid unnecessary pre-allocation */
 		WARN_ONCE(1, "Stack depot reached limit capacity");
 		return false;
@@ -273,7 +322,7 @@ static bool depot_init_pool(void **preal
 	 * NULL; do not reset to NULL if we have reached the maximum number of
 	 * pools.
 	 */
-	if (pools_num < DEPOT_MAX_POOLS)
+	if (pools_num < stack_max_pools)
 		WRITE_ONCE(new_pool, NULL);
 	else
 		WRITE_ONCE(new_pool, STACK_DEPOT_POISON);
_

Patches currently in -mm which might be from mfleming@cloudflare.com are

stackdepot-make-max-number-of-pools-boot-time-configurable.patch

