From: akpm@linux-foundation.org
Subject: - slub-another-slabinfo-fix.patch removed from -mm tree
Date: Sat, 19 May 2007 10:18:11 -0700
Message-ID: <200705191718.l4JHIAtt006994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41721 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755761AbXESRTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 13:19:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: another slabinfo fix
has been removed from the -mm tree.  Its filename was
     slub-another-slabinfo-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slub: another slabinfo fix
From: Christoph Lameter <clameter@sgi.com>

The slab manipulation functions should not be triggered by slabs
that are unresovable in the subset of slabs selected on the command line.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slabinfo.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN Documentation/vm/slabinfo.c~slub-another-slabinfo-fix Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~slub-another-slabinfo-fix
+++ a/Documentation/vm/slabinfo.c
@@ -262,11 +262,17 @@ void decode_numa_list(int *numa, char *t
 
 void slab_validate(struct slabinfo *s)
 {
+	if (strcmp(s->name, "*") == 0)
+		return;
+
 	set_obj(s, "validate", 1);
 }
 
 void slab_shrink(struct slabinfo *s)
 {
+	if (strcmp(s->name, "*") == 0)
+		return;
+
 	set_obj(s, "shrink", 1);
 }
 
@@ -550,6 +556,9 @@ int slab_empty(struct slabinfo *s)
 
 void slab_debug(struct slabinfo *s)
 {
+	if (strcmp(s->name, "*") == 0)
+		return;
+
 	if (sanity && !s->sanity_checks) {
 		set_obj(s, "sanity", 1);
 	}
_

Patches currently in -mm which might be from clameter@sgi.com are

git-ubi.patch
quicklist-support-for-x86_64.patch
slub-debug-fix-check-for-super-sized-slabs-512k-64bit-256k.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
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
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
