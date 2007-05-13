From: akpm@linux-foundation.org
Subject: - ubi-remove-inverted-check-in-ltree_entry_ctor.patch removed from -mm tree
Date: Sat, 12 May 2007 22:15:19 -0700
Message-ID: <200705130515.l4D5FJsa022767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbXEMFPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, Artem.Bityutskiy@nokia.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     ubi: remove inverted check in ltree_entry_ctor
has been removed from the -mm tree.  Its filename was
     ubi-remove-inverted-check-in-ltree_entry_ctor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ubi: remove inverted check in ltree_entry_ctor
From: Christoph Lameter <clameter@sgi.com>

Check is inverted and thus the ctor never does what it is supposed to do. 
The check is poinless since SLAB_CTOR_CONSTRUCTOR is always set.  So
remove.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/ubi/eba.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/mtd/ubi/eba.c~ubi-remove-inverted-check-in-ltree_entry_ctor drivers/mtd/ubi/eba.c
--- a/drivers/mtd/ubi/eba.c~ubi-remove-inverted-check-in-ltree_entry_ctor
+++ a/drivers/mtd/ubi/eba.c
@@ -940,9 +940,6 @@ static void ltree_entry_ctor(void *obj, 
 {
 	struct ltree_entry *le = obj;
 
-	if (flags & SLAB_CTOR_CONSTRUCTOR)
-		return;
-
 	le->users = 0;
 	init_rwsem(&le->mutex);
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
