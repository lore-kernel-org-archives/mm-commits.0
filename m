From: akpm@linux-foundation.org
Subject: + slub-slub_debug-must-depend-on-slub.patch added to -mm tree
Date: Wed, 09 May 2007 21:30:13 -0700
Message-ID: <200705100430.l4A4UD4K012018@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712AbXEJEaP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:30:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: SLUB_DEBUG must depend on SLUB
has been added to the -mm tree.  Its filename is
     slub-slub_debug-must-depend-on-slub.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: SLUB_DEBUG must depend on SLUB
From: Christoph Lameter <clameter@sgi.com>

Otherwise people get asked about SLUB_DEBUG even if they have another
slab allocator enabled.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/Kconfig~slub-slub_debug-must-depend-on-slub init/Kconfig
--- a/init/Kconfig~slub-slub_debug-must-depend-on-slub
+++ a/init/Kconfig
@@ -505,6 +505,7 @@ config VM_EVENT_COUNTERS
 config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EMBEDDED
+	depends on SLUB
 	help
 	  SLUB has extensive debug support features. Disabling these can
 	  result in significant savings in code size. This also disables
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
slub-slub_debug-must-depend-on-slub.patch
slub-remove-nr_cpu_ids-hack.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-i386-support.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
