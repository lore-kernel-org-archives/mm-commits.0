From: akpm@linux-foundation.org
Subject: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm tree
Date: Tue, 08 May 2007 16:02:20 -0700
Message-ID: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968613AbXEHXCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:02:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mpm@selenic.com


The patch titled
     Fix spellings of slab allocator section in init/Kconfig
has been added to the -mm tree.  Its filename is
     fix-spellings-of-slab-allocator-section-in-init-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix spellings of slab allocator section in init/Kconfig
From: Christoph Lameter <clameter@sgi.com>

Fix some of the spelling issues. Fix sentences. Discourage SLOB use
since SLUB can pack objects denser.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff -puN init/Kconfig~fix-spellings-of-slab-allocator-section-in-init-kconfig init/Kconfig
--- a/init/Kconfig~fix-spellings-of-slab-allocator-section-in-init-kconfig
+++ a/init/Kconfig
@@ -523,9 +523,9 @@ config SLAB
 	bool "SLAB"
 	help
 	  The regular slab allocator that is established and known to work
-	  well in all environments. It organizes chache hot objects in
+	  well in all environments. It organizes cache hot objects in
 	  per cpu and per node queues. SLAB is the default choice for
-	  slab allocator.
+	  a slab allocator.
 
 config SLUB
 	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
@@ -535,21 +535,20 @@ config SLUB
 	   instead of managing queues of cached objects (SLAB approach).
 	   Per cpu caching is realized using slabs of objects instead
 	   of queues of objects. SLUB can use memory efficiently
-	   way and has enhanced diagnostics.
+	   and has enhanced diagnostics.
 
 config SLOB
 #
-#	SLOB cannot support SMP because SLAB_DESTROY_BY_RCU does not work
-#	properly.
+#	SLOB does not support SMP because SLAB_DESTROY_BY_RCU is unsupported
 #
 	depends on EMBEDDED && !SMP && !SPARSEMEM
 	bool "SLOB (Simple Allocator)"
 	help
 	   SLOB replaces the SLAB allocator with a drastically simpler
 	   allocator.  SLOB is more space efficient that SLAB but does not
-	   scale well (single lock for all operations) and is more susceptible
-	   to fragmentation. SLOB it is a great choice to reduce
-	   memory usage and code size for embedded systems.
+	   scale well (single lock for all operations) and is also highly
+	   susceptible to fragmentation. SLUB can accomplish a higher object
+	   density. It is usually better to use SLUB instead of SLOB.
 
 endchoice
 
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
fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
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
