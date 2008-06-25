From: akpm@linux-foundation.org
Subject: + unevictable-lru-infrastructure-kconfig-fix.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:47:07 -0700
Message-ID: <200806252147.m5PLl78w028452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbYFYVrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, benjkidwell@yahoo.com, kosaki@jp.fujitsu.com, lee.schermerhorn@hp.com


The patch titled
     fix UNEVICTABLE_LRU and !PROC_PAGE_MONITOR build
has been added to the -mm tree.  Its filename is
     unevictable-lru-infrastructure-kconfig-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix UNEVICTABLE_LRU and !PROC_PAGE_MONITOR build
From: Rik van Riel <riel@redhat.com>

Both CONFIG_PROC_PAGE_MONITOR and CONFIG_UNEVICTABLE_LRU depend on
mm/pagewalk.c being built.  Create a CONFIG_PAGE_WALKER Kconfig variable
that is automatically selected if needed.

Debugged-by: Benjamin Kidwell <benjkidwell@yahoo.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 +
 mm/Kconfig   |    5 +++++
 mm/Makefile  |    2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~unevictable-lru-infrastructure-kconfig-fix init/Kconfig
--- a/init/Kconfig~unevictable-lru-infrastructure-kconfig-fix
+++ a/init/Kconfig
@@ -803,6 +803,7 @@ source "arch/Kconfig"
 config PROC_PAGE_MONITOR
  	default y
 	depends on PROC_FS && MMU
+	select PAGE_WALKER
 	bool "Enable /proc page monitoring" if EMBEDDED
  	help
 	  Various /proc files exist to monitor process memory utilization:
diff -puN mm/Kconfig~unevictable-lru-infrastructure-kconfig-fix mm/Kconfig
--- a/mm/Kconfig~unevictable-lru-infrastructure-kconfig-fix
+++ a/mm/Kconfig
@@ -209,9 +209,14 @@ config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
 
+# automatically selected by UNEVICTABLE_LRU or PROC_PAGE_MONITOR
+config PAGE_WALKER
+	def_bool n
+
 config UNEVICTABLE_LRU
 	bool "Add LRU list to track non-evictable pages"
 	default y
+	select PAGE_WALKER
 	help
 	  Keeps unevictable pages off of the active and inactive pageout
 	  lists, so kswapd will not waste CPU time or have its balancing
diff -puN mm/Makefile~unevictable-lru-infrastructure-kconfig-fix mm/Makefile
--- a/mm/Makefile~unevictable-lru-infrastructure-kconfig-fix
+++ a/mm/Makefile
@@ -13,7 +13,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o $(mmu-y)
 
-obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
+obj-$(CONFIG_PAGE_WALKER) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
_

Patches currently in -mm which might be from riel@redhat.com are

ntp-let-update_persistent_clock-sleep.patch
access_process_vm-device-memory-infrastructure.patch
access_process_vm-device-memory-infrastructure-fix.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
more-aggressively-use-lumpy-reclaim.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-kconfig-fix.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
make-mm-rmapc-anon_vma_cachep-static.patch

