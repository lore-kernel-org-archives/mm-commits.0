From: akpm@linux-foundation.org
Subject: [folded-merged] nilfs2-fix-data-loss-with-mmap-fix.patch removed
 from -mm tree
Date: Thu, 25 Sep 2014 16:02:38 -0700
Message-ID: <54249f0e.t5vustRSssxLyjOQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIYXCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 19:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2-fix-data-loss-with-mmap-fix
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-data-loss-with-mmap-fix.patch

This patch was dropped because it was folded into nilfs2-fix-data-loss-with-mmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nilfs2-fix-data-loss-with-mmap-fix

s/PAGE_SHIFT/PAGE_CACHE_SHIFT/

Cc: <stable@vger.kernel.org>
Cc: Andreas Rohner <andreas.rohner@gmx.net>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/inode.c~nilfs2-fix-data-loss-with-mmap-fix fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-fix-data-loss-with-mmap-fix
+++ a/fs/nilfs2/inode.c
@@ -24,6 +24,7 @@
 #include <linux/buffer_head.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
+#include <linux/pagemap.h>
 #include <linux/writeback.h>
 #include <linux/aio.h>
 #include "nilfs.h"
@@ -246,7 +247,7 @@ static int nilfs_set_page_dirty(struct p
 		if (nr_dirty)
 			nilfs_set_file_dirty(inode, nr_dirty);
 	} else if (ret) {
-		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
+		unsigned nr_dirty = 1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
 		nilfs_set_file_dirty(inode, nr_dirty);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
nilfs2-fix-data-loss-with-mmap.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private-fix.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
mm-debugc-use-pr_emerg.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
drivers-power-kconfig-revert-part-of-charger-max14577-add-support-for-max77836-charger.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

