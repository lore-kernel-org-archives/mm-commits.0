From: akpm@linux-foundation.org
Subject: [merged] serial-add-parameter-to-force-skipping-the-test-for-the-txen-bug.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:26 -0700
Message-ID: <200910051839.n95IdQTg019082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754737AbZJESkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cebbert@redhat.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: add parameter to force skipping the test for the TXEN bug
has been removed from the -mm tree.  Its filename was
     serial-add-parameter-to-force-skipping-the-test-for-the-txen-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add parameter to force skipping the test for the TXEN bug
From: Chuck Ebbert <cebbert@redhat.com>

Allow users to force skipping the TXEN test at init time. Applies
to all serial ports. Intended for debugging only.

There is a blacklist for devices where we need to skip the test but the
list is not complete.  This lets users force skipping the test so we can
determine if they need to be added to the list.

Some HP machines with weird serial consoles have this problem and there
may be more.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250.c~serial-add-parameter-to-force-skipping-the-test-for-the-txen-bug drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-add-parameter-to-force-skipping-the-test-for-the-txen-bug
+++ a/drivers/serial/8250.c
@@ -64,6 +64,8 @@ static int serial_index(struct uart_port
 	return (serial8250_reg.minor - 64) + port->line;
 }
 
+static unsigned int skip_txen_test; /* force skip of txen test at init time */
+
 /*
  * Debugging.
  */
@@ -2108,7 +2110,7 @@ static int serial8250_startup(struct uar
 	   is variable. So, let's just don't test if we receive
 	   TX irq. This way, we'll never enable UART_BUG_TXEN.
 	 */
-	if (up->port.flags & UPF_NO_TXEN_TEST)
+	if (skip_txen_test || up->port.flags & UPF_NO_TXEN_TEST)
 		goto dont_test_tx_en;
 
 	/*
@@ -3248,6 +3250,9 @@ MODULE_PARM_DESC(share_irqs, "Share IRQs
 module_param(nr_uarts, uint, 0644);
 MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");
 
+module_param(skip_txen_test, uint, 0644);
+MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init time");
+
 #ifdef CONFIG_SERIAL_8250_RSA
 module_param_array(probe_rsa, ulong, &probe_rsa_count, 0444);
 MODULE_PARM_DESC(probe_rsa, "Probe I/O ports for RSA");
_

Patches currently in -mm which might be from cebbert@redhat.com are


