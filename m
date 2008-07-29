From: akpm@linux-foundation.org
Subject: - introduce-__get_user_pages-fix.patch removed from -mm tree
Date: Mon, 28 Jul 2008 17:04:26 -0700
Message-ID: <200807290004.m6T04RDr003140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbYG2AFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:05:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Lee.Schermerhorn@hp.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     introduce-__get_user_pages-fix
has been removed from the -mm tree.  Its filename was
     introduce-__get_user_pages-fix.patch

This patch was dropped because it was folded into introduce-__get_user_pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce-__get_user_pages-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/nommu.c: In function `__get_user_pages':
mm/nommu.c:138: error: `GUP_FLAGS_WRITE' undeclared (first use in this function)
mm/nommu.c:138: error: (Each undeclared identifier is reported only once
mm/nommu.c:138: error: for each function it appears in.)
mm/nommu.c:139: error: `GUP_FLAGS_FORCE' undeclared (first use in this function)
mm/nommu.c:140: error: `GUP_FLAGS_IGNORE_VMA_PERMISSIONS' undeclared (first use in this function)
mm/nommu.c: In function `get_user_pages':
mm/nommu.c:189: error: `GUP_FLAGS_WRITE' undeclared (first use in this function)
mm/nommu.c:191: error: `GUP_FLAGS_FORCE' undeclared (first use in this function)

Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/nommu.c~introduce-__get_user_pages-fix mm/nommu.c
--- a/mm/nommu.c~introduce-__get_user_pages-fix
+++ a/mm/nommu.c
@@ -34,6 +34,8 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
+#include "internal.h"
+
 void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
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
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
introduce-__get_user_pages.patch
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

