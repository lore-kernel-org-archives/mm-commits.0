From: akpm@linux-foundation.org
Subject: - revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch removed from -mm tree
Date: Mon, 28 Jul 2008 17:26:23 -0700
Message-ID: <200807290026.m6T0QNYY004104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbYG2A1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:27:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, hugh@veritas.com, lizf@cn.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     splitlru: revert to unevictable-lru-infrastructure-kconfig-fix.patch
has been removed from the -mm tree.  Its filename was
     revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch

This patch was dropped because it was folded into unevictable-lru-infrastructure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splitlru: revert to unevictable-lru-infrastructure-kconfig-fix.patch
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

CONFIG_UNEVICTABLE_LRU automatically turn on CONFIG_PAGE_WALKER.  It
causes a build error on nommu machines.

Now, it is unnecessary because munlock was rewritten.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 -
 mm/Kconfig   |    5 -----
 mm/Makefile  |    2 +-
 3 files changed, 1 insertion(+), 7 deletions(-)

diff -puN init/Kconfig~revert-to-unevictable-lru-infrastructure-kconfig-fixpatch init/Kconfig
--- a/init/Kconfig~revert-to-unevictable-lru-infrastructure-kconfig-fixpatch
+++ a/init/Kconfig
@@ -793,7 +793,6 @@ source "arch/Kconfig"
 config PROC_PAGE_MONITOR
  	default y
 	depends on PROC_FS && MMU
-	select PAGE_WALKER
 	bool "Enable /proc page monitoring" if EMBEDDED
  	help
 	  Various /proc files exist to monitor process memory utilization:
diff -puN mm/Kconfig~revert-to-unevictable-lru-infrastructure-kconfig-fixpatch mm/Kconfig
--- a/mm/Kconfig~revert-to-unevictable-lru-infrastructure-kconfig-fixpatch
+++ a/mm/Kconfig
@@ -209,14 +209,9 @@ config VIRT_TO_BUS
 	def_bool y
 	depends on !ARCH_NO_VIRT_TO_BUS
 
-# automatically selected by UNEVICTABLE_LRU or PROC_PAGE_MONITOR
-config PAGE_WALKER
-	def_bool n
-
 config UNEVICTABLE_LRU
 	bool "Add LRU list to track non-evictable pages"
 	default y
-	select PAGE_WALKER
 	help
 	  Keeps unevictable pages off of the active and inactive pageout
 	  lists, so kswapd will not waste CPU time or have its balancing
diff -puN mm/Makefile~revert-to-unevictable-lru-infrastructure-kconfig-fixpatch mm/Makefile
--- a/mm/Makefile~revert-to-unevictable-lru-infrastructure-kconfig-fixpatch
+++ a/mm/Makefile
@@ -13,7 +13,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o $(mmu-y)
 
-obj-$(CONFIG_PAGE_WALKER) += pagewalk.o
+obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
introduce-__get_user_pages.patch
split-lru-munlock-rework.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

