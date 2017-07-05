From: akpm@linux-foundation.org
Subject: + drivers-tty-serial-move-inline-before-return-type.patch added
 to -mm tree
Date: Wed, 05 Jul 2017 13:45:28 -0700
Message-ID: <595d4fe8.UVf64st3bxyuYFsW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753487AbdGEUp3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, jslaby@suse.com, pfg@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: tty: serial: move inline before return type
has been added to the -mm tree.  Its filename is
     drivers-tty-serial-move-inline-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-tty-serial-move-inline-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-tty-serial-move-inline-before-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: drivers: tty: serial: move inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/55d3e89d50bb03d603bfb28019fab07f48bdc714.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Pat Gefre <pfg@sgi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/ioc3_serial.c |    4 ++--
 drivers/tty/serial/ioc4_serial.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/tty/serial/ioc3_serial.c~drivers-tty-serial-move-inline-before-return-type drivers/tty/serial/ioc3_serial.c
--- a/drivers/tty/serial/ioc3_serial.c~drivers-tty-serial-move-inline-before-return-type
+++ a/drivers/tty/serial/ioc3_serial.c
@@ -377,7 +377,7 @@ static struct ioc3_port *get_ioc3_port(s
  *			called per port from attach...
  * @port: port to initialize
  */
-static int inline port_init(struct ioc3_port *port)
+static inline int port_init(struct ioc3_port *port)
 {
 	uint32_t sio_cr;
 	struct port_hooks *hooks = port->ip_hooks;
@@ -1430,7 +1430,7 @@ static int receive_chars(struct uart_por
  * @pending: interrupts to handle
  */
 
-static int inline
+static inline int
 ioc3uart_intr_one(struct ioc3_submodule *is,
 			struct ioc3_driver_data *idd,
 			unsigned int pending)
diff -puN drivers/tty/serial/ioc4_serial.c~drivers-tty-serial-move-inline-before-return-type drivers/tty/serial/ioc4_serial.c
--- a/drivers/tty/serial/ioc4_serial.c~drivers-tty-serial-move-inline-before-return-type
+++ a/drivers/tty/serial/ioc4_serial.c
@@ -824,7 +824,7 @@ pending_intrs(struct ioc4_soft *soft, in
  *			called per port from attach...
  * @port: port to initialize
  */
-static int inline port_init(struct ioc4_port *port)
+static inline int port_init(struct ioc4_port *port)
 {
 	uint32_t sio_cr;
 	struct hooks *hooks = port->ip_hooks;
@@ -1048,7 +1048,7 @@ static irqreturn_t ioc4_intr(int irq, vo
  *			IOC4 with serial ports in the system.
  * @idd: Master module data for this IOC4
  */
-static int inline ioc4_attach_local(struct ioc4_driver_data *idd)
+static inline int ioc4_attach_local(struct ioc4_driver_data *idd)
 {
 	struct ioc4_port *port;
 	struct ioc4_port *ports[IOC4_NUM_SERIAL_PORTS];
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

