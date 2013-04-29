From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-relax-memcg-iter-caching-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:44:02 -0700
Message-ID: <20130429214402.80A335A42D5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41999 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759375Ab3D2VoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:44:03 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so712237qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:44:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-relax-memcg-iter-caching-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-relax-memcg-iter-caching-checkpatch-fixes.patch

This patch was dropped because it was folded into memcg-relax-memcg-iter-caching.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-relax-memcg-iter-caching-checkpatch-fixes

ERROR: code indent should use tabs where possible
#135: FILE: mm/memcontrol.c:1135:
+                         * If the dead_count mismatches, a destruction$

ERROR: code indent should use tabs where possible
#136: FILE: mm/memcontrol.c:1136:
+                         * has happened or is happening concurrently.$

ERROR: code indent should use tabs where possible
#137: FILE: mm/memcontrol.c:1137:
+                         * If the dead_count matches, a destruction$

ERROR: code indent should use tabs where possible
#138: FILE: mm/memcontrol.c:1138:
+                         * might still happen concurrently, but since$

ERROR: code indent should use tabs where possible
#139: FILE: mm/memcontrol.c:1139:
+                         * we checked under RCU, that destruction$

ERROR: code indent should use tabs where possible
#140: FILE: mm/memcontrol.c:1140:
+                         * won't free the object until we release the$

ERROR: code indent should use tabs where possible
#141: FILE: mm/memcontrol.c:1141:
+                         * RCU reader lock.  Thus, the dead_count$

ERROR: code indent should use tabs where possible
#142: FILE: mm/memcontrol.c:1142:
+                         * check verifies the pointer is still valid,$

ERROR: code indent should use tabs where possible
#143: FILE: mm/memcontrol.c:1143:
+                         * css_tryget() verifies the cgroup pointed to$

ERROR: code indent should use tabs where possible
#144: FILE: mm/memcontrol.c:1144:
+                         * is alive.$

total: 10 errors, 0 warnings, 130 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/memcg-relax-memcg-iter-caching.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-relax-memcg-iter-caching-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-relax-memcg-iter-caching-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -1132,16 +1132,16 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			}
 
 			/*
-                         * If the dead_count mismatches, a destruction
-                         * has happened or is happening concurrently.
-                         * If the dead_count matches, a destruction
-                         * might still happen concurrently, but since
-                         * we checked under RCU, that destruction
-                         * won't free the object until we release the
-                         * RCU reader lock.  Thus, the dead_count
-                         * check verifies the pointer is still valid,
-                         * css_tryget() verifies the cgroup pointed to
-                         * is alive.
+			 * If the dead_count mismatches, a destruction
+			 * has happened or is happening concurrently.
+			 * If the dead_count matches, a destruction
+			 * might still happen concurrently, but since
+			 * we checked under RCU, that destruction
+			 * won't free the object until we release the
+			 * RCU reader lock.  Thus, the dead_count
+			 * check verifies the pointer is still valid,
+			 * css_tryget() verifies the cgroup pointed to
+			 * is alive.
 			 */
 			dead_count = atomic_read(&root->dead_count);
 			smp_rmb();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

