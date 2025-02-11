Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25BE1E871
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 01:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739235778; cv=none; b=ek7gha5Gi9LsEUkmDV8r/tMRfPvesvTMFukMI2CU0e9VaZWoFwqaJsyK8ABvywM4eduC7SFtNnjIwKEMZWtAB6zxIglly6SvA7KGsVzc2v8Pl/Na9/DVUycJ0CekPUSnBHUM5Z+UKJzp8p7/8Zw5dKawq7LStlQVbeHihxwb9E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739235778; c=relaxed/simple;
	bh=Nvr7lYBtlydxo2gnX2WctaaG4uZebuTgjQCle8LKNsM=;
	h=Date:To:From:Subject:Message-Id; b=fMd//C+B4QfVG/hl4K7jcwR9x12FPejgw03oJxk5O9uNbRs/R4CjcjNSB9Wac1SNBUaoJJf5p8UOu4Hcj2oQaqnke8DFh7k1QlMF1MpRGTGGDOHcCckyeG1GJBU+oLAYXhaKLK9XaHHa724RLbqTJlRH8La6AzgkRXFu6vYgLcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KfhNZTHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KfhNZTHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9BAC4CED1;
	Tue, 11 Feb 2025 01:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739235776;
	bh=Nvr7lYBtlydxo2gnX2WctaaG4uZebuTgjQCle8LKNsM=;
	h=Date:To:From:Subject:From;
	b=KfhNZTHsCu0PeiIB00rrz7Fe5oHX0mxbLIArLSTpPR3ZSrQSfye4ax+l4XKiY5RFS
	 eMm7cIr5ttouJSMLjo4koslEpL/xqAYriSZAbV2eIP0kUUgcNbEmqf9AMEmpGRWFDN
	 uODPJuR2Wp/AJIpqbXnbXiAHkEKyGxuHz0bmj6CQ=
Date: Mon, 10 Feb 2025 17:02:55 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aisheng.dong@nxp.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-using-per-cma-locks-to-improve-concurrent-allocation-performance.patch added to mm-unstable branch
Message-Id: <20250211010256.3A9BAC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: using per-CMA locks to improve concurrent allocation performance
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-using-per-cma-locks-to-improve-concurrent-allocation-performance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-using-per-cma-locks-to-improve-concurrent-allocation-performance.patch

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
From: Ge Yang <yangge1116@126.com>
Subject: mm/cma: using per-CMA locks to improve concurrent allocation performance
Date: Mon, 10 Feb 2025 09:56:06 +0800

For different CMAs, concurrent allocation of CMA memory ideally should not
require synchronization using locks.  Currently, a global cma_mutex lock
is employed to synchronize all CMA allocations, which can impact the
performance of concurrent allocations across different CMAs.

To test the performance impact, follow these steps:
1. Boot the kernel with the command line argument hugetlb_cma=30G to
   allocate a 30GB CMA area specifically for huge page allocations. (note:
   on my machine, which has 3 nodes, each node is initialized with 10G of
   CMA)
2. Use the dd command with parameters if=/dev/zero of=/dev/shm/file bs=1G
   count=30 to fully utilize the CMA area by writing zeroes to a file in
   /dev/shm.
3. Open three terminals and execute the following commands simultaneously:
   (Note: Each of these commands attempts to allocate 10GB [2621440 * 4KB
   pages] of CMA memory.)
   On Terminal 1: time echo 2621440 > /sys/kernel/debug/cma/hugetlb1/alloc
   On Terminal 2: time echo 2621440 > /sys/kernel/debug/cma/hugetlb2/alloc
   On Terminal 3: time echo 2621440 > /sys/kernel/debug/cma/hugetlb3/alloc

We attempt to allocate pages through the CMA debug interface and use the
time command to measure the duration of each allocation.
Performance comparison:
             Without this patch      With this patch
Terminal1        ~7s                     ~7s
Terminal2       ~14s                     ~8s
Terminal3       ~21s                     ~7s

To solve problem above, we could use per-CMA locks to improve concurrent
allocation performance.  This would allow each CMA to be managed
independently, reducing the need for a global lock and thus improving
scalability and performance.

Link: https://lkml.kernel.org/r/1739152566-744-1-git-send-email-yangge1116@126.com
Signed-off-by: Ge Yang <yangge1116@126.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aisheng Dong <aisheng.dong@nxp.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    7 ++++---
 mm/cma.h |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/cma.c~mm-cma-using-per-cma-locks-to-improve-concurrent-allocation-performance
+++ a/mm/cma.c
@@ -34,7 +34,6 @@
 
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
-static DEFINE_MUTEX(cma_mutex);
 
 static int __init __cma_declare_contiguous_nid(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
@@ -175,6 +174,8 @@ static void __init cma_activate_area(str
 
 	spin_lock_init(&cma->lock);
 
+	mutex_init(&cma->alloc_mutex);
+
 #ifdef CONFIG_CMA_DEBUGFS
 	INIT_HLIST_HEAD(&cma->mem_head);
 	spin_lock_init(&cma->mem_head_lock);
@@ -813,9 +814,9 @@ static int cma_range_alloc(struct cma *c
 		spin_unlock_irq(&cma->lock);
 
 		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
-		mutex_lock(&cma_mutex);
+		mutex_lock(&cma->alloc_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA, gfp);
-		mutex_unlock(&cma_mutex);
+		mutex_unlock(&cma->alloc_mutex);
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
 			break;
--- a/mm/cma.h~mm-cma-using-per-cma-locks-to-improve-concurrent-allocation-performance
+++ a/mm/cma.h
@@ -39,6 +39,7 @@ struct cma {
 	unsigned long	available_count;
 	unsigned int order_per_bit; /* Order of pages represented by one bit */
 	spinlock_t	lock;
+	struct mutex alloc_mutex;
 #ifdef CONFIG_CMA_DEBUGFS
 	struct hlist_head mem_head;
 	spinlock_t mem_head_lock;
_

Patches currently in -mm which might be from yangge1116@126.com are

mm-cma-using-per-cma-locks-to-improve-concurrent-allocation-performance.patch

