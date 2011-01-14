From: akpm@linux-foundation.org
Subject: [merged] memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:32 -0800
Message-ID: <201101142252.p0EMqMm8005613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commi


The patch titled
     memcg: add page_cgroup flags for dirty page tracking
has been removed from the -mm tree.  Its filename was
     memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add page_cgroup flags for dirty page tracking
From: Greg Thelen <gthelen@google.com>

This patchset provides the ability for each cgroup to have independent
dirty page limits.

Limiting dirty memory is like fixing the max amount of dirty (hard to
reclaim) page cache used by a cgroup.  So, in case of multiple cgroup
writers, they will not be able to consume more than their designated share
of dirty pages and will be forced to perform write-out if they cross that
limit.

The patches are based on a series proposed by Andrea Righi in Mar 2010.

Overview:

- Add page_cgroup flags to record when pages are dirty, in writeback, or nfs
  unstable.

- Extend mem_cgroup to record the total number of pages in each of the 
  interesting dirty states (dirty, writeback, unstable_nfs).  

- Add dirty parameters similar to the system-wide  /proc/sys/vm/dirty_*
  limits to mem_cgroup.  The mem_cgroup dirty parameters are accessible
  via cgroupfs control files.

- Consider both system and per-memcg dirty limits in page writeback when
  deciding to queue background writeback or block for foreground writeback.

Known shortcomings:

- When a cgroup dirty limit is exceeded, then bdi writeback is employed to
  writeback dirty inodes.  Bdi writeback considers inodes from any cgroup, not
  just inodes contributing dirty pages to the cgroup exceeding its limit.  

- When memory.use_hierarchy is set, then dirty limits are disabled.  This is a
  implementation detail.  An enhanced implementation is needed to check the
  chain of parents to ensure that no dirty limit is exceeded.

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
  --repeat 3".  The -a option was used for parallel (p_*) runs.

- All numbers are page fault rate (M/sec).  Higher is better.

- To compare the performance of a kernel without non-memcg compare the first and
  last rows, neither has memcg configured.  The first row does not include any
  of these memcg patches.

- To compare the performance of using memcg dirty limits, compare the baseline
  (2nd row titled "w/ memcg") with the the code and memcg enabled (2nd to last
  row titled "all patches").

                           root_cgroup                    child_cgroup
                 s_read s_write p_read p_write   s_read s_write p_read p_write
mmotm w/o memcg   0.428  0.390   0.429  0.388
mmotm w/ memcg    0.411  0.378   0.391  0.362     0.412  0.377   0.385  0.363
all patches       0.384  0.360   0.370  0.348     0.381  0.363   0.368  0.347
all patches       0.431  0.402   0.427  0.395
  w/o memcg



This patch:

Add additional flags to page_cgroup to track dirty pages within a
mem_cgroup.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN include/linux/page_cgroup.h~memcg-add-page_cgroup-flags-for-dirty-page-tracking include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-add-page_cgroup-flags-for-dirty-page-tracking
+++ a/include/linux/page_cgroup.h
@@ -40,6 +40,9 @@ enum {
 	PCG_USED, /* this object is in use. */
 	PCG_ACCT_LRU, /* page has been accounted for */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
+	PCG_FILE_DIRTY, /* page is dirty */
+	PCG_FILE_WRITEBACK, /* page is under writeback */
+	PCG_FILE_UNSTABLE_NFS, /* page is NFS unstable */
 	PCG_MIGRATION, /* under page migration */
 };
 
@@ -59,6 +62,10 @@ static inline void ClearPageCgroup##unam
 static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
 
+#define TESTSETPCGFLAG(uname, lname)			\
+static inline int TestSetPageCgroup##uname(struct page_cgroup *pc)	\
+	{ return test_and_set_bit(PCG_##lname, &pc->flags);  }
+
 /* Cache flag is set only once (at allocation) */
 TESTPCGFLAG(Cache, CACHE)
 CLEARPCGFLAG(Cache, CACHE)
@@ -78,6 +85,22 @@ SETPCGFLAG(FileMapped, FILE_MAPPED)
 CLEARPCGFLAG(FileMapped, FILE_MAPPED)
 TESTPCGFLAG(FileMapped, FILE_MAPPED)
 
+SETPCGFLAG(FileDirty, FILE_DIRTY)
+CLEARPCGFLAG(FileDirty, FILE_DIRTY)
+TESTPCGFLAG(FileDirty, FILE_DIRTY)
+TESTCLEARPCGFLAG(FileDirty, FILE_DIRTY)
+TESTSETPCGFLAG(FileDirty, FILE_DIRTY)
+
+SETPCGFLAG(FileWriteback, FILE_WRITEBACK)
+CLEARPCGFLAG(FileWriteback, FILE_WRITEBACK)
+TESTPCGFLAG(FileWriteback, FILE_WRITEBACK)
+
+SETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+CLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+TESTPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+TESTCLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+TESTSETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+
 SETPCGFLAG(Migration, MIGRATION)
 CLEARPCGFLAG(Migration, MIGRATION)
 TESTPCGFLAG(Migration, MIGRATION)
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch

