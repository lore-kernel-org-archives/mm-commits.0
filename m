Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E88CD52A
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430504; cv=none; b=YYRZatSxMK4fi9pcTKaM761SsOmSmmWibzwK3lck0idpmVvt1W9P/K9Ie55aVxFnbsaUSq3ZuUqfpMZ8FBWAFf89TnUd03wvMTUtH2/HiRkhtSGKphPvX6+ExzLU/4UogmRyt6jLMs39te7Bh6IzK+ykQ4Tx62g18w4Sybj8B1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430504; c=relaxed/simple;
	bh=hV1rimHOXtWbwfJH+gMTW3uCSj80Y9PABkZZbnpH8Gs=;
	h=Date:To:From:Subject:Message-Id; b=g3T+Nfat5kP+v0CXEcJj8D3fLZ1S4f2x4GxV9VyiyCrFF4qDWzKRM0vsSsRvQHe+9KTKeRodzanrpRgYnUPWgRar/5suUmoEw/DF2jpTMyzGZfSdO+O8o0O2V/aKfbWFf1fQKqOPliwkJrthRoMV4sTQ7LuiHLyXJEejTokOVWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f8E92MEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f8E92MEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D15C433C7;
	Sun, 28 Jan 2024 08:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430503;
	bh=hV1rimHOXtWbwfJH+gMTW3uCSj80Y9PABkZZbnpH8Gs=;
	h=Date:To:From:Subject:From;
	b=f8E92MEE1d0t3FL9LalMdXTeyrYeRyYI2ZDYagNkyG2FiyG23m9vKYUcuDJePbDQQ
	 oLBCwC/lyZySED9J/D0T9FfjWVV8qh7bY+8aclPBRhQVBwQuS5/5KfUBTDF3ousw14
	 kXwsoC8uPz14Ka2crt0VW/cn98YCalc4lHxwW+24=
Date: Sun, 28 Jan 2024 00:28:20 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,rientjes@google.com,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,david@redhat.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-parallelize-1g-hugetlb-initialization.patch added to mm-unstable branch
Message-Id: <20240128082823.22D15C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: parallelize 1G hugetlb initialization
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-parallelize-1g-hugetlb-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-parallelize-1g-hugetlb-initialization.patch

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
Subject: hugetlb: parallelize 1G hugetlb initialization
Date: Fri, 26 Jan 2024 23:24:11 +0800

Optimize the initialization speed of 1G huge pages through
parallelization.

1G hugetlbs are allocated from bootmem, a process that is already very
fast and does not currently require optimization.  Therefore, we focus on
parallelizing only the initialization phase in `gather_bootmem_prealloc`.

Here are some test results:
      test case       no patch(ms)   patched(ms)   saved
 ------------------- -------------- ------------- --------
  256c2T(4 node) 1G           4745          2024   57.34%
  128c1T(2 node) 1G           3358          1712   49.02%
     12T         1G          77000         18300   76.23%

Link: https://lkml.kernel.org/r/20240126152411.1238072-8-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    2 -
 include/linux/hugetlb.h       |    2 -
 mm/hugetlb.c                  |   44 ++++++++++++++++++++++++++------
 3 files changed, 38 insertions(+), 10 deletions(-)

--- a/arch/powerpc/mm/hugetlbpage.c~hugetlb-parallelize-1g-hugetlb-initialization
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -226,7 +226,7 @@ static int __init pseries_alloc_bootmem_
 		return 0;
 	m = phys_to_virt(gpage_freearray[--nr_gpages]);
 	gpage_freearray[nr_gpages] = 0;
-	list_add(&m->list, &huge_boot_pages);
+	list_add(&m->list, &huge_boot_pages[0]);
 	m->hstate = hstate;
 	return 1;
 }
--- a/include/linux/hugetlb.h~hugetlb-parallelize-1g-hugetlb-initialization
+++ a/include/linux/hugetlb.h
@@ -178,7 +178,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage);
 
 extern int sysctl_hugetlb_shm_group;
-extern struct list_head huge_boot_pages;
+extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 /* arch callbacks */
 
--- a/mm/hugetlb.c~hugetlb-parallelize-1g-hugetlb-initialization
+++ a/mm/hugetlb.c
@@ -69,7 +69,7 @@ static bool hugetlb_cma_folio(struct fol
 #endif
 static unsigned long hugetlb_cma_size __initdata;
 
-__initdata LIST_HEAD(huge_boot_pages);
+__initdata struct list_head huge_boot_pages[MAX_NUMNODES];
 
 /* for command line parsing */
 static struct hstate * __initdata parsed_hstate;
@@ -3301,7 +3301,7 @@ int alloc_bootmem_huge_page(struct hstat
 int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 {
 	struct huge_bootmem_page *m = NULL; /* initialize for clang */
-	int nr_nodes, node;
+	int nr_nodes, node = nid;
 
 	/* do node specific alloc */
 	if (nid != NUMA_NO_NODE) {
@@ -3339,7 +3339,7 @@ found:
 		huge_page_size(h) - PAGE_SIZE);
 	/* Put them into a private list first because mem_map is not up yet */
 	INIT_LIST_HEAD(&m->list);
-	list_add(&m->list, &huge_boot_pages);
+	list_add(&m->list, &huge_boot_pages[node]);
 	m->hstate = h;
 	return 1;
 }
@@ -3390,8 +3390,6 @@ static void __init prep_and_add_bootmem_
 	/* Send list for bulk vmemmap optimization processing */
 	hugetlb_vmemmap_optimize_folios(h, folio_list);
 
-	/* Add all new pool pages to free lists in one lock cycle */
-	spin_lock_irqsave(&hugetlb_lock, flags);
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
 		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
 			/*
@@ -3404,23 +3402,27 @@ static void __init prep_and_add_bootmem_
 					HUGETLB_VMEMMAP_RESERVE_PAGES,
 					pages_per_huge_page(h));
 		}
+		/* Subdivide locks to achieve better parallel performance */
+		spin_lock_irqsave(&hugetlb_lock, flags);
 		__prep_account_new_huge_page(h, folio_nid(folio));
 		enqueue_hugetlb_folio(h, folio);
+		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
-	spin_unlock_irqrestore(&hugetlb_lock, flags);
 }
 
 /*
  * Put bootmem huge pages into the standard lists after mem_map is up.
  * Note: This only applies to gigantic (order > MAX_PAGE_ORDER) pages.
  */
-static void __init gather_bootmem_prealloc(void)
+static void __init gather_bootmem_prealloc_node(unsigned long start, unsigned long end, void *arg)
+
 {
+	int nid = start;
 	LIST_HEAD(folio_list);
 	struct huge_bootmem_page *m;
 	struct hstate *h = NULL, *prev_h = NULL;
 
-	list_for_each_entry(m, &huge_boot_pages, list) {
+	list_for_each_entry(m, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
 
@@ -3453,6 +3455,22 @@ static void __init gather_bootmem_preall
 	prep_and_add_bootmem_folios(h, &folio_list);
 }
 
+static void __init gather_bootmem_prealloc(void)
+{
+	struct padata_mt_job job = {
+		.thread_fn	= gather_bootmem_prealloc_node,
+		.fn_arg		= NULL,
+		.start		= 0,
+		.size		= num_node_state(N_MEMORY),
+		.align		= 1,
+		.min_chunk	= 1,
+		.max_threads	= num_node_state(N_MEMORY),
+		.numa_aware	= true,
+	};
+
+	padata_do_multithreaded(&job);
+}
+
 static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 {
 	unsigned long i;
@@ -3600,6 +3618,7 @@ static unsigned long __init hugetlb_page
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long allocated;
+	static bool initialied __initdata;
 
 	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
 	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
@@ -3607,6 +3626,15 @@ static void __init hugetlb_hstate_alloc_
 		return;
 	}
 
+	/* hugetlb_hstate_alloc_pages will be called many times, initialize huge_boot_pages once */
+	if (!initialied) {
+		int i = 0;
+
+		for (i = 0; i < MAX_NUMNODES; i++)
+			INIT_LIST_HEAD(&huge_boot_pages[i]);
+		initialied = true;
+	}
+
 	/* do node specific alloc */
 	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;
_

Patches currently in -mm which might be from gang.li@linux.dev are

hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch
hugetlb-split-hugetlb_hstate_alloc_pages.patch
padata-dispatch-works-on-different-nodes.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch

