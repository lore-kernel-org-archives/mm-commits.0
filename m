From: akpm@linux-foundation.org
Subject: + slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch added to -mm tree
Date: Mon, 14 May 2007 15:45:31 -0700
Message-ID: <200705142245.l4EMjVcw028326@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827AbXENWqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 18:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Remove depends on EXPERIMENTAL and !ARCH_USES_SLAB_PAGE_STRUCT
has been added to the -mm tree.  Its filename is
     slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Remove depends on EXPERIMENTAL and !ARCH_USES_SLAB_PAGE_STRUCT
From: Christoph Lameter <clameter@sgi.com>

No arch sets ARCH_USES_SLAB_PAGE_STRUCT anymore.

Remove the experimental dependency as well since we want to have it as
a real alternative to SLAB.

It all comes down to killing a single line from init/Kconfig.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 -
 1 files changed, 1 deletion(-)

diff -puN init/Kconfig~slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct init/Kconfig
--- a/init/Kconfig~slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct
+++ a/init/Kconfig
@@ -567,7 +567,6 @@ config SLAB
 	  a slab allocator.
 
 config SLUB
-	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
_

Patches currently in -mm which might be from clameter@sgi.com are

git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
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
