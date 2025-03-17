Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9927B156678
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188526; cv=none; b=rdTTzIps+RMw14P6N52ufbfLfYFUmU9LbvFA0Gv/CrJpYRtRPugov1JcGy7F6M/ndyZBrH0q8A4LerLEglfeIIsCYHQlo/fvTeNL53EjkX65PZ89vrDdBiJpfArSNYlqRAYayWaVYH6VIXnBi8+mE3iThuXJ1ksJHqIX1c8PMko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188526; c=relaxed/simple;
	bh=sx3Ht8ckTY9FuacIwn7AdQ7Mfq+STkcHk0SPKDrkUUk=;
	h=Date:To:From:Subject:Message-Id; b=EeoSt05bYYwl9G+YYL0Djn+RL0Md75iV6Yz9OSkdykpzbkL3OJbtahE4Hfq/sEBnQkHho547jIc/FZWQgfj8BD/oFr0x+XelL+5Qxm5CXZEDi5zVKgPmEvoKTS8ZZ5UkyfmJIwLyiIMwrU+9gQHxGo16lZ7j0lvqVYobzUceCYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IfbIN3Ep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IfbIN3Ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC7FC4CEEC;
	Mon, 17 Mar 2025 05:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188526;
	bh=sx3Ht8ckTY9FuacIwn7AdQ7Mfq+STkcHk0SPKDrkUUk=;
	h=Date:To:From:Subject:From;
	b=IfbIN3EpjMdMbepEMEnLp4pza+QiJhSJkFN5wCbjii9xRniGa44AjXdyB+twRakTA
	 0422Plz/iyh5nmvdLQL2E6CvEcp1HfWQraPd3tkv1VOi4oAXjNaO8M+YbRXfWP1qYF
	 iOf5vM66/Xo7fDMd3kNbtcKOcwetD4iimnXp/KLM=
Date: Sun, 16 Mar 2025 22:15:25 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,corbet@lwn.net,thomas.prescher@cyberus-technology.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-improve-parallel-huge-page-allocation-time.patch removed from -mm tree
Message-Id: <20250317051526.6EC7FC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: improve parallel huge page allocation time
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-improve-parallel-huge-page-allocation-time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Subject: mm: hugetlb: improve parallel huge page allocation time
Date: Thu, 27 Feb 2025 23:45:05 +0100

Patch series "Add a command line option that enables control of how many
threads should be used to allocate huge pages", v2.

Allocating huge pages can take a very long time on servers with terabytes
of memory even when they are allocated at boot time where the allocation
happens in parallel.

Before this series, the kernel used a hard coded value of 2 threads per
NUMA node for these allocations.  This value might have been good enough
in the past but it is not sufficient to fully utilize newer systems.

This series changes the default so the kernel uses 25% of the available
hardware threads for these allocations.  In addition, we allow the user
that wish to micro-optimize the allocation time to override this value via
a new kernel parameter.

We tested this on 2 generations of Xeon CPUs and the results show a big
improvement of the overall allocation time.

+-----------------------+-------+-------+-------+-------+-------+
| threads               |   8   |   16  |   32  |   64  |   128 |
+-----------------------+-------+-------+-------+-------+-------+
| skylake      144 cpus |   44s |   22s |   16s |   19s |   20s |
| cascade lake 192 cpus |   39s |   20s |   11s |   10s |    9s |
+-----------------------+-------+-------+-------+-------+-------+

On skylake, we see an improvment of 2.75x when using 32 threads, on
cascade lake we can get even better at 4.3x when we use 128 threads.

This speedup is quite significant and users of large machines like these
should have the option to make the machines boot as fast as possible.


This patch (of 3):

Before this patch, the kernel currently used a hard coded value of 2
threads per NUMA node for these allocations.

This patch changes this policy and the kernel now uses 25% of the
available hardware threads for the allocations.

Link: https://lkml.kernel.org/r/20250227-hugepage-parameter-v2-0-7db8c6dc0453@cyberus-technology.de
Link: https://lkml.kernel.org/r/20250227-hugepage-parameter-v2-1-7db8c6dc0453@cyberus-technology.de
Signed-off-by: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-improve-parallel-huge-page-allocation-time
+++ a/mm/hugetlb.c
@@ -14,9 +14,11 @@
 #include <linux/pagemap.h>
 #include <linux/mempolicy.h>
 #include <linux/compiler.h>
+#include <linux/cpumask.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
 #include <linux/memblock.h>
+#include <linux/minmax.h>
 #include <linux/sysfs.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
@@ -3605,31 +3607,31 @@ static unsigned long __init hugetlb_page
 		.numa_aware	= true
 	};
 
+	unsigned int num_allocation_threads = max(num_online_cpus() / 4, 1);
+
 	job.thread_fn	= hugetlb_pages_alloc_boot_node;
 	job.start	= 0;
 	job.size	= h->max_huge_pages;
 
 	/*
-	 * job.max_threads is twice the num_node_state(N_MEMORY),
+	 * job.max_threads is 25% of the available cpu threads by default.
 	 *
-	 * Tests below indicate that a multiplier of 2 significantly improves
-	 * performance, and although larger values also provide improvements,
-	 * the gains are marginal.
+	 * On large servers with terabytes of memory, huge page allocation
+	 * can consume a considerably amount of time.
 	 *
-	 * Therefore, choosing 2 as the multiplier strikes a good balance between
-	 * enhancing parallel processing capabilities and maintaining efficient
-	 * resource management.
+	 * Tests below show how long it takes to allocate 1 TiB of memory with 2MiB huge pages.
+	 * 2MiB huge pages. Using more threads can significantly improve allocation time.
 	 *
-	 * +------------+-------+-------+-------+-------+-------+
-	 * | multiplier |   1   |   2   |   3   |   4   |   5   |
-	 * +------------+-------+-------+-------+-------+-------+
-	 * | 256G 2node | 358ms | 215ms | 157ms | 134ms | 126ms |
-	 * | 2T   4node | 979ms | 679ms | 543ms | 489ms | 481ms |
-	 * | 50G  2node | 71ms  | 44ms  | 37ms  | 30ms  | 31ms  |
-	 * +------------+-------+-------+-------+-------+-------+
+	 * +-----------------------+-------+-------+-------+-------+-------+
+	 * | threads               |   8   |   16  |   32  |   64  |   128 |
+	 * +-----------------------+-------+-------+-------+-------+-------+
+	 * | skylake      144 cpus |   44s |   22s |   16s |   19s |   20s |
+	 * | cascade lake 192 cpus |   39s |   20s |   11s |   10s |    9s |
+	 * +-----------------------+-------+-------+-------+-------+-------+
 	 */
-	job.max_threads	= num_node_state(N_MEMORY) * 2;
-	job.min_chunk	= h->max_huge_pages / num_node_state(N_MEMORY) / 2;
+
+	job.max_threads	= num_allocation_threads;
+	job.min_chunk	= h->max_huge_pages / num_allocation_threads;
 	padata_do_multithreaded(&job);
 
 	return h->nr_huge_pages;
_

Patches currently in -mm which might be from thomas.prescher@cyberus-technology.de are


