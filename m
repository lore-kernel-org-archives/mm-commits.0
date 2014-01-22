From: akpm@linux-foundation.org
Subject: [merged] proc-meminfo-provide-estimated-available-memory.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:36 -0800
Message-ID: <52e02634.J51SpRgUwoarpyHK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, erik.mouw_2@nxp.com, riel@redhat.com

Subject: [merged] proc-meminfo-provide-estimated-available-memory.patch removed from -mm tree
To: riel@redhat.com,erik.mouw_2@nxp.com,hannes@cmpxchg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:36 -0800


The patch titled
     Subject: /proc/meminfo: provide estimated available memory
has been removed from the -mm tree.  Its filename was
     proc-meminfo-provide-estimated-available-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: /proc/meminfo: provide estimated available memory

Many load balancing and workload placing programs check /proc/meminfo to
estimate how much free memory is available.  They generally do this by
adding up "free" and "cached", which was fine ten years ago, but is pretty
much guaranteed to be wrong today.

It is wrong because Cached includes memory that is not freeable as page
cache, for example shared memory segments, tmpfs, and ramfs, and it does
not include reclaimable slab memory, which can take up a large fraction of
system memory on mostly idle systems with lots of files.

Currently, the amount of memory that is available for a new workload,
without pushing the system into swap, can be estimated from MemFree,
Active(file), Inactive(file), and SReclaimable, as well as the "low"
watermarks from /proc/zoneinfo.

However, this may change in the future, and user space really should not
be expected to know kernel internals to come up with an estimate for the
amount of free memory.

It is more convenient to provide such an estimate in /proc/meminfo.  If
things change in the future, we only have to change it in one place.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Erik Mouw <erik.mouw_2@nxp.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    9 ++++++
 fs/proc/meminfo.c                  |   37 +++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff -puN Documentation/filesystems/proc.txt~proc-meminfo-provide-estimated-available-memory Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-meminfo-provide-estimated-available-memory
+++ a/Documentation/filesystems/proc.txt
@@ -767,6 +767,7 @@ The "Locked" indicates whether the mappi
 
 MemTotal:     16344972 kB
 MemFree:      13634064 kB
+MemAvailable: 14836172 kB
 Buffers:          3656 kB
 Cached:        1195708 kB
 SwapCached:          0 kB
@@ -799,6 +800,14 @@ AnonHugePages:   49152 kB
     MemTotal: Total usable ram (i.e. physical ram minus a few reserved
               bits and the kernel binary code)
      MemFree: The sum of LowFree+HighFree
+MemAvailable: An estimate of how much memory is available for starting new
+              applications, without swapping. Calculated from MemFree,
+              SReclaimable, the size of the file LRU lists, and the low
+              watermarks in each zone.
+              The estimate takes into account that the system needs some
+              page cache to function well, and that not all reclaimable
+              slab will be reclaimable, due to items being in use. The
+              impact of those factors will vary from system to system.
      Buffers: Relatively temporary storage for raw disk blocks
               shouldn't get tremendously large (20MB or so)
       Cached: in-memory cache for files read from the disk (the
diff -puN fs/proc/meminfo.c~proc-meminfo-provide-estimated-available-memory fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~proc-meminfo-provide-estimated-available-memory
+++ a/fs/proc/meminfo.c
@@ -26,7 +26,11 @@ static int meminfo_proc_show(struct seq_
 	unsigned long committed;
 	struct vmalloc_info vmi;
 	long cached;
+	long available;
+	unsigned long pagecache;
+	unsigned long wmark_low = 0;
 	unsigned long pages[NR_LRU_LISTS];
+	struct zone *zone;
 	int lru;
 
 /*
@@ -47,12 +51,44 @@ static int meminfo_proc_show(struct seq_
 	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
 		pages[lru] = global_page_state(NR_LRU_BASE + lru);
 
+	for_each_zone(zone)
+		wmark_low += zone->watermark[WMARK_LOW];
+
+	/*
+	 * Estimate the amount of memory available for userspace allocations,
+	 * without causing swapping.
+	 *
+	 * Free memory cannot be taken below the low watermark, before the
+	 * system starts swapping.
+	 */
+	available = i.freeram - wmark_low;
+
+	/*
+	 * Not all the page cache can be freed, otherwise the system will
+	 * start swapping. Assume at least half of the page cache, or the
+	 * low watermark worth of cache, needs to stay.
+	 */
+	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
+	pagecache -= min(pagecache / 2, wmark_low);
+	available += pagecache;
+
+	/*
+	 * Part of the reclaimable swap consists of items that are in use,
+	 * and cannot be freed. Cap this estimate at the low watermark.
+	 */
+	available += global_page_state(NR_SLAB_RECLAIMABLE) -
+		     min(global_page_state(NR_SLAB_RECLAIMABLE) / 2, wmark_low);
+
+	if (available < 0)
+		available = 0;
+
 	/*
 	 * Tagged format, for easy grepping and expansion.
 	 */
 	seq_printf(m,
 		"MemTotal:       %8lu kB\n"
 		"MemFree:        %8lu kB\n"
+		"MemAvailable:   %8lu kB\n"
 		"Buffers:        %8lu kB\n"
 		"Cached:         %8lu kB\n"
 		"SwapCached:     %8lu kB\n"
@@ -105,6 +141,7 @@ static int meminfo_proc_show(struct seq_
 		,
 		K(i.totalram),
 		K(i.freeram),
+		K(available),
 		K(i.bufferram),
 		K(cached),
 		K(total_swapcache_pages()),
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
kexec-add-sysctl-to-disable-kexec_load.patch
ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch
ipc-change-kern_ipc_permdeleted-type-to-bool.patch
ipc-standardize-code-comments.patch
ipc-remove-braces-for-single-statements.patch
ipc-remove-useless-return-statement.patch
ipc-simplify-sysvipc_proc_open-return.patch
ipc-delete-seq_max-field-in-struct-ipc_ids.patch
ipcmsg-document-barriers.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

