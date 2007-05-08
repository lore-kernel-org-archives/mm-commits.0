From: akpm@linux-foundation.org
Subject: + disable-slub-on-powerpc.patch added to -mm tree
Date: Tue, 08 May 2007 16:35:20 -0700
Message-ID: <200705082335.l48NZKXE004886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969704AbXEHXf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:35:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org


The patch titled
     Disable SLUB on powerpc
has been added to the -mm tree.  Its filename is
     disable-slub-on-powerpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 deletion(-)

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
