From: akpm@linux-foundation.org
Subject: + proc-meminfo-provide-estimated-available-memory.patch added to
 -mm tree
Date: Thu, 07 Nov 2013 14:27:49 -0800
Message-ID: <527c13e5.O1/+x6JDZP+iyKMX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3KGW1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 17:27:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, erik.mouw_2@nxp.com, riel@redhat.com

Subject: + proc-meminfo-provide-estimated-available-memory.patch added to -mm tree
To: riel@redhat.com,erik.mouw_2@nxp.com,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 14:27:49 -0800


The patch titled
     Subject: /proc/meminfo: provide estimated available memory
has been added to the -mm tree.  Its filename is
     proc-meminfo-provide-estimated-available-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-meminfo-provide-estimated-available-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-meminfo-provide-estimated-available-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch
memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
proc-meminfo-provide-estimated-available-memory.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch

