From: akpm@linux-foundation.org
Subject: - rm9000-serial-driver-tidy.patch removed from -mm tree
Date: Mon, 26 Mar 2007 21:52:25 -0800
Message-ID: <200703270552.l2R5qPY3008484@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40682 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbXC0F4B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 01:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, thomas.koeller@baslerweb.com, mm-commits@vger.kernel.org


The patch titled
     rm9000-serial-driver-tidy
has been removed from the -mm tree.  Its filename was
     rm9000-serial-driver-tidy.patch

This patch was dropped because it was folded into rm9000-serial-driver.patch

------------------------------------------------------
Subject: rm9000-serial-driver-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Thomas Koeller <thomas.koeller@baslerweb.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/serial/8250.c~rm9000-serial-driver-tidy drivers/serial/8250.c
--- a/drivers/serial/8250.c~rm9000-serial-driver-tidy
+++ a/drivers/serial/8250.c
@@ -320,11 +320,19 @@ static const u8
 		[UART_SCR]	= 0x2c
 	};
 
-#define map_8250_in_reg(up, offset) \
-	(((up)->port.iotype == UPIO_RM9000) ? regmap_in[offset] : (offset))
-#define map_8250_out_reg(up, offset) \
-	(((up)->port.iotype == UPIO_RM9000) ? regmap_out[offset] : (offset))
+static inline int map_8250_in_reg(struct uart_8250_port *up, int offset)
+{
+	if (up->port.iotype != UPIO_RM9000)
+		return offset;
+	return regmap_in[offset];
+}
 
+static inline int map_8250_out_reg(struct uart_8250_port *up, int offset)
+{
+	if (up->port.iotype != UPIO_RM9000)
+		return offset;
+	return regmap_out[offset];
+}
 
 #else
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-ieee1394-vs-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue.patch
git-parisc.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
fix-gregkh-pci-pci-piggy-bus.patch
fix-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
make-aout-executables-work-again-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
time-smp-friendly-alignment-of-struct-clocksource-fix.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
mm-only-hrtimers-debug-patch-fix.patch
