From: akpm@linux-foundation.org
Subject: - serial-make-early_uart-to-use-early_prarm-instead-of-fix.patch removed from -mm tree
Date: Sun, 20 May 2007 21:47:19 -0700
Message-ID: <200705210447.l4L4lKcW002642@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUEtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:49:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Yinghai.Lu@Sun.COM, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial-make-early_uart-to-use-early_prarm-instead-of-fix
has been removed from the -mm tree.  Its filename was
     serial-make-early_uart-to-use-early_prarm-instead-of-fix.patch

This patch was dropped because it was folded into serial-make-early_uart-to-use-early_prarm-instead-of.patch

------------------------------------------------------
Subject: serial-make-early_uart-to-use-early_prarm-instead-of-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig       |    7 ++++---
 drivers/serial/serial_core.c |    2 +-
 include/linux/console.h      |    3 ++-
 kernel/printk.c              |    8 +++++---
 4 files changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/serial/Kconfig~serial-make-early_uart-to-use-early_prarm-instead-of-fix drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-make-early_uart-to-use-early_prarm-instead-of-fix
+++ a/drivers/serial/Kconfig
@@ -62,11 +62,12 @@ config SERIAL_8250_CONSOLE
 	  kernel will automatically use the first serial line, /dev/ttyS0, as
 	  system console.
 
-	  you can set that using a kernel command line option such as
+	  Early console may be specified using a kernel command line option
+	  such as
 	  "earlycon=uart,io,0x3f8,9600n8" or
 	  "earlycon=uart,mem,0xfe000008,115200n8".
-	  and it will switch to normal serial console when correponding port is
-	  ready.
+	  and it will switch to the normal serial console when the
+	  corresponding port is ready.
 
 	  If unsure, say N.
 
diff -puN drivers/serial/serial_core.c~serial-make-early_uart-to-use-early_prarm-instead-of-fix drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-make-early_uart-to-use-early_prarm-instead-of-fix
+++ a/drivers/serial/serial_core.c
@@ -2304,7 +2304,7 @@ int uart_add_one_port(struct uart_driver
 	 */
 	if (port->type != PORT_UNKNOWN &&
 	    port->cons && !(port->cons->flags & CON_ENABLED)) {
-		if(port->ops && port->ops->find_port_for_earlycon)
+		if (port->ops && port->ops->find_port_for_earlycon)
 			port->ops->find_port_for_earlycon();
 		register_console(port->cons);
 	}
diff -puN include/linux/console.h~serial-make-early_uart-to-use-early_prarm-instead-of-fix include/linux/console.h
--- a/include/linux/console.h~serial-make-early_uart-to-use-early_prarm-instead-of-fix
+++ a/include/linux/console.h
@@ -107,7 +107,8 @@ struct console {
 };
 
 extern int add_preferred_console(char *name, int idx, char *options);
-extern int update_console_cmdline_console_index(char *name, int idx_old, int idx_new);
+extern int update_console_cmdline_console_index(char *name, int idx_old,
+						int idx_new);
 extern void register_console(struct console *);
 extern int unregister_console(struct console *);
 extern struct console *console_drivers;
diff -puN kernel/printk.c~serial-make-early_uart-to-use-early_prarm-instead-of-fix kernel/printk.c
--- a/kernel/printk.c~serial-make-early_uart-to-use-early_prarm-instead-of-fix
+++ a/kernel/printk.c
@@ -726,21 +726,23 @@ int __init add_preferred_console(char *n
 	return 0;
 }
 
-int __init update_console_cmdline_console_index(char *name, int idx_old, int idx_new)
+int __init update_console_cmdline_console_index(char *name, int idx_old,
+						int idx_new)
 {
 	int i;
 
-	for(i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
+	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0];
+			i++) {
 		if (strcmp(console_cmdline[i].name, name) == 0 &&
 			  console_cmdline[i].index == idx_old) {
 			  	console_cmdline[i].index = idx_new;
 				return 0;
 		}
+	}
 
 	return 0;
 }
 
-
 #ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
 /**
  * suspend_console - suspend the console subsystem
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-dvb.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
ide-warning-fixes.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
serial-make-early_uart-to-use-early_prarm-instead-of.patch
serial-make-early_uart-to-use-early_prarm-instead-of-fix.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg-fix.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
xfs-clean-up-shrinker-games.patch
git-cryptodev.patch
pci-x-pci-express-read-control-interfaces-fix.patch
x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
simplify-cleanup_workqueue_thread-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
pie-randomization-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
reiser4.patch
reiser4-fix.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
vdso-print-fatal-signals.patch
check_dirty_inode_list.patch
git-gccbug-fixup.patch
w1-build-fix.patch
