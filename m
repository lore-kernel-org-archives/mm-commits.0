From: akpm@linux-foundation.org
Subject: + memcg-document-cgroup-dirty-memory-interfaces.patch added to -mm tree
Date: Fri, 29 Oct 2010 13:19:39 -0700
Message-ID: <201010292019.o9TKJdEL014947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761807Ab0J2UUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 16:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: document cgroup dirty memory interfaces
has been added to the -mm tree.  Its filename is
     memcg-document-cgroup-dirty-memory-interfaces.patch

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
Subject: memcg: document cgroup dirty memory interfaces
From: Greg Thelen <gthelen@google.com>

Document cgroup dirty memory interfaces and statistics.

Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   73 +++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

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
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
@@ -406,6 +410,9 @@ total_mapped_file	- sum of all children'
 total_pgpgin		- sum of all children's "pgpgin"
 total_pgpgout		- sum of all children's "pgpgout"
 total_swap		- sum of all children's "swap"
+total_dirty		- sum of all children's "dirty"
+total_writeback		- sum of all children's "writeback"
+total_nfs_unstable	- sum of all children's "nfs_unstable"
 total_inactive_anon	- sum of all children's "inactive_anon"
 total_active_anon	- sum of all children's "active_anon"
 total_inactive_file	- sum of all children's "inactive_file"
@@ -453,6 +460,72 @@ memory under it will be reclaimed.
 You can reset failcnt by writing 0 to failcnt file.
 # echo 0 > .../memory.failcnt
 
+5.5 dirty memory
+
+Control the maximum amount of dirty pages a cgroup can have at any given time.
+
+Limiting dirty memory is like fixing the max amount of dirty (hard to reclaim)
+page cache used by a cgroup.  So, in case of multiple cgroup writers, they will
+not be able to consume more than their designated share of dirty pages and will
+be forced to perform write-out if they cross that limit.
+
+The interface is equivalent to the procfs interface: /proc/sys/vm/dirty_*.  It
+is possible to configure a limit to trigger both a direct writeback or a
+background writeback performed by per-bdi flusher threads.  The root cgroup
+memory.dirty_* control files are read-only and match the contents of
+the /proc/sys/vm/dirty_* files.
+
+Per-cgroup dirty limits can be set using the following files in the cgroupfs:
+
+- memory.dirty_ratio: the amount of dirty memory (expressed as a percentage of
+  cgroup memory) at which a process generating dirty pages will itself start
+  writing out dirty data.
+
+- memory.dirty_limit_in_bytes: the amount of dirty memory (expressed in bytes)
+  in the cgroup at which a process generating dirty pages will start itself
+  writing out dirty data.  Suffix (k, K, m, M, g, or G) can be used to indicate
+  that value is kilo, mega or gigabytes.
+
+  Note: memory.dirty_limit_in_bytes is the counterpart of memory.dirty_ratio.
+  Only one of them may be specified at a time.  When one is written it is
+  immediately taken into account to evaluate the dirty memory limits and the
+  other appears as 0 when read.
+
+- memory.dirty_background_ratio: the amount of dirty memory of the cgroup
+  (expressed as a percentage of cgroup memory) at which background writeback
+  kernel threads will start writing out dirty data.
+
+- memory.dirty_background_limit_in_bytes: the amount of dirty memory (expressed
+  in bytes) in the cgroup at which background writeback kernel threads will
+  start writing out dirty data.  Suffix (k, K, m, M, g, or G) can be used to
+  indicate that value is kilo, mega or gigabytes.
+
+  Note: memory.dirty_background_limit_in_bytes is the counterpart of
+  memory.dirty_background_ratio.  Only one of them may be specified at a time.
+  When one is written it is immediately taken into account to evaluate the dirty
+  memory limits and the other appears as 0 when read.
+
+A cgroup may contain more dirty memory than its dirty limit.  This is possible
+because of the principle that the first cgroup to touch a page is charged for
+it.  Subsequent page counting events (dirty, writeback, nfs_unstable) are also
+counted to the originally charged cgroup.
+
+Example: If page is allocated by a cgroup A task, then the page is charged to
+cgroup A.  If the page is later dirtied by a task in cgroup B, then the cgroup A
+dirty count will be incremented.  If cgroup A is over its dirty limit but cgroup
+B is not, then dirtying a cgroup A page from a cgroup B task may push cgroup A
+over its dirty limit without throttling the dirtying cgroup B task.
+
+When use_hierarchy=0, each cgroup has dirty memory usage and limits.
+System-wide dirty limits are also consulted.  Dirty memory consumption is
+checked against both system-wide and per-cgroup dirty limits.
+
+The current implementation does enforce per-cgroup dirty limits when
+use_hierarchy=1.  System-wide dirty limits are used for processes in such
+cgroups.  Attempts to read memory.dirty_* files return the system-wide values.
+Writes to the memory.dirty_* files return error.  An enhanced implementation is
+needed to check the chain of parents to ensure that no dirty limit is exceeded.
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch

