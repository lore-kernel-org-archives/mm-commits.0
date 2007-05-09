From: akpm@linux-foundation.org
Subject: - fix-spellings-of-slab-allocator-section-in-init-kconfig.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:20 -0700
Message-ID: <200705092148.l49LmKH8002579@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759133AbXEIVsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     Fix spellings of slab allocator section in init/Kconfig
has been removed from the -mm tree.  Its filename was
     fix-spellings-of-slab-allocator-section-in-init-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 7 insertions(+), 8 deletions(-)

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
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
