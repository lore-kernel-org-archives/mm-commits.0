From: akpm@linux-foundation.org
Subject: + serial-copy-uart-properties-of-upf_fixed_type-ports-provisioned-using-early_serial_setup.patch added to -mm tree
Date: Wed, 28 Oct 2009 22:47:44 -0700
Message-ID: <200910290547.n9T5li8V027224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896AbZJ2FsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Oct 2009 01:48:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shmulik@jungo.com, alan@lxorguk.ukuu.org.uk


The patch titled
     serial: copy UART properties of UPF_FIXED_TYPE ports provisioned using early_serial_setup
has been added to the -mm tree.  Its filename is
     serial-copy-uart-properties-of-upf_fixed_type-ports-provisioned-using-early_serial_setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: copy UART properties of UPF_FIXED_TYPE ports provisioned using early_serial_setup
From: Shmulik Ladkani <shmulik@jungo.com>

Augment the UPF_FIXED_TYPE logic, which currently applies to UART ports
provisioned using platform_device_register.

The suggested patch applies same logic into 'serial8250_register_ports',
making UART ports provisioned using early_serial_setup inherit their
properties from the uart_config entry.

Signed-off-by: Shmulik Ladkani <shmulik@jungo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/serial/8250.c~serial-copy-uart-properties-of-upf_fixed_type-ports-provisioned-using-early_serial_setup drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-copy-uart-properties-of-upf_fixed_type-ports-provisioned-using-early_serial_setup
+++ a/drivers/serial/8250.c
@@ -2706,6 +2706,14 @@ serial8250_register_ports(struct uart_dr
 		struct uart_8250_port *up = &serial8250_ports[i];
 
 		up->port.dev = dev;
+
+		if (up->port.flags & UPF_FIXED_TYPE) {
+			up->port.fifosize =
+				uart_config[up->port.type].fifo_size;
+			up->capabilities = uart_config[up->port.type].flags;
+			up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
+		}
+
 		uart_add_one_port(drv, &up->port);
 	}
 }
_

Patches currently in -mm which might be from shmulik@jungo.com are

serial-copy-uart-properties-of-upf_fixed_type-ports-provisioned-using-early_serial_setup.patch

