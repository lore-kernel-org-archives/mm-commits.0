From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-parallelize-deferred_init_memmap.patch added to -mm
 tree
Date: Wed, 20 May 2020 16:31:30 -0700
Message-ID: <20200520233130.ZjhUFKJod%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbgETXbd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 19:31:33 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@redhat.com, alexander.h.duyck@linux.intel.com, corbet@lwn.net, dan.j.williams@intel.com, daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com, david@redhat.com, elliott@hpe.com, herbert@gondor.apana.org.au, jgg@ziepe.ca, josh@joshtriplett.org, ktkhai@virtuozzo.com, mhocko@kernel.org, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, pavel@ucw.cz, peterz@infradead.org, rdunlap@infradead.org, shile.zhang@linux.alibaba.com, steffen.klassert@secunet.com, steven.sistare@oracle.com, tj@kernel.org, ziy@nvidia.com


The patch titled
     Subject: mm: parallelize deferred_init_memmap()
has been added to the -mm tree.  Its filename is
     mm-parallelize-deferred_init_memmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-parallelize-deferred_init_memmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-parallelize-deferred_init_memmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: mm: parallelize deferred_init_memmap()

Deferred struct page init is a significant bottleneck in kernel boot. 
Optimizing it maximizes availability for large-memory systems and allows
spinning up short-lived VMs as needed without having to leave them
running.  It also benefits bare metal machines hosting VMs that are
sensitive to downtime.  In projects such as VMM Fast Restart[1], where
guest state is preserved across kexec reboot, it helps prevent application
and network timeouts in the guests.

Multithread to take full advantage of system memory bandwidth.

The maximum number of threads is capped at the number of CPUs on the node
because speedups always improve with additional threads on every system
tested, and at this phase of boot, the system is otherwise idle and
waiting on page init to finish.

Helper threads operate on section-aligned ranges to both avoid false
sharing when setting the pageblock's migrate type and to avoid accessing
uninitialized buddy pages, though max order alignment is enough for the
latter.

The minimum chunk size is also a section.  There was benefit to using
multiple threads even on relatively small memory (1G) systems, and this is
the smallest size that the alignment allows.

The time (milliseconds) is the slowest node to initialize since boot
blocks until all nodes finish.  intel_pstate is loaded in active mode
without hwp and with turbo enabled, and intel_idle is active as well.

    Intel(R) Xeon(R) Platinum 8167M CPU @ 2.00GHz (Skylake, bare metal)
      2 nodes * 26 cores * 2 threads = 104 CPUs
      384G/node = 768G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   4078.0 (  9.0)         --   1779.0 (  8.7)
       2% (  1)       1.4%   4021.3 (  2.9)       3.4%   1717.7 (  7.8)
      12% (  6)      35.1%   2644.7 ( 35.3)      80.8%    341.0 ( 35.5)
      25% ( 13)      38.7%   2498.0 ( 34.2)      89.1%    193.3 ( 32.3)
      37% ( 19)      39.1%   2482.0 ( 25.2)      90.1%    175.3 ( 31.7)
      50% ( 26)      38.8%   2495.0 (  8.7)      89.1%    193.7 (  3.5)
      75% ( 39)      39.2%   2478.0 ( 21.0)      90.3%    172.7 ( 26.7)
     100% ( 52)      40.0%   2448.0 (  2.0)      91.9%    143.3 (  1.5)

    Intel(R) Xeon(R) CPU E5-2699C v4 @ 2.20GHz (Broadwell, bare metal)
      1 node * 16 cores * 2 threads = 32 CPUs
      192G/node = 192G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   1996.0 ( 18.0)         --   1104.3 (  6.7)
       3% (  1)       1.4%   1968.0 (  3.0)       2.7%   1074.7 (  9.0)
      12% (  4)      40.1%   1196.0 ( 22.7)      72.4%    305.3 ( 16.8)
      25% (  8)      47.4%   1049.3 ( 17.2)      84.2%    174.0 ( 10.6)
      37% ( 12)      48.3%   1032.0 ( 14.9)      86.8%    145.3 (  2.5)
      50% ( 16)      48.9%   1020.3 (  2.5)      88.0%    133.0 (  1.7)
      75% ( 24)      49.1%   1016.3 (  8.1)      88.4%    128.0 (  1.7)
     100% ( 32)      49.4%   1009.0 (  8.5)      88.6%    126.3 (  0.6)

    Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, bare metal)
      2 nodes * 18 cores * 2 threads = 72 CPUs
      128G/node = 256G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   1682.7 (  6.7)         --    630.0 (  4.6)
       3% (  1)       0.4%   1676.0 (  2.0)       0.7%    625.3 (  3.2)
      12% (  4)      25.8%   1249.0 (  1.0)      68.2%    200.3 (  1.2)
      25% (  9)      30.0%   1178.0 (  5.2)      79.7%    128.0 (  3.5)
      37% ( 13)      30.6%   1167.7 (  3.1)      81.3%    117.7 (  1.2)
      50% ( 18)      30.6%   1167.3 (  2.3)      81.4%    117.0 (  1.0)
      75% ( 27)      31.0%   1161.3 (  4.6)      82.5%    110.0 (  6.9)
     100% ( 36)      32.1%   1142.0 (  3.6)      85.7%     90.0 (  1.0)

    AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
      1 node * 8 cores * 2 threads = 16 CPUs
      64G/node = 64G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --   1003.7 ( 16.6)         --    243.3 (  8.1)
       6% (  1)       1.4%    990.0 (  4.6)       1.2%    240.3 (  1.5)
      12% (  2)      11.4%    889.3 ( 16.7)      44.5%    135.0 (  3.0)
      25% (  4)      16.8%    835.3 (  9.0)      65.8%     83.3 (  2.5)
      37% (  6)      18.6%    816.7 ( 17.6)      70.4%     72.0 (  1.0)
      50% (  8)      18.2%    821.0 (  5.0)      70.7%     71.3 (  1.2)
      75% ( 12)      19.0%    813.3 (  5.0)      71.8%     68.7 (  2.1)
     100% ( 16)      19.8%    805.3 ( 10.8)      76.4%     57.3 ( 15.9)

Server-oriented distros that enable deferred page init sometimes run in
small VMs, and they still benefit even though the fraction of boot time
saved is smaller:

    AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
      1 node * 2 cores * 2 threads = 4 CPUs
      16G/node = 16G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --    722.3 (  9.5)         --     50.7 (  0.6)
      25% (  1)      -3.3%    746.3 (  4.7)      -2.0%     51.7 (  1.2)
      50% (  2)       0.2%    721.0 ( 11.3)      29.6%     35.7 (  4.9)
      75% (  3)      -0.3%    724.3 ( 11.2)      48.7%     26.0 (  0.0)
     100% (  4)       3.0%    700.3 ( 13.6)      55.9%     22.3 (  0.6)

    Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, kvm guest)
      1 node * 2 cores * 2 threads = 4 CPUs
      14G/node = 14G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
    node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
          (  0)         --    673.0 (  6.9)         --     57.0 (  1.0)
      25% (  1)      -0.6%    677.3 ( 19.8)       1.8%     56.0 (  1.0)
      50% (  2)       3.4%    650.0 (  3.6)      36.8%     36.0 (  5.2)
      75% (  3)       4.2%    644.7 (  7.6)      56.1%     25.0 (  1.0)
     100% (  4)       5.3%    637.0 (  5.6)      63.2%     21.0 (  0.0)

On Josh's 96-CPU and 192G memory system:

    Without this patch series:
    [    0.487132] node 0 initialised, 23398907 pages in 292ms
    [    0.499132] node 1 initialised, 24189223 pages in 304ms
    ...
    [    0.629376] Run /sbin/init as init process

    With this patch series:
    [    0.227868] node 0 initialised, 23398907 pages in 28ms
    [    0.230019] node 1 initialised, 24189223 pages in 28ms
    ...
    [    0.361069] Run /sbin/init as init process

[1] https://static.sched.com/hosted_files/kvmforum2019/66/VMM-fast-restart_kvmforum2019.pdf

Link: http://lkml.kernel.org/r/20200520182645.1658949-6-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@joshtriplett.org>
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

 mm/Kconfig      |    6 ++--
 mm/page_alloc.c |   60 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 58 insertions(+), 8 deletions(-)

--- a/mm/Kconfig~mm-parallelize-deferred_init_memmap
+++ a/mm/Kconfig
@@ -747,13 +747,13 @@ config DEFERRED_STRUCT_PAGE_INIT
 	depends on SPARSEMEM
 	depends on !NEED_PER_CPU_KM
 	depends on 64BIT
+	select PADATA
 	help
 	  Ordinarily all struct pages are initialised during early boot in a
 	  single thread. On very large machines this can take a considerable
 	  amount of time. If this option is set, large machines will bring up
-	  a subset of memmap at boot and then initialise the rest in parallel
-	  by starting one-off "pgdatinitX" kernel thread for each node X. This
-	  has a potential performance impact on processes running early in the
+	  a subset of memmap at boot and then initialise the rest in parallel.
+	  This has a potential performance impact on tasks running early in the
 	  lifetime of the system until these kthreads finish the
 	  initialisation.
 
--- a/mm/page_alloc.c~mm-parallelize-deferred_init_memmap
+++ a/mm/page_alloc.c
@@ -68,6 +68,7 @@
 #include <linux/lockdep.h>
 #include <linux/nmi.h>
 #include <linux/psi.h>
+#include <linux/padata.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -1815,16 +1816,44 @@ deferred_init_maxorder(u64 *i, struct zo
 	return nr_pages;
 }
 
+struct definit_args {
+	struct zone *zone;
+	atomic_long_t nr_pages;
+};
+
+static void __init
+deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
+			   void *arg)
+{
+	unsigned long spfn, epfn, nr_pages = 0;
+	struct definit_args *args = arg;
+	struct zone *zone = args->zone;
+	u64 i;
+
+	deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
+
+	/*
+	 * Initialize and free pages in MAX_ORDER sized increments so that we
+	 * can avoid introducing any issues with the buddy allocator.
+	 */
+	while (spfn < end_pfn) {
+		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		cond_resched();
+	}
+
+	atomic_long_add(nr_pages, &args->nr_pages);
+}
+
 /* Initialise remaining memory on a node */
 static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
 	unsigned long spfn = 0, epfn = 0, nr_pages = 0;
-	unsigned long first_init_pfn, flags;
+	unsigned long first_init_pfn, flags, epfn_align;
 	unsigned long start = jiffies;
 	struct zone *zone;
-	int zid;
+	int zid, max_threads;
 	u64 i;
 
 	/* Bind memory initialisation thread to a local node if possible */
@@ -1864,11 +1893,32 @@ static int __init deferred_init_memmap(v
 		goto zone_empty;
 
 	/*
-	 * Initialize and free pages in MAX_ORDER sized increments so
-	 * that we can avoid introducing any issues with the buddy
-	 * allocator.
+	 * More CPUs always led to greater speedups on tested systems, up to
+	 * all the nodes' CPUs.  Use all since the system is otherwise idle now.
 	 */
+	max_threads = max(cpumask_weight(cpumask), 1u);
+
 	while (spfn < epfn) {
+		epfn_align = ALIGN_DOWN(epfn, PAGES_PER_SECTION);
+
+		if (IS_ALIGNED(spfn, PAGES_PER_SECTION) &&
+		    epfn_align - spfn >= PAGES_PER_SECTION) {
+			struct definit_args arg = { zone, ATOMIC_LONG_INIT(0) };
+			struct padata_mt_job job = {
+				.thread_fn   = deferred_init_memmap_chunk,
+				.fn_arg      = &arg,
+				.start       = spfn,
+				.size        = epfn_align - spfn,
+				.align       = PAGES_PER_SECTION,
+				.min_chunk   = PAGES_PER_SECTION,
+				.max_threads = max_threads,
+			};
+
+			padata_do_multithreaded(&job);
+			nr_pages += atomic_long_read(&arg.nr_pages);
+			spfn = epfn_align;
+		}
+
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
 		cond_resched();
 	}
_

Patches currently in -mm which might be from daniel.m.jordan@oracle.com are

mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
padata-remove-exit-routine.patch
padata-initialize-earlier.patch
padata-allocate-work-structures-for-parallel-jobs-from-a-pool.patch
padata-add-basic-support-for-multithreaded-jobs.patch
mm-parallelize-deferred_init_memmap.patch
mm-make-deferred-inits-max-threads-arch-specific.patch
padata-document-multithreaded-jobs.patch
