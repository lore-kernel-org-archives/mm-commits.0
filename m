From: akpm@linux-foundation.org
Subject: - slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:27 -0700
Message-ID: <200705180705.l4I75Qrf010093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755629AbXERHHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLAB: Move two remaining SLAB specific definitions to slab_def.h
has been removed from the -mm tree.  Its filename was
     slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLAB: Move two remaining SLAB specific definitions to slab_def.h
From: Christoph Lameter <clameter@sgi.com>

Two definitions remained in slab.h that are particular to the SLAB allocator.
Move to slab_def.h

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h     |    3 ---
 include/linux/slab_def.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/slab.h~slab-move-two-remaining-slab-specific-definitions-to-slab_defh include/linux/slab.h
--- a/include/linux/slab.h~slab-move-two-remaining-slab-specific-definitions-to-slab_defh
+++ a/include/linux/slab.h
@@ -233,9 +233,6 @@ extern void *__kmalloc_node_track_caller
 
 #endif /* DEBUG_SLAB */
 
-extern const struct seq_operations slabinfo_op;
-ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
-
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SLAB_H */
 
diff -puN include/linux/slab_def.h~slab-move-two-remaining-slab-specific-definitions-to-slab_defh include/linux/slab_def.h
--- a/include/linux/slab_def.h~slab-move-two-remaining-slab-specific-definitions-to-slab_defh
+++ a/include/linux/slab_def.h
@@ -109,4 +109,7 @@ found:
 
 #endif	/* CONFIG_NUMA */
 
+extern const struct seq_operations slabinfo_op;
+ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
+
 #endif	/* _LINUX_SLAB_DEF_H */
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-another-slabinfo-fix.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
revoke-core-code.patch
