From: akpm@linux-foundation.org
Subject: + mm-scale-kswapd-watermarks-in-proportion-to-memory.patch added
 to -mm tree
Date: Tue, 23 Feb 2016 16:15:07 -0800
Message-ID: <56ccf60b.RJBobWhL3VgzMK8W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbcBXAPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 19:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: scale kswapd watermarks in proportion to memory
has been added to the -mm tree.  Its filename is
     mm-scale-kswapd-watermarks-in-proportion-to-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-scale-kswapd-watermarks-in-proportion-to-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: scale kswapd watermarks in proportion to memory

In machines with 140G of memory and enterprise flash storage, we have seen
read and write bursts routinely exceed the kswapd watermarks and cause
thundering herds in direct reclaim.  Unfortunately, the only way to tune
kswapd aggressiveness is through adjusting min_free_kbytes - the system's
emergency reserves - which is entirely unrelated to the system's latency
requirements.  In order to get kswapd to maintain a 250M buffer of free
memory, the emergency reserves need to be set to 1G.  That is a lot of
memory wasted for no good reason.

On the other hand, it's reasonable to assume that allocation bursts and
overall allocation concurrency scale with memory capacity, so it makes
sense to make kswapd aggressiveness a function of that as well.

Change the kswapd watermark scale factor from the currently fixed 25% of
the tunable emergency reserve to a tunable 0.001% of memory.

Beyond 1G of memory, this will produce bigger watermark steps than the
current formula in default settings.  Ensure that the new formula never
chooses steps smaller than that, i.e.  25% of the emergency reserve.

On a 140G machine, this raises the default watermark steps - the distance
between min and low, and low and high - from 16M to 143M.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   18 ++++++++++++++++++
 include/linux/mm.h          |    1 +
 include/linux/mmzone.h      |    2 ++
 kernel/sysctl.c             |   10 ++++++++++
 mm/page_alloc.c             |   29 +++++++++++++++++++++++++++--
 5 files changed, 58 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-scale-kswapd-watermarks-in-proportion-to-memory Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-scale-kswapd-watermarks-in-proportion-to-memory
+++ a/Documentation/sysctl/vm.txt
@@ -803,6 +803,24 @@ performance impact. Reclaim code needs t
 directory and inode objects. With vfs_cache_pressure=1000, it will look for
 ten times more freeable objects than there are.
 
+=============================================================
+
+watermark_scale_factor:
+
+This factor controls the aggressiveness of kswapd. It defines the
+amount of memory left in a node/system before kswapd is woken up and
+how much memory needs to be free before kswapd goes back to sleep.
+
+The unit is in fractions of 10,000. The default value of 10 means the
+distances between watermarks are 0.001% of the available memory in the
+node/system. The maximum value is 1000, or 10% of memory.
+
+A high rate of threads entering direct reclaim (allocstall) or kswapd
+going to sleep prematurely (kswapd_low_wmark_hit_quickly) can indicate
+that the number of free pages kswapd maintains for latency reasons is
+too small for the allocation bursts occurring in the system. This knob
+can then be used to tune kswapd aggressiveness accordingly.
+
 ==============================================================
 
 zone_reclaim_mode:
diff -puN include/linux/mm.h~mm-scale-kswapd-watermarks-in-proportion-to-memory include/linux/mm.h
--- a/include/linux/mm.h~mm-scale-kswapd-watermarks-in-proportion-to-memory
+++ a/include/linux/mm.h
@@ -1877,6 +1877,7 @@ extern void zone_pcp_reset(struct zone *
 
 /* page_alloc.c */
 extern int min_free_kbytes;
+extern int watermark_scale_factor;
 
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
diff -puN include/linux/mmzone.h~mm-scale-kswapd-watermarks-in-proportion-to-memory include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-scale-kswapd-watermarks-in-proportion-to-memory
+++ a/include/linux/mmzone.h
@@ -841,6 +841,8 @@ static inline int is_highmem(struct zone
 struct ctl_table;
 int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
+int watermark_scale_factor_sysctl_handler(struct ctl_table *, int,
+					void __user *, size_t *, loff_t *);
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
diff -puN kernel/sysctl.c~mm-scale-kswapd-watermarks-in-proportion-to-memory kernel/sysctl.c
--- a/kernel/sysctl.c~mm-scale-kswapd-watermarks-in-proportion-to-memory
+++ a/kernel/sysctl.c
@@ -126,6 +126,7 @@ static int __maybe_unused two = 2;
 static int __maybe_unused four = 4;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
+static int one_thousand = 1000;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
 #endif
@@ -1393,6 +1394,15 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 	{
+		.procname	= "watermark_scale_factor",
+		.data		= &watermark_scale_factor,
+		.maxlen		= sizeof(watermark_scale_factor),
+		.mode		= 0644,
+		.proc_handler	= watermark_scale_factor_sysctl_handler,
+		.extra1		= &one,
+		.extra2		= &one_thousand,
+	},
+	{
 		.procname	= "percpu_pagelist_fraction",
 		.data		= &percpu_pagelist_fraction,
 		.maxlen		= sizeof(percpu_pagelist_fraction),
diff -puN mm/page_alloc.c~mm-scale-kswapd-watermarks-in-proportion-to-memory mm/page_alloc.c
--- a/mm/page_alloc.c~mm-scale-kswapd-watermarks-in-proportion-to-memory
+++ a/mm/page_alloc.c
@@ -249,6 +249,7 @@ compound_page_dtor * const compound_page
 
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
+int watermark_scale_factor = 10;
 
 static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
@@ -6344,8 +6345,17 @@ static void __setup_per_zone_wmarks(void
 			zone->watermark[WMARK_MIN] = tmp;
 		}
 
-		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
-		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
+		/*
+		 * Set the kswapd watermarks distance according to the
+		 * scale factor in proportion to available memory, but
+		 * ensure a minimum size on small systems.
+		 */
+		tmp = max_t(u64, tmp >> 2,
+			    mult_frac(zone->managed_pages,
+				      watermark_scale_factor, 10000));
+
+		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
+		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + tmp * 2;
 
 		__mod_zone_page_state(zone, NR_ALLOC_BATCH,
 			high_wmark_pages(zone) - low_wmark_pages(zone) -
@@ -6486,6 +6496,21 @@ int min_free_kbytes_sysctl_handler(struc
 	return 0;
 }
 
+int watermark_scale_factor_sysctl_handler(struct ctl_table *table, int write,
+	void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int rc;
+
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
+	if (write)
+		setup_per_zone_wmarks();
+
+	return 0;
+}
+
 #ifdef CONFIG_NUMA
 int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
mm-simplify-lock_page_memcg.patch
mm-remove-unnecessary-uses-of-lock_page_memcg.patch
mm-migrate-consolidate-mem_cgroup_migrate-calls.patch
mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch

