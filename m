Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11BD53B
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430500; cv=none; b=to2pfzQ+23aEEDA353uiZHad8E6X2Wg1Ice4/5bvn+vQSxSK0Gbe5sdCY0led59jWXoZjevAhuH3efRhm4HFXX+2Wz3Pr4Dbcuyq/xyINhed1FqW00Qb5J3UiMcS+Xg6AB421jlmbw98fwr7jYtbZVbW9Zgp0lSY5JxNsYuqDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430500; c=relaxed/simple;
	bh=pjMJb93pTd94xSFfYAl5FGjppdpG6iL1KjYglrQW26E=;
	h=Date:To:From:Subject:Message-Id; b=n1STt/e1Y2rlGhvrx8a9QT5hxdM7dvEsKFNs1mPNfhszBBdd51PqVrqafT84HEC0GO9ok5MCJOHuNm9ywUetmocPVyciFCAfdKR6Bxmyh13JpUPulIoeyXdomOrCR1jRMlYkxOUB3wEGjgNJ2pUlq1+gpV6kBa4cITbwXeangr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FPkirYFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FPkirYFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0EEC433C7;
	Sun, 28 Jan 2024 08:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430499;
	bh=pjMJb93pTd94xSFfYAl5FGjppdpG6iL1KjYglrQW26E=;
	h=Date:To:From:Subject:From;
	b=FPkirYFe8+m7EKvfNf1U5RKdTYvWoMRCA977j1fg1wsxSjrfymXKBd4fD80QYWHBQ
	 vbDM2ciR6lWXL3nYbyxuyAqOebDKguUWvlc05omw5fonUaSCy/Cw54FpLPHAf0rl2D
	 qbKfhGqwdiDED5xuuqmqnXJtU4aLvusD2McBFWqw=
Date: Sun, 28 Jan 2024 00:28:16 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,rientjes@google.com,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,david@redhat.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch added to mm-unstable branch
Message-Id: <20240128082818.DF0EEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: parallelize 2M hugetlb allocation and initialization
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch

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
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: parallelize 2M hugetlb allocation and initialization
Date: Fri, 26 Jan 2024 23:24:10 +0800

By distributing both the allocation and the initialization tasks across
multiple threads, the initialization of 2M hugetlb will be faster, thereby
improving the boot speed.

Here are some test results:
      test case        no patch(ms)   patched(ms)   saved
 ------------------- -------------- ------------- --------
  256c2T(4 node) 2M           3336          1051   68.52%
  128c1T(2 node) 2M           1943           716   63.15%

Link: https://lkml.kernel.org/r/20240126152411.1238072-7-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
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

hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch
hugetlb-split-hugetlb_hstate_alloc_pages.patch
padata-dispatch-works-on-different-nodes.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch

