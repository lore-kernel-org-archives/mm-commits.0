From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-document-cgroup-dirty-memory-interfaces.patch removed from -mm tree
Date: Tue, 29 Mar 2011 16:11:43 -0700
Message-ID: <201103292311.p2TNBi0i011238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab1C2XMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Mar 2011 19:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, ctalbott@google.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.co


The patch titled
     memcg: document cgroup dirty memory interfaces
has been removed from the -mm tree.  Its filename was
     memcg-document-cgroup-dirty-memory-interfaces.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: document cgroup dirty memory interfaces
From: Greg Thelen <gthelen@google.com>

This patchset provides the ability for each cgroup to have independent
dirty page limits.

Limiting dirty memory is like fixing the max amount of dirty (hard to
reclaim) page cache used by a cgroup.  So, in case of multiple cgroup
writers, they will not be able to consume more than their designated share
of dirty pages and will be throttled if they cross that limit.

Example use case:
  #!/bin/bash
  #
  # Here is a test script that shows a situation where memcg dirty limits are
  # beneficial.
  #
  # The script runs two programs:
  # 1) a dirty page background antagonist (dd)
  # 2) an interactive foreground process (tar).
  #
  # If the script's argument is false, then both processes are run together in
  # the root cgroup sharing system-wide dirty memory in classic fashion.  If the
  # script is given a true argument, then a cgroup is used to contain dd dirty
  # page consumption.  The cgroup isolates the dd dirty memory consumption from
  # the rest of the system processes (tar in this case).
  #
  # The time used by the tar process is printed (lower is better).
  #
  # The tar process had faster and more predictable performance.  memcg dirty
  # ratios might be useful to serve different task classes (interactive vs
  # batch).  A past discussion touched on this:
  # http://lkml.org/lkml/2010/5/20/136
  #
  # When called with 'false' (using memcg without dirty isolation):
  #  tar takes 8s
  #  dd reports 69 MB/s
  #
  # When called with 'true' (using memcg for dirty isolation):
  #  tar takes 6s
  #  dd reports 66 MB/s
  #
  echo memcg_dirty_limits: $1
  
  # Declare system limits.
  echo $((1<<30)) > /proc/sys/vm/dirty_bytes
  echo $((1<<29)) > /proc/sys/vm/dirty_background_bytes
  
  mkdir /dev/cgroup/memory/A
  
  # start antagonist
  if $1; then    # if using cgroup to contain 'dd'...
    echo 400M > /dev/cgroup/memory/A/memory.dirty_limit_in_bytes
  fi
  
  (echo $BASHPID > /dev/cgroup/memory/A/tasks; \
   dd if=/dev/zero of=big.file count=10k bs=1M) &
  
  # let antagonist get warmed up
  sleep 10
  
  # time interactive job
  time tar -xzf linux.tar.gz
  
  wait
  sleep 10
  rmdir /dev/cgroup/memory/A


The patches are based on a series proposed by Andrea Righi in Mar 2010.


Overview:

- Add page_cgroup flags to record when pages are dirty, in writeback, or
  nfs unstable.

- Extend mem_cgroup to record the total number of pages in each of the
  interesting dirty states (dirty, writeback, unstable_nfs).  

- Add dirty parameters similar to the system-wide /proc/sys/vm/dirty_*
  limits to mem_cgroup.  The mem_cgroup dirty parameters are accessible
  via cgroupfs control files.

- Consider both system and per-memcg dirty limits in page writeback when
  deciding to queue background writeback or throttle dirty memory
  production.

Known shortcomings (see the patch 1/9 update to
Documentation/cgroups/memory.txt for more details):

- When a cgroup dirty limit is exceeded, then bdi writeback is employed
  to writeback dirty inodes.  Bdi writeback considers inodes from any
  cgroup, not just inodes contributing dirty pages to the cgroup exceeding
  its limit.  

- A cgroup may exceed its dirty limit if the memory is dirtied by a
  process in a different memcg.

Performance data:
- A page fault microbenchmark workload was used to measure performance, which
  can be called in read or write mode:
        f = open(foo. $cpu)
        truncate(f, 4096)
        alarm(60)
        while (1) {
                p = mmap(f, 4096)
                if (write)
			*p = 1
		else
			x = *p
                munmap(p)
        }

- The workload was called for several points in the patch series in different
  modes:

  - s_read is a single threaded reader
  - s_write is a single threaded writer
  - p_read is a 16 thread reader, each operating on a different file
  - p_write is a 16 thread writer, each operating on a different file

- Measurements were collected on a 16 core non-numa system using "perf stat
  --repeat 3".

- All numbers are page fault rate (M/sec).  Higher is better.

- To compare the performance of a kernel without memcg compare the first
  and last rows - neither has memcg configured.  The first row does not
  include any of these memcg dirty limit patches.

- To compare the performance of using memcg dirty limits, compare the
  memcg baseline (2nd row titled "mmotm w/ memcg") with the 3rd row (memcg
  enabled with all patches).

                          root_cgroup                     child_cgroup
                 s_read s_write p_read p_write   s_read s_write p_read p_write
mmotm w/o memcg   0.313  0.271   0.307  0.267
mmotm w/  memcg   0.311  0.280   0.303  0.268     0.317  0.278   0.299  0.266
all patches       0.315  0.283   0.303  0.267     0.318  0.279   0.307  0.267
all patches       0.324  0.277   0.315  0.273
  w/o memcg


This patch:

Document cgroup dirty memory interfaces and statistics.

Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>
Cc: Justin TerAvest <teravest@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   80 +++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-document-cgroup-dirty-memory-interfaces Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-document-cgroup-dirty-memory-interfaces
+++ a/Documentation/cgroups/memory.txt
@@ -385,6 +385,10 @@ mapped_file	- # of bytes of mapped file 
 pgpgin		- # of pages paged in (equivalent to # of charging events).
 pgpgout		- # of pages paged out (equivalent to # of uncharging events).
 swap		- # of bytes of swap usage
+dirty		- # of bytes that are waiting to get written back to the disk.
+writeback	- # of bytes that are actively being written back to the disk.
+nfs_unstable	- # of bytes sent to the NFS server, but not yet committed to
+		the actual storage.
 pgfault		- # of page faults.
 pgmajfault	- # of major page faults.
 soft_steal	- # of pages reclaimed from global hierarchical reclaim
@@ -410,6 +414,9 @@ total_mapped_file	- sum of all children'
 total_pgpgin		- sum of all children's "pgpgin"
 total_pgpgout		- sum of all children's "pgpgout"
 total_swap		- sum of all children's "swap"
+total_dirty		- sum of all children's "dirty"
+total_writeback		- sum of all children's "writeback"
+total_nfs_unstable	- sum of all children's "nfs_unstable"
 total_pgfault		- sum of all children's "pgfault"
 total_pgmajfault	- sum of all children's "pgmajfault"
 total_soft_steal	- sum of all children's "soft_steal"
@@ -461,6 +468,79 @@ memory under it will be reclaimed.
 You can reset failcnt by writing 0 to failcnt file.
 # echo 0 > .../memory.failcnt
 
+5.5 dirty memory
+
+Control the maximum amount of dirty pages a cgroup can have at any given time.
+
+Limiting dirty memory is like fixing the max amount of dirty (hard to reclaim)
+page cache used by a cgroup.  So, in case of multiple cgroup writers, they will
+not be able to consume more than their designated share of dirty pages and will
+be throttled if they cross that limit.  System-wide dirty limits are also
+consulted.  Dirty memory consumption is checked against both system-wide and
+per-cgroup dirty limits.
+
+The interface is similar to the procfs interface: /proc/sys/vm/dirty_*.  It is
+possible to configure a limit to trigger throttling of a dirtier or queue
+background writeback.  The root cgroup memory.dirty_* control files are
+read-only and match the contents of the /proc/sys/vm/dirty_* files.
+
+Per-cgroup dirty limits can be set using the following files in the cgroupfs:
+
+- memory.dirty_ratio: the amount of dirty memory (expressed as a percentage of
+  cgroup memory) at which a process generating dirty pages will be throttled.
+  The default value is the system-wide dirty ratio, /proc/sys/vm/dirty_ratio.
+
+- memory.dirty_limit_in_bytes: the amount of dirty memory (expressed in bytes)
+  in the cgroup at which a process generating dirty pages will be throttled.
+  Suffix (k, K, m, M, g, or G) can be used to indicate that value is kilo, mega
+  or gigabytes.  The default value is the system-wide dirty limit,
+  /proc/sys/vm/dirty_bytes.
+
+  Note: memory.dirty_limit_in_bytes is the counterpart of memory.dirty_ratio.
+  Only one may be specified at a time.  When one is written it is immediately
+  taken into account to evaluate the dirty memory limits and the other appears
+  as 0 when read.
+
+- memory.dirty_background_ratio: the amount of dirty memory of the cgroup
+  (expressed as a percentage of cgroup memory) at which background writeback
+  kernel threads will start writing out dirty data.  The default value is the
+  system-wide background dirty ratio, /proc/sys/vm/dirty_background_ratio.
+
+- memory.dirty_background_limit_in_bytes: the amount of dirty memory (expressed
+  in bytes) in the cgroup at which background writeback kernel threads will
+  start writing out dirty data.  Suffix (k, K, m, M, g, or G) can be used to
+  indicate that value is kilo, mega or gigabytes.  The default value is the
+  system-wide dirty background limit, /proc/sys/vm/dirty_background_bytes.
+
+  Note: memory.dirty_background_limit_in_bytes is the counterpart of
+  memory.dirty_background_ratio.  Only one may be specified at a time.  When one
+  is written it is immediately taken into account to evaluate the dirty memory
+  limits and the other appears as 0 when read.
+
+A cgroup may contain more dirty memory than its dirty limit.  This is possible
+because of the principle that the first cgroup to touch a page is charged for
+it.  Subsequent page counting events (dirty, writeback, nfs_unstable) are also
+counted to the originally charged cgroup.  Example: If page is allocated by a
+cgroup A task, then the page is charged to cgroup A.  If the page is later
+dirtied by a task in cgroup B, then the cgroup A dirty count will be
+incremented.  If cgroup A is over its dirty limit but cgroup B is not, then
+dirtying a cgroup A page from a cgroup B task may push cgroup A over its dirty
+limit without throttling the dirtying cgroup B task.
+
+When use_hierarchy=0, each cgroup has independent dirty memory usage and limits.
+When use_hierarchy=1 the dirty limits of parents cgroups are also checked to
+ensure that no dirty limit is exceeded.
+
+5.5.1 Inode writeback issue
+
+When a memcg dirty limit is exceeded, then bdi writeback is employed to
+writeback dirty inodes.  Bdi writeback considers inodes from any memcg, not just
+inodes contributing dirty pages to the memcg exceeding its limit.  Ideally when
+a memcg dirty limit is exceeded only inodes contributing dirty pages to that
+memcg would be considered for writeback.  However, the current implementation
+does not behave this way because there is no way to quickly check the memcgs
+that an inode contributes dirty pages to.
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

