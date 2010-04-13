From: akpm@linux-foundation.org
Subject: + rapidio-add-enabling-srio-port-rx-and-tx.patch added to -mm tree
Date: Mon, 12 Apr 2010 20:56:01 -0400
Message-ID: <201004130357.o3D3vdCb011297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016Ab0DMD56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 23:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.moll@sysgo.com, abounine@tundra.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org


The patch titled
     rapidio: add enabling SRIO port RX and TX
has been added to the -mm tree.  Its filename is
     rapidio-add-enabling-srio-port-rx-and-tx.patch

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
Subject: rapidio: add enabling SRIO port RX and TX
From: Thomas Moll <thomas.moll@sysgo.com>

Add the functionality to enable Input receiver and Output transmitter of
every port, to allow non-maintenance traffic.

Signed-off-by: Thomas Moll <thomas.moll@sysgo.com>
Signed-off-by: Alexandre Bounine <abounine@tundra.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/Kconfig    |   11 ++++
 drivers/rapidio/rio-scan.c |   79 ++++++++++++++++++++++++++++++++++-
 include/linux/rio_regs.h   |    5 ++
 3 files changed, 94 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/Kconfig~rapidio-add-enabling-srio-port-rx-and-tx drivers/rapidio/Kconfig
--- a/drivers/rapidio/Kconfig~rapidio-add-enabling-srio-port-rx-and-tx
+++ a/drivers/rapidio/Kconfig
@@ -9,4 +9,15 @@ config RAPIDIO_DISC_TIMEOUT
 	  Amount of time a discovery node waits for a host to complete
 	  enumeration before giving up.
 
+config RAPIDIO_ENABLE_RX_TX_PORTS
+	bool "Enable RapidIO Input/Output Ports"
+	depends on RAPIDIO
+	---help---
+	  The RapidIO specification describes a Output port transmit
+	  enable and a Input port receive enable. The recommended state
+	  for Input ports and Output ports should be disabled. When
+	  this switch is set the RapidIO subsystem will enable all
+	  ports for Input/Output direction to allow other traffic
+	  than Maintenance transfers.
+
 source "drivers/rapidio/switches/Kconfig"
diff -puN drivers/rapidio/rio-scan.c~rapidio-add-enabling-srio-port-rx-and-tx drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-add-enabling-srio-port-rx-and-tx
+++ a/drivers/rapidio/rio-scan.c
@@ -8,6 +8,10 @@
  * Alex Bounine <alexandre.bounine@idt.com>
  * - Added Port-Write/Error Management initialization and handling
  *
+ * Copyright 2009 Sysgo AG
+ * Thomas Moll <thomas.moll@sysgo.com>
+ * - Added Input- Output- enable functionality, to allow full communication
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
@@ -328,6 +332,65 @@ static int __devinit rio_add_device(stru
 }
 
 /**
+ * rio_enable_rx_tx_port - enable input reciever and output transmitter of
+ * given port
+ * @port: Master port associated with the RIO network
+ * @local: local=1 select local port otherwise a far device is reached
+ * @destid: Destination ID of the device to check host bit
+ * @hopcount: Number of hops to reach the target
+ * @port_num: Port (-number on switch) to enable on a far end device
+ *
+ * Returns 0 or 1 from on General Control Command and Status Register
+ * (EXT_PTR+0x3C)
+ */
+inline int rio_enable_rx_tx_port(struct rio_mport *port,
+				 int local, u16 destid,
+				 u8 hopcount, u8 port_num) {
+#ifdef CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS
+	u32 regval;
+	u32 ext_ftr_ptr;
+
+	/*
+	* enable rx input tx output port
+	*/
+	pr_debug("rio_enable_rx_tx_port(local = %d, destid = %d, hopcount = "
+		 "%d, port_num = %d)\n", local, destid, hopcount, port_num);
+
+	ext_ftr_ptr = rio_mport_get_physefb(port, local, destid, hopcount);
+
+	if (local) {
+		rio_local_read_config_32(port, ext_ftr_ptr +
+				RIO_PORT_N_CTL_CSR(0),
+				&regval);
+	} else {
+		if (rio_mport_read_config_32(port, destid, hopcount,
+		ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), &regval) < 0)
+			return -EIO;
+	}
+
+	if (regval & RIO_PORT_N_CTL_P_TYP_SER) {
+		/* serial */
+		regval = regval | RIO_PORT_N_CTL_EN_RX_SER
+				| RIO_PORT_N_CTL_EN_TX_SER;
+	} else {
+		/* parallel */
+		regval = regval | RIO_PORT_N_CTL_EN_RX_PAR
+				| RIO_PORT_N_CTL_EN_TX_PAR;
+	}
+
+	if (local) {
+		rio_local_write_config_32(port, ext_ftr_ptr +
+					  RIO_PORT_N_CTL_CSR(0), regval);
+	} else {
+		if (rio_mport_write_config_32(port, destid, hopcount,
+		    ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), regval) < 0)
+			return -EIO;
+	}
+#endif
+	return 0;
+}
+
+/**
  * rio_setup_device- Allocates and sets up a RIO device
  * @net: RIO network
  * @port: Master port to send transactions
@@ -430,9 +493,14 @@ static struct rio_dev __devinit *rio_set
 
 		list_add_tail(&rswitch->node, &rio_switches);
 
-	} else
+	} else {
+		if (do_enum)
+			/*Enable Input Output Port (transmitter reviever)*/
+			rio_enable_rx_tx_port(port, 0, destid, hopcount, 0);
+
 		dev_set_name(&rdev->dev, "%02x:e:%04x", rdev->net->id,
 			     rdev->destid);
+	}
 
 	rdev->dev.bus = &rio_bus_type;
 
@@ -812,6 +880,11 @@ static int __devinit rio_enum_peer(struc
 		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
 		sw_destid = next_destid;
 		for (port_num = 0; port_num < num_ports; port_num++) {
+			/*Enable Input Output Port (transmitter reviever)*/
+			rio_enable_rx_tx_port(port, 0,
+					      RIO_ANY_DESTID(port->sys_size),
+					      hopcount, port_num);
+
 			if (sw_inport == port_num) {
 				rdev->rswitch->port_ok |= (1 << port_num);
 				continue;
@@ -1132,6 +1205,10 @@ int __devinit rio_enum_mport(struct rio_
 			rc = -ENOMEM;
 			goto out;
 		}
+
+		/* Enable Input Output Port (transmitter reviever) */
+		rio_enable_rx_tx_port(mport, 1, 0, 0, 0);
+
 		if (rio_enum_peer(net, mport, 0) < 0) {
 			/* A higher priority host won enumeration, bail. */
 			printk(KERN_INFO
diff -puN include/linux/rio_regs.h~rapidio-add-enabling-srio-port-rx-and-tx include/linux/rio_regs.h
--- a/include/linux/rio_regs.h~rapidio-add-enabling-srio-port-rx-and-tx
+++ a/include/linux/rio_regs.h
@@ -243,7 +243,12 @@
 #define  RIO_PORT_N_CTL_PWIDTH		0xc0000000
 #define  RIO_PORT_N_CTL_PWIDTH_1	0x00000000
 #define  RIO_PORT_N_CTL_PWIDTH_4	0x40000000
+#define  RIO_PORT_N_CTL_P_TYP_SER	0x00000001
 #define  RIO_PORT_N_CTL_LOCKOUT		0x00000002
+#define  RIO_PORT_N_CTL_EN_RX_SER	0x00200000
+#define  RIO_PORT_N_CTL_EN_TX_SER	0x00400000
+#define  RIO_PORT_N_CTL_EN_RX_PAR	0x08000000
+#define  RIO_PORT_N_CTL_EN_TX_PAR	0x40000000
 
 /*
  * Error Management Extensions (RapidIO 1.3+, Part 8)
_

Patches currently in -mm which might be from thomas.moll@sysgo.com are

rapidio-add-idt-cps-tsi-switches.patch
rapidio-add-switch-locking-during-discovery.patch
rapidio-add-port-write-handling-for-em.patch
rapidio-powerpc-85xx-add-port-write-message-handler-for-srio-port.patch
rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch
rapidio-add-enabling-srio-port-rx-and-tx.patch

