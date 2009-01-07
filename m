From: akpm@linux-foundation.org
Subject: - memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:08:33 -0800
Message-ID: <200901072308.n07N8XAS027013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbZAGXIm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:08:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-introduce-charge-commit-cancel-style-of-functions-fix
has been removed from the -mm tree.  Its filename was
     memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch

This patch was dropped because it was folded into memcg-introduce-charge-commit-cancel-style-of-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-introduce-charge-commit-cancel-style-of-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

include/linux/memcontrol.h:105: warning: 'mem_cgroup_try_charge' defined but not used
include/linux/memcontrol.h:111: warning: 'mem_cgroup_commit_charge_swapin' defined but not used
include/linux/memcontrol.h:114: warning: 'mem_cgroup_cancel_charge_swapin' defined but not used
include/linux/memcontrol.h:105: warning: 'mem_cgroup_try_charge' defined but not used
include/linux/memcontrol.h:111: warning: 'mem_cgroup_commit_charge_swapin' defined but not used
include/linux/memcontrol.h:114: warning: 'mem_cgroup_cancel_charge_swapin' defined but not used

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-introduce-charge-commit-cancel-style-of-functions-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-introduce-charge-commit-cancel-style-of-functions-fix
+++ a/include/linux/memcontrol.h
@@ -100,17 +100,18 @@ static inline int mem_cgroup_charge_migr
 	return 0;
 }
 
-static int mem_cgroup_try_charge(struct mm_struct *mm,
+static inline int mem_cgroup_try_charge(struct mm_struct *mm,
 				gfp_t gfp_mask, struct mem_cgroup **ptr)
 {
 	return 0;
 }
 
-static void mem_cgroup_commit_charge_swapin(struct page *page,
+static inline void mem_cgroup_commit_charge_swapin(struct page *page,
 					  struct mem_cgroup *ptr)
 {
 }
-static void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *ptr)
+
+static inline void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *ptr)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

