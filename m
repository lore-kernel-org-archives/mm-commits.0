From: akpm@linux-foundation.org
Subject: [merged] serial-bfin_5xx-add-missing-spin_lock-init.patch removed from -mm tree
Date: Tue, 23 Jun 2009 11:05:53 -0700
Message-ID: <200906231805.n5NI5rmm009984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632AbZFWSHA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 14:07:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, alan@lxorguk.ukuu.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     serial: bfin_5xx: add missing spin_lock init
has been removed from the -mm tree.  Its filename was
     serial-bfin_5xx-add-missing-spin_lock-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: bfin_5xx: add missing spin_lock init
From: Mike Frysinger <vapier@gentoo.org>

The Blackfin serial driver never initialized the spin_lock that is part of
the serial core structure, but we never noticed because spin_lock's are
rarely enabled on UP systems.  Yeah lockdep and friends.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/bfin_5xx.c~serial-bfin_5xx-add-missing-spin_lock-init drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~serial-bfin_5xx-add-missing-spin_lock-init
+++ a/drivers/serial/bfin_5xx.c
@@ -1110,6 +1110,7 @@ static void __init bfin_serial_init_port
 	bfin_serial_hw_init();
 
 	for (i = 0; i < nr_active_ports; i++) {
+		spin_lock_init(&bfin_serial_ports[i].port.lock);
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
 		bfin_serial_ports[i].port.fifosize  = BFIN_UART_TX_FIFO_SIZE;
 		bfin_serial_ports[i].port.ops       = &bfin_serial_pops;
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
rmap-fixup-page_referenced-for-nommu-systems.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch

