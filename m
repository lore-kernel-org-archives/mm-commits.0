From: akpm@linux-foundation.org
Subject: - powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified.patch removed from -mm tree
Date: Mon, 07 May 2007 17:09:10 -0700
Message-ID: <200705080009.l4809AiJ009428@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967455AbXEHAJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     PowerPC: Disable SLUB for configurations in which slab page structs are modified
has been removed from the -mm tree.  Its filename was
     powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PowerPC: Disable SLUB for configurations in which slab page structs are modified
From: Christoph Lameter <clameter@sgi.com>

PowerPC uses the slab allocator to manage the lowest level of the page
table.  In high cpu configurations we also use the page struct to split the
page table lock.  Disallow the selection of SLUB for that case.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |   13 +++++++++++++
 1 files changed, 13 insertions(+)

diff -puN arch/powerpc/Kconfig~powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified
+++ a/arch/powerpc/Kconfig
@@ -120,6 +120,19 @@ config GENERIC_BUG
 config SYS_SUPPORTS_APM_EMULATION
 	bool
 
+#
+# Powerpc uses the slab allocator to manage its ptes and the
+# page structs of ptes are used for splitting the page table
+# lock for configurations supporting more than SPLIT_PTLOCK_CPUS.
+#
+# In that special configuration the page structs of slabs are modified.
+# This setting disables the selection of SLUB as a slab allocator.
+#
+config ARCH_USES_SLAB_PAGE_STRUCT
+	bool
+	default y
+	depends on SPLIT_PTLOCK_CPUS <= NR_CPUS
+
 config DEFAULT_UIMAGE
 	bool
 	help
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
