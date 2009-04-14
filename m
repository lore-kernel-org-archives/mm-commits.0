From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-documentation.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:09 -0700
Message-ID: <200904141950.n3EJo9IN020004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbZDNTx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:53:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix documentation
has been removed from the -mm tree.  Its filename was
     memcg-fix-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix documentation
From: Bharata B Rao <bharata@linux.vnet.ibm.com>

The description about various statistics from memory.stat is not accurate
and confusing at times.

Correct this along with a few other minor cleanups.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   53 ++++++++++++++++-------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-fix-documentation Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-fix-documentation
+++ a/Documentation/cgroups/memory.txt
@@ -6,15 +6,14 @@ used here with the memory controller tha
 
 Salient features
 
-a. Enable control of both RSS (mapped) and Page Cache (unmapped) pages
+a. Enable control of Anonymous, Page Cache (mapped and unmapped) and
+   Swap Cache memory pages.
 b. The infrastructure allows easy addition of other types of memory to control
 c. Provides *zero overhead* for non memory controller users
 d. Provides a double LRU: global memory pressure causes reclaim from the
    global LRU; a cgroup on hitting a limit, reclaims from the per
    cgroup LRU
 
-NOTE: Swap Cache (unmapped) is not accounted now.
-
 Benefits and Purpose of the memory controller
 
 The memory controller isolates the memory behaviour of a group of tasks
@@ -290,34 +289,44 @@ will be charged as a new owner of it.
   moved to the parent. If you want to avoid that, force_empty will be useful.
 
 5.2 stat file
-  memory.stat file includes following statistics (now)
-	cache			- # of pages from page-cache and shmem.
-	rss			- # of pages from anonymous memory.
-	pgpgin			- # of event of charging
-	pgpgout			- # of event of uncharging
-	active_anon		- # of pages on active lru of anon, shmem.
-	inactive_anon 		- # of pages on active lru of anon, shmem
-	active_file		- # of pages on active lru of file-cache
-	inactive_file		- # of pages on inactive lru of file cache
-	unevictable		- # of pages cannot be reclaimed.(mlocked etc)
-
-	Below is depend on CONFIG_DEBUG_VM.
-	inactive_ratio		- VM internal parameter. (see mm/page_alloc.c)
-	recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
-	recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
-	recent_scanned_anon 	- VM internal parameter. (see mm/vmscan.c)
-	recent_scanned_file 	- VM internal parameter. (see mm/vmscan.c)
 
-  Memo:
+memory.stat file includes following statistics
+
+cache		- # of bytes of page cache memory.
+rss		- # of bytes of anonymous and swap cache memory.
+pgpgin		- # of pages paged in (equivalent to # of charging events).
+pgpgout		- # of pages paged out (equivalent to # of uncharging events).
+active_anon	- # of bytes of anonymous and  swap cache memory on active
+		  lru list.
+inactive_anon	- # of bytes of anonymous memory and swap cache memory on
+		  inactive lru list.
+active_file	- # of bytes of file-backed memory on active lru list.
+inactive_file	- # of bytes of file-backed memory on inactive lru list.
+unevictable	- # of bytes of memory that cannot be reclaimed (mlocked etc).
+
+The following additional stats are dependent on CONFIG_DEBUG_VM.
+
+inactive_ratio		- VM internal parameter. (see mm/page_alloc.c)
+recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
+recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
+recent_scanned_anon	- VM internal parameter. (see mm/vmscan.c)
+recent_scanned_file	- VM internal parameter. (see mm/vmscan.c)
+
+Memo:
 	recent_rotated means recent frequency of lru rotation.
 	recent_scanned means recent # of scans to lru.
 	showing for better debug please see the code for meanings.
 
+Note:
+	Only anonymous and swap cache memory is listed as part of 'rss' stat.
+	This should not be confused with the true 'resident set size' or the
+	amount of physical memory used by the cgroup. Per-cgroup rss
+	accounting is not done yet.
 
 5.3 swappiness
   Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
 
-  Following cgroup's swapiness can't be changed.
+  Following cgroups' swapiness can't be changed.
   - root cgroup (uses /proc/sys/vm/swappiness).
   - a cgroup which uses hierarchy and it has child cgroup.
   - a cgroup which uses hierarchy and not the root of hierarchy.
_

Patches currently in -mm which might be from bharata@linux.vnet.ibm.com are

origin.patch

