Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CEF7082D
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282352; cv=none; b=p6Me9fFLO+brlTTzjYRpZDhyazEfblKc2V5v2vCzxPt7B2+WUoG6UOzxMbz/bA3Vn8YAlFhOcwv3kmZ8FjVNMS6Lwg60Qj/ZmoYbxLIq/n3hjGgRxlSSDx/FnnvfipAsCmMcwXTVApvieEOMVxd6dEKueKfqprPcrvPnlfQcFoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282352; c=relaxed/simple;
	bh=o5UWKXR8ZOloeRTYGeccGU+73k8+werOSeabfb36RNc=;
	h=Date:To:From:Subject:Message-Id; b=IRqPHkqvzESg9DpUKz4IJO3VBwgc1XMyOoG1ATeUdBlhoLsGK390VtoCHIQPs27XgjnbnLeLrmXeAQn29N7l2Ks/HsC+XBwfLP05z084x0b8SGnbiRu9GdAzHZ3sw5D4kH6M/pbWI1aMYCKyMyitBIYCKEK/719OXBJJF0vfjzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u3ITQVih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u3ITQVih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1453C4CEFB;
	Thu, 27 Nov 2025 22:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282351;
	bh=o5UWKXR8ZOloeRTYGeccGU+73k8+werOSeabfb36RNc=;
	h=Date:To:From:Subject:From;
	b=u3ITQVih1ds7vI98FzYsOu47ZryC5Y90jDjGjcGFwO17kazswCyB76BjD68GsDfTS
	 9Nj8aBLEt8KMySOOzF4cyYdtb8c10LPuxi76Ljc/Z6YstIzItPV3ZG72V/LJJB5K4c
	 uWTR8MODkCo++JmZZ1atkhc7b+HdPNQsc0x5IxpM=
Date: Thu, 27 Nov 2025 14:25:50 -0800
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,liam.howlett@oracle.com,kees@kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-stop-ignoring-numa-while-handling-cached-thread-stacks.patch removed from -mm tree
Message-Id: <20251127222550.F1453C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: stop ignoring NUMA while handling cached thread stacks
has been removed from the -mm tree.  Its filename was
     fork-stop-ignoring-numa-while-handling-cached-thread-stacks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: fork: stop ignoring NUMA while handling cached thread stacks
Date: Thu, 20 Nov 2025 06:40:15 +0100

1. the numa parameter was straight up ignored.
2. nothing was done to check if the to-be-cached/allocated stack matches
   the local node

The id remains ignored on free in case of memoryless nodes.

Note the current caching is already bad as the cache keeps overflowing
and a different solution is needed for the long run, to be worked
out(tm).

Stats collected over a kernel build with the patch with the following
topology:
  NUMA node(s):              2
  NUMA node0 CPU(s):         0-11
  NUMA node1 CPU(s):         12-23

caller's node vs stack backing pages on free:
matching:	50083 (70%)
mismatched:	21492 (30%)

caching efficiency:
cached:		32651 (65.2%)
dropped:	17432 (34.8%)

Link: https://lkml.kernel.org/r/20251120054015.3019419-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   65 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 11 deletions(-)

--- a/kernel/fork.c~fork-stop-ignoring-numa-while-handling-cached-thread-stacks
+++ a/kernel/fork.c
@@ -208,15 +208,62 @@ struct vm_stack {
 	struct vm_struct *stack_vm_area;
 };
 
-static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
+static struct vm_struct *alloc_thread_stack_node_from_cache(struct task_struct *tsk, int node)
 {
+	struct vm_struct *vm_area;
 	unsigned int i;
 
-	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		struct vm_struct *tmp = NULL;
+	/*
+	 * If the node has memory, we are guaranteed the stacks are backed by local pages.
+	 * Otherwise the pages are arbitrary.
+	 *
+	 * Note that depending on cpuset it is possible we will get migrated to a different
+	 * node immediately after allocating here, so this does *not* guarantee locality for
+	 * arbitrary callers.
+	 */
+	scoped_guard(preempt) {
+		if (node != NUMA_NO_NODE && numa_node_id() != node)
+			return NULL;
+
+		for (i = 0; i < NR_CACHED_STACKS; i++) {
+			vm_area = this_cpu_xchg(cached_stacks[i], NULL);
+			if (vm_area)
+				return vm_area;
+		}
+	}
 
-		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
-			return true;
+	return NULL;
+}
+
+static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
+{
+	unsigned int i;
+	int nid;
+
+	/*
+	 * Don't cache stacks if any of the pages don't match the local domain, unless
+	 * there is no local memory to begin with.
+	 *
+	 * Note that lack of local memory does not automatically mean it makes no difference
+	 * performance-wise which other domain backs the stack. In this case we are merely
+	 * trying to avoid constantly going to vmalloc.
+	 */
+	scoped_guard(preempt) {
+		nid = numa_node_id();
+		if (node_state(nid, N_MEMORY)) {
+			for (i = 0; i < vm_area->nr_pages; i++) {
+				struct page *page = vm_area->pages[i];
+				if (page_to_nid(page) != nid)
+					return false;
+			}
+		}
+
+		for (i = 0; i < NR_CACHED_STACKS; i++) {
+			struct vm_struct *tmp = NULL;
+
+			if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
+				return true;
+		}
 	}
 	return false;
 }
@@ -283,13 +330,9 @@ static int alloc_thread_stack_node(struc
 {
 	struct vm_struct *vm_area;
 	void *stack;
-	int i;
-
-	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		vm_area = this_cpu_xchg(cached_stacks[i], NULL);
-		if (!vm_area)
-			continue;
 
+	vm_area = alloc_thread_stack_node_from_cache(tsk, node);
+	if (vm_area) {
 		if (memcg_charge_kernel_stack(vm_area)) {
 			vfree(vm_area->addr);
 			return -ENOMEM;
_

Patches currently in -mm which might be from mjguzik@gmail.com are


