From: akpm@linux-foundation.org
Subject: - disable-slub-on-powerpc.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:24 -0700
Message-ID: <200705092148.l49LmO3Y002586@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759037AbXEIVsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Disable SLUB on powerpc
has been removed from the -mm tree.  Its filename was
     disable-slub-on-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Disable SLUB on powerpc
From: Christoph Lameter <clameter@sgi.com>

Disable SLUB on powerpc since the Kconfig comparison does not work
reliably.

Work is in progress to fix the powerpc issues with page struct
modifications.  So I hope that this patch will only be necessary for a
short time.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/powerpc/Kconfig~disable-slub-on-powerpc arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~disable-slub-on-powerpc
+++ a/arch/powerpc/Kconfig
@@ -131,7 +131,6 @@ config SYS_SUPPORTS_APM_EMULATION
 config ARCH_USES_SLAB_PAGE_STRUCT
 	bool
 	default y
-	depends on SPLIT_PTLOCK_CPUS <= NR_CPUS
 
 config DEFAULT_UIMAGE
 	bool
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
