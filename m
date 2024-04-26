Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592633C2F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103871; cv=none; b=igHzTOv44aViKJI0icm4vTaQJV0fbo/JoxWAGTAxPBttDhVJI47QmcbwVzoWID4d4u42YuIUknd9Vx03KibSuH8rcXj9JvRNji54Be/38elVh1TFkniLBceb99LCVP1WVslN/4M2RSb28DCUm3LKsHOOa2ReDk637AcmZUaI2qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103871; c=relaxed/simple;
	bh=gCYvjFW2mOMJBToM7b6G7AOlkH1qwdyFOR8VjtIE6Ko=;
	h=Date:To:From:Subject:Message-Id; b=YwkHoO78aHJgSw5YMLfckpc/RkboKUcYGxVMxtHE3z7wJLK6KS6bmMXeDrpuzefW57AMqkYaiMF65XTZjGiH0zQ9EzehXRwc6Br/W3UC/iiwnt3ROxiQjEnUouo333exqIotRZ+MPz+qzkiiksM2mv5oNGwG6WSsPpkLrrjHMIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lx5GMZrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lx5GMZrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30238C113CD;
	Fri, 26 Apr 2024 03:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103871;
	bh=gCYvjFW2mOMJBToM7b6G7AOlkH1qwdyFOR8VjtIE6Ko=;
	h=Date:To:From:Subject:From;
	b=lx5GMZrDntWmSVTir9pVZhs79Mq9q/k9pBjgyfUy/RJxxLdyLXpQA62t8NNWd4R6T
	 JTuClX1Xjdo17YRCj8lKNiRcpAXOi4EUePSKCs7DxAfaENWpipuRRDf86d+3XBKyxg
	 lK4KZ8p4Re68WHtuII78Ee9u3bTG/0ui8jAjQSEI=
Date: Thu, 25 Apr 2024 20:57:50 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,hughd@google.com,hannes@cmpxchg.org,feng.tang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,aneesh.kumar@kernel.org,aarcange@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch removed from -mm tree
Message-Id: <20240426035751.30238C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: use numa_node_id() instead of cpu_to_node()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm/mempolicy: use numa_node_id() instead of cpu_to_node()
Date: Fri, 8 Mar 2024 09:15:37 -0600

Patch series "Allow migrate on protnone reference with MPOL_PREFERRED_MANY
policy:, v4.

This patchset is to optimize the cross-socket memory access with
MPOL_PREFERRED_MANY policy.

To test this patch we ran the following test on a 3 node system.
 Node 0 - 2GB   - Tier 1
 Node 1 - 11GB  - Tier 1
 Node 6 - 10GB  - Tier 2

Below changes are made to memcached to set the memory policy,
It select Node0 and Node1 as preferred nodes.

   #include <numaif.h>
   #include <numa.h>

    unsigned long nodemask;
    int ret;

    nodemask = 0x03;
    ret = set_mempolicy(MPOL_PREFERRED_MANY | MPOL_F_NUMA_BALANCING,
                                               &nodemask, 10);
    /* If MPOL_F_NUMA_BALANCING isn't supported,
     * fall back to MPOL_PREFERRED_MANY */
    if (ret < 0 && errno == EINVAL){
       printf("set mem policy normal\n");
        ret = set_mempolicy(MPOL_PREFERRED_MANY, &nodemask, 10);
    }
    if (ret < 0) {
       perror("Failed to call set_mempolicy");
       exit(-1);
    }

Test Procedure:
===============
1. Make sure memory tiring and demotion are enabled.
2. Start memcached.

   # ./memcached -b 100000 -m 204800 -u root -c 1000000 -t 7
       -d -s "/tmp/memcached.sock"

3. Run memtier_benchmark to store 3200000 keys.

  #./memtier_benchmark -S "/tmp/memcached.sock" --protocol=memcache_binary
    --threads=1 --pipeline=1 --ratio=1:0 --key-pattern=S:S --key-minimum=1
    --key-maximum=3200000 -n allkeys -c 1 -R -x 1 -d 1024

4. Start a memory eater on node 0 and 1. This will demote all memcached
   pages to node 6.
5. Make sure all the memcached pages got demoted to lower tier by reading
   /proc/<memcaced PID>/numa_maps.

    # cat /proc/2771/numa_maps
     ---
    default anon=1009 dirty=1009 active=0 N6=1009 kernelpagesize_kB=64
    default anon=1009 dirty=1009 active=0 N6=1009 kernelpagesize_kB=64
     ---

6. Kill memory eater.
7. Read the pgpromote_success counter.
8. Start reading the keys by running memtier_benchmark.

  #./memtier_benchmark -S "/tmp/memcached.sock" --protocol=memcache_binary
   --pipeline=1 --distinct-client-seed --ratio=0:3 --key-pattern=R:R
   --key-minimum=1 --key-maximum=3200000 -n allkeys
   --threads=64 -c 1 -R -x 6

9. Read the pgpromote_success counter.

Test Results:
=============
Without Patch
------------------
1. pgpromote_success  before test
Node 0:  pgpromote_success 11
Node 1:  pgpromote_success 140974

pgpromote_success  after test
Node 0:  pgpromote_success 11
Node 1:  pgpromote_success 140974

2. Memtier-benchmark result.
AGGREGATED AVERAGE RESULTS (6 runs)
==================================================================
Type    Ops/sec   Hits/sec   Misses/sec  Avg. Latency  p50 Latency
------------------------------------------------------------------
Sets     0.00       ---         ---        ---          ---
Gets    305792.03  305791.93   0.10       0.18949       0.16700
Waits    0.00       ---         ---        ---          ---
Totals  305792.03  305791.93   0.10       0.18949       0.16700

======================================
p99 Latency  p99.9 Latency  KB/sec
-------------------------------------
---          ---            0.00
0.44700     1.71100        11542.69
---           ---            ---
0.44700     1.71100        11542.69

With Patch
---------------
1. pgpromote_success  before test
Node 0:  pgpromote_success 5
Node 1:  pgpromote_success 89386

pgpromote_success  after test
Node 0:  pgpromote_success 57895
Node 1:  pgpromote_success 141463

2. Memtier-benchmark result.
AGGREGATED AVERAGE RESULTS (6 runs)
====================================================================
Type    Ops/sec    Hits/sec  Misses/sec  Avg. Latency  p50 Latency
--------------------------------------------------------------------
Sets     0.00        ---       ---        ---           ---
Gets    521942.24  521942.07  0.17       0.11459        0.10300
Waits    0.00        ---       ---         ---          ---
Totals  521942.24  521942.07  0.17       0.11459        0.10300

=======================================
p99 Latency  p99.9 Latency  KB/sec
---------------------------------------
 ---          ---            0.00
0.23100      0.31900        19701.68
---          ---             ---
0.23100      0.31900        19701.68


Test Result Analysis:
=====================
1. With patch we could observe pages are getting promoted.
2. Memtier-benchmark results shows that, with the patch,
   performance has increased more than 50%.

 Ops/sec without fix -  305792.03
 Ops/sec with fix    -  521942.24


This patch (of 2):

Instead of using 'cpu_to_node()', we use 'numa_node_id()', which is
quicker.  smp_processor_id is guaranteed to be stable in the
'mpol_misplaced()' function because it is called with ptl held. 
lockdep_assert_held was added to ensure that.

No functional change in this patch.

[donettom@linux.ibm.com: add "* @vmf: structure describing the fault" comment]
  Link: https://lkml.kernel.org/r/d8b993ea9dccfac0bc3ed61d3a81f4ac5f376e46.1711002865.git.donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/cover.1711373653.git.donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/6059f034f436734b472d066db69676fb3a459864.1711373653.git.donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/cover.1709909210.git.donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/744646531af02cc687cde8ae788fb1779e99d02c.1709909210.git.donettom@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    5 +++--
 mm/huge_memory.c          |    2 +-
 mm/internal.h             |    2 +-
 mm/memory.c               |    8 +++++---
 mm/mempolicy.c            |   14 ++++++++++----
 5 files changed, 20 insertions(+), 11 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node
+++ a/include/linux/mempolicy.h
@@ -167,7 +167,8 @@ extern void mpol_to_str(char *buffer, in
 /* Check if a vma is migratable */
 extern bool vma_migratable(struct vm_area_struct *vma);
 
-int mpol_misplaced(struct folio *, struct vm_area_struct *, unsigned long);
+int mpol_misplaced(struct folio *folio, struct vm_fault *vmf,
+					unsigned long addr);
 extern void mpol_put_task_policy(struct task_struct *);
 
 static inline bool mpol_is_preferred_many(struct mempolicy *pol)
@@ -282,7 +283,7 @@ static inline int mpol_parse_str(char *s
 #endif
 
 static inline int mpol_misplaced(struct folio *folio,
-				 struct vm_area_struct *vma,
+				 struct vm_fault *vmf,
 				 unsigned long address)
 {
 	return -1; /* no node preference */
--- a/mm/huge_memory.c~mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node
+++ a/mm/huge_memory.c
@@ -1754,7 +1754,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	 */
 	if (node_is_toptier(nid))
 		last_cpupid = folio_last_cpupid(folio);
-	target_nid = numa_migrate_prep(folio, vma, haddr, nid, &flags);
+	target_nid = numa_migrate_prep(folio, vmf, haddr, nid, &flags);
 	if (target_nid == NUMA_NO_NODE) {
 		folio_put(folio);
 		goto out_map;
--- a/mm/internal.h~mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node
+++ a/mm/internal.h
@@ -1087,7 +1087,7 @@ void vunmap_range_noflush(unsigned long
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
-int numa_migrate_prep(struct folio *folio, struct vm_area_struct *vma,
+int numa_migrate_prep(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int page_nid, int *flags);
 
 void free_zone_device_page(struct page *page);
--- a/mm/memory.c~mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node
+++ a/mm/memory.c
@@ -5035,9 +5035,11 @@ static vm_fault_t do_fault(struct vm_fau
 	return ret;
 }
 
-int numa_migrate_prep(struct folio *folio, struct vm_area_struct *vma,
+int numa_migrate_prep(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int page_nid, int *flags)
 {
+	struct vm_area_struct *vma = vmf->vma;
+
 	folio_get(folio);
 
 	/* Record the current PID acceesing VMA */
@@ -5049,7 +5051,7 @@ int numa_migrate_prep(struct folio *foli
 		*flags |= TNF_FAULT_LOCAL;
 	}
 
-	return mpol_misplaced(folio, vma, addr);
+	return mpol_misplaced(folio, vmf, addr);
 }
 
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
@@ -5123,7 +5125,7 @@ static vm_fault_t do_numa_page(struct vm
 		last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
 		last_cpupid = folio_last_cpupid(folio);
-	target_nid = numa_migrate_prep(folio, vma, vmf->address, nid, &flags);
+	target_nid = numa_migrate_prep(folio, vmf, vmf->address, nid, &flags);
 	if (target_nid == NUMA_NO_NODE) {
 		folio_put(folio);
 		goto out_map;
--- a/mm/mempolicy.c~mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node
+++ a/mm/mempolicy.c
@@ -2718,7 +2718,7 @@ static void sp_free(struct sp_node *n)
  * mpol_misplaced - check whether current folio node is valid in policy
  *
  * @folio: folio to be checked
- * @vma: vm area where folio mapped
+ * @vmf: structure describing the fault
  * @addr: virtual address in @vma for shared policy lookup and interleave policy
  *
  * Lookup current policy node id for vma,addr and "compare to" folio's
@@ -2728,18 +2728,24 @@ static void sp_free(struct sp_node *n)
  * Return: NUMA_NO_NODE if the page is in a node that is valid for this
  * policy, or a suitable node ID to allocate a replacement folio from.
  */
-int mpol_misplaced(struct folio *folio, struct vm_area_struct *vma,
+int mpol_misplaced(struct folio *folio, struct vm_fault *vmf,
 		   unsigned long addr)
 {
 	struct mempolicy *pol;
 	pgoff_t ilx;
 	struct zoneref *z;
 	int curnid = folio_nid(folio);
+	struct vm_area_struct *vma = vmf->vma;
 	int thiscpu = raw_smp_processor_id();
-	int thisnid = cpu_to_node(thiscpu);
+	int thisnid = numa_node_id();
 	int polnid = NUMA_NO_NODE;
 	int ret = NUMA_NO_NODE;
 
+	/*
+	 * Make sure ptl is held so that we don't preempt and we
+	 * have a stable smp processor id
+	 */
+	lockdep_assert_held(vmf->ptl);
 	pol = get_vma_policy(vma, addr, folio_order(folio), &ilx);
 	if (!(pol->flags & MPOL_F_MOF))
 		goto out;
@@ -2781,7 +2787,7 @@ int mpol_misplaced(struct folio *folio,
 		if (node_isset(curnid, pol->nodes))
 			goto out;
 		z = first_zones_zonelist(
-				node_zonelist(numa_node_id(), GFP_HIGHUSER),
+				node_zonelist(thisnid, GFP_HIGHUSER),
 				gfp_zone(GFP_HIGHUSER),
 				&pol->nodes);
 		polnid = zone_to_nid(z->zone);
_

Patches currently in -mm which might be from donettom@linux.ibm.com are


