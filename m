From: akpm@linux-foundation.org
Subject: [folded] serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:38:27 -0700
Message-ID: <201004271905.o3RJ5piQ014030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756030Ab0D0TG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 15:06:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, richard.rojfors@pelagicore.com, mm-commits@vger.kernel.org


The patch titled
     serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fi=
x
has been removed from the -mm tree.  Its filename was
     serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fi=
x.patch

This patch was dropped because it was folded into serial-timbuart-make-=
sure-last-byte-is-sent-when-port-is-closed.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: serial-timbuart-make-sure-last-byte-is-sent-when-port-is-close=
d-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

drivers/serial/timbuart.c: In function 'timbuart_flush_buffer':
drivers/serial/timbuart.c:72: error: implicit declaration of function '=
timbuart_tx_empty'
drivers/serial/timbuart.c: At top level:
drivers/serial/timbuart.c:201: error: conflicting types for 'timbuart_t=
x_empty'
drivers/serial/timbuart.c:72: error: previous implicit declaration of '=
timbuart_tx_empty' was here

confused.

Cc: Greg KH <greg@kroah.com>
Cc: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/timbuart.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/serial/timbuart.c~serial-timbuart-make-sure-last-byte=
-is-sent-when-port-is-closed-fix drivers/serial/timbuart.c
--- a/drivers/serial/timbuart.c~serial-timbuart-make-sure-last-byte-is-=
sent-when-port-is-closed-fix
+++ a/drivers/serial/timbuart.c
@@ -68,6 +68,13 @@ static void timbuart_start_tx(struct uar
 	tasklet_schedule(&uart->tasklet);
 }
=20
+static unsigned int timbuart_tx_empty(struct uart_port *port)
+{
+	u32 isr =3D ioread32(port->membase + TIMBUART_ISR);
+
+	return (isr & TXBE) ? TIOCSER_TEMT : 0;
+}
+
 static void timbuart_flush_buffer(struct uart_port *port)
 {
 	if (!timbuart_tx_empty(port)) {
@@ -198,13 +205,6 @@ void timbuart_tasklet(unsigned long arg)
 	dev_dbg(uart->port.dev, "%s leaving\n", __func__);
 }
=20
-static unsigned int timbuart_tx_empty(struct uart_port *port)
-{
-	u32 isr =3D ioread32(port->membase + TIMBUART_ISR);
-
-	return (isr & TXBE) ? TIOCSER_TEMT : 0;
-}
-
 static unsigned int timbuart_get_mctrl(struct uart_port *port)
 {
 	u8 cts =3D ioread8(port->membase + TIMBUART_CTRL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes.patch
drivers-acpi-use-kasprintf.patch
acpi_pad-processor_aggregator-name-too-long.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
jfs-free-sbi-memory-in-error-path.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.pat=
ch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-e=
ntries-checkpatch-fixes.patch
laptop-mode-make-flushes-per-device-fix.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-r=
emove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-s=
hrt_max-and-shrt_min-fix.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.p=
atch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixe=
s.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patc=
h
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on=
-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__f=
ile-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-check=
patch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
