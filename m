Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DB71C11
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759102; cv=none; b=BUtPfinU1akKeuZiHT1WFADDq4niVOVWgL1QViosc/diMC/58EtwdV6L5V9tR6RgLUXcCA36UVsmdocpDBE0FuFQpiiHQqFJnpLtfg8oVzMfnuC5BaMkkuKrO8PwdWa27dCVHC7a4A37TPzo73QLrD/L6h81BBS5iIdugM1EvIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759102; c=relaxed/simple;
	bh=jYeSCFTYXRrGOvBrM/pAyURstXS+SJVZBwHDTBM8OHk=;
	h=Date:To:From:Subject:Message-Id; b=Wf4GYd+eU96MAm3q43ZokxhHBsTCSlE0Z0A7xrSzmjPqrKUIF00wikC9XLRJiMjev8xHhkl9ZPpvpD+TxOnFz6h6h8+xMN/+mko8J+PTFlK1sAaYZmcdOxuL8NxHqsDiW+35BY5aRGmVr5CkGyLPdq1QMBM3QeX2sbz50CG17wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ej+cAgvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ej+cAgvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66911C433C7;
	Wed,  6 Mar 2024 21:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759101;
	bh=jYeSCFTYXRrGOvBrM/pAyURstXS+SJVZBwHDTBM8OHk=;
	h=Date:To:From:Subject:From;
	b=Ej+cAgvgmjlZUT4lUy04Z15bH5P90rk1lEVwKScjCj315Qn4OrwUsaNupfnJ+arLz
	 kziRe2WaBeuuiiAkpc15/KxmrAiZAn1ZZZRAUchyYcKMRQzUq0TZbQM66BJgxJd6mh
	 /aPwJfQbU/2YFrmeHXES2nM83wwxBjhtxtnEk0Xk=
Date: Wed, 06 Mar 2024 13:05:00 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,steffen.klassert@secunet.com,rientjes@google.com,rdunlap@infradead.org,paulmck@kernel.org,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,jane.chu@oracle.com,david@redhat.com,daniel.m.jordan@oracle.com,adobriyan@gmail.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-parallelize-1g-hugetlb-initialization.patch removed from -mm tree
Message-Id: <20240306210501.66911C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: parallelize 1G hugetlb initialization
has been removed from the -mm tree.  Its filename was
     hugetlb-parallelize-1g-hugetlb-initialization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: parallelize 1G hugetlb initialization
Date: Thu, 22 Feb 2024 22:04:21 +0800

Optimizing the initialization speed of 1G huge pages through
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

[akpm@linux-foundation.org: s/initialied/initialized/, per Alexey]
Link: https://lkml.kernel.org/r/20240222140422.393911-9-gang.li@linux.dev
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

 arch/powerpc/mm/hugetlbpage.c |    2 -
 include/linux/hugetlb.h       |    2 -
 mm/hugetlb.c                  |   51 ++++++++++++++++++++++++++------
 3 files changed, 45 insertions(+), 10 deletions(-)

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
@@ -3404,23 +3402,25 @@ static void __init prep_and_add_bootmem_
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
+static void __init gather_bootmem_prealloc_node(unsigned long nid)
 {
 	LIST_HEAD(folio_list);
 	struct huge_bootmem_page *m;
 	struct hstate *h = NULL, *prev_h = NULL;
 
-	list_for_each_entry(m, &huge_boot_pages, list) {
+	list_for_each_entry(m, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
 
@@ -3453,6 +3453,31 @@ static void __init gather_bootmem_preall
 	prep_and_add_bootmem_folios(h, &folio_list);
 }
 
+static void __init gather_bootmem_prealloc_parallel(unsigned long start,
+						    unsigned long end, void *arg)
+{
+	int nid;
+
+	for (nid = start; nid < end; nid++)
+		gather_bootmem_prealloc_node(nid);
+}
+
+static void __init gather_bootmem_prealloc(void)
+{
+	struct padata_mt_job job = {
+		.thread_fn	= gather_bootmem_prealloc_parallel,
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
@@ -3600,6 +3625,7 @@ static unsigned long __init hugetlb_page
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long allocated;
+	static bool initialized __initdata;
 
 	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
 	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
@@ -3607,6 +3633,15 @@ static void __init hugetlb_hstate_alloc_
 		return;
 	}
 
+	/* hugetlb_hstate_alloc_pages will be called many times, initialize huge_boot_pages once */
+	if (!initialized) {
+		int i = 0;
+
+		for (i = 0; i < MAX_NUMNODES; i++)
+			INIT_LIST_HEAD(&huge_boot_pages[i]);
+		initialized = true;
+	}
+
 	/* do node specific alloc */
 	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;
_

Patches currently in -mm which might be from gang.li@linux.dev are


