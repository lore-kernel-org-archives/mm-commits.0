From: akpm@linux-foundation.org
Subject: - char-icom-mark-__init-as-__devinit.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:11 -0700
Message-ID: <200704252039.l3PKdBC0012283@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993123AbXDYUjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: icom, mark __init as __devinit
has been removed from the -mm tree.  Its filename was
     char-icom-mark-__init-as-__devinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: icom, mark __init as __devinit
From: Jiri Slaby <jirislaby@gmail.com>

Two functions are called from __devinit context, but they are marked as
__init. Fix this.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/icom.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/icom.c~char-icom-mark-__init-as-__devinit drivers/serial/icom.c
--- a/drivers/serial/icom.c~char-icom-mark-__init-as-__devinit
+++ a/drivers/serial/icom.c
@@ -164,7 +164,7 @@ static void free_port_memory(struct icom
 	}
 }
 
-static int __init get_port_memory(struct icom_port *icom_port)
+static int __devinit get_port_memory(struct icom_port *icom_port)
 {
 	int index;
 	unsigned long stgAddr;
@@ -1380,7 +1380,7 @@ static void icom_port_active(struct icom
 			    0x8024 + 2 - 2 * (icom_port->port - 2);
 	}
 }
-static int __init icom_load_ports(struct icom_adapter *icom_adapter)
+static int __devinit icom_load_ports(struct icom_adapter *icom_adapter)
 {
 	struct icom_port *icom_port;
 	int port_num;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
acpi-asus_acpi-support-f2je-model.patch
input-ff-add-ff_raw-effect.patch
input-phantom-add-a-new-driver.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
shrink_slab-handle-bad-shrinkers.patch
