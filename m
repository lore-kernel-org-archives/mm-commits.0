From: akpm@linux-foundation.org
Subject: - unevictable-lru-infrastructure-kconfig-fix.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:53:17 -0700
Message-ID: <200807282353.m6SNrHCe002606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbYG1Xxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, benjkidwell@yahoo.com, kosaki@jp.fujitsu.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     fix UNEVICTABLE_LRU and !PROC_PAGE_MONITOR build
has been removed from the -mm tree.  Its filename was
     unevictable-lru-infrastructure-kconfig-fix.patch

This patch was dropped because it was folded into unevictable-lru-infrastructure.patch

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
 			   page_isolation.o mm_init.o $(mmu-y)
 
-obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
+obj-$(CONFIG_PAGE_WALKER) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
ecryptfs-use-page_alloc-not-kmalloc-to-get-a-page-of-memory.patch
ntp-let-update_persistent_clock-sleep.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
more-aggressively-use-lumpy-reclaim.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-kconfig-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
swap-cull-unevictable-pages-in-fault-path.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

