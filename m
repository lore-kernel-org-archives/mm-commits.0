Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178091E5B72
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161337; cv=none; b=XonSQzCCiCe/gLVb7yb9v9+BqzqPNF7poOvGrNjfeU1iWGhli5lDJ593ahIMxgdJOrd9IY2TCXamBpnvqHWrildGPSWi6ygYrAbotrFs7n7AvrfUmFMKPMRGe3nkg2e/eASKIKhvCG+KvnMrafQEWmbZvnvI/F8SgB3Ot1oOnLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161337; c=relaxed/simple;
	bh=TALftInW9RKfcvM3ISfErvxGYZFlMSdj/RvCK6x3a3Q=;
	h=Date:To:From:Subject:Message-Id; b=rGqABxy+ZUmMp415veH6rTO386k8MqRegHXVvXfXPCPAiqV6WwXKwznsggLTCaEyhC+ZaAE3OABn4ZIqOTRpIhVdz2klrPQMk42fDy+qMGQTlaV3n/6H8B3D9pJQz8PpQkQll76dDHrjZ8HT9dPYTvYwa5Pz7ijO/jO9wYYpPp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yjYfEEmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yjYfEEmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAFCC4CEEF;
	Sat,  2 Aug 2025 19:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161336;
	bh=TALftInW9RKfcvM3ISfErvxGYZFlMSdj/RvCK6x3a3Q=;
	h=Date:To:From:Subject:From;
	b=yjYfEEmtklvd1X9LePiQZcD1AH8UoPHkEZ5DavQwVIPOe9G6EJ2INfwmabmoM8J0p
	 dQW/5OAWdm9RFnz1QJiDwLlnkPzx1AOCr5GU8vjIvD0WnAMAzkDxqWdsTfEZnlDkXi
	 +lBLs12oqu+O6t6LH+3dr04u+i2s/TFnJOS6aV68=
Date: Sat, 02 Aug 2025 12:02:16 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] stackdepot-make-max-number-of-pools-boot-time-configurable.patch removed from -mm tree
Message-Id: <20250802190216.8CAFCC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stackdepot: make max number of pools boot-time configurable
has been removed from the -mm tree.  Its filename was
     stackdepot-make-max-number-of-pools-boot-time-configurable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
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


