From: akpm@linux-foundation.org
Subject: + x86-export-is_uv_system.patch added to -mm tree
Date: Wed, 30 Jul 2008 16:59:06 -0700
Message-ID: <200807310011.m6V0BrWD025657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761159AbYGaAMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 20:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dcn@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: export is_uv_system()
has been added to the -mm tree.  Its filename is
     x86-export-is_uv_system.patch

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
Subject: x86: export is_uv_system()
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "is_uv_system" [drivers/misc/sgi-xp/xpnet.ko] undefined!
ERROR: "is_uv_system" [drivers/misc/sgi-xp/xpc.ko] undefined!
ERROR: "is_uv_system" [drivers/misc/sgi-xp/xp.ko] undefined!
ERROR: "is_uv_system" [drivers/misc/sgi-gru/gru.ko] undefined!

(is sgi-xp an x86-64 driver?)

Cc: Dean Nelson <dcn@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genx2apic_uv_x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/genx2apic_uv_x.c~x86-export-is_uv_system arch/x86/kernel/genx2apic_uv_x.c
--- a/arch/x86/kernel/genx2apic_uv_x.c~x86-export-is_uv_system
+++ a/arch/x86/kernel/genx2apic_uv_x.c
@@ -53,6 +53,7 @@ int is_uv_system(void)
 {
 	return uv_system_type != UV_NONE;
 }
+EXPORT_SYMBOL(is_uv_system);
 
 DEFINE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 EXPORT_PER_CPU_SYMBOL_GPL(__uv_hub_info);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
pci-make-pci_register_driver-a-macro.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
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
w1-feature-enable-hardware-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-add-support-for-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch
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
x86-export-is_uv_system.patch

