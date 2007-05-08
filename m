From: akpm@linux-foundation.org
Subject: + slub-after-object-padding-only-needed-for-redzoning.patch added to -mm tree
Date: Tue, 08 May 2007 14:48:39 -0700
Message-ID: <200705082148.l48LmdqB002600@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968348AbXEHVsl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:48:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: after object padding only needed for Redzoning
has been added to the -mm tree.  Its filename is
     slub-after-object-padding-only-needed-for-redzoning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: after object padding only needed for Redzoning
From: Christoph Lameter <clameter@sgi.com>

If no redzoning is selected then we do not need padding before the next
object.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-after-object-padding-only-needed-for-redzoning mm/slub.c
--- a/mm/slub.c~slub-after-object-padding-only-needed-for-redzoning
+++ a/mm/slub.c
@@ -1656,7 +1656,7 @@ static int calculate_sizes(struct kmem_c
 		 */
 		size += 2 * sizeof(struct track);
 
-	if (flags & DEBUG_DEFAULT_FLAGS)
+	if (flags & SLAB_RED_ZONE)
 		/*
 		 * Add some empty padding so that we can catch
 		 * overwrites from earlier objects rather than let
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
slub-add-support-for-dynamic-cacheline-size-determination-fix.patch
slub-after-object-padding-only-needed-for-redzoning.patch
slub-slabinfo-upgrade.patch
slub-use-check_valid_pointer-in-kmem_ptr_validate.patch
slub-clean-up-krealloc.patch
slub-clean-up-krealloc-fix.patch
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
