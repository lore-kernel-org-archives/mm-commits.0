From: akpm@linux-foundation.org
Subject: + stop_machine-now-uses-hard_irq_disable-fix.patch added to -mm tree
Date: Thu, 10 May 2007 02:57:05 -0700
Message-ID: <200705101000.l4AA04fr017725@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754123AbXEJKAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 06:00:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, paulus@samba.org, rusty@rustcorp.com.au


The patch titled
     stop_machine-now-uses-hard_irq_disable-fix
has been added to the -mm tree.  Its filename is
     stop_machine-now-uses-hard_irq_disable-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: stop_machine-now-uses-hard_irq_disable-fix
From: Andrew Morton <akpm@linux-foundation.org>

kernel/built-in.o: In function `stopmachine':
stop_machine.c:(.text+0x3b9ff): undefined reference to `hard_irq_disable'
kernel/built-in.o: In function `do_stop':
stop_machine.c:(.text+0x3bb36): undefined reference to `hard_irq_disable'
make: *** [.tmp_vmlinux1] Error 1

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/stop_machine.c~stop_machine-now-uses-hard_irq_disable-fix kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-now-uses-hard_irq_disable-fix
+++ a/kernel/stop_machine.c
@@ -8,6 +8,8 @@
 #include <linux/sched.h>
 #include <linux/stop_machine.h>
 #include <linux/syscalls.h>
+#include <linux/interrupt.h>
+
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
upper-32-bits.patch
afs-write-support-fixes-fix.patch
revert-md-improve-partition-detection-in-md-array.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder-fix.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-battery.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
x86_64-rename-and-export-bad_srat-to-kernel-code-fix.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
xfs-clean-up-shrinker-games.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
lib-hexdump.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
synclink_gt-add-compat_ioctl-fix.patch
stop_machine-now-uses-hard_irq_disable-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
linux-kernel-markers-architecture-independant-code-update-fix.patch
linux-kernel-markers-powerpc-optimization-fix.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-documentation-update.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
pm3fb-preliminary-24-to-26-port-fix.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
