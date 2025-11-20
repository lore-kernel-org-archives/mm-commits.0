Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE32B266EFC
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763657335; cv=none; b=WBuJXRV3lYlHFfuqFOpjhTo03fBmTGmv3CF7w8PMDbm0NVk/2BXi/2Ar5cBise5Kj00GUD0atVD+tOWXevBRMf8rMSjug2lKplQqN5Q8gPb+pgcH7SMfy3pvgpx/+LHo8u+kECxnc71f7gsCJK6MHk2eljpaOokj3o+/diP2W+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763657335; c=relaxed/simple;
	bh=LzpheKfltb8vCbl9pXnxkjATowNrtf/IYH+EYfHo3n4=;
	h=Date:To:From:Subject:Message-Id; b=Iy+t3wy4KZ8XAk0x+BE0nVgGLFj9wznOxtiZ6r7MTtg8kvSn+KX+aAGTCuZtNUBuB0tCUBdfzS1FqGu5SG8ZSBGtkSuqO0Y+5XePvmHpYT1Rvm/AUIVexgQYnG5F6R0ZsyYjKvERudk6gnTfq5rZ/LrNPjkwcrH9Gq3LGdwtKMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xEhmgykN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xEhmgykN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F999C4CEF1;
	Thu, 20 Nov 2025 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763657335;
	bh=LzpheKfltb8vCbl9pXnxkjATowNrtf/IYH+EYfHo3n4=;
	h=Date:To:From:Subject:From;
	b=xEhmgykNk1wGCaKQXXAbYpMLNhT5j2ha/pgPlKhMIzR79UH+szrDtYB0cm1q29Wdk
	 Pbi7trhJuuDxhoIGfOpKVGpx9vwl/9jKzucY052Y8N40RxucmCp4Urqn8QQuO3DKQB
	 i3XjWUhiwAwjM2fQ/KLYgiiQ/ho16ch4xvrGfJms=
Date: Thu, 20 Nov 2025 08:48:55 -0800
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,liam.howlett@oracle.com,kees@kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-stop-ignoring-numa-while-handling-cached-thread-stacks.patch added to mm-nonmm-unstable branch
Message-Id: <20251120164855.8F999C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: stop ignoring NUMA while handling cached thread stacks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-stop-ignoring-numa-while-handling-cached-thread-stacks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-stop-ignoring-numa-while-handling-cached-thread-stacks.patch

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

fork-stop-ignoring-numa-while-handling-cached-thread-stacks.patch

