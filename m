From: akpm@linux-foundation.org
Subject: [folded] memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 15:59:11 -0700
Message-ID: <201103222259.p2MMxCwO032716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828Ab1CVW75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 18:59:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mincha


The patch titled
     memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix
has been removed from the -mm tree.  Its filename was
     memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix.patch

This patch was dropped because it was folded into memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix patch ordering

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix
+++ a/mm/memcontrol.c
@@ -851,7 +851,7 @@ void mem_cgroup_rotate_reclaimable_page(
 	smp_rmb();
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
-	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
+	mz = page_cgroup_zoneinfo(pc);
 	list_move_tail(&pc->lru, &mz->lists[lru]);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-batch-free-pcp-list-if-possible.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

