Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8707E273FE
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741063935; cv=none; b=UnFZr9o8zvu1YHsh6YhNaqxpYr9dSi+4W/tY3mD3qlMf2VSV9EiiBi+uePFQdzbCk3k1t3ijTT+BlLN7dV8dKBbwExa4tObRaF2CftSvgpw6PP+gHBGR1r4wxau2GWBZ7SdZPq3HBeeJrvxbkOdErvVeFtPj1Z78iWNetsvEh2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741063935; c=relaxed/simple;
	bh=CnmOw9SwKPD/RzzeVfcaa/IdCVM1HnoDMZNxWAs8evw=;
	h=Date:To:From:Subject:Message-Id; b=iJIXkyDQlhB1MmaR0Q2Mgo+NtxwAc4o+lKrOhLd9v7Txs6ZM82iFE4G2ihBvK8r5zDtSWKoYKV+gCeVrStwzpUJS9TIsYUw3QJNvbopXyHGFho4tz/0/vX4mZj8PNUskmCCNP8yHr+rsb8FGahjO/7wfkF8p93AGHgXap1v6VLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZZZz+MtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZZZz+MtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8909C4CEE5;
	Tue,  4 Mar 2025 04:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741063935;
	bh=CnmOw9SwKPD/RzzeVfcaa/IdCVM1HnoDMZNxWAs8evw=;
	h=Date:To:From:Subject:From;
	b=ZZZz+MtH3EB1dcp0AjFb6UzWf8GcfhWGvmxk9a2GEB/a8v5Z/Q0KMwwbtSN5gtIQa
	 Ng/0kEDw4PUt5jOLdXKff4rG1OIqcWC0RdHLBK/m/3BtFl/PTG6bUSlq9NXSU9M8Jv
	 iOJ/2AAISsyL7aIj/fy+1Ke0tcCZxQdfHy/XiaFI=
Date: Mon, 03 Mar 2025 20:52:14 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,corbet@lwn.net,thomas.prescher@cyberus-technology.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-improve-parallel-huge-page-allocation-time.patch added to mm-unstable branch
Message-Id: <20250304045214.E8909C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: improve parallel huge page allocation time
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-improve-parallel-huge-page-allocation-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-improve-parallel-huge-page-allocation-time.patch

This patch will later appear in the mm-unstable branch at
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
@@ -3600,31 +3602,31 @@ static unsigned long __init hugetlb_page
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

mm-hugetlb-improve-parallel-huge-page-allocation-time.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch
mm-hugetlb-log-time-needed-to-allocate-hugepages.patch

