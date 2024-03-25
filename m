Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B12A28E6
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711391693; cv=none; b=qxJBkUIV88bfbIBeNjRBTbr6iKCjKhbeBh7nQ/C7CXWyvH4K25xQglwyHAA6y06H3xAZIo1DKmnkd4moFiJg7XAdTS2fz5LAMicOksM9ijmKoIEKAwTmC5nXPHRAqx1nsB1D7VKXUcNWTWvLsqjOzIV47gWrJrr4cTjQpHkIEzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711391693; c=relaxed/simple;
	bh=7G1Yax2e4vPsmptP3xNXeH7tLbJwvX9C6yfeXcqwi/8=;
	h=Date:To:From:Subject:Message-Id; b=aCndK650n++++bE2KoWDRWIeyeEQvNJIbZHAlU1UbCOVVvf2mk30TJiq9oo+ZcEuxCZg93SISZAPpoGTWCYaWoIS4hsczHbhqHEX1cy3ZMZHw1dvOMVVp1F4xnGUqux1lbIidZgMDRz8khCuWO63QjDbWf4GnXhZ9bVIoyPZxyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a+pzAsD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a+pzAsD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12249C433C7;
	Mon, 25 Mar 2024 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711391693;
	bh=7G1Yax2e4vPsmptP3xNXeH7tLbJwvX9C6yfeXcqwi/8=;
	h=Date:To:From:Subject:From;
	b=a+pzAsD4MprtkSe4ZKsyf72A609fe4LalpWUV8aUBfL34cjw4IGIswiwPq28B4p09
	 /TXfdezINeEWdfYvPkyPHmOMOSkSXJIsW2Jwx66rXgjrSNmn35U2x9CSg//OTKWw2S
	 FY+1WpKC4KVAfeoKeEPVQnb/ohYZPwPDiztq2TFI=
Date: Mon, 25 Mar 2024 11:34:52 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,dawei.li@shingroup.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] cpumask-create-dedicated-kmem-cache-for-cpumask-var.patch removed from -mm tree
Message-Id: <20240325183453.12249C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cpumask: create dedicated kmem cache for cpumask var
has been removed from the -mm tree.  Its filename was
     cpumask-create-dedicated-kmem-cache-for-cpumask-var.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Dawei Li <dawei.li@shingroup.cn>
Subject: cpumask: create dedicated kmem cache for cpumask var
Date: Tue, 19 Mar 2024 20:24:00 +0800

alloc_cpumask_var_node() and friends allocate cpumask var dynamically
for CONFIG_CPUMASK_OFFSTACK=y kernel. The allocated size of cpumask var
is cpumask_size(), which is runtime constant after nr_cpu_ids is
freezed.

Create a dedicated kmem cache for dynamic allocation of cpumask var.

The window for creation of cache is somewhat narrow:
- After last update of nr_cpu_ids(via set_nr_cpu_ids())
- After kmem cache is available.
- Before any alloc_cpumask_var_node() invocations(sched_init() e.g).

Link: https://lkml.kernel.org/r/20240319122400.399516-1-dawei.li@shingroup.cn
Signed-off-by: Dawei Li <dawei.li@shingroup.cn>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    7 +++++++
 init/main.c             |    1 +
 lib/cpumask.c           |   15 +++++++++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/linux/cpumask.h~cpumask-create-dedicated-kmem-cache-for-cpumask-var
+++ a/include/linux/cpumask.h
@@ -902,6 +902,8 @@ typedef struct cpumask *cpumask_var_t;
 #define this_cpu_cpumask_var_ptr(x)	this_cpu_read(x)
 #define __cpumask_var_read_mostly	__read_mostly
 
+int __init cpumask_cache_init(void);
+
 bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
 
 static inline
@@ -949,6 +951,11 @@ typedef struct cpumask cpumask_var_t[1];
 #define this_cpu_cpumask_var_ptr(x) this_cpu_ptr(x)
 #define __cpumask_var_read_mostly
 
+static inline int cpumask_cache_init(void)
+{
+	return 0;
+}
+
 static inline bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
 {
 	return true;
--- a/init/main.c~cpumask-create-dedicated-kmem-cache-for-cpumask-var
+++ a/init/main.c
@@ -931,6 +931,7 @@ void start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	mm_core_init();
+	cpumask_cache_init();
 	poking_init();
 	ftrace_init();
 
--- a/lib/cpumask.c~cpumask-create-dedicated-kmem-cache-for-cpumask-var
+++ a/lib/cpumask.c
@@ -57,9 +57,20 @@ EXPORT_SYMBOL(cpumask_next_wrap);
  * CONFIG_CPUMASK_OFFSTACK=n, so does code elimination in that case
  * too.
  */
+
+static struct kmem_cache *cpumask_cache __ro_after_init;
+
+int __init cpumask_cache_init(void)
+{
+	cpumask_cache = kmem_cache_create("cpumask", cpumask_size(), sizeof(long),
+					  SLAB_HWCACHE_ALIGN, NULL);
+
+	return cpumask_cache ? 0 : -ENOMEM;
+}
+
 bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node)
 {
-	*mask = kmalloc_node(cpumask_size(), flags, node);
+	*mask = kmem_cache_alloc_node(cpumask_cache, flags, node);
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 	if (!*mask) {
@@ -97,7 +108,7 @@ void __init alloc_bootmem_cpumask_var(cp
  */
 void free_cpumask_var(cpumask_var_t mask)
 {
-	kfree(mask);
+	kmem_cache_free(cpumask_cache, mask);
 }
 EXPORT_SYMBOL(free_cpumask_var);
 
_

Patches currently in -mm which might be from dawei.li@shingroup.cn are


