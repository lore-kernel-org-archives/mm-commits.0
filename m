From: akpm@linux-foundation.org
Subject: - memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:09:40 -0800
Message-ID: <200901072309.n07N9e3n027893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913AbZAGXKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:10:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg-new-force_empty-to-free-pages-under-group-fix-fix
has been removed from the -mm tree.  Its filename was
     memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch

This patch was dropped because it was folded into memcg-new-force_empty-to-free-pages-under-group.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-new-force_empty-to-free-pages-under-group-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

be less weird.

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-new-force_empty-to-free-pages-under-group-fix-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-new-force_empty-to-free-pages-under-group-fix-fix
+++ a/mm/memcontrol.c
@@ -1113,9 +1113,7 @@ out:
 
 try_to_free:
 	/* returns EBUSY if there is a task or if we come here twice. */
-	if (cgroup_task_count(cgrp)
-	    || !list_empty(&cgrp->children)
-	    || shrink) {
+	if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children) || shrink) {
 		ret = -EBUSY;
 		goto out;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-new-force_empty-to-free-pages-under-group.patch
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

