From: akpm@linux-foundation.org
Subject: [patch 91/96] drivers: tty: serial: move inline before
 return type
Date: Wed, 12 Jul 2017 14:37:37 -0700
Message-ID: <20170712213737.RKlE9tusC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55302 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVhi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, jslaby@suse.com, mm-commits@vger.kernel.org, pfg@sgi.com, torvalds@linux-foundation.org

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
