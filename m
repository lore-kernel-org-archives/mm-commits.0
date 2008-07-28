From: akpm@linux-foundation.org
Subject: - mlock-mlocked-pages-are-unevictable-fix-3.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:58:52 -0700
Message-ID: <200807282358.m6SNwq2C002864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069AbYG1X7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com, rja@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mlock-mlocked-pages-are-unevictable-fix-3
has been removed from the -mm tree.  Its filename was
     mlock-mlocked-pages-are-unevictable-fix-3.patch

This patch was dropped because it was folded into mlock-mlocked-pages-are-unevictable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock-mlocked-pages-are-unevictable-fix-3
From: Andrew Morton <akpm@linux-foundation.org>

a) Russ copying Linus on unimportant MM patches and ignoring all the
   pending MM work.

b) Linus making my life harder by merging it.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russ Anderson <rja@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/page-flags.h~mlock-mlocked-pages-are-unevictable-fix-3 include/linux/page-flags.h
--- a/include/linux/page-flags.h~mlock-mlocked-pages-are-unevictable-fix-3
+++ a/include/linux/page-flags.h
@@ -368,15 +368,17 @@ static inline void __ClearPageTail(struc
 #endif /* !PAGEFLAGS_EXTENDED */
 
 #ifdef CONFIG_UNEVICTABLE_LRU
-#define __PG_UNEVICTABLE (1 << PG_unevictable)
+#define __PG_UNEVICTABLE	(1 << PG_unevictable)
+#define __PG_MLOCKED		(1 << PG_mlocked)
 #else
-#define __PG_UNEVICTABLE 0
+#define __PG_UNEVICTABLE	0
+#define __PG_MLOCKED		0
 #endif
 
 #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
 			 1 << PG_buddy | 1 << PG_writeback | \
 			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
-			 1 << PG_swapbacked | __PG_UNEVICTABLE)
+			 1 << PG_swapbacked | __PG_UNEVICTABLE | __PG_MLOCKED)
 
 /*
  * Flags checked in bad_page().  Pages on the free list should not have
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
drivers-char-pcmcia-ipwireless-networkc-build-fix.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gru-driver-v3-fixes-to-resolve-code-review-comments-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

