From: akpm@linux-foundation.org
Subject: + uninline-arch_pick_mmap_layout.patch added to -mm tree
Date: Fri, 25 Jul 2008 01:56:31 -0700
Message-ID: <200807250856.m6P8uVSh002432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309AbYGYI5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 04:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bunk@kernel.org, hskinnemoen@atmel.com


The patch titled
     uninline arch_pick_mmap_layout()
has been added to the -mm tree.  Its filename is
     uninline-arch_pick_mmap_layout.patch

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
Subject: uninline arch_pick_mmap_layout()
From: Andrew Morton <akpm@linux-foundation.org>

Fix this, on avr32:

/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/utsname.h:35,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:20:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h: In function 'arch_pick_mmap_layout':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h:2149: error: implicit declaration of function 'PAGE_ALIGN'

Reported-by: Adrian Bunk <bunk@kernel.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    9 ---------
 mm/mmap.c             |    9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/sched.h~uninline-arch_pick_mmap_layout include/linux/sched.h
--- a/include/linux/sched.h~uninline-arch_pick_mmap_layout
+++ a/include/linux/sched.h
@@ -2139,16 +2139,7 @@ static inline void set_task_cpu(struct t
 
 #endif /* CONFIG_SMP */
 
-#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
-#else
-static inline void arch_pick_mmap_layout(struct mm_struct *mm)
-{
-	mm->mmap_base = TASK_UNMAPPED_BASE;
-	mm->get_unmapped_area = arch_get_unmapped_area;
-	mm->unmap_area = arch_unmap_area;
-}
-#endif
 
 #ifdef CONFIG_TRACING
 extern void
diff -puN mm/mmap.c~uninline-arch_pick_mmap_layout mm/mmap.c
--- a/mm/mmap.c~uninline-arch_pick_mmap_layout
+++ a/mm/mmap.c
@@ -2268,3 +2268,12 @@ int install_special_mapping(struct mm_st
 
 	return 0;
 }
+
+#ifndef HAVE_ARCH_PICK_MMAP_LAYOUT
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+	mm->mmap_base = TASK_UNMAPPED_BASE;
+	mm->get_unmapped_area = arch_get_unmapped_area;
+	mm->unmap_area = arch_unmap_area;
+}
+#endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mfd-dont-use-memzero.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
exec-remove-some-includes.patch
inflate-refactor-inflate-malloc-code.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated.patch
gpio-add-bt8xxgpio-driver.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-deleting-corrupted-indirect-blocks.patch
jbd-dont-abort-if-flushing-file-data-failed.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch
quota-move-function-macros-from-quotah-to-quotaopsh.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch
devcgroup-code-cleanup.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-limit-change-shrink-usage.patch
coredump-format_corename-fix-the-core_uses_pid-logic.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-rewrite-undo-list-locking.patch
fs-partition-checkc-fix-return-value-warning.patch
block-ioctlc-and-fs-partition-checkc.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass.patch
arm-fix-fls-for-64-bit-arguments.patch
linux-next.patch
linux-next-fixups.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
drivers-mfd-tc6393xbc-doesnt-compile-on-i386.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
drm-fix-sparc64-build.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
eink_apollofb-new-driver-for-apollo-eink-controller-cleanup.patch
eink_apollofb-new-driver-for-apollo-eink-controller-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller-fix-fix-2.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sdhci-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
slb-drop-kmem-cache-argument-from-constructor-ubifs.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
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
uninline-arch_pick_mmap_layout.patch

