From: akpm@linux-foundation.org
Subject: + slub-clean-up-krealloc.patch added to -mm tree
Date: Tue, 08 May 2007 14:48:45 -0700
Message-ID: <200705082148.l48Lmjqp002611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031546AbXEHVss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: clean up krealloc
has been added to the -mm tree.  Its filename is
     slub-clean-up-krealloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: clean up krealloc
From: Christoph Lameter <clameter@sgi.com>

We really do not need all this gaga there.

ksize gives us all the information we need to figure out if the object can
cope with the new size.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-clean-up-krealloc mm/slub.c
--- a/mm/slub.c~slub-clean-up-krealloc
+++ a/mm/slub.c
@@ -2199,9 +2199,8 @@ EXPORT_SYMBOL(kmem_cache_shrink);
  */
 void *krealloc(const void *p, size_t new_size, gfp_t flags)
 {
-	struct kmem_cache *new_cache;
 	void *ret;
-	struct page *page;
+	unsigned long ks;
 
 	if (unlikely(!p))
 		return kmalloc(new_size, flags);
@@ -2211,19 +2210,13 @@ void *krealloc(const void *p, size_t new
 		return NULL;
 	}
 
-	page = virt_to_head_page(p);
-
-	new_cache = get_slab(new_size, flags);
-
-	/*
- 	 * If new size fits in the current cache, bail out.
- 	 */
-	if (likely(page->slab == new_cache))
+	ks = ksize(p);
+	if (ks >= new_size)
 		return (void *)p;
 
 	ret = kmalloc(new_size, flags);
 	if (ret) {
-		memcpy(ret, p, min(new_size, ksize(p)));
+		memcpy(ret, p, min(new_size, ks));
 		kfree(p);
 	}
 	return ret;
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
