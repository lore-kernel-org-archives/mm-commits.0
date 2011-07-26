From: akpm@linux-foundation.org
Subject: [folded] memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:54:32 -0700
Message-ID: <201107262254.p6QMsXgF014478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160Ab1GZWzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg-consolidates-memory-cgroup-lru-stat-functions-fix
has been removed from the -mm tree.  Its filename was
     memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch

This patch was dropped because it was folded into memcg-consolidates-memory-cgroup-lru-stat-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-consolidates-memory-cgroup-lru-stat-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/vmscan.c: In function 'zone_nr_lru_pages':
mm/vmscan.c:175: warning: passing argument 2 of 'mem_cgroup_zone_nr_lru_pages' makes pointer from integer without a cast
include/linux/memcontrol.h:307: note: expected 'struct zone *' but argument is of type 'int'
mm/vmscan.c:175: error: too many arguments to function 'mem_cgroup_zone_nr_lru_pages'

Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-consolidates-memory-cgroup-lru-stat-functions-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-consolidates-memory-cgroup-lru-stat-functions-fix
+++ a/include/linux/memcontrol.h
@@ -304,8 +304,8 @@ mem_cgroup_inactive_file_is_low(struct m
 }
 
 static inline unsigned long
-mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, struct zone *zone,
-			     enum lru_list lru)
+mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
+				unsigned int lru_mask)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch

