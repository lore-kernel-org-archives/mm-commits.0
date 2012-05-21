From: akpm@linux-foundation.org
Subject: + mm-document-the-meminfo-and-vmstat-fields-of-relevance-to-transparent-hugepages.patch added to -mm tree
Date: Mon, 21 May 2012 15:44:44 -0700
Message-ID: <20120521224444.5675BA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:44205 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab2EUWop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 May 2012 18:44:45 -0400
Received: by yhgm50 with SMTP id m50so792901yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 21 May 2012 15:44:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com


The patch titled
     Subject: mm: document the meminfo and vmstat fields of relevance to transparent hugepages
has been added to the -mm tree.  Its filename is
     mm-document-the-meminfo-and-vmstat-fields-of-relevance-to-transparent-hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: document the meminfo and vmstat fields of relevance to transparent hugepages

Update Documentation/vm/transhuge.txt and
Documentation/filesystems/proc.txt with some information on monitoring
transparent huge page usage and the associated overhead.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 
 Documentation/vm/transhuge.txt     |   62 +++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff -puN Documentation/filesystems/proc.txt~mm-document-the-meminfo-and-vmstat-fields-of-relevance-to-transparent-hugepages Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-document-the-meminfo-and-vmstat-fields-of-relevance-to-transparent-hugepages
+++ a/Documentation/filesystems/proc.txt
@@ -743,6 +743,7 @@ Committed_AS:   100056 kB
 VmallocTotal:   112216 kB
 VmallocUsed:       428 kB
 VmallocChunk:   111088 kB
+AnonHugePages:   49152 kB
 
     MemTotal: Total usable ram (i.e. physical ram minus a few reserved
               bits and the kernel binary code)
@@ -776,6 +777,7 @@ VmallocChunk:   111088 kB
        Dirty: Memory which is waiting to get written back to the disk
    Writeback: Memory which is actively being written back to the disk
    AnonPages: Non-file backed pages mapped into userspace page tables
+AnonHugePages: Non-file backed huge pages mapped into userspace page tables
       Mapped: files which have been mmaped, such as libraries
         Slab: in-kernel data structures cache
 SReclaimable: Part of Slab, that might be reclaimed, such as caches
diff -puN Documentation/vm/transhuge.txt~mm-document-the-meminfo-and-vmstat-fields-of-relevance-to-transparent-hugepages Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~mm-document-the-meminfo-and-vmstat-fields-of-relevance-to-transparent-hugepages
+++ a/Documentation/vm/transhuge.txt
@@ -166,6 +166,68 @@ behavior. So to make them effective you 
 application that could have been using hugepages. This also applies to
 the regions registered in khugepaged.
 
+== Monitoring usage ==
+
+The number of transparent huge pages currently used by the system is
+available by reading the AnonHugePages field in /proc/meminfo. To
+identify what applications are using transparent huge pages, it is
+necessary to read /proc/PID/smaps and count the AnonHugePages fields
+for each mapping. Note that reading the smaps file is expensive and
+reading it frequently will incur overhead.
+
+There are a number of counters in /proc/vmstat that may be used to
+monitor how successfully the system is providing huge pages for use.
+
+thp_fault_alloc is incremented every time a huge page is successfully
+	allocated to handle a page fault. This applies to both the
+	first time a page is faulted and for COW faults.
+
+thp_collapse_alloc is incremented by khugepaged when it has found
+	a range of pages to collapse into one huge page and has
+	successfully allocated a new huge page to store the data.
+
+thp_fault_fallback is incremented if a page fault fails to allocate
+	a huge page and instead falls back to using small pages.
+
+thp_collapse_alloc_failed is incremented if khugepaged found a range
+	of pages that should be collapsed into one huge page but failed
+	the allocation.
+
+thp_split is incremented every time a huge page is split into base
+	pages. This can happen for a variety of reasons but a common
+	reason is that a huge page is old and is being reclaimed.
+
+As the system ages, allocating huge pages may be expensive as the
+system uses memory compaction to copy data around memory to free a
+huge page for use. There are some counters in /proc/vmstat to help
+monitor this overhead.
+
+compact_stall is incremented every time a process stalls to run
+	memory compaction so that a huge page is free for use.
+
+compact_success is incremented if the system compacted memory and
+	freed a huge page for use.
+
+compact_fail is incremented if the system tries to compact memory
+	but failed.
+
+compact_pages_moved is incremented each time a page is moved. If
+	this value is increasing rapidly, it implies that the system
+	is copying a lot of data to satisfy the huge page allocation.
+	It is possible that the cost of copying exceeds any savings
+	from reduced TLB misses.
+
+compact_pagemigrate_failed is incremented when the underlying mechanism
+	for moving a page failed.
+
+compact_blocks_moved is incremented each time memory compaction examines
+	a huge page aligned range of pages.
+
+It is possible to establish how long the stalls were using the function
+tracer to record how long was spent in __alloc_pages_nodemask and
+using the mm_page_alloc tracepoint to identify which allocations were
+for huge pages.
+
 == get_user_pages and follow_page ==
 
 get_user_pages and follow_page if run on a hugepage, will return the
_
Subject: Subject: mm: document the meminfo and vmstat fields of relevance to transparent hugepages

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-part-2.patch
mm-document-the-meminfo-and-vmstat-fields-of-relevance-to-transparent-hugepages.patch
mm-optimize-put_mems_allowed-usage-fix.patch

