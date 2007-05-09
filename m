From: akpm@linux-foundation.org
Subject: - revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch removed from -mm tree
Date: Wed, 09 May 2007 02:56:01 -0700
Message-ID: <200705090956.l499u1u3020545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757271AbXEIJ4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab allocators: Remove multiple alignment specifications (revoke)
has been removed from the -mm tree.  Its filename was
     revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: slab allocators: Remove multiple alignment specifications (revoke)
From: Christoph Lameter <clameter@sgi.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke
+++ a/fs/revoke.c
@@ -709,8 +709,7 @@ static void revokefs_init_inode(void *ob
 {
 	struct revokefs_inode_info *info = obj;
 
-	if ((flags & (SLAB_CTOR_VERIFY | SLAB_CTOR_CONSTRUCTOR)) ==
-	    SLAB_CTOR_CONSTRUCTOR) {
+	if (flags & SLAB_CTOR_CONSTRUCTOR) {
 		info->owner = NULL;
 		inode_init_once(&info->vfs_inode);
 	}
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
slub-rework-slab-order-determination.patch
krealloc-fix-kerneldoc-comments.patch
fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
frv-replace-pgd-management-via-slabs-through-quicklists.patch
disable-slub-on-powerpc.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
move-remote-node-draining-out-of-slab-allocators.patch
md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
