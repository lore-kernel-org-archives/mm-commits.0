From: akpm@linux-foundation.org
Subject: + pata_acpi-restore-driver-fix.patch added to -mm tree
Date: Thu, 29 Mar 2007 18:01:48 -0700
Message-ID: <200703300103.l2U13uGB016990@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934195AbXC3BEK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 21:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@redhat.com


The patch titled
     pata_acpi-restore-driver-fix
has been added to the -mm tree.  Its filename is
     pata_acpi-restore-driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_acpi-restore-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/ata/pata_acpi.c: In function 'pacpi_pre_reset':
drivers/ata/pata_acpi.c:55: error: too many arguments to function 'ata_std_prereset'
drivers/ata/pata_acpi.c: In function 'pacpi_error_handler':
drivers/ata/pata_acpi.c:86: warning: passing argument 2 of 'ata_bmdma_drive_eh' from incompatible pointer type

Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_acpi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/Kconfig~pata_acpi-restore-driver-fix drivers/ata/Kconfig
diff -puN drivers/ata/Makefile~pata_acpi-restore-driver-fix drivers/ata/Makefile
diff -puN drivers/ata/pata_acpi.c~pata_acpi-restore-driver-fix drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~pata_acpi-restore-driver-fix
+++ a/drivers/ata/pata_acpi.c
@@ -45,14 +45,14 @@ struct pata_acpi {
  *	Perform the PATA port setup we need.
  */
 
-static int pacpi_pre_reset(struct ata_port *ap, unsigned long deadline)
+static int pacpi_pre_reset(struct ata_port *ap)
 {
 	struct pata_acpi *acpi = ap->private_data;
 
 	if (acpi->handle == NULL || ata_acpi_gtm(ap, acpi->handle, &acpi->gtm) < 0)
 		return -ENODEV;
 
-	return ata_std_prereset(ap, deadline);
+	return ata_std_prereset(ap);
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n.patch
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
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-ubi.patch
git-netdev-all.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-piggy-bus.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
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
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
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
linux-kernel-markers-i386-optimization-fix.patch
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
mm-only-hrtimers-debug-patch-fix.patch
pata_acpi-restore-driver-fix.patch
