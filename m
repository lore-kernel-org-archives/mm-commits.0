From: akpm@linux-foundation.org
Subject: - slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 01:46:26 -0700
Message-ID: <200705090846.l498kQjQ018349@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756053AbXEIIq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: include lifetime stats and sets of cpus / nodes in tracking output (fix)
has been removed from the -mm tree.  Its filename was
     slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch

This patch was dropped because it was folded into slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch

------------------------------------------------------
Subject: SLUB: include lifetime stats and sets of cpus / nodes in tracking output (fix)
From: Christoph Lameter <clameter@sgi.com>

32 bit cannot perform 64 bit division.

Replace division by div_long_long.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix mm/slub.c
--- a/mm/slub.c~slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix
+++ a/mm/slub.c
@@ -2933,12 +2933,14 @@ static int list_locations(struct kmem_ca
 		else
 			n += sprintf(buf + n, "<not-available>");
 
-		if (l->sum_time != l->min_time)
+		if (l->sum_time != l->min_time) {
+			unsigned long remainder;
+
 			n += sprintf(buf + n, " age=%ld/%ld/%ld",
 			l->min_time,
-			(unsigned long)(l->sum_time / l->count),
+			div_long_long_rem(l->sum_time, l->count, &remainder),
 			l->max_time);
-		else
+		} else
 			n += sprintf(buf + n, " age=%ld",
 				l->min_time);
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
slub-after-object-padding-only-needed-for-redzoning.patch
slub-slabinfo-upgrade.patch
slub-use-check_valid_pointer-in-kmem_ptr_validate.patch
slub-clean-up-krealloc.patch
slub-get-rid-of-finish_bootstrap.patch
slub-update-comments.patch
slub-add-macros-for-scanning-objects-in-a-slab.patch
slub-move-resiliency-check-into-sysfs-section.patch
slub-introduce-debugslabpage.patch
slub-consolidate-trace-code.patch
slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch
slub-add-config_slub_debug.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch
slub-rework-slab-order-determination.patch
krealloc-fix-kerneldoc-comments.patch
fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
frv-replace-pgd-management-via-slabs-through-quicklists.patch
disable-slub-on-powerpc.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
vmstat-use-our-own-timer-events-fix.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
move-remote-node-draining-out-of-slab-allocators.patch
md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch
