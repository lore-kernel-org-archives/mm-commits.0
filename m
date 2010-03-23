From: akpm@linux-foundation.org
Subject: + serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch added to -mm tree
Date: Tue, 23 Mar 2010 15:05:02 -0700
Message-ID: <201003232231.o2NMVdJ4029736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331Ab0CWWcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 18:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, richard.rojfors@pelagicore.com


The patch titled
     serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fi=
x
has been added to the -mm tree.  Its filename is
     serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fi=
x.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -67,6 +67,13 @@ static void timbuart_start_tx(struct uar
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
@@ -197,13 +204,6 @@ void timbuart_tasklet(unsigned long arg)
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

c2port-fix-device_create-return-value-check.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
ratelimit-annotate-___ratelimit-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-pres=
ent.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
hpet-factor-timer-allocate-from-open-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
serial-add-driver-for-the-altera-uart-unbork.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.pat=
ch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.p=
atch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixe=
s.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on=
-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-check=
patch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
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
