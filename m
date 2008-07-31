From: akpm@linux-foundation.org
Subject: + zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:14:32 -0700
Message-ID: <200807310314.m6V3EWHe001016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033AbYGaDOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clameter@sgi.com, mingo@elte.hu, travis@sgi.com


The patch titled
     Zero based percpu: use VMLINUX_SYMBOL in include/asm-generic/vmlinux.lds.h
has been added to the -mm tree.  Its filename is
     zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch

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
Subject: Zero based percpu: use VMLINUX_SYMBOL in include/asm-generic/vmlinux.lds.h
From: Andrew Morton <akpm@linux-foundation.org>

might be wrong or incomplete or whatever...

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/vmlinux.lds.h~zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh
+++ a/include/asm-generic/vmlinux.lds.h
@@ -385,15 +385,15 @@
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	percpu : { } :percpu						\
-	__per_cpu_load = .;						\
-	.data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {		\
+	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
+	.data.percpu 0 : AT(VMLINUX_SYMBOL(__per_cpu_load) - LOAD_OFFSET) { \
 		*(.data.percpu.first)					\
 		*(.data.percpu.shared_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.page_aligned)				\
-		____per_cpu_size = .;					\
+		VMLINUX_SYMBOL(____per_cpu_size) = .;			\
 	}								\
-	. = __per_cpu_load + ____per_cpu_size;				\
+	. = VMLINUX_SYMBOL(__per_cpu_load) + VMLINUX_SYMBOL(____per_cpu_size); \
 	data : { } :data
 #else
 #define PERCPU(align)							\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
missing-symbol-prefix-on-vmlinuxldsh-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-fixup.patch
next-remove-localversion.patch
pci-make-pci_register_driver-a-macro.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
x86-export-is_uv_system.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-mtd.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
usb-hubc-fix-build-with-config_pm=n.patch
git-xtensa.patch
drivers-telephony-ixjc-depends-on-pnp.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
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

