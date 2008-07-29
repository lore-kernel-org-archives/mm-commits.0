From: akpm@linux-foundation.org
Subject: - vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch removed from -mm tree
Date: Mon, 28 Jul 2008 17:31:22 -0700
Message-ID: <200807290031.m6T0VMMx004345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbYG2AcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:32:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan-unevictable-lru-scan-sysctl-nommu-fix
has been removed from the -mm tree.  Its filename was
     vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch

This patch was dropped because it was folded into vmscan-unevictable-lru-scan-sysctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-unevictable-lru-scan-sysctl-nommu-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix one CONFIG_MMU=n build error.

More remain:

mm/built-in.o(.text+0x1bb28): In function `truncate_complete_page':
: undefined reference to `__clear_page_mlock'
mm/built-in.o(.text+0x1ca40): In function `__invalidate_mapping_pages':
: undefined reference to `__clear_page_mlock'
mm/built-in.o(.text+0x1d24c): In function `invalidate_inode_pages2_range':
: undefined reference to `__clear_page_mlock'

Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-unevictable-lru-scan-sysctl-nommu-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-unevictable-lru-scan-sysctl-nommu-fix
+++ a/mm/vmscan.c
@@ -2416,7 +2416,7 @@ static void show_page_path(struct page *
 		       dentry_path(dentry, buf, 256), pgoff);
 		spin_unlock(&mapping->i_mmap_lock);
 	} else {
-#ifdef CONFIG_MM_OWNER
+#if defined(CONFIG_MM_OWNER) && defined(CONFIG_MMU)
 		struct anon_vma *anon_vma;
 		struct vm_area_struct *vma;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
introduce-down_try-so-we-can-move-away-from-down_trylock-checkpatch-fixes.patch
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
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
introduce-__get_user_pages.patch
vmscan-unevictable-lru-scan-sysctl.patch
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

