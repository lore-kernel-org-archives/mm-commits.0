Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55E11C11
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759100; cv=none; b=YjbwpXHTX/jjc+TGGxXkuZTDTpLqzPuIVDrGghNly7xWDFDf3bOvpHxX2pUXniC8UA+a9wb5UCTpS6/rlknBxoF/MdswY45LmcST8CZmAZeXevn6LrO0z4yrrNFiaEAyEARMmWwM/nWCubtpsPM24gTWg1DqnZfo8LlVLPLJW5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759100; c=relaxed/simple;
	bh=Oo9tTlqSP9GRDiWZjUA7tAzBvZNNc58aPeAY0qjc7JI=;
	h=Date:To:From:Subject:Message-Id; b=k9GkfPfzZkRlJ4Zno+5060xPhNHqxE6z6xcKkYM4pqKgJMbN0rcTqP1DK5iaLDVAKbiwlGF/8D5+YVlMoEW4F9h3qx2P9Z8wzYXRunos5/SCIpLfmki7ix08N9dwy5ekJvTVg75tsoLzaXPgtiOK9mq6HObUnbE0JIsQBV9gXH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dZUNAjDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dZUNAjDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C25C433C7;
	Wed,  6 Mar 2024 21:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759100;
	bh=Oo9tTlqSP9GRDiWZjUA7tAzBvZNNc58aPeAY0qjc7JI=;
	h=Date:To:From:Subject:From;
	b=dZUNAjDhbTAhzHtWGj13EVARSi2exTMEvYTRAsH5HIQ0mRqgsBZxZwT6RJDrl22dt
	 B1DfaSj35f9f0aFix6dlFMg0llZW0jOcm9fuwk6kRk1ODeB+sgamj/3+KK8VSeR5xS
	 ZVYYsz3H7luITi3MLdD6ROSOEuiZH/vFsadSRAJo=
Date: Wed, 06 Mar 2024 13:04:59 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,steffen.klassert@secunet.com,rientjes@google.com,rdunlap@infradead.org,paulmck@kernel.org,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,jane.chu@oracle.com,david@redhat.com,daniel.m.jordan@oracle.com,adobriyan@gmail.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch removed from -mm tree
Message-Id: <20240306210500.65C25C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: parallelize 2M hugetlb allocation and initialization
has been removed from the -mm tree.  Its filename was
     hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: parallelize 2M hugetlb allocation and initialization
Date: Thu, 22 Feb 2024 22:04:20 +0800

By distributing both the allocation and the initialization tasks across
multiple threads, the initialization of 2M hugetlb will be faster, thereby
improving the boot speed.

Here are some test results:
      test case        no patch(ms)   patched(ms)   saved
 ------------------- -------------- ------------- --------
  256c2T(4 node) 2M           3336          1051   68.52%
  128c1T(2 node) 2M           1943           716   63.15%

Link: https://lkml.kernel.org/r/20240222140422.393911-8-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   75 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 57 insertions(+), 18 deletions(-)

--- a/mm/hugetlb.c~hugetlb-parallelize-2m-hugetlb-allocation-and-initialization
+++ a/mm/hugetlb.c
@@ -35,6 +35,7 @@
 #include <linux/delayacct.h>
 #include <linux/memory.h>
 #include <linux/mm_inline.h>
+#include <linux/padata.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -3510,43 +3511,81 @@ static void __init hugetlb_hstate_alloc_
 	}
 }
 
-static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
+static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned long end, void *arg)
 {
-	unsigned long i;
+	struct hstate *h = (struct hstate *)arg;
+	int i, num = end - start;
+	nodemask_t node_alloc_noretry;
+	LIST_HEAD(folio_list);
+	int next_node = first_online_node;
 
-	for (i = 0; i < h->max_huge_pages; ++i) {
-		if (!alloc_bootmem_huge_page(h, NUMA_NO_NODE))
+	/* Bit mask controlling how hard we retry per-node allocations.*/
+	nodes_clear(node_alloc_noretry);
+
+	for (i = 0; i < num; ++i) {
+		struct folio *folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
+						&node_alloc_noretry, &next_node);
+		if (!folio)
 			break;
+
+		list_move(&folio->lru, &folio_list);
 		cond_resched();
 	}
 
-	return i;
+	prep_and_add_allocated_folios(h, &folio_list);
 }
 
-static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
+static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
 {
 	unsigned long i;
-	struct folio *folio;
-	LIST_HEAD(folio_list);
-	nodemask_t node_alloc_noretry;
-
-	/* Bit mask controlling how hard we retry per-node allocations.*/
-	nodes_clear(node_alloc_noretry);
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
-		folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
-						&node_alloc_noretry);
-		if (!folio)
+		if (!alloc_bootmem_huge_page(h, NUMA_NO_NODE))
 			break;
-		list_add(&folio->lru, &folio_list);
 		cond_resched();
 	}
 
-	prep_and_add_allocated_folios(h, &folio_list);
-
 	return i;
 }
 
+static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
+{
+	struct padata_mt_job job = {
+		.fn_arg		= h,
+		.align		= 1,
+		.numa_aware	= true
+	};
+
+	job.thread_fn	= hugetlb_pages_alloc_boot_node;
+	job.start	= 0;
+	job.size	= h->max_huge_pages;
+
+	/*
+	 * job.max_threads is twice the num_node_state(N_MEMORY),
+	 *
+	 * Tests below indicate that a multiplier of 2 significantly improves
+	 * performance, and although larger values also provide improvements,
+	 * the gains are marginal.
+	 *
+	 * Therefore, choosing 2 as the multiplier strikes a good balance between
+	 * enhancing parallel processing capabilities and maintaining efficient
+	 * resource management.
+	 *
+	 * +------------+-------+-------+-------+-------+-------+
+	 * | multiplier |   1   |   2   |   3   |   4   |   5   |
+	 * +------------+-------+-------+-------+-------+-------+
+	 * | 256G 2node | 358ms | 215ms | 157ms | 134ms | 126ms |
+	 * | 2T   4node | 979ms | 679ms | 543ms | 489ms | 481ms |
+	 * | 50G  2node | 71ms  | 44ms  | 37ms  | 30ms  | 31ms  |
+	 * +------------+-------+-------+-------+-------+-------+
+	 */
+	job.max_threads	= num_node_state(N_MEMORY) * 2;
+	job.min_chunk	= h->max_huge_pages / num_node_state(N_MEMORY) / 2;
+	padata_do_multithreaded(&job);
+
+	return h->nr_huge_pages;
+}
+
 /*
  * NOTE: this routine is called in different contexts for gigantic and
  * non-gigantic pages.
_

Patches currently in -mm which might be from gang.li@linux.dev are


