From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-deferred-inits-max-threads-arch-specific.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:18:45 -0700
Message-ID: <20200604171845.27Az1hQUJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730053AbgFDRSr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, alexander.h.duyck@linux.intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com, david@redhat.com, elliott@hpe.com, herbert@gondor.apana.org.au, jgg@ziepe.ca, josh@joshtriplett.org, ktkhai@virtuozzo.com, mhocko@kernel.org, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, pavel@ucw.cz, peterz@infradead.org, rdunlap@infradead.org, shile.zhang@linux.alibaba.com, steffen.klassert@secunet.com, steven.sistare@oracle.com, tj@kernel.org, ziy@nvidia.com


The patch titled
     Subject: mm: make deferred init's max threads arch-specific
has been removed from the -mm tree.  Its filename was
     mm-make-deferred-inits-max-threads-arch-specific.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: mm: make deferred init's max threads arch-specific

Using padata during deferred init has only been tested on x86, so for now
limit it to this architecture.

If another arch wants this, it can find the max thread limit that's best
for it and override deferred_page_init_max_threads().

Link: http://lkml.kernel.org/r/20200527173608.2885243-8-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Tested-by: Josh Triplett <josh@joshtriplett.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Robert Elliott <elliott@hpe.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c    |   12 ++++++++++++
 include/linux/memblock.h |    3 +++
 mm/page_alloc.c          |   13 ++++++++-----
 3 files changed, 23 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/init_64.c~mm-make-deferred-inits-max-threads-arch-specific
+++ a/arch/x86/mm/init_64.c
@@ -1265,6 +1265,18 @@ void __init mem_init(void)
 	mem_init_print_info(NULL);
 }
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+int __init deferred_page_init_max_threads(const struct cpumask *node_cpumask)
+{
+	/*
+	 * More CPUs always led to greater speedups on tested systems, up to
+	 * all the nodes' CPUs.  Use all since the system is otherwise idle
+	 * now.
+	 */
+	return max_t(int, cpumask_weight(node_cpumask), 1);
+}
+#endif
+
 int kernel_set_to_readonly;
 
 void mark_rodata_ro(void)
--- a/include/linux/memblock.h~mm-make-deferred-inits-max-threads-arch-specific
+++ a/include/linux/memblock.h
@@ -273,6 +273,9 @@ void __next_mem_pfn_range_in_zone(u64 *i
 #define for_each_free_mem_pfn_range_in_zone_from(i, zone, p_start, p_end) \
 	for (; i != U64_MAX;					  \
 	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
+
+int __init deferred_page_init_max_threads(const struct cpumask *node_cpumask);
+
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 /**
--- a/mm/page_alloc.c~mm-make-deferred-inits-max-threads-arch-specific
+++ a/mm/page_alloc.c
@@ -1836,6 +1836,13 @@ deferred_init_memmap_chunk(unsigned long
 	}
 }
 
+/* An arch may override for more concurrency. */
+__weak int __init
+deferred_page_init_max_threads(const struct cpumask *node_cpumask)
+{
+	return 1;
+}
+
 /* Initialise remaining memory on a node */
 static int __init deferred_init_memmap(void *data)
 {
@@ -1884,11 +1891,7 @@ static int __init deferred_init_memmap(v
 						 first_init_pfn))
 		goto zone_empty;
 
-	/*
-	 * More CPUs always led to greater speedups on tested systems, up to
-	 * all the nodes' CPUs.  Use all since the system is otherwise idle now.
-	 */
-	max_threads = max(cpumask_weight(cpumask), 1u);
+	max_threads = deferred_page_init_max_threads(cpumask);
 
 	while (spfn < epfn) {
 		unsigned long epfn_align = ALIGN(epfn, PAGES_PER_SECTION);
_

Patches currently in -mm which might be from daniel.m.jordan@oracle.com are
