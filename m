From: akpm@linux-foundation.org
Subject: + update-of-documentation-vmtxt-and-proctxt.patch added to -mm tree
Date: Mon, 12 Jan 2009 16:52:06 -0800
Message-ID: <200901130052.n0D0q6ah021951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbZAMAwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 19:52:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pmorreale@novell.com, randy.dunlap@oracle.com


The patch titled
     Update of Documentation: vm.txt and proc.txt
has been added to the -mm tree.  Its filename is
     update-of-documentation-vmtxt-and-proctxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Update of Documentation: vm.txt and proc.txt
From: Peter W Morreale <pmorreale@novell.com>

Update Documentation/sysctl/vm.txt and Documentation/filesystems/proc.txt.
 More specifically, the section on /proc/sys/vm in
Documentation/filesystems/proc.txt was removed and a link to
Documentation/sysctl/vm.txt added.

Most of the verbiage from proc.txt was simply moved in vm.txt, with new
addtional text for "swappiness" and "stat_interval".

Signed-off-by: Peter W Morreale <pmorreale@novell.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |  288 ------------
 Documentation/sysctl/vm.txt        |  619 ++++++++++++++++++---------
 2 files changed, 437 insertions(+), 470 deletions(-)

diff -puN Documentation/filesystems/proc.txt~update-of-documentation-vmtxt-and-proctxt Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~update-of-documentation-vmtxt-and-proctxt
+++ a/Documentation/filesystems/proc.txt
@@ -1371,292 +1371,8 @@ auto_msgmni default value is 1.
 2.4 /proc/sys/vm - The virtual memory subsystem
 -----------------------------------------------
 
-The files  in  this directory can be used to tune the operation of the virtual
-memory (VM)  subsystem  of  the  Linux  kernel.
-
-vfs_cache_pressure
-------------------
-
-Controls the tendency of the kernel to reclaim the memory which is used for
-caching of directory and inode objects.
-
-At the default value of vfs_cache_pressure=100 the kernel will attempt to
-reclaim dentries and inodes at a "fair" rate with respect to pagecache and
-swapcache reclaim.  Decreasing vfs_cache_pressure causes the kernel to prefer
-to retain dentry and inode caches.  Increasing vfs_cache_pressure beyond 100
-causes the kernel to prefer to reclaim dentries and inodes.
-
-dirty_background_bytes
-----------------------
-
-Contains the amount of dirty memory at which the pdflush background writeback
-daemon will start writeback.
-
-If dirty_background_bytes is written, dirty_background_ratio becomes a function
-of its value (dirty_background_bytes / the amount of dirtyable system memory).
-
-dirty_background_ratio
-----------------------
-
-Contains, as a percentage of the dirtyable system memory (free pages + mapped
-pages + file cache, not including locked pages and HugePages), the number of
-pages at which the pdflush background writeback daemon will start writing out
-dirty data.
-
-If dirty_background_ratio is written, dirty_background_bytes becomes a function
-of its value (dirty_background_ratio * the amount of dirtyable system memory).
-
-dirty_bytes
------------
-
-Contains the amount of dirty memory at which a process generating disk writes
-will itself start writeback.
-
-If dirty_bytes is written, dirty_ratio becomes a function of its value
-(dirty_bytes / the amount of dirtyable system memory).
-
-dirty_ratio
------------
-
-Contains, as a percentage of the dirtyable system memory (free pages + mapped
-pages + file cache, not including locked pages and HugePages), the number of
-pages at which a process which is generating disk writes will itself start
-writing out dirty data.
-
-If dirty_ratio is written, dirty_bytes becomes a function of its value
-(dirty_ratio * the amount of dirtyable system memory).
-
-dirty_writeback_centisecs
--------------------------
-
-The pdflush writeback daemons will periodically wake up and write `old' data
-out to disk.  This tunable expresses the interval between those wakeups, in
-100'ths of a second.
-
-Setting this to zero disables periodic writeback altogether.
-
-dirty_expire_centisecs
-----------------------
-
-This tunable is used to define when dirty data is old enough to be eligible
-for writeout by the pdflush daemons.  It is expressed in 100'ths of a second. 
-Data which has been dirty in-memory for longer than this interval will be
-written out next time a pdflush daemon wakes up.
-
-highmem_is_dirtyable
---------------------
-
-Only present if CONFIG_HIGHMEM is set.
-
-This defaults to 0 (false), meaning that the ratios set above are calculated
-as a percentage of lowmem only.  This protects against excessive scanning
-in page reclaim, swapping and general VM distress.
-
-Setting this to 1 can be useful on 32 bit machines where you want to make
-random changes within an MMAPed file that is larger than your available
-lowmem without causing large quantities of random IO.  Is is safe if the
-behavior of all programs running on the machine is known and memory will
-not be otherwise stressed.
-
-legacy_va_layout
-----------------
-
-If non-zero, this sysctl disables the new 32-bit mmap mmap layout - the kernel
-will use the legacy (2.4) layout for all processes.
-
-lowmem_reserve_ratio
----------------------
-
-For some specialised workloads on highmem machines it is dangerous for
-the kernel to allow process memory to be allocated from the "lowmem"
-zone.  This is because that memory could then be pinned via the mlock()
-system call, or by unavailability of swapspace.
-
-And on large highmem machines this lack of reclaimable lowmem memory
-can be fatal.
-
-So the Linux page allocator has a mechanism which prevents allocations
-which _could_ use highmem from using too much lowmem.  This means that
-a certain amount of lowmem is defended from the possibility of being
-captured into pinned user memory.
-
-(The same argument applies to the old 16 megabyte ISA DMA region.  This
-mechanism will also defend that region from allocations which could use
-highmem or lowmem).
-
-The `lowmem_reserve_ratio' tunable determines how aggressive the kernel is
-in defending these lower zones.
-
-If you have a machine which uses highmem or ISA DMA and your
-applications are using mlock(), or if you are running with no swap then
-you probably should change the lowmem_reserve_ratio setting.
-
-The lowmem_reserve_ratio is an array. You can see them by reading this file.
--
-% cat /proc/sys/vm/lowmem_reserve_ratio
-256     256     32
--
-Note: # of this elements is one fewer than number of zones. Because the highest
-      zone's value is not necessary for following calculation.
-
-But, these values are not used directly. The kernel calculates # of protection
-pages for each zones from them. These are shown as array of protection pages
-in /proc/zoneinfo like followings. (This is an example of x86-64 box).
-Each zone has an array of protection pages like this.
-
--
-Node 0, zone      DMA
-  pages free     1355
-        min      3
-        low      3
-        high     4
-	:
-	:
-    numa_other   0
-        protection: (0, 2004, 2004, 2004)
-	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-  pagesets
-    cpu: 0 pcp: 0
-        :
--
-These protections are added to score to judge whether this zone should be used
-for page allocation or should be reclaimed.
-
-In this example, if normal pages (index=2) are required to this DMA zone and
-pages_high is used for watermark, the kernel judges this zone should not be
-used because pages_free(1355) is smaller than watermark + protection[2]
-(4 + 2004 = 2008). If this protection value is 0, this zone would be used for
-normal page requirement. If requirement is DMA zone(index=0), protection[0]
-(=0) is used.
-
-zone[i]'s protection[j] is calculated by following expression.
-
-(i < j):
-  zone[i]->protection[j]
-  = (total sums of present_pages from zone[i+1] to zone[j] on the node)
-    / lowmem_reserve_ratio[i];
-(i = j):
-   (should not be protected. = 0;
-(i > j):
-   (not necessary, but looks 0)
-
-The default values of lowmem_reserve_ratio[i] are
-    256 (if zone[i] means DMA or DMA32 zone)
-    32  (others).
-As above expression, they are reciprocal number of ratio.
-256 means 1/256. # of protection pages becomes about "0.39%" of total present
-pages of higher zones on the node.
-
-If you would like to protect more pages, smaller values are effective.
-The minimum value is 1 (1/1 -> 100%).
-
-page-cluster
-------------
-
-page-cluster controls the number of pages which are written to swap in
-a single attempt.  The swap I/O size.
-
-It is a logarithmic value - setting it to zero means "1 page", setting
-it to 1 means "2 pages", setting it to 2 means "4 pages", etc.
-
-The default value is three (eight pages at a time).  There may be some
-small benefits in tuning this to a different value if your workload is
-swap-intensive.
-
-overcommit_memory
------------------
-
-Controls overcommit of system memory, possibly allowing processes
-to allocate (but not use) more memory than is actually available.
-
-
-0	-	Heuristic overcommit handling. Obvious overcommits of
-		address space are refused. Used for a typical system. It
-		ensures a seriously wild allocation fails while allowing
-		overcommit to reduce swap usage.  root is allowed to
-		allocate slightly more memory in this mode. This is the
-		default.
-
-1	-	Always overcommit. Appropriate for some scientific
-		applications.
-
-2	-	Don't overcommit. The total address space commit
-		for the system is not permitted to exceed swap plus a
-		configurable percentage (default is 50) of physical RAM.
-		Depending on the percentage you use, in most situations
-		this means a process will not be killed while attempting
-		to use already-allocated memory but will receive errors
-		on memory allocation as	appropriate.
-
-overcommit_ratio
-----------------
-
-Percentage of physical memory size to include in overcommit calculations
-(see above.)
-
-Memory allocation limit = swapspace + physmem * (overcommit_ratio / 100)
-
-	swapspace = total size of all swap areas
-	physmem = size of physical memory in system
-
-nr_hugepages and hugetlb_shm_group
-----------------------------------
-
-nr_hugepages configures number of hugetlb page reserved for the system.
-
-hugetlb_shm_group contains group id that is allowed to create SysV shared
-memory segment using hugetlb page.
-
-hugepages_treat_as_movable
---------------------------
-
-This parameter is only useful when kernelcore= is specified at boot time to
-create ZONE_MOVABLE for pages that may be reclaimed or migrated. Huge pages
-are not movable so are not normally allocated from ZONE_MOVABLE. A non-zero
-value written to hugepages_treat_as_movable allows huge pages to be allocated
-from ZONE_MOVABLE.
-
-Once enabled, the ZONE_MOVABLE is treated as an area of memory the huge
-pages pool can easily grow or shrink within. Assuming that applications are
-not running that mlock() a lot of memory, it is likely the huge pages pool
-can grow to the size of ZONE_MOVABLE by repeatedly entering the desired value
-into nr_hugepages and triggering page reclaim.
-
-laptop_mode
------------
-
-laptop_mode is a knob that controls "laptop mode". All the things that are
-controlled by this knob are discussed in Documentation/laptops/laptop-mode.txt.
-
-block_dump
-----------
-
-block_dump enables block I/O debugging when set to a nonzero value. More
-information on block I/O debugging is in Documentation/laptops/laptop-mode.txt.
-
-swap_token_timeout
-------------------
-
-This file contains valid hold time of swap out protection token. The Linux
-VM has token based thrashing control mechanism and uses the token to prevent
-unnecessary page faults in thrashing situation. The unit of the value is
-second. The value would be useful to tune thrashing behavior.
-
-drop_caches
------------
-
-Writing to this will cause the kernel to drop clean caches, dentries and
-inodes from memory, causing that memory to become free.
-
-To free pagecache:
-	echo 1 > /proc/sys/vm/drop_caches
-To free dentries and inodes:
-	echo 2 > /proc/sys/vm/drop_caches
-To free pagecache, dentries and inodes:
-	echo 3 > /proc/sys/vm/drop_caches
-
-As this is a non-destructive operation and dirty objects are not freeable, the
-user should run `sync' first.
+Please see: Documentation/sysctls/vm.txt for a description of these
+entries.
 
 
 2.5 /proc/sys/dev - Device specific parameters
diff -puN Documentation/sysctl/vm.txt~update-of-documentation-vmtxt-and-proctxt Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~update-of-documentation-vmtxt-and-proctxt
+++ a/Documentation/sysctl/vm.txt
@@ -1,12 +1,13 @@
-Documentation for /proc/sys/vm/*	kernel version 2.2.10
+Documentation for /proc/sys/vm/*	kernel version 2.6.29
 	(c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+	(c) 2008         Peter W. Morreale <pmorreale@novell.com>
 
 For general info and legal blurb, please look in README.
 
 ==============================================================
 
 This file contains the documentation for the sysctl files in
-/proc/sys/vm and is valid for Linux kernel version 2.2.
+/proc/sys/vm and is valid for Linux kernel version 2.6.29.
 
 The files in this directory can be used to tune the operation
 of the virtual memory (VM) subsystem of the Linux kernel and
@@ -16,180 +17,274 @@ Default values and initialization routin
 files can be found in mm/swap.c.
 
 Currently, these files are in /proc/sys/vm:
-- overcommit_memory
-- page-cluster
-- dirty_ratio
+
+- block_dump
+- dirty_background_bytes
 - dirty_background_ratio
+- dirty_bytes
 - dirty_expire_centisecs
+- dirty_ratio
 - dirty_writeback_centisecs
-- highmem_is_dirtyable   (only if CONFIG_HIGHMEM set)
+- drop_caches
+- hugepages_treat_as_movable
+- hugetlb_shm_group
+- laptop_mode
+- legacy_va_layout
+- lowmem_reserve_ratio
 - max_map_count
 - min_free_kbytes
-- laptop_mode
-- block_dump
-- drop-caches
-- zone_reclaim_mode
-- min_unmapped_ratio
 - min_slab_ratio
-- panic_on_oom
-- oom_dump_tasks
-- oom_kill_allocating_task
-- mmap_min_address
-- numa_zonelist_order
+- min_unmapped_ratio
+- mmap_min_addr
 - nr_hugepages
 - nr_overcommit_hugepages
-- nr_trim_pages		(only if CONFIG_MMU=n)
+- nr_pdflush_threads
+- nr_trim_pages         (only if CONFIG_MMU=n)
+- numa_zonelist_order
+- oom_dump_tasks
+- oom_kill_allocating_task
+- overcommit_memory
+- overcommit_ratio
+- page-cluster
+- panic_on_oom
+- percpu_pagelist_fraction
+- stat_interval
+- swappiness
+- vfs_cache_pressure
+- zone_reclaim_mode
+
 
 ==============================================================
 
-dirty_bytes, dirty_ratio, dirty_background_bytes,
-dirty_background_ratio, dirty_expire_centisecs,
-dirty_writeback_centisecs, highmem_is_dirtyable,
-vfs_cache_pressure, laptop_mode, block_dump, swap_token_timeout,
-drop-caches, hugepages_treat_as_movable:
+block_dump
 
-See Documentation/filesystems/proc.txt
+block_dump enables block I/O debugging when set to a nonzero value. More
+information on block I/O debugging is in Documentation/laptops/laptop-mode.txt.
 
 ==============================================================
 
-overcommit_memory:
+dirty_background_bytes
 
-This value contains a flag that enables memory overcommitment.
+Contains the amount of dirty memory at which the pdflush background writeback
+daemon will start writeback.
 
-When this flag is 0, the kernel attempts to estimate the amount
-of free memory left when userspace requests more memory.
+If dirty_background_bytes is written, dirty_background_ratio becomes a function
+of its value (dirty_background_bytes / the amount of dirtyable system memory).
 
-When this flag is 1, the kernel pretends there is always enough
-memory until it actually runs out.
+==============================================================
 
-When this flag is 2, the kernel uses a "never overcommit"
-policy that attempts to prevent any overcommit of memory.  
+dirty_background_ratio
 
-This feature can be very useful because there are a lot of
-programs that malloc() huge amounts of memory "just-in-case"
-and don't use much of it.
+Contains, as a percentage of total system memory, the number of pages at which
+the pdflush background writeback daemon will start writing out dirty data.
 
-The default value is 0.
+==============================================================
 
-See Documentation/vm/overcommit-accounting and
-security/commoncap.c::cap_vm_enough_memory() for more information.
+dirty_bytes
+
+Contains the amount of dirty memory at which a process generating disk writes
+will itself start writeback.
+
+If dirty_bytes is written, dirty_ratio becomes a function of its value
+(dirty_bytes / the amount of dirtyable system memory).
 
 ==============================================================
 
-overcommit_ratio:
+dirty_expire_centisecs
 
-When overcommit_memory is set to 2, the committed address
-space is not permitted to exceed swap plus this percentage
-of physical RAM.  See above.
+This tunable is used to define when dirty data is old enough to be eligible
+for writeout by the pdflush daemons.  It is expressed in 100'ths of a second.
+Data which has been dirty in-memory for longer than this interval will be
+written out next time a pdflush daemon wakes up.
 
 ==============================================================
 
-page-cluster:
+dirty_ratio
 
-The Linux VM subsystem avoids excessive disk seeks by reading
-multiple pages on a page fault. The number of pages it reads
-is dependent on the amount of memory in your machine.
-
-The number of pages the kernel reads in at once is equal to
-2 ^ page-cluster. Values above 2 ^ 5 don't make much sense
-for swap because we only cluster swap data in 32-page groups.
+Contains, as a percentage of total system memory, the number of pages at which
+a process which is generating disk writes will itself start writing out dirty
+data.
 
 ==============================================================
 
-max_map_count:
+dirty_writeback_centisecs
 
-This file contains the maximum number of memory map areas a process
-may have. Memory map areas are used as a side-effect of calling
-malloc, directly by mmap and mprotect, and also when loading shared
-libraries.
+The pdflush writeback daemons will periodically wake up and write `old' data
+out to disk.  This tunable expresses the interval between those wakeups, in
+100'ths of a second.
 
-While most applications need less than a thousand maps, certain
-programs, particularly malloc debuggers, may consume lots of them,
-e.g., up to one or two maps per allocation.
+Setting this to zero disables periodic writeback altogether.
 
-The default value is 65536.
+==============================================================
+
+drop_caches
+
+Writing to this will cause the kernel to drop clean caches, dentries and
+inodes from memory, causing that memory to become free.
+
+To free pagecache:
+	echo 1 > /proc/sys/vm/drop_caches
+To free dentries and inodes:
+	echo 2 > /proc/sys/vm/drop_caches
+To free pagecache, dentries and inodes:
+	echo 3 > /proc/sys/vm/drop_caches
+
+As this is a non-destructive operation and dirty objects are not freeable, the
+user should run `sync' first.
 
 ==============================================================
 
-min_free_kbytes:
+hugepages_treat_as_movable
 
-This is used to force the Linux VM to keep a minimum number 
-of kilobytes free.  The VM uses this number to compute a pages_min
-value for each lowmem zone in the system.  Each lowmem zone gets 
-a number of reserved free pages based proportionally on its size.
+This parameter is only useful when kernelcore= is specified at boot time to
+create ZONE_MOVABLE for pages that may be reclaimed or migrated. Huge pages
+are not movable so are not normally allocated from ZONE_MOVABLE. A non-zero
+value written to hugepages_treat_as_movable allows huge pages to be allocated
+from ZONE_MOVABLE.
 
-Some minimal amount of memory is needed to satisfy PF_MEMALLOC
-allocations; if you set this to lower than 1024KB, your system will
-become subtly broken, and prone to deadlock under high loads.
+Once enabled, the ZONE_MOVABLE is treated as an area of memory the huge
+pages pool can easily grow or shrink within. Assuming that applications are
+not running that mlock() a lot of memory, it is likely the huge pages pool
+can grow to the size of ZONE_MOVABLE by repeatedly entering the desired value
+into nr_hugepages and triggering page reclaim.
 
-Setting this too high will OOM your machine instantly.
+==============================================================
+
+hugetlb_shm_group
+
+hugetlb_shm_group contains group id that is allowed to create SysV
+shared memory segment using hugetlb page.
 
 ==============================================================
 
-percpu_pagelist_fraction
+laptop_mode
 
-This is the fraction of pages at most (high mark pcp->high) in each zone that
-are allocated for each per cpu page list.  The min value for this is 8.  It
-means that we don't allow more than 1/8th of pages in each zone to be
-allocated in any single per_cpu_pagelist.  This entry only changes the value
-of hot per cpu pagelists.  User can specify a number like 100 to allocate
-1/100th of each zone to each per cpu page list.
+laptop_mode is a knob that controls "laptop mode". All the things that are
+controlled by this knob are discussed in Documentation/laptops/laptop-mode.txt.
 
-The batch value of each per cpu pagelist is also updated as a result.  It is
-set to pcp->high/4.  The upper limit of batch is (PAGE_SHIFT * 8)
+==============================================================
 
-The initial value is zero.  Kernel does not use this value at boot time to set
-the high water marks for each per cpu page list.
+legacy_va_layout
 
-===============================================================
+If non-zero, this sysctl disables the new 32-bit mmap mmap layout - the kernel
+will use the legacy (2.4) layout for all processes.
 
-zone_reclaim_mode:
+==============================================================
 
-Zone_reclaim_mode allows someone to set more or less aggressive approaches to
-reclaim memory when a zone runs out of memory. If it is set to zero then no
-zone reclaim occurs. Allocations will be satisfied from other zones / nodes
-in the system.
+lowmem_reserve_ratio
 
-This is value ORed together of
+For some specialised workloads on highmem machines it is dangerous for
+the kernel to allow process memory to be allocated from the "lowmem"
+zone.  This is because that memory could then be pinned via the mlock()
+system call, or by unavailability of swapspace.
 
-1	= Zone reclaim on
-2	= Zone reclaim writes dirty pages out
-4	= Zone reclaim swaps pages
+And on large highmem machines this lack of reclaimable lowmem memory
+can be fatal.
 
-zone_reclaim_mode is set during bootup to 1 if it is determined that pages
-from remote zones will cause a measurable performance reduction. The
-page allocator will then reclaim easily reusable pages (those page
-cache pages that are currently not used) before allocating off node pages.
+So the Linux page allocator has a mechanism which prevents allocations
+which _could_ use highmem from using too much lowmem.  This means that
+a certain amount of lowmem is defended from the possibility of being
+captured into pinned user memory.
 
-It may be beneficial to switch off zone reclaim if the system is
-used for a file server and all of memory should be used for caching files
-from disk. In that case the caching effect is more important than
-data locality.
+(The same argument applies to the old 16 megabyte ISA DMA region.  This
+mechanism will also defend that region from allocations which could use
+highmem or lowmem).
 
-Allowing zone reclaim to write out pages stops processes that are
-writing large amounts of data from dirtying pages on other nodes. Zone
-reclaim will write out dirty pages if a zone fills up and so effectively
-throttle the process. This may decrease the performance of a single process
-since it cannot use all of system memory to buffer the outgoing writes
-anymore but it preserve the memory on other nodes so that the performance
-of other processes running on other nodes will not be affected.
+The `lowmem_reserve_ratio' tunable determines how aggressive the kernel is
+in defending these lower zones.
 
-Allowing regular swap effectively restricts allocations to the local
-node unless explicitly overridden by memory policies or cpuset
-configurations.
+If you have a machine which uses highmem or ISA DMA and your
+applications are using mlock(), or if you are running with no swap then
+you probably should change the lowmem_reserve_ratio setting.
 
-=============================================================
+The lowmem_reserve_ratio is an array. You can see them by reading this file.
+-
+% cat /proc/sys/vm/lowmem_reserve_ratio
+256     256     32
+-
+Note: # of this elements is one fewer than number of zones. Because the highest
+      zone's value is not necessary for following calculation.
 
-min_unmapped_ratio:
+But, these values are not used directly. The kernel calculates # of protection
+pages for each zones from them. These are shown as array of protection pages
+in /proc/zoneinfo like followings. (This is an example of x86-64 box).
+Each zone has an array of protection pages like this.
 
-This is available only on NUMA kernels.
+-
+Node 0, zone      DMA
+  pages free     1355
+        min      3
+        low      3
+        high     4
+	:
+	:
+    numa_other   0
+        protection: (0, 2004, 2004, 2004)
+	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+  pagesets
+    cpu: 0 pcp: 0
+        :
+-
+These protections are added to score to judge whether this zone should be used
+for page allocation or should be reclaimed.
 
-A percentage of the total pages in each zone.  Zone reclaim will only
-occur if more than this percentage of pages are file backed and unmapped.
-This is to insure that a minimal amount of local pages is still available for
-file I/O even if the node is overallocated.
+In this example, if normal pages (index=2) are required to this DMA zone and
+pages_high is used for watermark, the kernel judges this zone should not be
+used because pages_free(1355) is smaller than watermark + protection[2]
+(4 + 2004 = 2008). If this protection value is 0, this zone would be used for
+normal page requirement. If requirement is DMA zone(index=0), protection[0]
+(=0) is used.
 
-The default is 1 percent.
+zone[i]'s protection[j] is calculated by following expression.
+
+(i < j):
+  zone[i]->protection[j]
+  = (total sums of present_pages from zone[i+1] to zone[j] on the node)
+    / lowmem_reserve_ratio[i];
+(i = j):
+   (should not be protected. = 0;
+(i > j):
+   (not necessary, but looks 0)
+
+The default values of lowmem_reserve_ratio[i] are
+    256 (if zone[i] means DMA or DMA32 zone)
+    32  (others).
+As above expression, they are reciprocal number of ratio.
+256 means 1/256. # of protection pages becomes about "0.39%" of total present
+pages of higher zones on the node.
+
+If you would like to protect more pages, smaller values are effective.
+The minimum value is 1 (1/1 -> 100%).
+
+==============================================================
+
+max_map_count:
+
+This file contains the maximum number of memory map areas a process
+may have. Memory map areas are used as a side-effect of calling
+malloc, directly by mmap and mprotect, and also when loading shared
+libraries.
+
+While most applications need less than a thousand maps, certain
+programs, particularly malloc debuggers, may consume lots of them,
+e.g., up to one or two maps per allocation.
+
+The default value is 65536.
+
+==============================================================
+
+min_free_kbytes:
+
+This is used to force the Linux VM to keep a minimum number
+of kilobytes free.  The VM uses this number to compute a pages_min
+value for each lowmem zone in the system.  Each lowmem zone gets
+a number of reserved free pages based proportionally on its size.
+
+Some minimal amount of memory is needed to satisfy PF_MEMALLOC
+allocations; if you set this to lower than 1024KB, your system will
+become subtly broken, and prone to deadlock under high loads.
+
+Setting this too high will OOM your machine instantly.
 
 =============================================================
 
@@ -211,82 +306,73 @@ and may not be fast.
 
 =============================================================
 
-panic_on_oom
+min_unmapped_ratio:
 
-This enables or disables panic on out-of-memory feature.
+This is available only on NUMA kernels.
 
-If this is set to 0, the kernel will kill some rogue process,
-called oom_killer.  Usually, oom_killer can kill rogue processes and
-system will survive.
+A percentage of the total pages in each zone.  Zone reclaim will only
+occur if more than this percentage of pages are file backed and unmapped.
+This is to insure that a minimal amount of local pages is still available for
+file I/O even if the node is overallocated.
 
-If this is set to 1, the kernel panics when out-of-memory happens.
-However, if a process limits using nodes by mempolicy/cpusets,
-and those nodes become memory exhaustion status, one process
-may be killed by oom-killer. No panic occurs in this case.
-Because other nodes' memory may be free. This means system total status
-may be not fatal yet.
+The default is 1 percent.
 
-If this is set to 2, the kernel panics compulsorily even on the
-above-mentioned.
+==============================================================
 
-The default value is 0.
-1 and 2 are for failover of clustering. Please select either
-according to your policy of failover.
+mmap_min_addr
 
-=============================================================
+This file indicates the amount of address space  which a user process will
+be restricted from mmaping.  Since kernel null dereference bugs could
+accidentally operate based on the information in the first couple of pages
+of memory userspace processes should not be allowed to write to them.  By
+default this value is set to 0 and no protections will be enforced by the
+security module.  Setting this value to something like 64k will allow the
+vast majority of applications to work correctly and provide defense in depth
+against future potential kernel bugs.
 
-oom_dump_tasks
+==============================================================
 
-Enables a system-wide task dump (excluding kernel threads) to be
-produced when the kernel performs an OOM-killing and includes such
-information as pid, uid, tgid, vm size, rss, cpu, oom_adj score, and
-name.  This is helpful to determine why the OOM killer was invoked
-and to identify the rogue task that caused it.
+nr_hugepages
 
-If this is set to zero, this information is suppressed.  On very
-large systems with thousands of tasks it may not be feasible to dump
-the memory state information for each one.  Such systems should not
-be forced to incur a performance penalty in OOM conditions when the
-information may not be desired.
+Change the minimum size of the hugepage pool.
 
-If this is set to non-zero, this information is shown whenever the
-OOM killer actually kills a memory-hogging task.
+See Documentation/vm/hugetlbpage.txt
 
-The default value is 0.
+==============================================================
 
-=============================================================
+nr_overcommit_hugepages
 
-oom_kill_allocating_task
+Change the maximum size of the hugepage pool. The maximum is
+nr_hugepages + nr_overcommit_hugepages.
 
-This enables or disables killing the OOM-triggering task in
-out-of-memory situations.
+See Documentation/vm/hugetlbpage.txt
 
-If this is set to zero, the OOM killer will scan through the entire
-tasklist and select a task based on heuristics to kill.  This normally
-selects a rogue memory-hogging task that frees up a large amount of
-memory when killed.
+==============================================================
 
-If this is set to non-zero, the OOM killer simply kills the task that
-triggered the out-of-memory condition.  This avoids the expensive
-tasklist scan.
+nr_pdflush_threads
 
-If panic_on_oom is selected, it takes precedence over whatever value
-is used in oom_kill_allocating_task.
+The current number of pdflush threads.  This value is read-only.
+The value changes according to the number of dirty pages in the system.
 
-The default value is 0.
+When neccessary, additional pdflush threads are created, one per second, up to
+nr_pdflush_threads_max.
 
 ==============================================================
 
-mmap_min_addr
+nr_trim_pages
 
-This file indicates the amount of address space  which a user process will
-be restricted from mmaping.  Since kernel null dereference bugs could
-accidentally operate based on the information in the first couple of pages
-of memory userspace processes should not be allowed to write to them.  By
-default this value is set to 0 and no protections will be enforced by the
-security module.  Setting this value to something like 64k will allow the
-vast majority of applications to work correctly and provide defense in depth
-against future potential kernel bugs.
+This is available only on NOMMU kernels.
+
+This value adjusts the excess page trimming behaviour of power-of-2 aligned
+NOMMU mmap allocations.
+
+A value of 0 disables trimming of allocations entirely, while a value of 1
+trims excess pages aggressively. Any value >= 1 acts as the watermark where
+trimming of allocations is initiated.
+
+The default value is 1.
+
+See Documentation/nommu-mmap.txt for more information.
 
 ==============================================================
 
@@ -335,34 +421,199 @@ this is causing problems for your system
 
 ==============================================================
 
-nr_hugepages
+oom_dump_tasks
 
-Change the minimum size of the hugepage pool.
+Enables a system-wide task dump (excluding kernel threads) to be
+produced when the kernel performs an OOM-killing and includes such
+information as pid, uid, tgid, vm size, rss, cpu, oom_adj score, and
+name.  This is helpful to determine why the OOM killer was invoked
+and to identify the rogue task that caused it.
 
-See Documentation/vm/hugetlbpage.txt
+If this is set to zero, this information is suppressed.  On very
+large systems with thousands of tasks it may not be feasible to dump
+the memory state information for each one.  Such systems should not
+be forced to incur a performance penalty in OOM conditions when the
+information may not be desired.
+
+If this is set to non-zero, this information is shown whenever the
+OOM killer actually kills a memory-hogging task.
+
+The default value is 0.
 
 ==============================================================
 
-nr_overcommit_hugepages
+oom_kill_allocating_task
 
-Change the maximum size of the hugepage pool. The maximum is
-nr_hugepages + nr_overcommit_hugepages.
+This enables or disables killing the OOM-triggering task in
+out-of-memory situations.
 
-See Documentation/vm/hugetlbpage.txt
+If this is set to zero, the OOM killer will scan through the entire
+tasklist and select a task based on heuristics to kill.  This normally
+selects a rogue memory-hogging task that frees up a large amount of
+memory when killed.
+
+If this is set to non-zero, the OOM killer simply kills the task that
+triggered the out-of-memory condition.  This avoids the expensive
+tasklist scan.
+
+If panic_on_oom is selected, it takes precedence over whatever value
+is used in oom_kill_allocating_task.
+
+The default value is 0.
 
 ==============================================================
 
-nr_trim_pages
+overcommit_memory:
 
-This is available only on NOMMU kernels.
+This value contains a flag that enables memory overcommitment.
 
-This value adjusts the excess page trimming behaviour of power-of-2 aligned
-NOMMU mmap allocations.
+When this flag is 0, the kernel attempts to estimate the amount
+of free memory left when userspace requests more memory.
 
-A value of 0 disables trimming of allocations entirely, while a value of 1
-trims excess pages aggressively. Any value >= 1 acts as the watermark where
-trimming of allocations is initiated.
+When this flag is 1, the kernel pretends there is always enough
+memory until it actually runs out.
 
-The default value is 1.
+When this flag is 2, the kernel uses a "never overcommit"
+policy that attempts to prevent any overcommit of memory.
 
-See Documentation/nommu-mmap.txt for more information.
+This feature can be very useful because there are a lot of
+programs that malloc() huge amounts of memory "just-in-case"
+and don't use much of it.
+
+The default value is 0.
+
+See Documentation/vm/overcommit-accounting and
+security/commoncap.c::cap_vm_enough_memory() for more information.
+
+==============================================================
+
+overcommit_ratio:
+
+When overcommit_memory is set to 2, the committed address
+space is not permitted to exceed swap plus this percentage
+of physical RAM.  See above.
+
+==============================================================
+
+page-cluster
+
+page-cluster controls the number of pages which are written to swap in
+a single attempt.  The swap I/O size.
+
+It is a logarithmic value - setting it to zero means "1 page", setting
+it to 1 means "2 pages", setting it to 2 means "4 pages", etc.
+
+The default value is three (eight pages at a time).  There may be some
+small benefits in tuning this to a different value if your workload is
+swap-intensive.
+
+=============================================================
+
+panic_on_oom
+
+This enables or disables panic on out-of-memory feature.
+
+If this is set to 0, the kernel will kill some rogue process,
+called oom_killer.  Usually, oom_killer can kill rogue processes and
+system will survive.
+
+If this is set to 1, the kernel panics when out-of-memory happens.
+However, if a process limits using nodes by mempolicy/cpusets,
+and those nodes become memory exhaustion status, one process
+may be killed by oom-killer. No panic occurs in this case.
+Because other nodes' memory may be free. This means system total status
+may be not fatal yet.
+
+If this is set to 2, the kernel panics compulsorily even on the
+above-mentioned.
+
+The default value is 0.
+1 and 2 are for failover of clustering. Please select either
+according to your policy of failover.
+
+=============================================================
+
+percpu_pagelist_fraction
+
+This is the fraction of pages at most (high mark pcp->high) in each zone that
+are allocated for each per cpu page list.  The min value for this is 8.  It
+means that we don't allow more than 1/8th of pages in each zone to be
+allocated in any single per_cpu_pagelist.  This entry only changes the value
+of hot per cpu pagelists.  User can specify a number like 100 to allocate
+1/100th of each zone to each per cpu page list.
+
+The batch value of each per cpu pagelist is also updated as a result.  It is
+set to pcp->high/4.  The upper limit of batch is (PAGE_SHIFT * 8)
+
+The initial value is zero.  Kernel does not use this value at boot time to set
+the high water marks for each per cpu page list.
+
+==============================================================
+
+stat_interval
+
+The time interval between which vm statistics are updated.  The default
+is 1 second.
+
+==============================================================
+
+swappiness
+
+This control is used to define how aggressive the kernel will swap
+memory pages.  Higher values will increase agressiveness, lower values
+descrease the amount of swap.
+
+The default value is 60.
+
+==============================================================
+
+vfs_cache_pressure
+------------------
+
+Controls the tendency of the kernel to reclaim the memory which is used for
+caching of directory and inode objects.
+
+At the default value of vfs_cache_pressure=100 the kernel will attempt to
+reclaim dentries and inodes at a "fair" rate with respect to pagecache and
+swapcache reclaim.  Decreasing vfs_cache_pressure causes the kernel to prefer
+to retain dentry and inode caches.  Increasing vfs_cache_pressure beyond 100
+causes the kernel to prefer to reclaim dentries and inodes.
+
+==============================================================
+
+zone_reclaim_mode:
+
+Zone_reclaim_mode allows someone to set more or less aggressive approaches to
+reclaim memory when a zone runs out of memory. If it is set to zero then no
+zone reclaim occurs. Allocations will be satisfied from other zones / nodes
+in the system.
+
+This is value ORed together of
+
+1	= Zone reclaim on
+2	= Zone reclaim writes dirty pages out
+4	= Zone reclaim swaps pages
+
+zone_reclaim_mode is set during bootup to 1 if it is determined that pages
+from remote zones will cause a measurable performance reduction. The
+page allocator will then reclaim easily reusable pages (those page
+cache pages that are currently not used) before allocating off node pages.
+
+It may be beneficial to switch off zone reclaim if the system is
+used for a file server and all of memory should be used for caching files
+from disk. In that case the caching effect is more important than
+data locality.
+
+Allowing zone reclaim to write out pages stops processes that are
+writing large amounts of data from dirtying pages on other nodes. Zone
+reclaim will write out dirty pages if a zone fills up and so effectively
+throttle the process. This may decrease the performance of a single process
+since it cannot use all of system memory to buffer the outgoing writes
+anymore but it preserve the memory on other nodes so that the performance
+of other processes running on other nodes will not be affected.
+
+Allowing regular swap effectively restricts allocations to the local
+node unless explicitly overridden by memory policies or cpuset
+configurations.
+
+============ End of Document =================================
_

Patches currently in -mm which might be from pmorreale@novell.com are

update-of-documentation-vmtxt-and-proctxt.patch
mm-fix-pdflush-thread-creation-upper-bound.patch
mm-add-proc-controls-for-pdflush-threads.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch

