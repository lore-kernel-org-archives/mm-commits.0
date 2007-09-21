From: akpm@linux-foundation.org
Subject: + kernel-printkc-concerns-about-the-console-handover.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:30:53 -0700
Message-ID: <200709210730.l8L7UrAh024668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055AbXIUHcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:32:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, Yinghai.Lu@Sun.COM, akpm@linux-foundation.org, bryan.wu@analog.com, dilinger@queued.net, kraxel@redhat.com, kraxel@suse.de, lethal@linux-sh.org, rgetz@blackfin.uclinux.org, rmk@arm.linux.org.uk, vapier.adi@gmail.com


The patch titled
     kernel/printk.c: Concerns about the console handover
has been added to the -mm tree.  Its filename is
     kernel-printkc-concerns-about-the-console-handover.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/printk.c: Concerns about the console handover
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Move the hadover message to after the boot console has been released to
avoid bad interactions between it and the real console.

OPThe 69331af79cf29e26d1231152a172a1a10c2df511 commit of May 8th added a
"console handover: ..." message to register_console() that is output during
the short period when both the boot and the newly-registered console are
registered.

This is presumably fine for boot consoles implemented entirely by Linux as
they are fully controlled.  But it may produce problems when the boot
console is actually implemented as a call to the firmware which may not be
quite happy about how the OS driver for the piece of hardware involved
controls it.

I hit this problem with the DECstation.  Depending on the configuration the
fimrware uses a graphics adapter or a predefined serial port for console
output -- which device actually that is cannot be reliably determined by
Linux, though an approximation may be possible.  Now if the firmware uses
the serial port and Linux is asked to use the same serial port for the real
console, then this printk() hangs forever in the firmware.  The driver used
is drivers/serial/zs.c.

The reason is by the time the ->write() call is issued for the boot console
as a result of this printk(), the zs.c driver has been initialised and
because at the moment the serial port has not been opened, the serial
transmitter is disabled.  The firmware polls for the transmit buffer empty
condition, but does not enable the module, presumably under the assumption
it will not be called once an OS driver has taken control of the device
(the register containing the enable bit is write-only anyway, so it would
be hard to restore the previous value).  This causes a hang, because once a
single character is put into the transmit buffer it will not become empty
until the transmitter has been enabled.

The serial console as implemented by zs.c handles the case correctly, by
enabling the transmitter, outputting what should be output, waiting for the
transmit shift register to drain and restoring the state of the transmitter
enable (which is held in a shadow variable).

I feel a bit uneasy about keeping serial transmitters enabled for lines
that have not been opened; I gather others may agree as for example while
not explicitly mentioned, I believe it is implied by what is said in
Documentation/serial/driver referring to the ->shutdown() call: "Disable
the port, [...]" -- with the transmitter enabled a port can hardly be
considered fully disabled.  Below is a change which makes the problem
disappear for me, but I suppose there was a deliberate reason for placing
the printk() where it is now and nowhere else.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Gerd Hoffmann <kraxel@suse.de>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Gerd Hoffmann" <kraxel@redhat.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~kernel-printkc-concerns-about-the-console-handover kernel/printk.c
--- a/kernel/printk.c~kernel-printkc-concerns-about-the-console-handover
+++ a/kernel/printk.c
@@ -1137,11 +1137,11 @@ void register_console(struct console *co
 		return;
 
 	if (bootconsole && (console->flags & CON_CONSDEV)) {
+		unregister_console(bootconsole);
+		console->flags &= ~CON_PRINTBUFFER;
 		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
 		       bootconsole->name, bootconsole->index,
 		       console->name, console->index);
-		unregister_console(bootconsole);
-		console->flags &= ~CON_PRINTBUFFER;
 	} else {
 		printk(KERN_INFO "console [%s%d] enabled\n",
 		       console->name, console->index);
_

Patches currently in -mm which might be from macro@linux-mips.org are

git-mips.patch
git-net.patch
phylib-spinlock-fixes-for-softirqs.patch
phylib-irq-event-workqueue-handling-fixes.patch
phylib-fix-an-interrupt-loop-potential-when-halting.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
lk201-remove-obsolete-driver.patch
kernel-printkc-concerns-about-the-console-handover.patch
drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
