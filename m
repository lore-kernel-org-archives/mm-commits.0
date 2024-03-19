Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E51B5FB91
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 22:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710885636; cv=none; b=nNZH9+nZ67Zo+F/0vIi5/KgY7Ffqv+NjC51neJ8PirBFpEBimimqUfmcsQhNsvERLaJ06IBKQ5ITQYWCyhC85zUv9/PxjKGAN6JDPFPnoP4icLD5bD9b2CWsQdFw+KGuZzq9aXPY39IuguStaBHFWBaqr1AD7p3rAf6zDVzVtvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710885636; c=relaxed/simple;
	bh=cM2phqGuCrd1SCiBaSBvdI5g0H9lWu0UcGh4Yxm2byc=;
	h=Date:To:From:Subject:Message-Id; b=IpYXXz/VIm5IOxHA+UaP7iVTPquNa8/pxfvxjiJr83hiFz7Flwj1rMuati+WwMWuwNCH/4gGOJzaxKoGIsfPHx04iYLOPofjPhc+oaxhm8i2Cv8WShmegS+dyDyOdQupzoHvAD1U+vGwsOzBfZh8GFn4Z7LapZrpa4cQ2n7VEHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SA4enxub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SA4enxub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8288C433F1;
	Tue, 19 Mar 2024 22:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710885635;
	bh=cM2phqGuCrd1SCiBaSBvdI5g0H9lWu0UcGh4Yxm2byc=;
	h=Date:To:From:Subject:From;
	b=SA4enxube6nHhVCWqd6FQiByItCZfOmOtZ8zTjaEApqAyJkAJtZbdqTAyhQ2pBKWn
	 DTnMYICwRPR/r2tmBmPz4ucKjxxNrqXnROIDqsxyn/+L8NUdy4xmNHEQJYilG2NVNr
	 Qfe6NxFKSHomaQylnAM2gciZrMgyl1ruXSVD0yU8=
Date: Tue, 19 Mar 2024 15:00:35 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,mgorman@suse.de,hughd@google.com,hannes@cmpxchg.org,feng.tang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,aneesh.kumar@kernel.org,aarcange@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch added to mm-unstable branch
Message-Id: <20240319220035.A8288C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: use numa_node_id() instead of cpu_to_node()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm/mempolicy: use numa_node_id() instead of cpu_to_node()
Date: Fri, 8 Mar 2024 09:15:37 -0600

Patch series "Allow migrate on protnone reference with MPOL_PREFERRED_MANY
policy:, v2.

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
 mm/mempolicy.c            |   12 +++++++++---
 5 files changed, 19 insertions(+), 10 deletions(-)

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
@@ -1732,7 +1732,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
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

mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch
mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

