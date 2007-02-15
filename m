From: akpm@linux-foundation.org
Subject: + Fabric7-VIOC-driver.patch added to -mm tree
Date: Wed, 14 Feb 2007 22:43:32 -0800
Message-ID: <200702150643.l1F6hWjS022125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36691 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964912AbXBOGnt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 01:43:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schidambaram@fabric7.com, driver-support@fabric7.com


The patch titled
     Fabric7 VIOC driver
has been added to the -mm tree.  Its filename is
     Fabric7-VIOC-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Fabric7 VIOC driver
=46rom: Sriram Chidambaram <schidambaram@fabric7.com>

This patch provides the Fabric7 VIOC driver source code.


Overview
=3D=3D=3D=3D=3D=3D=3D=3D

A Virtual Input-Output Controller (VIOC) is a PCI device that provides
10Gbps of I/O bandwidth that can be shared by up to 16 virtual network
interfaces (VNICs).  VIOC hardware supports several features such as
large frames, checksum offload, gathered send, MSI/MSI-X, bandwidth
control, interrupt mitigation, etc.

VNICs are provisioned to a host partition via an out-of-band interface
from the System Controller -- typically before the partition boots,
although they can be dynamically added or removed from a running
partition as well.

Each provisioned VNIC appears as an Ethernet netdevice to the host OS,
and maintains its own transmit ring in DMA memory.  VNICs are
configured to share up to 4 of total 16 receive rings and 1 of total
16 receive-completion rings in DMA memory.  VIOC hardware classifies
packets into receive rings based on size, allowing more efficient use
of DMA buffer memory.  The default, and recommended, configuration
uses groups of 'receive sets' (rxsets), each with 3 receive rings, a
receive completion ring, and a VIOC Rx interrupt.  The driver gives
each rxset a NAPI poll handler associated with a phantom (invisible)
netdevice, for concurrency.  VNICs are assigned to rxsets using a
simple modulus.

VIOC provides 4 interrupts in INTx mode: 2 for Rx, 1 for Tx, and 1 for
out-of-band messages from the System Controller and errors.  VIOC also
provides 19 MSI-X interrupts: 16 for Rx, 1 for Tx, 1 for out-of-band
messages from the System Controller, and 1 for error signalling from
the hardware.  The VIOC driver makes a determination whether MSI-X
functionality is supported and initializes interrupts accordingly.
[Note: The Linux kernel disables MSI-X for VIOCs on modules with AMD
8131, even if the device is on the HT link.]


Module loadable parameters
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

- poll_weight (default 8) - the number of received packets will be
  processed during one call into the NAPI poll handler.

- rx_intr_timeout (default 1) - hardware rx interrupt mitigation
  timer, in units of 5us.

- rx_intr_pkt_cnt (default 64) - hardware rx interrupt mitigation
  counter, in units of packets.

- tx_pkts_per_irq (default 64) - hardware tx interrupt mitigation
  counter, in units of packets.

- tx_pkts_per_bell (default 1) - the number of packets to enqueue on a
  transmit ring before issuing a doorbell to hardware.

Performance Tuning
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

You may want to use the following sysctl settings to improve
performance.  [NOTE: To be re-checked]

# set in /etc/sysctl.conf

net.ipv4.tcp_timestamps =3D 0
net.ipv4.tcp_sack =3D 0
net.ipv4.tcp_rmem =3D 10000000 10000000 10000000
net.ipv4.tcp_wmem =3D 10000000 10000000 10000000
net.ipv4.tcp_mem  =3D 10000000 10000000 10000000

net.core.rmem_max =3D 5242879
net.core.wmem_max =3D 5242879
net.core.rmem_default =3D 5242879
net.core.wmem_default =3D 5242879
net.core.optmem_max =3D 5242879
net.core.netdev_max_backlog =3D 100000

Out-of-band Communications with System Controller
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

System operators can use the out-of-band facility to allow for remote
shutdown or reboot of the host partition.  Upon receiving such a
command, the VIOC driver executes "/sbin/reboot" or "/sbin/shutdown"
via the usermodehelper() call.

This same communications facility is used for dynamic VNIC
provisioning (plug in and out).

The VIOC driver also registers a callback with
register_reboot_notifier().  When the callback is executed, the driver
records the shutdown event and reason in a VIOC register to notify the
System Controller.



Signed-off-by: Fabric7 Driver-Support <driver-support@fabric7.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/vioc.txt         |   98=20
 MAINTAINERS                               |    5=20
 drivers/net/Kconfig                       |    9=20
 drivers/net/Makefile                      |    1=20
 drivers/net/vioc/Makefile                 |   34=20
 drivers/net/vioc/driver_version.h         |   27=20
 drivers/net/vioc/f7/spp.h                 |   68=20
 drivers/net/vioc/f7/spp_msgdata.h         |   54=20
 drivers/net/vioc/f7/sppapi.h              |  240 ++
 drivers/net/vioc/f7/vioc_bmc_registers.h  | 1343 ++++++++++++
 drivers/net/vioc/f7/vioc_ht_registers.h   |  771 +++++++
 drivers/net/vioc/f7/vioc_hw_registers.h   |  160 +
 drivers/net/vioc/f7/vioc_ihcu_registers.h |  550 +++++
 drivers/net/vioc/f7/vioc_le_registers.h   |  241 ++
 drivers/net/vioc/f7/vioc_msi_registers.h  |  111 +
 drivers/net/vioc/f7/vioc_pkts_defs.h      |  853 +++++++
 drivers/net/vioc/f7/vioc_veng_registers.h |  299 ++
 drivers/net/vioc/f7/vioc_ving_registers.h |  327 +++
 drivers/net/vioc/f7/vnic_defs.h           | 2168 ++++++++++++++++++++
 drivers/net/vioc/khash.h                  |   65=20
 drivers/net/vioc/spp.c                    |  626 +++++
 drivers/net/vioc/spp_vnic.c               |  131 +
 drivers/net/vioc/vioc_api.c               |  384 +++
 drivers/net/vioc/vioc_api.h               |   64=20
 drivers/net/vioc/vioc_driver.c            |  872 ++++++++
 drivers/net/vioc/vioc_ethtool.c           |  303 ++
 drivers/net/vioc/vioc_irq.c               |  517 ++++
 drivers/net/vioc/vioc_provision.c         |  226 ++
 drivers/net/vioc/vioc_receive.c           |  367 +++
 drivers/net/vioc/vioc_spp.c               |  390 +++
 drivers/net/vioc/vioc_transmit.c          | 1034 +++++++++
 drivers/net/vioc/vioc_vnic.h              |  515 ++++
 32 files changed, 12853 insertions(+)

diff -puN /dev/null Documentation/networking/vioc.txt
--- /dev/null
+++ a/Documentation/networking/vioc.txt
@@ -0,0 +1,98 @@
+                VIOC Driver Release Notes (07/12/06)
+                =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+                     driver-support@fabric7.com
+
+
+Overview
+=3D=3D=3D=3D=3D=3D=3D=3D
+
+A Virtual Input-Output Controller (VIOC) is a PCI device that provides
+10Gbps of I/O bandwidth that can be shared by up to 16 virtual network
+interfaces (VNICs).  VIOC hardware supports several features such as
+large frames, checksum offload, gathered send, MSI/MSI-X, bandwidth
+control, interrupt mitigation, etc.
+
+VNICs are provisioned to a host partition via an out-of-band interface
+from the System Controller -- typically before the partition boots,
+although they can be dynamically added or removed from a running
+partition as well.
+
+Each provisioned VNIC appears as an Ethernet netdevice to the host OS,
+and maintains its own transmit ring in DMA memory.  VNICs are
+configured to share up to 4 of total 16 receive rings and 1 of total
+16 receive-completion rings in DMA memory.  VIOC hardware classifies
+packets into receive rings based on size, allowing more efficient use
+of DMA buffer memory.  The default, and recommended, configuration
+uses groups of 'receive sets' (rxsets), each with 3 receive rings, a
+receive completion ring, and a VIOC Rx interrupt.  The driver gives
+each rxset a NAPI poll handler associated with a phantom (invisible)
+netdevice, for concurrency.  VNICs are assigned to rxsets using a
+simple modulus.
+
+VIOC provides 4 interrupts in INTx mode: 2 for Rx, 1 for Tx, and 1 for
+out-of-band messages from the System Controller and errors.  VIOC also
+provides 19 MSI-X interrupts: 16 for Rx, 1 for Tx, 1 for out-of-band
+messages from the System Controller, and 1 for error signalling from
+the hardware.  The VIOC driver makes a determination whether MSI-X
+functionality is supported and initializes interrupts accordingly.
+[Note: The Linux kernel disables MSI-X for VIOCs on modules with AMD
+8131, even if the device is on the HT link.]
+
+
+Module loadable parameters
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+
+- poll_weight (default 8) - the number of received packets will be
+  processed during one call into the NAPI poll handler.
+
+- rx_intr_timeout (default 1) - hardware rx interrupt mitigation
+  timer, in units of 5us.
+
+- rx_intr_pkt_cnt (default 64) - hardware rx interrupt mitigation
+  counter, in units of packets.
+
+- tx_pkts_per_irq (default 64) - hardware tx interrupt mitigation
+  counter, in units of packets.
+
+- tx_pkts_per_bell (default 1) - the number of packets to enqueue on a
+  transmit ring before issuing a doorbell to hardware.
+
+Performance Tuning
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+You may want to use the following sysctl settings to improve
+performance.  [NOTE: To be re-checked]
+
+# set in /etc/sysctl.conf
+
+net.ipv4.tcp_timestamps =3D 0
+net.ipv4.tcp_sack =3D 0
+net.ipv4.tcp_rmem =3D 10000000 10000000 10000000
+net.ipv4.tcp_wmem =3D 10000000 10000000 10000000
+net.ipv4.tcp_mem  =3D 10000000 10000000 10000000
+
+net.core.rmem_max =3D 5242879
+net.core.wmem_max =3D 5242879
+net.core.rmem_default =3D 5242879
+net.core.wmem_default =3D 5242879
+net.core.optmem_max =3D 5242879
+net.core.netdev_max_backlog =3D 100000
+
+Out-of-band Communications with System Controller
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
+
+System operators can use the out-of-band facility to allow for remote
+shutdown or reboot of the host partition.  Upon receiving such a
+command, the VIOC driver executes "/sbin/reboot" or "/sbin/shutdown"
+via the usermodehelper() call.
+
+This same communications facility is used for dynamic VNIC
+provisioning (plug in and out).
+
+The VIOC driver also registers a callback with
+register_reboot_notifier().  When the callback is executed, the driver
+records the shutdown event and reason in a VIOC register to notify the
+System Controller.
+
+
+
diff -puN MAINTAINERS~Fabric7-VIOC-driver MAINTAINERS
--- a/MAINTAINERS~Fabric7-VIOC-driver
+++ a/MAINTAINERS
@@ -3689,6 +3689,11 @@ L:	rio500-users@lists.sourceforge.net
 W:	http://rio500.sourceforge.net
 S:	Maintained
=20
+VIOC NETWORK DRIVER
+P:     support@fabric7.com
+L:     netdev@vger.kernel.org
+S:     Maintained
+
 VIDEO FOR LINUX
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
diff -puN drivers/net/Kconfig~Fabric7-VIOC-driver drivers/net/Kconfig
--- a/drivers/net/Kconfig~Fabric7-VIOC-driver
+++ a/drivers/net/Kconfig
@@ -2511,6 +2511,15 @@ config PASEMI_MAC
 	  This driver supports the on-chip 1/10Gbit Ethernet controller on
 	  PA Semi's PWRficient line of chips.
=20
+config VIOC
+	tristate "Fabric7 VIOC support"
+	depends on PCI
+	help
+	 This driver supports the Virtual Input-Output Controller (VIOC) a
+	 single PCI device that provides 10Gbps of I/O bandwidth that can be
+	 shared by up to 16 virtual network interfaces (VNICs).
+	 See <file:Documentation/networking/vioc.txt> for more information
+
 endmenu
=20
 source "drivers/net/tokenring/Kconfig"
diff -puN drivers/net/Makefile~Fabric7-VIOC-driver drivers/net/Makefile
--- a/drivers/net/Makefile~Fabric7-VIOC-driver
+++ a/drivers/net/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_IBM_EMAC) +=3D ibm_emac/
 obj-$(CONFIG_IXGB) +=3D ixgb/
 obj-$(CONFIG_CHELSIO_T1) +=3D chelsio/
 obj-$(CONFIG_CHELSIO_T3) +=3D cxgb3/
+obj-$(CONFIG_VIOC) +=3D vioc/
 obj-$(CONFIG_EHEA) +=3D ehea/
 obj-$(CONFIG_BONDING) +=3D bonding/
 obj-$(CONFIG_ATL1) +=3D atl1/
diff -puN /dev/null drivers/net/vioc/Makefile
--- /dev/null
+++ a/drivers/net/vioc/Makefile
@@ -0,0 +1,34 @@
+######################################################################=
##########
+#
+#
+# Copyright(c) 2003-2006 Fabric7 Systems. All rights reserved.
+#
+# This program is free software; you can redistribute it and/or modify=
 it
+# under the terms of the GNU General Public License as published by th=
e Free
+# Software Foundation; either version 2 of the License, or (at your op=
tion)
+# any later version.
+#
+# This program is distributed in the hope that it will be useful, but =
WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY o=
r
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licens=
e for
+# more details.
+#
+# You should have received a copy of the GNU General Public License al=
ong with
+# this program; if not, write to the Free Software Foundation, Inc., 5=
9
+# Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+#
+# The full GNU General Public License is included in this distribution=
 in the
+# file called LICENSE.
+#
+# Contact Information:
+# <support@fabric7.com>
+# Fabric7 Systems, 1300 Crittenden Lane Suite 302 Mountain View, CA 94=
043
+#
+######################################################################=
##########
+
+obj-$(CONFIG_VIOC) +=3D vioc.o
+
+vioc-objs :=3D vioc_driver.o vioc_transmit.o vioc_receive.o vioc_api.o=
 \
+            vioc_spp.o vioc_irq.o spp.o spp_vnic.o vioc_provision.o \
+            vioc_ethtool.o
+
diff -puN /dev/null drivers/net/vioc/driver_version.h
--- /dev/null
+++ a/drivers/net/vioc/driver_version.h
@@ -0,0 +1,27 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#define VIOC_DISPLAY_VERSION "VER09.00.00"
diff -puN /dev/null drivers/net/vioc/f7/spp.h
--- /dev/null
+++ a/drivers/net/vioc/f7/spp.h
@@ -0,0 +1,68 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#ifndef _SPP_H_
+#define _SPP_H_
+
+#include "vioc_hw_registers.h"
+
+#define SPP_MODULE     VIOC_BMC
+
+#define SPP_CMD_REG_BANK       15
+#define SPP_SIM_PMM_BANK       14
+#define        SPP_PMM_BMC_BANK        13
+
+/* communications COMMAND REGISTERS */
+#define SPP_SIM_PMM_CMDREG     GETRELADDR(SPP_MODULE, SPP_CMD_REG_BANK=
, VREG_BMC_REG_R1)
+#define VIOCCP_SPP_SIM_PMM_CMDREG              \
+                       VIOCCP_GETRELADDR(SPP_MODULE, SPP_CMD_REG_BANK,=
 VREG_BMC_REG_R1)
+#define SPP_PMM_SIM_CMDREG     GETRELADDR(SPP_MODULE, SPP_CMD_REG_BANK=
, VREG_BMC_REG_R2)
+#define VIOCCP_SPP_PMM_SIM_CMDREG              \
+                       VIOCCP_GETRELADDR(SPP_MODULE, SPP_CMD_REG_BANK,=
 VREG_BMC_REG_R2)
+#define SPP_PMM_BMC_HB_CMDREG  GETRELADDR(SPP_MODULE, SPP_CMD_REG_BANK=
, VREG_BMC_REG_R3)
+#define SPP_PMM_BMC_SIG_CMDREG GETRELADDR(SPP_MODULE, SPP_CMD_REG_BANK=
, VREG_BMC_REG_R4)
+#define SPP_PMM_BMC_CMDREG     GETRELADDR(SPP_MODULE, SPP_CMD_REG_BANK=
, VREG_BMC_REG_R5)
+
+#define SPP_BANK_ADDR(bank) GETRELADDR(SPP_MODULE, bank, VREG_BMC_REG_=
R0)
+
+#define SPP_SIM_PMM_DATA GETRELADDR(SPP_MODULE, SPP_SIM_PMM_BANK, VREG=
_BMC_REG_R0)
+#define VIOCCP_SPP_SIM_PMM_DATA                        \
+                       VIOCCP_GETRELADDR(SPP_MODULE, SPP_SIM_PMM_BANK,=
 VREG_BMC_REG_R0)
+
+/* PMM-BMC Sensor register bits */
+#define SPP_PMM_BMC_HB_SENREG  GETRELADDR(SPP_MODULE, 0, VREG_BMC_SENS=
OR0)
+#define SPP_PMM_BMC_CTL_SENREG GETRELADDR(SPP_MODULE, 0, VREG_BMC_SENS=
OR1)
+#define SPP_PMM_BMC_SENREG     GETRELADDR(SPP_MODULE, 0, VREG_BMC_SENS=
OR2)
+
+/* BMC Interrupt number used to alert PMM that message has been sent *=
/
+#define SPP_SIM_PMM_INTR       1
+#define SPP_BANK_REGS          32
+
+
+#define SPP_OK                 0
+#define SPP_CHKSUM_ERR 1
+#endif /* _SPP_H_ */
+
diff -puN /dev/null drivers/net/vioc/f7/spp_msgdata.h
--- /dev/null
+++ a/drivers/net/vioc/f7/spp_msgdata.h
@@ -0,0 +1,54 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#ifndef _SPPMSGDATA_H_
+#define _SPPMSGDATA_H_
+
+#include "spp.h"
+
+/* KEYs For SPP_FACILITY_VNIC */
+#define SPP_KEY_VNIC_CTL       1
+#define SPP_KEY_SET_PROV       2
+
+/* Data Register Offset for VIOC ID parameter */
+#define SPP_VIOC_ID_IDX        0
+#define SPP_VIOC_ID_OFFSET GETRELADDR(SPP_MODULE, SPP_SIM_PMM_BANK, (V=
REG_BMC_REG_R0 + (SPP_VIOC_ID_IDX << 2)))
+#define VIOCCP_SPP_VIOC_ID_OFFSET VIOCCP_GETRELADDR(SPP_MODULE, SPP_SI=
M_PMM_BANK, (VREG_BMC_REG_R0 + (SPP_VIOC_ID_IDX << 2)))
+
+/* KEYs for  SPP_FACILITY_SYS  */
+#define SPP_KEY_REQUEST_SIGNAL 1
+
+/* Data Register Offset for RESET_TYPE parameter */
+#define SPP_UOS_RESET_TYPE_IDX 0
+#define SPP_UOS_RESET_TYPE_OFFSET GETRELADDR(SPP_MODULE, SPP_SIM_PMM_B=
ANK, (VREG_BMC_REG_R0 + (SPP_UOS_RESET_TYPE_IDX << 2)))
+#define VIOCCP_SPP_UOS_RESET_TYPE_OFFSET VIOCCP_GETRELADDR(SPP_MODULE,=
 SPP_SIM_PMM_BANK, (VREG_BMC_REG_R0 + (SPP_UOS_RESET_TYPE_IDX << 2)))
+
+#define SPP_RESET_TYPE_REBOOT  1
+#define SPP_RESET_TYPE_SHUTDOWN        2
+
+#endif /* _SPPMSGDATA_H_ */
+
+
diff -puN /dev/null drivers/net/vioc/f7/sppapi.h
--- /dev/null
+++ a/drivers/net/vioc/f7/sppapi.h
@@ -0,0 +1,240 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#ifndef _SPPAPI_H_
+#define _SPPAPI_H_
+
+/*
+ * COMMAND REGISTER is encoded as follows:
+ * |-------------|-------------|--------|-----|----|------------|-----=
----|
+ * | chksum:     | unique id:  | spare: | RC: | D: | facility:  | key:=
    |
+ * | 31 30 29 28 | 27 26 25 24 | 23 22  | 21  | 20 | 19 18 17 16| 15 -=
 0  |
+ * |-------------|-------------|--------|-----|----|------------|-----=
----|
+ */
+
+#define SPP_KEY_MASK           0x0000ffff
+#define SPP_KEY_SHIFT  0
+#define SPP_KEY_MASK_SHIFTED   (SPP_KEY_MASK >> SPP_KEY_SHIFT)
+#define SPP_FACILITY_MASK      0x000f0000
+#define SPP_FACILITY_SHIFT     16
+#define SPP_FACILITY_MASK_SHIFTED      (SPP_FACILITY_MASK >> SPP_FACIL=
ITY_SHIFT)
+#define SPP_D_MASK                     0x00100000
+#define SPP_D_SHIFT                    20
+#define SPP_D_MASK_SHIFTED     (SPP_D_MASK >> SPP_D_SHIFT)
+#define SPP_RC_MASK                    0x00200000
+#define SPP_RC_SHIFT           21
+#define SPP_RC_MASK_SHIFTED    (SPP_RC_MASK >> SPP_RC_SHIFT)
+#define SPP_UNIQID_MASK                0x0f000000
+#define SPP_UNIQID_SHIFT       24
+#define SPP_UNIQID_MASK_SHIFTED        (SPP_UNIQID_MASK >> SPP_UNIQID_=
SHIFT)
+#define SPP_CHKSUM_MASK                0xf0000000
+#define SPP_CHKSUM_SHIFT       28
+#define SPP_CHKSUM_MASK_SHIFTED        (SPP_CHKSUM_MASK >> SPP_CHKSUM_=
SHIFT)
+
+#define SPP_GET_KEY(m)                         \
+    ((m & SPP_KEY_MASK) >> SPP_KEY_SHIFT)
+
+#define SPP_GET_FACILITY(m)                            \
+    ((m & SPP_FACILITY_MASK) >> SPP_FACILITY_SHIFT)
+
+#define SPP_GET_D(m)                                   \
+    ((m & SPP_D_MASK) >> SPP_D_SHIFT)
+
+#define SPP_GET_RC(m)                                  \
+    ((m & SPP_D_MASK) >> SPP_D_SHIFT)
+
+#define SPP_GET_UNIQID(m)                                      \
+    ((m & SPP_UNIQID_MASK) >> SPP_UNIQID_SHIFT)
+
+#define SPP_GET_CHKSUM(m)                                      \
+    ((m & SPP_CHKSUM_MASK) >> SPP_CHKSUM_SHIFT)
+
+#define SPP_SET_KEY(m, key) do { \
+    m =3D ((m & ~SPP_KEY_MASK) | ((key << SPP_KEY_SHIFT) & SPP_KEY_MAS=
K)) ; \
+} while (0)
+
+#define SPP_SET_FACILITY(m, facility) do { \
+    m =3D ((m & ~SPP_FACILITY_MASK) | ((facility << SPP_FACILITY_SHIFT=
) & SPP_FACILITY_MASK)) ; \
+} while (0)
+
+#define SPP_MBOX_FREE          0
+#define SPP_MBOX_OCCUPIED      1
+
+#define SPP_MBOX_EMPTY(m) (SPP_GET_D(m) =3D=3D SPP_MBOX_FREE)
+#define SPP_MBOX_FULL(m) (SPP_GET_D(m) =3D=3D SPP_MBOX_OCCUPIED)
+
+#define SPP_SET_D(m, D) do { \
+    m =3D ((m & ~SPP_D_MASK) | ((D << SPP_D_SHIFT) & SPP_D_MASK)) ; \
+} while (0)
+
+#define        SPP_CMD_OK              0
+#define SPP_CMD_FAIL   1
+
+#define SPP_SET_RC(m, rc) do { \
+    m =3D ((m & ~SPP_RC_MASK) | ((rc << SPP_RC_SHIFT) & SPP_RC_MASK)) =
; \
+} while (0)
+
+#define SPP_SET_UNIQID(m, uniqid) do { \
+    m =3D ((m & ~SPP_UNIQID_MASK) | ((uniqid << SPP_UNIQID_SHIFT) & SP=
P_UNIQID_MASK)) ; \
+} while (0)
+
+
+#define SPP_SET_CHKSUM(m, chksum) do { \
+    m =3D ((m & ~SPP_CHKSUM_MASK) | ((chksum << SPP_CHKSUM_SHIFT) & SP=
P_CHKSUM_MASK)) ; \
+} while (0)
+
+
+static inline u32 spp_calc_u32_4bit_chksum(u32 w, int n)
+{
+       int len;
+       int nibbles =3D (n > 8) ? 8:n;
+       u32 cs =3D 0;
+
+       for (len =3D 0; len < nibbles; len++) {
+               w =3D (w >> len);
+               cs +=3D w  & SPP_CHKSUM_MASK_SHIFTED;
+       }
+
+       while (cs >> 4)
+               cs =3D (cs & SPP_CHKSUM_MASK_SHIFTED) + (cs >> 4);
+
+       return (~cs);
+}
+
+static inline u32 spp_calc_u32_chksum(u32 w)
+{
+       return (spp_calc_u32_4bit_chksum(w, 7));
+}
+
+static inline u32
+spp_validate_u32_chksum(u32 w)
+{
+       return (spp_calc_u32_4bit_chksum(w, 8) & SPP_CHKSUM_MASK_SHIFTE=
D);
+}
+
+static inline u32
+spp_mbox_build_cmd(u32 key, u32 facility, u32 uniqid)
+{
+       u32     m =3D 0;
+       u32 cs;
+
+       SPP_SET_KEY(m, key);
+       SPP_SET_FACILITY(m, facility);
+       SPP_SET_UNIQID(m, uniqid);
+       SPP_SET_D(m, SPP_MBOX_OCCUPIED);
+       cs =3D spp_calc_u32_4bit_chksum(m, 7);
+       cs =3D (cs)?cs:~cs;
+       SPP_SET_CHKSUM(m, cs);
+
+       return (m);
+}
+
+static inline u32
+spp_build_key_facility(u32 key, u32 facility)
+{
+       u32     m =3D 0;
+
+       SPP_SET_KEY(m, key);
+       SPP_SET_FACILITY(m, facility);
+
+       return (m);
+}
+
+
+static inline u32
+spp_mbox_build_reply(u32 cmd, int success)
+{
+       u32 reply =3D cmd;
+       u32 cs;
+
+       SPP_SET_D(reply, SPP_MBOX_FREE);
+       if (success =3D=3D SPP_CMD_OK)
+               SPP_SET_RC(reply, SPP_CMD_OK);
+       else
+               SPP_SET_RC(reply, SPP_CMD_FAIL);
+
+       cs =3D spp_calc_u32_4bit_chksum(reply, 7);
+       cs =3D (cs)?cs:~cs;
+       SPP_SET_CHKSUM(reply, cs);
+
+       return (reply);
+}
+
+static inline int
+spp_mbox_empty(u32 m)
+{
+       return SPP_MBOX_EMPTY(m);
+}
+
+static inline int
+spp_mbox_full(u32 m)
+{
+       return SPP_MBOX_FULL(m);
+}
+
+/*
+ * SPP Facilities 0 - 15
+ */
+
+#define SPP_FACILITY_VNIC      0       /* VNIC Provisioning */
+#define SPP_FACILITY_SYS       1       /* UOS Control */
+#define SPP_FACILITY_ISCSI_VNIC        2       /* iSCSI Initiator Prov=
isioning */
+
+
+/*
+ * spp_msg_register() is use to install a callback - cb_fn() function,=
 that would
+ * be invoked once the message with specific handle has beed received.
+ * The unique "handle" that associates the callback with the messages =
is
+ * key_facility parameter.
+ * Typically the endpoints (sender on SIM and receiver on PMM) would a=
gree on
+ * the  "handle" that consists of FACILITY (4 bits) and KEY (16 bits).
+ * The inlude spp_build_key_facility(key, facility) builds such handle=
=2E
+ * The parameters of callback:
+ * cb_nf(u32 cmd, void *data_buf, int data_buf_size, u32 timestamp), a=
re
+ * cmd - an actual command value that was sent by SIM
+ * data_buf - pointer to up to 128 bytes (32 u32s) of message data fro=
m SIM
+ * data_buf_size - actual number of bytes in the message
+ * timestamp - a relative time/sequence number indicating when message=
,
+ * that caused the callback, was received.
+ *
+ * IMPORTANT: If the message was already waiting, at the time of spp_m=
sg_register()
+ * call, the cb_fn() will be invoked in the context of spp_msg_registe=
r().
+ *
+ */
+extern int spp_msg_register(u32 key_facility, void (*cb_fn)(u32, void =
*, int, u32));
+
+/*
+ * spp_msg_unregirster() will remove the callback function, so that
+ * the imcoming messages with the key_facility handle will basically b=
e
+ * overwriting command and data buffers.
+ */
+
+extern void spp_msg_unregister(u32 key_facility);
+
+extern int read_spp_regbank32(int vioc, int bank, char *buffer);
+
+#endif /* _SPPAPI_H_ */
+
diff -puN /dev/null drivers/net/vioc/f7/vioc_bmc_registers.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vioc_bmc_registers.h
@@ -0,0 +1,1343 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+
+#ifndef _VIOC_BMC_REGISTERS_H_
+#define _VIOC_BMC_REGISTERS_H_
+
+// BMC VNIC block 0
+/* Data Register Bytes 1 and 0 for 16 bit accesses (15..0) */
+#define VREG_BMC_DATAREGB10_MASK       0x0000ffff
+#define VREG_BMC_DATAREGB10_ACCESSMODE         2
+#define VREG_BMC_DATAREGB10_HOSTPRIVILEGE      0
+#define VREG_BMC_DATAREGB10_RESERVEDMASK       0x00000000
+#define VREG_BMC_DATAREGB10_WRITEMASK  0x0000ffff
+#define VREG_BMC_DATAREGB10_READMASK   0x0000ffff
+#define VREG_BMC_DATAREGB10_CLEARMASK  0x00000000
+#define VREG_BMC_DATAREGB10    0x000
+#define VREG_BMC_DATAREGB10_ID         0
+
+#define VVAL_BMC_DATAREGB10_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Data Register Bytes 3 and 2 for 16 bit accesses (15..0) */
+#define VREG_BMC_DATAREGB32_MASK       0x0000ffff
+#define VREG_BMC_DATAREGB32_ACCESSMODE         2
+#define VREG_BMC_DATAREGB32_HOSTPRIVILEGE      0
+#define VREG_BMC_DATAREGB32_RESERVEDMASK       0x00000000
+#define VREG_BMC_DATAREGB32_WRITEMASK  0x0000ffff
+#define VREG_BMC_DATAREGB32_READMASK   0x0000ffff
+#define VREG_BMC_DATAREGB32_CLEARMASK  0x00000000
+#define VREG_BMC_DATAREGB32    0x004
+#define VREG_BMC_DATAREGB32_ID         1
+
+#define VVAL_BMC_DATAREGB32_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Data Register Bytes 5 and 4 for 16 bit accesses (15..0) */
+#define VREG_BMC_DATAREGB54_MASK       0x0000ffff
+#define VREG_BMC_DATAREGB54_ACCESSMODE         2
+#define VREG_BMC_DATAREGB54_HOSTPRIVILEGE      0
+#define VREG_BMC_DATAREGB54_RESERVEDMASK       0x00000000
+#define VREG_BMC_DATAREGB54_WRITEMASK  0x0000ffff
+#define VREG_BMC_DATAREGB54_READMASK   0x0000ffff
+#define VREG_BMC_DATAREGB54_CLEARMASK  0x00000000
+#define VREG_BMC_DATAREGB54    0x008
+#define VREG_BMC_DATAREGB54_ID         2
+
+#define VVAL_BMC_DATAREGB54_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Data Register Bytes 7 and 6 for 16 bit accesses (15..0) */
+#define VREG_BMC_DATAREGB76_MASK       0x0000ffff
+#define VREG_BMC_DATAREGB76_ACCESSMODE         2
+#define VREG_BMC_DATAREGB76_HOSTPRIVILEGE      0
+#define VREG_BMC_DATAREGB76_RESERVEDMASK       0x00000000
+#define VREG_BMC_DATAREGB76_WRITEMASK  0x0000ffff
+#define VREG_BMC_DATAREGB76_READMASK   0x0000ffff
+#define VREG_BMC_DATAREGB76_CLEARMASK  0x00000000
+#define VREG_BMC_DATAREGB76    0x00c
+#define VREG_BMC_DATAREGB76_ID         3
+
+#define VVAL_BMC_DATAREGB76_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Data Register Byte 8 for 16 bit accesses (7..0) */
+#define VREG_BMC_DATAREGB8_MASK        0x000000ff
+#define VREG_BMC_DATAREGB8_ACCESSMODE  2
+#define VREG_BMC_DATAREGB8_HOSTPRIVILEGE       0
+#define VREG_BMC_DATAREGB8_RESERVEDMASK        0x00000000
+#define VREG_BMC_DATAREGB8_WRITEMASK   0x000000ff
+#define VREG_BMC_DATAREGB8_READMASK    0x000000ff
+#define VREG_BMC_DATAREGB8_CLEARMASK   0x00000000
+#define VREG_BMC_DATAREGB8     0x010
+#define VREG_BMC_DATAREGB8_ID  4
+
+#define VVAL_BMC_DATAREGB8_DEFAULT 0x0         /* Reset by hreset: Res=
et to 0 */
+
+
+/* Holds last POST Code value (7..0) */
+#define VREG_BMC_POSTCODE_MASK         0x000000ff
+#define VREG_BMC_POSTCODE_ACCESSMODE   1
+#define VREG_BMC_POSTCODE_HOSTPRIVILEGE        1
+#define VREG_BMC_POSTCODE_RESERVEDMASK         0x00000000
+#define VREG_BMC_POSTCODE_WRITEMASK    0x00000000
+#define VREG_BMC_POSTCODE_READMASK     0x000000ff
+#define VREG_BMC_POSTCODE_CLEARMASK    0x00000000
+#define VREG_BMC_POSTCODE      0x014
+#define VREG_BMC_POSTCODE_ID   5
+
+
+
+/* Count Register Bytes 1 and 0 for 16 bit accesses (15..0) */
+#define VREG_BMC_COUNTREGB10_MASK      0x0000ffff
+#define VREG_BMC_COUNTREGB10_ACCESSMODE        2
+#define VREG_BMC_COUNTREGB10_HOSTPRIVILEGE     0
+#define VREG_BMC_COUNTREGB10_RESERVEDMASK      0x00000000
+#define VREG_BMC_COUNTREGB10_WRITEMASK         0x0000ffff
+#define VREG_BMC_COUNTREGB10_READMASK  0x0000ffff
+#define VREG_BMC_COUNTREGB10_CLEARMASK         0x00000000
+#define VREG_BMC_COUNTREGB10   0x018
+#define VREG_BMC_COUNTREGB10_ID        6
+
+#define VVAL_BMC_COUNTREGB10_DEFAULT 0x0       /* Reset by hreset: Res=
et to 0 */
+
+
+/* Count Register Byte 2 for 16 bit accesses (7..0) */
+#define VREG_BMC_COUNTREGB2_MASK       0x000000ff
+#define VREG_BMC_COUNTREGB2_ACCESSMODE         2
+#define VREG_BMC_COUNTREGB2_HOSTPRIVILEGE      0
+#define VREG_BMC_COUNTREGB2_RESERVEDMASK       0x00000000
+#define VREG_BMC_COUNTREGB2_WRITEMASK  0x000000ff
+#define VREG_BMC_COUNTREGB2_READMASK   0x000000ff
+#define VREG_BMC_COUNTREGB2_CLEARMASK  0x00000000
+#define VREG_BMC_COUNTREGB2    0x01c
+#define VREG_BMC_COUNTREGB2_ID         7
+
+#define VVAL_BMC_COUNTREGB2_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Addr Register Bytes 1 and 0 for 16 bit accesses (15..2) */
+#define VREG_BMC_ADDRREGB10_MASK       0x0000fffc
+#define VREG_BMC_ADDRREGB10_ACCESSMODE         2
+#define VREG_BMC_ADDRREGB10_HOSTPRIVILEGE      0
+#define VREG_BMC_ADDRREGB10_RESERVEDMASK       0x00000000
+#define VREG_BMC_ADDRREGB10_WRITEMASK  0x0000fffc
+#define VREG_BMC_ADDRREGB10_READMASK   0x0000fffc
+#define VREG_BMC_ADDRREGB10_CLEARMASK  0x00000000
+#define VREG_BMC_ADDRREGB10    0x020
+#define VREG_BMC_ADDRREGB10_ID         8
+
+
+
+/* Addr Register Bytes 3 and 2 for 16 bit accesses (15..0) */
+#define VREG_BMC_ADDRREGB32_MASK       0x0000ffff
+#define VREG_BMC_ADDRREGB32_ACCESSMODE         2
+#define VREG_BMC_ADDRREGB32_HOSTPRIVILEGE      0
+#define VREG_BMC_ADDRREGB32_RESERVEDMASK       0x00000000
+#define VREG_BMC_ADDRREGB32_WRITEMASK  0x0000ffff
+#define VREG_BMC_ADDRREGB32_READMASK   0x0000ffff
+#define VREG_BMC_ADDRREGB32_CLEARMASK  0x00000000
+#define VREG_BMC_ADDRREGB32    0x024
+#define VREG_BMC_ADDRREGB32_ID         9
+
+
+
+/* Addr Register Bytes 5 and 4 for 16 bit accesses (8..0) */
+#define VREG_BMC_ADDRREGB54_MASK       0x000001ff
+#define VREG_BMC_ADDRREGB54_ACCESSMODE         2
+#define VREG_BMC_ADDRREGB54_HOSTPRIVILEGE      0
+#define VREG_BMC_ADDRREGB54_RESERVEDMASK       0x00000000
+#define VREG_BMC_ADDRREGB54_WRITEMASK  0x000001ff
+#define VREG_BMC_ADDRREGB54_READMASK   0x000001ff
+#define VREG_BMC_ADDRREGB54_CLEARMASK  0x00000000
+#define VREG_BMC_ADDRREGB54    0x028
+#define VREG_BMC_ADDRREGB54_ID         10
+
+
+
+/* Communication register between Host and BMC (15..0) */
+#define VREG_BMC_SENSOR_MASK   0x0000ffff
+#define VREG_BMC_SENSOR_ACCESSMODE     2
+#define VREG_BMC_SENSOR_HOSTPRIVILEGE  1
+#define VREG_BMC_SENSOR_RESERVEDMASK   0x00000000
+#define VREG_BMC_SENSOR_WRITEMASK      0x000000ff
+#define VREG_BMC_SENSOR_READMASK       0x0000ffff
+#define VREG_BMC_SENSOR_CLEARMASK      0x00000000
+#define VREG_BMC_SENSOR        0x02c
+#define VREG_BMC_SENSOR_ID     11
+
+#define VVAL_BMC_SENSOR_DEFAULT 0x0    /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of Sensor */
+#define VREG_BMC_SENSOR_SYSRESET_MASK  0x00008000      /* System Reset=
 GPIO pin from Keyboard Controller [15..15] */
+#define VREG_BMC_SENSOR_RTS0_MASK      0x00004000      /* Request to S=
end bit from UART 0 [14..14] */
+#define VREG_BMC_SENSOR_TXRDY1_MASK    0x00002000      /* Uart1 Tx Rea=
dy Flag [13..13] */
+#define VREG_BMC_SENSOR_TXRDY0_MASK    0x00001000      /* Uart0 Tx Rea=
dy Flag [12..12] */
+#define VREG_BMC_SENSOR_FIFOEN1_MASK   0x00000800      /* UART1 FIFO E=
nabled [11..11] */
+#define VREG_BMC_SENSOR_RXEMPTY1_MASK  0x00000400      /* UART1 Receiv=
e Empty Flag [10..10] */
+#define VREG_BMC_SENSOR_FIFOEN0_MASK   0x00000200      /* UART0 FIFO E=
nabled [9..9] */
+#define VREG_BMC_SENSOR_RXEMPTY0_MASK  0x00000100      /* UART0 Receiv=
e Empty Flag [8..8] */
+#define VREG_BMC_SENSOR_SENSOR_MASK    0x000000ff      /* Sensor Data =
[0..7] */
+
+
+
+
+/* If read error is detected, bits 11:4 of error address (11..0) */
+#define VREG_BMC_ERRORADDR_MASK        0x00000fff
+#define VREG_BMC_ERRORADDR_ACCESSMODE  1
+#define VREG_BMC_ERRORADDR_HOSTPRIVILEGE       0
+#define VREG_BMC_ERRORADDR_RESERVEDMASK        0x00000000
+#define VREG_BMC_ERRORADDR_WRITEMASK   0x00000000
+#define VREG_BMC_ERRORADDR_READMASK    0x00000fff
+#define VREG_BMC_ERRORADDR_CLEARMASK   0x00000000
+#define VREG_BMC_ERRORADDR     0x030
+#define VREG_BMC_ERRORADDR_ID  12
+    /*
+     * The address of the 128 bit word in error can be determined as f=
ollows:
+     * if(ErrorAddr[11] =3D=3D AddrReg[11]) BadWordAddr[39:11] =3D Add=
rReg[39:11];
+     * else BadWordAddr[39:11] =3D AddrReg[39:11] - 1;
+     * BadWordAddr[10:4] =3D ErrorAddr[10:4];
+     * BadWordAddr[3:0] =3D 0;
+     */
+
+#define VVAL_BMC_ERRORADDR_DEFAULT 0x0         /* Reset by hreset: Res=
et to 0 */
+
+
+/* If read error is detected, expected and actual data (15..0) */
+#define VREG_BMC_ERRORDATA_MASK        0x0000ffff
+#define VREG_BMC_ERRORDATA_ACCESSMODE  1
+#define VREG_BMC_ERRORDATA_HOSTPRIVILEGE       0
+#define VREG_BMC_ERRORDATA_RESERVEDMASK        0x00000000
+#define VREG_BMC_ERRORDATA_WRITEMASK   0x00000000
+#define VREG_BMC_ERRORDATA_READMASK    0x0000ffff
+#define VREG_BMC_ERRORDATA_CLEARMASK   0x00000000
+#define VREG_BMC_ERRORDATA     0x034
+#define VREG_BMC_ERRORDATA_ID  13
+
+#define VVAL_BMC_ERRORDATA_DEFAULT 0x0         /* Reset by hreset: Res=
et to 0 */
+/* Subfields of ErrorData */
+#define VREG_BMC_ERRORDATA_EXPECTED_MASK       0x0000ff00      /* Expe=
cted data for read operation [8..15] */
+#define VREG_BMC_ERRORDATA_ACTUAL_MASK 0x000000ff      /* Actual data =
returned for read operation [0..7] */
+
+/* Indicates which byte, or bytes, did not match expected data (15..0)=
 */
+#define VREG_BMC_ERRBYTEMASK_MASK      0x0000ffff
+#define VREG_BMC_ERRBYTEMASK_ACCESSMODE        1
+#define VREG_BMC_ERRBYTEMASK_HOSTPRIVILEGE     0
+#define VREG_BMC_ERRBYTEMASK_RESERVEDMASK      0x00000000
+#define VREG_BMC_ERRBYTEMASK_WRITEMASK         0x00000000
+#define VREG_BMC_ERRBYTEMASK_READMASK  0x0000ffff
+#define VREG_BMC_ERRBYTEMASK_CLEARMASK         0x00000000
+#define VREG_BMC_ERRBYTEMASK   0x038
+#define VREG_BMC_ERRBYTEMASK_ID        14
+    /*
+     * If more than one bit is set in the ErrByteMask then multiple by=
tes were in error
+     * The expected and actual data value returned correspond to the l=
eftmost bad byte
+     * in the 128 bit data word.
+     */
+
+#define VVAL_BMC_ERRBYTEMASK_DEFAULT 0x0       /* Reset by hreset: Res=
et to 0 */
+
+
+/* Command (7..0) */
+#define VREG_BMC_CMDREG_MASK   0x000000ff
+#define VREG_BMC_CMDREG_ACCESSMODE     2
+#define VREG_BMC_CMDREG_HOSTPRIVILEGE  0
+#define VREG_BMC_CMDREG_RESERVEDMASK   0x00000000
+#define VREG_BMC_CMDREG_WRITEMASK      0x000000ff
+#define VREG_BMC_CMDREG_READMASK       0x000000ff
+#define VREG_BMC_CMDREG_CLEARMASK      0x00000078
+#define VREG_BMC_CMDREG        0x03c
+#define VREG_BMC_CMDREG_ID     15
+    /* Multiple Status bits can be asserted independently */
+
+#define VVAL_BMC_CMDREG_DEFAULT 0x0    /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of CmdReg */
+#define VREG_BMC_CMDREG_VALID_MASK     0x00000080      /* Set to 1 to =
start operation, HW clears to 0 when complete [7..7] */
+#define VREG_BMC_CMDREG_STATUS_MASK    0x00000078      /* Completion s=
tatus [3..6] */
+#define VVAL_BMC_CMDREG_STATUS_HTCKERR 0x40    /* Comparison Failed du=
ring read operation */
+#define VVAL_BMC_CMDREG_STATUS_BADCMD 0x20     /* Unknown command */
+#define VVAL_BMC_CMDREG_STATUS_RINGERR 0x10    /* Ring operation faile=
d */
+#define VVAL_BMC_CMDREG_STATUS_BADMODID 0x8    /* Ring Address had unk=
nown Module ID */
+#define VREG_BMC_CMDREG_COMMAND_MASK   0x00000007      /* Command to e=
xecute [0..2] */
+#define VVAL_BMC_CMDREG_COMMAND_READWORD 0x0   /* Read a single word f=
rom memory or the ring */
+#define VVAL_BMC_CMDREG_COMMAND_WRITEWORD 0x1  /* Write a single word =
to memory or the ring */
+#define VVAL_BMC_CMDREG_COMMAND_READBLOCK 0x2  /* Read a block of memo=
ry and compare to a constant value */
+#define VVAL_BMC_CMDREG_COMMAND_WRITEBLOCK 0x3         /* Write a bloc=
k of memory to a constant value */
+#define VVAL_BMC_CMDREG_COMMAND_READLFSR 0x4   /* Read a block of memo=
ry and compare to LFSR value */
+#define VVAL_BMC_CMDREG_COMMAND_WRITELFSR 0x5  /* Write a block of mem=
ory to LFSR value */
+#define VVAL_BMC_CMDREG_COMMAND_RESV6 0x6      /* Reserved */
+#define VVAL_BMC_CMDREG_COMMAND_RESV7 0x7      /* Reserved */
+
+/* Low order 32-bits of 41-bit address (31..2) */
+#define VREG_BMC_ADDRREGLO_MASK        0xfffffffc
+#define VREG_BMC_ADDRREGLO_ACCESSMODE  2
+#define VREG_BMC_ADDRREGLO_HOSTPRIVILEGE       0
+#define VREG_BMC_ADDRREGLO_RESERVEDMASK        0x00000000
+#define VREG_BMC_ADDRREGLO_WRITEMASK   0xfffffffc
+#define VREG_BMC_ADDRREGLO_READMASK    0xfffffffc
+#define VREG_BMC_ADDRREGLO_CLEARMASK   0x00000000
+#define VREG_BMC_ADDRREGLO     0x040
+#define VREG_BMC_ADDRREGLO_ID  16
+
+#define VVAL_BMC_ADDRREGLO_DEFAULT 0x0         /* Reset by hreset: Res=
et to 0 */
+
+
+/* High Order 9-bits of 41-bit address (8..0) */
+#define VREG_BMC_ADDRREGHI_MASK        0x000001ff
+#define VREG_BMC_ADDRREGHI_ACCESSMODE  2
+#define VREG_BMC_ADDRREGHI_HOSTPRIVILEGE       0
+#define VREG_BMC_ADDRREGHI_RESERVEDMASK        0x00000000
+#define VREG_BMC_ADDRREGHI_WRITEMASK   0x000001ff
+#define VREG_BMC_ADDRREGHI_READMASK    0x000001ff
+#define VREG_BMC_ADDRREGHI_CLEARMASK   0x00000000
+#define VREG_BMC_ADDRREGHI     0x044
+#define VREG_BMC_ADDRREGHI_ID  17
+
+#define VVAL_BMC_ADDRREGHI_DEFAULT 0x0         /* Reset by hreset: Res=
et to 0 */
+
+
+/* 24-Bit Count register (23..0) */
+#define VREG_BMC_COUNTREG_MASK         0x00ffffff
+#define VREG_BMC_COUNTREG_ACCESSMODE   2
+#define VREG_BMC_COUNTREG_HOSTPRIVILEGE        0
+#define VREG_BMC_COUNTREG_RESERVEDMASK         0x00000000
+#define VREG_BMC_COUNTREG_WRITEMASK    0x00ffffff
+#define VREG_BMC_COUNTREG_READMASK     0x00ffffff
+#define VREG_BMC_COUNTREG_CLEARMASK    0x00000000
+#define VREG_BMC_COUNTREG      0x048
+#define VREG_BMC_COUNTREG_ID   18
+
+#define VVAL_BMC_COUNTREG_DEFAULT 0x0  /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Low order 32-bits for 72-bit data (31..0) */
+#define VREG_BMC_DATAREGLO_MASK        0xffffffff
+#define VREG_BMC_DATAREGLO_ACCESSMODE  2
+#define VREG_BMC_DATAREGLO_HOSTPRIVILEGE       0
+#define VREG_BMC_DATAREGLO_RESERVEDMASK        0x00000000
+#define VREG_BMC_DATAREGLO_WRITEMASK   0xffffffff
+#define VREG_BMC_DATAREGLO_READMASK    0xffffffff
+#define VREG_BMC_DATAREGLO_CLEARMASK   0x00000000
+#define VREG_BMC_DATAREGLO     0x050
+#define VREG_BMC_DATAREGLO_ID  20
+
+#define VVAL_BMC_DATAREGLO_DEFAULT 0x0         /* Reset by hreset: Res=
et to 0 */
+
+
+/* Middle 32-Bits for 72-bit data (31..0) */
+#define VREG_BMC_DATAREGMID_MASK       0xffffffff
+#define VREG_BMC_DATAREGMID_ACCESSMODE         2
+#define VREG_BMC_DATAREGMID_HOSTPRIVILEGE      0
+#define VREG_BMC_DATAREGMID_RESERVEDMASK       0x00000000
+#define VREG_BMC_DATAREGMID_WRITEMASK  0xffffffff
+#define VREG_BMC_DATAREGMID_READMASK   0xffffffff
+#define VREG_BMC_DATAREGMID_CLEARMASK  0x00000000
+#define VREG_BMC_DATAREGMID    0x054
+#define VREG_BMC_DATAREGMID_ID         21
+
+#define VVAL_BMC_DATAREGMID_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* High order 8-Bits for 72-bit data (7..0) */
+#define VREG_BMC_DATAREGHI_MASK        0x000000ff
+#define VREG_BMC_DATAREGHI_ACCESSMODE  2
+#define VREG_BMC_DATAREGHI_HOSTPRIVILEGE       0
+#define VREG_BMC_DATAREGHI_RESERVEDMASK        0x00000000
+#define VREG_BMC_DATAREGHI_WRITEMASK   0x000000ff
+#define VREG_BMC_DATAREGHI_READMASK    0x000000ff
+#define VREG_BMC_DATAREGHI_CLEARMASK   0x00000000
+#define VREG_BMC_DATAREGHI     0x058
+#define VREG_BMC_DATAREGHI_ID  22
+
+#define VVAL_BMC_DATAREGHI_DEFAULT 0x0         /* Reset by hreset: Res=
et to 0 */
+
+
+/* Full Data Register for 72 bit accesses (31..0) */
+#define VREG_BMC_DATAREG_MASK  0xffffffff
+#define VREG_BMC_DATAREG_ACCESSMODE    2
+#define VREG_BMC_DATAREG_HOSTPRIVILEGE         0
+#define VREG_BMC_DATAREG_RESERVEDMASK  0x00000000
+#define VREG_BMC_DATAREG_WRITEMASK     0xffffffff
+#define VREG_BMC_DATAREG_READMASK      0xffffffff
+#define VREG_BMC_DATAREG_CLEARMASK     0x00000000
+#define VREG_BMC_DATAREG       0x060
+#define VREG_BMC_DATAREG_ID    24
+
+/* Full Addr Register for 41 bit accesses (31..0) */
+#define VREG_BMC_ADDRREG_MASK  0xffffffff
+#define VREG_BMC_ADDRREG_ACCESSMODE    2
+#define VREG_BMC_ADDRREG_HOSTPRIVILEGE         0
+#define VREG_BMC_ADDRREG_RESERVEDMASK  0x00000000
+#define VREG_BMC_ADDRREG_WRITEMASK     0xffffffff
+#define VREG_BMC_ADDRREG_READMASK      0xffffffff
+#define VREG_BMC_ADDRREG_CLEARMASK     0x00000000
+#define VREG_BMC_ADDRREG       0x070
+#define VREG_BMC_ADDRREG_ID    28
+
+
+
+/* Global Enable and Status bits (31..0) */
+#define VREG_BMC_GLOBAL_MASK   0xffffffff
+#define VREG_BMC_GLOBAL_ACCESSMODE     2
+#define VREG_BMC_GLOBAL_HOSTPRIVILEGE  1
+#define VREG_BMC_GLOBAL_RESERVEDMASK   0xff473e0e
+#define VREG_BMC_GLOBAL_WRITEMASK      0x0000c1f0
+#define VREG_BMC_GLOBAL_READMASK       0x00b8c1f1
+#define VREG_BMC_GLOBAL_CLEARMASK      0x00000000
+#define VREG_BMC_GLOBAL        0x100
+#define VREG_BMC_GLOBAL_ID     64
+
+#define VVAL_BMC_GLOBAL_DEFAULT 0x30   /* Reset by hreset: Reset with =
UART and KBRD enabled */
+/* Subfields of Global */
+#define VREG_BMC_GLOBAL_RESV0_MASK     0xff000000      /* Reserved [24=
=2E.31] */
+#define VREG_BMC_GLOBAL_HTINIT_MASK    0x00800000      /* HT Interface=
 Initialization Complete [23..23] */
+#define VREG_BMC_GLOBAL_RESV0A_MASK    0x00400000      /* Reserved [22=
=2E.22] */
+#define VREG_BMC_GLOBAL_C6SYNC_MASK    0x00200000      /* C6 Rx Syncs =
received [21..21] */
+#define VREG_BMC_GLOBAL_C6IDLE_MASK    0x00100000      /* C6 Rx Idles =
received [20..20] */
+#define VREG_BMC_GLOBAL_C6READY_MASK   0x00080000      /* C6 Rx Ready =
received [19..19] */
+#define VREG_BMC_GLOBAL_RESV1_MASK     0x00070000      /* Reserved [16=
=2E.18] */
+#define VREG_BMC_GLOBAL_VIOCEN_MASK    0x00008000      /* Master VIOC =
Enable bit [15..15] */
+#define VREG_BMC_GLOBAL_LEGAPICEN_MASK 0x00004000      /* Legacy IOAPI=
C Enable bit [14..14] */
+#define VREG_BMC_GLOBAL_RESV2_MASK     0x00003e00      /* Reserved [9.=
=2E13] */
+#define VREG_BMC_GLOBAL_APICCLKEN_MASK 0x00000100      /* Enables VIOC=
 to drive APIC bus clock [8..8] */
+#define VREG_BMC_GLOBAL_HTEN_MASK      0x00000080      /* HT interface=
 Enable bit [7..7] */
+#define VREG_BMC_GLOBAL_CSIXEN_MASK    0x00000040      /* CSIX interfa=
ce Enable bit [6..6] */
+#define VREG_BMC_GLOBAL_KBRDEN_MASK    0x00000020      /* Emulated Key=
board Register Enable bit [5..5] */
+#define VREG_BMC_GLOBAL_UARTEN_MASK    0x00000010      /* Emulated UAR=
T Enable bit [4..4] */
+#define VREG_BMC_GLOBAL_RESV3_MASK     0x0000000e      /* Reserved [1.=
=2E3] */
+#define VREG_BMC_GLOBAL_SOFTRESET_MASK 0x00000001      /* VIOC Soft Re=
set: HW clears bit after reset is complete [0..0] */
+
+
+
+
+/* Nonprivileged Debug Control and Status Bits (31..0) */
+#define VREG_BMC_DEBUG_MASK    0xffffffff
+#define VREG_BMC_DEBUG_ACCESSMODE      2
+#define VREG_BMC_DEBUG_HOSTPRIVILEGE   1
+#define VREG_BMC_DEBUG_RESERVEDMASK    0xffff0000
+#define VREG_BMC_DEBUG_WRITEMASK       0x0000ffff
+#define VREG_BMC_DEBUG_READMASK        0x0000ffff
+#define VREG_BMC_DEBUG_CLEARMASK       0x00000000
+#define VREG_BMC_DEBUG         0x104
+#define VREG_BMC_DEBUG_ID      65
+
+#define VVAL_BMC_DEBUG_DEFAULT 0x0     /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of Debug */
+#define VREG_BMC_DEBUG_RESV0_MASK      0xffff0000      /* Reserved [16=
=2E.31] */
+#define VREG_BMC_DEBUG_DEBUGHI_MASK    0x0000ff00      /* Select bits =
to appear on high half of Debug port [8..15] */
+#define VREG_BMC_DEBUG_DEBUGLO_MASK    0x000000ff      /* Select bits =
to appear on low half of Debug port [0..7] */
+
+
+
+
+/* Privileged Debug Control and Status Bits (31..0) */
+#define VREG_BMC_DEBUGPRIV_MASK        0xffffffff
+#define VREG_BMC_DEBUGPRIV_ACCESSMODE  2
+#define VREG_BMC_DEBUGPRIV_HOSTPRIVILEGE       0
+#define VREG_BMC_DEBUGPRIV_RESERVEDMASK        0x1fffffff
+#define VREG_BMC_DEBUGPRIV_WRITEMASK   0xe0000000
+#define VREG_BMC_DEBUGPRIV_READMASK    0xe0000000
+#define VREG_BMC_DEBUGPRIV_CLEARMASK   0x00000000
+#define VREG_BMC_DEBUGPRIV     0x108
+#define VREG_BMC_DEBUGPRIV_ID  66
+
+#define VVAL_BMC_DEBUGPRIV_DEFAULT 0x0         /* Reset by hreset: Res=
ets to 0 */
+/* Subfields of DebugPriv */
+#define VREG_BMC_DEBUGPRIV_DISABLE_MASK        0x80000000      /* When=
 set disables access to privileged registers from Host CPU [31..31] */
+#define VREG_BMC_DEBUGPRIV_C6_INTLOOP_MASK     0x40000000      /* Enab=
le CSIX Internal Loopback on egress to ingress [30..30] */
+#define VREG_BMC_DEBUGPRIV_C6_EXTLOOP_MASK     0x20000000      /* Enab=
le CSIX External Loopback on ingress to egress [29..29] */
+#define VREG_BMC_DEBUGPRIV_RESV0_MASK  0x1fffffff      /* Reserved [0.=
=2E28] */
+
+
+
+
+/* HT Receive Clock A DCM control (31..0) */
+#define VREG_BMC_HTRXACLK_MASK         0xffffffff
+#define VREG_BMC_HTRXACLK_ACCESSMODE   2
+#define VREG_BMC_HTRXACLK_HOSTPRIVILEGE        0
+#define VREG_BMC_HTRXACLK_RESERVEDMASK         0xffff7e00
+#define VREG_BMC_HTRXACLK_WRITEMASK    0x000000ff
+#define VREG_BMC_HTRXACLK_READMASK     0x000081ff
+#define VREG_BMC_HTRXACLK_CLEARMASK    0x00000000
+#define VREG_BMC_HTRXACLK      0x110
+#define VREG_BMC_HTRXACLK_ID   68
+
+/* Subfields of HTRxAClk */
+#define VREG_BMC_HTRXACLK_RESV0_MASK   0xffff0000      /* Reserved [16=
=2E.31] */
+#define VREG_BMC_HTRXACLK_DONE_MASK    0x00008000      /* indicates th=
at the DCM has completed the previous operation [15..15] */
+#define VREG_BMC_HTRXACLK_RESV1_MASK   0x00007e00      /* Reserved [9.=
=2E14] */
+#define VREG_BMC_HTRXACLK_SAMPLE_MASK  0x00000100      /* Clock value =
sampled with current phase shift [8..8] */
+#define VREG_BMC_HTRXACLK_PHASE_MASK   0x000000ff      /* 8 bit phase =
shift value [0..7] */
+
+
+
+
+/* HT Receive Clock B DCM control (31..0) */
+#define VREG_BMC_HTRXBCLK_MASK         0xffffffff
+#define VREG_BMC_HTRXBCLK_ACCESSMODE   2
+#define VREG_BMC_HTRXBCLK_HOSTPRIVILEGE        0
+#define VREG_BMC_HTRXBCLK_RESERVEDMASK         0xffff7e00
+#define VREG_BMC_HTRXBCLK_WRITEMASK    0x000000ff
+#define VREG_BMC_HTRXBCLK_READMASK     0x000081ff
+#define VREG_BMC_HTRXBCLK_CLEARMASK    0x00000000
+#define VREG_BMC_HTRXBCLK      0x114
+#define VREG_BMC_HTRXBCLK_ID   69
+
+/* Subfields of HTRxBClk */
+#define VREG_BMC_HTRXBCLK_RESV0_MASK   0xffff0000      /* Reserved [16=
=2E.31] */
+#define VREG_BMC_HTRXBCLK_DONE_MASK    0x00008000      /* indicates th=
at the DCM has completed the previous operation [15..15] */
+#define VREG_BMC_HTRXBCLK_RESV1_MASK   0x00007e00      /* Reserved [9.=
=2E14] */
+#define VREG_BMC_HTRXBCLK_SAMPLE_MASK  0x00000100      /* Clock value =
sampled with current phase shift [8..8] */
+#define VREG_BMC_HTRXBCLK_PHASE_MASK   0x000000ff      /* 8 bit phase =
shift value [0..7] */
+
+
+
+
+/* HT Transmit Clock DCM control (31..0) */
+#define VREG_BMC_HTTXCLK_MASK  0xffffffff
+#define VREG_BMC_HTTXCLK_ACCESSMODE    2
+#define VREG_BMC_HTTXCLK_HOSTPRIVILEGE         0
+#define VREG_BMC_HTTXCLK_RESERVEDMASK  0xffff7e00
+#define VREG_BMC_HTTXCLK_WRITEMASK     0x000000ff
+#define VREG_BMC_HTTXCLK_READMASK      0x000081ff
+#define VREG_BMC_HTTXCLK_CLEARMASK     0x00000000
+#define VREG_BMC_HTTXCLK       0x118
+#define VREG_BMC_HTTXCLK_ID    70
+
+/* Subfields of HTTxClk */
+#define VREG_BMC_HTTXCLK_RESV0_MASK    0xffff0000      /* Reserved [16=
=2E.31] */
+#define VREG_BMC_HTTXCLK_DONE_MASK     0x00008000      /* indicates th=
at the DCM has completed the previous operation [15..15] */
+#define VREG_BMC_HTTXCLK_RESV1_MASK    0x00007e00      /* Reserved [9.=
=2E14] */
+#define VREG_BMC_HTTXCLK_SAMPLE_MASK   0x00000100      /* Clock value =
sampled with current phase shift [8..8] */
+#define VREG_BMC_HTTXCLK_PHASE_MASK    0x000000ff      /* 8 bit phase =
shift value [0..7] */
+
+
+
+
+/* Sensor bit 0 (0..0) */
+#define VREG_BMC_SENSOR0_MASK  0x00000001
+#define VREG_BMC_SENSOR0_ACCESSMODE    2
+#define VREG_BMC_SENSOR0_HOSTPRIVILEGE         1
+#define VREG_BMC_SENSOR0_RESERVEDMASK  0x00000000
+#define VREG_BMC_SENSOR0_WRITEMASK     0x00000001
+#define VREG_BMC_SENSOR0_READMASK      0x00000001
+#define VREG_BMC_SENSOR0_CLEARMASK     0x00000000
+#define VREG_BMC_SENSOR0       0x120
+#define VREG_BMC_SENSOR0_ID    72
+
+#define VVAL_BMC_SENSOR0_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Sensor bit 1 (0..0) */
+#define VREG_BMC_SENSOR1_MASK  0x00000001
+#define VREG_BMC_SENSOR1_ACCESSMODE    2
+#define VREG_BMC_SENSOR1_HOSTPRIVILEGE         1
+#define VREG_BMC_SENSOR1_RESERVEDMASK  0x00000000
+#define VREG_BMC_SENSOR1_WRITEMASK     0x00000001
+#define VREG_BMC_SENSOR1_READMASK      0x00000001
+#define VREG_BMC_SENSOR1_CLEARMASK     0x00000000
+#define VREG_BMC_SENSOR1       0x124
+#define VREG_BMC_SENSOR1_ID    73
+
+#define VVAL_BMC_SENSOR1_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Sensor bit 2 (0..0) */
+#define VREG_BMC_SENSOR2_MASK  0x00000001
+#define VREG_BMC_SENSOR2_ACCESSMODE    2
+#define VREG_BMC_SENSOR2_HOSTPRIVILEGE         1
+#define VREG_BMC_SENSOR2_RESERVEDMASK  0x00000000
+#define VREG_BMC_SENSOR2_WRITEMASK     0x00000001
+#define VREG_BMC_SENSOR2_READMASK      0x00000001
+#define VREG_BMC_SENSOR2_CLEARMASK     0x00000000
+#define VREG_BMC_SENSOR2       0x128
+#define VREG_BMC_SENSOR2_ID    74
+
+#define VVAL_BMC_SENSOR2_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Sensor bit 3 (0..0) */
+#define VREG_BMC_SENSOR3_MASK  0x00000001
+#define VREG_BMC_SENSOR3_ACCESSMODE    2
+#define VREG_BMC_SENSOR3_HOSTPRIVILEGE         1
+#define VREG_BMC_SENSOR3_RESERVEDMASK  0x00000000
+#define VREG_BMC_SENSOR3_WRITEMASK     0x00000001
+#define VREG_BMC_SENSOR3_READMASK      0x00000001
+#define VREG_BMC_SENSOR3_CLEARMASK     0x00000000
+#define VREG_BMC_SENSOR3       0x12c
+#define VREG_BMC_SENSOR3_ID    75
+
+#define VVAL_BMC_SENSOR3_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Sensor bit 4 (0..0) */
+#define VREG_BMC_SENSOR4_MASK  0x00000001
+#define VREG_BMC_SENSOR4_ACCESSMODE    2
+#define VREG_BMC_SENSOR4_HOSTPRIVILEGE         1
+#define VREG_BMC_SENSOR4_RESERVEDMASK  0x00000000
+#define VREG_BMC_SENSOR4_WRITEMASK     0x00000001
+#define VREG_BMC_SENSOR4_READMASK      0x00000001
+#define VREG_BMC_SENSOR4_CLEARMASK     0x00000000
+#define VREG_BMC_SENSOR4       0x130
+#define VREG_BMC_SENSOR4_ID    76
+
+#define VVAL_BMC_SENSOR4_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Sensor bit 5 (0..0) */
+#define VREG_BMC_SENSOR5_MASK  0x00000001
+#define VREG_BMC_SENSOR5_ACCESSMODE    2
+#define VREG_BMC_SENSOR5_HOSTPRIVILEGE         1
+#define VREG_BMC_SENSOR5_RESERVEDMASK  0x00000000
+#define VREG_BMC_SENSOR5_WRITEMASK     0x00000001
+#define VREG_BMC_SENSOR5_READMASK      0x00000001
+#define VREG_BMC_SENSOR5_CLEARMASK     0x00000000
+#define VREG_BMC_SENSOR5       0x134
+#define VREG_BMC_SENSOR5_ID    77
+
+#define VVAL_BMC_SENSOR5_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Sensor bit 6 (0..0) */
+#define VREG_BMC_SENSOR6_MASK  0x00000001
+#define VREG_BMC_SENSOR6_ACCESSMODE    2
+#define VREG_BMC_SENSOR6_HOSTPRIVILEGE         1
+#define VREG_BMC_SENSOR6_RESERVEDMASK  0x00000000
+#define VREG_BMC_SENSOR6_WRITEMASK     0x00000001
+#define VREG_BMC_SENSOR6_READMASK      0x00000001
+#define VREG_BMC_SENSOR6_CLEARMASK     0x00000000
+#define VREG_BMC_SENSOR6       0x138
+#define VREG_BMC_SENSOR6_ID    78
+
+#define VVAL_BMC_SENSOR6_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Sensor bit 7 (0..0) */
+#define VREG_BMC_SENSOR7_MASK  0x00000001
+#define VREG_BMC_SENSOR7_ACCESSMODE    2
+#define VREG_BMC_SENSOR7_HOSTPRIVILEGE         1
+#define VREG_BMC_SENSOR7_RESERVEDMASK  0x00000000
+#define VREG_BMC_SENSOR7_WRITEMASK     0x00000001
+#define VREG_BMC_SENSOR7_READMASK      0x00000001
+#define VREG_BMC_SENSOR7_CLEARMASK     0x00000000
+#define VREG_BMC_SENSOR7       0x13c
+#define VREG_BMC_SENSOR7_ID    79
+
+#define VVAL_BMC_SENSOR7_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Interrupt Request Register (15..0) */
+#define VREG_BMC_INTRREQ_MASK  0x0000ffff
+#define VREG_BMC_INTRREQ_ACCESSMODE    2
+#define VREG_BMC_INTRREQ_HOSTPRIVILEGE         1
+#define VREG_BMC_INTRREQ_RESERVEDMASK  0x00000000
+#define VREG_BMC_INTRREQ_WRITEMASK     0x0000ffff
+#define VREG_BMC_INTRREQ_READMASK      0x0000ffff
+#define VREG_BMC_INTRREQ_CLEARMASK     0x00000000
+#define VREG_BMC_INTRREQ       0x140
+#define VREG_BMC_INTRREQ_ID    80
+
+#define VVAL_BMC_INTRREQ_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Interrupt Status Register (31..0) */
+#define VREG_BMC_INTRSTATUS_MASK       0xffffffff
+#define VREG_BMC_INTRSTATUS_ACCESSMODE         2
+#define VREG_BMC_INTRSTATUS_HOSTPRIVILEGE      1
+#define VREG_BMC_INTRSTATUS_RESERVEDMASK       0xfffc0000
+#define VREG_BMC_INTRSTATUS_WRITEMASK  0x0003ffff
+#define VREG_BMC_INTRSTATUS_READMASK   0x0003ffff
+#define VREG_BMC_INTRSTATUS_CLEARMASK  0x0003ffff
+#define VREG_BMC_INTRSTATUS    0x144
+#define VREG_BMC_INTRSTATUS_ID         81
+
+#define VVAL_BMC_INTRSTATUS_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+/* Subfields of IntrStatus */
+#define VREG_BMC_INTRSTATUS_RSVD_MASK  0xfffc0000      /* Reserved [18=
=2E.31] */
+#define VREG_BMC_INTRSTATUS_NONFATAL_MASK      0x00020000      /* NonF=
atal error was signalled [17..17] */
+#define VREG_BMC_INTRSTATUS_FATAL_MASK 0x00010000      /* Fatal error =
was signalled [16..16] */
+#define VREG_BMC_INTRSTATUS_INTR_MASK  0x0000ffff      /* Programmed I=
nterrupt was signalled [0..15] */
+
+
+
+
+/* NonFatal Error Status (31..0) */
+#define VREG_BMC_INTRERRSTAT_MASK      0xffffffff
+#define VREG_BMC_INTRERRSTAT_ACCESSMODE        2
+#define VREG_BMC_INTRERRSTAT_HOSTPRIVILEGE     1
+#define VREG_BMC_INTRERRSTAT_RESERVEDMASK      0xfffffffe
+#define VREG_BMC_INTRERRSTAT_WRITEMASK         0x00000001
+#define VREG_BMC_INTRERRSTAT_READMASK  0x00000001
+#define VREG_BMC_INTRERRSTAT_CLEARMASK         0x00000001
+#define VREG_BMC_INTRERRSTAT   0x150
+#define VREG_BMC_INTRERRSTAT_ID        84
+
+#define VVAL_BMC_INTRERRSTAT_DEFAULT 0x0       /* Reset by hreset: Res=
et to 0 */
+/* Subfields of IntrErrStat */
+#define VREG_BMC_INTRERRSTAT_RSVD_MASK 0xfffffffe      /* Reserved [1.=
=2E31] */
+#define VREG_BMC_INTRERRSTAT_ERR1_MASK 0x00000001      /* Example - De=
tails to be filled in [0..0] */
+
+
+
+
+/* Fatal Error Status (31..0) */
+#define VREG_BMC_NMIERRSTAT_MASK       0xffffffff
+#define VREG_BMC_NMIERRSTAT_ACCESSMODE         2
+#define VREG_BMC_NMIERRSTAT_HOSTPRIVILEGE      1
+#define VREG_BMC_NMIERRSTAT_RESERVEDMASK       0xfffffffe
+#define VREG_BMC_NMIERRSTAT_WRITEMASK  0x00000001
+#define VREG_BMC_NMIERRSTAT_READMASK   0x00000001
+#define VREG_BMC_NMIERRSTAT_CLEARMASK  0x00000001
+#define VREG_BMC_NMIERRSTAT    0x154
+#define VREG_BMC_NMIERRSTAT_ID         85
+
+#define VVAL_BMC_NMIERRSTAT_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+/* Subfields of NMIErrStat */
+#define VREG_BMC_NMIERRSTAT_RSVD_MASK  0xfffffffe      /* Reserved [1.=
=2E31] */
+#define VREG_BMC_NMIERRSTAT_ERR1_MASK  0x00000001      /* Example - De=
tails to be filled in [0..0] */
+
+
+
+
+/* First NonFatal Error (31..0) */
+#define VREG_BMC_FRSTINTRERR_MASK      0xffffffff
+#define VREG_BMC_FRSTINTRERR_ACCESSMODE        2
+#define VREG_BMC_FRSTINTRERR_HOSTPRIVILEGE     1
+#define VREG_BMC_FRSTINTRERR_RESERVEDMASK      0xfffffffe
+#define VREG_BMC_FRSTINTRERR_WRITEMASK         0x00000001
+#define VREG_BMC_FRSTINTRERR_READMASK  0x00000001
+#define VREG_BMC_FRSTINTRERR_CLEARMASK         0x00000001
+#define VREG_BMC_FRSTINTRERR   0x158
+#define VREG_BMC_FRSTINTRERR_ID        86
+
+#define VVAL_BMC_FRSTINTRERR_DEFAULT 0x0       /* Reset by hreset: Res=
et to 0 */
+/* Subfields of FrstIntrErr */
+#define VREG_BMC_FRSTINTRERR_RSVD_MASK 0xfffffffe      /* Reserved [1.=
=2E31] */
+#define VREG_BMC_FRSTINTRERR_ERR1_MASK 0x00000001      /* Example - De=
tails to be filled in [0..0] */
+
+
+
+
+/* First Fatal Error (31..0) */
+#define VREG_BMC_FRSTNMIERR_MASK       0xffffffff
+#define VREG_BMC_FRSTNMIERR_ACCESSMODE         2
+#define VREG_BMC_FRSTNMIERR_HOSTPRIVILEGE      1
+#define VREG_BMC_FRSTNMIERR_RESERVEDMASK       0xfffffffe
+#define VREG_BMC_FRSTNMIERR_WRITEMASK  0x00000001
+#define VREG_BMC_FRSTNMIERR_READMASK   0x00000001
+#define VREG_BMC_FRSTNMIERR_CLEARMASK  0x00000001
+#define VREG_BMC_FRSTNMIERR    0x15c
+#define VREG_BMC_FRSTNMIERR_ID         87
+
+#define VVAL_BMC_FRSTNMIERR_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+/* Subfields of FrstNMIErr */
+#define VREG_BMC_FRSTNMIERR_RSVD_MASK  0xfffffffe      /* Reserved [1.=
=2E31] */
+#define VREG_BMC_FRSTNMIERR_ERR1_MASK  0x00000001      /* Example - De=
tails to be filled in [0..0] */
+
+
+
+
+/* Fabric configuration Register (31..0) */
+#define VREG_BMC_FABRIC_MASK   0xffffffff
+#define VREG_BMC_FABRIC_ACCESSMODE     2
+#define VREG_BMC_FABRIC_HOSTPRIVILEGE  1
+#define VREG_BMC_FABRIC_RESERVEDMASK   0xfffffff0
+#define VREG_BMC_FABRIC_WRITEMASK      0x0000000f
+#define VREG_BMC_FABRIC_READMASK       0x0000000f
+#define VREG_BMC_FABRIC_CLEARMASK      0x00000000
+#define VREG_BMC_FABRIC        0x200
+#define VREG_BMC_FABRIC_ID     128
+
+#define VVAL_BMC_FABRIC_DEFAULT 0x0    /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of Fabric */
+#define VREG_BMC_FABRIC_RESV0_MASK     0xfffffff0      /* Reserved [4.=
=2E31] */
+#define VREG_BMC_FABRIC_PORT_MASK      0x0000000f      /* Fabric Port =
Address [0..3] */
+
+
+
+
+/* VIOC Manager configuration Register (31..0) */
+#define VREG_BMC_VMGRCFG_MASK  0xffffffff
+#define VREG_BMC_VMGRCFG_ACCESSMODE    2
+#define VREG_BMC_VMGRCFG_HOSTPRIVILEGE         0
+#define VREG_BMC_VMGRCFG_RESERVEDMASK  0xfffffffe
+#define VREG_BMC_VMGRCFG_WRITEMASK     0x00000001
+#define VREG_BMC_VMGRCFG_READMASK      0x00000001
+#define VREG_BMC_VMGRCFG_CLEARMASK     0x00000000
+#define VREG_BMC_VMGRCFG       0x210
+#define VREG_BMC_VMGRCFG_ID    132
+
+#define VVAL_BMC_VMGRCFG_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of VMgrCfg */
+#define VREG_BMC_VMGRCFG_RESV0_MASK    0xfffffffe      /* Reserved [1.=
=2E31] */
+#define VREG_BMC_VMGRCFG_MGIDOFFSET_MASK       0x00000001      /* Enab=
les CSIX MGID Offset [0..0] */
+
+
+
+
+/* VIOC Manager PCI configuration Register 0 (31..0) */
+#define VREG_BMC_VMGRPCICFG0_MASK      0xffffffff
+#define VREG_BMC_VMGRPCICFG0_ACCESSMODE        2
+#define VREG_BMC_VMGRPCICFG0_HOSTPRIVILEGE     0
+#define VREG_BMC_VMGRPCICFG0_RESERVEDMASK      0x7f000000
+#define VREG_BMC_VMGRPCICFG0_WRITEMASK         0x80ffffff
+#define VREG_BMC_VMGRPCICFG0_READMASK  0x80ffffff
+#define VREG_BMC_VMGRPCICFG0_CLEARMASK         0x00000000
+#define VREG_BMC_VMGRPCICFG0   0x214
+#define VREG_BMC_VMGRPCICFG0_ID        133
+
+#define VVAL_BMC_VMGRPCICFG0_DEFAULT 0x80088000        /* Reset by hre=
set: Reset to Enabled */
+/* Subfields of VMgrPCICfg0 */
+#define VREG_BMC_VMGRPCICFG0_MSIXEN_MASK       0x80000000      /* Enab=
le MSI-X Configuration Registers [31..31] */
+#define VREG_BMC_VMGRPCICFG0_RESV0_MASK        0x7f000000      /* Rese=
rved [24..30] */
+#define VREG_BMC_VMGRPCICFG0_CLASSCODE_MASK    0x00ffffff      /* Clas=
s Code to expose for Function 0 [0..23] */
+
+
+
+
+/* Base address for Uart 0 (15..0) */
+#define VREG_BMC_UART0BASE_MASK        0x0000ffff
+#define VREG_BMC_UART0BASE_ACCESSMODE  2
+#define VREG_BMC_UART0BASE_HOSTPRIVILEGE       1
+#define VREG_BMC_UART0BASE_RESERVEDMASK        0x00000007
+#define VREG_BMC_UART0BASE_WRITEMASK   0x0000fff8
+#define VREG_BMC_UART0BASE_READMASK    0x0000fff8
+#define VREG_BMC_UART0BASE_CLEARMASK   0x00000000
+#define VREG_BMC_UART0BASE     0x300
+#define VREG_BMC_UART0BASE_ID  192
+
+#define VVAL_BMC_UART0BASE_DEFAULT 0x3f8       /* Reset by hreset: Def=
ault is the legacy COM1 port address */
+/* Subfields of UART0Base */
+#define VREG_BMC_UART0BASE_ADDR_MASK   0x0000fff8      /* UART0 Base A=
ddr [3..15] */
+#define VREG_BMC_UART0BASE_RSV1_MASK   0x00000007      /* Reserved - r=
ead as 0 [0..2] */
+
+
+
+
+/* IRQ number to be used by Uart 0 (3..0) */
+#define VREG_BMC_UART0IRQ_MASK         0x0000000f
+#define VREG_BMC_UART0IRQ_ACCESSMODE   2
+#define VREG_BMC_UART0IRQ_HOSTPRIVILEGE        1
+#define VREG_BMC_UART0IRQ_RESERVEDMASK         0x00000000
+#define VREG_BMC_UART0IRQ_WRITEMASK    0x0000000f
+#define VREG_BMC_UART0IRQ_READMASK     0x0000000f
+#define VREG_BMC_UART0IRQ_CLEARMASK    0x00000000
+#define VREG_BMC_UART0IRQ      0x304
+#define VREG_BMC_UART0IRQ_ID   193
+
+#define VVAL_BMC_UART0IRQ_DEFAULT 0x4  /* Reset by hreset: Default is =
the legacy COM1 IRQ */
+
+
+/* Send (write) and Receive (read) uart data register (15..0) */
+#define VREG_BMC_UART0DATA_MASK        0x0000ffff
+#define VREG_BMC_UART0DATA_ACCESSMODE  1
+#define VREG_BMC_UART0DATA_HOSTPRIVILEGE       1
+#define VREG_BMC_UART0DATA_RESERVEDMASK        0x0000cfff
+#define VREG_BMC_UART0DATA_WRITEMASK   0x00000000
+#define VREG_BMC_UART0DATA_READMASK    0x00003000
+#define VREG_BMC_UART0DATA_CLEARMASK   0x00000000
+#define VREG_BMC_UART0DATA     0x308
+#define VREG_BMC_UART0DATA_ID  194
+
+#define VVAL_BMC_UART0DATA_DEFAULT 0x0         /* Reset by hreset: Def=
ault is 0 */
+/* Subfields of UART0Data */
+#define VREG_BMC_UART0DATA_RSV1_MASK   0x0000c000      /* Reserved - r=
ead as 0 [14..15] */
+#define VREG_BMC_UART0DATA_TXRDY1_MASK 0x00002000      /* Uart1 Tx Rea=
dy Flag [13..13] */
+#define VREG_BMC_UART0DATA_TXRDY0_MASK 0x00001000      /* Uart0 Tx Rea=
dy Flag [12..12] */
+#define VREG_BMC_UART0DATA_RSV0_MASK   0x00000f00      /* Reserved - r=
ead as 0 [8..11] */
+#define VREG_BMC_UART0DATA_DATA_MASK   0x000000ff      /* UART Data Re=
gister [0..7] */
+
+
+
+
+/* Base address for Uart 1 (15..0) */
+#define VREG_BMC_UART1BASE_MASK        0x0000ffff
+#define VREG_BMC_UART1BASE_ACCESSMODE  2
+#define VREG_BMC_UART1BASE_HOSTPRIVILEGE       1
+#define VREG_BMC_UART1BASE_RESERVEDMASK        0x00000007
+#define VREG_BMC_UART1BASE_WRITEMASK   0x0000fff8
+#define VREG_BMC_UART1BASE_READMASK    0x0000fff8
+#define VREG_BMC_UART1BASE_CLEARMASK   0x00000000
+#define VREG_BMC_UART1BASE     0x310
+#define VREG_BMC_UART1BASE_ID  196
+
+#define VVAL_BMC_UART1BASE_DEFAULT 0x2f8       /* Reset by hreset: Def=
ault is the legacy COM2 port address */
+/* Subfields of UART1Base */
+#define VREG_BMC_UART1BASE_ADDR_MASK   0x0000fff8      /* UART1 Base A=
ddr [3..15] */
+#define VREG_BMC_UART1BASE_RSV1_MASK   0x00000007      /* Reserved - r=
ead as 0 [0..2] */
+
+
+
+
+/* IRQ number to be used by Uart 1 (3..0) */
+#define VREG_BMC_UART1IRQ_MASK         0x0000000f
+#define VREG_BMC_UART1IRQ_ACCESSMODE   2
+#define VREG_BMC_UART1IRQ_HOSTPRIVILEGE        1
+#define VREG_BMC_UART1IRQ_RESERVEDMASK         0x00000000
+#define VREG_BMC_UART1IRQ_WRITEMASK    0x0000000f
+#define VREG_BMC_UART1IRQ_READMASK     0x0000000f
+#define VREG_BMC_UART1IRQ_CLEARMASK    0x00000000
+#define VREG_BMC_UART1IRQ      0x314
+#define VREG_BMC_UART1IRQ_ID   197
+
+#define VVAL_BMC_UART1IRQ_DEFAULT 0x3  /* Reset by hreset: Default is =
the legacy COM2 IRQ */
+
+
+/* Send (write) and Receive (read) uart data register (15..0) */
+#define VREG_BMC_UART1DATA_MASK        0x0000ffff
+#define VREG_BMC_UART1DATA_ACCESSMODE  1
+#define VREG_BMC_UART1DATA_HOSTPRIVILEGE       1
+#define VREG_BMC_UART1DATA_RESERVEDMASK        0x0000cfff
+#define VREG_BMC_UART1DATA_WRITEMASK   0x00000000
+#define VREG_BMC_UART1DATA_READMASK    0x00003000
+#define VREG_BMC_UART1DATA_CLEARMASK   0x00000000
+#define VREG_BMC_UART1DATA     0x318
+#define VREG_BMC_UART1DATA_ID  198
+
+#define VVAL_BMC_UART1DATA_DEFAULT 0x0         /* Reset by hreset: Def=
ault is 0 */
+/* Subfields of UART1Data */
+#define VREG_BMC_UART1DATA_RSV1_MASK   0x0000c000      /* Reserved - r=
ead as 0 [14..15] */
+#define VREG_BMC_UART1DATA_TXRDY1_MASK 0x00002000      /* Uart1 Tx Rea=
dy Flag [13..13] */
+#define VREG_BMC_UART1DATA_TXRDY0_MASK 0x00001000      /* Uart0 Tx Rea=
dy Flag [12..12] */
+#define VREG_BMC_UART1DATA_RSV0_MASK   0x00000f00      /* Reserved - r=
ead as 0 [8..11] */
+#define VREG_BMC_UART1DATA_DATA_MASK   0x000000ff      /* UART Data Re=
gister [0..7] */
+
+
+
+
+/* VNIC Queue Enable register (31..0) */
+#define VREG_BMC_VNIC_CFG_MASK         0xffffffff
+#define VREG_BMC_VNIC_CFG_ACCESSMODE   2
+#define VREG_BMC_VNIC_CFG_HOSTPRIVILEGE        1
+#define VREG_BMC_VNIC_CFG_RESERVEDMASK         0xfffffffc
+#define VREG_BMC_VNIC_CFG_WRITEMASK    0x00000003
+#define VREG_BMC_VNIC_CFG_READMASK     0x00000003
+#define VREG_BMC_VNIC_CFG_CLEARMASK    0x00000000
+#define VREG_BMC_VNIC_CFG      0x800
+#define VREG_BMC_VNIC_CFG_ID   512
+    /*
+     * This register is repeated for each VNIC.
+     * Bits 15:12 of the address indicate the VNIC ID
+     */
+
+#define VVAL_BMC_VNIC_CFG_DEFAULT 0x0  /* Reset by sreset: Reset to 0 =
*/
+/* Subfields of VNIC_CFG */
+#define VREG_BMC_VNIC_CFG_RSV1_MASK    0xfffffffc      /* Reserved - r=
ead as 0 [2..31] */
+#define VREG_BMC_VNIC_CFG_PROMISCUOUS_MASK     0x00000002      /*  [1.=
=2E1] */
+#define VREG_BMC_VNIC_CFG_ENABLE_MASK  0x00000001      /*  [0..0] */
+
+
+
+
+/* VNIC Enable Register (15..0) */
+#define VREG_BMC_VNIC_EN_MASK  0x0000ffff
+#define VREG_BMC_VNIC_EN_ACCESSMODE    2
+#define VREG_BMC_VNIC_EN_HOSTPRIVILEGE         0
+#define VREG_BMC_VNIC_EN_RESERVEDMASK  0x00000000
+#define VREG_BMC_VNIC_EN_WRITEMASK     0x0000ffff
+#define VREG_BMC_VNIC_EN_READMASK      0x0000ffff
+#define VREG_BMC_VNIC_EN_CLEARMASK     0x00000000
+#define VREG_BMC_VNIC_EN       0x804
+#define VREG_BMC_VNIC_EN_ID    513
+    /*
+     * This register is privileged. The SIM writes this register to
+     * provision VNICs for the partition
+     */
+
+#define VVAL_BMC_VNIC_EN_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of VNIC_EN */
+#define VREG_BMC_VNIC_EN_VNIC0_MASK    0x00000001      /* Enable VNIC =
0 [0..0] */
+#define VREG_BMC_VNIC_EN_VNIC1_MASK    0x00000002      /* Enable VNIC =
1 [1..1] */
+#define VREG_BMC_VNIC_EN_VNIC2_MASK    0x00000004      /* Enable VNIC =
2 [2..2] */
+#define VREG_BMC_VNIC_EN_VNIC3_MASK    0x00000008      /* Enable VNIC =
3 [3..3] */
+#define VREG_BMC_VNIC_EN_VNIC4_MASK    0x00000010      /* Enable VNIC =
4 [4..4] */
+#define VREG_BMC_VNIC_EN_VNIC5_MASK    0x00000020      /* Enable VNIC =
5 [5..5] */
+#define VREG_BMC_VNIC_EN_VNIC6_MASK    0x00000040      /* Enable VNIC =
6 [6..6] */
+#define VREG_BMC_VNIC_EN_VNIC7_MASK    0x00000080      /* Enable VNIC =
7 [7..7] */
+#define VREG_BMC_VNIC_EN_VNIC8_MASK    0x00000100      /* Enable VNIC =
8 [8..8] */
+#define VREG_BMC_VNIC_EN_VNIC9_MASK    0x00000200      /* Enable VNIC =
9 [9..9] */
+#define VREG_BMC_VNIC_EN_VNIC10_MASK   0x00000400      /* Enable VNIC =
10 [10..10] */
+#define VREG_BMC_VNIC_EN_VNIC11_MASK   0x00000800      /* Enable VNIC =
11 [11..11] */
+#define VREG_BMC_VNIC_EN_VNIC12_MASK   0x00001000      /* Enable VNIC =
12 [12..12] */
+#define VREG_BMC_VNIC_EN_VNIC13_MASK   0x00002000      /* Enable VNIC =
13 [13..13] */
+#define VREG_BMC_VNIC_EN_VNIC14_MASK   0x00004000      /* Enable VNIC =
14 [14..14] */
+#define VREG_BMC_VNIC_EN_VNIC15_MASK   0x00008000      /* Enable VNIC =
15 [15..15] */
+
+
+
+
+/* PORT Enable Register (15..0) */
+#define VREG_BMC_PORT_EN_MASK  0x0000ffff
+#define VREG_BMC_PORT_EN_ACCESSMODE    2
+#define VREG_BMC_PORT_EN_HOSTPRIVILEGE         0
+#define VREG_BMC_PORT_EN_RESERVEDMASK  0x00000000
+#define VREG_BMC_PORT_EN_WRITEMASK     0x0000ffff
+#define VREG_BMC_PORT_EN_READMASK      0x0000ffff
+#define VREG_BMC_PORT_EN_CLEARMASK     0x00000000
+#define VREG_BMC_PORT_EN       0x808
+#define VREG_BMC_PORT_EN_ID    514
+    /*
+     * This register is privileged. The SIM writes this register to
+     * provision PORTs for the partition
+     */
+
+#define VVAL_BMC_PORT_EN_DEFAULT 0xffff        /* Reset by hreset: Res=
et enable all ports */
+/* Subfields of PORT_EN */
+#define VREG_BMC_PORT_EN_PORT0_MASK    0x00000001      /* Enable PORT =
0 [0..0] */
+#define VREG_BMC_PORT_EN_PORT1_MASK    0x00000002      /* Enable PORT =
1 [1..1] */
+#define VREG_BMC_PORT_EN_PORT2_MASK    0x00000004      /* Enable PORT =
2 [2..2] */
+#define VREG_BMC_PORT_EN_PORT3_MASK    0x00000008      /* Enable PORT =
3 [3..3] */
+#define VREG_BMC_PORT_EN_PORT4_MASK    0x00000010      /* Enable PORT =
4 [4..4] */
+#define VREG_BMC_PORT_EN_PORT5_MASK    0x00000020      /* Enable PORT =
5 [5..5] */
+#define VREG_BMC_PORT_EN_PORT6_MASK    0x00000040      /* Enable PORT =
6 [6..6] */
+#define VREG_BMC_PORT_EN_PORT7_MASK    0x00000080      /* Enable PORT =
7 [7..7] */
+#define VREG_BMC_PORT_EN_PORT8_MASK    0x00000100      /* Enable PORT =
8 [8..8] */
+#define VREG_BMC_PORT_EN_PORT9_MASK    0x00000200      /* Enable PORT =
9 [9..9] */
+#define VREG_BMC_PORT_EN_PORT10_MASK   0x00000400      /* Enable PORT =
10 [10..10] */
+#define VREG_BMC_PORT_EN_PORT11_MASK   0x00000800      /* Enable PORT =
11 [11..11] */
+#define VREG_BMC_PORT_EN_PORT12_MASK   0x00001000      /* Enable PORT =
12 [12..12] */
+#define VREG_BMC_PORT_EN_PORT13_MASK   0x00002000      /* Enable PORT =
13 [13..13] */
+#define VREG_BMC_PORT_EN_PORT14_MASK   0x00004000      /* Enable PORT =
14 [14..14] */
+#define VREG_BMC_PORT_EN_PORT15_MASK   0x00008000      /* Enable PORT =
15 [15..15] */
+
+
+
+
+/* General Scratchpad space. 32 Registers/VNIC (31..0) */
+#define VREG_BMC_REG_MASK      0xffffffff
+#define VREG_BMC_REG_ACCESSMODE        2
+#define VREG_BMC_REG_HOSTPRIVILEGE     1
+#define VREG_BMC_REG_RESERVEDMASK      0x00000000
+#define VREG_BMC_REG_WRITEMASK         0xffffffff
+#define VREG_BMC_REG_READMASK  0xffffffff
+#define VREG_BMC_REG_CLEARMASK         0x00000000
+#define VREG_BMC_REG   0x900
+#define VREG_BMC_REG_ID        576
+
+#define        VREG_BMC_REG_R0         0x900
+#define        VREG_BMC_REG_R1         0x904
+#define        VREG_BMC_REG_R2         0x908
+#define        VREG_BMC_REG_R3         0x90C
+#define        VREG_BMC_REG_R4         0x910
+#define        VREG_BMC_REG_R5         0x914
+#define        VREG_BMC_REG_R6         0x918
+#define        VREG_BMC_REG_R7         0x91C
+#define        VREG_BMC_REG_R8         0x920
+#define        VREG_BMC_REG_R9         0x924
+#define        VREG_BMC_REG_R10        0x928
+#define        VREG_BMC_REG_R11        0x92C
+#define        VREG_BMC_REG_R12        0x930
+#define        VREG_BMC_REG_R13        0x934
+#define        VREG_BMC_REG_R14        0x938
+#define        VREG_BMC_REG_R15        0x93C
+#define        VREG_BMC_REG_R16        0x940
+#define        VREG_BMC_REG_R17        0x944
+#define        VREG_BMC_REG_R18        0x948
+#define        VREG_BMC_REG_R19        0x94C
+#define        VREG_BMC_REG_R20        0x950
+#define        VREG_BMC_REG_R21        0x954
+#define        VREG_BMC_REG_R22        0x958
+#define        VREG_BMC_REG_R23        0x95C
+#define        VREG_BMC_REG_R24        0x960
+#define        VREG_BMC_REG_R25        0x964
+#define        VREG_BMC_REG_R26        0x968
+#define        VREG_BMC_REG_R27        0x96C
+#define        VREG_BMC_REG_R28        0x970
+#define        VREG_BMC_REG_R29        0x974
+#define        VREG_BMC_REG_R30        0x978
+#define        VREG_BMC_REG_R31        0x97C
+
+
+/* POST Code history registers (31..0) */
+#define VREG_BMC_POST_MASK     0xffffffff
+#define VREG_BMC_POST_ACCESSMODE       1
+#define VREG_BMC_POST_HOSTPRIVILEGE    1
+#define VREG_BMC_POST_RESERVEDMASK     0x00000000
+#define VREG_BMC_POST_WRITEMASK        0x00000000
+#define VREG_BMC_POST_READMASK         0xffffffff
+#define VREG_BMC_POST_CLEARMASK        0x00000000
+#define VREG_BMC_POST  0xc00
+#define VREG_BMC_POST_ID       768
+
+#define        VREG_BMC_POST_R0        0xC00
+#define        VREG_BMC_POST_R1        0xC04
+#define        VREG_BMC_POST_R2        0xC08
+#define        VREG_BMC_POST_R3        0xC0C
+#define        VREG_BMC_POST_R4        0xC10
+#define        VREG_BMC_POST_R5        0xC14
+#define        VREG_BMC_POST_R6        0xC18
+#define        VREG_BMC_POST_R7        0xC1C
+#define        VREG_BMC_POST_R8        0xC20
+#define        VREG_BMC_POST_R9        0xC24
+#define        VREG_BMC_POST_R10       0xC28
+#define        VREG_BMC_POST_R11       0xC2C
+#define        VREG_BMC_POST_R12       0xC30
+#define        VREG_BMC_POST_R13       0xC34
+#define        VREG_BMC_POST_R14       0xC38
+#define        VREG_BMC_POST_R15       0xC3C
+#define        VREG_BMC_POST_R16       0xC40
+#define        VREG_BMC_POST_R17       0xC44
+#define        VREG_BMC_POST_R18       0xC48
+#define        VREG_BMC_POST_R19       0xC4C
+#define        VREG_BMC_POST_R20       0xC50
+#define        VREG_BMC_POST_R21       0xC54
+#define        VREG_BMC_POST_R22       0xC58
+#define        VREG_BMC_POST_R23       0xC5C
+#define        VREG_BMC_POST_R24       0xC60
+#define        VREG_BMC_POST_R25       0xC64
+#define        VREG_BMC_POST_R26       0xC68
+#define        VREG_BMC_POST_R27       0xC6C
+#define        VREG_BMC_POST_R28       0xC70
+#define        VREG_BMC_POST_R29       0xC74
+#define        VREG_BMC_POST_R30       0xC78
+#define        VREG_BMC_POST_R31       0xC7C
+#define        VREG_BMC_POST_R32       0xC80
+#define        VREG_BMC_POST_R33       0xC84
+#define        VREG_BMC_POST_R34       0xC88
+#define        VREG_BMC_POST_R35       0xC8C
+#define        VREG_BMC_POST_R36       0xC90
+#define        VREG_BMC_POST_R37       0xC94
+#define        VREG_BMC_POST_R38       0xC98
+#define        VREG_BMC_POST_R39       0xC9C
+#define        VREG_BMC_POST_R40       0xCA0
+#define        VREG_BMC_POST_R41       0xCA4
+#define        VREG_BMC_POST_R42       0xCA8
+#define        VREG_BMC_POST_R43       0xCAC
+#define        VREG_BMC_POST_R44       0xCB0
+#define        VREG_BMC_POST_R45       0xCB4
+#define        VREG_BMC_POST_R46       0xCB8
+#define        VREG_BMC_POST_R47       0xCBC
+#define        VREG_BMC_POST_R48       0xCC0
+#define        VREG_BMC_POST_R49       0xCC4
+#define        VREG_BMC_POST_R50       0xCC8
+#define        VREG_BMC_POST_R51       0xCCC
+#define        VREG_BMC_POST_R52       0xCD0
+#define        VREG_BMC_POST_R53       0xCD4
+#define        VREG_BMC_POST_R54       0xCD8
+#define        VREG_BMC_POST_R55       0xCDC
+#define        VREG_BMC_POST_R56       0xCE0
+#define        VREG_BMC_POST_R57       0xCE4
+#define        VREG_BMC_POST_R58       0xCE8
+#define        VREG_BMC_POST_R59       0xCEC
+#define        VREG_BMC_POST_R60       0xCF0
+#define        VREG_BMC_POST_R61       0xCF4
+#define        VREG_BMC_POST_R62       0xCF8
+#define        VREG_BMC_POST_R63       0xCFC
+#define        VREG_BMC_POST_R64       0xD00
+#define        VREG_BMC_POST_R65       0xD04
+#define        VREG_BMC_POST_R66       0xD08
+#define        VREG_BMC_POST_R67       0xD0C
+#define        VREG_BMC_POST_R68       0xD10
+#define        VREG_BMC_POST_R69       0xD14
+#define        VREG_BMC_POST_R70       0xD18
+#define        VREG_BMC_POST_R71       0xD1C
+#define        VREG_BMC_POST_R72       0xD20
+#define        VREG_BMC_POST_R73       0xD24
+#define        VREG_BMC_POST_R74       0xD28
+#define        VREG_BMC_POST_R75       0xD2C
+#define        VREG_BMC_POST_R76       0xD30
+#define        VREG_BMC_POST_R77       0xD34
+#define        VREG_BMC_POST_R78       0xD38
+#define        VREG_BMC_POST_R79       0xD3C
+#define        VREG_BMC_POST_R80       0xD40
+#define        VREG_BMC_POST_R81       0xD44
+#define        VREG_BMC_POST_R82       0xD48
+#define        VREG_BMC_POST_R83       0xD4C
+#define        VREG_BMC_POST_R84       0xD50
+#define        VREG_BMC_POST_R85       0xD54
+#define        VREG_BMC_POST_R86       0xD58
+#define        VREG_BMC_POST_R87       0xD5C
+#define        VREG_BMC_POST_R88       0xD60
+#define        VREG_BMC_POST_R89       0xD64
+#define        VREG_BMC_POST_R90       0xD68
+#define        VREG_BMC_POST_R91       0xD6C
+#define        VREG_BMC_POST_R92       0xD70
+#define        VREG_BMC_POST_R93       0xD74
+#define        VREG_BMC_POST_R94       0xD78
+#define        VREG_BMC_POST_R95       0xD7C
+#define        VREG_BMC_POST_R96       0xD80
+#define        VREG_BMC_POST_R97       0xD84
+#define        VREG_BMC_POST_R98       0xD88
+#define        VREG_BMC_POST_R99       0xD8C
+#define        VREG_BMC_POST_R100      0xD90
+#define        VREG_BMC_POST_R101      0xD94
+#define        VREG_BMC_POST_R102      0xD98
+#define        VREG_BMC_POST_R103      0xD9C
+#define        VREG_BMC_POST_R104      0xDA0
+#define        VREG_BMC_POST_R105      0xDA4
+#define        VREG_BMC_POST_R106      0xDA8
+#define        VREG_BMC_POST_R107      0xDAC
+#define        VREG_BMC_POST_R108      0xDB0
+#define        VREG_BMC_POST_R109      0xDB4
+#define        VREG_BMC_POST_R110      0xDB8
+#define        VREG_BMC_POST_R111      0xDBC
+#define        VREG_BMC_POST_R112      0xDC0
+#define        VREG_BMC_POST_R113      0xDC4
+#define        VREG_BMC_POST_R114      0xDC8
+#define        VREG_BMC_POST_R115      0xDCC
+#define        VREG_BMC_POST_R116      0xDD0
+#define        VREG_BMC_POST_R117      0xDD4
+#define        VREG_BMC_POST_R118      0xDD8
+#define        VREG_BMC_POST_R119      0xDDC
+#define        VREG_BMC_POST_R120      0xDE0
+#define        VREG_BMC_POST_R121      0xDE4
+#define        VREG_BMC_POST_R122      0xDE8
+#define        VREG_BMC_POST_R123      0xDEC
+#define        VREG_BMC_POST_R124      0xDF0
+#define        VREG_BMC_POST_R125      0xDF4
+#define        VREG_BMC_POST_R126      0xDF8
+#define        VREG_BMC_POST_R127      0xDFC
+#define        VREG_BMC_POST_R128      0xE00
+#define        VREG_BMC_POST_R129      0xE04
+#define        VREG_BMC_POST_R130      0xE08
+#define        VREG_BMC_POST_R131      0xE0C
+#define        VREG_BMC_POST_R132      0xE10
+#define        VREG_BMC_POST_R133      0xE14
+#define        VREG_BMC_POST_R134      0xE18
+#define        VREG_BMC_POST_R135      0xE1C
+#define        VREG_BMC_POST_R136      0xE20
+#define        VREG_BMC_POST_R137      0xE24
+#define        VREG_BMC_POST_R138      0xE28
+#define        VREG_BMC_POST_R139      0xE2C
+#define        VREG_BMC_POST_R140      0xE30
+#define        VREG_BMC_POST_R141      0xE34
+#define        VREG_BMC_POST_R142      0xE38
+#define        VREG_BMC_POST_R143      0xE3C
+#define        VREG_BMC_POST_R144      0xE40
+#define        VREG_BMC_POST_R145      0xE44
+#define        VREG_BMC_POST_R146      0xE48
+#define        VREG_BMC_POST_R147      0xE4C
+#define        VREG_BMC_POST_R148      0xE50
+#define        VREG_BMC_POST_R149      0xE54
+#define        VREG_BMC_POST_R150      0xE58
+#define        VREG_BMC_POST_R151      0xE5C
+#define        VREG_BMC_POST_R152      0xE60
+#define        VREG_BMC_POST_R153      0xE64
+#define        VREG_BMC_POST_R154      0xE68
+#define        VREG_BMC_POST_R155      0xE6C
+#define        VREG_BMC_POST_R156      0xE70
+#define        VREG_BMC_POST_R157      0xE74
+#define        VREG_BMC_POST_R158      0xE78
+#define        VREG_BMC_POST_R159      0xE7C
+#define        VREG_BMC_POST_R160      0xE80
+#define        VREG_BMC_POST_R161      0xE84
+#define        VREG_BMC_POST_R162      0xE88
+#define        VREG_BMC_POST_R163      0xE8C
+#define        VREG_BMC_POST_R164      0xE90
+#define        VREG_BMC_POST_R165      0xE94
+#define        VREG_BMC_POST_R166      0xE98
+#define        VREG_BMC_POST_R167      0xE9C
+#define        VREG_BMC_POST_R168      0xEA0
+#define        VREG_BMC_POST_R169      0xEA4
+#define        VREG_BMC_POST_R170      0xEA8
+#define        VREG_BMC_POST_R171      0xEAC
+#define        VREG_BMC_POST_R172      0xEB0
+#define        VREG_BMC_POST_R173      0xEB4
+#define        VREG_BMC_POST_R174      0xEB8
+#define        VREG_BMC_POST_R175      0xEBC
+#define        VREG_BMC_POST_R176      0xEC0
+#define        VREG_BMC_POST_R177      0xEC4
+#define        VREG_BMC_POST_R178      0xEC8
+#define        VREG_BMC_POST_R179      0xECC
+#define        VREG_BMC_POST_R180      0xED0
+#define        VREG_BMC_POST_R181      0xED4
+#define        VREG_BMC_POST_R182      0xED8
+#define        VREG_BMC_POST_R183      0xEDC
+#define        VREG_BMC_POST_R184      0xEE0
+#define        VREG_BMC_POST_R185      0xEE4
+#define        VREG_BMC_POST_R186      0xEE8
+#define        VREG_BMC_POST_R187      0xEEC
+#define        VREG_BMC_POST_R188      0xEF0
+#define        VREG_BMC_POST_R189      0xEF4
+#define        VREG_BMC_POST_R190      0xEF8
+#define        VREG_BMC_POST_R191      0xEFC
+#define        VREG_BMC_POST_R192      0xF00
+#define        VREG_BMC_POST_R193      0xF04
+#define        VREG_BMC_POST_R194      0xF08
+#define        VREG_BMC_POST_R195      0xF0C
+#define        VREG_BMC_POST_R196      0xF10
+#define        VREG_BMC_POST_R197      0xF14
+#define        VREG_BMC_POST_R198      0xF18
+#define        VREG_BMC_POST_R199      0xF1C
+#define        VREG_BMC_POST_R200      0xF20
+#define        VREG_BMC_POST_R201      0xF24
+#define        VREG_BMC_POST_R202      0xF28
+#define        VREG_BMC_POST_R203      0xF2C
+#define        VREG_BMC_POST_R204      0xF30
+#define        VREG_BMC_POST_R205      0xF34
+#define        VREG_BMC_POST_R206      0xF38
+#define        VREG_BMC_POST_R207      0xF3C
+#define        VREG_BMC_POST_R208      0xF40
+#define        VREG_BMC_POST_R209      0xF44
+#define        VREG_BMC_POST_R210      0xF48
+#define        VREG_BMC_POST_R211      0xF4C
+#define        VREG_BMC_POST_R212      0xF50
+#define        VREG_BMC_POST_R213      0xF54
+#define        VREG_BMC_POST_R214      0xF58
+#define        VREG_BMC_POST_R215      0xF5C
+#define        VREG_BMC_POST_R216      0xF60
+#define        VREG_BMC_POST_R217      0xF64
+#define        VREG_BMC_POST_R218      0xF68
+#define        VREG_BMC_POST_R219      0xF6C
+#define        VREG_BMC_POST_R220      0xF70
+#define        VREG_BMC_POST_R221      0xF74
+#define        VREG_BMC_POST_R222      0xF78
+#define        VREG_BMC_POST_R223      0xF7C
+#define        VREG_BMC_POST_R224      0xF80
+#define        VREG_BMC_POST_R225      0xF84
+#define        VREG_BMC_POST_R226      0xF88
+#define        VREG_BMC_POST_R227      0xF8C
+#define        VREG_BMC_POST_R228      0xF90
+#define        VREG_BMC_POST_R229      0xF94
+#define        VREG_BMC_POST_R230      0xF98
+#define        VREG_BMC_POST_R231      0xF9C
+#define        VREG_BMC_POST_R232      0xFA0
+#define        VREG_BMC_POST_R233      0xFA4
+#define        VREG_BMC_POST_R234      0xFA8
+#define        VREG_BMC_POST_R235      0xFAC
+#define        VREG_BMC_POST_R236      0xFB0
+#define        VREG_BMC_POST_R237      0xFB4
+#define        VREG_BMC_POST_R238      0xFB8
+#define        VREG_BMC_POST_R239      0xFBC
+#define        VREG_BMC_POST_R240      0xFC0
+#define        VREG_BMC_POST_R241      0xFC4
+#define        VREG_BMC_POST_R242      0xFC8
+#define        VREG_BMC_POST_R243      0xFCC
+#define        VREG_BMC_POST_R244      0xFD0
+#define        VREG_BMC_POST_R245      0xFD4
+#define        VREG_BMC_POST_R246      0xFD8
+#define        VREG_BMC_POST_R247      0xFDC
+#define        VREG_BMC_POST_R248      0xFE0
+#define        VREG_BMC_POST_R249      0xFE4
+#define        VREG_BMC_POST_R250      0xFE8
+#define        VREG_BMC_POST_R251      0xFEC
+#define        VREG_BMC_POST_R252      0xFF0
+#define        VREG_BMC_POST_R253      0xFF4
+#define        VREG_BMC_POST_R254      0xFF8
+#define        VREG_BMC_POST_R255      0xFFC
+
+#endif /* _VNIC_BMC_REGISTERS_H_ */
+
diff -puN /dev/null drivers/net/vioc/f7/vioc_ht_registers.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vioc_ht_registers.h
@@ -0,0 +1,771 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+
+#ifndef _VIOC_HT_REGISTERS_H_
+#define _VIOC_HT_REGISTERS_H_
+/*
+ * HyperTransport Configuration Register Designators
+ * Register addresses are offsets from the VIOCs base Config Space add=
ress
+ * which is defined as 0xFDFE000000
+ */
+/* Module HT:4 */
+
+/* Device and Vendor ID (31..0) */
+#define VREG_HT_ID_MASK        0xffffffff
+#define VREG_HT_ID_ACCESSMODE  1
+#define VREG_HT_ID_HOSTPRIVILEGE       1
+#define VREG_HT_ID_RESERVEDMASK        0x00000000
+#define VREG_HT_ID_WRITEMASK   0x00000000
+#define VREG_HT_ID_READMASK    0xffffffff
+#define VREG_HT_ID_CLEARMASK   0x00000000
+#define VREG_HT_ID     0x000
+#define VREG_HT_ID_ID  0
+    /* Device Header */
+
+#define VVAL_HT_ID_DEFAULT 0x1fab7     /* Reset by hreset: Private Dev=
ice ID and Vendor ID */
+/* Subfields of ID */
+#define VREG_HT_ID_DEVID_MASK  0xffff0000      /* Device ID =3D 0x0001=
 [16..31] */
+#define VREG_HT_ID_VENDORID_MASK       0x0000ffff      /* Vendor ID =3D=
 0xFAB7 [0..15] */
+
+
+
+
+/* Command and Status register (31..0) */
+#define VREG_HT_CMD_MASK       0xffffffff
+#define VREG_HT_CMD_ACCESSMODE         2
+#define VREG_HT_CMD_HOSTPRIVILEGE      1
+#define VREG_HT_CMD_RESERVEDMASK       0x06e7fab8
+#define VREG_HT_CMD_WRITEMASK  0xf9000146
+#define VREG_HT_CMD_READMASK   0xf9180547
+#define VREG_HT_CMD_CLEARMASK  0xf9000000
+#define VREG_HT_CMD    0x004
+#define VREG_HT_CMD_ID         1
+
+#define VVAL_HT_CMD_DEFAULT 0x100000   /* Reset by hreset: */
+/* Subfields of Cmd */
+#define VREG_HT_CMD_DATAERR_MASK       0x80000000      /* Data Error D=
etected [31..31] */
+#define VREG_HT_CMD_SYSERR_MASK        0x40000000      /* Signalled Sy=
stem Error [30..30] */
+#define VREG_HT_CMD_RCVMSTRABRT_MASK   0x20000000      /* Received a M=
aster Abort [29..29] */
+#define VREG_HT_CMD_RCVTGTABRT_MASK    0x10000000      /* Received a T=
arget Abort [28..28] */
+#define VREG_HT_CMD_SIGTGTABRT_MASK    0x08000000      /* Signalled a =
Target Abort [27..27] */
+#define VREG_HT_CMD_RSV1_MASK  0x06000000      /* Reserved - read as 0=
 [25..26] */
+#define VREG_HT_CMD_MSTRDATAERR_MASK   0x01000000      /* Master Data =
Error [24..24] */
+#define VREG_HT_CMD_RSV2_MASK  0x00e00000      /* Reserved - read as 0=
 [21..23] */
+#define VREG_HT_CMD_CAPLIST_MASK       0x00100000      /* Capabilities=
 List Present - always 1 [20..20] */
+#define VREG_HT_CMD_INTSTATUS_MASK     0x00080000      /* Legacy Inter=
rupt Status - always 0 [19..19] */
+#define VREG_HT_CMD_RSV3_MASK  0x00070000      /* Reserved - read as 0=
 [16..18] */
+#define VREG_HT_CMD_RSV4_MASK  0x0000f800      /* Reserved - read as 0=
 [11..15] */
+#define VREG_HT_CMD_INTDISABLE_MASK    0x00000400      /* Legacy Inter=
rupt disable - always 0 [10..10] */
+#define VREG_HT_CMD_RSV5_MASK  0x00000200      /* Reserved - read as 0=
 [9..9] */
+#define VREG_HT_CMD_SERREN_MASK        0x00000100      /* Enable Sync =
flood on error [8..8] */
+#define VREG_HT_CMD_RSV6_MASK  0x00000080      /* Reserved - read as 0=
 [7..7] */
+#define VREG_HT_CMD_DERRRSP_MASK       0x00000040      /* Data Error R=
esponse [6..6] */
+#define VREG_HT_CMD_RSV7_MASK  0x00000038      /* Reserved - read as 0=
 [3..5] */
+#define VREG_HT_CMD_BUSMSTREN_MASK     0x00000004      /* Bus Master E=
nable [2..2] */
+#define VREG_HT_CMD_MEMSPACEEN_MASK    0x00000002      /* Memory Space=
 Enable [1..1] */
+#define VREG_HT_CMD_IOSPACEEN_MASK     0x00000001      /* IO Space Ena=
ble [0..0] */
+
+
+
+
+/* Class Code and Revision ID (31..0) */
+#define VREG_HT_CLASSREV_MASK  0xffffffff
+#define VREG_HT_CLASSREV_ACCESSMODE    1
+#define VREG_HT_CLASSREV_HOSTPRIVILEGE         1
+#define VREG_HT_CLASSREV_RESERVEDMASK  0x00000000
+#define VREG_HT_CLASSREV_WRITEMASK     0x00000000
+#define VREG_HT_CLASSREV_READMASK      0xffffffff
+#define VREG_HT_CLASSREV_CLEARMASK     0x00000000
+#define VREG_HT_CLASSREV       0x008
+#define VREG_HT_CLASSREV_ID    2
+
+#define VVAL_HT_CLASSREV_DEFAULT 0x8800001     /* Reset by hreset: Har=
dwired */
+/* Subfields of ClassRev */
+#define VREG_HT_CLASSREV_CLASS_MASK    0xffffff00      /* Class Code =3D=
 0x088000 [8..31] */
+#define VREG_HT_CLASSREV_REVID_MASK    0x000000ff      /* Revision ID =
=3D 0x01 [0..7] */
+
+
+
+
+/* Cache Line Size register - not implemented (31..0) */
+#define VREG_HT_CACHELSZ_MASK  0xffffffff
+#define VREG_HT_CACHELSZ_ACCESSMODE    1
+#define VREG_HT_CACHELSZ_HOSTPRIVILEGE         1
+#define VREG_HT_CACHELSZ_RESERVEDMASK  0x00000000
+#define VREG_HT_CACHELSZ_WRITEMASK     0x00000000
+#define VREG_HT_CACHELSZ_READMASK      0xffffffff
+#define VREG_HT_CACHELSZ_CLEARMASK     0x00000000
+#define VREG_HT_CACHELSZ       0x00c
+#define VREG_HT_CACHELSZ_ID    3
+
+#define VVAL_HT_CACHELSZ_DEFAULT 0x800000      /* Reset by hreset: Def=
ault value */
+/* Subfields of CacheLSz */
+#define VREG_HT_CACHELSZ_BIST_MASK     0xff000000      /* BIST [24..31=
] */
+#define VREG_HT_CACHELSZ_MULTIFUNC_MASK        0x00800000      /* Mult=
iFunction Device Flag [23..23] */
+#define VREG_HT_CACHELSZ_HDRTYPE_MASK  0x007f0000      /* Header Type =
[16..22] */
+#define VREG_HT_CACHELSZ_LATTIMER_MASK 0x0000ff00      /* Latency Time=
r [8..15] */
+#define VREG_HT_CACHELSZ_LINESZ_MASK   0x000000ff      /* Cache Line S=
ize [0..7] */
+
+
+
+
+/* Bits 31:0 of Memory Base Address - bits 23:0 are ignored and assume=
d to be 0 (31..0) */
+#define VREG_HT_MEMBASEADDR_LO_MASK    0xffffffff
+#define VREG_HT_MEMBASEADDR_LO_ACCESSMODE      2
+#define VREG_HT_MEMBASEADDR_LO_HOSTPRIVILEGE   1
+#define VREG_HT_MEMBASEADDR_LO_RESERVEDMASK    0x00000000
+#define VREG_HT_MEMBASEADDR_LO_WRITEMASK       0xffffffff
+#define VREG_HT_MEMBASEADDR_LO_READMASK        0xffffffff
+#define VREG_HT_MEMBASEADDR_LO_CLEARMASK       0x00000000
+#define VREG_HT_MEMBASEADDR_LO         0x010
+#define VREG_HT_MEMBASEADDR_LO_ID      4
+
+#define VVAL_HT_MEMBASEADDR_LO_DEFAULT 0x4     /* Reset by hreset: Res=
et to 0 */
+
+
+/* Bits 63:32 of Memory Base Address - bits 63:40 are ignored (31..0) =
*/
+#define VREG_HT_MEMBASEADDR_HI_MASK    0xffffffff
+#define VREG_HT_MEMBASEADDR_HI_ACCESSMODE      2
+#define VREG_HT_MEMBASEADDR_HI_HOSTPRIVILEGE   1
+#define VREG_HT_MEMBASEADDR_HI_RESERVEDMASK    0x00000000
+#define VREG_HT_MEMBASEADDR_HI_WRITEMASK       0xffffffff
+#define VREG_HT_MEMBASEADDR_HI_READMASK        0xffffffff
+#define VREG_HT_MEMBASEADDR_HI_CLEARMASK       0x00000000
+#define VREG_HT_MEMBASEADDR_HI         0x014
+#define VREG_HT_MEMBASEADDR_HI_ID      5
+
+#define VVAL_HT_MEMBASEADDR_HI_DEFAULT 0x0     /* Reset by hreset: Res=
et to 0 */
+
+
+/* Pointer to Capability List (7..0) */
+#define VREG_HT_CAPPTR_MASK    0x000000ff
+#define VREG_HT_CAPPTR_ACCESSMODE      1
+#define VREG_HT_CAPPTR_HOSTPRIVILEGE   1
+#define VREG_HT_CAPPTR_RESERVEDMASK    0x00000000
+#define VREG_HT_CAPPTR_WRITEMASK       0x00000000
+#define VREG_HT_CAPPTR_READMASK        0x000000ff
+#define VREG_HT_CAPPTR_CLEARMASK       0x00000000
+#define VREG_HT_CAPPTR         0x034
+#define VREG_HT_CAPPTR_ID      13
+
+#define VVAL_HT_CAPPTR_DEFAULT 0x40    /* Reset by hreset: */
+
+
+/* Sub rev ID for experimental versions of the part (7..0) */
+#define VREG_HT_EXPREV_MASK    0x000000ff
+#define VREG_HT_EXPREV_ACCESSMODE      2
+#define VREG_HT_EXPREV_HOSTPRIVILEGE   1
+#define VREG_HT_EXPREV_RESERVEDMASK    0x00000000
+#define VREG_HT_EXPREV_WRITEMASK       0x000000ff
+#define VREG_HT_EXPREV_READMASK        0x000000ff
+#define VREG_HT_EXPREV_CLEARMASK       0x00000000
+#define VREG_HT_EXPREV         0x038
+#define VREG_HT_EXPREV_ID      14
+
+#define VVAL_HT_EXPREV_DEFAULT 0x0     /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Interrupt Line - RW scratchpad register (15..0) */
+#define VREG_HT_INT_MASK       0x0000ffff
+#define VREG_HT_INT_ACCESSMODE         2
+#define VREG_HT_INT_HOSTPRIVILEGE      1
+#define VREG_HT_INT_RESERVEDMASK       0x00000000
+#define VREG_HT_INT_WRITEMASK  0x000000ff
+#define VREG_HT_INT_READMASK   0x0000ffff
+#define VREG_HT_INT_CLEARMASK  0x00000000
+#define VREG_HT_INT    0x03c
+#define VREG_HT_INT_ID         15
+
+#define VVAL_HT_INT_DEFAULT 0x100      /* Reset by hreset: Reset to 10=
0 */
+/* Subfields of Int */
+#define VREG_HT_INT_PIN_MASK   0x0000ff00      /* Interrupt pin used b=
y Function [8..15] */
+#define VREG_HT_INT_LINE_MASK  0x000000ff      /* Interrupt Line assig=
ned by Function BIOS [0..7] */
+
+
+
+
+/* Command and Capability Register (31..0) */
+#define VREG_HT_CAP0_MASK      0xffffffff
+#define VREG_HT_CAP0_ACCESSMODE        2
+#define VREG_HT_CAP0_HOSTPRIVILEGE     1
+#define VREG_HT_CAP0_RESERVEDMASK      0x00000000
+#define VREG_HT_CAP0_WRITEMASK         0x101f0000
+#define VREG_HT_CAP0_READMASK  0xffffffff
+#define VREG_HT_CAP0_CLEARMASK         0x00000000
+#define VREG_HT_CAP0   0x040
+#define VREG_HT_CAP0_ID        16
+    /* Capability Header */
+
+#define VVAL_HT_CAP0_DEFAULT 0x806008  /* Reset by hreset: */
+/* Subfields of Cap0 */
+#define VREG_HT_CAP0_TYPESLV_MASK      0xe0000000      /* Capability T=
ype Field. Slave =3D 0x0 [29..31] */
+#define VREG_HT_CAP0_DROPUNINIT_MASK   0x10000000      /* Drop on Unin=
itialized Link. [28..28] */
+#define VREG_HT_CAP0_DIR_MASK  0x08000000      /* Default Direction. I=
gnored on cave. [27..27] */
+#define VREG_HT_CAP0_MSTRHOST_MASK     0x04000000      /* Indicates wh=
ich link is path to master host bridge [26..26] */
+#define VREG_HT_CAP0_UNITCNT_MASK      0x03e00000      /* Number of Un=
itIDs required by this device [21..25] */
+#define VREG_HT_CAP0_BASEUNITID_MASK   0x001f0000      /* Base UnitID.=
 Lowest numbered UnitID belonging to this device [16..20] */
+#define VREG_HT_CAP0_CAPPTR_MASK       0x0000ff00      /* Pointer to n=
ext Capability Block =3D 0x60 [8..15] */
+#define VREG_HT_CAP0_CAPID_MASK        0x000000ff      /* Capability I=
D =3D 0x08 [0..7] */
+
+
+
+
+/* Link0 Config and Control Register (31..0) */
+#define VREG_HT_CAP1_MASK      0xffffffff
+#define VREG_HT_CAP1_ACCESSMODE        2
+#define VREG_HT_CAP1_HOSTPRIVILEGE     1
+#define VREG_HT_CAP1_RESERVEDMASK      0x00000001
+#define VREG_HT_CAP1_WRITEMASK         0x77000f0a
+#define VREG_HT_CAP1_READMASK  0xfffffffe
+#define VREG_HT_CAP1_CLEARMASK         0x00000f00
+#define VREG_HT_CAP1   0x044
+#define VREG_HT_CAP1_ID        17
+
+#define VVAL_HT_CAP1_DEFAULT 0x110000  /* Reset by hreset: Reset value=
 */
+/* Subfields of Cap1 */
+#define VREG_HT_CAP1_CFG_DWFCOUTEN_MASK        0x80000000      /* Doub=
le Word Flow Control Out enable [31..31] */
+#define VREG_HT_CAP1_CFG_LWIDTHOUT_MASK        0x70000000      /* Link=
 width to use for Output [28..30] */
+#define VREG_HT_CAP1_CFG_DWFCINEN_MASK 0x08000000      /* Double Word =
=46low Control In enable [27..27] */
+#define VREG_HT_CAP1_CFG_LWIDTHIN_MASK 0x07000000      /* Link width t=
o use for Input [24..26] */
+#define VREG_HT_CAP1_CFG_DWFCOUT_MASK  0x00800000      /* Double Word =
=46low Control Out [23..23] */
+#define VREG_HT_CAP1_CFG_MAXWIDTHOUT_MASK      0x00700000      /* Maxi=
mum Link width of output port [20..22] */
+#define VREG_HT_CAP1_CFG_DWFCIN_MASK   0x00080000      /* Double Word =
=46low Control In [19..19] */
+#define VREG_HT_CAP1_CFG_MAXWIDTHIN_MASK       0x00070000      /* Maxi=
mum Link width of input port [16..18] */
+#define VREG_HT_CAP1_CTL_64BEN_MASK    0x00008000      /* Enable 64 bi=
t addressing [15..15] */
+#define VREG_HT_CAP1_CTL_EXTCTLTIME_MASK       0x00004000      /* Asse=
rt CTL for 50 uSec after LDTSTOP [14..14] */
+#define VREG_HT_CAP1_CTL_LDTSTOPTE_MASK        0x00002000      /* Tris=
tate link during LDTSTOP [13..13] */
+#define VREG_HT_CAP1_CTL_ISOCFCEN_MASK 0x00001000      /* Isochronous =
=46low Control Enable [12..12] */
+#define VREG_HT_CAP1_CTL_CRCERROR_MASK 0x00000f00      /* CRC Error [8=
=2E.11] */
+#define VREG_HT_CAP1_CTL_XMITOFF_MASK  0x00000080      /* Transmitter =
Off - SW can set, not clear [7..7] */
+#define VREG_HT_CAP1_CTL_ENDOFCHAIN_MASK       0x00000040      /* End =
of Chain - SW can set, not clear [6..6] */
+#define VREG_HT_CAP1_CTL_INITDONE_MASK 0x00000020      /* Asserted whe=
n Initialization is complete [5..5] */
+#define VREG_HT_CAP1_CTL_LINKFAIL_MASK 0x00000010      /* Set if a Fai=
lure is detected on the link [4..4] */
+#define VREG_HT_CAP1_CTL_FRCCRCERR_MASK        0x00000008      /* Forc=
e CRC errors [3..3] */
+#define VREG_HT_CAP1_CTL_CRCTEST_MASK  0x00000004      /* Start CRC Te=
st [2..2] */
+#define VREG_HT_CAP1_CTL_CRCFLOODEN_MASK       0x00000002      /* Gene=
rate Sync flood on CRC error [1..1] */
+#define VREG_HT_CAP1_CTL_RSV1_MASK     0x00000001      /* Reserved [0.=
=2E0] */
+
+
+
+
+/* Link1 Config and Control Register (31..0) */
+#define VREG_HT_CAP2_MASK      0xffffffff
+#define VREG_HT_CAP2_ACCESSMODE        1
+#define VREG_HT_CAP2_HOSTPRIVILEGE     1
+#define VREG_HT_CAP2_RESERVEDMASK      0x00000000
+#define VREG_HT_CAP2_WRITEMASK         0x00000000
+#define VREG_HT_CAP2_READMASK  0xffffffff
+#define VREG_HT_CAP2_CLEARMASK         0x00000000
+#define VREG_HT_CAP2   0x048
+#define VREG_HT_CAP2_ID        18
+
+#define VVAL_HT_CAP2_DEFAULT 0xd0      /* Reset by hreset: There is no=
 second link */
+/* Subfields of Cap2 */
+#define VREG_HT_CAP2_CFG_DWFCOUTEN_MASK        0x80000000      /* Doub=
le Word Flow Control Out enable [31..31] */
+#define VREG_HT_CAP2_CFG_LWIDTHOUT_MASK        0x70000000      /* Link=
 width to use for Output [28..30] */
+#define VREG_HT_CAP2_CFG_DWFCINEN_MASK 0x08000000      /* Double Word =
=46low Control In enable [27..27] */
+#define VREG_HT_CAP2_CFG_LWIDTHIN_MASK 0x07000000      /* Link width t=
o use for Input [24..26] */
+#define VREG_HT_CAP2_CFG_DWFCOUT_MASK  0x00800000      /* Double Word =
=46low Control Out [23..23] */
+#define VREG_HT_CAP2_CFG_MAXWIDTHOUT_MASK      0x00700000      /* Maxi=
mum Link width of output port [20..22] */
+#define VREG_HT_CAP2_CFG_DWFCIN_MASK   0x00080000      /* Double Word =
=46low Control In [19..19] */
+#define VREG_HT_CAP2_CFG_MAXWIDTHIN_MASK       0x00070000      /* Maxi=
mum Link width of input port [16..18] */
+#define VREG_HT_CAP2_CTL_64BEN_MASK    0x00008000      /* Enable 64 bi=
t addressing [15..15] */
+#define VREG_HT_CAP2_CTL_EXTCTLTIME_MASK       0x00004000      /* Asse=
rt CTL for 50 uSec after LDTSTOP [14..14] */
+#define VREG_HT_CAP2_CTL_LDTSTOPTE_MASK        0x00002000      /* Tris=
tate link during LDTSTOP [13..13] */
+#define VREG_HT_CAP2_CTL_ISOCFCEN_MASK 0x00001000      /* Isochronous =
=46low Control Enable [12..12] */
+#define VREG_HT_CAP2_CTL_CRCERROR_MASK 0x00000f00      /* CRC Error [8=
=2E.11] */
+#define VREG_HT_CAP2_CTL_XMITOFF_MASK  0x00000080      /* Transmitter =
Off [7..7] */
+#define VREG_HT_CAP2_CTL_ENDOFCHAIN_MASK       0x00000040      /* End =
of Chain [6..6] */
+#define VREG_HT_CAP2_CTL_INITDONE_MASK 0x00000020      /* Asserted whe=
n Initialization is complete [5..5] */
+#define VREG_HT_CAP2_CTL_LINKFAIL_MASK 0x00000010      /* Set if a Fai=
lure is detected on the link [4..4] */
+#define VREG_HT_CAP2_CTL_FRCCRCERR_MASK        0x00000008      /* Forc=
e CRC errors [3..3] */
+#define VREG_HT_CAP2_CTL_CRCTEST_MASK  0x00000004      /* Start CRC Te=
st [2..2] */
+#define VREG_HT_CAP2_CTL_CRCFLOODEN_MASK       0x00000002      /* Gene=
rate Sync flood on CRC error [1..1] */
+#define VREG_HT_CAP2_CTL_RSV1_MASK     0x00000001      /* Reserved [0.=
=2E0] */
+
+
+
+
+/* , Word 3 of Capability Block (31..0) */
+#define VREG_HT_CAP3_MASK      0xffffffff
+#define VREG_HT_CAP3_ACCESSMODE        2
+#define VREG_HT_CAP3_HOSTPRIVILEGE     1
+#define VREG_HT_CAP3_RESERVEDMASK      0x00000000
+#define VREG_HT_CAP3_WRITEMASK         0x00006f00
+#define VREG_HT_CAP3_READMASK  0xffffffff
+#define VREG_HT_CAP3_CLEARMASK         0x00006000
+#define VREG_HT_CAP3   0x04c
+#define VREG_HT_CAP3_ID        19
+
+#define VVAL_HT_CAP3_DEFAULT 0x50025   /* Reset by hreset: HT link rev=
 1.05, 200 and 400 MHz only */
+/* Subfields of Cap3 */
+#define VREG_HT_CAP3_FREQCAP_MASK      0xffff0000      /* Frequencies =
supported by device [16..31] */
+#define VREG_HT_CAP3_CTLTIMEOUT_MASK   0x00008000      /* CTL Timeout =
Error Detected [15..15] */
+#define VREG_HT_CAP3_EOCERR_MASK       0x00004000      /* End of Chain=
 Error Detected [14..14] */
+#define VREG_HT_CAP3_OVFLERR_MASK      0x00002000      /* Buffer Overf=
low Error Detected [13..13] */
+#define VREG_HT_CAP3_PROTERR_MASK      0x00001000      /* Protocol Err=
or Detected [12..12] */
+#define VREG_HT_CAP3_LINKFREQ_MASK     0x00000f00      /* Link Frequen=
cy Control [8..11] */
+#define VVAL_HT_CAP3_LINKFREQ_200 0x0  /* 200 Mhz */
+#define VVAL_HT_CAP3_LINKFREQ_400 0x200        /* 400 Mhz */
+#define VREG_HT_CAP3_MAJORREV_MASK     0x000000e0      /* Major HT rev=
ision level - 1 [5..7] */
+#define VREG_HT_CAP3_MINORREV_MASK     0x0000001f      /* Minor HT rev=
ision level - .05 [0..4] */
+
+
+
+
+/* Word 4 of Capability Block (31..0) */
+#define VREG_HT_CAP4_MASK      0xffffffff
+#define VREG_HT_CAP4_ACCESSMODE        1
+#define VREG_HT_CAP4_HOSTPRIVILEGE     1
+#define VREG_HT_CAP4_RESERVEDMASK      0x00000000
+#define VREG_HT_CAP4_WRITEMASK         0x00000000
+#define VREG_HT_CAP4_READMASK  0xffffffff
+#define VREG_HT_CAP4_CLEARMASK         0x00000000
+#define VREG_HT_CAP4   0x050
+#define VREG_HT_CAP4_ID        20
+
+#define VVAL_HT_CAP4_DEFAULT 0x0       /* Reset by hreset: No extra fe=
atures */
+
+
+/* Word 4 of Capability Block (31..0) */
+#define VREG_HT_CAP5_MASK      0xffffffff
+#define VREG_HT_CAP5_ACCESSMODE        2
+#define VREG_HT_CAP5_HOSTPRIVILEGE     1
+#define VREG_HT_CAP5_RESERVEDMASK      0x00000000
+#define VREG_HT_CAP5_WRITEMASK         0x7a7affff
+#define VREG_HT_CAP5_READMASK  0xffffffff
+#define VREG_HT_CAP5_CLEARMASK         0x02000000
+#define VREG_HT_CAP5   0x054
+#define VREG_HT_CAP5_ID        21
+
+#define VVAL_HT_CAP5_DEFAULT 0x0       /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of Cap5 */
+#define VREG_HT_CAP5_SERRNFEEN_MASK    0x80000000      /* System Error=
 Non-Fatal Interrupt Enable [31..31] */
+#define VREG_HT_CAP5_CRCNFEEN_MASK     0x40000000      /* CRC Error No=
n-Fatal Interrupt Enable [30..30] */
+#define VREG_HT_CAP5_RSPNFEEN_MASK     0x20000000      /* Response Err=
or Non-Fatal Interrupt Enable [29..29] */
+#define VREG_HT_CAP5_EOCNFEEN_MASK     0x10000000      /* End of Chain=
 Error Non-Fatal Interrupt Enable [28..28] */
+#define VREG_HT_CAP5_OVFLNFEEN_MASK    0x08000000      /* Overflow Err=
or Non-Fatal Interrupt Enable [27..27] */
+#define VREG_HT_CAP5_PROTNFEEN_MASK    0x04000000      /* Protocol Err=
or Non-Fatal Interrupt Enable [26..26] */
+#define VREG_HT_CAP5_RSPERROR_MASK     0x02000000      /* Set to indic=
ate Response Error received [25..25] */
+#define VREG_HT_CAP5_CHAINFAIL_MASK    0x01000000      /* Set to indic=
ate Sync flood received [24..24] */
+#define VREG_HT_CAP5_SERRFEEN_MASK     0x00800000      /* System Error=
 Fatal Interrupt Enable [23..23] */
+#define VREG_HT_CAP5_CRCFEEN_MASK      0x00400000      /* CRC Error Fa=
tal Interrupt Enable [22..22] */
+#define VREG_HT_CAP5_RSPFEEN_MASK      0x00200000      /* Response Err=
or Fatal Interrupt Enable [21..21] */
+#define VREG_HT_CAP5_EOCFEEN_MASK      0x00100000      /* End of Chain=
 Error Fatal Interrupt Enable [20..20] */
+#define VREG_HT_CAP5_OVFLFEEN_MASK     0x00080000      /* Overflow Err=
or Fatal Interrupt Enable [19..19] */
+#define VREG_HT_CAP5_PROTFEEN_MASK     0x00040000      /* Protocol Err=
or Fatal Interrupt Enable [18..18] */
+#define VREG_HT_CAP5_OVFLFLDEN_MASK    0x00020000      /* Overflow Err=
or Flood Enable [17..17] */
+#define VREG_HT_CAP5_PROTFLDEN_MASK    0x00010000      /* Protocol Err=
or Flood Enable [16..16] */
+#define VREG_HT_CAP5_SCRATCH_MASK      0x0000ffff      /* Enumeration =
Scratchpad register [0..15] */
+
+
+
+/*
+ * MSIX Table Structure
+ * One table entry is described here.
+ * There are a total of 19 table entries.
+ */
+/* Module MSIXTBL:96 */
+
+/* MSIX PBA Structure - ReadOnly */
+/* Module MSIXPBA:97 */
+
+/* MSI-X Discovery And Configuration Capability Block (31..0) */
+#define VREG_HT_MSIXCAP0_MASK  0xffffffff
+#define VREG_HT_MSIXCAP0_ACCESSMODE    2
+#define VREG_HT_MSIXCAP0_HOSTPRIVILEGE         1
+#define VREG_HT_MSIXCAP0_RESERVEDMASK  0x38000000
+#define VREG_HT_MSIXCAP0_WRITEMASK     0xc0000000
+#define VREG_HT_MSIXCAP0_READMASK      0xc7ffffff
+#define VREG_HT_MSIXCAP0_CLEARMASK     0x00000000
+#define VREG_HT_MSIXCAP0       0x060
+#define VREG_HT_MSIXCAP0_ID    24
+
+#define VVAL_HT_MSIXCAP0_DEFAULT 0x120011      /* Reset by hreset: Res=
et value */
+/* Subfields of MsixCap0 */
+#define VREG_HT_MSIXCAP0_MSIX_EN_MASK  0x80000000      /* Enable MSI-X=
 function [31..31] */
+#define VREG_HT_MSIXCAP0_FUNCMASK_MASK 0x40000000      /* Mask all MSI=
-X interrupts [30..30] */
+#define VREG_HT_MSIXCAP0_RSVD_MASK     0x38000000      /* Reserved [27=
=2E.29] */
+#define VREG_HT_MSIXCAP0_TBLSIZE_MASK  0x07ff0000      /* MSI-X Table =
Size [16..26] */
+#define VREG_HT_MSIXCAP0_NEXT_MASK     0x0000ff00      /* pointer to n=
ext capability block [8..15] */
+#define VREG_HT_MSIXCAP0_ID_MASK       0x000000ff      /* 0x11 MSI-X I=
D [0..7] */
+
+
+
+
+/* MSI-X Discovery And Configuration Capability Block (31..0) */
+#define VREG_HT_MSIXCAP1_MASK  0xffffffff
+#define VREG_HT_MSIXCAP1_ACCESSMODE    2
+#define VREG_HT_MSIXCAP1_HOSTPRIVILEGE         1
+#define VREG_HT_MSIXCAP1_RESERVEDMASK  0x00000000
+#define VREG_HT_MSIXCAP1_WRITEMASK     0x00000000
+#define VREG_HT_MSIXCAP1_READMASK      0xffffffff
+#define VREG_HT_MSIXCAP1_CLEARMASK     0x00000000
+#define VREG_HT_MSIXCAP1       0x064
+#define VREG_HT_MSIXCAP1_ID    25
+
+#define VVAL_HT_MSIXCAP1_DEFAULT 0x600000      /* Reset by hreset: Res=
et value */
+/* Subfields of MsixCap1 */
+#define VREG_HT_MSIXCAP1_TBLOFFSET_MASK        0xfffffff8      /* Offs=
et to MSI-X Table [3..31] */
+#define VREG_HT_MSIXCAP1_TBLBIR_MASK   0x00000007      /* BAR Index fo=
r Table [0..2] */
+
+
+
+
+/* MSI-X Discovery And Configuration Capability Block (31..0) */
+#define VREG_HT_MSIXCAP2_MASK  0xffffffff
+#define VREG_HT_MSIXCAP2_ACCESSMODE    2
+#define VREG_HT_MSIXCAP2_HOSTPRIVILEGE         1
+#define VREG_HT_MSIXCAP2_RESERVEDMASK  0x00000000
+#define VREG_HT_MSIXCAP2_WRITEMASK     0x00000000
+#define VREG_HT_MSIXCAP2_READMASK      0xffffffff
+#define VREG_HT_MSIXCAP2_CLEARMASK     0x00000000
+#define VREG_HT_MSIXCAP2       0x068
+#define VREG_HT_MSIXCAP2_ID    26
+
+#define VVAL_HT_MSIXCAP2_DEFAULT 0x610000      /* Reset by hreset: Res=
et value */
+/* Subfields of MsixCap2 */
+#define VREG_HT_MSIXCAP2_PBAOFFSET_MASK        0xfffffff8      /* Offs=
et to MSI-X Table [3..31] */
+#define VREG_HT_MSIXCAP2_PBABIR_MASK   0x00000007      /* BAR Index fo=
r Table [0..2] */
+
+
+
+
+/* Device and Vendor ID (31..0) */
+#define VREG_HT_ID_1_MASK      0xffffffff
+#define VREG_HT_ID_1_ACCESSMODE        1
+#define VREG_HT_ID_1_HOSTPRIVILEGE     1
+#define VREG_HT_ID_1_RESERVEDMASK      0x00000000
+#define VREG_HT_ID_1_WRITEMASK         0x00000000
+#define VREG_HT_ID_1_READMASK  0xffffffff
+#define VREG_HT_ID_1_CLEARMASK         0x00000000
+#define VREG_HT_ID_1   0x100
+#define VREG_HT_ID_1_ID        64
+    /* Device Header */
+
+#define VVAL_HT_ID_1_DEFAULT 0x9fab7   /* Reset by hreset: Private Dev=
ice ID and Vendor ID */
+/* Subfields of ID_1 */
+#define VREG_HT_ID_1_DEVID_MASK        0xffff0000      /* Device ID =3D=
 0x0001 [16..31] */
+#define VREG_HT_ID_1_VENDORID_MASK     0x0000ffff      /* Vendor ID =3D=
 0xFAB7 [0..15] */
+
+
+
+
+/* Command and Status register (31..0) */
+#define VREG_HT_CMD_1_MASK     0xffffffff
+#define VREG_HT_CMD_1_ACCESSMODE       1
+#define VREG_HT_CMD_1_HOSTPRIVILEGE    1
+#define VREG_HT_CMD_1_RESERVEDMASK     0x00000000
+#define VREG_HT_CMD_1_WRITEMASK        0x00000000
+#define VREG_HT_CMD_1_READMASK         0xffffffff
+#define VREG_HT_CMD_1_CLEARMASK        0x00000000
+#define VREG_HT_CMD_1  0x104
+#define VREG_HT_CMD_1_ID       65
+
+#define VVAL_HT_CMD_1_DEFAULT 0x0      /* Reset by hreset: */
+
+
+/* Class Code and Revision ID (31..0) */
+#define VREG_HT_CLASSREV_1_MASK        0xffffffff
+#define VREG_HT_CLASSREV_1_ACCESSMODE  1
+#define VREG_HT_CLASSREV_1_HOSTPRIVILEGE       1
+#define VREG_HT_CLASSREV_1_RESERVEDMASK        0x00000000
+#define VREG_HT_CLASSREV_1_WRITEMASK   0x00000000
+#define VREG_HT_CLASSREV_1_READMASK    0xffffffff
+#define VREG_HT_CLASSREV_1_CLEARMASK   0x00000000
+#define VREG_HT_CLASSREV_1     0x108
+#define VREG_HT_CLASSREV_1_ID  66
+
+#define VVAL_HT_CLASSREV_1_DEFAULT 0x8800001   /* Reset by hreset: Har=
dwired */
+/* Subfields of ClassRev_1 */
+#define VREG_HT_CLASSREV_1_CLASS_MASK  0xffffff00      /* Class Code =3D=
 0x088000 [8..31] */
+#define VREG_HT_CLASSREV_1_REVID_MASK  0x000000ff      /* Revision ID =
=3D 0x01 [0..7] */
+
+
+
+
+/* Cache Line Size register - not implemented (31..0) */
+#define VREG_HT_CACHELSZ_1_MASK        0xffffffff
+#define VREG_HT_CACHELSZ_1_ACCESSMODE  1
+#define VREG_HT_CACHELSZ_1_HOSTPRIVILEGE       1
+#define VREG_HT_CACHELSZ_1_RESERVEDMASK        0x00000000
+#define VREG_HT_CACHELSZ_1_WRITEMASK   0x00000000
+#define VREG_HT_CACHELSZ_1_READMASK    0xffffffff
+#define VREG_HT_CACHELSZ_1_CLEARMASK   0x00000000
+#define VREG_HT_CACHELSZ_1     0x10c
+#define VREG_HT_CACHELSZ_1_ID  67
+
+#define VVAL_HT_CACHELSZ_1_DEFAULT 0x0         /* Reset by hreset: Def=
ault value */
+
+
+/* Hardwired to 0, No memory space (31..0) */
+#define VREG_HT_MBADDR_LO_1_MASK       0xffffffff
+#define VREG_HT_MBADDR_LO_1_ACCESSMODE         1
+#define VREG_HT_MBADDR_LO_1_HOSTPRIVILEGE      1
+#define VREG_HT_MBADDR_LO_1_RESERVEDMASK       0x00000000
+#define VREG_HT_MBADDR_LO_1_WRITEMASK  0x00000000
+#define VREG_HT_MBADDR_LO_1_READMASK   0xffffffff
+#define VREG_HT_MBADDR_LO_1_CLEARMASK  0x00000000
+#define VREG_HT_MBADDR_LO_1    0x110
+#define VREG_HT_MBADDR_LO_1_ID         68
+
+#define VVAL_HT_MBADDR_LO_1_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Interrupt Line - RW scratchpad register (15..0) */
+#define VREG_HT_INT_1_MASK     0x0000ffff
+#define VREG_HT_INT_1_ACCESSMODE       2
+#define VREG_HT_INT_1_HOSTPRIVILEGE    1
+#define VREG_HT_INT_1_RESERVEDMASK     0x00000000
+#define VREG_HT_INT_1_WRITEMASK        0x000000ff
+#define VREG_HT_INT_1_READMASK         0x0000ffff
+#define VREG_HT_INT_1_CLEARMASK        0x00000000
+#define VREG_HT_INT_1  0x13c
+#define VREG_HT_INT_1_ID       79
+
+#define VVAL_HT_INT_1_DEFAULT 0x200    /* Reset by hreset: Reset to 20=
0 */
+/* Subfields of Int_1 */
+#define VREG_HT_INT_1_PIN_MASK 0x0000ff00      /* Interrupt pin used b=
y Function [8..15] */
+#define VREG_HT_INT_1_LINE_MASK        0x000000ff      /* Interrupt Li=
ne assigned by Function BIOS [0..7] */
+
+
+
+
+/* Device and Vendor ID (31..0) */
+#define VREG_HT_ID_2_MASK      0xffffffff
+#define VREG_HT_ID_2_ACCESSMODE        1
+#define VREG_HT_ID_2_HOSTPRIVILEGE     1
+#define VREG_HT_ID_2_RESERVEDMASK      0x00000000
+#define VREG_HT_ID_2_WRITEMASK         0x00000000
+#define VREG_HT_ID_2_READMASK  0xffffffff
+#define VREG_HT_ID_2_CLEARMASK         0x00000000
+#define VREG_HT_ID_2   0x200
+#define VREG_HT_ID_2_ID        128
+    /* Device Header */
+
+#define VVAL_HT_ID_2_DEFAULT 0x9fab7   /* Reset by hreset: Private Dev=
ice ID and Vendor ID */
+/* Subfields of ID_2 */
+#define VREG_HT_ID_2_DEVID_MASK        0xffff0000      /* Device ID =3D=
 0x0001 [16..31] */
+#define VREG_HT_ID_2_VENDORID_MASK     0x0000ffff      /* Vendor ID =3D=
 0xFAB7 [0..15] */
+
+
+
+
+/* Command and Status register (31..0) */
+#define VREG_HT_CMD_2_MASK     0xffffffff
+#define VREG_HT_CMD_2_ACCESSMODE       1
+#define VREG_HT_CMD_2_HOSTPRIVILEGE    1
+#define VREG_HT_CMD_2_RESERVEDMASK     0x00000000
+#define VREG_HT_CMD_2_WRITEMASK        0x00000000
+#define VREG_HT_CMD_2_READMASK         0xffffffff
+#define VREG_HT_CMD_2_CLEARMASK        0x00000000
+#define VREG_HT_CMD_2  0x204
+#define VREG_HT_CMD_2_ID       129
+
+#define VVAL_HT_CMD_2_DEFAULT 0x0      /* Reset by hreset: */
+
+
+/* Class Code and Revision ID (31..0) */
+#define VREG_HT_CLASSREV_2_MASK        0xffffffff
+#define VREG_HT_CLASSREV_2_ACCESSMODE  1
+#define VREG_HT_CLASSREV_2_HOSTPRIVILEGE       1
+#define VREG_HT_CLASSREV_2_RESERVEDMASK        0x00000000
+#define VREG_HT_CLASSREV_2_WRITEMASK   0x00000000
+#define VREG_HT_CLASSREV_2_READMASK    0xffffffff
+#define VREG_HT_CLASSREV_2_CLEARMASK   0x00000000
+#define VREG_HT_CLASSREV_2     0x208
+#define VREG_HT_CLASSREV_2_ID  130
+
+#define VVAL_HT_CLASSREV_2_DEFAULT 0x8800001   /* Reset by hreset: Har=
dwired */
+/* Subfields of ClassRev_2 */
+#define VREG_HT_CLASSREV_2_CLASS_MASK  0xffffff00      /* Class Code =3D=
 0x088000 [8..31] */
+#define VREG_HT_CLASSREV_2_REVID_MASK  0x000000ff      /* Revision ID =
=3D 0x01 [0..7] */
+
+
+
+
+/* Cache Line Size register - not implemented (31..0) */
+#define VREG_HT_CACHELSZ_2_MASK        0xffffffff
+#define VREG_HT_CACHELSZ_2_ACCESSMODE  1
+#define VREG_HT_CACHELSZ_2_HOSTPRIVILEGE       1
+#define VREG_HT_CACHELSZ_2_RESERVEDMASK        0x00000000
+#define VREG_HT_CACHELSZ_2_WRITEMASK   0x00000000
+#define VREG_HT_CACHELSZ_2_READMASK    0xffffffff
+#define VREG_HT_CACHELSZ_2_CLEARMASK   0x00000000
+#define VREG_HT_CACHELSZ_2     0x20c
+#define VREG_HT_CACHELSZ_2_ID  131
+
+#define VVAL_HT_CACHELSZ_2_DEFAULT 0x0         /* Reset by hreset: Def=
ault value */
+
+
+/* Hardwired to 0, No memory space (31..0) */
+#define VREG_HT_MBADDR_LO_2_MASK       0xffffffff
+#define VREG_HT_MBADDR_LO_2_ACCESSMODE         1
+#define VREG_HT_MBADDR_LO_2_HOSTPRIVILEGE      1
+#define VREG_HT_MBADDR_LO_2_RESERVEDMASK       0x00000000
+#define VREG_HT_MBADDR_LO_2_WRITEMASK  0x00000000
+#define VREG_HT_MBADDR_LO_2_READMASK   0xffffffff
+#define VREG_HT_MBADDR_LO_2_CLEARMASK  0x00000000
+#define VREG_HT_MBADDR_LO_2    0x210
+#define VREG_HT_MBADDR_LO_2_ID         132
+
+#define VVAL_HT_MBADDR_LO_2_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Interrupt Line - RW scratchpad register (15..0) */
+#define VREG_HT_INT_2_MASK     0x0000ffff
+#define VREG_HT_INT_2_ACCESSMODE       2
+#define VREG_HT_INT_2_HOSTPRIVILEGE    1
+#define VREG_HT_INT_2_RESERVEDMASK     0x00000000
+#define VREG_HT_INT_2_WRITEMASK        0x000000ff
+#define VREG_HT_INT_2_READMASK         0x0000ffff
+#define VREG_HT_INT_2_CLEARMASK        0x00000000
+#define VREG_HT_INT_2  0x23c
+#define VREG_HT_INT_2_ID       143
+
+#define VVAL_HT_INT_2_DEFAULT 0x300    /* Reset by hreset: Reset to 30=
0 */
+/* Subfields of Int_2 */
+#define VREG_HT_INT_2_PIN_MASK 0x0000ff00      /* Interrupt pin used b=
y Function [8..15] */
+#define VREG_HT_INT_2_LINE_MASK        0x000000ff      /* Interrupt Li=
ne assigned by Function BIOS [0..7] */
+
+
+
+
+/* Device and Vendor ID (31..0) */
+#define VREG_HT_ID_3_MASK      0xffffffff
+#define VREG_HT_ID_3_ACCESSMODE        1
+#define VREG_HT_ID_3_HOSTPRIVILEGE     1
+#define VREG_HT_ID_3_RESERVEDMASK      0x00000000
+#define VREG_HT_ID_3_WRITEMASK         0x00000000
+#define VREG_HT_ID_3_READMASK  0xffffffff
+#define VREG_HT_ID_3_CLEARMASK         0x00000000
+#define VREG_HT_ID_3   0x300
+#define VREG_HT_ID_3_ID        192
+    /* Device Header */
+
+#define VVAL_HT_ID_3_DEFAULT 0x9fab7   /* Reset by hreset: Private Dev=
ice ID and Vendor ID */
+/* Subfields of ID_3 */
+#define VREG_HT_ID_3_DEVID_MASK        0xffff0000      /* Device ID =3D=
 0x0001 [16..31] */
+#define VREG_HT_ID_3_VENDORID_MASK     0x0000ffff      /* Vendor ID =3D=
 0xFAB7 [0..15] */
+
+
+
+
+/* Command and Status register (31..0) */
+#define VREG_HT_CMD_3_MASK     0xffffffff
+#define VREG_HT_CMD_3_ACCESSMODE       1
+#define VREG_HT_CMD_3_HOSTPRIVILEGE    1
+#define VREG_HT_CMD_3_RESERVEDMASK     0x00000000
+#define VREG_HT_CMD_3_WRITEMASK        0x00000000
+#define VREG_HT_CMD_3_READMASK         0xffffffff
+#define VREG_HT_CMD_3_CLEARMASK        0x00000000
+#define VREG_HT_CMD_3  0x304
+#define VREG_HT_CMD_3_ID       193
+
+#define VVAL_HT_CMD_3_DEFAULT 0x0      /* Reset by hreset: */
+
+
+/* Class Code and Revision ID (31..0) */
+#define VREG_HT_CLASSREV_3_MASK        0xffffffff
+#define VREG_HT_CLASSREV_3_ACCESSMODE  1
+#define VREG_HT_CLASSREV_3_HOSTPRIVILEGE       1
+#define VREG_HT_CLASSREV_3_RESERVEDMASK        0x00000000
+#define VREG_HT_CLASSREV_3_WRITEMASK   0x00000000
+#define VREG_HT_CLASSREV_3_READMASK    0xffffffff
+#define VREG_HT_CLASSREV_3_CLEARMASK   0x00000000
+#define VREG_HT_CLASSREV_3     0x308
+#define VREG_HT_CLASSREV_3_ID  194
+
+#define VVAL_HT_CLASSREV_3_DEFAULT 0x8800001   /* Reset by hreset: Har=
dwired */
+/* Subfields of ClassRev_3 */
+#define VREG_HT_CLASSREV_3_CLASS_MASK  0xffffff00      /* Class Code =3D=
 0x088000 [8..31] */
+#define VREG_HT_CLASSREV_3_REVID_MASK  0x000000ff      /* Revision ID =
=3D 0x01 [0..7] */
+
+
+
+
+/* Cache Line Size register - not implemented (31..0) */
+#define VREG_HT_CACHELSZ_3_MASK        0xffffffff
+#define VREG_HT_CACHELSZ_3_ACCESSMODE  1
+#define VREG_HT_CACHELSZ_3_HOSTPRIVILEGE       1
+#define VREG_HT_CACHELSZ_3_RESERVEDMASK        0x00000000
+#define VREG_HT_CACHELSZ_3_WRITEMASK   0x00000000
+#define VREG_HT_CACHELSZ_3_READMASK    0xffffffff
+#define VREG_HT_CACHELSZ_3_CLEARMASK   0x00000000
+#define VREG_HT_CACHELSZ_3     0x30c
+#define VREG_HT_CACHELSZ_3_ID  195
+
+#define VVAL_HT_CACHELSZ_3_DEFAULT 0x0         /* Reset by hreset: Def=
ault value */
+
+
+/* Hardwired to 0, No memory space (31..0) */
+#define VREG_HT_MBADDR_LO_3_MASK       0xffffffff
+#define VREG_HT_MBADDR_LO_3_ACCESSMODE         1
+#define VREG_HT_MBADDR_LO_3_HOSTPRIVILEGE      1
+#define VREG_HT_MBADDR_LO_3_RESERVEDMASK       0x00000000
+#define VREG_HT_MBADDR_LO_3_WRITEMASK  0x00000000
+#define VREG_HT_MBADDR_LO_3_READMASK   0xffffffff
+#define VREG_HT_MBADDR_LO_3_CLEARMASK  0x00000000
+#define VREG_HT_MBADDR_LO_3    0x310
+#define VREG_HT_MBADDR_LO_3_ID         196
+
+#define VVAL_HT_MBADDR_LO_3_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Interrupt Line - RW scratchpad register (15..0) */
+#define VREG_HT_INT_3_MASK     0x0000ffff
+#define VREG_HT_INT_3_ACCESSMODE       2
+#define VREG_HT_INT_3_HOSTPRIVILEGE    1
+#define VREG_HT_INT_3_RESERVEDMASK     0x00000000
+#define VREG_HT_INT_3_WRITEMASK        0x000000ff
+#define VREG_HT_INT_3_READMASK         0x0000ffff
+#define VREG_HT_INT_3_CLEARMASK        0x00000000
+#define VREG_HT_INT_3  0x33c
+#define VREG_HT_INT_3_ID       207
+
+#define VVAL_HT_INT_3_DEFAULT 0x400    /* Reset by hreset: Reset to 40=
0 */
+/* Subfields of Int_3 */
+#define VREG_HT_INT_3_PIN_MASK 0x0000ff00      /* Interrupt pin used b=
y Function [8..15] */
+#define VREG_HT_INT_3_LINE_MASK        0x000000ff      /* Interrupt Li=
ne assigned by Function BIOS [0..7] */
+
+
+
+
+/* Collection of internal SRAM parity error (31..0) */
+#define VREG_HT_PARERR_MASK    0xffffffff
+#define VREG_HT_PARERR_ACCESSMODE      3
+#define VREG_HT_PARERR_HOSTPRIVILEGE   1
+#define VREG_HT_PARERR_RESERVEDMASK    0x00000000
+#define VREG_HT_PARERR_WRITEMASK       0xffffffff
+#define VREG_HT_PARERR_READMASK        0xffffffff
+#define VREG_HT_PARERR_CLEARMASK       0xffffffff
+#define VREG_HT_PARERR         0x700
+#define VREG_HT_PARERR_ID      448
+
+#define VVAL_HT_PARERR_DEFAULT 0x0     /* Reset by hreset: Reset to 0 =
*/
+
+#endif /* _VIOC_HT_REGISTERS_H_ */
diff -puN /dev/null drivers/net/vioc/f7/vioc_hw_registers.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vioc_hw_registers.h
@@ -0,0 +1,160 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+
+#ifndef _VIOC_HW_REGISTERS_H_
+#define _VIOC_HW_REGISTERS_H_
+
+/* Constructs a relative address, independent of PCI base address */
+#define GETRELADDR(module, vnic, reg)                                 =
 \
+       (u64) (((module & 0xFF) << 16) | ((vnic & 0xF) << 12) |  (reg &=
 0xFFC))
+
+#include <asm/io.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+#define        VIOC_RESERVED_00        0x00
+#define        VIOC_BMC        0x01 /* BMC Interface Module */
+#define        VIOC_SIM        0x02 /* SIM Interface Module */
+#define        VIOC_RESERVED_03        0x03
+#define        VIOC_HT         0x04 /* HT Target Module */
+#define        VIOC_TCAM       0x05 /* TCAM read/write interface Modul=
e */
+#define        VIOC_DRAM       0x06 /* DRAM Interface Module */
+#define        VIOC_C6RX       0x07 /* CSIX Receive Module */
+#define        VIOC_C6FPU      0x08 /* CSIX Frame Parser Unit Module *=
/
+#define        VIOC_F7LE       0x09 /* F7 Lookup Engine Module */
+
+#define        VIOC_RESERVED_0A        0x0A
+#define        VIOC_RESERVED_0B        0x0B
+#define        VIOC_RESERVED_0C        0x0C
+#define        VIOC_RESERVED_0D        0x0D
+#define        VIOC_RESERVED_0E        0x0E
+#define        VIOC_RESERVED_0F        0x0F
+#define        VIOC_VING       0x10 /* VIOC Ingress Module */
+#define        VIOC_IHCU       0x11 /* Ingress Host Control Unit Modul=
e */
+#define        VIOC_PERFMON    0x12 /* Performance Counter and Statist=
ics */
+#define        VIOC_RESERVED_13        0x13
+#define        VIOC_RESERVED_14        0x14
+#define        VIOC_APIC       0x15 /* IO APIC Configuration Registers=
 */
+#define        VIOC_RESERVED_16        0x16
+#define        VIOC_RESERVED_17        0x17
+#define        VIOC_RESERVED_18        0x18
+#define        VIOC_RESERVED_19        0x19
+#define        VIOC_RESERVED_1A        0x1A
+#define        VIOC_RESERVED_1B        0x1B
+#define        VIOC_RESERVED_1C        0x1C
+#define        VIOC_RESERVED_1D        0x1D
+#define        VIOC_RESERVED_1E        0x1E
+#define        VIOC_RESERVED_1F        0x1F
+#define        VIOC_VENG       0x20 /* VIOC Egress Module */
+#define        VIOC_RESERVED_21        0x21
+#define        VIOC_RESERVED_22        0x22
+#define        VIOC_RESERVED_23        0x23
+#define        VIOC_RESERVED_24        0x24
+#define        VIOC_RESERVED_25        0x25
+#define        VIOC_RESERVED_26        0x26
+#define        VIOC_RESERVED_27        0x27
+#define        VIOC_RESERVED_28        0x28
+#define        VIOC_RESERVED_29        0x29
+#define        VIOC_RESERVED_2A        0x2A
+#define        VIOC_RESERVED_2B        0x2B
+#define        VIOC_RESERVED_2C        0x2C
+#define        VIOC_RESERVED_2D        0x2D
+#define        VIOC_RESERVED_2E        0x2E
+#define        VIOC_RESERVED_2F        0x2F
+#define        VIOC_VARB       0x30 /* VIOC Arbiter Module */
+#define        VIOC_RESERVED_31        0x31
+#define        VIOC_RESERVED_32        0x32
+#define        VIOC_RESERVED_33        0x33
+#define        VIOC_RESERVED_34        0x34
+#define        VIOC_RESERVED_35        0x35
+#define        VIOC_RESERVED_36        0x36
+#define        VIOC_RESERVED_37        0x37
+#define        VIOC_RESERVED_38        0x38
+#define        VIOC_RESERVED_39        0x39
+#define        VIOC_RESERVED_3A        0x3A
+#define        VIOC_RESERVED_3B        0x3B
+#define        VIOC_RESERVED_3C        0x3C
+#define        VIOC_RESERVED_3D        0x3D
+#define        VIOC_RESERVED_3E        0x3E
+#define        VIOC_RESERVED_3F        0x3F
+#define        VIOC_F7MP       0x40 /* F7MP Control Module */
+#define        VIOC_RESERVED_41        0x41
+#define        VIOC_RESERVED_42        0x42
+#define        VIOC_RESERVED_43        0x43
+#define        VIOC_RESERVED_44        0x44
+#define        VIOC_RESERVED_45        0x45
+#define        VIOC_RESERVED_46        0x46
+#define        VIOC_RESERVED_47        0x47
+#define        VIOC_RESERVED_48        0x48
+#define        VIOC_RESERVED_49        0x49
+#define        VIOC_RESERVED_4A        0x4A
+#define        VIOC_RESERVED_4B        0x4B
+#define        VIOC_RESERVED_4C        0x4C
+#define        VIOC_RESERVED_4D        0x4D
+#define        VIOC_RESERVED_4E        0x4E
+#define        VIOC_RESERVED_4F        0x4F
+#define        VIOC_RESERVED_50        0x50
+#define        VIOC_RESERVED_51        0x51
+#define        VIOC_RESERVED_52        0x52
+#define        VIOC_RESERVED_53        0x53
+#define        VIOC_RESERVED_54        0x54
+#define        VIOC_RESERVED_55        0x55
+#define        VIOC_RESERVED_56        0x56
+#define        VIOC_RESERVED_57        0x57
+#define        VIOC_RESERVED_58        0x58
+#define        VIOC_RESERVED_59        0x59
+#define        VIOC_RESERVED_5A        0x5A
+#define        VIOC_RESERVED_5B        0x5B
+#define        VIOC_RESERVED_5C        0x5C
+#define        VIOC_RESERVED_5D        0x5D
+#define        VIOC_RESERVED_5E        0x5E
+#define        VIOC_RESERVED_5F        0x5F
+#define        VIOC_MSIXTBL    0x60 /* MSIX Table Structure */
+#define        VIOC_MSIXPBA    0x61 /* MSIX Pending Bit Array Structur=
e */
+
+
+
+#define VIOC_MAX_VNICS 16
+#define VIOC_MAX_MODULES 98
+#if !defined(VIOC_MAX_VIOCS) // can be overridden
+#define VIOC_MAX_VIOCS 4
+#endif /* VIOC_MAX_VIOS */
+#define VIOC_MAX_VNIC_REGISTERS 1023
+#ifdef __cplusplus
+}
+#endif
+
+#include "vioc_ihcu_registers.h"
+#include "vioc_bmc_registers.h"
+#include "vioc_ht_registers.h"
+#include "vioc_msi_registers.h"
+#include "vioc_le_registers.h"
+#include "vioc_ving_registers.h"
+#include "vioc_veng_registers.h"
+
+#endif /* _VIOC_HW_REGISTERS_H_ */
diff -puN /dev/null drivers/net/vioc/f7/vioc_ihcu_registers.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vioc_ihcu_registers.h
@@ -0,0 +1,550 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+
+#ifndef _VIOC_IHCU_REGISTERS_H_
+#define _VIOC_IHCU_REGISTERS_H_
+
+/* Module IHCU:17 */
+
+/* Collection of internal SRAM parity error (31..0) */
+#define VREG_IHCU_PARERR_MASK  0xffffffff
+#define VREG_IHCU_PARERR_ACCESSMODE    2
+#define VREG_IHCU_PARERR_HOSTPRIVILEGE         1
+#define VREG_IHCU_PARERR_RESERVEDMASK  0xfffff800
+#define VREG_IHCU_PARERR_WRITEMASK     0x000007ff
+#define VREG_IHCU_PARERR_READMASK      0x000007ff
+#define VREG_IHCU_PARERR_CLEARMASK     0x000007ff
+#define VREG_IHCU_PARERR       0x100
+#define VREG_IHCU_PARERR_ID    64
+
+#define VVAL_IHCU_PARERR_DEFAULT 0x0   /* Reset by sreset: Reset to 0 =
*/
+/* Subfields of ParErr */
+#define VREG_IHCU_PARERR_RESV0_MASK    0xfffff800      /* Unused [11..=
31] */
+#define VREG_IHCU_PARERR_MCTHREAD0_MASK        0x00000400      /* Bank=
 0 of Multicast Thread RAM [10..10] */
+#define VREG_IHCU_PARERR_MCTHREAD1_MASK        0x00000200      /* Bank=
 0 of Multicast Thread RAM [9..9] */
+#define VREG_IHCU_PARERR_RXCOFF_MASK   0x00000100      /* RxC Offset R=
AM [8..8] */
+#define VREG_IHCU_PARERR_RXCPTR_MASK   0x00000080      /* RxC Current =
Pointer [7..7] */
+#define VREG_IHCU_PARERR_RXDQMAP_MASK  0x00000040      /* RxD to VNIC =
Q reverse map RAM [6..6] */
+#define VREG_IHCU_PARERR_VNICQRXD_MASK 0x00000020      /* VNIC Q to Rx=
D map RAM [5..5] */
+#define VREG_IHCU_PARERR_RXDBUFLEN_MASK        0x00000010      /* RxD =
Buffer Length RAM [4..4] */
+#define VREG_IHCU_PARERR_VNICQRXC_MASK 0x00000008      /* VNIC Q to Rx=
C map RAM [3..3] */
+#define VREG_IHCU_PARERR_RXCBALO_MASK  0x00000004      /* RxC Base Add=
ress SRAM [2..2] */
+#define VREG_IHCU_PARERR_RXCBAHI_MASK  0x00000002      /* RxC Base Add=
ress SRAM [1..1] */
+#define VREG_IHCU_PARERR_THMEM_MASK    0x00000001      /* Thread state=
 Memory RAM [0..0] */
+
+
+
+
+/* RxD Queue Definition - Base address (31..0) */
+#define VREG_IHCU_RXD_W0_MASK  0xffffffff
+#define VREG_IHCU_RXD_W0_ACCESSMODE    2
+#define VREG_IHCU_RXD_W0_HOSTPRIVILEGE         1
+#define VREG_IHCU_RXD_W0_RESERVEDMASK  0x0000003f
+#define VREG_IHCU_RXD_W0_WRITEMASK     0xffffffc0
+#define VREG_IHCU_RXD_W0_READMASK      0xffffffc0
+#define VREG_IHCU_RXD_W0_CLEARMASK     0x00000000
+#define VREG_IHCU_RXD_W0       0x200
+#define VREG_IHCU_RXD_W0_ID    128
+
+/* Subfields of RxD_W0 */
+#define VREG_IHCU_RXD_W0_BA_LO_MASK    0xffffffc0      /* Bits 31:6 of=
 the RxD ring base address [6..31] */
+#define VREG_IHCU_RXD_W0_RSV_MASK      0x0000003f      /* Reserved [0.=
=2E5] */
+
+
+#define        VREG_IHCU_RXD_W0_R0     0x200
+#define        VREG_IHCU_RXD_W0_R1     0x210
+#define        VREG_IHCU_RXD_W0_R2     0x220
+#define        VREG_IHCU_RXD_W0_R3     0x230
+#define        VREG_IHCU_RXD_W0_R4     0x240
+#define        VREG_IHCU_RXD_W0_R5     0x250
+#define        VREG_IHCU_RXD_W0_R6     0x260
+#define        VREG_IHCU_RXD_W0_R7     0x270
+#define        VREG_IHCU_RXD_W0_R8     0x280
+#define        VREG_IHCU_RXD_W0_R9     0x290
+#define        VREG_IHCU_RXD_W0_R10    0x2A0
+#define        VREG_IHCU_RXD_W0_R11    0x2B0
+#define        VREG_IHCU_RXD_W0_R12    0x2C0
+#define        VREG_IHCU_RXD_W0_R13    0x2D0
+#define        VREG_IHCU_RXD_W0_R14    0x2E0
+#define        VREG_IHCU_RXD_W0_R15    0x2F0
+
+
+/* RxD Queue Definition (31..0) */
+#define VREG_IHCU_RXD_W1_MASK  0xffffffff
+#define VREG_IHCU_RXD_W1_ACCESSMODE    2
+#define VREG_IHCU_RXD_W1_HOSTPRIVILEGE         1
+#define VREG_IHCU_RXD_W1_RESERVEDMASK  0xff000000
+#define VREG_IHCU_RXD_W1_WRITEMASK     0x00ffffff
+#define VREG_IHCU_RXD_W1_READMASK      0x00ffffff
+#define VREG_IHCU_RXD_W1_CLEARMASK     0x00000000
+#define VREG_IHCU_RXD_W1       0x204
+#define VREG_IHCU_RXD_W1_ID    129
+
+/* Subfields of RxD_W1 */
+#define VREG_IHCU_RXD_W1_RSV1_MASK     0xff000000      /* Reserved [24=
=2E.31] */
+#define VREG_IHCU_RXD_W1_SIZE_MASK     0x00ffff00      /* Number of de=
scriptors in the queue [8..23] */
+#define VREG_IHCU_RXD_W1_BA_HI_MASK    0x000000ff      /* Bits 39:32 o=
f base address [0..7] */
+
+
+#define        VREG_IHCU_RXD_W1_R0     0x204
+#define        VREG_IHCU_RXD_W1_R1     0x214
+#define        VREG_IHCU_RXD_W1_R2     0x224
+#define        VREG_IHCU_RXD_W1_R3     0x234
+#define        VREG_IHCU_RXD_W1_R4     0x244
+#define        VREG_IHCU_RXD_W1_R5     0x254
+#define        VREG_IHCU_RXD_W1_R6     0x264
+#define        VREG_IHCU_RXD_W1_R7     0x274
+#define        VREG_IHCU_RXD_W1_R8     0x284
+#define        VREG_IHCU_RXD_W1_R9     0x294
+#define        VREG_IHCU_RXD_W1_R10    0x2A4
+#define        VREG_IHCU_RXD_W1_R11    0x2B4
+#define        VREG_IHCU_RXD_W1_R12    0x2C4
+#define        VREG_IHCU_RXD_W1_R13    0x2D4
+#define        VREG_IHCU_RXD_W1_R14    0x2E4
+#define        VREG_IHCU_RXD_W1_R15    0x2F4
+
+
+/* RxD Queue Definition (31..0) */
+#define VREG_IHCU_RXD_W2_MASK  0xffffffff
+#define VREG_IHCU_RXD_W2_ACCESSMODE    2
+#define VREG_IHCU_RXD_W2_HOSTPRIVILEGE         1
+#define VREG_IHCU_RXD_W2_RESERVEDMASK  0xffffc000
+#define VREG_IHCU_RXD_W2_WRITEMASK     0x00003fff
+#define VREG_IHCU_RXD_W2_READMASK      0x00003fff
+#define VREG_IHCU_RXD_W2_CLEARMASK     0x00000000
+#define VREG_IHCU_RXD_W2       0x208
+#define VREG_IHCU_RXD_W2_ID    130
+
+/* Subfields of RxD_W2 */
+#define VREG_IHCU_RXD_W2_RSV1_MASK     0xffff0000      /* Reserved [16=
=2E.31] */
+#define VREG_IHCU_RXD_W2_RSV2_MASK     0x0000c000      /* Reserved [14=
=2E.15] */
+#define VREG_IHCU_RXD_W2_BUFSIZE_MASK  0x00003fff      /* Size of queu=
ed buffers, in bytes [0..13] */
+
+
+#define        VREG_IHCU_RXD_W2_R0     0x208
+#define        VREG_IHCU_RXD_W2_R1     0x218
+#define        VREG_IHCU_RXD_W2_R2     0x228
+#define        VREG_IHCU_RXD_W2_R3     0x238
+#define        VREG_IHCU_RXD_W2_R4     0x248
+#define        VREG_IHCU_RXD_W2_R5     0x258
+#define        VREG_IHCU_RXD_W2_R6     0x268
+#define        VREG_IHCU_RXD_W2_R7     0x278
+#define        VREG_IHCU_RXD_W2_R8     0x288
+#define        VREG_IHCU_RXD_W2_R9     0x298
+#define        VREG_IHCU_RXD_W2_R10    0x2A8
+#define        VREG_IHCU_RXD_W2_R11    0x2B8
+#define        VREG_IHCU_RXD_W2_R12    0x2C8
+#define        VREG_IHCU_RXD_W2_R13    0x2D8
+#define        VREG_IHCU_RXD_W2_R14    0x2E8
+#define        VREG_IHCU_RXD_W2_R15    0x2F8
+
+
+/* RxD Queue Status (31..0) */
+#define VREG_IHCU_RXD_W3_MASK  0xffffffff
+#define VREG_IHCU_RXD_W3_ACCESSMODE    2
+#define VREG_IHCU_RXD_W3_HOSTPRIVILEGE         1
+#define VREG_IHCU_RXD_W3_RESERVEDMASK  0x7fffc000
+#define VREG_IHCU_RXD_W3_WRITEMASK     0x80000000
+#define VREG_IHCU_RXD_W3_READMASK      0x80003fff
+#define VREG_IHCU_RXD_W3_CLEARMASK     0x00000000
+#define VREG_IHCU_RXD_W3       0x20c
+#define VREG_IHCU_RXD_W3_ID    131
+    /* Any packets arriving to a Paused RxD will be dropped */
+
+/* Subfields of RxD_W3 */
+#define VREG_IHCU_RXD_W3_PAUSEREQ_MASK 0x80000000      /* Temporarily =
stop enqeueing on this RxD [31..31] */
+#define VREG_IHCU_RXD_W3_RSV1_MASK     0x7fffc000      /* Reserved [14=
=2E.30] */
+#define VREG_IHCU_RXD_W3_CURRRDPTR_MASK        0x00003fff      /* Offs=
et in RxD of NEXT descriptor to be used [0..13] */
+
+
+#define        VREG_IHCU_RXD_W3_R0     0x20C
+#define        VREG_IHCU_RXD_W3_R1     0x21C
+#define        VREG_IHCU_RXD_W3_R2     0x22C
+#define        VREG_IHCU_RXD_W3_R3     0x23C
+#define        VREG_IHCU_RXD_W3_R4     0x24C
+#define        VREG_IHCU_RXD_W3_R5     0x25C
+#define        VREG_IHCU_RXD_W3_R6     0x26C
+#define        VREG_IHCU_RXD_W3_R7     0x27C
+#define        VREG_IHCU_RXD_W3_R8     0x28C
+#define        VREG_IHCU_RXD_W3_R9     0x29C
+#define        VREG_IHCU_RXD_W3_R10    0x2AC
+#define        VREG_IHCU_RXD_W3_R11    0x2BC
+#define        VREG_IHCU_RXD_W3_R12    0x2CC
+#define        VREG_IHCU_RXD_W3_R13    0x2DC
+#define        VREG_IHCU_RXD_W3_R14    0x2EC
+#define        VREG_IHCU_RXD_W3_R15    0x2FC
+
+
+/* RxC Queue Definition - Base address (31..0) */
+#define VREG_IHCU_RXC_LO_MASK  0xffffffff
+#define VREG_IHCU_RXC_LO_ACCESSMODE    2
+#define VREG_IHCU_RXC_LO_HOSTPRIVILEGE         1
+#define VREG_IHCU_RXC_LO_RESERVEDMASK  0x0000003f
+#define VREG_IHCU_RXC_LO_WRITEMASK     0xffffffc0
+#define VREG_IHCU_RXC_LO_READMASK      0xffffffc0
+#define VREG_IHCU_RXC_LO_CLEARMASK     0x00000000
+#define VREG_IHCU_RXC_LO       0x400
+#define VREG_IHCU_RXC_LO_ID    256
+
+/* Subfields of RxC_Lo */
+#define VREG_IHCU_RXC_LO_BA_LO_MASK    0xffffffc0      /* Bits 31:6 of=
 base address [6..31] */
+#define VREG_IHCU_RXC_LO_RSV_MASK      0x0000003f      /* Reserved [0.=
=2E5] */
+
+
+#define        VREG_IHCU_RXC_LO_R0     0x400
+#define        VREG_IHCU_RXC_LO_R1     0x410
+#define        VREG_IHCU_RXC_LO_R2     0x420
+#define        VREG_IHCU_RXC_LO_R3     0x430
+#define        VREG_IHCU_RXC_LO_R4     0x440
+#define        VREG_IHCU_RXC_LO_R5     0x450
+#define        VREG_IHCU_RXC_LO_R6     0x460
+#define        VREG_IHCU_RXC_LO_R7     0x470
+#define        VREG_IHCU_RXC_LO_R8     0x480
+#define        VREG_IHCU_RXC_LO_R9     0x490
+#define        VREG_IHCU_RXC_LO_R10    0x4A0
+#define        VREG_IHCU_RXC_LO_R11    0x4B0
+#define        VREG_IHCU_RXC_LO_R12    0x4C0
+#define        VREG_IHCU_RXC_LO_R13    0x4D0
+#define        VREG_IHCU_RXC_LO_R14    0x4E0
+#define        VREG_IHCU_RXC_LO_R15    0x4F0
+
+
+/* RxC Queue Definition (31..0) */
+#define VREG_IHCU_RXC_HI_MASK  0xffffffff
+#define VREG_IHCU_RXC_HI_ACCESSMODE    2
+#define VREG_IHCU_RXC_HI_HOSTPRIVILEGE         1
+#define VREG_IHCU_RXC_HI_RESERVEDMASK  0xff000000
+#define VREG_IHCU_RXC_HI_WRITEMASK     0x00ffffff
+#define VREG_IHCU_RXC_HI_READMASK      0x00ffffff
+#define VREG_IHCU_RXC_HI_CLEARMASK     0x00000000
+#define VREG_IHCU_RXC_HI       0x404
+#define VREG_IHCU_RXC_HI_ID    257
+
+/* Subfields of RxC_Hi */
+#define VREG_IHCU_RXC_HI_RSV1_MASK     0xff000000      /* Reserved [24=
=2E.31] */
+#define VREG_IHCU_RXC_HI_SIZE_MASK     0x00ffff00      /* Number of de=
scriptors in the queue [8..23] */
+#define VREG_IHCU_RXC_HI_BA_HI_MASK    0x000000ff      /* Bits 39:32 o=
f base address [0..7] */
+
+
+#define        VREG_IHCU_RXC_HI_R0     0x404
+#define        VREG_IHCU_RXC_HI_R1     0x414
+#define        VREG_IHCU_RXC_HI_R2     0x424
+#define        VREG_IHCU_RXC_HI_R3     0x434
+#define        VREG_IHCU_RXC_HI_R4     0x444
+#define        VREG_IHCU_RXC_HI_R5     0x454
+#define        VREG_IHCU_RXC_HI_R6     0x464
+#define        VREG_IHCU_RXC_HI_R7     0x474
+#define        VREG_IHCU_RXC_HI_R8     0x484
+#define        VREG_IHCU_RXC_HI_R9     0x494
+#define        VREG_IHCU_RXC_HI_R10    0x4A4
+#define        VREG_IHCU_RXC_HI_R11    0x4B4
+#define        VREG_IHCU_RXC_HI_R12    0x4C4
+#define        VREG_IHCU_RXC_HI_R13    0x4D4
+#define        VREG_IHCU_RXC_HI_R14    0x4E4
+#define        VREG_IHCU_RXC_HI_R15    0x4F4
+
+
+/* RxC Queue Definition - Interrupt (3..0) */
+#define VREG_IHCU_RXC_INT_MASK         0x0000000f
+#define VREG_IHCU_RXC_INT_ACCESSMODE   2
+#define VREG_IHCU_RXC_INT_HOSTPRIVILEGE        1
+#define VREG_IHCU_RXC_INT_RESERVEDMASK         0x00000000
+#define VREG_IHCU_RXC_INT_WRITEMASK    0x0000000f
+#define VREG_IHCU_RXC_INT_READMASK     0x0000000f
+#define VREG_IHCU_RXC_INT_CLEARMASK    0x00000000
+#define VREG_IHCU_RXC_INT      0x408
+#define VREG_IHCU_RXC_INT_ID   258
+    /* RxC_Int specifies which interrupt will get sent for this comple=
tion queue */
+
+#define        VREG_IHCU_RXC_INT_R0    0x408
+#define        VREG_IHCU_RXC_INT_R1    0x418
+#define        VREG_IHCU_RXC_INT_R2    0x428
+#define        VREG_IHCU_RXC_INT_R3    0x438
+#define        VREG_IHCU_RXC_INT_R4    0x448
+#define        VREG_IHCU_RXC_INT_R5    0x458
+#define        VREG_IHCU_RXC_INT_R6    0x468
+#define        VREG_IHCU_RXC_INT_R7    0x478
+#define        VREG_IHCU_RXC_INT_R8    0x488
+#define        VREG_IHCU_RXC_INT_R9    0x498
+#define        VREG_IHCU_RXC_INT_R10   0x4A8
+#define        VREG_IHCU_RXC_INT_R11   0x4B8
+#define        VREG_IHCU_RXC_INT_R12   0x4C8
+#define        VREG_IHCU_RXC_INT_R13   0x4D8
+#define        VREG_IHCU_RXC_INT_R14   0x4E8
+#define        VREG_IHCU_RXC_INT_R15   0x4F8
+
+
+/* Minimum time to wait between checking RxD queue state (12..0) */
+#define VREG_IHCU_SLEEPTIME_MASK       0x00001fff
+#define VREG_IHCU_SLEEPTIME_ACCESSMODE         2
+#define VREG_IHCU_SLEEPTIME_HOSTPRIVILEGE      1
+#define VREG_IHCU_SLEEPTIME_RESERVEDMASK       0x00000000
+#define VREG_IHCU_SLEEPTIME_WRITEMASK  0x00001fff
+#define VREG_IHCU_SLEEPTIME_READMASK   0x00001fff
+#define VREG_IHCU_SLEEPTIME_CLEARMASK  0x00000000
+#define VREG_IHCU_SLEEPTIME    0x500
+#define VREG_IHCU_SLEEPTIME_ID         320
+    /*
+     * When an RxD queue runs out of buffers the VIOC goes to sleep on=
 that queue.
+     * When a new SOP cell arrives the VIOC will check to see if new b=
uffers
+     * have been posted. If another cell arrives within the interval
+     * indicated by SleepTime, the VIOC will just drop the cell.
+     * SleepTime is specified in unit of cell time.
+     */
+
+#define VVAL_IHCU_SLEEPTIME_DEFAULT 0x1e       /* Reset by sreset: Res=
et to 30 */
+
+
+/* Addr[31:6] for Interrupt Status Block Write (31..0) */
+#define VREG_IHCU_INTRSTATADDRLO_MASK  0xffffffff
+#define VREG_IHCU_INTRSTATADDRLO_ACCESSMODE    2
+#define VREG_IHCU_INTRSTATADDRLO_HOSTPRIVILEGE         1
+#define VREG_IHCU_INTRSTATADDRLO_RESERVEDMASK  0x00000000
+#define VREG_IHCU_INTRSTATADDRLO_WRITEMASK     0xffffffff
+#define VREG_IHCU_INTRSTATADDRLO_READMASK      0xffffffff
+#define VREG_IHCU_INTRSTATADDRLO_CLEARMASK     0x00000000
+#define VREG_IHCU_INTRSTATADDRLO       0x508
+#define VREG_IHCU_INTRSTATADDRLO_ID    322
+
+#define VVAL_IHCU_INTRSTATADDRLO_DEFAULT 0x0   /* Reset by sreset: Res=
et to 0 */
+
+
+/* Addr[39:32] for Interrupt Status Block Write (7..0) */
+#define VREG_IHCU_INTRSTATADDRHI_MASK  0x000000ff
+#define VREG_IHCU_INTRSTATADDRHI_ACCESSMODE    2
+#define VREG_IHCU_INTRSTATADDRHI_HOSTPRIVILEGE         1
+#define VREG_IHCU_INTRSTATADDRHI_RESERVEDMASK  0x00000000
+#define VREG_IHCU_INTRSTATADDRHI_WRITEMASK     0x000000ff
+#define VREG_IHCU_INTRSTATADDRHI_READMASK      0x000000ff
+#define VREG_IHCU_INTRSTATADDRHI_CLEARMASK     0x00000000
+#define VREG_IHCU_INTRSTATADDRHI       0x50c
+#define VREG_IHCU_INTRSTATADDRHI_ID    323
+
+#define VVAL_IHCU_INTRSTATADDRHI_DEFAULT 0x0   /* Reset by sreset: Res=
et to 0 */
+
+
+/* Enable bits for RxD Queues (15..0) */
+#define VREG_IHCU_RXDQEN_MASK  0x0000ffff
+#define VREG_IHCU_RXDQEN_ACCESSMODE    2
+#define VREG_IHCU_RXDQEN_HOSTPRIVILEGE         1
+#define VREG_IHCU_RXDQEN_RESERVEDMASK  0x00000000
+#define VREG_IHCU_RXDQEN_WRITEMASK     0x0000ffff
+#define VREG_IHCU_RXDQEN_READMASK      0x0000ffff
+#define VREG_IHCU_RXDQEN_CLEARMASK     0x00000000
+#define VREG_IHCU_RXDQEN       0x510
+#define VREG_IHCU_RXDQEN_ID    324
+
+#define VVAL_IHCU_RXDQEN_DEFAULT 0x0   /* Reset by sreset: Reset to 0 =
*/
+/* Subfields of RxDQEn */
+#define VREG_IHCU_RXDQEN_RXD15_MASK    0x00008000      /* Enable RxD15=
 [15..15] */
+#define VREG_IHCU_RXDQEN_RXD14_MASK    0x00004000      /* Enable RxD14=
 [14..14] */
+#define VREG_IHCU_RXDQEN_RXD13_MASK    0x00002000      /* Enable RxD13=
 [13..13] */
+#define VREG_IHCU_RXDQEN_RXD12_MASK    0x00001000      /* Enable RxD12=
 [12..12] */
+#define VREG_IHCU_RXDQEN_RXD11_MASK    0x00000800      /* Enable RxD11=
 [11..11] */
+#define VREG_IHCU_RXDQEN_RXD10_MASK    0x00000400      /* Enable RxD10=
 [10..10] */
+#define VREG_IHCU_RXDQEN_RXD9_MASK     0x00000200      /* Enable RxD9 =
[9..9] */
+#define VREG_IHCU_RXDQEN_RXD8_MASK     0x00000100      /* Enable RxD8 =
[8..8] */
+#define VREG_IHCU_RXDQEN_RXD7_MASK     0x00000080      /* Enable RxD7 =
[7..7] */
+#define VREG_IHCU_RXDQEN_RXD6_MASK     0x00000040      /* Enable RxD6 =
[6..6] */
+#define VREG_IHCU_RXDQEN_RXD5_MASK     0x00000020      /* Enable RxD5 =
[5..5] */
+#define VREG_IHCU_RXDQEN_RXD4_MASK     0x00000010      /* Enable RxD4 =
[4..4] */
+#define VREG_IHCU_RXDQEN_RXD3_MASK     0x00000008      /* Enable RxD3 =
[3..3] */
+#define VREG_IHCU_RXDQEN_RXD2_MASK     0x00000004      /* Enable RxD2 =
[2..2] */
+#define VREG_IHCU_RXDQEN_RXD1_MASK     0x00000002      /* Enable RxD1 =
[1..1] */
+#define VREG_IHCU_RXDQEN_RXD0_MASK     0x00000001      /* Enable RxD0 =
[0..0] */
+
+/* Map of VNIC to RxD Queues (31..0) */
+#define VREG_IHCU_VNICRXDMAP_MASK      0xffffffff
+#define VREG_IHCU_VNICRXDMAP_ACCESSMODE        2
+#define VREG_IHCU_VNICRXDMAP_HOSTPRIVILEGE     1
+#define VREG_IHCU_VNICRXDMAP_RESERVEDMASK      0x70707070
+#define VREG_IHCU_VNICRXDMAP_WRITEMASK         0x8f8f8f8f
+#define VREG_IHCU_VNICRXDMAP_READMASK  0x8f8f8f8f
+#define VREG_IHCU_VNICRXDMAP_CLEARMASK         0x00000000
+#define VREG_IHCU_VNICRXDMAP   0x810
+#define VREG_IHCU_VNICRXDMAP_ID        516
+
+/* Subfields of VNICRxDMap */
+#define VREG_IHCU_VNICRXDMAP_P3_MASK   0x80000000      /* Set to 1 if =
4th RxD is provisioned [31..31] */
+#define VREG_IHCU_VNICRXDMAP_RSV3_MASK 0x70000000      /* Reserved [28=
=2E.30] */
+#define VREG_IHCU_VNICRXDMAP_RXD3_MASK 0x0f000000      /* RxD to use f=
or 4th mapping [24..27] */
+#define VREG_IHCU_VNICRXDMAP_P2_MASK   0x00800000      /* Set to 1 if =
3rd RxD is provisioned [23..23] */
+#define VREG_IHCU_VNICRXDMAP_RSV2_MASK 0x00700000      /* Reserved [20=
=2E.22] */
+#define VREG_IHCU_VNICRXDMAP_RXD2_MASK 0x000f0000      /* RxD to use f=
or 3rd mapping [16..19] */
+#define VREG_IHCU_VNICRXDMAP_P1_MASK   0x00008000      /* Set to 1 if =
2nd RxD is provisioned [15..15] */
+#define VREG_IHCU_VNICRXDMAP_RSV1_MASK 0x00007000      /* Reserved [12=
=2E.14] */
+#define VREG_IHCU_VNICRXDMAP_RXD1_MASK 0x00000f00      /* RxD to use f=
or 2nd mapping [8..11] */
+#define VREG_IHCU_VNICRXDMAP_P0_MASK   0x00000080      /* Set to 1 if =
1st RxD is provisioned [7..7] */
+#define VREG_IHCU_VNICRXDMAP_RSV0_MASK 0x00000070      /* Reserved [4.=
=2E6] */
+#define VREG_IHCU_VNICRXDMAP_RXD0_MASK 0x0000000f      /* RxD to use f=
or 1st mapping [0..3] */
+
+
+
+
+/* Map of VNIC to RxC Queue (31..0) */
+#define VREG_IHCU_VNICRXCMAP_MASK      0xffffffff
+#define VREG_IHCU_VNICRXCMAP_ACCESSMODE        2
+#define VREG_IHCU_VNICRXCMAP_HOSTPRIVILEGE     1
+#define VREG_IHCU_VNICRXCMAP_RESERVEDMASK      0x00000000
+#define VREG_IHCU_VNICRXCMAP_WRITEMASK         0xffffffff
+#define VREG_IHCU_VNICRXCMAP_READMASK  0xffffffff
+#define VREG_IHCU_VNICRXCMAP_CLEARMASK         0x00000000
+#define VREG_IHCU_VNICRXCMAP   0x820
+#define VREG_IHCU_VNICRXCMAP_ID        520
+
+
+
+/* Timer register for RxC Interrupt generation (31..0) */
+#define VREG_IHCU_RXCINTTIMER_MASK     0xffffffff
+#define VREG_IHCU_RXCINTTIMER_ACCESSMODE       2
+#define VREG_IHCU_RXCINTTIMER_HOSTPRIVILEGE    1
+#define VREG_IHCU_RXCINTTIMER_RESERVEDMASK     0x00000000
+#define VREG_IHCU_RXCINTTIMER_WRITEMASK        0x0000ffff
+#define VREG_IHCU_RXCINTTIMER_READMASK         0xffffffff
+#define VREG_IHCU_RXCINTTIMER_CLEARMASK        0x00000000
+#define VREG_IHCU_RXCINTTIMER  0x900
+#define VREG_IHCU_RXCINTTIMER_ID       576
+
+/* Subfields of RxCIntTimer */
+#define VREG_IHCU_RXCINTTIMER_CURR_MASK        0xffff0000      /* Curr=
ent Count [16..31] */
+#define VREG_IHCU_RXCINTTIMER_TERM_MASK        0x0000ffff      /* Term=
inal Count [0..15] */
+
+
+#define        VREG_IHCU_RXCINTTIMER_R0        0x900
+#define        VREG_IHCU_RXCINTTIMER_R1        0x904
+#define        VREG_IHCU_RXCINTTIMER_R2        0x908
+#define        VREG_IHCU_RXCINTTIMER_R3        0x90C
+#define        VREG_IHCU_RXCINTTIMER_R4        0x910
+#define        VREG_IHCU_RXCINTTIMER_R5        0x914
+#define        VREG_IHCU_RXCINTTIMER_R6        0x918
+#define        VREG_IHCU_RXCINTTIMER_R7        0x91C
+#define        VREG_IHCU_RXCINTTIMER_R8        0x920
+#define        VREG_IHCU_RXCINTTIMER_R9        0x924
+#define        VREG_IHCU_RXCINTTIMER_R10       0x928
+#define        VREG_IHCU_RXCINTTIMER_R11       0x92C
+#define        VREG_IHCU_RXCINTTIMER_R12       0x930
+#define        VREG_IHCU_RXCINTTIMER_R13       0x934
+#define        VREG_IHCU_RXCINTTIMER_R14       0x938
+#define        VREG_IHCU_RXCINTTIMER_R15       0x93C
+
+
+/* Packet Count register for RxC Interrupt generation (31..0) */
+#define VREG_IHCU_RXCINTPKTCNT_MASK    0xffffffff
+#define VREG_IHCU_RXCINTPKTCNT_ACCESSMODE      2
+#define VREG_IHCU_RXCINTPKTCNT_HOSTPRIVILEGE   1
+#define VREG_IHCU_RXCINTPKTCNT_RESERVEDMASK    0x00000000
+#define VREG_IHCU_RXCINTPKTCNT_WRITEMASK       0x0000ffff
+#define VREG_IHCU_RXCINTPKTCNT_READMASK        0xffffffff
+#define VREG_IHCU_RXCINTPKTCNT_CLEARMASK       0x00000000
+#define VREG_IHCU_RXCINTPKTCNT         0x940
+#define VREG_IHCU_RXCINTPKTCNT_ID      592
+
+/* Subfields of RxCIntPktCnt */
+#define VREG_IHCU_RXCINTPKTCNT_CURR_MASK       0xffff0000      /* Curr=
ent Count [16..31] */
+#define VREG_IHCU_RXCINTPKTCNT_TERM_MASK       0x0000ffff      /* Term=
inal Count [0..15] */
+
+
+#define        VREG_IHCU_RXCINTPKTCNT_R0       0x940
+#define        VREG_IHCU_RXCINTPKTCNT_R1       0x944
+#define        VREG_IHCU_RXCINTPKTCNT_R2       0x948
+#define        VREG_IHCU_RXCINTPKTCNT_R3       0x94C
+#define        VREG_IHCU_RXCINTPKTCNT_R4       0x950
+#define        VREG_IHCU_RXCINTPKTCNT_R5       0x954
+#define        VREG_IHCU_RXCINTPKTCNT_R6       0x958
+#define        VREG_IHCU_RXCINTPKTCNT_R7       0x95C
+#define        VREG_IHCU_RXCINTPKTCNT_R8       0x960
+#define        VREG_IHCU_RXCINTPKTCNT_R9       0x964
+#define        VREG_IHCU_RXCINTPKTCNT_R10      0x968
+#define        VREG_IHCU_RXCINTPKTCNT_R11      0x96C
+#define        VREG_IHCU_RXCINTPKTCNT_R12      0x970
+#define        VREG_IHCU_RXCINTPKTCNT_R13      0x974
+#define        VREG_IHCU_RXCINTPKTCNT_R14      0x978
+#define        VREG_IHCU_RXCINTPKTCNT_R15      0x97C
+
+
+/* Control register for RxC Interrupt generation (31..0) */
+#define VREG_IHCU_RXCINTCTL_MASK       0xffffffff
+#define VREG_IHCU_RXCINTCTL_ACCESSMODE         2
+#define VREG_IHCU_RXCINTCTL_HOSTPRIVILEGE      1
+#define VREG_IHCU_RXCINTCTL_RESERVEDMASK       0xfffffffc
+#define VREG_IHCU_RXCINTCTL_WRITEMASK  0x00000003
+#define VREG_IHCU_RXCINTCTL_READMASK   0x00000003
+#define VREG_IHCU_RXCINTCTL_CLEARMASK  0x00000000
+#define VREG_IHCU_RXCINTCTL    0x980
+#define VREG_IHCU_RXCINTCTL_ID         608
+
+#define VVAL_IHCU_RXCINTCTL_DEFAULT 0x0        /* Reset by sreset: Res=
et to 0 */
+/* Subfields of RxCIntCtl */
+#define VREG_IHCU_RXCINTCTL_RSV_MASK   0xfffffffc      /* Reserved [2.=
=2E31] */
+#define VREG_IHCU_RXCINTCTL_CLRPEND_MASK       0x00000002      /* Clea=
r MSI-X Pending bit [1..1] */
+#define VREG_IHCU_RXCINTCTL_MASK_MASK  0x00000001      /* Mask Rx Inte=
rrupts [0..0] */
+
+
+#define        VREG_IHCU_RXCINTCTL_R0  0x980
+#define        VREG_IHCU_RXCINTCTL_R1  0x984
+#define        VREG_IHCU_RXCINTCTL_R2  0x988
+#define        VREG_IHCU_RXCINTCTL_R3  0x98C
+#define        VREG_IHCU_RXCINTCTL_R4  0x990
+#define        VREG_IHCU_RXCINTCTL_R5  0x994
+#define        VREG_IHCU_RXCINTCTL_R6  0x998
+#define        VREG_IHCU_RXCINTCTL_R7  0x99C
+#define        VREG_IHCU_RXCINTCTL_R8  0x9A0
+#define        VREG_IHCU_RXCINTCTL_R9  0x9A4
+#define        VREG_IHCU_RXCINTCTL_R10         0x9A8
+#define        VREG_IHCU_RXCINTCTL_R11         0x9AC
+#define        VREG_IHCU_RXCINTCTL_R12         0x9B0
+#define        VREG_IHCU_RXCINTCTL_R13         0x9B4
+#define        VREG_IHCU_RXCINTCTL_R14         0x9B8
+#define        VREG_IHCU_RXCINTCTL_R15         0x9BC
+
+
+/* Diagnostic Shared memory Read Address register (12..0) */
+#define VREG_IHCU_DIAGADDR_MASK        0x00001fff
+#define VREG_IHCU_DIAGADDR_ACCESSMODE  2
+#define VREG_IHCU_DIAGADDR_HOSTPRIVILEGE       1
+#define VREG_IHCU_DIAGADDR_RESERVEDMASK        0x00000000
+#define VREG_IHCU_DIAGADDR_WRITEMASK   0x00001fff
+#define VREG_IHCU_DIAGADDR_READMASK    0x00001fff
+#define VREG_IHCU_DIAGADDR_CLEARMASK   0x00000000
+#define VREG_IHCU_DIAGADDR     0xf00
+#define VREG_IHCU_DIAGADDR_ID  960
+
+#define VVAL_IHCU_DIAGADDR_DEFAULT 0x0         /* Reset by sreset: Res=
et to 0 */
+
+/* Diagnostic read result register (31..0) */
+#define VREG_IHCU_DIAGRESULT_MASK      0xffffffff
+#define VREG_IHCU_DIAGRESULT_ACCESSMODE        1
+#define VREG_IHCU_DIAGRESULT_HOSTPRIVILEGE     1
+#define VREG_IHCU_DIAGRESULT_RESERVEDMASK      0x00000000
+#define VREG_IHCU_DIAGRESULT_WRITEMASK         0x00000000
+#define VREG_IHCU_DIAGRESULT_READMASK  0xffffffff
+#define VREG_IHCU_DIAGRESULT_CLEARMASK         0x00000000
+#define VREG_IHCU_DIAGRESULT   0xf04
+#define VREG_IHCU_DIAGRESULT_ID        961
+
+#endif /* _VIOC_IHCU_REGISTERS_H_ */
+
diff -puN /dev/null drivers/net/vioc/f7/vioc_le_registers.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vioc_le_registers.h
@@ -0,0 +1,241 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+
+#ifndef _VIOC_LE_REGISTERS_H_
+#define _VIOC_LE_REGISTERS_H_
+
+// F7LE
+
+/* Combined 72 bit Address and Command Register (31..0) */
+#define VREG_F7LE_ADDRCMD_MASK         0xffffffff
+#define VREG_F7LE_ADDRCMD_ACCESSMODE   2
+#define VREG_F7LE_ADDRCMD_HOSTPRIVILEGE        0
+#define VREG_F7LE_ADDRCMD_RESERVEDMASK         0x00000000
+#define VREG_F7LE_ADDRCMD_WRITEMASK    0xffffffff
+#define VREG_F7LE_ADDRCMD_READMASK     0xffffffff
+#define VREG_F7LE_ADDRCMD_CLEARMASK    0x00000000
+#define VREG_F7LE_ADDRCMD      0x000
+#define VREG_F7LE_ADDRCMD_ID   0
+
+#define VVAL_F7LE_ADDRCMD_DEFAULT 0x0  /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Full Addr Register for 72-bit accesses (31..0) */
+#define VREG_F7LE_DATAREG_MASK         0xffffffff
+#define VREG_F7LE_DATAREG_ACCESSMODE   2
+#define VREG_F7LE_DATAREG_HOSTPRIVILEGE        0
+#define VREG_F7LE_DATAREG_RESERVEDMASK         0x00000000
+#define VREG_F7LE_DATAREG_WRITEMASK    0xffffffff
+#define VREG_F7LE_DATAREG_READMASK     0xffffffff
+#define VREG_F7LE_DATAREG_CLEARMASK    0x00000000
+#define VREG_F7LE_DATAREG      0x004
+#define VREG_F7LE_DATAREG_ID   1
+
+#define VVAL_F7LE_DATAREG_DEFAULT 0x0  /* Reset by hreset: Reset to 0 =
*/
+
+
+/* Full 72 bit ReadData Register for 72-bit accesses (31..0) */
+#define VREG_F7LE_RDDATAREG_MASK       0xffffffff
+#define VREG_F7LE_RDDATAREG_ACCESSMODE         2
+#define VREG_F7LE_RDDATAREG_HOSTPRIVILEGE      0
+#define VREG_F7LE_RDDATAREG_RESERVEDMASK       0x00000000
+#define VREG_F7LE_RDDATAREG_WRITEMASK  0xffffffff
+#define VREG_F7LE_RDDATAREG_READMASK   0xffffffff
+#define VREG_F7LE_RDDATAREG_CLEARMASK  0x00000000
+#define VREG_F7LE_RDDATAREG    0x008
+#define VREG_F7LE_RDDATAREG_ID         2
+
+#define VVAL_F7LE_RDDATAREG_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Address for Diagnostic accesses to TCAM and SRAM (31..0) */
+#define VREG_F7LE_ADDRREG_MASK         0xffffffff
+#define VREG_F7LE_ADDRREG_ACCESSMODE   2
+#define VREG_F7LE_ADDRREG_HOSTPRIVILEGE        0
+#define VREG_F7LE_ADDRREG_RESERVEDMASK         0x00000000
+#define VREG_F7LE_ADDRREG_WRITEMASK    0xffffffff
+#define VREG_F7LE_ADDRREG_READMASK     0xffffffff
+#define VREG_F7LE_ADDRREG_CLEARMASK    0x00000000
+#define VREG_F7LE_ADDRREG      0x010
+#define VREG_F7LE_ADDRREG_ID   4
+
+#define VVAL_F7LE_ADDRREG_DEFAULT 0x0  /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of AddrReg */
+#define VREG_F7LE_ADDRREG_RSVD0_MASK   0xffe00000      /* Reserved [21=
=2E.31] */
+#define VREG_F7LE_ADDRREG_ARRAY_MASK   0x00180000      /* Select array=
 to access [19..20] */
+#define VVAL_F7LE_ADDRREG_ARRAY_TCAMDATA 0x0   /* TCAM Data array */
+#define VVAL_F7LE_ADDRREG_ARRAY_TCAMMASK 0x80000       /* TCAM Mask ar=
ray */
+#define VVAL_F7LE_ADDRREG_ARRAY_SRAM 0x100000  /* SRAM */
+#define VVAL_F7LE_ADDRREG_ARRAY_REGS 0x180000  /* TCAM internal regist=
ers */
+#define VREG_F7LE_ADDRREG_ADDRESS_MASK 0x0007ffff      /* Address [0..=
18] */
+
+
+
+
+/* Command and Status for diagnostic accesses (31..0) */
+#define VREG_F7LE_CMDREG_MASK  0xffffffff
+#define VREG_F7LE_CMDREG_ACCESSMODE    2
+#define VREG_F7LE_CMDREG_HOSTPRIVILEGE         0
+#define VREG_F7LE_CMDREG_RESERVEDMASK  0x00000000
+#define VREG_F7LE_CMDREG_WRITEMASK     0xffffff00
+#define VREG_F7LE_CMDREG_READMASK      0xffffffff
+#define VREG_F7LE_CMDREG_CLEARMASK     0x00000000
+#define VREG_F7LE_CMDREG       0x014
+#define VREG_F7LE_CMDREG_ID    5
+    /*
+     * Writing this register causes a diagnostic access to be performe=
d
+     * Allows arbitrary parity pattern to be used for write or lookup.
+     * Bits 15:8 of the command register are used in place of the HW g=
enerated parity
+     */
+
+#define VVAL_F7LE_CMDREG_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of CmdReg */
+#define VREG_F7LE_CMDREG_CMD_MASK      0xc0000000      /* Type of oper=
ation [30..31] */
+#define VVAL_F7LE_CMDREG_CMD_READ 0x0  /* Read Operation */
+#define VVAL_F7LE_CMDREG_CMD_LOOKUP 0x40000000         /* Lookup Opera=
tion */
+#define VVAL_F7LE_CMDREG_CMD_WRITE 0x80000000  /* Write Operation */
+#define VREG_F7LE_CMDREG_FRCPAR_MASK   0x20000000      /* Bypass HW pa=
rity generation [29..29] */
+#define VREG_F7LE_CMDREG_RSVD0_MASK    0x1fff0000      /* Unused [16..=
28] */
+#define VREG_F7LE_CMDREG_WRPARITY_MASK 0x0000ff00      /* Parity bits =
to be used for raw write operations. [8..15] */
+#define VREG_F7LE_CMDREG_RDPARITY_MASK 0x000000ff      /* Raw Parity b=
its returned from Read operation [0..7] */
+
+
+
+
+/* Low order 32-bits of 72 bit data for 32 bit accesses (31..0) */
+#define VREG_F7LE_DATAREGLO_MASK       0xffffffff
+#define VREG_F7LE_DATAREGLO_ACCESSMODE         2
+#define VREG_F7LE_DATAREGLO_HOSTPRIVILEGE      0
+#define VREG_F7LE_DATAREGLO_RESERVEDMASK       0x00000000
+#define VREG_F7LE_DATAREGLO_WRITEMASK  0xffffffff
+#define VREG_F7LE_DATAREGLO_READMASK   0xffffffff
+#define VREG_F7LE_DATAREGLO_CLEARMASK  0x00000000
+#define VREG_F7LE_DATAREGLO    0x020
+#define VREG_F7LE_DATAREGLO_ID         8
+
+#define VVAL_F7LE_DATAREGLO_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Middle 32-bits of 72 bit data for 32 bit accesses (31..0) */
+#define VREG_F7LE_DATAREGMID_MASK      0xffffffff
+#define VREG_F7LE_DATAREGMID_ACCESSMODE        2
+#define VREG_F7LE_DATAREGMID_HOSTPRIVILEGE     0
+#define VREG_F7LE_DATAREGMID_RESERVEDMASK      0x00000000
+#define VREG_F7LE_DATAREGMID_WRITEMASK         0xffffffff
+#define VREG_F7LE_DATAREGMID_READMASK  0xffffffff
+#define VREG_F7LE_DATAREGMID_CLEARMASK         0x00000000
+#define VREG_F7LE_DATAREGMID   0x024
+#define VREG_F7LE_DATAREGMID_ID        9
+
+#define VVAL_F7LE_DATAREGMID_DEFAULT 0x0       /* Reset by hreset: Res=
et to 0 */
+
+
+/* Unused (7..0) */
+#define VREG_F7LE_DATAREGHI_MASK       0x000000ff
+#define VREG_F7LE_DATAREGHI_ACCESSMODE         2
+#define VREG_F7LE_DATAREGHI_HOSTPRIVILEGE      0
+#define VREG_F7LE_DATAREGHI_RESERVEDMASK       0x00000000
+#define VREG_F7LE_DATAREGHI_WRITEMASK  0x000000ff
+#define VREG_F7LE_DATAREGHI_READMASK   0x000000ff
+#define VREG_F7LE_DATAREGHI_CLEARMASK  0x00000000
+#define VREG_F7LE_DATAREGHI    0x02c
+#define VREG_F7LE_DATAREGHI_ID         11
+
+#define VVAL_F7LE_DATAREGHI_DEFAULT 0x0        /* Reset by hreset: Res=
et to 0 */
+
+
+/* Low order 32-bits of 72 bit RdData for 32 bit accesses (31..0) */
+#define VREG_F7LE_RDDATAREGLO_MASK     0xffffffff
+#define VREG_F7LE_RDDATAREGLO_ACCESSMODE       1
+#define VREG_F7LE_RDDATAREGLO_HOSTPRIVILEGE    0
+#define VREG_F7LE_RDDATAREGLO_RESERVEDMASK     0x00000000
+#define VREG_F7LE_RDDATAREGLO_WRITEMASK        0x00000000
+#define VREG_F7LE_RDDATAREGLO_READMASK         0xffffffff
+#define VREG_F7LE_RDDATAREGLO_CLEARMASK        0x00000000
+#define VREG_F7LE_RDDATAREGLO  0x030
+#define VREG_F7LE_RDDATAREGLO_ID       12
+
+#define VVAL_F7LE_RDDATAREGLO_DEFAULT 0x0      /* Reset by hreset: Res=
et to 0 */
+
+
+/* Middle 32-bits of 72 bit RdData for 32 bit accesses (31..0) */
+#define VREG_F7LE_RDDATAREGMID_MASK    0xffffffff
+#define VREG_F7LE_RDDATAREGMID_ACCESSMODE      1
+#define VREG_F7LE_RDDATAREGMID_HOSTPRIVILEGE   0
+#define VREG_F7LE_RDDATAREGMID_RESERVEDMASK    0x00000000
+#define VREG_F7LE_RDDATAREGMID_WRITEMASK       0x00000000
+#define VREG_F7LE_RDDATAREGMID_READMASK        0xffffffff
+#define VREG_F7LE_RDDATAREGMID_CLEARMASK       0x00000000
+#define VREG_F7LE_RDDATAREGMID         0x034
+#define VREG_F7LE_RDDATAREGMID_ID      13
+
+#define VVAL_F7LE_RDDATAREGMID_DEFAULT 0x0     /* Reset by hreset: Res=
et to 0 */
+
+
+/* Status bits from read result (7..0) */
+#define VREG_F7LE_RDDATAREGHI_MASK     0x000000ff
+#define VREG_F7LE_RDDATAREGHI_ACCESSMODE       1
+#define VREG_F7LE_RDDATAREGHI_HOSTPRIVILEGE    0
+#define VREG_F7LE_RDDATAREGHI_RESERVEDMASK     0x00000000
+#define VREG_F7LE_RDDATAREGHI_WRITEMASK        0x00000000
+#define VREG_F7LE_RDDATAREGHI_READMASK         0x000000ff
+#define VREG_F7LE_RDDATAREGHI_CLEARMASK        0x00000000
+#define VREG_F7LE_RDDATAREGHI  0x03c
+#define VREG_F7LE_RDDATAREGHI_ID       15
+
+#define VVAL_F7LE_RDDATAREGHI_DEFAULT 0x0      /* Reset by hreset: Res=
et to 0 */
+/* Subfields of RdDataRegHi */
+#define VREG_F7LE_RDDATAREGHI_DONE_MASK        0x00000080      /* FLD_=
RDONLY, HW clears when read is started, sets when done [7..7] */
+#define VREG_F7LE_RDDATAREGHI_LOOKUP_MASK      0x00000040      /* FLD_=
RDONLY, Result data is from a lookup (1) or Read (0) [6..6] */
+#define VREG_F7LE_RDDATAREGHI_MATCH_MASK       0x00000020      /* FLD_=
RDONLY, On a lookup asserted if TCAM indicated match [5..5] */
+#define VREG_F7LE_RDDATAREGHI_PARERR_MASK      0x00000010      /* FLD_=
RDONLY, HW Detected a parity error on the response data [4..4] */
+#define VREG_F7LE_RDDATAREGHI_RSVD0_MASK       0x0000000f      /* Rese=
rved [0..3] */
+
+
+
+
+/* TCAM initialization control register (31..0) */
+#define VREG_F7LE_INIT_MASK    0xffffffff
+#define VREG_F7LE_INIT_ACCESSMODE      2
+#define VREG_F7LE_INIT_HOSTPRIVILEGE   0
+#define VREG_F7LE_INIT_RESERVEDMASK    0x7cfe0000
+#define VREG_F7LE_INIT_WRITEMASK       0x0301ffff
+#define VREG_F7LE_INIT_READMASK        0x8301ffff
+#define VREG_F7LE_INIT_CLEARMASK       0x00000000
+#define VREG_F7LE_INIT         0x040
+#define VREG_F7LE_INIT_ID      16
+
+#define VVAL_F7LE_INIT_DEFAULT 0x0     /* Reset by hreset: Reset to 0 =
*/
+/* Subfields of Init */
+#define VREG_F7LE_INIT_DONE_MASK       0x80000000      /* Read Only: T=
CAM initialization Sequence is complete [31..31] */
+#define VREG_F7LE_INIT_RESV0_MASK      0x7c000000      /* Reserved [26=
=2E.30] */
+#define VREG_F7LE_INIT_STOP_MASK       0x02000000      /* 1 causes VIO=
C to stop TCAM initialization [25..25] */
+#define VREG_F7LE_INIT_START_MASK      0x01000000      /* 1 causes VIO=
C to initialize TCAM. HW clears after starting [24..24] */
+#define VREG_F7LE_INIT_RESV1_MASK      0x00fe0000      /* Reserved [17=
=2E.23] */
+#define VREG_F7LE_INIT_COUNT_MASK      0x0001ffff      /* Number of TC=
AM data or mask entries to clear [0..16] */
+
+#endif /* _VIOC_LE_REGISTERS_H_ */
diff -puN /dev/null drivers/net/vioc/f7/vioc_msi_registers.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vioc_msi_registers.h
@@ -0,0 +1,111 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+
+#ifndef _VIOC_MSI_REGISTERS_H_
+#define _VIOC_MSI_REGISTERS_H_
+
+/*
+ * MSIX Table Structure
+ * One table entry is described here.
+ * There are a total of 19 table entries.
+ */
+/* Module MSIXTBL:96 */
+
+/* Low half of MSI-X Address (31..0) */
+#define VREG_MSIXTBL_ADDRLOW_MASK      0xffffffff
+#define VREG_MSIXTBL_ADDRLOW_ACCESSMODE        2
+#define VREG_MSIXTBL_ADDRLOW_HOSTPRIVILEGE     1
+#define VREG_MSIXTBL_ADDRLOW_RESERVEDMASK      0x00000000
+#define VREG_MSIXTBL_ADDRLOW_WRITEMASK         0xffffffff
+#define VREG_MSIXTBL_ADDRLOW_READMASK  0xffffffff
+#define VREG_MSIXTBL_ADDRLOW_CLEARMASK         0x00000000
+#define VREG_MSIXTBL_ADDRLOW   0x000
+#define VREG_MSIXTBL_ADDRLOW_ID        0
+
+
+
+/* High half of MSI-X Address (31..0) */
+#define VREG_MSIXTBL_ADDRHIGH_MASK     0xffffffff
+#define VREG_MSIXTBL_ADDRHIGH_ACCESSMODE       2
+#define VREG_MSIXTBL_ADDRHIGH_HOSTPRIVILEGE    1
+#define VREG_MSIXTBL_ADDRHIGH_RESERVEDMASK     0x00000000
+#define VREG_MSIXTBL_ADDRHIGH_WRITEMASK        0xffffffff
+#define VREG_MSIXTBL_ADDRHIGH_READMASK         0xffffffff
+#define VREG_MSIXTBL_ADDRHIGH_CLEARMASK        0x00000000
+#define VREG_MSIXTBL_ADDRHIGH  0x004
+#define VREG_MSIXTBL_ADDRHIGH_ID       1
+
+
+
+/* MSI_X Data (31..0) */
+#define VREG_MSIXTBL_DATA_MASK         0xffffffff
+#define VREG_MSIXTBL_DATA_ACCESSMODE   2
+#define VREG_MSIXTBL_DATA_HOSTPRIVILEGE        1
+#define VREG_MSIXTBL_DATA_RESERVEDMASK         0x00000000
+#define VREG_MSIXTBL_DATA_WRITEMASK    0xffffffff
+#define VREG_MSIXTBL_DATA_READMASK     0xffffffff
+#define VREG_MSIXTBL_DATA_CLEARMASK    0x00000000
+#define VREG_MSIXTBL_DATA      0x008
+#define VREG_MSIXTBL_DATA_ID   2
+
+
+
+/* MSI_X Control (31..0) */
+#define VREG_MSIXTBL_CNTL_MASK         0xffffffff
+#define VREG_MSIXTBL_CNTL_ACCESSMODE   2
+#define VREG_MSIXTBL_CNTL_HOSTPRIVILEGE        1
+#define VREG_MSIXTBL_CNTL_RESERVEDMASK         0xfffffffe
+#define VREG_MSIXTBL_CNTL_WRITEMASK    0x00000001
+#define VREG_MSIXTBL_CNTL_READMASK     0x00000001
+#define VREG_MSIXTBL_CNTL_CLEARMASK    0x00000000
+#define VREG_MSIXTBL_CNTL      0x00c
+#define VREG_MSIXTBL_CNTL_ID   3
+
+/* Subfields of Cntl */
+#define VREG_MSIXTBL_CNTL_RSVD_MASK    0xfffffffe      /* Reserved [1.=
=2E31] */
+#define VREG_MSIXTBL_CNTL_MASK_MASK    0x00000001      /* Interrupt Ma=
sk [0..0] */
+
+
+/* MSIX PBA Structure - ReadOnly */
+/* Module MSIXPBA:97 */
+
+// MSIXPBA one VNIC block
+
+
+/* Bit vector of pending interrupts (18..0) */
+#define VREG_MSIXPBA_PENDING_MASK      0x0007ffff
+#define VREG_MSIXPBA_PENDING_ACCESSMODE        1
+#define VREG_MSIXPBA_PENDING_HOSTPRIVILEGE     1
+#define VREG_MSIXPBA_PENDING_RESERVEDMASK      0x00000000
+#define VREG_MSIXPBA_PENDING_WRITEMASK         0x00000000
+#define VREG_MSIXPBA_PENDING_READMASK  0x0007ffff
+#define VREG_MSIXPBA_PENDING_CLEARMASK         0x00000000
+#define VREG_MSIXPBA_PENDING   0x000
+#define VREG_MSIXPBA_PENDING_ID        0
+
+#endif /* _VIOC_MSI_REGISTERS_H_ */
+
diff -puN /dev/null drivers/net/vioc/f7/vioc_pkts_defs.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vioc_pkts_defs.h
@@ -0,0 +1,853 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#ifndef _VIOC_PKTS_H_
+#define _VIOC_PKTS_H_
+/* Fabric7 Fabric Packet Format */
+struct vioc_f7pf {
+
+       /* 30..31: Encapsulation Version */
+       u32 enVer:      2;
+#define VIOC_F7PF_VERSION0 0x0         /* Version 0 */
+#define VIOC_F7PF_VERSION1 0x1         /* Version 1 */
+#define VIOC_F7PF_ENCAPRESERVED2 0x2   /* reserved */
+#define VIOC_F7PF_ENCAPRESERVED3 0x3   /* reserved */
+
+       /* 29..29: Multicast Flag */
+       u32 mc: 1;
+#define VIOC_F7PF_UNICASTPKT 0x0       /* Unicast Packet */
+#define VIOC_F7PF_MULTICASTPKT 0x1     /* Multicast Packet */
+
+       /* 28..28: No Touch Flag */
+       u32 noTouch:    1;
+#define VIOC_F7PF_FLAGTOUCH 0x0        /* Indicates Normal VIOC Proces=
sing */
+#define VIOC_F7PF_FLAGNOTOUCH 0x1      /* Privileged mode, skips VIOC =
Processing (SIM only) */
+
+       /* 26..27: Drop Precedence */
+       u32 f7DP:       2;
+
+       /* 24..25: Class of Service (Fabric Priority) */
+       u32 f7COS:      2;
+#define VIOC_F7PF_PRIORITY0 0x0        /* Priority for VIOCCP */
+#define VIOC_F7PF_PRIORITY1 0x1        /* Reserved1 */
+#define VIOC_F7PF_PRIORITY2 0x2        /* Reserved2 */
+#define VIOC_F7PF_PRIORITY3 0x3        /* Priority for all other traff=
ic */
+
+       /* 16..23: Encapsulation Tag */
+       u32 enTag:      8;
+       /* All other encap values are reserved */
+#define VIOC_F7PF_ET_NULL 0x0  /* Null Encapsulation Tag (Invalid ) */
+#define VIOC_F7PF_ET_VIOCCP 0x1        /* Encap for VIOC Control Proto=
col Requests */
+#define VIOC_F7PF_ET_VIOCCP_RESP 0x2   /* Encap for VIOC Control Proto=
col Responses */
+#define VIOC_F7PF_ET_VNIC_DIAG 0x8     /* Encap for VNIC Driver Diagno=
stics */
+#define VIOC_F7PF_ET_ETH 0x10  /* Ethernet Frame */
+#define VIOC_F7PF_ET_ETH_F7MP 0x11     /* Ethernet Frame with F7MP pay=
load */
+#define VIOC_F7PF_ET_ETH_IPV4 0x12     /* Ethernet Frame with IP paylo=
ad */
+#define VIOC_F7PF_ET_ETH_IPV4_CKS 0x13         /* Ethernet Frame with =
IP payload */
+#define VIOC_F7PF_ET_ETH_CONTROL 0x18  /* Ethernet BPDU, LACP Control =
Protocol */
+#define VIOC_F7PF_ET_MPLS 0x20         /* MPLS transit, no Ethernet en=
cap */
+#define VIOC_F7PF_ET_IPV4 0x30         /* IPV4, no Ethernet encap */
+#define VIOC_F7PF_ET_F7MP 0xf7         /* F7MP, no Ethernet encap */
+
+       /* 14..15: Key Length */
+       u32 ekLen:      2;
+
+       /* 0..13: Packet Length */
+       u32 pktLen:     14;
+
+       /* 10..15: Destination Fabric address */
+       u16 dstFabAddr: 6;
+
+       /* 4..9: Destination Sub Address */
+       u16 dstSubAddr: 6;
+
+       /* 0..3: Reserved */
+       u16 reserved_uni:       4;
+
+       /* 10..15: Source Fabric address */
+       u16 srcFabAddr: 6;
+
+       /* 4..9: Source Sub Address */
+       u16 srcSubAddr: 6;
+
+       /* 0..3: Source Priority */
+       u16 priority:   4;
+
+       /* 0..15: Logical Interface Identifier */
+       u16 lifID:      16;
+#define VIOC_F7PF_LOCAL_LIFID_MIN 0x0  /* Local LIF ( Card-Level ) Min=
 Value */
+#define VIOC_F7PF_LOCAL_LIFID_MAX 0xbfff       /* Local LIF ( Card-Lev=
el ) Max Value */
+#define VIOC_F7PF_GLOBAL_LIFID_MIN 0xc000      /* Global LIF Min Value=
 */
+#define VIOC_F7PF_GLOBAL_LIFID_MAX 0xffff      /* Global LIF Max Value=
 */
+};
+
+struct vioc_f7pf_w {
+       u32 word_0;
+
+   /* Encapsulation Version */
+#  define VIOC_F7PF_ENVER_WORD 0
+#  define VIOC_F7PF_ENVER_MASK 0xc0000000
+#  define VIOC_F7PF_ENVER_SHIFT        30
+#ifndef  GET_VIOC_F7PF_ENVER
+#  define GET_VIOC_F7PF_ENVER(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_ENVER_M=
ASK))
+#endif
+#ifndef  GET_VIOC_F7PF_ENVER_SHIFTED
+#  define GET_VIOC_F7PF_ENVER_SHIFTED(p)               \
+               (((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_ENVER_=
MASK))>>VIOC_F7PF_ENVER_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_ENVER
+#  define GET_NTOH_VIOC_F7PF_ENVER(p)          \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_EN=
VER_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_ENVER_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_ENVER_SHIFTED(p)          \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_E=
NVER_MASK))>>VIOC_F7PF_ENVER_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_ENVER
+#  define SET_VIOC_F7PF_ENVER(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D (val & VIOC_F=
7PF_ENVER_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_ENVER_SHIFTED
+#  define SET_VIOC_F7PF_ENVER_SHIFTED(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D ((val<<VIOC_F=
7PF_ENVER_SHIFT)& VIOC_F7PF_ENVER_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_ENVER
+#  define CLR_VIOC_F7PF_ENVER(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D (~VIOC_F7PF_E=
NVER_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_ENVER
+#  define SET_HTON_VIOC_F7PF_ENVER(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl(val & V=
IOC_F7PF_ENVER_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_ENVER_SHIFTED
+#  define SET_HTON_VIOC_F7PF_ENVER_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl((val<<V=
IOC_F7PF_ENVER_SHIFT)& VIOC_F7PF_ENVER_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_ENVER
+#  define CLR_HTON_VIOC_F7PF_ENVER(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D htonl(~VIOC_F=
7PF_ENVER_MASK))
+#endif
+      /* Version 0 (0x0<<30) */
+#     define VIOC_F7PF_Version0_W      0x00000000
+      /* Version 1 (0x1<<30) */
+#     define VIOC_F7PF_Version1_W      0x40000000
+      /* reserved (0x2<<30) */
+#     define VIOC_F7PF_EncapReserved2_W        0x80000000
+      /* reserved (0x3<<30) */
+#     define VIOC_F7PF_EncapReserved3_W        0xc0000000
+
+   /* Multicast Flag */
+#  define VIOC_F7PF_MC_WORD    0
+#  define VIOC_F7PF_MC_MASK    0x20000000
+#  define VIOC_F7PF_MC_SHIFT   29
+#ifndef  GET_VIOC_F7PF_MC
+#  define GET_VIOC_F7PF_MC(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_MC_MASK=
))
+#endif
+#ifndef  GET_VIOC_F7PF_MC_SHIFTED
+#  define GET_VIOC_F7PF_MC_SHIFTED(p)          \
+               (((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_MC_MAS=
K))>>VIOC_F7PF_MC_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_MC
+#  define GET_NTOH_VIOC_F7PF_MC(p)             \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_MC=
_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_MC_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_MC_SHIFTED(p)             \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_M=
C_MASK))>>VIOC_F7PF_MC_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_MC
+#  define SET_VIOC_F7PF_MC(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D (val & VIOC_F=
7PF_MC_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_MC_SHIFTED
+#  define SET_VIOC_F7PF_MC_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D ((val<<VIOC_F=
7PF_MC_SHIFT)& VIOC_F7PF_MC_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_MC
+#  define CLR_VIOC_F7PF_MC(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D (~VIOC_F7PF_M=
C_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_MC
+#  define SET_HTON_VIOC_F7PF_MC(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl(val & V=
IOC_F7PF_MC_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_MC_SHIFTED
+#  define SET_HTON_VIOC_F7PF_MC_SHIFTED(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl((val<<V=
IOC_F7PF_MC_SHIFT)& VIOC_F7PF_MC_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_MC
+#  define CLR_HTON_VIOC_F7PF_MC(p)             \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D htonl(~VIOC_F=
7PF_MC_MASK))
+#endif
+      /* Unicast Packet (0x0<<29) */
+#     define VIOC_F7PF_UnicastPkt_W    0x00000000
+      /* Multicast Packet (0x1<<29) */
+#     define VIOC_F7PF_MulticastPkt_W  0x20000000
+
+   /* No Touch Flag */
+#  define VIOC_F7PF_NOTOUCH_WORD       0
+#  define VIOC_F7PF_NOTOUCH_MASK       0x10000000
+#  define VIOC_F7PF_NOTOUCH_SHIFT      28
+#ifndef  GET_VIOC_F7PF_NOTOUCH
+#  define GET_VIOC_F7PF_NOTOUCH(p)             \
+               ((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_NOTOUCH=
_MASK))
+#endif
+#ifndef  GET_VIOC_F7PF_NOTOUCH_SHIFTED
+#  define GET_VIOC_F7PF_NOTOUCH_SHIFTED(p)             \
+               (((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_NOTOUC=
H_MASK))>>VIOC_F7PF_NOTOUCH_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_NOTOUCH
+#  define GET_NTOH_VIOC_F7PF_NOTOUCH(p)                \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_NO=
TOUCH_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_NOTOUCH_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_NOTOUCH_SHIFTED(p)                \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_N=
OTOUCH_MASK))>>VIOC_F7PF_NOTOUCH_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_NOTOUCH
+#  define SET_VIOC_F7PF_NOTOUCH(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D (val & VIOC_F=
7PF_NOTOUCH_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_NOTOUCH_SHIFTED
+#  define SET_VIOC_F7PF_NOTOUCH_SHIFTED(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D ((val<<VIOC_F=
7PF_NOTOUCH_SHIFT)& VIOC_F7PF_NOTOUCH_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_NOTOUCH
+#  define CLR_VIOC_F7PF_NOTOUCH(p)             \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D (~VIOC_F7PF_N=
OTOUCH_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_NOTOUCH
+#  define SET_HTON_VIOC_F7PF_NOTOUCH(p,val)            \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl(val & V=
IOC_F7PF_NOTOUCH_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_NOTOUCH_SHIFTED
+#  define SET_HTON_VIOC_F7PF_NOTOUCH_SHIFTED(p,val)            \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl((val<<V=
IOC_F7PF_NOTOUCH_SHIFT)& VIOC_F7PF_NOTOUCH_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_NOTOUCH
+#  define CLR_HTON_VIOC_F7PF_NOTOUCH(p)                \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D htonl(~VIOC_F=
7PF_NOTOUCH_MASK))
+#endif
+      /* Indicates Normal VIOC Processing (0x0<<28) */
+#     define VIOC_F7PF_FlagTouch_W     0x00000000
+      /* Privileged mode, skips VIOC Processing (SIM only) (0x1<<28) *=
/
+#     define VIOC_F7PF_FlagNoTouch_W   0x10000000
+
+   /* Drop Precedence */
+#  define VIOC_F7PF_F7DP_WORD  0
+#  define VIOC_F7PF_F7DP_MASK  0x0c000000
+#  define VIOC_F7PF_F7DP_SHIFT 26
+#ifndef  GET_VIOC_F7PF_F7DP
+#  define GET_VIOC_F7PF_F7DP(p)                \
+               ((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_F7DP_MA=
SK))
+#endif
+#ifndef  GET_VIOC_F7PF_F7DP_SHIFTED
+#  define GET_VIOC_F7PF_F7DP_SHIFTED(p)                \
+               (((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_F7DP_M=
ASK))>>VIOC_F7PF_F7DP_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_F7DP
+#  define GET_NTOH_VIOC_F7PF_F7DP(p)           \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_F7=
DP_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_F7DP_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_F7DP_SHIFTED(p)           \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_F=
7DP_MASK))>>VIOC_F7PF_F7DP_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_F7DP
+#  define SET_VIOC_F7PF_F7DP(p,val)            \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D (val & VIOC_F=
7PF_F7DP_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_F7DP_SHIFTED
+#  define SET_VIOC_F7PF_F7DP_SHIFTED(p,val)            \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D ((val<<VIOC_F=
7PF_F7DP_SHIFT)& VIOC_F7PF_F7DP_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_F7DP
+#  define CLR_VIOC_F7PF_F7DP(p)                \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D (~VIOC_F7PF_F=
7DP_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_F7DP
+#  define SET_HTON_VIOC_F7PF_F7DP(p,val)               \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl(val & V=
IOC_F7PF_F7DP_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_F7DP_SHIFTED
+#  define SET_HTON_VIOC_F7PF_F7DP_SHIFTED(p,val)               \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl((val<<V=
IOC_F7PF_F7DP_SHIFT)& VIOC_F7PF_F7DP_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_F7DP
+#  define CLR_HTON_VIOC_F7PF_F7DP(p)           \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D htonl(~VIOC_F=
7PF_F7DP_MASK))
+#endif
+
+   /* Class of Service (Fabric Priority) */
+#  define VIOC_F7PF_F7COS_WORD 0
+#  define VIOC_F7PF_F7COS_MASK 0x03000000
+#  define VIOC_F7PF_F7COS_SHIFT        24
+#ifndef  GET_VIOC_F7PF_F7COS
+#  define GET_VIOC_F7PF_F7COS(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_F7COS_M=
ASK))
+#endif
+#ifndef  GET_VIOC_F7PF_F7COS_SHIFTED
+#  define GET_VIOC_F7PF_F7COS_SHIFTED(p)               \
+               (((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_F7COS_=
MASK))>>VIOC_F7PF_F7COS_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_F7COS
+#  define GET_NTOH_VIOC_F7PF_F7COS(p)          \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_F7=
COS_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_F7COS_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_F7COS_SHIFTED(p)          \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_F=
7COS_MASK))>>VIOC_F7PF_F7COS_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_F7COS
+#  define SET_VIOC_F7PF_F7COS(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D (val & VIOC_F=
7PF_F7COS_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_F7COS_SHIFTED
+#  define SET_VIOC_F7PF_F7COS_SHIFTED(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D ((val<<VIOC_F=
7PF_F7COS_SHIFT)& VIOC_F7PF_F7COS_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_F7COS
+#  define CLR_VIOC_F7PF_F7COS(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D (~VIOC_F7PF_F=
7COS_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_F7COS
+#  define SET_HTON_VIOC_F7PF_F7COS(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl(val & V=
IOC_F7PF_F7COS_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_F7COS_SHIFTED
+#  define SET_HTON_VIOC_F7PF_F7COS_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl((val<<V=
IOC_F7PF_F7COS_SHIFT)& VIOC_F7PF_F7COS_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_F7COS
+#  define CLR_HTON_VIOC_F7PF_F7COS(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D htonl(~VIOC_F=
7PF_F7COS_MASK))
+#endif
+      /* Priority for VIOCCP (0x0<<24) */
+#     define VIOC_F7PF_Priority0_W     0x00000000
+      /* Reserved1 (0x1<<24) */
+#     define VIOC_F7PF_Priority1_W     0x01000000
+      /* Reserved2 (0x2<<24) */
+#     define VIOC_F7PF_Priority2_W     0x02000000
+      /* Priority for all other traffic (0x3<<24) */
+#     define VIOC_F7PF_Priority3_W     0x03000000
+
+   /* Encapsulation Tag */
+#  define VIOC_F7PF_ENTAG_WORD 0
+#  define VIOC_F7PF_ENTAG_MASK 0x00ff0000
+#  define VIOC_F7PF_ENTAG_SHIFT        16
+#ifndef  GET_VIOC_F7PF_ENTAG
+#  define GET_VIOC_F7PF_ENTAG(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_ENTAG_M=
ASK))
+#endif
+#ifndef  GET_VIOC_F7PF_ENTAG_SHIFTED
+#  define GET_VIOC_F7PF_ENTAG_SHIFTED(p)               \
+               (((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_ENTAG_=
MASK))>>VIOC_F7PF_ENTAG_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_ENTAG
+#  define GET_NTOH_VIOC_F7PF_ENTAG(p)          \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_EN=
TAG_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_ENTAG_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_ENTAG_SHIFTED(p)          \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_E=
NTAG_MASK))>>VIOC_F7PF_ENTAG_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_ENTAG
+#  define SET_VIOC_F7PF_ENTAG(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D (val & VIOC_F=
7PF_ENTAG_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_ENTAG_SHIFTED
+#  define SET_VIOC_F7PF_ENTAG_SHIFTED(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D ((val<<VIOC_F=
7PF_ENTAG_SHIFT)& VIOC_F7PF_ENTAG_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_ENTAG
+#  define CLR_VIOC_F7PF_ENTAG(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D (~VIOC_F7PF_E=
NTAG_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_ENTAG
+#  define SET_HTON_VIOC_F7PF_ENTAG(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl(val & V=
IOC_F7PF_ENTAG_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_ENTAG_SHIFTED
+#  define SET_HTON_VIOC_F7PF_ENTAG_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl((val<<V=
IOC_F7PF_ENTAG_SHIFT)& VIOC_F7PF_ENTAG_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_ENTAG
+#  define CLR_HTON_VIOC_F7PF_ENTAG(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D htonl(~VIOC_F=
7PF_ENTAG_MASK))
+#endif
+      /* Null Encapsulation Tag (Invalid ) (0x0<<16) */
+#     define VIOC_F7PF_ET_NULL_W       0x00000000
+      /* Encap for VIOC Control Protocol Requests (0x1<<16) */
+#     define VIOC_F7PF_ET_VIOCCP_W     0x00010000
+      /* Encap for VIOC Control Protocol Responses (0x2<<16) */
+#     define VIOC_F7PF_ET_VIOCCP_RESP_W        0x00020000
+      /* Encap for VNIC Driver Diagnostics (0x8<<16) */
+#     define VIOC_F7PF_ET_VNIC_DIAG_W  0x00080000
+      /* Ethernet Frame (0x10<<16) */
+#     define VIOC_F7PF_ET_ETH_W        0x00100000
+      /* Ethernet Frame with F7MP payload (0x11<<16) */
+#     define VIOC_F7PF_ET_ETH_F7MP_W   0x00110000
+      /* Ethernet Frame with IP payload (0x12<<16) */
+#     define VIOC_F7PF_ET_ETH_IPV4_W   0x00120000
+      /* Ethernet Frame with IP payload (0x13<<16) */
+#     define VIOC_F7PF_ET_ETH_IPV4_CKS_W       0x00130000
+      /* Ethernet BPDU, LACP Control Protocol (0x18<<16) */
+#     define VIOC_F7PF_ET_ETH_CONTROL_W        0x00180000
+      /* MPLS transit, no Ethernet encap (0x20<<16) */
+#     define VIOC_F7PF_ET_MPLS_W       0x00200000
+      /* IPV4, no Ethernet encap (0x30<<16) */
+#     define VIOC_F7PF_ET_IPV4_W       0x00300000
+      /* F7MP, no Ethernet encap (0xf7<<16) */
+#     define VIOC_F7PF_ET_F7MP_W       0x00f70000
+
+   /* Key Length */
+#  define VIOC_F7PF_EKLEN_WORD 0
+#  define VIOC_F7PF_EKLEN_MASK 0x0000c000
+#  define VIOC_F7PF_EKLEN_SHIFT        14
+#ifndef  GET_VIOC_F7PF_EKLEN
+#  define GET_VIOC_F7PF_EKLEN(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_EKLEN_M=
ASK))
+#endif
+#ifndef  GET_VIOC_F7PF_EKLEN_SHIFTED
+#  define GET_VIOC_F7PF_EKLEN_SHIFTED(p)               \
+               (((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_EKLEN_=
MASK))>>VIOC_F7PF_EKLEN_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_EKLEN
+#  define GET_NTOH_VIOC_F7PF_EKLEN(p)          \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_EK=
LEN_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_EKLEN_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_EKLEN_SHIFTED(p)          \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_E=
KLEN_MASK))>>VIOC_F7PF_EKLEN_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_EKLEN
+#  define SET_VIOC_F7PF_EKLEN(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D (val & VIOC_F=
7PF_EKLEN_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_EKLEN_SHIFTED
+#  define SET_VIOC_F7PF_EKLEN_SHIFTED(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D ((val<<VIOC_F=
7PF_EKLEN_SHIFT)& VIOC_F7PF_EKLEN_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_EKLEN
+#  define CLR_VIOC_F7PF_EKLEN(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D (~VIOC_F7PF_E=
KLEN_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_EKLEN
+#  define SET_HTON_VIOC_F7PF_EKLEN(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl(val & V=
IOC_F7PF_EKLEN_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_EKLEN_SHIFTED
+#  define SET_HTON_VIOC_F7PF_EKLEN_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl((val<<V=
IOC_F7PF_EKLEN_SHIFT)& VIOC_F7PF_EKLEN_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_EKLEN
+#  define CLR_HTON_VIOC_F7PF_EKLEN(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D htonl(~VIOC_F=
7PF_EKLEN_MASK))
+#endif
+
+   /* Packet Length */
+#  define VIOC_F7PF_PKTLEN_WORD        0
+#  define VIOC_F7PF_PKTLEN_MASK        0x00003fff
+#  define VIOC_F7PF_PKTLEN_SHIFT       0
+#ifndef  GET_VIOC_F7PF_PKTLEN
+#  define GET_VIOC_F7PF_PKTLEN(p)              \
+               ((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_PKTLEN_=
MASK))
+#endif
+#ifndef  GET_VIOC_F7PF_PKTLEN_SHIFTED
+#  define GET_VIOC_F7PF_PKTLEN_SHIFTED(p)              \
+               (((((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_PKTLEN=
_MASK))>>VIOC_F7PF_PKTLEN_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_PKTLEN
+#  define GET_NTOH_VIOC_F7PF_PKTLEN(p)         \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_PK=
TLEN_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_PKTLEN_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_PKTLEN_SHIFTED(p)         \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_0)&(VIOC_F7PF_P=
KTLEN_MASK))>>VIOC_F7PF_PKTLEN_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_PKTLEN
+#  define SET_VIOC_F7PF_PKTLEN(p,val)          \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D (val & VIOC_F=
7PF_PKTLEN_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_PKTLEN_SHIFTED
+#  define SET_VIOC_F7PF_PKTLEN_SHIFTED(p,val)          \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D ((val<<VIOC_F=
7PF_PKTLEN_SHIFT)& VIOC_F7PF_PKTLEN_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_PKTLEN
+#  define CLR_VIOC_F7PF_PKTLEN(p)              \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D (~VIOC_F7PF_P=
KTLEN_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_PKTLEN
+#  define SET_HTON_VIOC_F7PF_PKTLEN(p,val)             \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl(val & V=
IOC_F7PF_PKTLEN_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_PKTLEN_SHIFTED
+#  define SET_HTON_VIOC_F7PF_PKTLEN_SHIFTED(p,val)             \
+               ((((struct vioc_f7pf_w *)p)->word_0) |=3D htonl((val<<V=
IOC_F7PF_PKTLEN_SHIFT)& VIOC_F7PF_PKTLEN_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_PKTLEN
+#  define CLR_HTON_VIOC_F7PF_PKTLEN(p)         \
+               ((((struct vioc_f7pf_w *)p)->word_0) &=3D htonl(~VIOC_F=
7PF_PKTLEN_MASK))
+#endif
+
+       u32 word_1;
+
+   /* Destination Fabric address */
+#  define VIOC_F7PF_DSTFABADDR_WORD    1
+#  define VIOC_F7PF_DSTFABADDR_MASK    0xfc000000
+#  define VIOC_F7PF_DSTFABADDR_SHIFT   26
+#ifndef  GET_VIOC_F7PF_DSTFABADDR
+#  define GET_VIOC_F7PF_DSTFABADDR(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_DSTFABA=
DDR_MASK))
+#endif
+#ifndef  GET_VIOC_F7PF_DSTFABADDR_SHIFTED
+#  define GET_VIOC_F7PF_DSTFABADDR_SHIFTED(p)          \
+               (((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_DSTFAB=
ADDR_MASK))>>VIOC_F7PF_DSTFABADDR_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_DSTFABADDR
+#  define GET_NTOH_VIOC_F7PF_DSTFABADDR(p)             \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_DS=
TFABADDR_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_DSTFABADDR_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_DSTFABADDR_SHIFTED(p)             \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_D=
STFABADDR_MASK))>>VIOC_F7PF_DSTFABADDR_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_DSTFABADDR
+#  define SET_VIOC_F7PF_DSTFABADDR(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D (val & VIOC_F=
7PF_DSTFABADDR_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_DSTFABADDR_SHIFTED
+#  define SET_VIOC_F7PF_DSTFABADDR_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D ((val<<VIOC_F=
7PF_DSTFABADDR_SHIFT)& VIOC_F7PF_DSTFABADDR_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_DSTFABADDR
+#  define CLR_VIOC_F7PF_DSTFABADDR(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D (~VIOC_F7PF_D=
STFABADDR_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_DSTFABADDR
+#  define SET_HTON_VIOC_F7PF_DSTFABADDR(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl(val & V=
IOC_F7PF_DSTFABADDR_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_DSTFABADDR_SHIFTED
+#  define SET_HTON_VIOC_F7PF_DSTFABADDR_SHIFTED(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl((val<<V=
IOC_F7PF_DSTFABADDR_SHIFT)& VIOC_F7PF_DSTFABADDR_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_DSTFABADDR
+#  define CLR_HTON_VIOC_F7PF_DSTFABADDR(p)             \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D htonl(~VIOC_F=
7PF_DSTFABADDR_MASK))
+#endif
+
+   /* Destination Sub Address */
+#  define VIOC_F7PF_DSTSUBADDR_WORD    1
+#  define VIOC_F7PF_DSTSUBADDR_MASK    0x03f00000
+#  define VIOC_F7PF_DSTSUBADDR_SHIFT   20
+#ifndef  GET_VIOC_F7PF_DSTSUBADDR
+#  define GET_VIOC_F7PF_DSTSUBADDR(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_DSTSUBA=
DDR_MASK))
+#endif
+#ifndef  GET_VIOC_F7PF_DSTSUBADDR_SHIFTED
+#  define GET_VIOC_F7PF_DSTSUBADDR_SHIFTED(p)          \
+               (((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_DSTSUB=
ADDR_MASK))>>VIOC_F7PF_DSTSUBADDR_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_DSTSUBADDR
+#  define GET_NTOH_VIOC_F7PF_DSTSUBADDR(p)             \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_DS=
TSUBADDR_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_DSTSUBADDR_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_DSTSUBADDR_SHIFTED(p)             \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_D=
STSUBADDR_MASK))>>VIOC_F7PF_DSTSUBADDR_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_DSTSUBADDR
+#  define SET_VIOC_F7PF_DSTSUBADDR(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D (val & VIOC_F=
7PF_DSTSUBADDR_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_DSTSUBADDR_SHIFTED
+#  define SET_VIOC_F7PF_DSTSUBADDR_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D ((val<<VIOC_F=
7PF_DSTSUBADDR_SHIFT)& VIOC_F7PF_DSTSUBADDR_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_DSTSUBADDR
+#  define CLR_VIOC_F7PF_DSTSUBADDR(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D (~VIOC_F7PF_D=
STSUBADDR_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_DSTSUBADDR
+#  define SET_HTON_VIOC_F7PF_DSTSUBADDR(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl(val & V=
IOC_F7PF_DSTSUBADDR_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_DSTSUBADDR_SHIFTED
+#  define SET_HTON_VIOC_F7PF_DSTSUBADDR_SHIFTED(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl((val<<V=
IOC_F7PF_DSTSUBADDR_SHIFT)& VIOC_F7PF_DSTSUBADDR_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_DSTSUBADDR
+#  define CLR_HTON_VIOC_F7PF_DSTSUBADDR(p)             \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D htonl(~VIOC_F=
7PF_DSTSUBADDR_MASK))
+#endif
+
+   /* Reserved */
+#  define VIOC_F7PF_RESERVED_UNI_WORD  1
+#  define VIOC_F7PF_RESERVED_UNI_MASK  0x000f0000
+#  define VIOC_F7PF_RESERVED_UNI_SHIFT 16
+#ifndef  GET_VIOC_F7PF_RESERVED_UNI
+#  define GET_VIOC_F7PF_RESERVED_UNI(p)                \
+               ((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_RESERVE=
D_UNI_MASK))
+#endif
+#ifndef  GET_VIOC_F7PF_RESERVED_UNI_SHIFTED
+#  define GET_VIOC_F7PF_RESERVED_UNI_SHIFTED(p)                \
+               (((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_RESERV=
ED_UNI_MASK))>>VIOC_F7PF_RESERVED_UNI_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_RESERVED_UNI
+#  define GET_NTOH_VIOC_F7PF_RESERVED_UNI(p)           \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_RE=
SERVED_UNI_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_RESERVED_UNI_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_RESERVED_UNI_SHIFTED(p)           \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_R=
ESERVED_UNI_MASK))>>VIOC_F7PF_RESERVED_UNI_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_RESERVED_UNI
+#  define SET_VIOC_F7PF_RESERVED_UNI(p,val)            \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D (val & VIOC_F=
7PF_RESERVED_UNI_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_RESERVED_UNI_SHIFTED
+#  define SET_VIOC_F7PF_RESERVED_UNI_SHIFTED(p,val)            \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D ((val<<VIOC_F=
7PF_RESERVED_UNI_SHIFT)& VIOC_F7PF_RESERVED_UNI_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_RESERVED_UNI
+#  define CLR_VIOC_F7PF_RESERVED_UNI(p)                \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D (~VIOC_F7PF_R=
ESERVED_UNI_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_RESERVED_UNI
+#  define SET_HTON_VIOC_F7PF_RESERVED_UNI(p,val)               \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl(val & V=
IOC_F7PF_RESERVED_UNI_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_RESERVED_UNI_SHIFTED
+#  define SET_HTON_VIOC_F7PF_RESERVED_UNI_SHIFTED(p,val)              =
 \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl((val<<V=
IOC_F7PF_RESERVED_UNI_SHIFT)& VIOC_F7PF_RESERVED_UNI_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_RESERVED_UNI
+#  define CLR_HTON_VIOC_F7PF_RESERVED_UNI(p)           \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D htonl(~VIOC_F=
7PF_RESERVED_UNI_MASK))
+#endif
+
+   /* Source Fabric address */
+#  define VIOC_F7PF_SRCFABADDR_WORD    1
+#  define VIOC_F7PF_SRCFABADDR_MASK    0x0000fc00
+#  define VIOC_F7PF_SRCFABADDR_SHIFT   10
+#ifndef  GET_VIOC_F7PF_SRCFABADDR
+#  define GET_VIOC_F7PF_SRCFABADDR(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_SRCFABA=
DDR_MASK))
+#endif
+#ifndef  GET_VIOC_F7PF_SRCFABADDR_SHIFTED
+#  define GET_VIOC_F7PF_SRCFABADDR_SHIFTED(p)          \
+               (((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_SRCFAB=
ADDR_MASK))>>VIOC_F7PF_SRCFABADDR_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_SRCFABADDR
+#  define GET_NTOH_VIOC_F7PF_SRCFABADDR(p)             \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_SR=
CFABADDR_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_SRCFABADDR_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_SRCFABADDR_SHIFTED(p)             \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_S=
RCFABADDR_MASK))>>VIOC_F7PF_SRCFABADDR_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_SRCFABADDR
+#  define SET_VIOC_F7PF_SRCFABADDR(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D (val & VIOC_F=
7PF_SRCFABADDR_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_SRCFABADDR_SHIFTED
+#  define SET_VIOC_F7PF_SRCFABADDR_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D ((val<<VIOC_F=
7PF_SRCFABADDR_SHIFT)& VIOC_F7PF_SRCFABADDR_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_SRCFABADDR
+#  define CLR_VIOC_F7PF_SRCFABADDR(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D (~VIOC_F7PF_S=
RCFABADDR_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_SRCFABADDR
+#  define SET_HTON_VIOC_F7PF_SRCFABADDR(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl(val & V=
IOC_F7PF_SRCFABADDR_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_SRCFABADDR_SHIFTED
+#  define SET_HTON_VIOC_F7PF_SRCFABADDR_SHIFTED(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl((val<<V=
IOC_F7PF_SRCFABADDR_SHIFT)& VIOC_F7PF_SRCFABADDR_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_SRCFABADDR
+#  define CLR_HTON_VIOC_F7PF_SRCFABADDR(p)             \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D htonl(~VIOC_F=
7PF_SRCFABADDR_MASK))
+#endif
+
+   /* Source Sub Address */
+#  define VIOC_F7PF_SRCSUBADDR_WORD    1
+#  define VIOC_F7PF_SRCSUBADDR_MASK    0x000003f0
+#  define VIOC_F7PF_SRCSUBADDR_SHIFT   4
+#ifndef  GET_VIOC_F7PF_SRCSUBADDR
+#  define GET_VIOC_F7PF_SRCSUBADDR(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_SRCSUBA=
DDR_MASK))
+#endif
+#ifndef  GET_VIOC_F7PF_SRCSUBADDR_SHIFTED
+#  define GET_VIOC_F7PF_SRCSUBADDR_SHIFTED(p)          \
+               (((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_SRCSUB=
ADDR_MASK))>>VIOC_F7PF_SRCSUBADDR_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_SRCSUBADDR
+#  define GET_NTOH_VIOC_F7PF_SRCSUBADDR(p)             \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_SR=
CSUBADDR_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_SRCSUBADDR_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_SRCSUBADDR_SHIFTED(p)             \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_S=
RCSUBADDR_MASK))>>VIOC_F7PF_SRCSUBADDR_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_SRCSUBADDR
+#  define SET_VIOC_F7PF_SRCSUBADDR(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D (val & VIOC_F=
7PF_SRCSUBADDR_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_SRCSUBADDR_SHIFTED
+#  define SET_VIOC_F7PF_SRCSUBADDR_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D ((val<<VIOC_F=
7PF_SRCSUBADDR_SHIFT)& VIOC_F7PF_SRCSUBADDR_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_SRCSUBADDR
+#  define CLR_VIOC_F7PF_SRCSUBADDR(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D (~VIOC_F7PF_S=
RCSUBADDR_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_SRCSUBADDR
+#  define SET_HTON_VIOC_F7PF_SRCSUBADDR(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl(val & V=
IOC_F7PF_SRCSUBADDR_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_SRCSUBADDR_SHIFTED
+#  define SET_HTON_VIOC_F7PF_SRCSUBADDR_SHIFTED(p,val)         \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl((val<<V=
IOC_F7PF_SRCSUBADDR_SHIFT)& VIOC_F7PF_SRCSUBADDR_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_SRCSUBADDR
+#  define CLR_HTON_VIOC_F7PF_SRCSUBADDR(p)             \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D htonl(~VIOC_F=
7PF_SRCSUBADDR_MASK))
+#endif
+
+   /* Source Priority */
+#  define VIOC_F7PF_PRIORITY_WORD      1
+#  define VIOC_F7PF_PRIORITY_MASK      0x0000000f
+#  define VIOC_F7PF_PRIORITY_SHIFT     0
+#ifndef  GET_VIOC_F7PF_PRIORITY
+#  define GET_VIOC_F7PF_PRIORITY(p)            \
+               ((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_PRIORIT=
Y_MASK))
+#endif
+#ifndef  GET_VIOC_F7PF_PRIORITY_SHIFTED
+#  define GET_VIOC_F7PF_PRIORITY_SHIFTED(p)            \
+               (((((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_PRIORI=
TY_MASK))>>VIOC_F7PF_PRIORITY_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_PRIORITY
+#  define GET_NTOH_VIOC_F7PF_PRIORITY(p)               \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_PR=
IORITY_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_PRIORITY_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_PRIORITY_SHIFTED(p)               \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_1)&(VIOC_F7PF_P=
RIORITY_MASK))>>VIOC_F7PF_PRIORITY_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_PRIORITY
+#  define SET_VIOC_F7PF_PRIORITY(p,val)                \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D (val & VIOC_F=
7PF_PRIORITY_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_PRIORITY_SHIFTED
+#  define SET_VIOC_F7PF_PRIORITY_SHIFTED(p,val)                \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D ((val<<VIOC_F=
7PF_PRIORITY_SHIFT)& VIOC_F7PF_PRIORITY_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_PRIORITY
+#  define CLR_VIOC_F7PF_PRIORITY(p)            \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D (~VIOC_F7PF_P=
RIORITY_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_PRIORITY
+#  define SET_HTON_VIOC_F7PF_PRIORITY(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl(val & V=
IOC_F7PF_PRIORITY_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_PRIORITY_SHIFTED
+#  define SET_HTON_VIOC_F7PF_PRIORITY_SHIFTED(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_1) |=3D htonl((val<<V=
IOC_F7PF_PRIORITY_SHIFT)& VIOC_F7PF_PRIORITY_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_PRIORITY
+#  define CLR_HTON_VIOC_F7PF_PRIORITY(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_1) &=3D htonl(~VIOC_F=
7PF_PRIORITY_MASK))
+#endif
+
+       u32 word_2;
+
+   /* Logical Interface Identifier */
+#  define VIOC_F7PF_LIFID_WORD 2
+#  define VIOC_F7PF_LIFID_MASK 0xffff0000
+#  define VIOC_F7PF_LIFID_SHIFT        16
+#ifndef  GET_VIOC_F7PF_LIFID
+#  define GET_VIOC_F7PF_LIFID(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_2)&(VIOC_F7PF_LIFID_M=
ASK))
+#endif
+#ifndef  GET_VIOC_F7PF_LIFID_SHIFTED
+#  define GET_VIOC_F7PF_LIFID_SHIFTED(p)               \
+               (((((struct vioc_f7pf_w *)p)->word_2)&(VIOC_F7PF_LIFID_=
MASK))>>VIOC_F7PF_LIFID_SHIFT)
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_LIFID
+#  define GET_NTOH_VIOC_F7PF_LIFID(p)          \
+               (ntohl(((struct vioc_f7pf_w *)p)->word_2)&(VIOC_F7PF_LI=
=46ID_MASK))
+#endif
+#ifndef  GET_NTOH_VIOC_F7PF_LIFID_SHIFTED
+#  define GET_NTOH_VIOC_F7PF_LIFID_SHIFTED(p)          \
+               ((ntohl(((struct vioc_f7pf_w *)p)->word_2)&(VIOC_F7PF_L=
IFID_MASK))>>VIOC_F7PF_LIFID_SHIFT)
+#endif
+#ifndef  SET_VIOC_F7PF_LIFID
+#  define SET_VIOC_F7PF_LIFID(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_2) |=3D (val & VIOC_F=
7PF_LIFID_MASK))
+#endif
+#ifndef  SET_VIOC_F7PF_LIFID_SHIFTED
+#  define SET_VIOC_F7PF_LIFID_SHIFTED(p,val)           \
+               ((((struct vioc_f7pf_w *)p)->word_2) |=3D ((val<<VIOC_F=
7PF_LIFID_SHIFT)& VIOC_F7PF_LIFID_MASK))
+#endif
+#ifndef  CLR_VIOC_F7PF_LIFID
+#  define CLR_VIOC_F7PF_LIFID(p)               \
+               ((((struct vioc_f7pf_w *)p)->word_2) &=3D (~VIOC_F7PF_L=
IFID_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_LIFID
+#  define SET_HTON_VIOC_F7PF_LIFID(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_2) |=3D htonl(val & V=
IOC_F7PF_LIFID_MASK))
+#endif
+#ifndef  SET_HTON_VIOC_F7PF_LIFID_SHIFTED
+#  define SET_HTON_VIOC_F7PF_LIFID_SHIFTED(p,val)              \
+               ((((struct vioc_f7pf_w *)p)->word_2) |=3D htonl((val<<V=
IOC_F7PF_LIFID_SHIFT)& VIOC_F7PF_LIFID_MASK))
+#endif
+#ifndef  CLR_HTON_VIOC_F7PF_LIFID
+#  define CLR_HTON_VIOC_F7PF_LIFID(p)          \
+               ((((struct vioc_f7pf_w *)p)->word_2) &=3D htonl(~VIOC_F=
7PF_LIFID_MASK))
+#endif
+      /* Local LIF ( Card-Level ) Min Value (0x0<<16) */
+#     define VIOC_F7PF_LOCAL_LIFID_MIN_W       0x00000000
+      /* Local LIF ( Card-Level ) Max Value (0xbfff<<16) */
+#     define VIOC_F7PF_LOCAL_LIFID_MAX_W       0xbfff0000
+      /* Global LIF Min Value (0xc000<<16) */
+#     define VIOC_F7PF_GLOBAL_LIFID_MIN_W      0xc0000000
+      /* Global LIF Max Value (0xffff<<16) */
+#     define VIOC_F7PF_GLOBAL_LIFID_MAX_W      0xffff0000
+
+};
+
+
+extern void vioc_f7pf_copyin(struct vioc_f7pf *p, const u32 *mp);
+extern void vioc_f7pf_copyout(const struct vioc_f7pf *p, u32 *mp);
+
+
+#endif /* _VIOC_PKTS_H_ */
+
diff -puN /dev/null drivers/net/vioc/f7/vioc_veng_registers.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vioc_veng_registers.h
@@ -0,0 +1,299 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+
+#ifndef _VIOC_VENG_REGISTERS_H_
+#define _VIOC_VENG_REGISTERS_H_
+
+// VENG
+/* Fabric Priority Map (15..0) */
+#define VREG_VENG_PRIMAP_MASK  0x0000ffff
+#define VREG_VENG_PRIMAP_ACCESSMODE    2
+#define VREG_VENG_PRIMAP_HOSTPRIVILEGE         0
+#define VREG_VENG_PRIMAP_RESERVEDMASK  0x0000cccc
+#define VREG_VENG_PRIMAP_WRITEMASK     0x00003333
+#define VREG_VENG_PRIMAP_READMASK      0x00003333
+#define VREG_VENG_PRIMAP_CLEARMASK     0x00000000
+#define VREG_VENG_PRIMAP       0x000
+#define VREG_VENG_PRIMAP_ID    0
+
+#define VVAL_VENG_PRIMAP_DEFAULT 0x3210        /* Reset by hreset: Res=
et to identity mapping */
+/* Subfields of PriMap */
+#define VREG_VENG_PRIMAP_RSVD3_MASK    0x0000c000      /* Reserved [14=
=2E.15] */
+#define VREG_VENG_PRIMAP_P3_MASK       0x00003000      /* Map for Prio=
rity 3 [12..13] */
+#define VREG_VENG_PRIMAP_RSVD2_MASK    0x00000c00      /* Reserved [10=
=2E.11] */
+#define VREG_VENG_PRIMAP_P2_MASK       0x00000300      /* Map for Prio=
rity 2 [8..9] */
+#define VREG_VENG_PRIMAP_RSVD1_MASK    0x000000c0      /* Reserved [6.=
=2E7] */
+#define VREG_VENG_PRIMAP_P1_MASK       0x00000030      /* Map for Prio=
rity 1 [4..5] */
+#define VREG_VENG_PRIMAP_RSVD0_MASK    0x0000000c      /* Reserved [2.=
=2E3] */
+#define VREG_VENG_PRIMAP_P0_MASK       0x00000003      /* Map for Prio=
rity 0 [0..1] */
+
+/* 32-bit low bytes of VNIC MAC Address (31..0) */
+#define VREG_VENG_MACADDRLO_MASK       0xffffffff
+#define VREG_VENG_MACADDRLO_ACCESSMODE         2
+#define VREG_VENG_MACADDRLO_HOSTPRIVILEGE      0
+#define VREG_VENG_MACADDRLO_RESERVEDMASK       0x00000000
+#define VREG_VENG_MACADDRLO_WRITEMASK  0xffffffff
+#define VREG_VENG_MACADDRLO_READMASK   0xffffffff
+#define VREG_VENG_MACADDRLO_CLEARMASK  0x00000000
+#define VREG_VENG_MACADDRLO    0x010
+#define VREG_VENG_MACADDRLO_ID         4
+
+/* 16-bit high bytes of VNIC MAC Address (15..0) */
+#define VREG_VENG_MACADDRHI_MASK       0x0000ffff
+#define VREG_VENG_MACADDRHI_ACCESSMODE         2
+#define VREG_VENG_MACADDRHI_HOSTPRIVILEGE      0
+#define VREG_VENG_MACADDRHI_RESERVEDMASK       0x00000000
+#define VREG_VENG_MACADDRHI_WRITEMASK  0x0000ffff
+#define VREG_VENG_MACADDRHI_READMASK   0x0000ffff
+#define VREG_VENG_MACADDRHI_CLEARMASK  0x00000000
+#define VREG_VENG_MACADDRHI    0x014
+#define VREG_VENG_MACADDRHI_ID         5
+
+/* VLAN Tag (13..0) */
+#define VREG_VENG_VLANTAG_MASK         0x00003fff
+#define VREG_VENG_VLANTAG_ACCESSMODE   2
+#define VREG_VENG_VLANTAG_HOSTPRIVILEGE        0
+#define VREG_VENG_VLANTAG_RESERVEDMASK         0x00000000
+#define VREG_VENG_VLANTAG_WRITEMASK    0x00003fff
+#define VREG_VENG_VLANTAG_READMASK     0x00003fff
+#define VREG_VENG_VLANTAG_CLEARMASK    0x00000000
+#define VREG_VENG_VLANTAG      0x018
+#define VREG_VENG_VLANTAG_ID   6
+
+/* Min transmit bandwidth (31..0) */
+#define VREG_VENG_TXMINBW_MASK         0xffffffff
+#define VREG_VENG_TXMINBW_ACCESSMODE   2
+#define VREG_VENG_TXMINBW_HOSTPRIVILEGE        0
+#define VREG_VENG_TXMINBW_RESERVEDMASK         0x3fffff80
+#define VREG_VENG_TXMINBW_WRITEMASK    0xc000007f
+#define VREG_VENG_TXMINBW_READMASK     0xc000007f
+#define VREG_VENG_TXMINBW_CLEARMASK    0x00000000
+#define VREG_VENG_TXMINBW      0x020
+#define VREG_VENG_TXMINBW_ID   8
+    /* Units is 100Mbps of F7 payload */
+
+#define VVAL_VENG_TXMINBW_DEFAULT 0x0  /* Reset by sreset: Reset to 0 =
*/
+/* Subfields of TxMinBW */
+#define VREG_VENG_TXMINBW_DP_MASK      0xc0000000      /* Drop Precede=
nce [30..31] */
+#define VREG_VENG_TXMINBW_RSVD_MASK    0x3fffff80      /* Reserved [7.=
=2E29] */
+#define VREG_VENG_TXMINBW_MINBW_MASK   0x0000007f      /* Bandwidth in=
 100Mbps [0..6] */
+
+/* Max transmit bandwidth (31..0) */
+#define VREG_VENG_TXMAXBW_MASK         0xffffffff
+#define VREG_VENG_TXMAXBW_ACCESSMODE   2
+#define VREG_VENG_TXMAXBW_HOSTPRIVILEGE        0
+#define VREG_VENG_TXMAXBW_RESERVEDMASK         0x3fffff80
+#define VREG_VENG_TXMAXBW_WRITEMASK    0xc000007f
+#define VREG_VENG_TXMAXBW_READMASK     0xc000007f
+#define VREG_VENG_TXMAXBW_CLEARMASK    0x00000000
+#define VREG_VENG_TXMAXBW      0x024
+#define VREG_VENG_TXMAXBW_ID   9
+    /* Units is 100Mbps of F7 payload */
+
+#define VVAL_VENG_TXMAXBW_DEFAULT 0x0  /* Reset by sreset: Reset to 0 =
*/
+/* Subfields of TxMaxBW */
+#define VREG_VENG_TXMAXBW_DP_MASK      0xc0000000      /* Drop Precede=
nce [30..31] */
+#define VREG_VENG_TXMAXBW_RSVD_MASK    0x3fffff80      /* Reserved [7.=
=2E29] */
+#define VREG_VENG_TXMAXBW_MAXBW_MASK   0x0000007f      /* Bandwidth in=
 100Mbps [0..6] */
+
+/* Weight for arbitration among VNIC Tx Queues (5..0) */
+#define VREG_VENG_TXWRR_MASK   0x0000003f
+#define VREG_VENG_TXWRR_ACCESSMODE     2
+#define VREG_VENG_TXWRR_HOSTPRIVILEGE  0
+#define VREG_VENG_TXWRR_RESERVEDMASK   0x00000000
+#define VREG_VENG_TXWRR_WRITEMASK      0x0000003f
+#define VREG_VENG_TXWRR_READMASK       0x0000003f
+#define VREG_VENG_TXWRR_CLEARMASK      0x00000000
+#define VREG_VENG_TXWRR        0x028
+#define VREG_VENG_TXWRR_ID     10
+
+#define VVAL_VENG_TXWRR_DEFAULT 0x0    /* Reset by sreset: Reset to 0 =
*/
+
+
+/* Tx Interrupt Control Register (15..0) */
+#define VREG_VENG_TXINTCTL_MASK        0x0000ffff
+#define VREG_VENG_TXINTCTL_ACCESSMODE  2
+#define VREG_VENG_TXINTCTL_HOSTPRIVILEGE       1
+#define VREG_VENG_TXINTCTL_RESERVEDMASK        0x00007ff0
+#define VREG_VENG_TXINTCTL_WRITEMASK   0x0000800f
+#define VREG_VENG_TXINTCTL_READMASK    0x0000800f
+#define VREG_VENG_TXINTCTL_CLEARMASK   0x00000000
+#define VREG_VENG_TXINTCTL     0x040
+#define VREG_VENG_TXINTCTL_ID  16
+
+#define VVAL_VENG_TXINTCTL_DEFAULT 0x0         /* Reset by sreset: Res=
et to 0 */
+/* Subfields of TxIntCtl */
+#define VREG_VENG_TXINTCTL_INTONEMPTY_MASK     0x00008000      /* When=
 asserted send interrupt on transition to Empty [15..15] */
+#define VREG_VENG_TXINTCTL_RSVD0_MASK  0x00007ff0      /* Unused [4..1=
4] */
+#define VREG_VENG_TXINTCTL_INTNUM_MASK 0x0000000f      /* Interrupt nu=
mber to send [0..3] */
+
+
+
+
+/* Blast cell counter (31..0) */
+#define VREG_VENG_CNTR_BLAST_V0_MASK   0xffffffff
+#define VREG_VENG_CNTR_BLAST_V0_ACCESSMODE     1
+#define VREG_VENG_CNTR_BLAST_V0_HOSTPRIVILEGE  1
+#define VREG_VENG_CNTR_BLAST_V0_RESERVEDMASK   0x00000000
+#define VREG_VENG_CNTR_BLAST_V0_WRITEMASK      0x00000000
+#define VREG_VENG_CNTR_BLAST_V0_READMASK       0xffffffff
+#define VREG_VENG_CNTR_BLAST_V0_CLEARMASK      0x00000000
+#define VREG_VENG_CNTR_BLAST_V0        0x050
+#define VREG_VENG_CNTR_BLAST_V0_ID     20
+
+#define VVAL_VENG_CNTR_BLAST_V0_DEFAULT 0x0    /* Reset by sreset: Res=
et to 0 */
+
+
+/* C6tx cell counter (31..0) */
+#define VREG_VENG_CNTR_C6TXPHY_V0_MASK         0xffffffff
+#define VREG_VENG_CNTR_C6TXPHY_V0_ACCESSMODE   1
+#define VREG_VENG_CNTR_C6TXPHY_V0_HOSTPRIVILEGE        1
+#define VREG_VENG_CNTR_C6TXPHY_V0_RESERVEDMASK         0x00000000
+#define VREG_VENG_CNTR_C6TXPHY_V0_WRITEMASK    0x00000000
+#define VREG_VENG_CNTR_C6TXPHY_V0_READMASK     0xffffffff
+#define VREG_VENG_CNTR_C6TXPHY_V0_CLEARMASK    0x00000000
+#define VREG_VENG_CNTR_C6TXPHY_V0      0x054
+#define VREG_VENG_CNTR_C6TXPHY_V0_ID   21
+
+#define VVAL_VENG_CNTR_C6TXPHY_V0_DEFAULT 0x0  /* Reset by sreset: Res=
et to 0 */
+
+
+/* TxD Queue Definition - Base address (31..0) */
+#define VREG_VENG_TXD_W0_MASK  0xffffffff
+#define VREG_VENG_TXD_W0_ACCESSMODE    2
+#define VREG_VENG_TXD_W0_HOSTPRIVILEGE         1
+#define VREG_VENG_TXD_W0_RESERVEDMASK  0x0000003f
+#define VREG_VENG_TXD_W0_WRITEMASK     0xffffffc0
+#define VREG_VENG_TXD_W0_READMASK      0xffffffc0
+#define VREG_VENG_TXD_W0_CLEARMASK     0x00000000
+#define VREG_VENG_TXD_W0       0x100
+#define VREG_VENG_TXD_W0_ID    64
+
+/* Subfields of TxD_W0 */
+#define VREG_VENG_TXD_W0_BA_LO_MASK    0xffffffc0      /* Bits 31:6 of=
 the TxD ring base address [6..31] */
+#define VREG_VENG_TXD_W0_RSV_MASK      0x0000003f      /* Reserved [0.=
=2E5] */
+
+
+
+
+/* TxD Queue Definition (31..0) */
+#define VREG_VENG_TXD_W1_MASK  0xffffffff
+#define VREG_VENG_TXD_W1_ACCESSMODE    2
+#define VREG_VENG_TXD_W1_HOSTPRIVILEGE         1
+#define VREG_VENG_TXD_W1_RESERVEDMASK  0xff000000
+#define VREG_VENG_TXD_W1_WRITEMASK     0x00ffffff
+#define VREG_VENG_TXD_W1_READMASK      0x00ffffff
+#define VREG_VENG_TXD_W1_CLEARMASK     0x00000000
+#define VREG_VENG_TXD_W1       0x104
+#define VREG_VENG_TXD_W1_ID    65
+
+/* Subfields of TxD_W1 */
+#define VREG_VENG_TXD_W1_RSV1_MASK     0xff000000      /* Reserved [24=
=2E.31] */
+#define VREG_VENG_TXD_W1_SIZE_MASK     0x00ffff00      /* Number of de=
scriptors in the queue [8..23] */
+#define VREG_VENG_TXD_W1_BA_HI_MASK    0x000000ff      /* Bits 39:32 o=
f base address [0..7] */
+
+
+
+
+/* TxD Queue Status (31..0) */
+#define VREG_VENG_TXD_CTL_MASK         0xffffffff
+#define VREG_VENG_TXD_CTL_ACCESSMODE   2
+#define VREG_VENG_TXD_CTL_HOSTPRIVILEGE        1
+#define VREG_VENG_TXD_CTL_RESERVEDMASK         0xc000fc38
+#define VREG_VENG_TXD_CTL_WRITEMASK    0x000000c7
+#define VREG_VENG_TXD_CTL_READMASK     0x3fff03c7
+#define VREG_VENG_TXD_CTL_CLEARMASK    0x000000c0
+#define VREG_VENG_TXD_CTL      0x108
+#define VREG_VENG_TXD_CTL_ID   66
+    /*
+     * When 1 causes the Q to transition from Empty to Active.
+     * HW clears this bit after the transition
+     */
+
+/* Subfields of TxD_Ctl */
+#define VREG_VENG_TXD_CTL_RSV1_MASK    0xc0000000      /* Reserved [30=
=2E.31] */
+#define VREG_VENG_TXD_CTL_CURRRDPTR_MASK       0x3fff0000      /* Offs=
et in TxD of NEXT descriptor to be used [16..29] */
+#define VREG_VENG_TXD_CTL_RSV2_MASK    0x0000fc00      /* Reserved [10=
=2E.15] */
+#define VREG_VENG_TXD_CTL_TXSTATE_MASK 0x00000300      /* VNIC Tx Stat=
e [8..9] */
+#define VVAL_VENG_TXD_CTL_TXSTATE_DISABLED 0x0         /* Disabled */
+#define VVAL_VENG_TXD_CTL_TXSTATE_PAUSED 0x100         /* Paused */
+#define VVAL_VENG_TXD_CTL_TXSTATE_EMPTY 0x200  /* Empty */
+#define VVAL_VENG_TXD_CTL_TXSTATE_ACTIVE 0x300         /* Active */
+#define VREG_VENG_TXD_CTL_ERROR_MASK   0x00000080      /* Error detect=
ed while processing ring [7..7] */
+#define VREG_VENG_TXD_CTL_INVDESC_MASK 0x00000040      /* An Invalid d=
escriptor found mid packet [6..6] */
+#define VREG_VENG_TXD_CTL_RSV3_MASK    0x00000038      /* Reserved [3.=
=2E5] */
+#define VREG_VENG_TXD_CTL_QENABLE_MASK 0x00000004      /* Enable/Disab=
le the Tx Q [2..2] */
+#define VREG_VENG_TXD_CTL_QPAUSE_MASK  0x00000002      /* Force the Q =
to Pause state [1..1] */
+#define VREG_VENG_TXD_CTL_QRING_MASK   0x00000001      /* Ring the doo=
rbell for the Queue [0..0] */
+
+/* VNIC Transmit Q Control Register (31..0) */
+#define VREG_VENG_TXQ_CFG_MASK         0xffffffff
+#define VREG_VENG_TXQ_CFG_ACCESSMODE   2
+#define VREG_VENG_TXQ_CFG_HOSTPRIVILEGE        0
+#define VREG_VENG_TXQ_CFG_RESERVEDMASK         0xfffff8ff
+#define VREG_VENG_TXQ_CFG_WRITEMASK    0x00000700
+#define VREG_VENG_TXQ_CFG_READMASK     0x00000700
+#define VREG_VENG_TXQ_CFG_CLEARMASK    0x00000000
+#define VREG_VENG_TXQ_CFG      0x10c
+#define VREG_VENG_TXQ_CFG_ID   67
+
+#define VVAL_VENG_TXQ_CFG_DEFAULT 0x0  /* Reset by sreset: Reset to 0 =
*/
+/* Subfields of TxQ_Cfg */
+#define VREG_VENG_TXQ_CFG_RSVD0_MASK   0xfffff800      /* Reserved [11=
=2E.31] */
+#define VREG_VENG_TXQ_CFG_O_MASK       0x00000400      /* Override the=
 COS field from the packet header [10..10] */
+#define VREG_VENG_TXQ_CFG_PRI_MASK     0x00000300      /* Fabric Prior=
ity to be used [8..9] */
+#define VREG_VENG_TXQ_CFG_RSVD2_MASK   0x000000ff      /* Reserved [0.=
=2E7] */
+
+
+
+
+/* Base address of LAG Table (31..0) */
+#define VREG_VENG_LAGTBLBASE_MASK      0xffffffff
+#define VREG_VENG_LAGTBLBASE_ACCESSMODE        2
+#define VREG_VENG_LAGTBLBASE_HOSTPRIVILEGE     0
+#define VREG_VENG_LAGTBLBASE_RESERVEDMASK      0x00000000
+#define VREG_VENG_LAGTBLBASE_WRITEMASK         0xffffffff
+#define VREG_VENG_LAGTBLBASE_READMASK  0xffffffff
+#define VREG_VENG_LAGTBLBASE_CLEARMASK         0x00000000
+#define VREG_VENG_LAGTBLBASE   0x400
+#define VREG_VENG_LAGTBLBASE_ID        256
+
+
+/* Collection of internal SRAM parity error (31..0) */
+#define VREG_VENG_PARERR_MASK  0xffffffff
+#define VREG_VENG_PARERR_ACCESSMODE    3
+#define VREG_VENG_PARERR_HOSTPRIVILEGE         1
+#define VREG_VENG_PARERR_RESERVEDMASK  0x00000000
+#define VREG_VENG_PARERR_WRITEMASK     0xffffffff
+#define VREG_VENG_PARERR_READMASK      0xffffffff
+#define VREG_VENG_PARERR_CLEARMASK     0xffffffff
+#define VREG_VENG_PARERR       0xf00
+#define VREG_VENG_PARERR_ID    960
+
+#define VVAL_VENG_PARERR_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+#endif /* _VIOC_VENG_REGISTERS_H_ */
diff -puN /dev/null drivers/net/vioc/f7/vioc_ving_registers.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vioc_ving_registers.h
@@ -0,0 +1,327 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+
+#ifndef _VIOC_VING_REGISTERS_H_
+#define _VIOC_VIOG_REGISTERS_H_
+
+/* Module VING:16 */
+
+/* Priority 0 flow control threshold for Shared Memory (8..0) */
+#define VREG_VING_BUFTH1_MASK  0x000001ff
+#define VREG_VING_BUFTH1_ACCESSMODE    2
+#define VREG_VING_BUFTH1_HOSTPRIVILEGE         1
+#define VREG_VING_BUFTH1_RESERVEDMASK  0x00000000
+#define VREG_VING_BUFTH1_WRITEMASK     0x000001ff
+#define VREG_VING_BUFTH1_READMASK      0x000001ff
+#define VREG_VING_BUFTH1_CLEARMASK     0x00000000
+#define VREG_VING_BUFTH1       0x000
+#define VREG_VING_BUFTH1_ID    0
+
+#define VVAL_VING_BUFTH1_DEFAULT 0x0   /* Reset by sreset: Reset to 0 =
*/
+
+
+/* Priority 1 flow control threshold for Shared Memory (8..0) */
+#define VREG_VING_BUFTH2_MASK  0x000001ff
+#define VREG_VING_BUFTH2_ACCESSMODE    2
+#define VREG_VING_BUFTH2_HOSTPRIVILEGE         1
+#define VREG_VING_BUFTH2_RESERVEDMASK  0x00000000
+#define VREG_VING_BUFTH2_WRITEMASK     0x000001ff
+#define VREG_VING_BUFTH2_READMASK      0x000001ff
+#define VREG_VING_BUFTH2_CLEARMASK     0x00000000
+#define VREG_VING_BUFTH2       0x004
+#define VREG_VING_BUFTH2_ID    1
+
+#define VVAL_VING_BUFTH2_DEFAULT 0x0   /* Reset by sreset: Reset to 0 =
*/
+
+
+/* Priority 2 flow control threshold for Shared Memory (8..0) */
+#define VREG_VING_BUFTH3_MASK  0x000001ff
+#define VREG_VING_BUFTH3_ACCESSMODE    2
+#define VREG_VING_BUFTH3_HOSTPRIVILEGE         1
+#define VREG_VING_BUFTH3_RESERVEDMASK  0x00000000
+#define VREG_VING_BUFTH3_WRITEMASK     0x000001ff
+#define VREG_VING_BUFTH3_READMASK      0x000001ff
+#define VREG_VING_BUFTH3_CLEARMASK     0x00000000
+#define VREG_VING_BUFTH3       0x008
+#define VREG_VING_BUFTH3_ID    2
+
+#define VVAL_VING_BUFTH3_DEFAULT 0x0   /* Reset by sreset: Reset to 0 =
*/
+
+
+/* Priority 3 flow control threshold for Shared Memory (8..0) */
+#define VREG_VING_BUFTH4_MASK  0x000001ff
+#define VREG_VING_BUFTH4_ACCESSMODE    2
+#define VREG_VING_BUFTH4_HOSTPRIVILEGE         1
+#define VREG_VING_BUFTH4_RESERVEDMASK  0x00000000
+#define VREG_VING_BUFTH4_WRITEMASK     0x000001ff
+#define VREG_VING_BUFTH4_READMASK      0x000001ff
+#define VREG_VING_BUFTH4_CLEARMASK     0x00000000
+#define VREG_VING_BUFTH4       0x00c
+#define VREG_VING_BUFTH4_ID    3
+
+#define VVAL_VING_BUFTH4_DEFAULT 0x0   /* Reset by sreset: Reset to 0 =
*/
+
+
+/* Number of MC bufs remaining before drop Class 0 (8..0) */
+#define VREG_VING_MCDROPTH1_MASK       0x000001ff
+#define VREG_VING_MCDROPTH1_ACCESSMODE         2
+#define VREG_VING_MCDROPTH1_HOSTPRIVILEGE      1
+#define VREG_VING_MCDROPTH1_RESERVEDMASK       0x00000000
+#define VREG_VING_MCDROPTH1_WRITEMASK  0x000001ff
+#define VREG_VING_MCDROPTH1_READMASK   0x000001ff
+#define VREG_VING_MCDROPTH1_CLEARMASK  0x00000000
+#define VREG_VING_MCDROPTH1    0x010
+#define VREG_VING_MCDROPTH1_ID         4
+
+#define VVAL_VING_MCDROPTH1_DEFAULT 0x100      /* Reset by sreset: Res=
et to 256 */
+
+
+/* Number of MC bufs remaining before drop Class 1 (8..0) */
+#define VREG_VING_MCDROPTH2_MASK       0x000001ff
+#define VREG_VING_MCDROPTH2_ACCESSMODE         2
+#define VREG_VING_MCDROPTH2_HOSTPRIVILEGE      1
+#define VREG_VING_MCDROPTH2_RESERVEDMASK       0x00000000
+#define VREG_VING_MCDROPTH2_WRITEMASK  0x000001ff
+#define VREG_VING_MCDROPTH2_READMASK   0x000001ff
+#define VREG_VING_MCDROPTH2_CLEARMASK  0x00000000
+#define VREG_VING_MCDROPTH2    0x014
+#define VREG_VING_MCDROPTH2_ID         5
+
+#define VVAL_VING_MCDROPTH2_DEFAULT 0xc8       /* Reset by sreset: Res=
et to 200 */
+
+
+/* Number of MC bufs remaining before drop Class 2 (8..0) */
+#define VREG_VING_MCDROPTH3_MASK       0x000001ff
+#define VREG_VING_MCDROPTH3_ACCESSMODE         2
+#define VREG_VING_MCDROPTH3_HOSTPRIVILEGE      1
+#define VREG_VING_MCDROPTH3_RESERVEDMASK       0x00000000
+#define VREG_VING_MCDROPTH3_WRITEMASK  0x000001ff
+#define VREG_VING_MCDROPTH3_READMASK   0x000001ff
+#define VREG_VING_MCDROPTH3_CLEARMASK  0x00000000
+#define VREG_VING_MCDROPTH3    0x018
+#define VREG_VING_MCDROPTH3_ID         6
+
+#define VVAL_VING_MCDROPTH3_DEFAULT 0x96       /* Reset by sreset: Res=
et to 150 */
+
+
+/* Number of MC bufs remaining before drop Class 3 (8..0) */
+#define VREG_VING_MCDROPTH4_MASK       0x000001ff
+#define VREG_VING_MCDROPTH4_ACCESSMODE         2
+#define VREG_VING_MCDROPTH4_HOSTPRIVILEGE      1
+#define VREG_VING_MCDROPTH4_RESERVEDMASK       0x00000000
+#define VREG_VING_MCDROPTH4_WRITEMASK  0x000001ff
+#define VREG_VING_MCDROPTH4_READMASK   0x000001ff
+#define VREG_VING_MCDROPTH4_CLEARMASK  0x00000000
+#define VREG_VING_MCDROPTH4    0x01c
+#define VREG_VING_MCDROPTH4_ID         7
+
+#define VVAL_VING_MCDROPTH4_DEFAULT 0x80       /* Reset by sreset: Res=
et to 128 */
+
+
+/* Count of Cells arriving at inglcu (31..0) */
+#define VREG_VING_CNTR_CELLS_MASK      0xffffffff
+#define VREG_VING_CNTR_CELLS_ACCESSMODE        1
+#define VREG_VING_CNTR_CELLS_HOSTPRIVILEGE     1
+#define VREG_VING_CNTR_CELLS_RESERVEDMASK      0x00000000
+#define VREG_VING_CNTR_CELLS_WRITEMASK         0x00000000
+#define VREG_VING_CNTR_CELLS_READMASK  0xffffffff
+#define VREG_VING_CNTR_CELLS_CLEARMASK         0x00000000
+#define VREG_VING_CNTR_CELLS   0x100
+#define VREG_VING_CNTR_CELLS_ID        64
+
+#define VVAL_VING_CNTR_CELLS_DEFAULT 0x0       /* Reset by sreset: Res=
et to 0 */
+
+
+/* Count of Cells queued in Shared Memory (31..0) */
+#define VREG_VING_CNTR_CELLSQUEUED_MASK        0xffffffff
+#define VREG_VING_CNTR_CELLSQUEUED_ACCESSMODE  1
+#define VREG_VING_CNTR_CELLSQUEUED_HOSTPRIVILEGE       1
+#define VREG_VING_CNTR_CELLSQUEUED_RESERVEDMASK        0x00000000
+#define VREG_VING_CNTR_CELLSQUEUED_WRITEMASK   0x00000000
+#define VREG_VING_CNTR_CELLSQUEUED_READMASK    0xffffffff
+#define VREG_VING_CNTR_CELLSQUEUED_CLEARMASK   0x00000000
+#define VREG_VING_CNTR_CELLSQUEUED     0x104
+#define VREG_VING_CNTR_CELLSQUEUED_ID  65
+
+#define VVAL_VING_CNTR_CELLSQUEUED_DEFAULT 0x0         /* Reset by sre=
set: Reset to 0 */
+
+
+/* Count of SOP Cells queued in Shared Memory (31..0) */
+#define VREG_VING_CNTR_PKTSQUEUED_MASK         0xffffffff
+#define VREG_VING_CNTR_PKTSQUEUED_ACCESSMODE   1
+#define VREG_VING_CNTR_PKTSQUEUED_HOSTPRIVILEGE        1
+#define VREG_VING_CNTR_PKTSQUEUED_RESERVEDMASK         0x00000000
+#define VREG_VING_CNTR_PKTSQUEUED_WRITEMASK    0x00000000
+#define VREG_VING_CNTR_PKTSQUEUED_READMASK     0xffffffff
+#define VREG_VING_CNTR_PKTSQUEUED_CLEARMASK    0x00000000
+#define VREG_VING_CNTR_PKTSQUEUED      0x108
+#define VREG_VING_CNTR_PKTSQUEUED_ID   66
+
+#define VVAL_VING_CNTR_PKTSQUEUED_DEFAULT 0x0  /* Reset by sreset: Res=
et to 0 */
+
+
+/* Count of Packets Dropped because VNIC q is not enabled (31..0) */
+#define VREG_VING_CNTR_DROPNOQUEUE_MASK        0xffffffff
+#define VREG_VING_CNTR_DROPNOQUEUE_ACCESSMODE  1
+#define VREG_VING_CNTR_DROPNOQUEUE_HOSTPRIVILEGE       1
+#define VREG_VING_CNTR_DROPNOQUEUE_RESERVEDMASK        0x00000000
+#define VREG_VING_CNTR_DROPNOQUEUE_WRITEMASK   0x00000000
+#define VREG_VING_CNTR_DROPNOQUEUE_READMASK    0xffffffff
+#define VREG_VING_CNTR_DROPNOQUEUE_CLEARMASK   0x00000000
+#define VREG_VING_CNTR_DROPNOQUEUE     0x10c
+#define VREG_VING_CNTR_DROPNOQUEUE_ID  67
+
+#define VVAL_VING_CNTR_DROPNOQUEUE_DEFAULT 0x0         /* Reset by sre=
set: Reset to 0 */
+
+
+/* Count of Packets Dropped because MC lookup failed (31..0) */
+#define VREG_VING_CNTR_DROPMCLOOKUP_MASK       0xffffffff
+#define VREG_VING_CNTR_DROPMCLOOKUP_ACCESSMODE         1
+#define VREG_VING_CNTR_DROPMCLOOKUP_HOSTPRIVILEGE      1
+#define VREG_VING_CNTR_DROPMCLOOKUP_RESERVEDMASK       0x00000000
+#define VREG_VING_CNTR_DROPMCLOOKUP_WRITEMASK  0x00000000
+#define VREG_VING_CNTR_DROPMCLOOKUP_READMASK   0xffffffff
+#define VREG_VING_CNTR_DROPMCLOOKUP_CLEARMASK  0x00000000
+#define VREG_VING_CNTR_DROPMCLOOKUP    0x110
+#define VREG_VING_CNTR_DROPMCLOOKUP_ID         68
+
+#define VVAL_VING_CNTR_DROPMCLOOKUP_DEFAULT 0x0        /* Reset by sre=
set: Reset to 0 */
+
+
+/* Count of cells Dropped because of cell CRC Error (31..0) */
+#define VREG_VING_CNTR_C6RXCRCERR_MASK         0xffffffff
+#define VREG_VING_CNTR_C6RXCRCERR_ACCESSMODE   1
+#define VREG_VING_CNTR_C6RXCRCERR_HOSTPRIVILEGE        1
+#define VREG_VING_CNTR_C6RXCRCERR_RESERVEDMASK         0x00000000
+#define VREG_VING_CNTR_C6RXCRCERR_WRITEMASK    0x00000000
+#define VREG_VING_CNTR_C6RXCRCERR_READMASK     0xffffffff
+#define VREG_VING_CNTR_C6RXCRCERR_CLEARMASK    0x00000000
+#define VREG_VING_CNTR_C6RXCRCERR      0x114
+#define VREG_VING_CNTR_C6RXCRCERR_ID   69
+
+#define VVAL_VING_CNTR_C6RXCRCERR_DEFAULT 0x0  /* Reset by sreset: Res=
et to 0 */
+
+
+/* Count of cells Dropped because of cell HPar Error (31..0) */
+#define VREG_VING_CNTR_C6RXHPARERR_MASK        0xffffffff
+#define VREG_VING_CNTR_C6RXHPARERR_ACCESSMODE  1
+#define VREG_VING_CNTR_C6RXHPARERR_HOSTPRIVILEGE       1
+#define VREG_VING_CNTR_C6RXHPARERR_RESERVEDMASK        0x00000000
+#define VREG_VING_CNTR_C6RXHPARERR_WRITEMASK   0x00000000
+#define VREG_VING_CNTR_C6RXHPARERR_READMASK    0xffffffff
+#define VREG_VING_CNTR_C6RXHPARERR_CLEARMASK   0x00000000
+#define VREG_VING_CNTR_C6RXHPARERR     0x118
+#define VREG_VING_CNTR_C6RXHPARERR_ID  70
+
+#define VVAL_VING_CNTR_C6RXHPARERR_DEFAULT 0x0         /* Reset by sre=
set: Reset to 0 */
+
+
+/* Count of cells Dropped because of cell VPar Error (31..0) */
+#define VREG_VING_CNTR_C6RXVPARERR_MASK        0xffffffff
+#define VREG_VING_CNTR_C6RXVPARERR_ACCESSMODE  1
+#define VREG_VING_CNTR_C6RXVPARERR_HOSTPRIVILEGE       1
+#define VREG_VING_CNTR_C6RXVPARERR_RESERVEDMASK        0x00000000
+#define VREG_VING_CNTR_C6RXVPARERR_WRITEMASK   0x00000000
+#define VREG_VING_CNTR_C6RXVPARERR_READMASK    0xffffffff
+#define VREG_VING_CNTR_C6RXVPARERR_CLEARMASK   0x00000000
+#define VREG_VING_CNTR_C6RXVPARERR     0x11c
+#define VREG_VING_CNTR_C6RXVPARERR_ID  71
+
+#define VVAL_VING_CNTR_C6RXVPARERR_DEFAULT 0x0         /* Reset by sre=
set: Reset to 0 */
+
+
+/* Count of cells Dropped because of Framing Error (31..0) */
+#define VREG_VING_CNTR_C6RXFRAMEERR_MASK       0xffffffff
+#define VREG_VING_CNTR_C6RXFRAMEERR_ACCESSMODE         1
+#define VREG_VING_CNTR_C6RXFRAMEERR_HOSTPRIVILEGE      1
+#define VREG_VING_CNTR_C6RXFRAMEERR_RESERVEDMASK       0x00000000
+#define VREG_VING_CNTR_C6RXFRAMEERR_WRITEMASK  0x00000000
+#define VREG_VING_CNTR_C6RXFRAMEERR_READMASK   0xffffffff
+#define VREG_VING_CNTR_C6RXFRAMEERR_CLEARMASK  0x00000000
+#define VREG_VING_CNTR_C6RXFRAMEERR    0x120
+#define VREG_VING_CNTR_C6RXFRAMEERR_ID         72
+
+#define VVAL_VING_CNTR_C6RXFRAMEERR_DEFAULT 0x0        /* Reset by sre=
set: Reset to 0 */
+
+
+/* Maximum Bandwidth allowed for this VNIC (31..0) */
+#define VREG_VING_MAXBW_MASK   0xffffffff
+#define VREG_VING_MAXBW_ACCESSMODE     2
+#define VREG_VING_MAXBW_HOSTPRIVILEGE  0
+#define VREG_VING_MAXBW_RESERVEDMASK   0xf0000080
+#define VREG_VING_MAXBW_WRITEMASK      0x0fffff7f
+#define VREG_VING_MAXBW_READMASK       0x0fffff7f
+#define VREG_VING_MAXBW_CLEARMASK      0x00000000
+#define VREG_VING_MAXBW        0x200
+#define VREG_VING_MAXBW_ID     128
+
+#define VVAL_VING_MAXBW_DEFAULT 0x0    /* Reset by hreset: 0 means no =
limit is enforced */
+/* Subfields of MaxBW */
+#define VREG_VING_MAXBW_RSV0_MASK      0xf0000000      /* Reserved [28=
=2E.31] */
+#define VREG_VING_MAXBW_CBS_MASK       0x0fffff00      /* Committed Bu=
rst Size in 64 bytes [8..27] */
+#define VREG_VING_MAXBW_RSV1_MASK      0x00000080      /* Reserved [7.=
=2E7] */
+#define VREG_VING_MAXBW_CIR_MASK       0x0000007f      /* Committed In=
formation Rate in 100 Mbps [0..6] */
+
+
+
+
+/* Context Scrub Control Register (31..0) */
+#define VREG_VING_CONTEXTSCRUB_MASK    0xffffffff
+#define VREG_VING_CONTEXTSCRUB_ACCESSMODE      2
+#define VREG_VING_CONTEXTSCRUB_HOSTPRIVILEGE   1
+#define VREG_VING_CONTEXTSCRUB_RESERVEDMASK    0x7fffffe0
+#define VREG_VING_CONTEXTSCRUB_WRITEMASK       0x8000001f
+#define VREG_VING_CONTEXTSCRUB_READMASK        0x8000001f
+#define VREG_VING_CONTEXTSCRUB_CLEARMASK       0x00000000
+#define VREG_VING_CONTEXTSCRUB         0x300
+#define VREG_VING_CONTEXTSCRUB_ID      192
+
+#define VVAL_VING_CONTEXTSCRUB_DEFAULT 0x0     /* Reset by sreset: Res=
et to 0 */
+/* Subfields of ContextScrub */
+#define VREG_VING_CONTEXTSCRUB_ENABLE_MASK     0x80000000      /* Enab=
le Context Scrubber [31..31] */
+#define VREG_VING_CONTEXTSCRUB_RSV0_MASK       0x7fffffe0      /* Rese=
rved [5..30] */
+#define VREG_VING_CONTEXTSCRUB_RATE_MASK       0x0000001f      /* Scru=
b Rate - .3 sec to 10 sec [0..4] */
+
+
+
+
+/* Collection of internal SRAM parity error (31..0) */
+#define VREG_VING_PARERR_MASK  0xffffffff
+#define VREG_VING_PARERR_ACCESSMODE    3
+#define VREG_VING_PARERR_HOSTPRIVILEGE         1
+#define VREG_VING_PARERR_RESERVEDMASK  0x00000000
+#define VREG_VING_PARERR_WRITEMASK     0xffffffff
+#define VREG_VING_PARERR_READMASK      0xffffffff
+#define VREG_VING_PARERR_CLEARMASK     0xffffffff
+#define VREG_VING_PARERR       0xf00
+#define VREG_VING_PARERR_ID    960
+
+#define VVAL_VING_PARERR_DEFAULT 0x0   /* Reset by hreset: Reset to 0 =
*/
+
+#endif /* VIOC_VING_REGISTERS_H_ */
+
+
diff -puN /dev/null drivers/net/vioc/f7/vnic_defs.h
--- /dev/null
+++ a/drivers/net/vioc/f7/vnic_defs.h
@@ -0,0 +1,2168 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+
+#ifndef _VNIC_H_
+#define _VNIC_H_
+
+struct tx_pktBufDesc_Phys_w {
+       u32 word_0;
+
+   /* Lower 32-Bits of 40-Bit Phys addr of buffer */
+#  define VNIC_TX_BUFADDR_LO_WORD      0
+#  define VNIC_TX_BUFADDR_LO_MASK      0xffffffff
+#  define VNIC_TX_BUFADDR_LO_SHIFT     0
+#ifndef  GET_VNIC_TX_BUFADDR_LO
+#  define GET_VNIC_TX_BUFADDR_LO(p)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_0)&(VNIC_TX_=
BUFADDR_LO_MASK))
+#endif
+#ifndef  GET_VNIC_TX_BUFADDR_LO_SHIFTED
+#  define GET_VNIC_TX_BUFADDR_LO_SHIFTED(p)            \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_0)&(VNIC_TX=
_BUFADDR_LO_MASK))>>VNIC_TX_BUFADDR_LO_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_BUFADDR_LO
+#  define GET_NTOH_VNIC_TX_BUFADDR_LO(p)               \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_0)&(VNI=
C_TX_BUFADDR_LO_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_BUFADDR_LO_SHIFTED
+#  define GET_NTOH_VNIC_TX_BUFADDR_LO_SHIFTED(p)               \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_0)&(VN=
IC_TX_BUFADDR_LO_MASK))>>VNIC_TX_BUFADDR_LO_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_BUFADDR_LO
+#  define SET_VNIC_TX_BUFADDR_LO(p,val)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_0) |=3D (val=
 & VNIC_TX_BUFADDR_LO_MASK))
+#endif
+#ifndef  SET_VNIC_TX_BUFADDR_LO_SHIFTED
+#  define SET_VNIC_TX_BUFADDR_LO_SHIFTED(p,val)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_0) |=3D ((va=
l<<VNIC_TX_BUFADDR_LO_SHIFT)& VNIC_TX_BUFADDR_LO_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_BUFADDR_LO
+#  define CLR_VNIC_TX_BUFADDR_LO(p)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_0) &=3D (~VN=
IC_TX_BUFADDR_LO_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_BUFADDR_LO
+#  define SET_HTON_VNIC_TX_BUFADDR_LO(p,val)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_0) |=3D hton=
l(val & VNIC_TX_BUFADDR_LO_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_BUFADDR_LO_SHIFTED
+#  define SET_HTON_VNIC_TX_BUFADDR_LO_SHIFTED(p,val)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_0) |=3D hton=
l((val<<VNIC_TX_BUFADDR_LO_SHIFT)& VNIC_TX_BUFADDR_LO_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_BUFADDR_LO
+#  define CLR_HTON_VNIC_TX_BUFADDR_LO(p)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_0) &=3D hton=
l(~VNIC_TX_BUFADDR_LO_MASK))
+#endif
+
+       u32 word_1;
+
+   /* SW makes descriptor usable by VIOC HW */
+#  define VNIC_TX_HANDED_WORD  1
+#  define VNIC_TX_HANDED_MASK  0x80000000
+#  define VNIC_TX_HANDED_SHIFT 31
+#ifndef  GET_VNIC_TX_HANDED
+#  define GET_VNIC_TX_HANDED(p)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
HANDED_MASK))
+#endif
+#ifndef  GET_VNIC_TX_HANDED_SHIFTED
+#  define GET_VNIC_TX_HANDED_SHIFTED(p)                \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_HANDED_MASK))>>VNIC_TX_HANDED_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_HANDED
+#  define GET_NTOH_VNIC_TX_HANDED(p)           \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_HANDED_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_HANDED_SHIFTED
+#  define GET_NTOH_VNIC_TX_HANDED_SHIFTED(p)           \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_HANDED_MASK))>>VNIC_TX_HANDED_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_HANDED
+#  define SET_VNIC_TX_HANDED(p,val)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_HANDED_MASK))
+#endif
+#ifndef  SET_VNIC_TX_HANDED_SHIFTED
+#  define SET_VNIC_TX_HANDED_SHIFTED(p,val)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_HANDED_SHIFT)& VNIC_TX_HANDED_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_HANDED
+#  define CLR_VNIC_TX_HANDED(p)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_HANDED_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_HANDED
+#  define SET_HTON_VNIC_TX_HANDED(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_HANDED_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_HANDED_SHIFTED
+#  define SET_HTON_VNIC_TX_HANDED_SHIFTED(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_HANDED_SHIFT)& VNIC_TX_HANDED_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_HANDED
+#  define CLR_HTON_VNIC_TX_HANDED(p)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_HANDED_MASK))
+#endif
+      /* Handed to VIOC HW (0x1<<31) */
+#     define VNIC_TX_HANDED_HW_W       0x80000000
+
+   /* indicates the validiti of the sts field */
+#  define VNIC_TX_VALID_WORD   1
+#  define VNIC_TX_VALID_MASK   0x40000000
+#  define VNIC_TX_VALID_SHIFT  30
+#ifndef  GET_VNIC_TX_VALID
+#  define GET_VNIC_TX_VALID(p)         \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
VALID_MASK))
+#endif
+#ifndef  GET_VNIC_TX_VALID_SHIFTED
+#  define GET_VNIC_TX_VALID_SHIFTED(p)         \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_VALID_MASK))>>VNIC_TX_VALID_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_VALID
+#  define GET_NTOH_VNIC_TX_VALID(p)            \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_VALID_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_VALID_SHIFTED
+#  define GET_NTOH_VNIC_TX_VALID_SHIFTED(p)            \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_VALID_MASK))>>VNIC_TX_VALID_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_VALID
+#  define SET_VNIC_TX_VALID(p,val)             \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_VALID_MASK))
+#endif
+#ifndef  SET_VNIC_TX_VALID_SHIFTED
+#  define SET_VNIC_TX_VALID_SHIFTED(p,val)             \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_VALID_SHIFT)& VNIC_TX_VALID_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_VALID
+#  define CLR_VNIC_TX_VALID(p)         \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_VALID_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_VALID
+#  define SET_HTON_VNIC_TX_VALID(p,val)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_VALID_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_VALID_SHIFTED
+#  define SET_HTON_VNIC_TX_VALID_SHIFTED(p,val)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_VALID_SHIFT)& VNIC_TX_VALID_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_VALID
+#  define CLR_HTON_VNIC_TX_VALID(p)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_VALID_MASK))
+#endif
+      /* sts field is valid (0x1<<30) */
+#     define VNIC_TX_VALID_W   0x40000000
+
+   /* status set by VIOC HW after handling descriptor */
+#  define VNIC_TX_STS_WORD     1
+#  define VNIC_TX_STS_MASK     0x38000000
+#  define VNIC_TX_STS_SHIFT    27
+#ifndef  GET_VNIC_TX_STS
+#  define GET_VNIC_TX_STS(p)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
STS_MASK))
+#endif
+#ifndef  GET_VNIC_TX_STS_SHIFTED
+#  define GET_VNIC_TX_STS_SHIFTED(p)           \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_STS_MASK))>>VNIC_TX_STS_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_STS
+#  define GET_NTOH_VNIC_TX_STS(p)              \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_STS_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_STS_SHIFTED
+#  define GET_NTOH_VNIC_TX_STS_SHIFTED(p)              \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_STS_MASK))>>VNIC_TX_STS_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_STS
+#  define SET_VNIC_TX_STS(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_STS_MASK))
+#endif
+#ifndef  SET_VNIC_TX_STS_SHIFTED
+#  define SET_VNIC_TX_STS_SHIFTED(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_STS_SHIFT)& VNIC_TX_STS_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_STS
+#  define CLR_VNIC_TX_STS(p)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_STS_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_STS
+#  define SET_HTON_VNIC_TX_STS(p,val)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_STS_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_STS_SHIFTED
+#  define SET_HTON_VNIC_TX_STS_SHIFTED(p,val)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_STS_SHIFT)& VNIC_TX_STS_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_STS
+#  define CLR_HTON_VNIC_TX_STS(p)              \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_STS_MASK))
+#endif
+      /* Transmit successful; (0x0<<27) */
+#     define VNIC_TX_TX_OK_W   0x00000000
+      /* SOP too short (0x1<<27) */
+#     define VNIC_TX_RUNT_SOP_W        0x08000000
+      /* SOP framing error (0x2<<27) */
+#     define VNIC_TX_SOP_FRAME_ERR_W   0x10000000
+      /* MOP framing error (0x3<<27) */
+#     define VNIC_TX_MOP_FRAME_ERR_W   0x18000000
+      /* MOP framing error (0x4<<27) */
+#     define VNIC_TX_LENGTH_ERR_W      0x20000000
+
+   /* Reserved */
+#  define VNIC_TX_RSRVD_WORD   1
+#  define VNIC_TX_RSRVD_MASK   0x04000000
+#  define VNIC_TX_RSRVD_SHIFT  26
+#ifndef  GET_VNIC_TX_RSRVD
+#  define GET_VNIC_TX_RSRVD(p)         \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
RSRVD_MASK))
+#endif
+#ifndef  GET_VNIC_TX_RSRVD_SHIFTED
+#  define GET_VNIC_TX_RSRVD_SHIFTED(p)         \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_RSRVD_MASK))>>VNIC_TX_RSRVD_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_RSRVD
+#  define GET_NTOH_VNIC_TX_RSRVD(p)            \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_RSRVD_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_RSRVD_SHIFTED
+#  define GET_NTOH_VNIC_TX_RSRVD_SHIFTED(p)            \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_RSRVD_MASK))>>VNIC_TX_RSRVD_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_RSRVD
+#  define SET_VNIC_TX_RSRVD(p,val)             \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_RSRVD_MASK))
+#endif
+#ifndef  SET_VNIC_TX_RSRVD_SHIFTED
+#  define SET_VNIC_TX_RSRVD_SHIFTED(p,val)             \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_RSRVD_SHIFT)& VNIC_TX_RSRVD_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_RSRVD
+#  define CLR_VNIC_TX_RSRVD(p)         \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_RSRVD_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_RSRVD
+#  define SET_HTON_VNIC_TX_RSRVD(p,val)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_RSRVD_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_RSRVD_SHIFTED
+#  define SET_HTON_VNIC_TX_RSRVD_SHIFTED(p,val)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_RSRVD_SHIFT)& VNIC_TX_RSRVD_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_RSRVD
+#  define CLR_HTON_VNIC_TX_RSRVD(p)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_RSRVD_MASK))
+#endif
+      /* Reserved (0x0<<26) */
+#     define VNIC_TX_RSRVD_W   0x00000000
+
+   /* Transmit interrupt request */
+#  define VNIC_TX_INTR_REQ_WORD        1
+#  define VNIC_TX_INTR_REQ_MASK        0x02000000
+#  define VNIC_TX_INTR_REQ_SHIFT       25
+#ifndef  GET_VNIC_TX_INTR_REQ
+#  define GET_VNIC_TX_INTR_REQ(p)              \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
INTR_REQ_MASK))
+#endif
+#ifndef  GET_VNIC_TX_INTR_REQ_SHIFTED
+#  define GET_VNIC_TX_INTR_REQ_SHIFTED(p)              \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_INTR_REQ_MASK))>>VNIC_TX_INTR_REQ_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_INTR_REQ
+#  define GET_NTOH_VNIC_TX_INTR_REQ(p)         \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_INTR_REQ_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_INTR_REQ_SHIFTED
+#  define GET_NTOH_VNIC_TX_INTR_REQ_SHIFTED(p)         \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_INTR_REQ_MASK))>>VNIC_TX_INTR_REQ_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_INTR_REQ
+#  define SET_VNIC_TX_INTR_REQ(p,val)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_INTR_REQ_MASK))
+#endif
+#ifndef  SET_VNIC_TX_INTR_REQ_SHIFTED
+#  define SET_VNIC_TX_INTR_REQ_SHIFTED(p,val)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_INTR_REQ_SHIFT)& VNIC_TX_INTR_REQ_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_INTR_REQ
+#  define CLR_VNIC_TX_INTR_REQ(p)              \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_INTR_REQ_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_INTR_REQ
+#  define SET_HTON_VNIC_TX_INTR_REQ(p,val)             \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_INTR_REQ_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_INTR_REQ_SHIFTED
+#  define SET_HTON_VNIC_TX_INTR_REQ_SHIFTED(p,val)             \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_INTR_REQ_SHIFT)& VNIC_TX_INTR_REQ_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_INTR_REQ
+#  define CLR_HTON_VNIC_TX_INTR_REQ(p)         \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_INTR_REQ_MASK))
+#endif
+      /* Yes, Interrupt on xmt complete (0x1<<25) */
+#     define VNIC_TX_INTR_W    0x02000000
+
+   /* Checksum trailer request */
+#  define VNIC_TX_IP_CKSUM_REQ_WORD    1
+#  define VNIC_TX_IP_CKSUM_REQ_MASK    0x01000000
+#  define VNIC_TX_IP_CKSUM_REQ_SHIFT   24
+#ifndef  GET_VNIC_TX_IP_CKSUM_REQ
+#  define GET_VNIC_TX_IP_CKSUM_REQ(p)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
IP_CKSUM_REQ_MASK))
+#endif
+#ifndef  GET_VNIC_TX_IP_CKSUM_REQ_SHIFTED
+#  define GET_VNIC_TX_IP_CKSUM_REQ_SHIFTED(p)          \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_IP_CKSUM_REQ_MASK))>>VNIC_TX_IP_CKSUM_REQ_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_IP_CKSUM_REQ
+#  define GET_NTOH_VNIC_TX_IP_CKSUM_REQ(p)             \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_IP_CKSUM_REQ_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_IP_CKSUM_REQ_SHIFTED
+#  define GET_NTOH_VNIC_TX_IP_CKSUM_REQ_SHIFTED(p)             \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_IP_CKSUM_REQ_MASK))>>VNIC_TX_IP_CKSUM_REQ_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_IP_CKSUM_REQ
+#  define SET_VNIC_TX_IP_CKSUM_REQ(p,val)              \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_IP_CKSUM_REQ_MASK))
+#endif
+#ifndef  SET_VNIC_TX_IP_CKSUM_REQ_SHIFTED
+#  define SET_VNIC_TX_IP_CKSUM_REQ_SHIFTED(p,val)              \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_IP_CKSUM_REQ_SHIFT)& VNIC_TX_IP_CKSUM_REQ_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_IP_CKSUM_REQ
+#  define CLR_VNIC_TX_IP_CKSUM_REQ(p)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_IP_CKSUM_REQ_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_IP_CKSUM_REQ
+#  define SET_HTON_VNIC_TX_IP_CKSUM_REQ(p,val)         \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_IP_CKSUM_REQ_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_IP_CKSUM_REQ_SHIFTED
+#  define SET_HTON_VNIC_TX_IP_CKSUM_REQ_SHIFTED(p,val)         \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_IP_CKSUM_REQ_SHIFT)& VNIC_TX_IP_CKSUM_REQ_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_IP_CKSUM_REQ
+#  define CLR_HTON_VNIC_TX_IP_CKSUM_REQ(p)             \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_IP_CKSUM_REQ_MASK))
+#endif
+      /* Yes (0x1<<24) */
+#     define VNIC_TX_IP_CKSUM_W        0x01000000
+
+   /* first segment of the pkt */
+#  define VNIC_TX_SOP_WORD     1
+#  define VNIC_TX_SOP_MASK     0x00800000
+#  define VNIC_TX_SOP_SHIFT    23
+#ifndef  GET_VNIC_TX_SOP
+#  define GET_VNIC_TX_SOP(p)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
SOP_MASK))
+#endif
+#ifndef  GET_VNIC_TX_SOP_SHIFTED
+#  define GET_VNIC_TX_SOP_SHIFTED(p)           \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_SOP_MASK))>>VNIC_TX_SOP_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_SOP
+#  define GET_NTOH_VNIC_TX_SOP(p)              \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_SOP_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_SOP_SHIFTED
+#  define GET_NTOH_VNIC_TX_SOP_SHIFTED(p)              \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_SOP_MASK))>>VNIC_TX_SOP_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_SOP
+#  define SET_VNIC_TX_SOP(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_SOP_MASK))
+#endif
+#ifndef  SET_VNIC_TX_SOP_SHIFTED
+#  define SET_VNIC_TX_SOP_SHIFTED(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_SOP_SHIFT)& VNIC_TX_SOP_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_SOP
+#  define CLR_VNIC_TX_SOP(p)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_SOP_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_SOP
+#  define SET_HTON_VNIC_TX_SOP(p,val)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_SOP_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_SOP_SHIFTED
+#  define SET_HTON_VNIC_TX_SOP_SHIFTED(p,val)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_SOP_SHIFT)& VNIC_TX_SOP_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_SOP
+#  define CLR_HTON_VNIC_TX_SOP(p)              \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_SOP_MASK))
+#endif
+      /* Yes (0x1<<23) */
+#     define VNIC_TX_SOP_W     0x00800000
+
+   /* last segment of the pkt */
+#  define VNIC_TX_EOP_WORD     1
+#  define VNIC_TX_EOP_MASK     0x00400000
+#  define VNIC_TX_EOP_SHIFT    22
+#ifndef  GET_VNIC_TX_EOP
+#  define GET_VNIC_TX_EOP(p)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
EOP_MASK))
+#endif
+#ifndef  GET_VNIC_TX_EOP_SHIFTED
+#  define GET_VNIC_TX_EOP_SHIFTED(p)           \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_EOP_MASK))>>VNIC_TX_EOP_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_EOP
+#  define GET_NTOH_VNIC_TX_EOP(p)              \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_EOP_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_EOP_SHIFTED
+#  define GET_NTOH_VNIC_TX_EOP_SHIFTED(p)              \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_EOP_MASK))>>VNIC_TX_EOP_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_EOP
+#  define SET_VNIC_TX_EOP(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_EOP_MASK))
+#endif
+#ifndef  SET_VNIC_TX_EOP_SHIFTED
+#  define SET_VNIC_TX_EOP_SHIFTED(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_EOP_SHIFT)& VNIC_TX_EOP_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_EOP
+#  define CLR_VNIC_TX_EOP(p)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_EOP_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_EOP
+#  define SET_HTON_VNIC_TX_EOP(p,val)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_EOP_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_EOP_SHIFTED
+#  define SET_HTON_VNIC_TX_EOP_SHIFTED(p,val)          \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_EOP_SHIFT)& VNIC_TX_EOP_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_EOP
+#  define CLR_HTON_VNIC_TX_EOP(p)              \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_EOP_MASK))
+#endif
+      /* Yes (0x1<<22) */
+#     define VNIC_TX_EOP_W     0x00400000
+
+   /* 14-Bits length in bytes to transmit */
+#  define VNIC_TX_BUFLEN_WORD  1
+#  define VNIC_TX_BUFLEN_MASK  0x003fff00
+#  define VNIC_TX_BUFLEN_SHIFT 8
+#ifndef  GET_VNIC_TX_BUFLEN
+#  define GET_VNIC_TX_BUFLEN(p)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
BUFLEN_MASK))
+#endif
+#ifndef  GET_VNIC_TX_BUFLEN_SHIFTED
+#  define GET_VNIC_TX_BUFLEN_SHIFTED(p)                \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_BUFLEN_MASK))>>VNIC_TX_BUFLEN_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_BUFLEN
+#  define GET_NTOH_VNIC_TX_BUFLEN(p)           \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_BUFLEN_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_BUFLEN_SHIFTED
+#  define GET_NTOH_VNIC_TX_BUFLEN_SHIFTED(p)           \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_BUFLEN_MASK))>>VNIC_TX_BUFLEN_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_BUFLEN
+#  define SET_VNIC_TX_BUFLEN(p,val)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_BUFLEN_MASK))
+#endif
+#ifndef  SET_VNIC_TX_BUFLEN_SHIFTED
+#  define SET_VNIC_TX_BUFLEN_SHIFTED(p,val)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_BUFLEN_SHIFT)& VNIC_TX_BUFLEN_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_BUFLEN
+#  define CLR_VNIC_TX_BUFLEN(p)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_BUFLEN_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_BUFLEN
+#  define SET_HTON_VNIC_TX_BUFLEN(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_BUFLEN_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_BUFLEN_SHIFTED
+#  define SET_HTON_VNIC_TX_BUFLEN_SHIFTED(p,val)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_BUFLEN_SHIFT)& VNIC_TX_BUFLEN_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_BUFLEN
+#  define CLR_HTON_VNIC_TX_BUFLEN(p)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_BUFLEN_MASK))
+#endif
+
+   /* Top 8-Bits of 40-Bit Phys address of buffer */
+#  define VNIC_TX_BUFADDR_HI_WORD      1
+#  define VNIC_TX_BUFADDR_HI_MASK      0x000000ff
+#  define VNIC_TX_BUFADDR_HI_SHIFT     0
+#ifndef  GET_VNIC_TX_BUFADDR_HI
+#  define GET_VNIC_TX_BUFADDR_HI(p)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX_=
BUFADDR_HI_MASK))
+#endif
+#ifndef  GET_VNIC_TX_BUFADDR_HI_SHIFTED
+#  define GET_VNIC_TX_BUFADDR_HI_SHIFTED(p)            \
+               (((((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
_BUFADDR_HI_MASK))>>VNIC_TX_BUFADDR_HI_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TX_BUFADDR_HI
+#  define GET_NTOH_VNIC_TX_BUFADDR_HI(p)               \
+               (ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_TX_BUFADDR_HI_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TX_BUFADDR_HI_SHIFTED
+#  define GET_NTOH_VNIC_TX_BUFADDR_HI_SHIFTED(p)               \
+               ((ntohl(((struct tx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TX_BUFADDR_HI_MASK))>>VNIC_TX_BUFADDR_HI_SHIFT)
+#endif
+#ifndef  SET_VNIC_TX_BUFADDR_HI
+#  define SET_VNIC_TX_BUFADDR_HI(p,val)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_TX_BUFADDR_HI_MASK))
+#endif
+#ifndef  SET_VNIC_TX_BUFADDR_HI_SHIFTED
+#  define SET_VNIC_TX_BUFADDR_HI_SHIFTED(p,val)                \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_TX_BUFADDR_HI_SHIFT)& VNIC_TX_BUFADDR_HI_MASK))
+#endif
+#ifndef  CLR_VNIC_TX_BUFADDR_HI
+#  define CLR_VNIC_TX_BUFADDR_HI(p)            \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_TX_BUFADDR_HI_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_BUFADDR_HI
+#  define SET_HTON_VNIC_TX_BUFADDR_HI(p,val)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_TX_BUFADDR_HI_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TX_BUFADDR_HI_SHIFTED
+#  define SET_HTON_VNIC_TX_BUFADDR_HI_SHIFTED(p,val)           \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_TX_BUFADDR_HI_SHIFT)& VNIC_TX_BUFADDR_HI_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TX_BUFADDR_HI
+#  define CLR_HTON_VNIC_TX_BUFADDR_HI(p)               \
+               ((((struct tx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_TX_BUFADDR_HI_MASK))
+#endif
+
+};
+
+struct txd_pktBufDesc_Phys_w {
+       u32 word_0;
+
+   /* RESERVED */
+#  define VNIC_TXD_UNUSED0_WORD        0
+#  define VNIC_TXD_UNUSED0_MASK        0xffffffff
+#  define VNIC_TXD_UNUSED0_SHIFT       0
+#ifndef  GET_VNIC_TXD_UNUSED0
+#  define GET_VNIC_TXD_UNUSED0(p)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_0)&(VNIC_TX=
D_UNUSED0_MASK))
+#endif
+#ifndef  GET_VNIC_TXD_UNUSED0_SHIFTED
+#  define GET_VNIC_TXD_UNUSED0_SHIFTED(p)              \
+               (((((struct txd_pktBufDesc_Phys_w *)p)->word_0)&(VNIC_T=
XD_UNUSED0_MASK))>>VNIC_TXD_UNUSED0_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_UNUSED0
+#  define GET_NTOH_VNIC_TXD_UNUSED0(p)         \
+               (ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_0)&(VN=
IC_TXD_UNUSED0_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_UNUSED0_SHIFTED
+#  define GET_NTOH_VNIC_TXD_UNUSED0_SHIFTED(p)         \
+               ((ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_0)&(V=
NIC_TXD_UNUSED0_MASK))>>VNIC_TXD_UNUSED0_SHIFT)
+#endif
+#ifndef  SET_VNIC_TXD_UNUSED0
+#  define SET_VNIC_TXD_UNUSED0(p,val)          \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_0) |=3D (va=
l & VNIC_TXD_UNUSED0_MASK))
+#endif
+#ifndef  SET_VNIC_TXD_UNUSED0_SHIFTED
+#  define SET_VNIC_TXD_UNUSED0_SHIFTED(p,val)          \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_0) |=3D ((v=
al<<VNIC_TXD_UNUSED0_SHIFT)& VNIC_TXD_UNUSED0_MASK))
+#endif
+#ifndef  CLR_VNIC_TXD_UNUSED0
+#  define CLR_VNIC_TXD_UNUSED0(p)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_0) &=3D (~V=
NIC_TXD_UNUSED0_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_UNUSED0
+#  define SET_HTON_VNIC_TXD_UNUSED0(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_0) |=3D hto=
nl(val & VNIC_TXD_UNUSED0_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_UNUSED0_SHIFTED
+#  define SET_HTON_VNIC_TXD_UNUSED0_SHIFTED(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_0) |=3D hto=
nl((val<<VNIC_TXD_UNUSED0_SHIFT)& VNIC_TXD_UNUSED0_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TXD_UNUSED0
+#  define CLR_HTON_VNIC_TXD_UNUSED0(p)         \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_0) &=3D hto=
nl(~VNIC_TXD_UNUSED0_MASK))
+#endif
+
+       u32 word_1;
+
+   /* Ownership of the descriptor */
+#  define VNIC_TXD_OWNED_WORD  1
+#  define VNIC_TXD_OWNED_MASK  0x80000000
+#  define VNIC_TXD_OWNED_SHIFT 31
+#ifndef  GET_VNIC_TXD_OWNED
+#  define GET_VNIC_TXD_OWNED(p)                \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
D_OWNED_MASK))
+#endif
+#ifndef  GET_VNIC_TXD_OWNED_SHIFTED
+#  define GET_VNIC_TXD_OWNED_SHIFTED(p)                \
+               (((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_T=
XD_OWNED_MASK))>>VNIC_TXD_OWNED_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_OWNED
+#  define GET_NTOH_VNIC_TXD_OWNED(p)           \
+               (ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TXD_OWNED_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_OWNED_SHIFTED
+#  define GET_NTOH_VNIC_TXD_OWNED_SHIFTED(p)           \
+               ((ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(V=
NIC_TXD_OWNED_MASK))>>VNIC_TXD_OWNED_SHIFT)
+#endif
+#ifndef  SET_VNIC_TXD_OWNED
+#  define SET_VNIC_TXD_OWNED(p,val)            \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D (va=
l & VNIC_TXD_OWNED_MASK))
+#endif
+#ifndef  SET_VNIC_TXD_OWNED_SHIFTED
+#  define SET_VNIC_TXD_OWNED_SHIFTED(p,val)            \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D ((v=
al<<VNIC_TXD_OWNED_SHIFT)& VNIC_TXD_OWNED_MASK))
+#endif
+#ifndef  CLR_VNIC_TXD_OWNED
+#  define CLR_VNIC_TXD_OWNED(p)                \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D (~V=
NIC_TXD_OWNED_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_OWNED
+#  define SET_HTON_VNIC_TXD_OWNED(p,val)               \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl(val & VNIC_TXD_OWNED_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_OWNED_SHIFTED
+#  define SET_HTON_VNIC_TXD_OWNED_SHIFTED(p,val)               \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl((val<<VNIC_TXD_OWNED_SHIFT)& VNIC_TXD_OWNED_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TXD_OWNED
+#  define CLR_HTON_VNIC_TXD_OWNED(p)           \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D hto=
nl(~VNIC_TXD_OWNED_MASK))
+#endif
+      /* Desc Active, Owned by HW (0x1<<31) */
+#     define VNIC_TXD_OWNED_HW_W       0x80000000
+
+   /* Determines status of the operation posted */
+#  define VNIC_TXD_STATUS_WORD 1
+#  define VNIC_TXD_STATUS_MASK 0x40000000
+#  define VNIC_TXD_STATUS_SHIFT        30
+#ifndef  GET_VNIC_TXD_STATUS
+#  define GET_VNIC_TXD_STATUS(p)               \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
D_STATUS_MASK))
+#endif
+#ifndef  GET_VNIC_TXD_STATUS_SHIFTED
+#  define GET_VNIC_TXD_STATUS_SHIFTED(p)               \
+               (((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_T=
XD_STATUS_MASK))>>VNIC_TXD_STATUS_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_STATUS
+#  define GET_NTOH_VNIC_TXD_STATUS(p)          \
+               (ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TXD_STATUS_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_STATUS_SHIFTED
+#  define GET_NTOH_VNIC_TXD_STATUS_SHIFTED(p)          \
+               ((ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(V=
NIC_TXD_STATUS_MASK))>>VNIC_TXD_STATUS_SHIFT)
+#endif
+#ifndef  SET_VNIC_TXD_STATUS
+#  define SET_VNIC_TXD_STATUS(p,val)           \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D (va=
l & VNIC_TXD_STATUS_MASK))
+#endif
+#ifndef  SET_VNIC_TXD_STATUS_SHIFTED
+#  define SET_VNIC_TXD_STATUS_SHIFTED(p,val)           \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D ((v=
al<<VNIC_TXD_STATUS_SHIFT)& VNIC_TXD_STATUS_MASK))
+#endif
+#ifndef  CLR_VNIC_TXD_STATUS
+#  define CLR_VNIC_TXD_STATUS(p)               \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D (~V=
NIC_TXD_STATUS_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_STATUS
+#  define SET_HTON_VNIC_TXD_STATUS(p,val)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl(val & VNIC_TXD_STATUS_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_STATUS_SHIFTED
+#  define SET_HTON_VNIC_TXD_STATUS_SHIFTED(p,val)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl((val<<VNIC_TXD_STATUS_SHIFT)& VNIC_TXD_STATUS_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TXD_STATUS
+#  define CLR_HTON_VNIC_TXD_STATUS(p)          \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D hto=
nl(~VNIC_TXD_STATUS_MASK))
+#endif
+      /* Posted, posted to VIOC (0x1<<30) */
+#     define VNIC_TXD_STATUS_POSTED_W  0x40000000
+
+   /* RESERVED */
+#  define VNIC_TXD_UNUSED1_WORD        1
+#  define VNIC_TXD_UNUSED1_MASK        0x3e000000
+#  define VNIC_TXD_UNUSED1_SHIFT       25
+#ifndef  GET_VNIC_TXD_UNUSED1
+#  define GET_VNIC_TXD_UNUSED1(p)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
D_UNUSED1_MASK))
+#endif
+#ifndef  GET_VNIC_TXD_UNUSED1_SHIFTED
+#  define GET_VNIC_TXD_UNUSED1_SHIFTED(p)              \
+               (((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_T=
XD_UNUSED1_MASK))>>VNIC_TXD_UNUSED1_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_UNUSED1
+#  define GET_NTOH_VNIC_TXD_UNUSED1(p)         \
+               (ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TXD_UNUSED1_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_UNUSED1_SHIFTED
+#  define GET_NTOH_VNIC_TXD_UNUSED1_SHIFTED(p)         \
+               ((ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(V=
NIC_TXD_UNUSED1_MASK))>>VNIC_TXD_UNUSED1_SHIFT)
+#endif
+#ifndef  SET_VNIC_TXD_UNUSED1
+#  define SET_VNIC_TXD_UNUSED1(p,val)          \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D (va=
l & VNIC_TXD_UNUSED1_MASK))
+#endif
+#ifndef  SET_VNIC_TXD_UNUSED1_SHIFTED
+#  define SET_VNIC_TXD_UNUSED1_SHIFTED(p,val)          \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D ((v=
al<<VNIC_TXD_UNUSED1_SHIFT)& VNIC_TXD_UNUSED1_MASK))
+#endif
+#ifndef  CLR_VNIC_TXD_UNUSED1
+#  define CLR_VNIC_TXD_UNUSED1(p)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D (~V=
NIC_TXD_UNUSED1_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_UNUSED1
+#  define SET_HTON_VNIC_TXD_UNUSED1(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl(val & VNIC_TXD_UNUSED1_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_UNUSED1_SHIFTED
+#  define SET_HTON_VNIC_TXD_UNUSED1_SHIFTED(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl((val<<VNIC_TXD_UNUSED1_SHIFT)& VNIC_TXD_UNUSED1_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TXD_UNUSED1
+#  define CLR_HTON_VNIC_TXD_UNUSED1(p)         \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D hto=
nl(~VNIC_TXD_UNUSED1_MASK))
+#endif
+
+   /* VIOC transmit continuation */
+#  define VNIC_TXD_CONTINUATION_WORD   1
+#  define VNIC_TXD_CONTINUATION_MASK   0x01000000
+#  define VNIC_TXD_CONTINUATION_SHIFT  24
+#ifndef  GET_VNIC_TXD_CONTINUATION
+#  define GET_VNIC_TXD_CONTINUATION(p)         \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
D_CONTINUATION_MASK))
+#endif
+#ifndef  GET_VNIC_TXD_CONTINUATION_SHIFTED
+#  define GET_VNIC_TXD_CONTINUATION_SHIFTED(p)         \
+               (((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_T=
XD_CONTINUATION_MASK))>>VNIC_TXD_CONTINUATION_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_CONTINUATION
+#  define GET_NTOH_VNIC_TXD_CONTINUATION(p)            \
+               (ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TXD_CONTINUATION_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_CONTINUATION_SHIFTED
+#  define GET_NTOH_VNIC_TXD_CONTINUATION_SHIFTED(p)            \
+               ((ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(V=
NIC_TXD_CONTINUATION_MASK))>>VNIC_TXD_CONTINUATION_SHIFT)
+#endif
+#ifndef  SET_VNIC_TXD_CONTINUATION
+#  define SET_VNIC_TXD_CONTINUATION(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D (va=
l & VNIC_TXD_CONTINUATION_MASK))
+#endif
+#ifndef  SET_VNIC_TXD_CONTINUATION_SHIFTED
+#  define SET_VNIC_TXD_CONTINUATION_SHIFTED(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D ((v=
al<<VNIC_TXD_CONTINUATION_SHIFT)& VNIC_TXD_CONTINUATION_MASK))
+#endif
+#ifndef  CLR_VNIC_TXD_CONTINUATION
+#  define CLR_VNIC_TXD_CONTINUATION(p)         \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D (~V=
NIC_TXD_CONTINUATION_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_CONTINUATION
+#  define SET_HTON_VNIC_TXD_CONTINUATION(p,val)                \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl(val & VNIC_TXD_CONTINUATION_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_CONTINUATION_SHIFTED
+#  define SET_HTON_VNIC_TXD_CONTINUATION_SHIFTED(p,val)               =
 \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl((val<<VNIC_TXD_CONTINUATION_SHIFT)& VNIC_TXD_CONTINUATION_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TXD_CONTINUATION
+#  define CLR_HTON_VNIC_TXD_CONTINUATION(p)            \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D hto=
nl(~VNIC_TXD_CONTINUATION_MASK))
+#endif
+      /* Next desc being proc (0x1<<24) */
+#     define VNIC_TXD_CONT_ON_W        0x01000000
+
+   /* RESERVED */
+#  define VNIC_TXD_UNUSED2_WORD        1
+#  define VNIC_TXD_UNUSED2_MASK        0x00ffff00
+#  define VNIC_TXD_UNUSED2_SHIFT       8
+#ifndef  GET_VNIC_TXD_UNUSED2
+#  define GET_VNIC_TXD_UNUSED2(p)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
D_UNUSED2_MASK))
+#endif
+#ifndef  GET_VNIC_TXD_UNUSED2_SHIFTED
+#  define GET_VNIC_TXD_UNUSED2_SHIFTED(p)              \
+               (((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_T=
XD_UNUSED2_MASK))>>VNIC_TXD_UNUSED2_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_UNUSED2
+#  define GET_NTOH_VNIC_TXD_UNUSED2(p)         \
+               (ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TXD_UNUSED2_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_UNUSED2_SHIFTED
+#  define GET_NTOH_VNIC_TXD_UNUSED2_SHIFTED(p)         \
+               ((ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(V=
NIC_TXD_UNUSED2_MASK))>>VNIC_TXD_UNUSED2_SHIFT)
+#endif
+#ifndef  SET_VNIC_TXD_UNUSED2
+#  define SET_VNIC_TXD_UNUSED2(p,val)          \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D (va=
l & VNIC_TXD_UNUSED2_MASK))
+#endif
+#ifndef  SET_VNIC_TXD_UNUSED2_SHIFTED
+#  define SET_VNIC_TXD_UNUSED2_SHIFTED(p,val)          \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D ((v=
al<<VNIC_TXD_UNUSED2_SHIFT)& VNIC_TXD_UNUSED2_MASK))
+#endif
+#ifndef  CLR_VNIC_TXD_UNUSED2
+#  define CLR_VNIC_TXD_UNUSED2(p)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D (~V=
NIC_TXD_UNUSED2_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_UNUSED2
+#  define SET_HTON_VNIC_TXD_UNUSED2(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl(val & VNIC_TXD_UNUSED2_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_UNUSED2_SHIFTED
+#  define SET_HTON_VNIC_TXD_UNUSED2_SHIFTED(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl((val<<VNIC_TXD_UNUSED2_SHIFT)& VNIC_TXD_UNUSED2_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TXD_UNUSED2
+#  define CLR_HTON_VNIC_TXD_UNUSED2(p)         \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D hto=
nl(~VNIC_TXD_UNUSED2_MASK))
+#endif
+
+   /* RESERVED */
+#  define VNIC_TXD_UNUSED3_WORD        1
+#  define VNIC_TXD_UNUSED3_MASK        0x000000ff
+#  define VNIC_TXD_UNUSED3_SHIFT       0
+#ifndef  GET_VNIC_TXD_UNUSED3
+#  define GET_VNIC_TXD_UNUSED3(p)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_TX=
D_UNUSED3_MASK))
+#endif
+#ifndef  GET_VNIC_TXD_UNUSED3_SHIFTED
+#  define GET_VNIC_TXD_UNUSED3_SHIFTED(p)              \
+               (((((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_T=
XD_UNUSED3_MASK))>>VNIC_TXD_UNUSED3_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_UNUSED3
+#  define GET_NTOH_VNIC_TXD_UNUSED3(p)         \
+               (ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_TXD_UNUSED3_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_TXD_UNUSED3_SHIFTED
+#  define GET_NTOH_VNIC_TXD_UNUSED3_SHIFTED(p)         \
+               ((ntohl(((struct txd_pktBufDesc_Phys_w *)p)->word_1)&(V=
NIC_TXD_UNUSED3_MASK))>>VNIC_TXD_UNUSED3_SHIFT)
+#endif
+#ifndef  SET_VNIC_TXD_UNUSED3
+#  define SET_VNIC_TXD_UNUSED3(p,val)          \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D (va=
l & VNIC_TXD_UNUSED3_MASK))
+#endif
+#ifndef  SET_VNIC_TXD_UNUSED3_SHIFTED
+#  define SET_VNIC_TXD_UNUSED3_SHIFTED(p,val)          \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D ((v=
al<<VNIC_TXD_UNUSED3_SHIFT)& VNIC_TXD_UNUSED3_MASK))
+#endif
+#ifndef  CLR_VNIC_TXD_UNUSED3
+#  define CLR_VNIC_TXD_UNUSED3(p)              \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D (~V=
NIC_TXD_UNUSED3_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_UNUSED3
+#  define SET_HTON_VNIC_TXD_UNUSED3(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl(val & VNIC_TXD_UNUSED3_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_TXD_UNUSED3_SHIFTED
+#  define SET_HTON_VNIC_TXD_UNUSED3_SHIFTED(p,val)             \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) |=3D hto=
nl((val<<VNIC_TXD_UNUSED3_SHIFT)& VNIC_TXD_UNUSED3_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_TXD_UNUSED3
+#  define CLR_HTON_VNIC_TXD_UNUSED3(p)         \
+               ((((struct txd_pktBufDesc_Phys_w *)p)->word_1) &=3D hto=
nl(~VNIC_TXD_UNUSED3_MASK))
+#endif
+
+};
+
+struct rx_pktBufDesc_Phys_w {
+       u32 word_0;
+
+   /* Lo 32-Bits of 40-Bit Phys addr of buffer */
+#  define VNIC_RX_BUFADDR_LO_WORD      0
+#  define VNIC_RX_BUFADDR_LO_MASK      0xffffffff
+#  define VNIC_RX_BUFADDR_LO_SHIFT     0
+#ifndef  GET_VNIC_RX_BUFADDR_LO
+#  define GET_VNIC_RX_BUFADDR_LO(p)            \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_0)&(VNIC_RX_=
BUFADDR_LO_MASK))
+#endif
+#ifndef  GET_VNIC_RX_BUFADDR_LO_SHIFTED
+#  define GET_VNIC_RX_BUFADDR_LO_SHIFTED(p)            \
+               (((((struct rx_pktBufDesc_Phys_w *)p)->word_0)&(VNIC_RX=
_BUFADDR_LO_MASK))>>VNIC_RX_BUFADDR_LO_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RX_BUFADDR_LO
+#  define GET_NTOH_VNIC_RX_BUFADDR_LO(p)               \
+               (ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_0)&(VNI=
C_RX_BUFADDR_LO_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RX_BUFADDR_LO_SHIFTED
+#  define GET_NTOH_VNIC_RX_BUFADDR_LO_SHIFTED(p)               \
+               ((ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_0)&(VN=
IC_RX_BUFADDR_LO_MASK))>>VNIC_RX_BUFADDR_LO_SHIFT)
+#endif
+#ifndef  SET_VNIC_RX_BUFADDR_LO
+#  define SET_VNIC_RX_BUFADDR_LO(p,val)                \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_0) |=3D (val=
 & VNIC_RX_BUFADDR_LO_MASK))
+#endif
+#ifndef  SET_VNIC_RX_BUFADDR_LO_SHIFTED
+#  define SET_VNIC_RX_BUFADDR_LO_SHIFTED(p,val)                \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_0) |=3D ((va=
l<<VNIC_RX_BUFADDR_LO_SHIFT)& VNIC_RX_BUFADDR_LO_MASK))
+#endif
+#ifndef  CLR_VNIC_RX_BUFADDR_LO
+#  define CLR_VNIC_RX_BUFADDR_LO(p)            \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_0) &=3D (~VN=
IC_RX_BUFADDR_LO_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_BUFADDR_LO
+#  define SET_HTON_VNIC_RX_BUFADDR_LO(p,val)           \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_0) |=3D hton=
l(val & VNIC_RX_BUFADDR_LO_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_BUFADDR_LO_SHIFTED
+#  define SET_HTON_VNIC_RX_BUFADDR_LO_SHIFTED(p,val)           \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_0) |=3D hton=
l((val<<VNIC_RX_BUFADDR_LO_SHIFT)& VNIC_RX_BUFADDR_LO_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RX_BUFADDR_LO
+#  define CLR_HTON_VNIC_RX_BUFADDR_LO(p)               \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_0) &=3D hton=
l(~VNIC_RX_BUFADDR_LO_MASK))
+#endif
+
+       u32 word_1;
+
+   /* Determines ownership of the descriptor */
+#  define VNIC_RX_OWNED_WORD   1
+#  define VNIC_RX_OWNED_MASK   0x80000000
+#  define VNIC_RX_OWNED_SHIFT  31
+#ifndef  GET_VNIC_RX_OWNED
+#  define GET_VNIC_RX_OWNED(p)         \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_RX_=
OWNED_MASK))
+#endif
+#ifndef  GET_VNIC_RX_OWNED_SHIFTED
+#  define GET_VNIC_RX_OWNED_SHIFTED(p)         \
+               (((((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_RX=
_OWNED_MASK))>>VNIC_RX_OWNED_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RX_OWNED
+#  define GET_NTOH_VNIC_RX_OWNED(p)            \
+               (ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_RX_OWNED_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RX_OWNED_SHIFTED
+#  define GET_NTOH_VNIC_RX_OWNED_SHIFTED(p)            \
+               ((ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_RX_OWNED_MASK))>>VNIC_RX_OWNED_SHIFT)
+#endif
+#ifndef  SET_VNIC_RX_OWNED
+#  define SET_VNIC_RX_OWNED(p,val)             \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_RX_OWNED_MASK))
+#endif
+#ifndef  SET_VNIC_RX_OWNED_SHIFTED
+#  define SET_VNIC_RX_OWNED_SHIFTED(p,val)             \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_RX_OWNED_SHIFT)& VNIC_RX_OWNED_MASK))
+#endif
+#ifndef  CLR_VNIC_RX_OWNED
+#  define CLR_VNIC_RX_OWNED(p)         \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_RX_OWNED_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_OWNED
+#  define SET_HTON_VNIC_RX_OWNED(p,val)                \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_RX_OWNED_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_OWNED_SHIFTED
+#  define SET_HTON_VNIC_RX_OWNED_SHIFTED(p,val)                \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_RX_OWNED_SHIFT)& VNIC_RX_OWNED_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RX_OWNED
+#  define CLR_HTON_VNIC_RX_OWNED(p)            \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_RX_OWNED_MASK))
+#endif
+      /* VIOC HW (0x1<<31) */
+#     define VNIC_RX_OWNED_HW_W        0x80000000
+
+   /* RESERVED */
+#  define VNIC_RX_UNUSED0_WORD 1
+#  define VNIC_RX_UNUSED0_MASK 0x7f000000
+#  define VNIC_RX_UNUSED0_SHIFT        24
+#ifndef  GET_VNIC_RX_UNUSED0
+#  define GET_VNIC_RX_UNUSED0(p)               \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_RX_=
UNUSED0_MASK))
+#endif
+#ifndef  GET_VNIC_RX_UNUSED0_SHIFTED
+#  define GET_VNIC_RX_UNUSED0_SHIFTED(p)               \
+               (((((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_RX=
_UNUSED0_MASK))>>VNIC_RX_UNUSED0_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RX_UNUSED0
+#  define GET_NTOH_VNIC_RX_UNUSED0(p)          \
+               (ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_RX_UNUSED0_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RX_UNUSED0_SHIFTED
+#  define GET_NTOH_VNIC_RX_UNUSED0_SHIFTED(p)          \
+               ((ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_RX_UNUSED0_MASK))>>VNIC_RX_UNUSED0_SHIFT)
+#endif
+#ifndef  SET_VNIC_RX_UNUSED0
+#  define SET_VNIC_RX_UNUSED0(p,val)           \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_RX_UNUSED0_MASK))
+#endif
+#ifndef  SET_VNIC_RX_UNUSED0_SHIFTED
+#  define SET_VNIC_RX_UNUSED0_SHIFTED(p,val)           \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_RX_UNUSED0_SHIFT)& VNIC_RX_UNUSED0_MASK))
+#endif
+#ifndef  CLR_VNIC_RX_UNUSED0
+#  define CLR_VNIC_RX_UNUSED0(p)               \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_RX_UNUSED0_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_UNUSED0
+#  define SET_HTON_VNIC_RX_UNUSED0(p,val)              \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_RX_UNUSED0_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_UNUSED0_SHIFTED
+#  define SET_HTON_VNIC_RX_UNUSED0_SHIFTED(p,val)              \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_RX_UNUSED0_SHIFT)& VNIC_RX_UNUSED0_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RX_UNUSED0
+#  define CLR_HTON_VNIC_RX_UNUSED0(p)          \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_RX_UNUSED0_MASK))
+#endif
+
+   /* RESERVED */
+#  define VNIC_RX_UNUSED1_WORD 1
+#  define VNIC_RX_UNUSED1_MASK 0x00ffff00
+#  define VNIC_RX_UNUSED1_SHIFT        8
+#ifndef  GET_VNIC_RX_UNUSED1
+#  define GET_VNIC_RX_UNUSED1(p)               \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_RX_=
UNUSED1_MASK))
+#endif
+#ifndef  GET_VNIC_RX_UNUSED1_SHIFTED
+#  define GET_VNIC_RX_UNUSED1_SHIFTED(p)               \
+               (((((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_RX=
_UNUSED1_MASK))>>VNIC_RX_UNUSED1_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RX_UNUSED1
+#  define GET_NTOH_VNIC_RX_UNUSED1(p)          \
+               (ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_RX_UNUSED1_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RX_UNUSED1_SHIFTED
+#  define GET_NTOH_VNIC_RX_UNUSED1_SHIFTED(p)          \
+               ((ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_RX_UNUSED1_MASK))>>VNIC_RX_UNUSED1_SHIFT)
+#endif
+#ifndef  SET_VNIC_RX_UNUSED1
+#  define SET_VNIC_RX_UNUSED1(p,val)           \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_RX_UNUSED1_MASK))
+#endif
+#ifndef  SET_VNIC_RX_UNUSED1_SHIFTED
+#  define SET_VNIC_RX_UNUSED1_SHIFTED(p,val)           \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_RX_UNUSED1_SHIFT)& VNIC_RX_UNUSED1_MASK))
+#endif
+#ifndef  CLR_VNIC_RX_UNUSED1
+#  define CLR_VNIC_RX_UNUSED1(p)               \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_RX_UNUSED1_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_UNUSED1
+#  define SET_HTON_VNIC_RX_UNUSED1(p,val)              \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_RX_UNUSED1_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_UNUSED1_SHIFTED
+#  define SET_HTON_VNIC_RX_UNUSED1_SHIFTED(p,val)              \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_RX_UNUSED1_SHIFT)& VNIC_RX_UNUSED1_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RX_UNUSED1
+#  define CLR_HTON_VNIC_RX_UNUSED1(p)          \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_RX_UNUSED1_MASK))
+#endif
+
+   /* Hi 8-Bits of 40-Bit Phy address of buffer */
+#  define VNIC_RX_BUFADDR_HI_WORD      1
+#  define VNIC_RX_BUFADDR_HI_MASK      0x000000ff
+#  define VNIC_RX_BUFADDR_HI_SHIFT     0
+#ifndef  GET_VNIC_RX_BUFADDR_HI
+#  define GET_VNIC_RX_BUFADDR_HI(p)            \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_RX_=
BUFADDR_HI_MASK))
+#endif
+#ifndef  GET_VNIC_RX_BUFADDR_HI_SHIFTED
+#  define GET_VNIC_RX_BUFADDR_HI_SHIFTED(p)            \
+               (((((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNIC_RX=
_BUFADDR_HI_MASK))>>VNIC_RX_BUFADDR_HI_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RX_BUFADDR_HI
+#  define GET_NTOH_VNIC_RX_BUFADDR_HI(p)               \
+               (ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VNI=
C_RX_BUFADDR_HI_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RX_BUFADDR_HI_SHIFTED
+#  define GET_NTOH_VNIC_RX_BUFADDR_HI_SHIFTED(p)               \
+               ((ntohl(((struct rx_pktBufDesc_Phys_w *)p)->word_1)&(VN=
IC_RX_BUFADDR_HI_MASK))>>VNIC_RX_BUFADDR_HI_SHIFT)
+#endif
+#ifndef  SET_VNIC_RX_BUFADDR_HI
+#  define SET_VNIC_RX_BUFADDR_HI(p,val)                \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D (val=
 & VNIC_RX_BUFADDR_HI_MASK))
+#endif
+#ifndef  SET_VNIC_RX_BUFADDR_HI_SHIFTED
+#  define SET_VNIC_RX_BUFADDR_HI_SHIFTED(p,val)                \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D ((va=
l<<VNIC_RX_BUFADDR_HI_SHIFT)& VNIC_RX_BUFADDR_HI_MASK))
+#endif
+#ifndef  CLR_VNIC_RX_BUFADDR_HI
+#  define CLR_VNIC_RX_BUFADDR_HI(p)            \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) &=3D (~VN=
IC_RX_BUFADDR_HI_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_BUFADDR_HI
+#  define SET_HTON_VNIC_RX_BUFADDR_HI(p,val)           \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l(val & VNIC_RX_BUFADDR_HI_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RX_BUFADDR_HI_SHIFTED
+#  define SET_HTON_VNIC_RX_BUFADDR_HI_SHIFTED(p,val)           \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) |=3D hton=
l((val<<VNIC_RX_BUFADDR_HI_SHIFT)& VNIC_RX_BUFADDR_HI_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RX_BUFADDR_HI
+#  define CLR_HTON_VNIC_RX_BUFADDR_HI(p)               \
+               ((((struct rx_pktBufDesc_Phys_w *)p)->word_1) &=3D hton=
l(~VNIC_RX_BUFADDR_HI_MASK))
+#endif
+
+};
+
+struct rxc_pktDesc_Phys_w {
+       u32 word_0;
+
+   /* Descriptor INDEX on the rx ring */
+#  define VNIC_RXC_IDX_WORD    0
+#  define VNIC_RXC_IDX_MASK    0xffff0000
+#  define VNIC_RXC_IDX_SHIFT   16
+#ifndef  GET_VNIC_RXC_IDX
+#  define GET_VNIC_RXC_IDX(p)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0)&(VNIC_RXC_I=
DX_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_IDX_SHIFTED
+#  define GET_VNIC_RXC_IDX_SHIFTED(p)          \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_0)&(VNIC_RXC_=
IDX_MASK))>>VNIC_RXC_IDX_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_IDX
+#  define GET_NTOH_VNIC_RXC_IDX(p)             \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_0)&(VNIC_=
RXC_IDX_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_IDX_SHIFTED
+#  define GET_NTOH_VNIC_RXC_IDX_SHIFTED(p)             \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_0)&(VNIC=
_RXC_IDX_MASK))>>VNIC_RXC_IDX_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_IDX
+#  define SET_VNIC_RXC_IDX(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) |=3D (val &=
 VNIC_RXC_IDX_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_IDX_SHIFTED
+#  define SET_VNIC_RXC_IDX_SHIFTED(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) |=3D ((val<=
<VNIC_RXC_IDX_SHIFT)& VNIC_RXC_IDX_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_IDX
+#  define CLR_VNIC_RXC_IDX(p)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) &=3D (~VNIC=
_RXC_IDX_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_IDX
+#  define SET_HTON_VNIC_RXC_IDX(p,val)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) |=3D htonl(=
val & VNIC_RXC_IDX_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_IDX_SHIFTED
+#  define SET_HTON_VNIC_RXC_IDX_SHIFTED(p,val)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) |=3D htonl(=
(val<<VNIC_RXC_IDX_SHIFT)& VNIC_RXC_IDX_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_IDX
+#  define CLR_HTON_VNIC_RXC_IDX(p)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) &=3D htonl(=
~VNIC_RXC_IDX_MASK))
+#endif
+
+   /* Unique opaque ID for pkt in rx ring */
+#  define VNIC_RXC_PKT_ID_WORD 0
+#  define VNIC_RXC_PKT_ID_MASK 0x0000ffff
+#  define VNIC_RXC_PKT_ID_SHIFT        0
+#ifndef  GET_VNIC_RXC_PKT_ID
+#  define GET_VNIC_RXC_PKT_ID(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0)&(VNIC_RXC_P=
KT_ID_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_PKT_ID_SHIFTED
+#  define GET_VNIC_RXC_PKT_ID_SHIFTED(p)               \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_0)&(VNIC_RXC_=
PKT_ID_MASK))>>VNIC_RXC_PKT_ID_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_PKT_ID
+#  define GET_NTOH_VNIC_RXC_PKT_ID(p)          \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_0)&(VNIC_=
RXC_PKT_ID_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_PKT_ID_SHIFTED
+#  define GET_NTOH_VNIC_RXC_PKT_ID_SHIFTED(p)          \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_0)&(VNIC=
_RXC_PKT_ID_MASK))>>VNIC_RXC_PKT_ID_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_PKT_ID
+#  define SET_VNIC_RXC_PKT_ID(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) |=3D (val &=
 VNIC_RXC_PKT_ID_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_PKT_ID_SHIFTED
+#  define SET_VNIC_RXC_PKT_ID_SHIFTED(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) |=3D ((val<=
<VNIC_RXC_PKT_ID_SHIFT)& VNIC_RXC_PKT_ID_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_PKT_ID
+#  define CLR_VNIC_RXC_PKT_ID(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) &=3D (~VNIC=
_RXC_PKT_ID_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_PKT_ID
+#  define SET_HTON_VNIC_RXC_PKT_ID(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) |=3D htonl(=
val & VNIC_RXC_PKT_ID_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_PKT_ID_SHIFTED
+#  define SET_HTON_VNIC_RXC_PKT_ID_SHIFTED(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) |=3D htonl(=
(val<<VNIC_RXC_PKT_ID_SHIFT)& VNIC_RXC_PKT_ID_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_PKT_ID
+#  define CLR_HTON_VNIC_RXC_PKT_ID(p)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_0) &=3D htonl(=
~VNIC_RXC_PKT_ID_MASK))
+#endif
+
+       u32 word_1;
+
+   /* 16-bit IP checksum or 32-Bit CRC chksum */
+#  define VNIC_RXC_CKSUM_WORD  1
+#  define VNIC_RXC_CKSUM_MASK  0xffffffff
+#  define VNIC_RXC_CKSUM_SHIFT 0
+#ifndef  GET_VNIC_RXC_CKSUM
+#  define GET_VNIC_RXC_CKSUM(p)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_1)&(VNIC_RXC_C=
KSUM_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_CKSUM_SHIFTED
+#  define GET_VNIC_RXC_CKSUM_SHIFTED(p)                \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_1)&(VNIC_RXC_=
CKSUM_MASK))>>VNIC_RXC_CKSUM_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_CKSUM
+#  define GET_NTOH_VNIC_RXC_CKSUM(p)           \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_1)&(VNIC_=
RXC_CKSUM_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_CKSUM_SHIFTED
+#  define GET_NTOH_VNIC_RXC_CKSUM_SHIFTED(p)           \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_1)&(VNIC=
_RXC_CKSUM_MASK))>>VNIC_RXC_CKSUM_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_CKSUM
+#  define SET_VNIC_RXC_CKSUM(p,val)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_1) |=3D (val &=
 VNIC_RXC_CKSUM_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_CKSUM_SHIFTED
+#  define SET_VNIC_RXC_CKSUM_SHIFTED(p,val)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_1) |=3D ((val<=
<VNIC_RXC_CKSUM_SHIFT)& VNIC_RXC_CKSUM_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_CKSUM
+#  define CLR_VNIC_RXC_CKSUM(p)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_1) &=3D (~VNIC=
_RXC_CKSUM_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_CKSUM
+#  define SET_HTON_VNIC_RXC_CKSUM(p,val)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_1) |=3D htonl(=
val & VNIC_RXC_CKSUM_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_CKSUM_SHIFTED
+#  define SET_HTON_VNIC_RXC_CKSUM_SHIFTED(p,val)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_1) |=3D htonl(=
(val<<VNIC_RXC_CKSUM_SHIFT)& VNIC_RXC_CKSUM_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_CKSUM
+#  define CLR_HTON_VNIC_RXC_CKSUM(p)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_1) &=3D htonl(=
~VNIC_RXC_CKSUM_MASK))
+#endif
+
+       u32 word_2;
+
+   /* VNIC id of packet buffer */
+#  define VNIC_RXC_VNIC_ID_WORD        2
+#  define VNIC_RXC_VNIC_ID_MASK        0xf0000000
+#  define VNIC_RXC_VNIC_ID_SHIFT       28
+#ifndef  GET_VNIC_RXC_VNIC_ID
+#  define GET_VNIC_RXC_VNIC_ID(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_V=
NIC_ID_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_VNIC_ID_SHIFTED
+#  define GET_VNIC_RXC_VNIC_ID_SHIFTED(p)              \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_=
VNIC_ID_MASK))>>VNIC_RXC_VNIC_ID_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_VNIC_ID
+#  define GET_NTOH_VNIC_RXC_VNIC_ID(p)         \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_=
RXC_VNIC_ID_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_VNIC_ID_SHIFTED
+#  define GET_NTOH_VNIC_RXC_VNIC_ID_SHIFTED(p)         \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC=
_RXC_VNIC_ID_MASK))>>VNIC_RXC_VNIC_ID_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_VNIC_ID
+#  define SET_VNIC_RXC_VNIC_ID(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D (val &=
 VNIC_RXC_VNIC_ID_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_VNIC_ID_SHIFTED
+#  define SET_VNIC_RXC_VNIC_ID_SHIFTED(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D ((val<=
<VNIC_RXC_VNIC_ID_SHIFT)& VNIC_RXC_VNIC_ID_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_VNIC_ID
+#  define CLR_VNIC_RXC_VNIC_ID(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D (~VNIC=
_RXC_VNIC_ID_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_VNIC_ID
+#  define SET_HTON_VNIC_RXC_VNIC_ID(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
val & VNIC_RXC_VNIC_ID_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_VNIC_ID_SHIFTED
+#  define SET_HTON_VNIC_RXC_VNIC_ID_SHIFTED(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
(val<<VNIC_RXC_VNIC_ID_SHIFT)& VNIC_RXC_VNIC_ID_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_VNIC_ID
+#  define CLR_HTON_VNIC_RXC_VNIC_ID(p)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D htonl(=
~VNIC_RXC_VNIC_ID_MASK))
+#endif
+
+   /* RESERVED */
+#  define VNIC_RXC_UNUSED1_WORD        2
+#  define VNIC_RXC_UNUSED1_MASK        0x0c000000
+#  define VNIC_RXC_UNUSED1_SHIFT       26
+#ifndef  GET_VNIC_RXC_UNUSED1
+#  define GET_VNIC_RXC_UNUSED1(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_U=
NUSED1_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_UNUSED1_SHIFTED
+#  define GET_VNIC_RXC_UNUSED1_SHIFTED(p)              \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_=
UNUSED1_MASK))>>VNIC_RXC_UNUSED1_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED1
+#  define GET_NTOH_VNIC_RXC_UNUSED1(p)         \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_=
RXC_UNUSED1_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED1_SHIFTED
+#  define GET_NTOH_VNIC_RXC_UNUSED1_SHIFTED(p)         \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC=
_RXC_UNUSED1_MASK))>>VNIC_RXC_UNUSED1_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED1
+#  define SET_VNIC_RXC_UNUSED1(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D (val &=
 VNIC_RXC_UNUSED1_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED1_SHIFTED
+#  define SET_VNIC_RXC_UNUSED1_SHIFTED(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D ((val<=
<VNIC_RXC_UNUSED1_SHIFT)& VNIC_RXC_UNUSED1_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_UNUSED1
+#  define CLR_VNIC_RXC_UNUSED1(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D (~VNIC=
_RXC_UNUSED1_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED1
+#  define SET_HTON_VNIC_RXC_UNUSED1(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
val & VNIC_RXC_UNUSED1_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED1_SHIFTED
+#  define SET_HTON_VNIC_RXC_UNUSED1_SHIFTED(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
(val<<VNIC_RXC_UNUSED1_SHIFT)& VNIC_RXC_UNUSED1_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_UNUSED1
+#  define CLR_HTON_VNIC_RXC_UNUSED1(p)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D htonl(=
~VNIC_RXC_UNUSED1_MASK))
+#endif
+
+   /* Queue number within VNIC */
+#  define VNIC_RXC_VNIC_Q_WORD 2
+#  define VNIC_RXC_VNIC_Q_MASK 0x03000000
+#  define VNIC_RXC_VNIC_Q_SHIFT        24
+#ifndef  GET_VNIC_RXC_VNIC_Q
+#  define GET_VNIC_RXC_VNIC_Q(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_V=
NIC_Q_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_VNIC_Q_SHIFTED
+#  define GET_VNIC_RXC_VNIC_Q_SHIFTED(p)               \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_=
VNIC_Q_MASK))>>VNIC_RXC_VNIC_Q_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_VNIC_Q
+#  define GET_NTOH_VNIC_RXC_VNIC_Q(p)          \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_=
RXC_VNIC_Q_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_VNIC_Q_SHIFTED
+#  define GET_NTOH_VNIC_RXC_VNIC_Q_SHIFTED(p)          \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC=
_RXC_VNIC_Q_MASK))>>VNIC_RXC_VNIC_Q_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_VNIC_Q
+#  define SET_VNIC_RXC_VNIC_Q(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D (val &=
 VNIC_RXC_VNIC_Q_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_VNIC_Q_SHIFTED
+#  define SET_VNIC_RXC_VNIC_Q_SHIFTED(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D ((val<=
<VNIC_RXC_VNIC_Q_SHIFT)& VNIC_RXC_VNIC_Q_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_VNIC_Q
+#  define CLR_VNIC_RXC_VNIC_Q(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D (~VNIC=
_RXC_VNIC_Q_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_VNIC_Q
+#  define SET_HTON_VNIC_RXC_VNIC_Q(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
val & VNIC_RXC_VNIC_Q_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_VNIC_Q_SHIFTED
+#  define SET_HTON_VNIC_RXC_VNIC_Q_SHIFTED(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
(val<<VNIC_RXC_VNIC_Q_SHIFT)& VNIC_RXC_VNIC_Q_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_VNIC_Q
+#  define CLR_HTON_VNIC_RXC_VNIC_Q(p)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D htonl(=
~VNIC_RXC_VNIC_Q_MASK))
+#endif
+
+   /* Encapsulation Tag from F7 Header */
+#  define VNIC_RXC_ENTAG_WORD  2
+#  define VNIC_RXC_ENTAG_MASK  0x00ff0000
+#  define VNIC_RXC_ENTAG_SHIFT 16
+#ifndef  GET_VNIC_RXC_ENTAG
+#  define GET_VNIC_RXC_ENTAG(p)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_E=
NTAG_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_ENTAG_SHIFTED
+#  define GET_VNIC_RXC_ENTAG_SHIFTED(p)                \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_=
ENTAG_MASK))>>VNIC_RXC_ENTAG_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_ENTAG
+#  define GET_NTOH_VNIC_RXC_ENTAG(p)           \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_=
RXC_ENTAG_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_ENTAG_SHIFTED
+#  define GET_NTOH_VNIC_RXC_ENTAG_SHIFTED(p)           \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC=
_RXC_ENTAG_MASK))>>VNIC_RXC_ENTAG_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_ENTAG
+#  define SET_VNIC_RXC_ENTAG(p,val)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D (val &=
 VNIC_RXC_ENTAG_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_ENTAG_SHIFTED
+#  define SET_VNIC_RXC_ENTAG_SHIFTED(p,val)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D ((val<=
<VNIC_RXC_ENTAG_SHIFT)& VNIC_RXC_ENTAG_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_ENTAG
+#  define CLR_VNIC_RXC_ENTAG(p)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D (~VNIC=
_RXC_ENTAG_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_ENTAG
+#  define SET_HTON_VNIC_RXC_ENTAG(p,val)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
val & VNIC_RXC_ENTAG_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_ENTAG_SHIFTED
+#  define SET_HTON_VNIC_RXC_ENTAG_SHIFTED(p,val)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
(val<<VNIC_RXC_ENTAG_SHIFT)& VNIC_RXC_ENTAG_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_ENTAG
+#  define CLR_HTON_VNIC_RXC_ENTAG(p)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D htonl(=
~VNIC_RXC_ENTAG_MASK))
+#endif
+
+   /* RESERVED */
+#  define VNIC_RXC_UNUSED2_WORD        2
+#  define VNIC_RXC_UNUSED2_MASK        0x0000ffff
+#  define VNIC_RXC_UNUSED2_SHIFT       0
+#ifndef  GET_VNIC_RXC_UNUSED2
+#  define GET_VNIC_RXC_UNUSED2(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_U=
NUSED2_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_UNUSED2_SHIFTED
+#  define GET_VNIC_RXC_UNUSED2_SHIFTED(p)              \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_RXC_=
UNUSED2_MASK))>>VNIC_RXC_UNUSED2_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED2
+#  define GET_NTOH_VNIC_RXC_UNUSED2(p)         \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC_=
RXC_UNUSED2_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED2_SHIFTED
+#  define GET_NTOH_VNIC_RXC_UNUSED2_SHIFTED(p)         \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_2)&(VNIC=
_RXC_UNUSED2_MASK))>>VNIC_RXC_UNUSED2_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED2
+#  define SET_VNIC_RXC_UNUSED2(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D (val &=
 VNIC_RXC_UNUSED2_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED2_SHIFTED
+#  define SET_VNIC_RXC_UNUSED2_SHIFTED(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D ((val<=
<VNIC_RXC_UNUSED2_SHIFT)& VNIC_RXC_UNUSED2_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_UNUSED2
+#  define CLR_VNIC_RXC_UNUSED2(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D (~VNIC=
_RXC_UNUSED2_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED2
+#  define SET_HTON_VNIC_RXC_UNUSED2(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
val & VNIC_RXC_UNUSED2_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED2_SHIFTED
+#  define SET_HTON_VNIC_RXC_UNUSED2_SHIFTED(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) |=3D htonl(=
(val<<VNIC_RXC_UNUSED2_SHIFT)& VNIC_RXC_UNUSED2_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_UNUSED2
+#  define CLR_HTON_VNIC_RXC_UNUSED2(p)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_2) &=3D htonl(=
~VNIC_RXC_UNUSED2_MASK))
+#endif
+
+       u32 word_3;
+
+   /* Flag set when operation completed by HW */
+#  define VNIC_RXC_FLAGGED_WORD        3
+#  define VNIC_RXC_FLAGGED_MASK        0x80000000
+#  define VNIC_RXC_FLAGGED_SHIFT       31
+#ifndef  GET_VNIC_RXC_FLAGGED
+#  define GET_VNIC_RXC_FLAGGED(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_F=
LAGGED_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_FLAGGED_SHIFTED
+#  define GET_VNIC_RXC_FLAGGED_SHIFTED(p)              \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
=46LAGGED_MASK))>>VNIC_RXC_FLAGGED_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_FLAGGED
+#  define GET_NTOH_VNIC_RXC_FLAGGED(p)         \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_FLAGGED_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_FLAGGED_SHIFTED
+#  define GET_NTOH_VNIC_RXC_FLAGGED_SHIFTED(p)         \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_FLAGGED_MASK))>>VNIC_RXC_FLAGGED_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_FLAGGED
+#  define SET_VNIC_RXC_FLAGGED(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_FLAGGED_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_FLAGGED_SHIFTED
+#  define SET_VNIC_RXC_FLAGGED_SHIFTED(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_FLAGGED_SHIFT)& VNIC_RXC_FLAGGED_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_FLAGGED
+#  define CLR_VNIC_RXC_FLAGGED(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_FLAGGED_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_FLAGGED
+#  define SET_HTON_VNIC_RXC_FLAGGED(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_FLAGGED_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_FLAGGED_SHIFTED
+#  define SET_HTON_VNIC_RXC_FLAGGED_SHIFTED(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_FLAGGED_SHIFT)& VNIC_RXC_FLAGGED_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_FLAGGED
+#  define CLR_HTON_VNIC_RXC_FLAGGED(p)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_FLAGGED_MASK))
+#endif
+      /* Done, oper completed by VIOC (0x1<<31) */
+#     define VNIC_RXC_FLAGGED_HW_W     0x80000000
+
+   /* Flag signalling reception of a VIOCP packet */
+#  define VNIC_RXC_IS_VIOCP_WORD       3
+#  define VNIC_RXC_IS_VIOCP_MASK       0x40000000
+#  define VNIC_RXC_IS_VIOCP_SHIFT      30
+#ifndef  GET_VNIC_RXC_IS_VIOCP
+#  define GET_VNIC_RXC_IS_VIOCP(p)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_I=
S_VIOCP_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_IS_VIOCP_SHIFTED
+#  define GET_VNIC_RXC_IS_VIOCP_SHIFTED(p)             \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
IS_VIOCP_MASK))>>VNIC_RXC_IS_VIOCP_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_IS_VIOCP
+#  define GET_NTOH_VNIC_RXC_IS_VIOCP(p)                \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_IS_VIOCP_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_IS_VIOCP_SHIFTED
+#  define GET_NTOH_VNIC_RXC_IS_VIOCP_SHIFTED(p)                \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_IS_VIOCP_MASK))>>VNIC_RXC_IS_VIOCP_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_IS_VIOCP
+#  define SET_VNIC_RXC_IS_VIOCP(p,val)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_IS_VIOCP_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_IS_VIOCP_SHIFTED
+#  define SET_VNIC_RXC_IS_VIOCP_SHIFTED(p,val)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_IS_VIOCP_SHIFT)& VNIC_RXC_IS_VIOCP_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_IS_VIOCP
+#  define CLR_VNIC_RXC_IS_VIOCP(p)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_IS_VIOCP_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_IS_VIOCP
+#  define SET_HTON_VNIC_RXC_IS_VIOCP(p,val)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_IS_VIOCP_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_IS_VIOCP_SHIFTED
+#  define SET_HTON_VNIC_RXC_IS_VIOCP_SHIFTED(p,val)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_IS_VIOCP_SHIFT)& VNIC_RXC_IS_VIOCP_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_IS_VIOCP
+#  define CLR_HTON_VNIC_RXC_IS_VIOCP(p)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_IS_VIOCP_MASK))
+#endif
+      /* Buffer is VIOCP bit mask (0x1<<30) */
+#     define VNIC_RXC_ISVIOCPMASK_W    0x40000000
+      /* VIOCP packet (0x1<<30) */
+#     define VNIC_RXC_ISVIOCP_W        0x40000000
+
+   /* Status Flag signalling bad packet length */
+#  define VNIC_RXC_BADLENGTH_WORD      3
+#  define VNIC_RXC_BADLENGTH_MASK      0x20000000
+#  define VNIC_RXC_BADLENGTH_SHIFT     29
+#ifndef  GET_VNIC_RXC_BADLENGTH
+#  define GET_VNIC_RXC_BADLENGTH(p)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_B=
ADLENGTH_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_BADLENGTH_SHIFTED
+#  define GET_VNIC_RXC_BADLENGTH_SHIFTED(p)            \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
BADLENGTH_MASK))>>VNIC_RXC_BADLENGTH_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_BADLENGTH
+#  define GET_NTOH_VNIC_RXC_BADLENGTH(p)               \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_BADLENGTH_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_BADLENGTH_SHIFTED
+#  define GET_NTOH_VNIC_RXC_BADLENGTH_SHIFTED(p)               \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_BADLENGTH_MASK))>>VNIC_RXC_BADLENGTH_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_BADLENGTH
+#  define SET_VNIC_RXC_BADLENGTH(p,val)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_BADLENGTH_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_BADLENGTH_SHIFTED
+#  define SET_VNIC_RXC_BADLENGTH_SHIFTED(p,val)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_BADLENGTH_SHIFT)& VNIC_RXC_BADLENGTH_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_BADLENGTH
+#  define CLR_VNIC_RXC_BADLENGTH(p)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_BADLENGTH_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_BADLENGTH
+#  define SET_HTON_VNIC_RXC_BADLENGTH(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_BADLENGTH_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_BADLENGTH_SHIFTED
+#  define SET_HTON_VNIC_RXC_BADLENGTH_SHIFTED(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_BADLENGTH_SHIFT)& VNIC_RXC_BADLENGTH_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_BADLENGTH
+#  define CLR_HTON_VNIC_RXC_BADLENGTH(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_BADLENGTH_MASK))
+#endif
+      /* Bad Length (0x1<<29) */
+#     define VNIC_RXC_ISBADLENGTH_W    0x20000000
+
+   /* Status Flag signalling bad packet CRC */
+#  define VNIC_RXC_BADCRC_WORD 3
+#  define VNIC_RXC_BADCRC_MASK 0x10000000
+#  define VNIC_RXC_BADCRC_SHIFT        28
+#ifndef  GET_VNIC_RXC_BADCRC
+#  define GET_VNIC_RXC_BADCRC(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_B=
ADCRC_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_BADCRC_SHIFTED
+#  define GET_VNIC_RXC_BADCRC_SHIFTED(p)               \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
BADCRC_MASK))>>VNIC_RXC_BADCRC_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_BADCRC
+#  define GET_NTOH_VNIC_RXC_BADCRC(p)          \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_BADCRC_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_BADCRC_SHIFTED
+#  define GET_NTOH_VNIC_RXC_BADCRC_SHIFTED(p)          \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_BADCRC_MASK))>>VNIC_RXC_BADCRC_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_BADCRC
+#  define SET_VNIC_RXC_BADCRC(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_BADCRC_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_BADCRC_SHIFTED
+#  define SET_VNIC_RXC_BADCRC_SHIFTED(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_BADCRC_SHIFT)& VNIC_RXC_BADCRC_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_BADCRC
+#  define CLR_VNIC_RXC_BADCRC(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_BADCRC_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_BADCRC
+#  define SET_HTON_VNIC_RXC_BADCRC(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_BADCRC_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_BADCRC_SHIFTED
+#  define SET_HTON_VNIC_RXC_BADCRC_SHIFTED(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_BADCRC_SHIFT)& VNIC_RXC_BADCRC_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_BADCRC
+#  define CLR_HTON_VNIC_RXC_BADCRC(p)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_BADCRC_MASK))
+#endif
+      /* Bad CRC (0x1<<28) */
+#     define VNIC_RXC_ISBADCRC_W       0x10000000
+
+   /* RESERVED */
+#  define VNIC_RXC_UNUSED3_WORD        3
+#  define VNIC_RXC_UNUSED3_MASK        0x08000000
+#  define VNIC_RXC_UNUSED3_SHIFT       27
+#ifndef  GET_VNIC_RXC_UNUSED3
+#  define GET_VNIC_RXC_UNUSED3(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_U=
NUSED3_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_UNUSED3_SHIFTED
+#  define GET_VNIC_RXC_UNUSED3_SHIFTED(p)              \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
UNUSED3_MASK))>>VNIC_RXC_UNUSED3_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED3
+#  define GET_NTOH_VNIC_RXC_UNUSED3(p)         \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_UNUSED3_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED3_SHIFTED
+#  define GET_NTOH_VNIC_RXC_UNUSED3_SHIFTED(p)         \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_UNUSED3_MASK))>>VNIC_RXC_UNUSED3_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED3
+#  define SET_VNIC_RXC_UNUSED3(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_UNUSED3_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED3_SHIFTED
+#  define SET_VNIC_RXC_UNUSED3_SHIFTED(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_UNUSED3_SHIFT)& VNIC_RXC_UNUSED3_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_UNUSED3
+#  define CLR_VNIC_RXC_UNUSED3(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_UNUSED3_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED3
+#  define SET_HTON_VNIC_RXC_UNUSED3(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_UNUSED3_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED3_SHIFTED
+#  define SET_HTON_VNIC_RXC_UNUSED3_SHIFTED(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_UNUSED3_SHIFT)& VNIC_RXC_UNUSED3_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_UNUSED3
+#  define CLR_HTON_VNIC_RXC_UNUSED3(p)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_UNUSED3_MASK))
+#endif
+
+   /* Status Flag signalling bad Shared Memory Parity */
+#  define VNIC_RXC_BADSMPARITY_WORD    3
+#  define VNIC_RXC_BADSMPARITY_MASK    0x04000000
+#  define VNIC_RXC_BADSMPARITY_SHIFT   26
+#ifndef  GET_VNIC_RXC_BADSMPARITY
+#  define GET_VNIC_RXC_BADSMPARITY(p)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_B=
ADSMPARITY_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_BADSMPARITY_SHIFTED
+#  define GET_VNIC_RXC_BADSMPARITY_SHIFTED(p)          \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
BADSMPARITY_MASK))>>VNIC_RXC_BADSMPARITY_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_BADSMPARITY
+#  define GET_NTOH_VNIC_RXC_BADSMPARITY(p)             \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_BADSMPARITY_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_BADSMPARITY_SHIFTED
+#  define GET_NTOH_VNIC_RXC_BADSMPARITY_SHIFTED(p)             \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_BADSMPARITY_MASK))>>VNIC_RXC_BADSMPARITY_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_BADSMPARITY
+#  define SET_VNIC_RXC_BADSMPARITY(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_BADSMPARITY_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_BADSMPARITY_SHIFTED
+#  define SET_VNIC_RXC_BADSMPARITY_SHIFTED(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_BADSMPARITY_SHIFT)& VNIC_RXC_BADSMPARITY_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_BADSMPARITY
+#  define CLR_VNIC_RXC_BADSMPARITY(p)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_BADSMPARITY_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_BADSMPARITY
+#  define SET_HTON_VNIC_RXC_BADSMPARITY(p,val)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_BADSMPARITY_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_BADSMPARITY_SHIFTED
+#  define SET_HTON_VNIC_RXC_BADSMPARITY_SHIFTED(p,val)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_BADSMPARITY_SHIFT)& VNIC_RXC_BADSMPARITY_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_BADSMPARITY
+#  define CLR_HTON_VNIC_RXC_BADSMPARITY(p)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_BADSMPARITY_MASK))
+#endif
+      /* Bad Shared Memory Parity (0x1<<26) */
+#     define VNIC_RXC_ISBADSMPARITY_W  0x04000000
+
+   /* Status Flag signalling aborted packet */
+#  define VNIC_RXC_PKTABORT_WORD       3
+#  define VNIC_RXC_PKTABORT_MASK       0x02000000
+#  define VNIC_RXC_PKTABORT_SHIFT      25
+#ifndef  GET_VNIC_RXC_PKTABORT
+#  define GET_VNIC_RXC_PKTABORT(p)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_P=
KTABORT_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_PKTABORT_SHIFTED
+#  define GET_VNIC_RXC_PKTABORT_SHIFTED(p)             \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
PKTABORT_MASK))>>VNIC_RXC_PKTABORT_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_PKTABORT
+#  define GET_NTOH_VNIC_RXC_PKTABORT(p)                \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_PKTABORT_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_PKTABORT_SHIFTED
+#  define GET_NTOH_VNIC_RXC_PKTABORT_SHIFTED(p)                \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_PKTABORT_MASK))>>VNIC_RXC_PKTABORT_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_PKTABORT
+#  define SET_VNIC_RXC_PKTABORT(p,val)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_PKTABORT_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_PKTABORT_SHIFTED
+#  define SET_VNIC_RXC_PKTABORT_SHIFTED(p,val)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_PKTABORT_SHIFT)& VNIC_RXC_PKTABORT_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_PKTABORT
+#  define CLR_VNIC_RXC_PKTABORT(p)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_PKTABORT_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_PKTABORT
+#  define SET_HTON_VNIC_RXC_PKTABORT(p,val)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_PKTABORT_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_PKTABORT_SHIFTED
+#  define SET_HTON_VNIC_RXC_PKTABORT_SHIFTED(p,val)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_PKTABORT_SHIFT)& VNIC_RXC_PKTABORT_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_PKTABORT
+#  define CLR_HTON_VNIC_RXC_PKTABORT(p)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_PKTABORT_MASK))
+#endif
+      /* Packet aborted (0x1<<25) */
+#     define VNIC_RXC_ISPKTABORT_W     0x02000000
+
+   /* RESERVED */
+#  define VNIC_RXC_UNUSED4_WORD        3
+#  define VNIC_RXC_UNUSED4_MASK        0x01000000
+#  define VNIC_RXC_UNUSED4_SHIFT       24
+#ifndef  GET_VNIC_RXC_UNUSED4
+#  define GET_VNIC_RXC_UNUSED4(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_U=
NUSED4_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_UNUSED4_SHIFTED
+#  define GET_VNIC_RXC_UNUSED4_SHIFTED(p)              \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
UNUSED4_MASK))>>VNIC_RXC_UNUSED4_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED4
+#  define GET_NTOH_VNIC_RXC_UNUSED4(p)         \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_UNUSED4_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED4_SHIFTED
+#  define GET_NTOH_VNIC_RXC_UNUSED4_SHIFTED(p)         \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_UNUSED4_MASK))>>VNIC_RXC_UNUSED4_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED4
+#  define SET_VNIC_RXC_UNUSED4(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_UNUSED4_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED4_SHIFTED
+#  define SET_VNIC_RXC_UNUSED4_SHIFTED(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_UNUSED4_SHIFT)& VNIC_RXC_UNUSED4_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_UNUSED4
+#  define CLR_VNIC_RXC_UNUSED4(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_UNUSED4_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED4
+#  define SET_HTON_VNIC_RXC_UNUSED4(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_UNUSED4_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED4_SHIFTED
+#  define SET_HTON_VNIC_RXC_UNUSED4_SHIFTED(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_UNUSED4_SHIFT)& VNIC_RXC_UNUSED4_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_UNUSED4
+#  define CLR_HTON_VNIC_RXC_UNUSED4(p)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_UNUSED4_MASK))
+#endif
+
+   /* RESERVED */
+#  define VNIC_RXC_UNUSED5_WORD        3
+#  define VNIC_RXC_UNUSED5_MASK        0x00f00000
+#  define VNIC_RXC_UNUSED5_SHIFT       20
+#ifndef  GET_VNIC_RXC_UNUSED5
+#  define GET_VNIC_RXC_UNUSED5(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_U=
NUSED5_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_UNUSED5_SHIFTED
+#  define GET_VNIC_RXC_UNUSED5_SHIFTED(p)              \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
UNUSED5_MASK))>>VNIC_RXC_UNUSED5_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED5
+#  define GET_NTOH_VNIC_RXC_UNUSED5(p)         \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_UNUSED5_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_UNUSED5_SHIFTED
+#  define GET_NTOH_VNIC_RXC_UNUSED5_SHIFTED(p)         \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_UNUSED5_MASK))>>VNIC_RXC_UNUSED5_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED5
+#  define SET_VNIC_RXC_UNUSED5(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_UNUSED5_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_UNUSED5_SHIFTED
+#  define SET_VNIC_RXC_UNUSED5_SHIFTED(p,val)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_UNUSED5_SHIFT)& VNIC_RXC_UNUSED5_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_UNUSED5
+#  define CLR_VNIC_RXC_UNUSED5(p)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_UNUSED5_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED5
+#  define SET_HTON_VNIC_RXC_UNUSED5(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_UNUSED5_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_UNUSED5_SHIFTED
+#  define SET_HTON_VNIC_RXC_UNUSED5_SHIFTED(p,val)             \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_UNUSED5_SHIFT)& VNIC_RXC_UNUSED5_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_UNUSED5
+#  define CLR_HTON_VNIC_RXC_UNUSED5(p)         \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_UNUSED5_MASK))
+#endif
+
+   /* RxD queue ID for this packet buffer */
+#  define VNIC_RXC_RXQ_ID_WORD 3
+#  define VNIC_RXC_RXQ_ID_MASK 0x000f0000
+#  define VNIC_RXC_RXQ_ID_SHIFT        16
+#ifndef  GET_VNIC_RXC_RXQ_ID
+#  define GET_VNIC_RXC_RXQ_ID(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_R=
XQ_ID_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_RXQ_ID_SHIFTED
+#  define GET_VNIC_RXC_RXQ_ID_SHIFTED(p)               \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
RXQ_ID_MASK))>>VNIC_RXC_RXQ_ID_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_RXQ_ID
+#  define GET_NTOH_VNIC_RXC_RXQ_ID(p)          \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_RXQ_ID_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_RXQ_ID_SHIFTED
+#  define GET_NTOH_VNIC_RXC_RXQ_ID_SHIFTED(p)          \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_RXQ_ID_MASK))>>VNIC_RXC_RXQ_ID_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_RXQ_ID
+#  define SET_VNIC_RXC_RXQ_ID(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_RXQ_ID_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_RXQ_ID_SHIFTED
+#  define SET_VNIC_RXC_RXQ_ID_SHIFTED(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_RXQ_ID_SHIFT)& VNIC_RXC_RXQ_ID_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_RXQ_ID
+#  define CLR_VNIC_RXC_RXQ_ID(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_RXQ_ID_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_RXQ_ID
+#  define SET_HTON_VNIC_RXC_RXQ_ID(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_RXQ_ID_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_RXQ_ID_SHIFTED
+#  define SET_HTON_VNIC_RXC_RXQ_ID_SHIFTED(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_RXQ_ID_SHIFT)& VNIC_RXC_RXQ_ID_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_RXQ_ID
+#  define CLR_HTON_VNIC_RXC_RXQ_ID(p)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_RXQ_ID_MASK))
+#endif
+
+   /* Type of the packet fragment in the buffer */
+#  define VNIC_RXC_FRAG_TYPE_WORD      3
+#  define VNIC_RXC_FRAG_TYPE_MASK      0x0000c000
+#  define VNIC_RXC_FRAG_TYPE_SHIFT     14
+#ifndef  GET_VNIC_RXC_FRAG_TYPE
+#  define GET_VNIC_RXC_FRAG_TYPE(p)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_F=
RAG_TYPE_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_FRAG_TYPE_SHIFTED
+#  define GET_VNIC_RXC_FRAG_TYPE_SHIFTED(p)            \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
=46RAG_TYPE_MASK))>>VNIC_RXC_FRAG_TYPE_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_FRAG_TYPE
+#  define GET_NTOH_VNIC_RXC_FRAG_TYPE(p)               \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_FRAG_TYPE_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_FRAG_TYPE_SHIFTED
+#  define GET_NTOH_VNIC_RXC_FRAG_TYPE_SHIFTED(p)               \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_FRAG_TYPE_MASK))>>VNIC_RXC_FRAG_TYPE_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_FRAG_TYPE
+#  define SET_VNIC_RXC_FRAG_TYPE(p,val)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_FRAG_TYPE_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_FRAG_TYPE_SHIFTED
+#  define SET_VNIC_RXC_FRAG_TYPE_SHIFTED(p,val)                \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_FRAG_TYPE_SHIFT)& VNIC_RXC_FRAG_TYPE_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_FRAG_TYPE
+#  define CLR_VNIC_RXC_FRAG_TYPE(p)            \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_FRAG_TYPE_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_FRAG_TYPE
+#  define SET_HTON_VNIC_RXC_FRAG_TYPE(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_FRAG_TYPE_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_FRAG_TYPE_SHIFTED
+#  define SET_HTON_VNIC_RXC_FRAG_TYPE_SHIFTED(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_FRAG_TYPE_SHIFT)& VNIC_RXC_FRAG_TYPE_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_FRAG_TYPE
+#  define CLR_HTON_VNIC_RXC_FRAG_TYPE(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_FRAG_TYPE_MASK))
+#endif
+      /* Desc contains pkt body only (0x0<<14) */
+#     define VNIC_RXC_FRAG_BODY_W      0x00000000
+      /* Desc contains pkt tail (0x1<<14) */
+#     define VNIC_RXC_FRAG_TAIL_W      0x00004000
+      /* Desc contains pkt head (0x2<<14) */
+#     define VNIC_RXC_FRAG_HEAD_W      0x00008000
+      /* Desc contains pkt head, body & tail (0x3<<14) */
+#     define VNIC_RXC_FRAG_ALL_W       0x0000c000
+
+   /* 14-Bit Count of bytes written into associated buffer */
+#  define VNIC_RXC_LENGTH_WORD 3
+#  define VNIC_RXC_LENGTH_MASK 0x00003fff
+#  define VNIC_RXC_LENGTH_SHIFT        0
+#ifndef  GET_VNIC_RXC_LENGTH
+#  define GET_VNIC_RXC_LENGTH(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_L=
ENGTH_MASK))
+#endif
+#ifndef  GET_VNIC_RXC_LENGTH_SHIFTED
+#  define GET_VNIC_RXC_LENGTH_SHIFTED(p)               \
+               (((((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_RXC_=
LENGTH_MASK))>>VNIC_RXC_LENGTH_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_LENGTH
+#  define GET_NTOH_VNIC_RXC_LENGTH(p)          \
+               (ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC_=
RXC_LENGTH_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXC_LENGTH_SHIFTED
+#  define GET_NTOH_VNIC_RXC_LENGTH_SHIFTED(p)          \
+               ((ntohl(((struct rxc_pktDesc_Phys_w *)p)->word_3)&(VNIC=
_RXC_LENGTH_MASK))>>VNIC_RXC_LENGTH_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXC_LENGTH
+#  define SET_VNIC_RXC_LENGTH(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D (val &=
 VNIC_RXC_LENGTH_MASK))
+#endif
+#ifndef  SET_VNIC_RXC_LENGTH_SHIFTED
+#  define SET_VNIC_RXC_LENGTH_SHIFTED(p,val)           \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D ((val<=
<VNIC_RXC_LENGTH_SHIFT)& VNIC_RXC_LENGTH_MASK))
+#endif
+#ifndef  CLR_VNIC_RXC_LENGTH
+#  define CLR_VNIC_RXC_LENGTH(p)               \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D (~VNIC=
_RXC_LENGTH_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_LENGTH
+#  define SET_HTON_VNIC_RXC_LENGTH(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
val & VNIC_RXC_LENGTH_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXC_LENGTH_SHIFTED
+#  define SET_HTON_VNIC_RXC_LENGTH_SHIFTED(p,val)              \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) |=3D htonl(=
(val<<VNIC_RXC_LENGTH_SHIFT)& VNIC_RXC_LENGTH_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXC_LENGTH
+#  define CLR_HTON_VNIC_RXC_LENGTH(p)          \
+               ((((struct rxc_pktDesc_Phys_w *)p)->word_3) &=3D htonl(=
~VNIC_RXC_LENGTH_MASK))
+#endif
+
+};
+
+struct rxc_pktStatusBlock_w {
+       u32 word_0;
+
+   /* Current index in associated rxc */
+#  define VNIC_RXS_IDX_WORD    0
+#  define VNIC_RXS_IDX_MASK    0xffff0000
+#  define VNIC_RXS_IDX_SHIFT   16
+#ifndef  GET_VNIC_RXS_IDX
+#  define GET_VNIC_RXS_IDX(p)          \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0)&(VNIC_RXS=
_IDX_MASK))
+#endif
+#ifndef  GET_VNIC_RXS_IDX_SHIFTED
+#  define GET_VNIC_RXS_IDX_SHIFTED(p)          \
+               (((((struct rxc_pktStatusBlock_w *)p)->word_0)&(VNIC_RX=
S_IDX_MASK))>>VNIC_RXS_IDX_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXS_IDX
+#  define GET_NTOH_VNIC_RXS_IDX(p)             \
+               (ntohl(((struct rxc_pktStatusBlock_w *)p)->word_0)&(VNI=
C_RXS_IDX_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXS_IDX_SHIFTED
+#  define GET_NTOH_VNIC_RXS_IDX_SHIFTED(p)             \
+               ((ntohl(((struct rxc_pktStatusBlock_w *)p)->word_0)&(VN=
IC_RXS_IDX_MASK))>>VNIC_RXS_IDX_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXS_IDX
+#  define SET_VNIC_RXS_IDX(p,val)              \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) |=3D (val=
 & VNIC_RXS_IDX_MASK))
+#endif
+#ifndef  SET_VNIC_RXS_IDX_SHIFTED
+#  define SET_VNIC_RXS_IDX_SHIFTED(p,val)              \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) |=3D ((va=
l<<VNIC_RXS_IDX_SHIFT)& VNIC_RXS_IDX_MASK))
+#endif
+#ifndef  CLR_VNIC_RXS_IDX
+#  define CLR_VNIC_RXS_IDX(p)          \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) &=3D (~VN=
IC_RXS_IDX_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXS_IDX
+#  define SET_HTON_VNIC_RXS_IDX(p,val)         \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) |=3D hton=
l(val & VNIC_RXS_IDX_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXS_IDX_SHIFTED
+#  define SET_HTON_VNIC_RXS_IDX_SHIFTED(p,val)         \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) |=3D hton=
l((val<<VNIC_RXS_IDX_SHIFT)& VNIC_RXS_IDX_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXS_IDX
+#  define CLR_HTON_VNIC_RXS_IDX(p)             \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) &=3D hton=
l(~VNIC_RXS_IDX_MASK))
+#endif
+
+   /* RESERVED */
+#  define VNIC_RXS_UNUSED0_WORD        0
+#  define VNIC_RXS_UNUSED0_MASK        0x0000ffff
+#  define VNIC_RXS_UNUSED0_SHIFT       0
+#ifndef  GET_VNIC_RXS_UNUSED0
+#  define GET_VNIC_RXS_UNUSED0(p)              \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0)&(VNIC_RXS=
_UNUSED0_MASK))
+#endif
+#ifndef  GET_VNIC_RXS_UNUSED0_SHIFTED
+#  define GET_VNIC_RXS_UNUSED0_SHIFTED(p)              \
+               (((((struct rxc_pktStatusBlock_w *)p)->word_0)&(VNIC_RX=
S_UNUSED0_MASK))>>VNIC_RXS_UNUSED0_SHIFT)
+#endif
+#ifndef  GET_NTOH_VNIC_RXS_UNUSED0
+#  define GET_NTOH_VNIC_RXS_UNUSED0(p)         \
+               (ntohl(((struct rxc_pktStatusBlock_w *)p)->word_0)&(VNI=
C_RXS_UNUSED0_MASK))
+#endif
+#ifndef  GET_NTOH_VNIC_RXS_UNUSED0_SHIFTED
+#  define GET_NTOH_VNIC_RXS_UNUSED0_SHIFTED(p)         \
+               ((ntohl(((struct rxc_pktStatusBlock_w *)p)->word_0)&(VN=
IC_RXS_UNUSED0_MASK))>>VNIC_RXS_UNUSED0_SHIFT)
+#endif
+#ifndef  SET_VNIC_RXS_UNUSED0
+#  define SET_VNIC_RXS_UNUSED0(p,val)          \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) |=3D (val=
 & VNIC_RXS_UNUSED0_MASK))
+#endif
+#ifndef  SET_VNIC_RXS_UNUSED0_SHIFTED
+#  define SET_VNIC_RXS_UNUSED0_SHIFTED(p,val)          \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) |=3D ((va=
l<<VNIC_RXS_UNUSED0_SHIFT)& VNIC_RXS_UNUSED0_MASK))
+#endif
+#ifndef  CLR_VNIC_RXS_UNUSED0
+#  define CLR_VNIC_RXS_UNUSED0(p)              \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) &=3D (~VN=
IC_RXS_UNUSED0_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXS_UNUSED0
+#  define SET_HTON_VNIC_RXS_UNUSED0(p,val)             \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) |=3D hton=
l(val & VNIC_RXS_UNUSED0_MASK))
+#endif
+#ifndef  SET_HTON_VNIC_RXS_UNUSED0_SHIFTED
+#  define SET_HTON_VNIC_RXS_UNUSED0_SHIFTED(p,val)             \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) |=3D hton=
l((val<<VNIC_RXS_UNUSED0_SHIFT)& VNIC_RXS_UNUSED0_MASK))
+#endif
+#ifndef  CLR_HTON_VNIC_RXS_UNUSED0
+#  define CLR_HTON_VNIC_RXS_UNUSED0(p)         \
+               ((((struct rxc_pktStatusBlock_w *)p)->word_0) &=3D hton=
l(~VNIC_RXS_UNUSED0_MASK))
+#endif
+
+};
+
+/*
+ * Rx Descriptor macros
+ */
+#define VNIC_RX_BUFADDR_MASK ((u64) \
+       ((u64) VNIC_RX_BUFADDR_HI_MASK << 32) | \
+       (u64) VNIC_RX_BUFADDR_LO_MASK)
+
+#define VNIC_RX_DESC_HW_FLAG ((u64) VNIC_RX_OWNED_HW_W << 32)
+
+#define SET_VNIC_RX_BUFADDR(d, bufaddr) do {                          =
 \
+       *((dma_addr_t *) d) =3D \
+       ((dma_addr_t) bufaddr & VIOC_RX_BUFADDR_MASK); \
+}while (0)
+
+#define SET_VNIC_RX_BUFADDR_HW(d, bufaddr) do {                       =
         \
+       *((dma_addr_t *) d) =3D \
+       (((dma_addr_t) bufaddr & VNIC_RX_BUFADDR_MASK) | \
+       VNIC_RX_DESC_HW_FLAG) ; \
+} while (0)
+
+#endif /* _VNIC_H_ */
+
diff -puN /dev/null drivers/net/vioc/khash.h
--- /dev/null
+++ a/drivers/net/vioc/khash.h
@@ -0,0 +1,65 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ *
+ * Copyright (C) 2002, 2003, 2004  David G=F3mez <david@pleyades.net>
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#ifndef __HASHIT__
+#define __HASHIT__
+
+#define CHAIN_H 0U
+#define OADDRESS_H 1U
+#define OVERFLOW_H 2U
+
+#include <linux/stddef.h>
+#include <linux/errno.h>
+#include <linux/vmalloc.h>
+#include <linux/string.h>
+
+struct shash_t;
+
+/* Elem is used both for chain and overflow hash */
+struct hash_elem_t {
+    struct hash_elem_t *next;
+    void *key;
+    void *data;
+       void (*cb_fn)(u32, void *, int, u32);
+       u32      command;
+       u32      timestamp;
+       spinlock_t lock;
+};
+
+
+struct shash_t  *hashT_create(u32, size_t, size_t, u32(*)(unsigned cha=
r *, unsigned long), int(*)(void *, void *), unsigned int);
+int hashT_delete(struct shash_t * , void *);
+struct hash_elem_t *hashT_lookup(struct shash_t * , void *);
+struct hash_elem_t *hashT_add(struct shash_t *, void *);
+void hashT_destroy(struct shash_t *);
+/* Accesors */
+void **hashT_getkeys(struct shash_t *);
+size_t hashT_tablesize(struct shash_t *);
+size_t hashT_size(struct shash_t *);
+
+#endif
diff -puN /dev/null drivers/net/vioc/spp.c
--- /dev/null
+++ a/drivers/net/vioc/spp.c
@@ -0,0 +1,626 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ *
+ * Copyright (C) 2002, 2003, 2004  David G=F3mez <david@pleyades.net>
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include <linux/module.h>
+#include "f7/vioc_hw_registers.h"
+#include "f7/spp.h"
+#include "f7/sppapi.h"
+
+#include "vioc_vnic.h"
+#include "vioc_api.h"
+#include "khash.h"
+
+#define FACILITY_CNT   16
+
+#define mix(a,b,c) \
+{ \
+  a -=3D b; a -=3D c; a ^=3D (c >> 13); \
+  b -=3D c; b -=3D a; b ^=3D (a << 8); \
+  c -=3D a; c -=3D b; c ^=3D (b >> 13); \
+  a -=3D b; a -=3D c; a ^=3D (c >> 12);  \
+  b -=3D c; b -=3D a; b ^=3D (a << 16); \
+  c -=3D a; c -=3D b; c ^=3D (b >> 5); \
+  a -=3D b; a -=3D c; a ^=3D (c >> 3);  \
+  b -=3D c; b -=3D a; b ^=3D (a << 10); \
+  c -=3D a; c -=3D b; c ^=3D (b >> 15); \
+}
+
+
+struct shash_t {
+	/* Common fields for all hash tables types */
+	size_t tsize;		/* Table size */
+	size_t ksize;		/* Key size is fixed at creation time */
+	size_t dsize;		/* Data size is fixed at creation time */
+	size_t nelems;		/* Number of elements in the hash table */
+	struct hash_ops *h_ops;
+	 u32(*hash_fn) (unsigned char *, unsigned long);
+	void (*copy_fn) (void *, int, void *);
+	int (*compare_fn) (void *, void *);
+	struct hash_elem_t **chtable;	/* Data for the collision */
+};
+
+struct hash_ops {
+	int (*delete) (struct shash_t *, void *);
+	struct hash_elem_t *(*lookup) (struct shash_t *, void *);
+	void (*destroy) (struct shash_t *);
+	struct hash_elem_t *(*add) (struct shash_t *, void *);
+	void **(*getkeys) (struct shash_t *);
+};
+
+struct facility {
+	struct shash_t *hashT;
+	spinlock_t lock;
+};
+
+static u32 hash_func(unsigned char *k, unsigned long length)
+{
+	unsigned long a, b, c, len;
+
+	/* Set up the internal state */
+	len =3D length;
+	a =3D b =3D c =3D 0x9e3779b9;	/* the golden ratio; an arbitrary value=
 */
+
+	/* Handle most of the key */
+	while (len >=3D 12) {
+		a +=3D (k[0] + ((unsigned long)k[1] << 8) +
+		      ((unsigned long)k[2] << 16) +
+		      ((unsigned long)k[3] << 24));
+		b +=3D (k[4] + ((unsigned long)k[5] << 8) +
+		      ((unsigned long)k[6] << 16) +
+		      ((unsigned long)k[7] << 24));
+		c +=3D (k[8] + ((unsigned long)k[9] << 8) +
+		      ((unsigned long)k[10] << 16) +
+		      ((unsigned long)k[11] << 24));
+		mix(a, b, c);
+		k +=3D 12;
+		len -=3D 12;
+	}
+
+	/* Handle the last 11 bytes */
+	c +=3D length;
+	switch (len) {		/* all the case statements fall through */
+	case 11:
+		c +=3D ((unsigned long)k[10] << 24);
+	case 10:
+		c +=3D ((unsigned long)k[9] << 16);
+	case 9:
+		c +=3D ((unsigned long)k[8] << 8);
+		/* the first byte of c is reserved for the length */
+	case 8:
+		b +=3D ((unsigned long)k[7] << 24);
+	case 7:
+		b +=3D ((unsigned long)k[6] << 16);
+	case 6:
+		b +=3D ((unsigned long)k[5] << 8);
+	case 5:
+		b +=3D k[4];
+	case 4:
+		a +=3D ((unsigned long)k[3] << 24);
+	case 3:
+		a +=3D ((unsigned long)k[2] << 16);
+	case 2:
+		a +=3D ((unsigned long)k[1] << 8);
+	case 1:
+		a +=3D k[0];
+	}
+	mix(a, b, c);
+
+	return c;
+}
+
+static u32 gethash(struct shash_t *htable, void *key)
+{
+	size_t len;
+
+	len =3D htable->ksize;
+
+	/* Hash the key and get the meaningful bits for our table */
+	return ((htable->hash_fn(key, len)) & (htable->tsize - 1));
+}
+
+/* Data associated to this key MUST be freed by the caller */
+static int ch_delete(struct shash_t *htable, void *key)
+{
+	u32 idx;
+	struct hash_elem_t *cursor;	/* Cursor for the linked list */
+	struct hash_elem_t *tmp;	/* Pointer to the element to be deleted */
+
+	idx =3D gethash(htable, key);
+
+	if (!htable->chtable[idx])
+		return -1;
+
+	/* Delete asked element */
+	/* Element to delete is the first in the chain */
+	if (htable->compare_fn(htable->chtable[idx]->key, key) =3D=3D 0) {
+		tmp =3D htable->chtable[idx];
+		htable->chtable[idx] =3D tmp->next;
+		vfree(tmp);
+		htable->nelems--;
+		return 0;
+	}
+	/* Search thru the chain for the element */
+	else {
+		cursor =3D htable->chtable[idx];
+		while (cursor->next !=3D NULL) {
+			if (htable->compare_fn(cursor->next->key, key) =3D=3D 0) {
+				tmp =3D cursor->next;
+				cursor->next =3D tmp->next;
+				vfree(tmp);
+				htable->nelems--;
+				return 0;
+			}
+			cursor =3D cursor->next;
+		}
+	}
+
+	return -1;
+}
+
+static void ch_destroy(struct shash_t *htable)
+{
+	u32 idx;
+	struct hash_elem_t *cursor;
+
+	for (idx =3D 0; idx < htable->tsize; idx++) {
+		cursor =3D htable->chtable[idx];
+
+		while (cursor !=3D NULL) {
+			struct hash_elem_t *tmp_cursor =3D cursor;
+
+			cursor =3D cursor->next;
+			vfree(tmp_cursor);
+		}
+	}
+	vfree(htable->chtable);
+}
+
+/* Return a NULL terminated string of pointers to all hash table keys =
*/
+static void **ch_getkeys(struct shash_t *htable)
+{
+	u32 idx;
+	struct hash_elem_t *cursor;
+	void **keys;
+	u32 kidx;
+
+	keys =3D vmalloc((htable->nelems + 1) * sizeof(void *));
+	if (!keys) {
+		return NULL;
+	}
+	keys[htable->nelems] =3D NULL;
+	kidx =3D 0;
+
+	for (idx =3D 0; idx < htable->tsize; idx++) {
+
+		cursor =3D htable->chtable[idx];
+		while (cursor !=3D NULL) {
+			printk(KERN_INFO "Element %d in bucket %d, key %p value %px\n",
+			       kidx, idx, cursor->key, cursor->data);
+			keys[kidx] =3D cursor->key;
+			kidx++;
+
+			cursor =3D cursor->next;
+		}
+	}
+
+	return keys;
+}
+
+/* Accesors **********************************************************=
********/
+inline size_t hashT_tablesize(struct shash_t * htable)
+{
+	return htable->tsize;
+}
+
+inline size_t hashT_size(struct shash_t * htable)
+{
+	return htable->nelems;
+}
+
+static struct hash_elem_t *ch_lookup(struct shash_t *htable, void *key=
)
+{
+	u32 idx;
+	struct hash_elem_t *cursor;
+
+	idx =3D gethash(htable, key);
+
+	cursor =3D htable->chtable[idx];
+
+	/* Search thru the chain for the asked key */
+	while (cursor !=3D NULL) {
+		if (htable->compare_fn(cursor->key, key) =3D=3D 0)
+			return cursor;
+		cursor =3D cursor->next;
+	}
+
+	return NULL;
+}
+
+static struct hash_elem_t *ch_add(struct shash_t *htable, void *key)
+{
+	u32 idx;
+	struct hash_elem_t *cursor;
+	struct hash_elem_t *oneelem;
+
+	idx =3D gethash(htable, key);
+
+	cursor =3D htable->chtable[idx];
+
+	/* Search thru the chain for the asked key */
+	while (cursor !=3D NULL) {
+		if (htable->compare_fn(cursor->key, key) =3D=3D 0)
+			break;
+		cursor =3D cursor->next;
+	}
+
+	if (!cursor) {
+		/* cursor =3D=3D NULL, means, that no element with this key was foun=
d,
+		 * need to insert one
+		 */
+		oneelem =3D
+		    (struct hash_elem_t *)vmalloc(sizeof(struct hash_elem_t) +
+						  htable->ksize +
+						  htable->dsize);
+		if (!oneelem)
+			return (struct hash_elem_t *)NULL;
+		memset((void *)oneelem, 0,
+		       sizeof(struct hash_elem_t) + htable->ksize +
+		       htable->dsize);
+
+		oneelem->command =3D 0;
+		oneelem->key =3D (void *)((char *)oneelem + sizeof(struct hash_elem_=
t));
+		oneelem->data =3D (void *)((char *)oneelem->key + htable->ksize);
+		memcpy((void *)oneelem->key, (void *)key, htable->ksize);
+
+		oneelem->next =3D NULL;
+
+		if (htable->chtable[idx] =3D=3D NULL)
+			/* No collision ;), first element in this bucket */
+			htable->chtable[idx] =3D oneelem;
+		else {
+			/* Collision, insert at the end of the chain */
+			cursor =3D htable->chtable[idx];
+			while (cursor->next !=3D NULL)
+				cursor =3D cursor->next;
+
+			/* Insert element at the end of the chain */
+			cursor->next =3D oneelem;
+		}
+
+		htable->nelems++;
+		spin_lock_init(&oneelem->lock);
+	} else {
+		/* Found element with the key */
+		oneelem =3D cursor;
+	}
+
+	return oneelem;
+}
+
+static int key_compare(void *key_in, void *key_out)
+{
+	if ((u16) * ((u16 *) key_in) =3D=3D (u16) * ((u16 *) key_out))
+		return 0;
+	else
+		return 1;
+}
+
+struct hash_ops ch_ops =3D {
+	.delete =3D ch_delete,
+	.lookup =3D ch_lookup,
+	.destroy =3D ch_destroy,
+	.getkeys =3D ch_getkeys,
+	.add =3D ch_add
+};
+
+struct facility fTable[FACILITY_CNT];
+
+int spp_init(void)
+{
+	int i;
+
+	for (i =3D 0; i < FACILITY_CNT; i++) {
+		fTable[i].hashT =3D NULL;
+		spin_lock_init(&fTable[i].lock);
+	}
+
+	spp_vnic_init();
+
+	return 0;
+}
+
+void spp_terminate(void)
+{
+	int i;
+
+	spp_vnic_exit();
+
+	for (i =3D 0; i < FACILITY_CNT; i++) {
+		if (fTable[i].hashT) {
+			spin_lock(&fTable[i].lock);
+			hashT_destroy(fTable[i].hashT);
+			fTable[i].hashT =3D NULL;
+			spin_unlock(&fTable[i].lock);
+		}
+	}
+}
+
+void spp_msg_from_sim(int vioc_idx)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(vioc_idx);
+	u32 command_reg, pmm_reply;
+	u32 key, facility, uniqid;
+	u32 *data_p;
+	struct hash_elem_t *elem;
+	int i;
+
+	vioc_reg_rd(viocdev->ba.virt, SPP_SIM_PMM_CMDREG, &command_reg);
+
+	if (spp_mbox_empty(command_reg)) {
+		return;
+	}
+
+	/* Validate checksum */
+	if (spp_validate_u32_chksum(command_reg) !=3D 0) {
+		return;
+	}
+
+	/* Build reply message to SIM */
+	pmm_reply =3D spp_mbox_build_reply(command_reg, SPP_CMD_OK);
+
+	key =3D SPP_GET_KEY(command_reg);
+	facility =3D SPP_GET_FACILITY(command_reg);
+	uniqid =3D SPP_GET_UNIQID(command_reg);
+
+	/* Check-and-create hash table */
+	spin_lock(&fTable[facility].lock);
+
+	if (fTable[facility].hashT =3D=3D NULL) {
+		fTable[facility].hashT =3D
+		    hashT_create(1024, 2, 128, NULL, key_compare, 0);
+		if (fTable[facility].hashT =3D=3D NULL) {
+			goto error_exit;
+		}
+	}
+
+	/* Add the hash table element */
+	elem =3D hashT_add(fTable[facility].hashT, (void *)&key);
+	if (!elem) {
+		goto error_exit;
+	}
+	spin_unlock(&fTable[facility].lock);
+
+	/* Copy data from SPP Registers to the key buffer */
+	spin_lock(&elem->lock);
+
+	/* Copy data from SPP Register Bank */
+	for (i =3D 0, data_p =3D (u32 *) elem->data; i < SPP_BANK_REGS;
+	     i++, (u32 *) data_p++) {
+		vioc_reg_rd(viocdev->ba.virt, SPP_SIM_PMM_DATA + (i << 2), (u32 *) d=
ata_p);
+	}
+
+	elem->command =3D command_reg;
+	elem->timestamp++;
+	elem->timestamp =3D (elem->timestamp & 0x0fffffff) | (vioc_idx << 28)=
;
+
+	spin_unlock(&elem->lock);
+
+	vioc_reg_wr(pmm_reply, viocdev->ba.virt, SPP_SIM_PMM_CMDREG);
+	viocdev->last_msg_to_sim =3D pmm_reply;
+
+	/* If there was registered callback, execute it */
+	if (elem->cb_fn) {
+		spin_lock(&elem->lock);
+		if (spp_validate_u32_chksum(elem->command) =3D=3D 0) {
+			/* If there is a valid message waiting, call callback */
+			elem->cb_fn(elem->command,
+				    elem->data, 128, elem->timestamp);
+			elem->command =3D 0;
+		}
+		spin_unlock(&elem->lock);
+	}
+	return;
+
+      error_exit:
+	spin_unlock(&fTable[facility].lock);
+	pmm_reply =3D spp_mbox_build_reply(command_reg, SPP_CMD_FAIL);
+	vioc_reg_wr(pmm_reply, viocdev->ba.virt, SPP_SIM_PMM_CMDREG);
+	return;
+
+}
+
+int spp_msg_register(u32 key_facility, void (*cb_fn) (u32, void *, int=
, u32))
+{
+	u32 facility =3D SPP_GET_FACILITY(key_facility);
+	u32 key =3D SPP_GET_KEY(key_facility);
+	struct hash_elem_t *elem;
+
+	/* Check-and-create hash table */
+	spin_lock(&fTable[facility].lock);
+
+	if (fTable[facility].hashT =3D=3D NULL) {
+		fTable[facility].hashT =3D
+		    hashT_create(1024, 2, 128, NULL, key_compare, 0);
+		if (fTable[facility].hashT =3D=3D NULL) {
+			goto error_exit;
+		}
+	}
+
+	/* Add the hash table element */
+	elem =3D hashT_add(fTable[facility].hashT, (void *)&key);
+	if (!elem) {
+		goto error_exit;
+	}
+	spin_unlock(&fTable[facility].lock);
+
+	spin_lock(&elem->lock);
+	elem->cb_fn =3D cb_fn;
+	if (spp_validate_u32_chksum(elem->command) =3D=3D 0) {
+		/* If there is a valid message waiting, call callback */
+		elem->cb_fn(elem->command, elem->data, 128, elem->timestamp);
+		elem->command =3D 0;
+	}
+	spin_unlock(&elem->lock);
+	return SPP_CMD_OK;
+
+      error_exit:
+	spin_unlock(&fTable[facility].lock);
+	return SPP_CMD_FAIL;
+}
+
+void spp_msg_unregister(u32 key_facility)
+{
+	u32 key =3D SPP_GET_KEY(key_facility);
+	u32 facility =3D SPP_GET_FACILITY(key_facility);
+	struct hash_elem_t *elem;
+
+	if (fTable[facility].hashT =3D=3D NULL)
+		return;
+
+	elem =3D hashT_lookup(fTable[facility].hashT, (void *)&key);
+	if (!elem)
+		return;
+
+	spin_lock(&elem->lock);
+	elem->cb_fn =3D NULL;
+	spin_unlock(&elem->lock);
+}
+
+
+int read_spp_regbank32(int vioc_idx, int bank, char *buffer)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(vioc_idx);
+	int i;
+	u32 *data_p;
+	u32 reg;
+
+	if (!viocdev)
+		return 0;
+
+	/* Copy data from SPP Register Bank */
+	for (i =3D 0, data_p =3D (u32 *) buffer; i < SPP_BANK_REGS;
+	     i++, (u32 *) data_p++) {
+		reg =3D SPP_BANK_ADDR(bank) + (i << 2);
+		vioc_reg_rd(viocdev->ba.virt, reg, (u32 *) data_p);
+	}
+
+	return i;
+}
+
+struct shash_t *hashT_create(u32 sizehint,
+							size_t keybuf_size,
+							size_t databuf_size,
+							u32(*hfunc) (unsigned char *,
+							unsigned long),
+							int (*cfunc) (void *, void *),
+							unsigned int flags)
+{
+	struct shash_t *htable;
+	u32 size =3D 0;		/* Table size */
+	int i =3D 1;
+
+	/* Take the size hint and round it to the next higher power of two */
+	while (size < sizehint) {
+		size =3D 1 << i++;
+		if (size =3D=3D 0) {
+			size =3D 1 << (i - 2);
+			break;
+		}
+	}
+
+	if (cfunc =3D=3D NULL)
+		return NULL;
+
+	/* Create hash table */
+	htable =3D vmalloc(sizeof(struct shash_t) + keybuf_size + databuf_siz=
e);
+	if (!htable)
+		return NULL;
+
+	/* And create structs for hash table */
+
+	htable->h_ops =3D &ch_ops;
+	htable->chtable =3D vmalloc(size * (sizeof(struct hash_elem_t)
+							+ keybuf_size
+							+ databuf_size));
+	if (!htable->chtable) {
+		vfree(htable);
+		return NULL;
+	}
+
+	memset(htable->chtable, '\0',
+	       size * (sizeof(struct hash_elem_t) + keybuf_size + databuf_siz=
e));
+
+	/* Initialize hash table common fields */
+	htable->tsize =3D size;
+	htable->ksize =3D keybuf_size;
+	htable->dsize =3D databuf_size;
+	htable->nelems =3D 0;
+
+	if (hfunc)
+		htable->hash_fn =3D hfunc;
+	else
+		htable->hash_fn =3D hash_func;
+
+	htable->compare_fn =3D cfunc;
+
+	return htable;
+}
+
+int hashT_delete(struct shash_t *htable, void *key)
+{
+	return htable->h_ops->delete(htable, key);
+}
+
+struct hash_elem_t *hashT_add(struct shash_t *htable, void *key)
+{
+	return htable->h_ops->add(htable, key);
+}
+
+struct hash_elem_t *hashT_lookup(struct shash_t *htable, void *key)
+{
+	return htable->h_ops->lookup(htable, key);
+}
+
+void hashT_destroy(struct shash_t *htable)
+{
+
+	htable->h_ops->destroy(htable);
+
+	vfree(htable);
+}
+
+void **hashT_getkeys(struct shash_t *htable)
+{
+	return htable->h_ops->getkeys(htable);
+}
+
+#ifdef EXPORT_SYMTAB
+EXPORT_SYMBOL(spp_msg_register);
+EXPORT_SYMBOL(spp_msg_unregister);
+EXPORT_SYMBOL(read_spp_regbank32);
+#endif
diff -puN /dev/null drivers/net/vioc/spp_vnic.c
--- /dev/null
+++ a/drivers/net/vioc/spp_vnic.c
@@ -0,0 +1,131 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include <stdarg.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include "vioc_vnic.h"
+#include "vioc_api.h"
+#include "f7/sppapi.h"
+#include "f7/spp_msgdata.h"
+#include "f7/vioc_hw_registers.h"
+
+
+#define VIOC_ID_FROM_STAMP(stamp)      ((stamp >> 28) & 0xf)
+
+static u32 relative_time;
+
+static void spp_vnic_cb(u32 cmd, void *msg_buf, int buf_size, u32 vioc=
stamp)
+{
+	u32 param, param2;
+	int viocdev_idx;
+	u32 timestamp =3D viocstamp & 0x0fffffff;
+	int vioc_id =3D VIOC_ID_FROM_STAMP(viocstamp);
+
+	relative_time =3D timestamp;
+
+	viocdev_idx =3D ((int *)msg_buf)[SPP_VIOC_ID_IDX];
+	if (viocdev_idx !=3D vioc_id) {
+		printk(KERN_ERR "%s: MSG to VIOC=3D%d, but param VIOC=3D%d\n",
+		       __FUNCTION__, vioc_id, viocdev_idx);
+	}
+	param =3D vioc_rrd(viocdev_idx, VIOC_BMC, 0, VREG_BMC_VNIC_EN);
+	param2 =3D vioc_rrd(viocdev_idx, VIOC_BMC, 0, VREG_BMC_PORT_EN);
+#ifdef VNIC_UNREGISTER_PATCH
+	vioc_vnic_prov(viocdev_idx, param, param2, 1);
+#else
+	vioc_vnic_prov(viocdev_idx, param, param2, 0);
+#endif
+}
+
+static void spp_sys_cb(u32 cmd, void *msg_buf, int buf_size, u32 viocs=
tamp)
+{
+	u32 reset_type;
+	u32 timestamp =3D viocstamp & 0x0fffffff;
+
+	relative_time =3D timestamp;
+
+	reset_type =3D ((u32 *) msg_buf)[SPP_UOS_RESET_TYPE_IDX];
+	if (vioc_handle_reset_request(reset_type) < 0) {
+		/* Invalid reset type ..ignore the message */
+		printk(KERN_ERR "Invalid reset request %d\n", reset_type);
+	}
+}
+static void spp_prov_cb(u32 cmd, void *msg_buf, int buf_size, u32 vioc=
stamp)
+{
+	u32 timestamp =3D viocstamp & 0x0fffffff;
+
+	relative_time =3D timestamp;
+}
+
+struct kf_handler {
+	u32 key;
+	u32 facility;
+	void (*cb) (u32, void *, int, u32);
+};
+
+static
+struct kf_handler local_cb[] =3D {
+	{SPP_KEY_VNIC_CTL, SPP_FACILITY_VNIC, spp_vnic_cb},
+	{SPP_KEY_REQUEST_SIGNAL, SPP_FACILITY_SYS, spp_sys_cb},
+	{SPP_KEY_SET_PROV, SPP_FACILITY_VNIC, spp_prov_cb},
+	{0, 0, NULL}
+};
+
+int spp_vnic_init(void)
+{
+	u32 key_facility =3D 0;
+	int i;
+
+	for (i =3D 0; local_cb[i].cb; i++) {
+
+		SPP_SET_KEY(key_facility, local_cb[i].key);
+		SPP_SET_FACILITY(key_facility, local_cb[i].facility);
+
+		spp_msg_register(key_facility, local_cb[i].cb);
+	}
+	return 0;
+}
+
+void spp_vnic_exit(void)
+{
+	u32 key_facility =3D 0;
+	int i;
+
+	for (i =3D 0; local_cb[i].cb; i++) {
+
+		SPP_SET_KEY(key_facility, local_cb[i].key);
+		SPP_SET_FACILITY(key_facility, local_cb[i].facility);
+
+		spp_msg_unregister(key_facility);
+	}
+	return;
+}
+
diff -puN /dev/null drivers/net/vioc/vioc_api.c
--- /dev/null
+++ a/drivers/net/vioc/vioc_api.c
@@ -0,0 +1,384 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include <linux/autoconf.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/pci.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/byteorder.h>
+#include <asm/uaccess.h>
+
+#include "f7/vioc_hw_registers.h"
+#include "f7/vnic_defs.h"
+
+#include "vioc_vnic.h"
+#include "vioc_api.h"
+
+int vioc_set_rx_intr_param(int viocdev_idx, int rx_intr_id, u32 timeou=
t, u32 cntout)
+{
+	int ret =3D 0;
+	struct vioc_device *viocdev;
+	u64 regaddr;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+
+	regaddr =3D GETRELADDR(VIOC_IHCU, 0, (VREG_IHCU_RXCINTTIMER +
+							(rx_intr_id << 2)));
+	vioc_reg_wr(timeout, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_IHCU, 0, (VREG_IHCU_RXCINTPKTCNT +
+							(rx_intr_id << 2)));
+	vioc_reg_wr(cntout, viocdev->ba.virt, regaddr);
+
+	return ret;
+}
+
+
+int vioc_get_vnic_mac(int viocdev_idx, u32 vnic_id, u8 * p)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(viocdev_idx);
+	u64 regaddr;
+	u32 value;
+
+	regaddr =3D GETRELADDR(VIOC_VENG, vnic_id, VREG_VENG_MACADDRLO);
+	vioc_reg_rd(viocdev->ba.virt, regaddr, &value);
+	*((u32 *) & p[2]) =3D htonl(value);
+
+	regaddr =3D GETRELADDR(VIOC_VENG, vnic_id, VREG_VENG_MACADDRHI);
+	vioc_reg_rd(viocdev->ba.virt, regaddr, &value);
+	*((u16 *) & p[0]) =3D htons(value);
+
+	return 0;
+}
+
+int vioc_set_vnic_mac(int viocdev_idx, u32 vnic_id, u8 * p)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(viocdev_idx);
+	u64 regaddr;
+	u32 value;
+
+	regaddr =3D GETRELADDR(VIOC_VENG, vnic_id, VREG_VENG_MACADDRLO);
+	value =3D ntohl(*((u32 *) & p[2]));
+
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_VENG, vnic_id, VREG_VENG_MACADDRHI);
+	value =3D (ntohl(*((u32 *) & p[0])) >> 16) & 0xffff;
+
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	return 0;
+}
+
+int vioc_set_txq(int viocdev_idx, u32 vnic_id, u32 txq_id, dma_addr_t =
base,
+		 u32 num_elements)
+{
+	int ret =3D 0;
+	u32 value;
+	struct vioc_device *viocdev;
+	u64 regaddr;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+	if (vnic_id >=3D VIOC_MAX_VNICS)
+		goto parm_err_ret;
+
+	if (txq_id >=3D VIOC_MAX_TXQ)
+		goto parm_err_ret;
+
+	regaddr =3D GETRELADDR(VIOC_VENG, vnic_id, (VREG_VENG_TXD_W0 + (txq_i=
d << 5)));
+
+	value =3D base;
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_VENG, vnic_id, (VREG_VENG_TXD_W1 + (txq_i=
d << 5)));
+	value =3D (((base >> 16) >> 16) & 0x000000ff) |
+	    ((num_elements << 8) & 0x00ffff00);
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	/*
+	 * Enable Interrupt-on-Empty
+	 */
+	regaddr =3D GETRELADDR(VIOC_VENG, vnic_id, VREG_VENG_TXINTCTL);
+	vioc_reg_wr(VREG_VENG_TXINTCTL_INTONEMPTY_MASK, viocdev->ba.virt,
+		    regaddr);
+
+	return ret;
+
+      parm_err_ret:
+	return -EINVAL;
+}
+
+int vioc_set_rxc(int viocdev_idx, struct rxc *rxc)
+{
+	u32 value;
+	struct vioc_device *viocdev;
+	u64 regaddr;
+	int ret =3D 0;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+
+	regaddr =3D GETRELADDR(VIOC_IHCU, 0, (VREG_IHCU_RXC_LO + (rxc->rxc_id=
 << 4)));
+	value =3D rxc->dma;
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_IHCU, 0, (VREG_IHCU_RXC_HI + (rxc->rxc_id=
 << 4)));
+	value =3D (((rxc->dma >> 16) >> 16) & 0x000000ff) |
+	    ((rxc->count << 8) & 0x00ffff00);
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	/*
+	 * Set-up mapping between this RxC queue and Rx interrupt
+	 */
+	regaddr =3D GETRELADDR(VIOC_IHCU, 0, (VREG_IHCU_RXC_INT + (rxc->rxc_i=
d << 4)));
+	vioc_reg_wr((rxc->interrupt_id & 0xF), viocdev->ba.virt, regaddr);
+
+	ret =3D vioc_set_rx_intr_param(viocdev_idx,
+				     rxc->interrupt_id,
+				     viocdev->prov.run_param.rx_intr_timeout,
+				     viocdev->prov.run_param.rx_intr_cntout);
+	return ret;
+}
+
+int vioc_set_rxs(int viocdev_idx, dma_addr_t base)
+{
+	int ret =3D 0;
+	u32 value;
+	u64 regaddr;
+	struct vioc_device *viocdev;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+	regaddr =3D GETRELADDR(VIOC_IHCU, 0, VREG_IHCU_INTRSTATADDRLO);
+	value =3D base;
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+	regaddr =3D GETRELADDR(VIOC_IHCU, 0, VREG_IHCU_INTRSTATADDRHI);
+	value =3D ((base >> 16) >> 16) & 0x000000ff;
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	return ret;
+}
+
+int vioc_set_rxdq(int viocdev_idx, u32 vnic_id, u32 rxdq_id, u32 rx_bu=
fsize,
+		  dma_addr_t base, u32 num_elements)
+{
+	int ret =3D 0;
+	u32 value;
+	struct vioc_device *viocdev;
+	u64 regaddr;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+
+	regaddr =3D GETRELADDR(VIOC_IHCU, vnic_id, (VREG_IHCU_RXD_W0_R0 +
+							(rxdq_id << 4)));
+	value =3D base;
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_IHCU, vnic_id, (VREG_IHCU_RXD_W1_R0 +
+							(rxdq_id << 4)));
+	value =3D (((base >> 16) >> 16) & 0x000000ff) |
+	    ((num_elements << 8) & 0x00ffff00);
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_IHCU, vnic_id, (VREG_IHCU_RXD_W2_R0 +
+							(rxdq_id << 4)));
+	value =3D rx_bufsize;
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	return ret;
+}
+
+u32 vioc_rrd(int viocdev_idx, int module_id, int vnic_id, int reg_addr=
)
+{
+	u32 value;
+	u64 regaddr;
+	struct vioc_device *viocdev;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+
+	regaddr =3D GETRELADDR(module_id, vnic_id, reg_addr);
+	vioc_reg_rd(viocdev->ba.virt, regaddr, &value);
+
+	return value;
+}
+
+int vioc_rwr(int viocdev_idx, int module_id, int vnic_id, int reg_addr=
,
+	     u32 value)
+{
+	int ret =3D 0;
+	struct vioc_device *viocdev;
+	u64 regaddr;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+
+	regaddr =3D GETRELADDR(module_id, vnic_id, reg_addr);
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	return ret;
+}
+
+int vioc_ena_dis_tx_on_empty(int viocdev_idx, u32 vnic_id, u32 txq_id,
+			     int ena_dis)
+{
+	u32 value =3D 0;
+	u64 regaddr;
+	struct vioc_device *viocdev =3D vioc_viocdev(viocdev_idx);
+
+	if (ena_dis)
+		value |=3D VREG_VENG_TXINTCTL_INTONEMPTY_MASK;
+	else
+		value &=3D ~VREG_VENG_TXINTCTL_INTONEMPTY_MASK;
+
+	regaddr =3D GETRELADDR(VIOC_VENG, vnic_id, VREG_VENG_TXINTCTL);
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	return 0;
+}
+
+int vioc_set_vnic_cfg(int viocdev_idx, u32 vnic_id, u32 cfg)
+{
+	int ret =3D 0;
+	u64 regaddr;
+	struct vioc_device *viocdev;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+	regaddr =3D GETRELADDR(VIOC_BMC, vnic_id, VREG_BMC_VNIC_CFG);
+
+	vioc_reg_wr(cfg, viocdev->ba.virt, regaddr);
+
+	return ret;
+}
+
+int vioc_ena_dis_rxd_q(int viocdev_idx, u32 q_id, int ena_dis)
+{
+	int ret =3D 0;
+	u32 value;
+	u64 regaddr;
+	struct vioc_device *viocdev;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+	regaddr =3D GETRELADDR(VIOC_IHCU, 0, VREG_IHCU_RXDQEN);
+	vioc_reg_rd(viocdev->ba.virt, regaddr, &value);
+
+	if (ena_dis)
+		value |=3D 1 << q_id;
+	else
+		value &=3D ~(1 << q_id);
+
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	return ret;
+}
+
+void vioc_sw_reset(int viocdev_idx)
+{
+	u32 value;
+	u64 regaddr;
+	struct vioc_device *viocdev;
+
+	viocdev =3D vioc_viocdev(viocdev_idx);
+
+	regaddr =3D GETRELADDR(VIOC_BMC, 0, VREG_BMC_GLOBAL);
+	vioc_reg_rd(viocdev->ba.virt, regaddr, &value);
+	value |=3D VREG_BMC_GLOBAL_SOFTRESET_MASK;
+	vioc_reg_wr(value, viocdev->ba.virt, regaddr);
+
+	do {
+		vioc_reg_rd(viocdev->ba.virt, regaddr, &value);
+		mdelay(1);
+	} while (value & VREG_BMC_GLOBAL_SOFTRESET_MASK);
+
+	/*
+	 * Clear BMC INTERRUPT register
+	 */
+	regaddr =3D GETRELADDR(VIOC_BMC, 0, VREG_BMC_INTRSTATUS);
+	vioc_reg_wr(0xffff, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_VING, 0, VREG_VING_BUFTH1);
+	vioc_reg_wr(128, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_VING, 0, VREG_VING_BUFTH2);
+	vioc_reg_wr(150, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_VING, 0, VREG_VING_BUFTH3);
+	vioc_reg_wr(200, viocdev->ba.virt, regaddr);
+
+	regaddr =3D GETRELADDR(VIOC_VING, 0, VREG_VING_BUFTH4);
+	vioc_reg_wr(256, viocdev->ba.virt, regaddr);
+
+	/*
+	 * Initialize Context Scrub Control Register
+	 */
+	regaddr =3D GETRELADDR(VIOC_VING, 0, VREG_VING_CONTEXTSCRUB);
+	/* Enable Context Scrub, Timeout ~ 5 sec */
+	vioc_reg_wr(0x8000000f, viocdev->ba.virt, regaddr);
+	/*
+	 * Initialize Sleep Time Register
+	 */
+	regaddr =3D GETRELADDR(VIOC_IHCU, 0, VREG_IHCU_SLEEPTIME);
+	/* at 50ns ticks, 20 =3D 20x50 =3D 1usec */
+       vioc_reg_wr(20, viocdev->ba.virt, regaddr);
+	/*
+	 * VIOC bits version
+	 */
+	regaddr =3D GETRELADDR(VIOC_HT, 0, VREG_HT_CLASSREV);
+	vioc_reg_rd(viocdev->ba.virt, regaddr, &viocdev->vioc_bits_version);
+	/*
+	 * VIOC bits sub-version
+	 */
+	regaddr =3D GETRELADDR(VIOC_HT, 0, VREG_HT_EXPREV);
+	vioc_reg_rd(viocdev->ba.virt, regaddr, &viocdev->vioc_bits_subversion=
);
+
+}
+
+int vioc_vnic_resources_set(int viocdev_idx, u32 vnic_id)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(viocdev_idx);
+	struct vnic_device *vnicdev =3D viocdev->vnic_netdev[vnic_id]->priv;
+	u64 regaddr;
+
+	/* Map VNIC-2-RXD */
+	regaddr =3D GETRELADDR(VIOC_IHCU, vnic_id, VREG_IHCU_VNICRXDMAP);
+	vioc_reg_wr(vnicdev->qmap, viocdev->ba.virt, regaddr);
+
+	/* Map VNIC-2-RXC */
+	regaddr =3D GETRELADDR(VIOC_IHCU, vnic_id, VREG_IHCU_VNICRXCMAP);
+	vioc_reg_wr(vnicdev->rxc_id, viocdev->ba.virt, regaddr);
+
+	/* Map Interrupt-2-RXC */
+	regaddr =3D  GETRELADDR(VIOC_IHCU, vnic_id, (VREG_IHCU_RXC_INT +
+					       (vnicdev->rxc_id << 4)));
+	vioc_reg_wr(vnicdev->rxc_intr_id, viocdev->ba.virt, regaddr);
+
+	return 0;
+}
diff -puN /dev/null drivers/net/vioc/vioc_api.h
--- /dev/null
+++ a/drivers/net/vioc/vioc_api.h
@@ -0,0 +1,64 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#ifndef _VIOC_API_H_
+#define _VIOC_API_H_
+
+#include <asm/io.h>
+#include "vioc_vnic.h"
+
+extern int vioc_vnic_resources_set(int vioc_id, u32 vnic_id);
+extern void vioc_sw_reset(int vioc_id);
+extern u32 vioc_rrd(int vioc_id, int module_id, int vnic_id, int reg_a=
ddr);
+extern int vioc_rwr(int vioc_id, int module_id, int vnic_id, int reg_a=
ddr, u32 value);
+extern int vioc_set_vnic_mac(int vioc_id, u32 vnic_id, u8 * p);
+extern int vioc_get_vnic_mac(int vioc_id, u32 vnic_id, u8 * p);
+extern int vioc_set_txq(int vioc_id, u32 vnic_id, u32 txq_id, dma_addr=
_t base,
+                u32 num_elements);
+
+extern int vioc_set_rxc(int viocdev_idx, struct rxc *rxc);
+
+
+extern int vioc_set_rxdq(int vioc_id, u32 vnic_id, u32 rxq_id, u32 rx_=
bufsize,
+                 dma_addr_t base, u32 num_elements);
+extern int vioc_set_rxs(int vioc_id, dma_addr_t base);
+extern int vioc_set_vnic_cfg(int viocdev_idx, u32 vnic_id, u32 vnic_q_=
map);
+extern int vioc_ena_dis_rxd_q(int vioc_id, u32 q_id, int ena_dis);
+extern int vioc_ena_dis_tx_on_empty(int viocdev_idx, u32 vnic_id, u32 =
txq_id,
+                            int ena_dis);
+static inline void
+vioc_reg_wr(u32 value, void __iomem *vaddr, u32 offset)
+{
+       writel(value, vaddr + offset);
+}
+
+static inline void
+vioc_reg_rd(void __iomem *vaddr, u32 offset, u32 * value_p)
+{
+       *value_p =3D readl(vaddr + offset);
+}
+
+#endif                         /* _VIOC_API_H_ */
diff -puN /dev/null drivers/net/vioc/vioc_driver.c
--- /dev/null
+++ a/drivers/net/vioc/vioc_driver.c
@@ -0,0 +1,872 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include <linux/autoconf.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/netdevice.h>
+#include <linux/sysdev.h>
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+#include <linux/ethtool.h>
+#include <linux/mii.h>
+#include <linux/if_vlan.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/notifier.h>
+#include <linux/errno.h>
+
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/byteorder.h>
+#include <asm/uaccess.h>
+
+#include "f7/vioc_hw_registers.h"
+#include "f7/vnic_defs.h"
+
+#include <linux/moduleparam.h>
+#include "vioc_vnic.h"
+#include "vioc_api.h"
+
+#include "driver_version.h"
+
+
+MODULE_AUTHOR("support@fabric7.com");
+MODULE_DESCRIPTION("VIOC interface driver");
+MODULE_LICENSE("GPL");
+
+MODULE_VERSION(VIOC_DISPLAY_VERSION);
+
+/*
+ * Standard parameters for ring provisioning.  Single TxQ per VNIC.
+ * Two RX sets per VIOC, with 3 RxDs, 1 RxC, 1 Rx interrupt per set.
+ */
+
+#define TXQ_SIZE			1024
+#define TX_INTR_ON_EMPTY	0
+
+#define VNIC_RXQ_MAP		0xf	/* Bits 0-3 for 4 VNIC queues */
+#define RXDQ_PERSET_COUNT	3
+#define RXDQ_COUNT			(RXSET_COUNT * RXDQ_PERSET_COUNT)
+/* RXDQ sizes (entry counts) must be multiples of this */
+#define RXDQ_ALIGN			VIOC_RXD_BATCH_BITS
+#define RXDQ_SIZE			2048
+#define RXDQ_JUMBO_SIZE		ALIGN(RXDQ_SIZE, RXDQ_ALIGN)
+#define RXDQ_STD_SIZE		ALIGN(RXDQ_SIZE, RXDQ_ALIGN)
+#define RXDQ_SMALL_SIZE		ALIGN(RXDQ_SIZE, RXDQ_ALIGN)
+#define RXDQ_EXTRA_SIZE		ALIGN(RXDQ_SIZE, RXDQ_ALIGN)
+
+#define RXC_COUNT			RXSET_COUNT
+#define RXC_SIZE			(RXDQ_JUMBO_SIZE+RXDQ_STD_SIZE+RXDQ_SMALL_SIZE+RXDQ=
_EXTRA_SIZE)
+
+/* VIOC devices */
+static struct pci_device_id vioc_pci_tbl[] __devinitdata =3D {
+	{PCI_DEVICE(PCI_VENDOR_ID_FABRIC7, PCI_DEVICE_ID_VIOC_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_FABRIC7, PCI_DEVICE_ID_VIOC_8)},
+	{0,},
+};
+
+MODULE_DEVICE_TABLE(pci, vioc_pci_tbl);
+
+static spinlock_t vioc_idx_lock =3D SPIN_LOCK_UNLOCKED;
+static unsigned vioc_idx =3D 0;
+static struct vioc_device *vioc_devices[VIOC_MAX_VIOCS];
+
+static struct vioc_device *viocdev_new(int viocdev_idx, struct pci_dev=
 *pdev)
+{
+	int k;
+	struct vioc_device *viocdev;
+
+	if (viocdev_idx >=3D VIOC_MAX_VIOCS)
+		return NULL;
+
+	viocdev =3D kmalloc(sizeof(struct vioc_device), GFP_KERNEL);
+	if (!viocdev)
+		return viocdev;
+
+	memset(viocdev, 0, sizeof(struct vioc_device));
+
+	viocdev->pdev =3D pdev;
+	viocdev->vioc_state =3D VIOC_STATE_INIT;
+	viocdev->viocdev_idx =3D viocdev_idx;
+
+	viocdev->prov.run_param.tx_pkts_per_bell =3D TX_PKTS_PER_BELL;
+	viocdev->prov.run_param.tx_pkts_per_irq =3D TX_PKTS_PER_IRQ;
+	viocdev->prov.run_param.tx_intr_on_empty =3D TX_INTR_ON_EMPTY;
+	viocdev->prov.run_param.rx_intr_timeout =3D RX_INTR_TIMEOUT;
+	viocdev->prov.run_param.rx_intr_cntout =3D RX_INTR_PKT_CNT;
+	viocdev->prov.run_param.rx_wdog_timeout =3D HZ / 4;
+
+	for (k =3D 0; k < VIOC_MAX_VNICS; k++) {
+		viocdev->vnic_netdev[k] =3D NULL;	/* spp */
+	}
+
+	vioc_devices[viocdev_idx] =3D viocdev;
+
+	return viocdev;
+}
+
+/*
+ * Remove all Rx descriptors from the queue.
+ */
+static void vioc_clear_rxq(struct vioc_device *viocdev, struct rxdq *r=
xdq)
+{
+	int j;
+
+	/* Disable this queue */
+	vioc_ena_dis_rxd_q(viocdev->viocdev_idx, rxdq->rxdq_id, 0);
+
+	if (rxdq->vbuf =3D=3D NULL)
+		return;
+
+	for (j =3D 0; j < rxdq->count; j++) {
+		struct rx_pktBufDesc_Phys_w *rxd;
+		if (rxdq->vbuf[j].skb) {
+			pci_unmap_single(rxdq->viocdev->pdev,
+					 rxdq->vbuf[j].dma,
+					 rxdq->rx_buf_size, PCI_DMA_FROMDEVICE);
+			dev_kfree_skb_any((struct sk_buff *)rxdq->vbuf[j].skb);
+			rxdq->vbuf[j].skb =3D NULL;
+			rxdq->vbuf[j].dma =3D (dma_addr_t) NULL;
+		}
+		rxd =3D RXD_PTR(rxdq, j);
+		wmb();
+		CLR_VNIC_RX_OWNED(rxd);
+	}
+}
+
+/*
+ * Refill an empty Rx queue with Rx with Rx buffers
+ */
+static int vioc_refill_rxq(struct vioc_device *viocdev, struct rxdq *r=
xdq)
+{
+	int ret =3D 0;
+
+	memset(rxdq->vbuf, 0, rxdq->count * sizeof(struct vbuf));
+	memset(rxdq->dmap, 0, rxdq->dmap_count * (VIOC_RXD_BATCH_BITS / 8));
+
+	rxdq->fence =3D 0;
+	rxdq->to_hw =3D VIOC_NONE_TO_HW;
+	rxdq->starvations =3D 0;
+	rxdq->run_to_end =3D 0;
+	rxdq->skip_fence_run =3D rxdq->dmap_count / 4;
+
+	ret =3D vioc_next_fence_run(rxdq);
+	BUG_ON(ret !=3D 0);
+	return ret;
+}
+
+struct vioc_device *vioc_viocdev(u32 viocdev_idx)
+{
+	if (viocdev_idx >=3D vioc_idx) {
+		BUG_ON(viocdev_idx >=3D vioc_idx);
+		return NULL;
+	}
+
+	BUG_ON(vioc_devices[viocdev_idx] =3D=3D NULL);
+	return vioc_devices[viocdev_idx];
+}
+
+static void vioc_bmc_wdog(unsigned long data)
+{
+
+	struct vioc_device *viocdev =3D (struct vioc_device *)data;
+
+	if (!viocdev->bmc_wd_timer_active)
+		return;
+
+	/*
+	 * Send Heartbeat message to BMC
+	 */
+	vioc_hb_to_bmc(viocdev->viocdev_idx);
+
+	/*
+	 * Reset the timer
+	 */
+	mod_timer(&viocdev->bmc_wd_timer, jiffies + HZ);
+
+	return;
+}
+
+static int extract_vnic_prov(struct vioc_device *viocdev,
+									struct vnic_device *vnicdev)
+{
+	struct vnic_prov_def *vr;
+	int j;
+
+	vr =3D viocdev->prov.vnic_prov_p[vnicdev->vnic_id];
+	if (vr =3D=3D NULL) {
+		dev_err(&viocdev->pdev->dev, "vioc %d: vnic %d No provisioning set\n=
",
+		       viocdev->viocdev_idx, vnicdev->vnic_id);
+		return E_VIOCPARMERR;
+	}
+
+	if (vr->tx_entries =3D=3D 0) {
+		dev_err(&viocdev->pdev->dev, "vioc %d: vnic %d Tx ring not provision=
ed\n",
+		       viocdev->viocdev_idx, vnicdev->vnic_id);
+		return E_VIOCPARMERR;
+	}
+
+	if (viocdev->rxc_p[vr->rxc_id] =3D=3D NULL) {
+		dev_err(&viocdev->pdev->dev,
+		       "vioc %d: vnic %d RxC ring %d  not provisioned\n",
+		       viocdev->viocdev_idx, vnicdev->vnic_id, vr->rxc_id);
+		return E_VIOCPARMERR;
+	}
+
+	if (vr->rxc_intr_id >=3D viocdev->num_rx_irqs) {
+		dev_err(&viocdev->pdev->dev, "vioc %d: vnic %d IRQ %d INVALID (max %=
d)\n",
+		       viocdev->viocdev_idx, vnicdev->vnic_id,
+		       vr->rxc_intr_id, (viocdev->num_rx_irqs - 1));
+		return E_VIOCPARMERR;
+	}
+
+	vnicdev->txq.count =3D vr->tx_entries;
+	vnicdev->rxc_id =3D vr->rxc_id;
+	vnicdev->rxc_intr_id =3D vr->rxc_intr_id;
+
+	for (j =3D 0; j < 4; j++) {
+		struct rxd_q_prov *ring =3D &vr->rxd_ring[j];
+
+		if (ring->state =3D=3D 0)
+			continue;
+
+		if (viocdev->rxd_p[ring->id] =3D=3D NULL) {
+			dev_err(&viocdev->pdev->dev,
+			       "vioc %d: vnic %d RxD ring %d  not provisioned\n",
+			       viocdev->viocdev_idx, vnicdev->vnic_id,
+			       ring->id);
+			return E_VIOCPARMERR;
+		}
+
+		/* Set Rx queue ENABLE bit for BMC_VNIC_CFG register */
+		vnicdev->vnic_q_en |=3D (1 << j);
+
+	}
+	vnicdev->qmap =3D
+	    ((vr->rxd_ring[0].id & 0xf) << (0 + 8 * 0)) |
+	    ((vr->rxd_ring[0].state & 0x1) << (7 + 8 * 0)) |
+	    ((vr->rxd_ring[1].id & 0xf) << (0 + 8 * 1)) |
+	    ((vr->rxd_ring[1].state & 0x1) << (7 + 8 * 1)) |
+	    ((vr->rxd_ring[2].id & 0xf) << (0 + 8 * 2)) |
+	    ((vr->rxd_ring[2].state & 0x1) << (7 + 8 * 2)) |
+	    ((vr->rxd_ring[3].id & 0xf) << (0 + 8 * 3)) |
+	    ((vr->rxd_ring[3].state & 0x1) << (7 + 8 * 3));
+	return E_VIOCOK;
+}
+
+struct net_device *vioc_alloc_vnicdev(struct vioc_device *viocdev, int=
 vnic_id)
+{
+	struct net_device *netdev;
+	struct vnic_device *vnicdev;
+
+	netdev =3D alloc_etherdev(sizeof(struct vnic_device));
+	if (!netdev) {
+		return NULL;
+	}
+
+	viocdev->vnic_netdev[vnic_id] =3D netdev;
+	vnicdev =3D netdev_priv(netdev);
+	vnicdev->viocdev =3D viocdev;
+	vnicdev->netdev =3D netdev;
+	vnicdev->vnic_id =3D vnic_id;
+	sprintf(&netdev->name[0], "ve%d.%02d", viocdev->viocdev_idx, vnic_id)=
;
+	netdev->init =3D &vioc_vnic_init;	/* called when it is registered */
+	vnicdev->txq.vnic_id =3D vnic_id;
+
+	if (extract_vnic_prov(viocdev, vnicdev) !=3D E_VIOCOK) {
+		free_netdev(netdev);
+		return NULL;
+	}
+
+	return netdev;
+}
+
+static void vioc_free_resources(struct vioc_device *viocdev, u32 vioci=
dx)
+{
+	int i;
+	struct napi_poll *napi_p;
+	int start_j =3D jiffies;
+	int delta_j =3D 0;
+
+	for (i =3D 0; i < VIOC_MAX_RXCQ; i++) {
+		struct rxc *rxc =3D viocdev->rxc_p[i];
+		if (rxc =3D=3D NULL)
+			continue;
+
+		napi_p =3D &rxc->napi;
+		/* Tell NAPI poll to stop */
+		napi_p->enabled =3D 0;
+
+		/* Make sure that NAPI poll gets the message */
+		netif_rx_schedule(&napi_p->poll_dev);
+
+		/* Wait for an ack from NAPI that it stopped,
+		 * so we can release resources
+		 */
+		while (!napi_p->stopped) {
+			schedule();
+			delta_j =3D jiffies - start_j;
+			if (delta_j > 10 * HZ) {
+				/* Looks like NAPI didn;t get to run.
+				 * Bail out hoping, we are not stuck
+				 * in NAPI poll.
+				 */
+				break;
+			}
+		}
+		if (rxc->dma) {
+			pci_free_consistent(viocdev->pdev,
+					    rxc->count * RXC_DESC_SIZE,
+					    rxc->desc, rxc->dma);
+			rxc->desc =3D NULL;
+			rxc->dma =3D (dma_addr_t) NULL;
+		}
+	}
+
+	for (i =3D 0; i < VIOC_MAX_RXDQ; i++) {
+		struct rxdq *rxdq =3D viocdev->rxd_p[i];
+		if (rxdq =3D=3D NULL)
+			continue;
+
+		vioc_ena_dis_rxd_q(viocidx, rxdq->rxdq_id, 0);
+		if (rxdq->vbuf) {
+			vioc_clear_rxq(viocdev, rxdq);
+			vfree(rxdq->vbuf);
+			rxdq->vbuf =3D NULL;
+		}
+		if (rxdq->dmap) {
+			vfree(rxdq->dmap);
+			rxdq->dmap =3D NULL;
+		}
+		if (rxdq->dma) {
+			pci_free_consistent(viocdev->pdev,
+					    rxdq->count * RX_DESC_SIZE,
+					    rxdq->desc, rxdq->dma);
+			rxdq->desc =3D NULL;
+			rxdq->dma =3D (dma_addr_t) NULL;
+		}
+		viocdev->rxd_p[rxdq->rxdq_id] =3D NULL;
+	}
+
+	/* Free RxC status block */
+	if (viocdev->rxcstat.dma) {
+		pci_free_consistent(viocdev->pdev, RXS_DESC_SIZE,
+				    viocdev->rxcstat.block,
+				    viocdev->rxcstat.dma);
+		viocdev->rxcstat.block =3D NULL;
+		viocdev->rxcstat.dma =3D (dma_addr_t) NULL;
+	}
+
+}
+
+/*
+ * Initialize rxsets - RxS, RxCs and RxDs and push to VIOC.
+ * Return negative errno on failure.
+ */
+static int vioc_alloc_resources(struct vioc_device *viocdev, u32 vioci=
dx)
+{
+	int j, i;
+	int ret;
+	struct vnic_prov_def *vr;
+	struct napi_poll *napi_p;
+	struct rxc *rxc;
+
+	dev_err(&viocdev->pdev->dev, "vioc%d: ENTER %s\n", viocidx, __FUNCTIO=
N__);
+
+	/* Allocate Rx Completion Status block */
+	viocdev->rxcstat.block =3D (struct rxc_pktStatusBlock_w *)
+	    pci_alloc_consistent(viocdev->pdev,
+				 RXS_DESC_SIZE * VIOC_MAX_RXCQ,
+				 &viocdev->rxcstat.dma);
+	if (!viocdev->rxcstat.block) {
+		dev_err(&viocdev->pdev->dev, "vioc%d: Could not allocate RxS\n", vio=
cidx);
+		ret =3D -ENOMEM;
+		goto error;
+	}
+	/* Tell VIOC about this RxC Status block */
+	ret =3D vioc_set_rxs(viocidx, viocdev->rxcstat.dma);
+	if (ret) {
+		dev_err(&viocdev->pdev->dev, "vioc%d: Could not set RxS\n", viocidx)=
;
+		goto error;
+	}
+
+	/* Based on provisioning request, setup RxCs and RxDs */
+	for (i =3D 0; i < VIOC_MAX_VNICS; i++) {
+		vr =3D viocdev->prov.vnic_prov_p[i];
+		if (vr =3D=3D NULL) {
+			dev_err(&viocdev->pdev->dev,
+			       "vioc %d: vnic %d No provisioning set\n",
+			       viocdev->viocdev_idx, i);
+			goto error;
+		}
+
+		if (vr->rxc_id >=3D VIOC_MAX_RXCQ) {
+			dev_err(&viocdev->pdev->dev, "vioc%d: INVALID RxC %d provisioned\n"=
,
+			       viocidx, vr->rxc_id);
+			goto error;
+		}
+		rxc =3D viocdev->rxc_p[vr->rxc_id];
+		if (rxc =3D=3D NULL) {
+			rxc =3D &viocdev->rxc_buf[vr->rxc_id];
+			viocdev->rxc_p[vr->rxc_id] =3D rxc;
+			rxc->rxc_id =3D vr->rxc_id;
+			rxc->viocdev =3D viocdev;
+			rxc->quota =3D POLL_WEIGHT;
+			rxc->budget =3D POLL_WEIGHT;
+			rxc->count =3D vr->rxc_entries;
+
+			/* Allocate RxC ring memory */
+			rxc->desc =3D (struct rxc_pktDesc_Phys_w *)
+			    pci_alloc_consistent(viocdev->pdev,
+						 rxc->count * RXC_DESC_SIZE,
+						 &rxc->dma);
+			if (!rxc->desc) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: Can't allocate RxC ring %d for %d entries\n",
+				       viocidx, rxc->rxc_id, rxc->count);
+				ret =3D -ENOMEM;
+				goto error;
+			}
+			rxc->interrupt_id =3D vr->rxc_intr_id;
+
+			rxc->va_of_vreg_ihcu_rxcinttimer =3D
+			    (&viocdev->ba)->virt + GETRELADDR(VIOC_IHCU, 0,
+							      (VREG_IHCU_RXCINTTIMER
+							       +
+							       (rxc->
+								interrupt_id <<
+								2)));
+
+			rxc->va_of_vreg_ihcu_rxcintpktcnt =3D
+			    (&viocdev->ba)->virt + GETRELADDR(VIOC_IHCU, 0,
+							      (VREG_IHCU_RXCINTPKTCNT
+							       +
+							       (rxc->
+								interrupt_id <<
+								2)));
+			rxc->va_of_vreg_ihcu_rxcintctl =3D
+			    (&viocdev->ba)->virt + GETRELADDR(VIOC_IHCU, 0,
+							      (VREG_IHCU_RXCINTCTL
+							       +
+							       (rxc->
+								interrupt_id <<
+								2)));
+			/* Set parameter (rxc->rxc_id), that will be passed to interrupt co=
de */
+			ret =3D vioc_set_intr_func_param(viocdev->viocdev_idx,
+						       rxc->interrupt_id,
+						       rxc->rxc_id);
+			if (ret) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: Could not set PARAM for INTR ID %d\n",
+				       viocidx, rxc->interrupt_id);
+				goto error;
+			}
+
+			/* Register RxC ring and interrupt */
+			ret =3D vioc_set_rxc(viocidx, rxc);
+			if (ret) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: Could not set RxC %d\n",
+				       viocidx, vr->rxc_id);
+				goto error;
+			}
+
+			/* Initialize NAPI poll structure and device */
+			napi_p =3D &rxc->napi;
+			napi_p->enabled =3D 1;	/* ready for Rx poll */
+			napi_p->stopped =3D 0;	/* NOT stopped */
+			napi_p->rxc =3D rxc;
+			napi_p->poll_dev.weight =3D POLL_WEIGHT;
+			napi_p->poll_dev.priv =3D &rxc->napi;	/* Note */
+			napi_p->poll_dev.poll =3D &vioc_rx_poll;
+
+			dev_hold(&napi_p->poll_dev);
+			/* Enable the poll device */
+			set_bit(__LINK_STATE_START, &napi_p->poll_dev.state);
+			netif_start_queue(&napi_p->poll_dev);
+		};
+
+		/* Allocate Rx rings */
+		for (j =3D 0; j < 4; j++) {
+			struct rxd_q_prov *ring =3D &vr->rxd_ring[j];
+			struct rxdq *rxdq;
+
+			if (ring->id >=3D VIOC_MAX_RXDQ) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: BAD Provisioning request for RXD %d\n",
+				       viocidx, ring->id);
+				goto error;
+			}
+
+			rxdq =3D viocdev->rxd_p[ring->id];
+			if (rxdq !=3D NULL)
+				continue;
+
+			if (ring->state =3D=3D 0)
+				continue;
+
+			rxdq =3D &viocdev->rxd_buf[ring->id];
+			viocdev->rxd_p[ring->id] =3D rxdq;
+
+			rxdq->rxdq_id =3D ring->id;
+			rxdq->viocdev =3D viocdev;
+			rxdq->count =3D ring->entries;
+			rxdq->rx_buf_size =3D ring->buf_size;
+
+			/* skb array */
+			rxdq->vbuf =3D vmalloc(rxdq->count * sizeof(struct vbuf));
+			if (!rxdq->vbuf) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: Can't allocate RxD vbuf (%d entries)\n",
+				       viocidx, rxdq->count);
+				ret =3D -ENOMEM;
+				goto error;
+			}
+
+			/* Ring memory */
+			rxdq->desc =3D (struct rx_pktBufDesc_Phys_w *)
+			    pci_alloc_consistent(viocdev->pdev,
+						 rxdq->count * RX_DESC_SIZE,
+						 &rxdq->dma);
+			if (!rxdq->desc) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: Can't allocate RxD ring (%d entries)\n",
+				       viocidx, rxdq->count);
+				ret =3D -ENOMEM;
+				goto error;
+			}
+			rxdq->dmap_count =3D rxdq->count / VIOC_RXD_BATCH_BITS;
+			/* Descriptor ownership bit map */
+			rxdq->dmap =3D (u32 *)
+			    vmalloc(rxdq->dmap_count *
+				    (VIOC_RXD_BATCH_BITS / 8));
+			if (!rxdq->dmap) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: Could not allocate dmap\n",
+				       viocidx);
+				ret =3D -ENOMEM;
+				goto error;
+			}
+			/* Refill ring */
+			ret =3D vioc_refill_rxq(viocdev, rxdq);
+			if (ret) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: Could not fill rxdq%d\n",
+				       viocidx, rxdq->rxdq_id);
+				goto error;
+			}
+			/* Tell VIOC about this queue */
+			ret =3D vioc_set_rxdq(viocidx, VIOC_ANY_VNIC,
+					    rxdq->rxdq_id, rxdq->rx_buf_size,
+					    rxdq->dma, rxdq->count);
+			if (ret) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: Could not set rxdq%d\n",
+				       viocidx, rxdq->rxdq_id);
+				goto error;
+			}
+			/* Enable this queue */
+			ret =3D vioc_ena_dis_rxd_q(viocidx, rxdq->rxdq_id, 1);
+			if (ret) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: Could not enable rxdq%d\n",
+				       viocidx, rxdq->rxdq_id);
+				goto error;
+			}
+		}		/* for 4 rings */
+	}
+
+	return 0;
+
+      error:
+	/* Caller is responsible for calling vioc_free_rxsets() */
+	return ret;
+}
+
+static void vioc_remove(struct pci_dev *pdev)
+{
+	struct vioc_device *viocdev =3D pci_get_drvdata(pdev);
+
+	if (!viocdev)
+		return;
+
+	/* Disable interrupts */
+	vioc_free_irqs(viocdev->viocdev_idx);
+
+	viocdev->vioc_state =3D VIOC_STATE_INIT;
+
+	if (viocdev->bmc_wd_timer.function) {
+		viocdev->bmc_wd_timer_active =3D 0;
+		del_timer_sync(&viocdev->bmc_wd_timer);
+	}
+
+	if (viocdev->tx_timer.function) {
+		viocdev->tx_timer_active =3D 0;
+		del_timer_sync(&viocdev->tx_timer);
+	}
+
+	vioc_vnic_prov(viocdev->viocdev_idx, 0, 0, 1);
+
+	vioc_free_resources(viocdev, viocdev->viocdev_idx);
+
+	/* Reset VIOC chip */
+	vioc_sw_reset(viocdev->viocdev_idx);
+
+#if defined(CONFIG_MSIX_MOD)
+	if (viocdev->num_irqs > 4) {
+		pci_disable_msix(viocdev->pdev);
+	} else {
+		pci_release_regions(viocdev->pdev);
+	}
+#else
+	pci_release_regions(viocdev->pdev);
+#endif
+
+	iounmap(viocdev->ba.virt);
+
+	if (viocdev->viocdev_idx < VIOC_MAX_VIOCS)
+		vioc_devices[viocdev->viocdev_idx] =3D NULL;
+
+	kfree(viocdev);
+	pci_set_drvdata(pdev, NULL);
+
+	pci_disable_device(pdev);
+}
+
+/*
+ * vioc_probe - Device Initialization Routine
+ * @pdev: PCI device information struct (VIOC PCI device)
+ * @ent: entry in vioc_pci_tbl
+ *
+ * Returns 0 on success, negative on failure
+ *
+ */
+static int __devinit vioc_probe(struct pci_dev *pdev, const
+				struct pci_device_id *ent)
+{
+	int cur_vioc_idx;
+	struct vioc_device *viocdev;
+	unsigned long long mmio_start =3D 0, mmio_len;
+	u32 param1, param2;
+	int ret;
+
+	viocdev =3D pci_get_drvdata(pdev);
+	if (viocdev) {
+		cur_vioc_idx =3D viocdev->viocdev_idx;
+		BUG_ON(viocdev !=3D NULL);	/* should not happen */
+	} else {
+		spin_lock(&vioc_idx_lock);
+		cur_vioc_idx =3D vioc_idx++;
+		spin_unlock(&vioc_idx_lock);
+		if (cur_vioc_idx < VIOC_MAX_VIOCS) {
+			viocdev =3D viocdev_new(cur_vioc_idx, pdev);
+			BUG_ON(viocdev =3D=3D NULL);
+			pci_set_drvdata(pdev, viocdev);
+		} else {
+			dev_err(&pdev->dev,
+			       "vioc_id %d > maximum supported, aborting.\n",
+			       cur_vioc_idx);
+			return -ENODEV;
+		}
+	}
+
+	sprintf(viocdev->name, "vioc%d", cur_vioc_idx);
+
+	if ((ret =3D pci_enable_device(pdev))) {
+		dev_err(&pdev->dev, "vioc%d: Cannot enable PCI device\n",
+		       cur_vioc_idx);
+		goto vioc_probe_err;
+	}
+
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
+		dev_err(&pdev->dev, "vioc%d: Cannot find PCI device base address\n",
+		       cur_vioc_idx);
+		ret =3D -ENODEV;
+		goto vioc_probe_err;
+	}
+
+	/* Initialize interrupts: get number if Rx IRQs, 2 or 16 are valid re=
turns */
+	viocdev->num_rx_irqs =3D vioc_request_irqs(cur_vioc_idx);
+
+	if (viocdev->num_rx_irqs =3D=3D 0) {
+		dev_err(&pdev->dev, "vioc%d: Request IRQ failed\n", cur_vioc_idx);
+		goto vioc_probe_err;
+	}
+
+	pci_set_master(pdev);
+
+	/* Configure DMA attributes. */
+	if ((ret =3D pci_set_dma_mask(pdev, DMA_64BIT_MASK))) {
+		if ((ret =3D pci_set_dma_mask(pdev, DMA_32BIT_MASK))) {
+			dev_err(&pdev->dev, "vioc%d: No usable DMA configuration\n",
+			       cur_vioc_idx);
+			goto vioc_probe_err;
+		}
+	} else {
+		viocdev->highdma =3D 1;
+	}
+
+	mmio_start =3D pci_resource_start(pdev, 0);
+	mmio_len =3D pci_resource_len(pdev, 0);
+
+	viocdev->ba.virt =3D ioremap(mmio_start, mmio_len);
+	viocdev->ba.phy =3D mmio_start;
+	viocdev->ba.len =3D mmio_len;
+
+	/* Soft reset the chip; pick up versions */
+	vioc_sw_reset(cur_vioc_idx);
+
+	viocdev->vioc_bits_version &=3D 0xff;
+
+	if (viocdev->vioc_bits_version < 0x74) {
+		dev_err(&pdev->dev, "VIOC version %x not supported, aborting\n",
+		       viocdev->vioc_bits_version);
+		ret =3D -EINVAL;
+		goto vioc_probe_err;
+	}
+
+	dev_info(&pdev->dev, "vioc%d: Detected VIOC version %x.%x\n",
+	       cur_vioc_idx,
+	       viocdev->vioc_bits_version, viocdev->vioc_bits_subversion);
+
+	viocdev->prov.vnic_prov_p =3D vioc_prov_get(viocdev->num_rx_irqs);
+
+	/* Allocate and provision resources */
+	if ((ret =3D vioc_alloc_resources(viocdev, cur_vioc_idx))) {
+		dev_err(&pdev->dev, "vioc%d: Could not allocate resources\n",
+		       cur_vioc_idx);
+		goto vioc_probe_err;
+	}
+
+	/*
+	 * Initialize heartbeat (watchdog) timer:
+	 */
+	if (viocdev->viocdev_idx =3D=3D 0) {
+		/* Heartbeat is delivered ONLY by "master" VIOC in a
+		 * partition */
+		init_timer(&viocdev->bmc_wd_timer);
+		viocdev->bmc_wd_timer.function =3D &vioc_bmc_wdog;
+		viocdev->bmc_wd_timer.expires =3D jiffies + HZ;
+		viocdev->bmc_wd_timer.data =3D (unsigned long)viocdev;
+		add_timer(&viocdev->bmc_wd_timer);
+		viocdev->bmc_wd_timer_active =3D 1;
+	}
+
+	/* Disable all watchdogs by default */
+	viocdev->bmc_wd_timer_active =3D 0;
+
+	/*
+	 * Initialize tx_timer (tx watchdog) timer:
+	 */
+	init_timer(&viocdev->tx_timer);
+	viocdev->tx_timer.function =3D &vioc_tx_timer;
+	viocdev->tx_timer.expires =3D jiffies + HZ / 4;
+	viocdev->tx_timer.data =3D (unsigned long)viocdev;
+	add_timer(&viocdev->tx_timer);
+	/* !!! TESTING ONLY !!! */
+	viocdev->tx_timer_active =3D 1;
+
+	viocdev->vnics_map =3D 0;
+
+	param1 =3D vioc_rrd(viocdev->viocdev_idx, VIOC_BMC, 0, VREG_BMC_VNIC_=
EN);
+	param2 =3D vioc_rrd(viocdev->viocdev_idx, VIOC_BMC, 0, VREG_BMC_PORT_=
EN);
+	vioc_vnic_prov(viocdev->viocdev_idx, param1, param2, 1);
+
+	viocdev->vioc_state =3D VIOC_STATE_UP;
+
+	return ret;
+
+      vioc_probe_err:
+	vioc_remove(pdev);
+	return ret;
+}
+
+/*
+ * Set up "version" as a driver attribute.
+ */
+static ssize_t show_version(struct device_driver *drv, char *buf)
+{
+	sprintf(buf, "%s\n", VIOC_DISPLAY_VERSION);
+	return strlen(buf) + 1;
+}
+
+static DRIVER_ATTR(version, S_IRUGO, show_version, NULL);
+
+static struct pci_driver vioc_driver =3D {
+	.name =3D VIOC_DRV_MODULE_NAME,
+	.id_table =3D vioc_pci_tbl,
+	.probe =3D vioc_probe,
+	.remove =3D __devexit_p(vioc_remove),
+};
+
+static int __init vioc_module_init(void)
+{
+	int ret =3D 0;
+
+	memset(&vioc_devices, 0, sizeof(vioc_devices));
+	vioc_idx =3D 0;
+	spin_lock_init(&vioc_idx_lock);
+
+	vioc_irq_init();
+	spp_init();
+
+	ret =3D pci_module_init(&vioc_driver);
+	if (ret) {
+		printk(KERN_ERR "%s: pci_module_init() -> %d\n", __FUNCTION__,
+		       ret);
+		vioc_irq_exit();
+		return ret;
+	} else
+		driver_create_file(&vioc_driver.driver, &driver_attr_version);
+
+	vioc_os_reset_notifier_init();
+
+	return ret;
+}
+
+static void __exit vioc_module_exit(void)
+{
+	vioc_irq_exit();
+	spp_terminate();
+	flush_scheduled_work();
+	vioc_os_reset_notifier_exit();
+	driver_remove_file(&vioc_driver.driver, &driver_attr_version);
+	pci_unregister_driver(&vioc_driver);
+}
+
+module_init(vioc_module_init);
+module_exit(vioc_module_exit);
+
+#ifdef EXPORT_SYMTAB
+EXPORT_SYMBOL(vioc_viocdev);
+#endif				/* EXPORT_SYMTAB */
diff -puN /dev/null drivers/net/vioc/vioc_ethtool.c
--- /dev/null
+++ a/drivers/net/vioc/vioc_ethtool.c
@@ -0,0 +1,303 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include <linux/autoconf.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+#include <linux/ethtool.h>
+#include <linux/mii.h>
+#include <linux/if_vlan.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/notifier.h>
+#include <linux/errno.h>
+
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/byteorder.h>
+#include <asm/uaccess.h>
+
+#include "f7/vioc_hw_registers.h"
+#include "f7/vnic_defs.h"
+
+#include <linux/moduleparam.h>
+#include "vioc_vnic.h"
+#include "vioc_api.h"
+#include "driver_version.h"
+
+/* ethtool support for vnic */
+
+#ifdef SIOCETHTOOL
+#include <asm/uaccess.h>
+
+#ifndef ETH_GSTRING_LEN
+#define ETH_GSTRING_LEN 32
+#endif
+
+#ifdef ETHTOOL_OPS_COMPAT
+#include "kcompat_ethtool.c"
+#endif
+
+#define VIOC_READ_REG(R, M, V, viocdev) (\
+       readl((viocdev->ba.virt + GETRELADDR(M, V, R))))
+
+#define VIOC_WRITE_REG(R, M, V, viocdev, value) (\
+       (writel(value, viocdev->ba.virt + GETRELADDR(M, V, R))))
+
+#ifdef ETHTOOL_GSTATS
+struct vnic_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int sizeof_stat;
+	int stat_offset;
+};
+
+#define VNIC_STAT(m) sizeof(((struct vnic_device *)0)->m), \
+                     offsetof(struct vnic_device, m)
+
+static const struct vnic_stats vnic_gstrings_stats[] =3D {
+	{"rx_packets", VNIC_STAT(net_stats.rx_packets)},
+	{"tx_packets", VNIC_STAT(net_stats.tx_packets)},
+	{"rx_bytes", VNIC_STAT(net_stats.rx_bytes)},
+	{"tx_bytes", VNIC_STAT(net_stats.tx_bytes)},
+	{"rx_errors", VNIC_STAT(net_stats.rx_errors)},
+	{"tx_errors", VNIC_STAT(net_stats.tx_errors)},
+	{"rx_dropped", VNIC_STAT(net_stats.rx_dropped)},
+	{"tx_dropped", VNIC_STAT(net_stats.tx_dropped)},
+	{"multicast", VNIC_STAT(net_stats.multicast)},
+	{"collisions", VNIC_STAT(net_stats.collisions)},
+	{"rx_length_errors", VNIC_STAT(net_stats.rx_length_errors)},
+	{"rx_over_errors", VNIC_STAT(net_stats.rx_over_errors)},
+	{"rx_crc_errors", VNIC_STAT(net_stats.rx_crc_errors)},
+	{"rx_frame_errors", VNIC_STAT(net_stats.rx_frame_errors)},
+	{"rx_fifo_errors", VNIC_STAT(net_stats.rx_fifo_errors)},
+	{"rx_missed_errors", VNIC_STAT(net_stats.rx_missed_errors)},
+	{"tx_aborted_errors", VNIC_STAT(net_stats.tx_aborted_errors)},
+	{"tx_carrier_errors", VNIC_STAT(net_stats.tx_carrier_errors)},
+	{"tx_fifo_errors", VNIC_STAT(net_stats.tx_fifo_errors)},
+	{"tx_heartbeat_errors", VNIC_STAT(net_stats.tx_heartbeat_errors)},
+	{"tx_window_errors", VNIC_STAT(net_stats.tx_window_errors)},
+	{"rx_fragment_errors", VNIC_STAT(vnic_stats.rx_fragment_errors)},
+	{"rx_dropped", VNIC_STAT(vnic_stats.rx_dropped)},
+	{"tx_skb_equeued", VNIC_STAT(vnic_stats.skb_enqueued)},
+	{"tx_skb_freed", VNIC_STAT(vnic_stats.skb_freed)},
+	{"netif_stops", VNIC_STAT(vnic_stats.netif_stops)},
+	{"tx_on_empty_intr", VNIC_STAT(vnic_stats.tx_on_empty_interrupts)},
+	{"tx_headroom_misses", VNIC_STAT(vnic_stats.headroom_misses)},
+	{"tx_headroom_miss_drops", VNIC_STAT(vnic_stats.headroom_miss_drops)}=
,
+	{"tx_ring_size", VNIC_STAT(txq.count)},
+	{"tx_ring_capacity", VNIC_STAT(txq.empty)},
+	{"pkts_till_intr", VNIC_STAT(txq.tx_pkts_til_irq)},
+	{"pkts_till_bell", VNIC_STAT(txq.tx_pkts_til_bell)},
+	{"bells", VNIC_STAT(txq.bells)},
+	{"next_to_use", VNIC_STAT(txq.next_to_use)},
+	{"next_to_clean", VNIC_STAT(txq.next_to_clean)},
+	{"tx_frags", VNIC_STAT(txq.frags)},
+	{"tx_ring_wraps", VNIC_STAT(txq.wraps)},
+	{"tx_ring_fulls", VNIC_STAT(txq.full)}
+};
+
+#define VNIC_STATS_LEN \
+       sizeof(vnic_gstrings_stats) / sizeof(struct vnic_stats)
+#endif				/* ETHTOOL_GSTATS */
+#ifdef ETHTOOL_TEST
+static const char vnic_gstrings_test[][ETH_GSTRING_LEN] =3D {
+	"Register test  (offline)", "Eeprom test    (offline)",
+	"Interrupt test (offline)", "Loopback test  (offline)",
+	"Link test   (on/offline)"
+};
+
+#define VNIC_TEST_LEN sizeof(vnic_gstrings_test) / ETH_GSTRING_LEN
+#endif				/* ETHTOOL_TEST */
+
+static int vnic_get_settings(struct net_device *netdev,
+			     struct ethtool_cmd *ecmd)
+{
+	ecmd->supported =3D SUPPORTED_1000baseT_Full;
+	ecmd->advertising =3D ADVERTISED_TP;
+	ecmd->port =3D PORT_TP;
+	ecmd->phy_address =3D 0;
+	ecmd->transceiver =3D XCVR_INTERNAL;
+	ecmd->duplex =3D DUPLEX_FULL;
+	ecmd->speed =3D 3;
+	ecmd->autoneg =3D 0;
+	return 0;
+}
+
+int vioc_trace;
+
+static u32 vnic_get_msglevel(struct net_device *netdev)
+{
+	return vioc_trace;
+}
+
+static void vnic_set_msglevel(struct net_device *netdev, u32 data)
+{
+	vioc_trace =3D (int)data;
+}
+
+struct regs_line {
+	u32	addr;
+	u32	data;
+};
+
+#define VNIC_REGS_CNT 12
+#define VNIC_REGS_LINE_LEN sizeof(struct regs_line)
+
+static int vnic_get_regs_len(struct net_device *netdev)
+{
+	return (VNIC_REGS_CNT * VNIC_REGS_LINE_LEN);
+}
+
+
+static void vnic_get_regs(struct net_device *netdev,
+			  struct ethtool_regs *regs, void *p)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	struct vioc_device *viocdev =3D vnicdev->viocdev;
+	struct regs_line *regs_info =3D p;
+	int i =3D 0;
+
+	memset((void *) regs_info, 0, VNIC_REGS_CNT * VNIC_REGS_LINE_LEN);
+
+	regs->version =3D 1;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_BMC_GLOBAL, VIOC_BMC, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_BMC_GLOBAL, VIOC_BMC, 0, vio=
cdev);
+	i++;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_BMC_DEBUG, VIOC_BMC, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_BMC_DEBUG, VIOC_BMC, 0, vioc=
dev);
+	i++;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_BMC_DEBUGPRIV, VIOC_BMC, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_BMC_DEBUGPRIV, VIOC_BMC, 0, =
viocdev);
+	i++;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_BMC_FABRIC, VIOC_BMC, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_BMC_FABRIC, VIOC_BMC, 0, vio=
cdev);
+	i++;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_BMC_VNIC_EN, VIOC_BMC, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_BMC_VNIC_EN, VIOC_BMC, 0, vi=
ocdev);
+	i++;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_BMC_PORT_EN, VIOC_BMC, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_BMC_PORT_EN, VIOC_BMC, 0, vi=
ocdev);
+	i++;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_BMC_VNIC_CFG, VIOC_BMC, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_BMC_VNIC_CFG, VIOC_BMC, 0, v=
iocdev);
+	i++;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_IHCU_RXDQEN, VIOC_IHCU, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_IHCU_RXDQEN, VIOC_IHCU, 0, v=
iocdev);
+	i++;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_VENG_VLANTAG, VIOC_VENG, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_VENG_VLANTAG, VIOC_VENG, 0, =
viocdev);
+	i++;
+
+	regs_info[i].addr =3D GETRELADDR(VREG_VENG_TXD_CTL, VIOC_VENG, 0);
+	regs_info[i].data =3D VIOC_READ_REG(VREG_VENG_TXD_CTL, VIOC_VENG, 0, =
viocdev);
+}
+
+static void vnic_get_drvinfo(struct net_device *netdev,
+			     struct ethtool_drvinfo *drvinfo)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	struct vioc_device *viocdev =3D vnicdev->viocdev;
+
+	sprintf(drvinfo->driver, VIOC_DRV_MODULE_NAME);
+	strncpy(drvinfo->version, VIOC_DISPLAY_VERSION, 32);
+	sprintf(drvinfo->fw_version, "%02X-%02X", viocdev->vioc_bits_version,
+		viocdev->vioc_bits_subversion);
+	strncpy(drvinfo->bus_info, pci_name(viocdev->pdev), 32);
+	drvinfo->n_stats =3D VNIC_STATS_LEN;
+	drvinfo->testinfo_len =3D VNIC_TEST_LEN;
+	drvinfo->regdump_len =3D vnic_get_regs_len(netdev);
+	drvinfo->eedump_len =3D 0;
+}
+
+static int vnic_get_stats_count(struct net_device *netdev)
+{
+	return VNIC_STATS_LEN;
+}
+
+static void vnic_get_ethtool_stats(struct net_device *netdev,
+				   struct ethtool_stats *stats, u64 * data)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	int i;
+
+	for (i =3D 0; i < VNIC_STATS_LEN; i++) {
+		char *p =3D (char *)vnicdev + vnic_gstrings_stats[i].stat_offset;
+		data[i] =3D (vnic_gstrings_stats[i].sizeof_stat =3D=3D
+			   sizeof(u64)) ? *(u64 *) p : *(u32 *) p;
+	}
+}
+
+static void vnic_get_strings(struct net_device *netdev, u32 stringset,
+			     u8 * data)
+{
+	int i;
+
+	switch (stringset) {
+	case ETH_SS_TEST:
+		memcpy(data, *vnic_gstrings_test,
+		       VNIC_TEST_LEN * ETH_GSTRING_LEN);
+		break;
+	case ETH_SS_STATS:
+		for (i =3D 0; i < VNIC_STATS_LEN; i++) {
+			memcpy(data + i * ETH_GSTRING_LEN,
+			       vnic_gstrings_stats[i].stat_string,
+			       ETH_GSTRING_LEN);
+		}
+		break;
+	}
+}
+
+struct ethtool_ops vioc_ethtool_ops =3D {
+	.get_settings =3D vnic_get_settings,
+	.get_drvinfo =3D vnic_get_drvinfo,
+	.get_regs_len =3D vnic_get_regs_len,
+	.get_regs =3D vnic_get_regs,
+	.get_msglevel =3D vnic_get_msglevel,
+	.set_msglevel =3D vnic_set_msglevel,
+	.get_strings =3D vnic_get_strings,
+	.get_stats_count =3D vnic_get_stats_count,
+	.get_ethtool_stats =3D vnic_get_ethtool_stats,
+};
+
+#endif				/* SIOCETHTOOL */
diff -puN /dev/null drivers/net/vioc/vioc_irq.c
--- /dev/null
+++ a/drivers/net/vioc/vioc_irq.c
@@ -0,0 +1,517 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include <linux/autoconf.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+#include <linux/ethtool.h>
+#include <linux/mii.h>
+#include <linux/if_vlan.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/byteorder.h>
+#include <asm/uaccess.h>
+#include <asm/apic.h>
+
+#include "f7/vioc_hw_registers.h"
+#include "f7/vnic_defs.h"
+#include "vioc_vnic.h"
+
+#define VIOC_INTERRUPTS_CNT    19	/* 16 Rx + 1 Tx + 1 BMC + 1 Error */
+#define VIOC_INTERRUPTS_CNT_PIN_IRQ    4	/* 2 Rx + 1 Tx + 1 BMC */
+
+#define VIOC_SLVAR(x) x spinlock_t vioc_driver_lock =3D SPIN_LOCK_UNLO=
CKED
+#define VIOC_CLI spin_lock_irq(&vioc_driver_lock)
+#define VIOC_STI spin_unlock_irq(&vioc_driver_lock)
+#define IRQRETURN return IRQ_HANDLED
+#define TX_IRQ_IDX			16
+#define BMC_IRQ_IDX			17
+#define ERR_IRQ_IDX			18
+#define HANDLER_TASKLET		1
+#define HANDLER_DIRECT		2
+#define HANDLER_TASKQ		3
+#define VIOC_RX0_PCI_FUNC   0
+#define VIOC_TX_PCI_FUNC    1
+#define VIOC_BMC_PCI_FUNC   2
+#define VIOC_RX1_PCI_FUNC   3
+#define VIOC_IRQ_NONE       (u16) -1
+#define VIOC_ID_NONE        -1
+#define VIOC_IVEC_NONE      -1
+#define VIOC_INTR_NONE      -1
+
+
+struct vioc_msix_entry {
+	u16 vector;
+	u16 entry;
+};
+
+struct viocdev_intreq {
+	int vioc_id;
+	struct pci_dev *pci_dev;
+	void *vioc_virt;
+	unsigned long long vioc_phy;
+	void *ioapic_virt;
+	unsigned long long ioapic_phy;
+	struct vioc_intreq intreq[VIOC_INTERRUPTS_CNT];
+	struct vioc_msix_entry irqs[VIOC_INTERRUPTS_CNT];
+};
+
+/* GLOBAL VIOC Interrupt table/structure */
+struct viocdev_intreq vioc_interrupts[VIOC_MAX_VIOCS];
+
+VIOC_SLVAR();
+
+static irqreturn_t taskq_handler(int i, void *p)
+{
+	int intr_id =3D VIOC_IRQ_PARAM_INTR_ID(p);
+	int vioc_id =3D VIOC_IRQ_PARAM_VIOC_ID(p);
+
+	schedule_work(&vioc_interrupts[vioc_id].intreq[intr_id].taskq);
+	IRQRETURN;
+}
+
+static irqreturn_t tasklet_handler(int i, void *p)
+{
+	int intr_id =3D VIOC_IRQ_PARAM_INTR_ID(p);
+	int vioc_id =3D VIOC_IRQ_PARAM_VIOC_ID(p);
+
+	tasklet_schedule(&vioc_interrupts[vioc_id].intreq[intr_id].tasklet);
+	IRQRETURN;
+}
+
+static irqreturn_t direct_handler(int i, void *p)
+{
+	int intr_id =3D VIOC_IRQ_PARAM_INTR_ID(p);
+	int vioc_id =3D VIOC_IRQ_PARAM_VIOC_ID(p);
+
+	vioc_interrupts[vioc_id].intreq[intr_id].
+	    intrFuncp((void *)&vioc_interrupts[vioc_id].intreq[intr_id].taskq=
);
+	IRQRETURN;
+}
+
+static int vioc_enable_msix(u32 viocdev_idx)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(viocdev_idx);
+	int ret;
+
+#if defined(CONFIG_MSIX_MOD)
+	ret =3D pci_enable_msix(viocdev->pdev,
+			      (struct msix_entry *)
+			      &vioc_interrupts[viocdev_idx].irqs,
+			      VIOC_INTERRUPTS_CNT);
+	if (ret =3D=3D 0) {
+		dev_err(&viocdev->pdev->dev, "MSI-X OK\n");
+		return VIOC_INTERRUPTS_CNT;
+	} else {
+		dev_err(&viocdev->pdev->dev,
+		       "Enabling MSIX failed (%d) VIOC %d, use PIN-IRQ\n", ret,
+		       viocdev_idx);
+		pci_disable_msix(viocdev->pdev);
+		ret =3D pci_request_regions(viocdev->pdev, VIOC_DRV_MODULE_NAME);
+		if (ret !=3D 0) {
+			dev_err(&viocdev->pdev->dev, "vioc%d: Cannot obtain PCI resources\n=
",
+			       viocdev_idx);
+			return 0;
+		}
+		return VIOC_INTERRUPTS_CNT_PIN_IRQ;
+	}
+#else
+	ret =3D pci_request_regions(viocdev->pdev, VIOC_DRV_MODULE_NAME);
+	if (ret !=3D 0) {
+		dev_err(&viocdev->pdev->dev, "vioc%d: Cannot obtain PCI resources\n"=
,
+		       viocdev_idx);
+		return 0;
+	}
+	return VIOC_INTERRUPTS_CNT_PIN_IRQ;
+#endif
+}
+
+static void vioc_irq_remove(int viocdev_idx, int irq)
+{
+	int intr_id;
+
+	if (viocdev_idx >=3D VIOC_MAX_VIOCS)
+		return;
+
+	for (intr_id =3D 0; intr_id < VIOC_INTERRUPTS_CNT; intr_id++) {
+		if (vioc_interrupts[viocdev_idx].intreq[intr_id].irq =3D=3D irq) {
+			if (vioc_interrupts[viocdev_idx].intreq[intr_id].irq !=3D
+			    VIOC_IRQ_NONE) {
+				free_irq(vioc_interrupts[viocdev_idx].
+					 intreq[intr_id].irq,
+					 vioc_interrupts[viocdev_idx].
+					 intreq[intr_id].intrFuncparm);
+			}
+			vioc_interrupts[viocdev_idx].intreq[intr_id].irq =3D
+			    VIOC_IRQ_NONE;
+			vioc_interrupts[viocdev_idx].irqs[intr_id].vector =3D
+			    VIOC_IRQ_NONE;
+		}
+	}
+}
+
+void vioc_free_irqs(u32 viocdev_idx)
+{
+	u32 i;
+
+	for (i =3D 0; i < VIOC_INTERRUPTS_CNT; i++) {
+		if (vioc_interrupts[viocdev_idx].irqs[i].vector !=3D
+		    VIOC_IRQ_NONE) {
+			vioc_irq_remove(viocdev_idx,
+					vioc_interrupts[viocdev_idx].irqs[i].
+					vector);
+		}
+	}
+}
+
+void vioc_irq_exit(void)
+{
+	int vioc_id;
+
+	for (vioc_id =3D 0; vioc_id < VIOC_MAX_VIOCS; vioc_id++)
+		vioc_free_irqs(vioc_id);
+}
+
+int vioc_irq_init(void)
+{
+	int intr_id, vioc_id;
+
+	/* Zero out whole vioc_interrupts array */
+	memset(&vioc_interrupts, 0, sizeof(vioc_interrupts));
+
+	for (vioc_id =3D 0; vioc_id < VIOC_MAX_VIOCS; vioc_id++) {
+		vioc_interrupts[vioc_id].vioc_id =3D VIOC_ID_NONE;
+		for (intr_id =3D 0; intr_id < VIOC_INTERRUPTS_CNT; intr_id++) {
+			vioc_interrupts[vioc_id].intreq[intr_id].irq =3D
+			    VIOC_IRQ_NONE;
+			vioc_interrupts[vioc_id].irqs[intr_id].vector =3D
+			    VIOC_IRQ_NONE;
+			vioc_interrupts[vioc_id].irqs[intr_id].entry =3D intr_id;
+		}
+	}
+	return 0;
+}
+
+int get_pci_pin_irq(struct pci_dev *dev_in, int func)
+{
+	struct pci_dev *dev =3D NULL;
+	unsigned int slot, fn, devfn;
+
+	slot =3D PCI_SLOT(dev_in->devfn);
+	fn =3D PCI_FUNC(dev_in->devfn);
+	devfn =3D dev_in->devfn;
+
+	devfn =3D PCI_DEVFN(slot, func);
+	/* Find pci_dev structure of the requested function */
+	dev =3D pci_find_slot(dev_in->bus->number, devfn);
+	if (dev) {
+		return dev->irq;
+	} else {
+		return VIOC_IRQ_NONE;
+	}
+}
+
+static int vioc_irq_install(struct pci_dev *vioc_pci_dev,
+			    void (*routine) (struct work_struct *work),
+			    int vioc_id,
+			    int intr_id,
+			    int irq,
+			    int intr_handler_type,
+			    int intr_param, char *intr_name)
+{
+	int ret;
+
+	/*
+	 * Find IRQ of requested interrupt: For now, search the
+	 * vioc_interrupts[] table that was initialized with proper
+	 * IRQs during viocdev_htirq_init() In the final product, the
+	 * IRQ will be obtained from the pci_dev structure of the VIOC
+	 * device.
+	 */
+
+	if (vioc_id >=3D VIOC_MAX_VIOCS)
+		return -ENODEV;
+
+	if (intr_id >=3D VIOC_INTERRUPTS_CNT) {
+		dev_err(&vioc_pci_dev->dev,
+		       "%s: INTR ID (%d) out of range for Interrupt IRQ %d, name %s\=
n",
+		       __FUNCTION__, intr_id, irq, intr_name);
+		return -EINVAL;
+	}
+	vioc_interrupts[vioc_id].vioc_id =3D vioc_id;
+
+	if (vioc_interrupts[vioc_id].intreq[intr_id].irq !=3D VIOC_IRQ_NONE) =
{
+		free_irq(vioc_interrupts[vioc_id].
+			 intreq[intr_id].irq,
+			 vioc_interrupts[vioc_id].intreq[intr_id].intrFuncparm);
+		vioc_interrupts[vioc_id].intreq[intr_id].irq =3D VIOC_IRQ_NONE;
+	}
+
+	vioc_set_intr_func_param(vioc_id, intr_id, intr_param);
+	INIT_WORK(&vioc_interrupts[vioc_id].intreq[intr_id].taskq, routine);
+
+	vioc_interrupts[vioc_id].intreq[intr_id].irq =3D irq;
+	vioc_interrupts[vioc_id].intreq[intr_id].name[VIOC_NAME_LEN - 1] =3D =
'\0';
+
+	vioc_interrupts[vioc_id].intreq[intr_id].timeout_value =3D 100;
+	vioc_interrupts[vioc_id].intreq[intr_id].pkt_counter =3D 1;
+	vioc_interrupts[vioc_id].intreq[intr_id].vec =3D VIOC_IVEC_NONE;
+	vioc_interrupts[vioc_id].intreq[intr_id].intrFuncp =3D routine;
+
+	/* Init work_struct used to schedule task from INTR handler code */
+
+	/* Init tasklet_struct used to run "tasklet" from INTR handler code *=
/
+	vioc_interrupts[vioc_id].intreq[intr_id].tasklet.next =3D NULL;
+	vioc_interrupts[vioc_id].intreq[intr_id].tasklet.state =3D 0;
+	atomic_set(&vioc_interrupts[vioc_id].intreq[intr_id].tasklet.count, 0=
);
+	vioc_interrupts[vioc_id].intreq[intr_id].tasklet.func =3D
+	    (void (*)(unsigned long))routine;
+	vioc_interrupts[vioc_id].intreq[intr_id].tasklet.data =3D
+	    (unsigned long)&vioc_interrupts[vioc_id].intreq[intr_id].taskq;
+
+	snprintf(&vioc_interrupts[vioc_id].intreq[intr_id].name[0],
+		 VIOC_NAME_LEN, "%s_%02x", intr_name, vioc_id);
+	vioc_interrupts[vioc_id].intreq[intr_id].name[VIOC_NAME_LEN - 1] =3D =
'\0';
+
+	if (intr_handler_type =3D=3D HANDLER_TASKLET)
+		vioc_interrupts[vioc_id].intreq[intr_id].hthandler =3D
+		    tasklet_handler;
+	else if (intr_handler_type =3D=3D HANDLER_TASKQ)
+		vioc_interrupts[vioc_id].intreq[intr_id].hthandler =3D
+		    taskq_handler;
+	else if (intr_handler_type =3D=3D HANDLER_DIRECT)
+		vioc_interrupts[vioc_id].intreq[intr_id].hthandler =3D
+		    direct_handler;
+	else {
+		dev_err(&vioc_pci_dev->dev,
+		       "%s: Interrupt handler type for name %s unknown\n",
+		       __FUNCTION__, intr_name);
+		return -EINVAL;
+	}
+
+	ret =3D request_irq(vioc_interrupts[vioc_id].intreq[intr_id].irq,
+			  vioc_interrupts[vioc_id].intreq[intr_id].hthandler,
+			  SA_INTERRUPT,
+			  vioc_interrupts[vioc_id].intreq[intr_id].name,
+			  vioc_interrupts[vioc_id].intreq[intr_id].
+			  intrFuncparm);
+	if (ret) {
+		dev_err(&vioc_pci_dev->dev, "%s: request_irq() -> %d\n", __FUNCTION_=
_, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int vioc_set_intr_func_param(int viocdev_idx, int intr_idx, int intr_p=
aram)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(viocdev_idx);
+
+	void *intr_func_param =3D (void *)
+	    VIOC_IRQ_PARAM_SET(viocdev_idx, intr_idx, intr_param);
+
+	if (viocdev_idx >=3D VIOC_MAX_VIOCS) {
+		dev_err(&viocdev->pdev->dev, "%s: VIOC ID (%d) is out of range\n",
+		       __FUNCTION__, viocdev_idx);
+		return -ENODEV;
+	}
+
+	if (intr_idx >=3D VIOC_INTERRUPTS_CNT) {
+		dev_err(&viocdev->pdev->dev, "%s: INTR ID (%d) is out of range\n",
+		       __FUNCTION__, intr_idx);
+		return -EINVAL;
+	}
+
+	vioc_interrupts[viocdev_idx].intreq[intr_idx].intrFuncparm =3D
+	    intr_func_param;
+	return 0;
+}
+
+/*
+ * Function returns number of Rx IRQs.
+ * When PIN IRQ is used, 2 Rx IRQs are supported.
+ * With MSI-X 16 Rx IRQs.
+ */
+
+int vioc_request_irqs(u32 viocdev_idx)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(viocdev_idx);
+	int ret;
+	int total_num_irqs;
+	int intr_idx;
+	char name_buf[64];
+
+	/* Check for MSI-X, install either 2 or 16 Rx IRQs */
+	total_num_irqs =3D vioc_enable_msix(viocdev_idx);
+	viocdev->num_irqs =3D total_num_irqs;
+
+	switch (total_num_irqs) {
+
+	case VIOC_INTERRUPTS_CNT_PIN_IRQ:
+		vioc_interrupts[viocdev_idx].irqs[2].vector =3D
+		    get_pci_pin_irq(viocdev->pdev, VIOC_TX_PCI_FUNC);
+		vioc_interrupts[viocdev_idx].irqs[3].vector =3D
+		    get_pci_pin_irq(viocdev->pdev, VIOC_BMC_PCI_FUNC);
+
+		intr_idx =3D 0;
+		vioc_interrupts[viocdev_idx].irqs[intr_idx].vector =3D
+		    get_pci_pin_irq(viocdev->pdev, VIOC_RX0_PCI_FUNC);
+		sprintf(name_buf, "rx%02d_intr", intr_idx);
+		ret =3D vioc_irq_install(viocdev->pdev,
+				       vioc_rxc_interrupt,
+				       viocdev_idx,
+				       intr_idx,
+				       vioc_interrupts[viocdev_idx].
+				       irqs[intr_idx].vector, HANDLER_DIRECT,
+				       intr_idx, name_buf);
+		if (ret) {
+			dev_err(&viocdev->pdev->dev, "vioc%d: RX IRQ %02d not installed\n",
+			       viocdev_idx, intr_idx);
+			return 0;
+		}
+
+		intr_idx =3D 1;
+		vioc_interrupts[viocdev_idx].irqs[intr_idx].vector =3D
+		    get_pci_pin_irq(viocdev->pdev, VIOC_RX1_PCI_FUNC);
+		sprintf(name_buf, "rx%02d_intr", intr_idx);
+		ret =3D vioc_irq_install(viocdev->pdev,
+				       vioc_rxc_interrupt,
+				       viocdev_idx,
+				       intr_idx,
+				       vioc_interrupts[viocdev_idx].
+				       irqs[intr_idx].vector, HANDLER_DIRECT,
+				       intr_idx, name_buf);
+		if (ret) {
+			dev_err(&viocdev->pdev->dev, "vioc%d: RX IRQ %02d not installed\n",
+			       viocdev_idx, intr_idx);
+			return 0;
+		}
+
+		intr_idx =3D TX_IRQ_IDX;
+		vioc_interrupts[viocdev_idx].irqs[intr_idx].vector =3D
+		    get_pci_pin_irq(viocdev->pdev, VIOC_TX_PCI_FUNC);
+		ret =3D vioc_irq_install(viocdev->pdev,
+				       vioc_tx_interrupt,
+				       viocdev_idx,
+				       intr_idx,
+				       vioc_interrupts[viocdev_idx].
+				       irqs[intr_idx].vector, HANDLER_TASKLET,
+				       intr_idx, "tx_intr");
+		if (ret) {
+			dev_err(&viocdev->pdev->dev, "vioc%d: TX IRQ not installed\n",
+			       viocdev_idx);
+			return 0;
+		}
+
+		intr_idx =3D BMC_IRQ_IDX;
+		vioc_interrupts[viocdev_idx].irqs[intr_idx].vector =3D
+		    get_pci_pin_irq(viocdev->pdev, VIOC_BMC_PCI_FUNC);
+		ret =3D vioc_irq_install(viocdev->pdev,
+				       vioc_bmc_interrupt,
+				       viocdev_idx,
+				       intr_idx,
+				       vioc_interrupts[viocdev_idx].
+				       irqs[intr_idx].vector, HANDLER_TASKQ,
+				       intr_idx, "bmc_intr");
+		if (ret) {
+			dev_err(&viocdev->pdev->dev, "vioc%d: BMC IRQ not installed\n",
+			       viocdev_idx);
+			return 0;
+		}
+
+		return 2;
+
+	case VIOC_INTERRUPTS_CNT:
+
+		for (intr_idx =3D 0; intr_idx < 16; intr_idx++) {
+			sprintf(name_buf, "rx%02d_intr", intr_idx);
+			ret =3D vioc_irq_install(viocdev->pdev,
+					       vioc_rxc_interrupt,
+					       viocdev_idx,
+					       intr_idx,
+					       vioc_interrupts[viocdev_idx].
+					       irqs[intr_idx].vector,
+					       HANDLER_DIRECT, intr_idx,
+					       name_buf);
+			if (ret) {
+				dev_err(&viocdev->pdev->dev,
+				       "vioc%d: RX IRQ %02d not installed\n",
+				       viocdev_idx, intr_idx);
+				return 0;
+			}
+		}
+
+		intr_idx =3D TX_IRQ_IDX;
+		ret =3D vioc_irq_install(viocdev->pdev,
+				       vioc_tx_interrupt,
+				       viocdev_idx,
+				       intr_idx,
+				       vioc_interrupts[viocdev_idx].
+				       irqs[intr_idx].vector, HANDLER_TASKLET,
+				       intr_idx, "tx_intr");
+		if (ret) {
+			dev_err(&viocdev->pdev->dev, "vioc%d: TX IRQ not installed\n",
+			       viocdev_idx);
+			return 0;
+		}
+
+		intr_idx =3D BMC_IRQ_IDX;
+		ret =3D vioc_irq_install(viocdev->pdev,
+				       vioc_bmc_interrupt,
+				       viocdev_idx,
+				       intr_idx,
+				       vioc_interrupts[viocdev_idx].
+				       irqs[intr_idx].vector, HANDLER_TASKQ,
+				       intr_idx, "bmc_intr");
+		if (ret) {
+			dev_err(&viocdev->pdev->dev, "vioc%d: BMC IRQ not installed\n",
+			       viocdev_idx);
+			return 0;
+		}
+
+		return 16;
+
+	default:
+
+		return 0;
+	}
+
+	return 0;
+}
+
diff -puN /dev/null drivers/net/vioc/vioc_provision.c
--- /dev/null
+++ a/drivers/net/vioc/vioc_provision.c
@@ -0,0 +1,226 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include "f7/vioc_hw_registers.h"
+#include "vioc_vnic.h"
+
+/*
+ * Standard parameters for ring provisioning.  Single TxQ per VNIC.
+ * Two RX sets per VIOC, with 3 RxDs, 1 RxC, 1 Rx interrupt per set.
+ */
+
+#define TXQ_ENTRIES                    1024
+#define TX_INTR_ON_EMPTY       false
+
+/* RXDQ sizes (entry counts) must be multiples of this */
+#define        RXDQ_ALIGN              VIOC_RXD_BATCH_BITS
+#define        RXDQ_ENTRIES    1024
+
+#define        RXDQ_JUMBO_ENTRIES              ALIGN(RXDQ_ENTRIES, RXD=
Q_ALIGN)
+#define        RXDQ_STD_ENTRIES                ALIGN(RXDQ_ENTRIES, RXD=
Q_ALIGN)
+#define        RXDQ_SMALL_ENTRIES              ALIGN(RXDQ_ENTRIES, RXD=
Q_ALIGN)
+#define        RXDQ_EXTRA_ENTRIES              ALIGN(RXDQ_ENTRIES, RXD=
Q_ALIGN)
+
+#define        RXC_ENTRIES             (RXDQ_JUMBO_ENTRIES+RXDQ_STD_EN=
TRIES+RXDQ_SMALL_ENTRIES+RXDQ_EXTRA_ENTRIES)
+
+#define        RXDQ_JUMBO_BUFSIZE      (VNIC_MAX_MTU+ETH_HLEN+F7PF_HLE=
N_STD)
+#define        RXDQ_STD_BUFSIZE        (VNIC_STD_MTU+ETH_HLEN+F7PF_HLE=
N_STD)
+#define        RXDQ_SMALL_BUFSIZE      (256+ETH_HLEN+F7PF_HLEN_STD)
+
+#define        RXDQ_JUMBO_ALLOC_BUFSIZE        ALIGN(RXDQ_JUMBO_BUFSIZ=
E,64)
+#define        RXDQ_STD_ALLOC_BUFSIZE  ALIGN(RXDQ_STD_BUFSIZE,64)
+#define        RXDQ_SMALL_ALLOC_BUFSIZE        ALIGN(RXDQ_SMALL_BUFSIZ=
E,64)
+
+/*
+ Every entry in this structure is defined as follows:
+
+struct vnic_prov_def {
+       struct rxd_q_prov rxd_ring[4];
+       u32  tx_entries;        Size of Tx Ring
+       u32  rxc_entries;   Size of Rx Completion Ring
+       u8      rxc_id;                 Rx Completion queue ID
+       u8      rxc_intr_id;    INTR servicing the above Rx Completion =
queue
+};
+
+The 4 rxd_q_prov structures of rxd_ring[] array define  Rx queues per =
VNIC.
+struct rxd_q_prov {
+       u32        buf_size;    Buffer size
+       u32        entries;             Size of the queue
+       u8         id;                  Queue id/
+       u8         state;               Provisioning state 1-ena, 0-dis
+};
+
+*/
+
+struct vnic_prov_def vnic_set_0 =3D {
+	.rxd_ring[0].buf_size =3D RXDQ_SMALL_ALLOC_BUFSIZE,
+	.rxd_ring[0].entries =3D RXDQ_SMALL_ENTRIES,
+	.rxd_ring[0].id =3D 0,
+	.rxd_ring[0].state =3D 1,
+	.rxd_ring[1].buf_size =3D RXDQ_STD_ALLOC_BUFSIZE,
+	.rxd_ring[1].entries =3D RXDQ_STD_ENTRIES,
+	.rxd_ring[1].id =3D 1,
+	.rxd_ring[1].state =3D 1,
+	.rxd_ring[2].buf_size =3D RXDQ_JUMBO_ALLOC_BUFSIZE,
+	.rxd_ring[2].entries =3D RXDQ_JUMBO_ENTRIES,
+	.rxd_ring[2].id =3D 2,
+	.rxd_ring[2].state =3D 1,
+	.tx_entries =3D TXQ_ENTRIES,.rxc_entries =3D RXC_ENTRIES,.rxc_id =3D
+	    0,.rxc_intr_id =3D 0
+};
+
+struct vnic_prov_def vnic_set_1 =3D {
+	.rxd_ring[0].buf_size =3D RXDQ_SMALL_ALLOC_BUFSIZE,
+	.rxd_ring[0].entries =3D RXDQ_SMALL_ENTRIES,
+	.rxd_ring[0].id =3D 4,
+	.rxd_ring[0].state =3D 1,
+	.rxd_ring[1].buf_size =3D RXDQ_STD_ALLOC_BUFSIZE,
+	.rxd_ring[1].entries =3D RXDQ_STD_ENTRIES,
+	.rxd_ring[1].id =3D 5,
+	.rxd_ring[1].state =3D 1,
+	.rxd_ring[2].buf_size =3D RXDQ_JUMBO_ALLOC_BUFSIZE,
+	.rxd_ring[2].entries =3D RXDQ_JUMBO_ENTRIES,
+	.rxd_ring[2].id =3D 6,
+	.rxd_ring[2].state =3D 1,
+	.tx_entries =3D TXQ_ENTRIES,.rxc_entries =3D RXC_ENTRIES,.rxc_id =3D
+	    1,.rxc_intr_id =3D 1
+};
+
+struct vnic_prov_def vnic_set_2 =3D {
+	.rxd_ring[0].buf_size =3D RXDQ_SMALL_ALLOC_BUFSIZE,
+	.rxd_ring[0].entries =3D RXDQ_SMALL_ENTRIES,
+	.rxd_ring[0].id =3D 8,
+	.rxd_ring[0].state =3D 1,
+	.rxd_ring[1].buf_size =3D RXDQ_STD_ALLOC_BUFSIZE,
+	.rxd_ring[1].entries =3D RXDQ_STD_ENTRIES,
+	.rxd_ring[1].id =3D 9,
+	.rxd_ring[1].state =3D 1,
+	.rxd_ring[2].buf_size =3D RXDQ_JUMBO_ALLOC_BUFSIZE,
+	.rxd_ring[2].entries =3D RXDQ_JUMBO_ENTRIES,
+	.rxd_ring[2].id =3D 10,
+	.rxd_ring[2].state =3D 1,
+	.tx_entries =3D TXQ_ENTRIES,.rxc_entries =3D RXC_ENTRIES,.rxc_id =3D
+	    2,.rxc_intr_id =3D 2
+};
+
+struct vnic_prov_def vnic_set_3 =3D {
+	.rxd_ring[0].buf_size =3D RXDQ_SMALL_ALLOC_BUFSIZE,
+	.rxd_ring[0].entries =3D RXDQ_SMALL_ENTRIES,
+	.rxd_ring[0].id =3D 12,
+	.rxd_ring[0].state =3D 1,
+	.rxd_ring[1].buf_size =3D RXDQ_STD_ALLOC_BUFSIZE,
+	.rxd_ring[1].entries =3D RXDQ_STD_ENTRIES,
+	.rxd_ring[1].id =3D 13,
+	.rxd_ring[1].state =3D 1,
+	.rxd_ring[2].buf_size =3D RXDQ_JUMBO_ALLOC_BUFSIZE,
+	.rxd_ring[2].entries =3D RXDQ_JUMBO_ENTRIES,
+	.rxd_ring[2].id =3D 15,
+	.rxd_ring[2].state =3D 1,
+	.tx_entries =3D TXQ_ENTRIES,.rxc_entries =3D RXC_ENTRIES,.rxc_id =3D
+	    3,.rxc_intr_id =3D 3
+};
+
+struct vnic_prov_def vnic_set_sim =3D {
+	.rxd_ring[0].buf_size =3D RXDQ_STD_ALLOC_BUFSIZE,
+	.rxd_ring[0].entries =3D 256,
+	.rxd_ring[0].id =3D 0,
+	.rxd_ring[0].state =3D 1,
+	.rxd_ring[1].buf_size =3D RXDQ_STD_ALLOC_BUFSIZE,
+	.rxd_ring[1].entries =3D 256,
+	.rxd_ring[1].id =3D 1,
+	.rxd_ring[1].state =3D 1,
+	.rxd_ring[2].buf_size =3D RXDQ_STD_ALLOC_BUFSIZE,
+	.rxd_ring[2].entries =3D 256,
+	.rxd_ring[2].id =3D 2,
+	.rxd_ring[2].state =3D 1,
+	.tx_entries =3D 256,.rxc_entries =3D 256 * 3,.rxc_id =3D 0,.rxc_intr_=
id =3D 0
+};
+
+struct vnic_prov_def *vnic_prov_pmm_pin_irq[VIOC_MAX_VNICS] =3D {
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_0,
+	&vnic_set_1
+};
+
+struct vnic_prov_def *vnic_prov_pmm_msi_x[VIOC_MAX_VNICS] =3D {
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_2,
+	&vnic_set_3,
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_2,
+	&vnic_set_3,
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_2,
+	&vnic_set_3,
+	&vnic_set_0,
+	&vnic_set_1,
+	&vnic_set_2,
+	&vnic_set_3
+};
+
+struct vnic_prov_def *vnic_prov_sim[VIOC_MAX_VNICS] =3D {
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim,
+	&vnic_set_sim
+};
+
+struct vnic_prov_def **vioc_prov_get(int num_rx_irq)
+{
+	if (num_rx_irq =3D=3D 16)
+		return (struct vnic_prov_def **)&vnic_prov_pmm_msi_x;
+	else
+		return (struct vnic_prov_def **)&vnic_prov_pmm_pin_irq;
+
+}
diff -puN /dev/null drivers/net/vioc/vioc_receive.c
--- /dev/null
+++ a/drivers/net/vioc/vioc_receive.c
@@ -0,0 +1,367 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include <linux/autoconf.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+#include <linux/ethtool.h>
+#include <linux/mii.h>
+#include <linux/if_vlan.h>
+
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/byteorder.h>
+#include <asm/uaccess.h>
+
+#include "f7/vioc_hw_registers.h"
+#include "f7/vnic_defs.h"
+
+#include "vioc_vnic.h"
+#include "vioc_api.h"
+
+/*
+ * Receive one packet.  The VIOC is read-locked.  Since RxDQs are
+ * partitioned into independent RxSets and VNICs assigned to exactly
+ * one RxSet, no locking is needed on RxDQs or RxCQs.
+ * Return true if we got a packet, false if the queue is empty.
+ */
+int vioc_rx_pkt(struct vioc_device *viocdev, struct rxc *rxc, u32 sw_i=
dx)
+{
+	u32 rx_status;
+	u32 vnic_id;
+	u32 rxdq_id;
+	u32 rxd_id;
+	u32 pkt_len;
+	u32 dmap_idx;
+	struct sk_buff *in_skb, *out_skb;
+	struct vnic_device *vnicdev;
+	struct rxdq *rxdq;
+	struct rxc_pktDesc_Phys_w *rxcd;
+	struct rx_pktBufDesc_Phys_w *rxd;
+
+	rxcd =3D &rxc->desc[sw_idx];
+	if (GET_VNIC_RXC_FLAGGED(rxcd) !=3D VNIC_RXC_FLAGGED_HW_W)
+		return 0;	/* ring empty */
+
+	vnic_id =3D GET_VNIC_RXC_VNIC_ID_SHIFTED(rxcd);
+	rxdq_id =3D GET_VNIC_RXC_RXQ_ID_SHIFTED(rxcd);
+	rxd_id =3D GET_VNIC_RXC_IDX_SHIFTED(rxcd);
+	rxdq =3D viocdev->rxd_p[rxdq_id];
+	rxd =3D &rxdq->desc[rxd_id];
+
+	in_skb =3D (struct sk_buff *)rxdq->vbuf[rxd_id].skb;
+	BUG_ON(in_skb =3D=3D NULL);
+	out_skb =3D in_skb;	/* default it here */
+
+	/*
+	 * Reset HW FLAG in this RxC Descriptor, marking it as "SW
+	 * acknowledged HW completion".
+	 */
+	CLR_VNIC_RXC_FLAGGED(rxcd);
+
+	if (!(viocdev->vnics_map & (1 << vnic_id)))
+		/* VNIC is not enabled - silently drop packet */
+		goto out;
+
+	in_skb->dev =3D viocdev->vnic_netdev[vnic_id];
+	vnicdev =3D in_skb->dev->priv;
+	BUG_ON(vnicdev =3D=3D NULL);
+
+	rx_status =3D GET_VNIC_RXC_STATUS(rxcd);
+
+	if (likely(rx_status =3D=3D VNIC_RXC_STATUS_OK_W)) {
+
+		pkt_len =3D GET_NTOH_VIOC_F7PF_PKTLEN_SHIFTED(in_skb->data);
+
+		/* Copy out mice packets in ALL rings, even small */
+		if (pkt_len <=3D VIOC_COPYOUT_THRESHOLD) {
+			out_skb =3D dev_alloc_skb(pkt_len);
+			if (!out_skb)
+				goto drop;
+			out_skb->dev =3D in_skb->dev;
+			memcpy(out_skb->data, in_skb->data, pkt_len);
+		}
+
+		vnicdev->net_stats.rx_bytes +=3D pkt_len;
+		vnicdev->net_stats.rx_packets++;
+		/* Set ->len and ->tail to reflect packet size */
+		skb_put(out_skb, pkt_len);
+
+		skb_pull(out_skb, F7PF_HLEN_STD);
+		out_skb->protocol =3D eth_type_trans(out_skb, out_skb->dev);
+
+		/* Checksum offload */
+		if (GET_VNIC_RXC_ENTAG_SHIFTED(rxcd) =3D=3D
+		    VIOC_F7PF_ET_ETH_IPV4_CKS)
+			out_skb->ip_summed =3D CHECKSUM_UNNECESSARY;
+		else {
+			out_skb->ip_summed =3D VIOC_CSUM_OFFLOAD;
+			out_skb->csum =3D
+			    ntohs(~GET_VNIC_RXC_CKSUM_SHIFTED(rxcd) & 0xffff);
+		}
+
+		netif_receive_skb(out_skb);
+	} else {
+		vnicdev->net_stats.rx_errors++;
+		if (rx_status & VNIC_RXC_ISBADLENGTH_W)
+			vnicdev->net_stats.rx_length_errors++;
+		if (rx_status & VNIC_RXC_ISBADCRC_W)
+			vnicdev->net_stats.rx_crc_errors++;
+		vnicdev->net_stats.rx_missed_errors++;
+	      drop:
+		vnicdev->net_stats.rx_dropped++;
+	}
+
+      out:
+	CLR_VNIC_RX_OWNED(rxd);
+
+	/* Deallocate only if we did not copy skb above */
+	if (in_skb =3D=3D out_skb) {
+		pci_unmap_single(viocdev->pdev,
+				 rxdq->vbuf[rxd_id].dma,
+				 rxdq->rx_buf_size, PCI_DMA_FROMDEVICE);
+		rxdq->vbuf[rxd_id].skb =3D NULL;
+		rxdq->vbuf[rxd_id].dma =3D (dma_addr_t) NULL;
+	}
+
+	dmap_idx =3D rxd_id / VIOC_RXD_BATCH_BITS;
+	rxdq->dmap[dmap_idx] &=3D ~(1 << (rxd_id % VIOC_RXD_BATCH_BITS));
+
+	if (!rxdq->skip_fence_run)
+		vioc_next_fence_run(rxdq);
+	else
+		rxdq->skip_fence_run--;
+
+	return 1;		/* got a packet */
+}
+
+/*
+ * Refill one batch of VIOC_RXD_BATCH_BITS descriptors with skb's as
+ * needed.  Transfer this batch to HW.  Return -1 on success, the
+ * batch id otherwise (which means this batch must be retried.)
+ */
+static u32 _vioc_fill_n_xfer(struct rxdq *rxdq, unsigned batch_idx)
+{
+	unsigned first_idx, idx;
+	int i;
+	struct rx_pktBufDesc_Phys_w *rxd;
+	struct sk_buff *skb;
+	u64 x;
+	unsigned size;
+
+	first_idx =3D batch_idx * VIOC_RXD_BATCH_BITS;
+	size =3D rxdq->rx_buf_size;
+	i =3D VIOC_RXD_BATCH_BITS;
+
+	while (--i >=3D 0) {
+		idx =3D first_idx + i;
+		/* Check if that slot is unallocated */
+		if (rxdq->vbuf[idx].skb =3D=3D NULL) {
+			skb =3D dev_alloc_skb(size + 64);
+			if (skb =3D=3D NULL) {
+				goto undo_refill;
+			}
+			/* Cache align */
+			x =3D (u64) skb->data;
+			skb->data =3D (unsigned char *)ALIGN(x, 64);
+			rxdq->vbuf[idx].skb =3D skb;
+			rxdq->vbuf[idx].dma =3D
+			    pci_map_single(rxdq->viocdev->pdev,
+					   skb->data, size, PCI_DMA_FROMDEVICE);
+		}
+
+		rxd =3D RXD_PTR(rxdq, idx);
+
+		if (idx =3D=3D first_idx)
+			/*
+			 * Making sure that all writes to the Rx
+			 * Descriptor Queue where completed before
+			 * turning over up the last (i.e the first)
+			 * descriptor to HW.
+			 */
+			wmb();
+
+		/* Set the address of the Rx buffer and HW FLAG */
+		SET_VNIC_RX_BUFADDR_HW(rxd, rxdq->vbuf[idx].dma);
+	}
+
+	rxdq->dmap[batch_idx] =3D ALL_BATCH_HW_OWNED;
+	return VIOC_NONE_TO_HW;	/* XXX success */
+
+      undo_refill:
+	/*
+	 * Just turn descriptors over to SW.  Leave skb's allocated,
+	 * they will be used when we retry.  Uses idx!
+	 */
+	for (; idx < (first_idx + VIOC_RXD_BATCH_BITS); idx++) {
+		rxd =3D RXD_PTR(rxdq, idx);
+		CLR_VNIC_RX_OWNED(rxd);
+	}
+
+	rxdq->starvations++;
+	return batch_idx;	/* failure - retry this batch */
+}
+
+#define IDX_PLUS_DELTA(idx, count, delta) \
+       (((idx) + (delta)) % (count))
+#define IDX_MINUS_DELTA(idx, count, delta) \
+       (((idx) =3D=3D 0) ? ((count) - (delta)): ((idx) - (delta)))
+
+/*
+ * Returns 0 on success, or a negative errno on failure
+ */
+int vioc_next_fence_run(struct rxdq *rxdq)
+{
+	unsigned dmap_idx, dmap_start, dmap_end, dmap_count;
+	unsigned to_hw =3D rxdq->to_hw;
+
+	if (to_hw !=3D VIOC_NONE_TO_HW)
+		to_hw =3D _vioc_fill_n_xfer(rxdq, to_hw);
+	if (to_hw !=3D VIOC_NONE_TO_HW) {
+		/* Problem! Can't refill the Rx queue. */
+		rxdq->to_hw =3D to_hw;
+		return -ENOMEM;
+	}
+
+	dmap_count =3D rxdq->dmap_count;
+	dmap_start =3D rxdq->fence;
+	dmap_end =3D IDX_MINUS_DELTA(dmap_start, dmap_count, 1);
+	dmap_idx =3D dmap_start;
+
+	while (rxdq->dmap[dmap_idx] =3D=3D ALL_BATCH_SW_OWNED) {
+		dmap_idx =3D IDX_PLUS_DELTA(dmap_idx, dmap_count, 1);
+		if (dmap_idx =3D=3D dmap_end) {
+			rxdq->run_to_end++;
+			break;
+		}
+	}
+
+	dmap_idx =3D IDX_MINUS_DELTA(dmap_idx, dmap_count, 1);
+
+	/* If are back at the fence - nothing to do */
+	if (dmap_idx =3D=3D dmap_start)
+		return 0;
+	/*
+	 * Now dmap_idx points to the "last" batch, that is
+	 * 100% owned by SW, this will become a new fence.
+	 */
+	rxdq->fence =3D dmap_idx;
+	rxdq->skip_fence_run =3D dmap_count / 4;
+
+	/*
+	 * Go back up tp dmap_start (old fence) and refill and
+	 * turn over to HW Rx Descriptors
+	 */
+	while (dmap_idx !=3D dmap_start) {
+		dmap_idx =3D IDX_MINUS_DELTA(dmap_idx, dmap_count, 1);
+		to_hw =3D _vioc_fill_n_xfer(rxdq, dmap_idx);
+		if (to_hw !=3D VIOC_NONE_TO_HW) {
+			rxdq->to_hw =3D to_hw;
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * NAPI poll method. RxC interrupt for this queue is disabled.
+ * The only lock we need is a read-lock on the VIOC.
+ */
+int vioc_rx_poll(struct net_device *dev, int *budget)
+{
+	struct napi_poll *napi =3D dev->priv;
+	struct rxc *rxc =3D napi->rxc;
+	struct vioc_device *viocdev =3D rxc->viocdev;	/* safe */
+	u32 sw_idx, count;
+	int rxflag =3D 0;
+	int quota, work_done =3D 0;
+
+	if (!napi->enabled) {
+		/* If NOT enabled - do nothing.
+		 * ACK by setting stopped.
+		 */
+		napi->stopped =3D 1;
+		netif_rx_complete(dev);
+		return 0;
+	}
+
+	quota =3D min(*budget, dev->quota);
+
+	sw_idx =3D rxc->sw_idx;
+	count =3D rxc->count;
+	while (work_done <=3D quota) {
+		rxflag =3D vioc_rx_pkt(viocdev, rxc, sw_idx);
+		if (unlikely(!rxflag))
+			break;	/* no work left */
+		sw_idx++;
+		if (unlikely(sw_idx =3D=3D count))
+			sw_idx =3D 0;
+		work_done++;
+	}
+	rxc->sw_idx =3D sw_idx;
+	dev->quota -=3D work_done;
+	*budget -=3D work_done;
+	if (rxflag)
+		return 1;	/* keep going */
+
+	netif_rx_complete(dev);
+	dev->weight =3D POLL_WEIGHT;
+
+	vioc_rxc_interrupt_enable(rxc);
+
+	return 0;		/* poll done */
+}
+
+void vioc_rxc_interrupt(struct work_struct *work)
+{
+        struct vioc_intreq *input_param=3D container_of(work, struct v=
ioc_intreq,
+				                     taskq);
+	unsigned vioc_idx =3D VIOC_IRQ_PARAM_VIOC_ID(input_param->intrFuncpar=
m);
+	struct vioc_device *viocdev =3D vioc_viocdev(vioc_idx);
+	unsigned rxc_id =3D VIOC_IRQ_PARAM_PARAM_ID(input_param->intrFuncparm=
);
+	struct rxc *rxc =3D viocdev->rxc_p[rxc_id];
+	struct napi_poll *napi =3D &rxc->napi;
+
+	napi->rx_interrupts++;
+	/* Schedule NAPI poll */
+	if (netif_rx_schedule_prep(&napi->poll_dev)) {
+		vioc_rxc_interrupt_disable(rxc);
+		__netif_rx_schedule(&napi->poll_dev);
+	} else {
+		vioc_rxc_interrupt_clear_pend(rxc);
+	}
+}
diff -puN /dev/null drivers/net/vioc/vioc_spp.c
--- /dev/null
+++ a/drivers/net/vioc/vioc_spp.c
@@ -0,0 +1,390 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include <linux/autoconf.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+#include <linux/ethtool.h>
+#include <linux/mii.h>
+#include <linux/if_vlan.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/reboot.h>
+#include <linux/kallsyms.h>
+
+#include <asm/system.h>
+#include <asm/io.h>
+#include <asm/byteorder.h>
+#include <asm/uaccess.h>
+#include <asm/semaphore.h>
+#include <net/genetlink.h>
+
+#include "f7/vioc_hw_registers.h"
+#include "f7/vnic_defs.h"
+#include "f7/spp_msgdata.h"
+#include "vioc_vnic.h"
+#include "vioc_api.h"
+
+/* Register definitions for communication between VIOC and BMC */
+
+#define SPP_VIOC_MODULE        VIOC_BMC
+
+#define SPP_BMC_VNIC   14
+#define SPP_SIM_VNIC   15
+
+/* PMM-BMC communications messages */
+#define SPP_BMC_RST_RQ         0x01
+#define SPP_BMC_TUN_MSG                0x02
+#define SPP_BMC_HB                     0x01
+
+/* PMM-BMC Sensor register bits */
+#define SPP_HB_SENSOR_REG      GETRELADDR(SPP_VIOC_MODULE, 0, VREG_BMC=
_SENSOR0)
+#define SPP_SHUTDWN_SENSOR_REG GETRELADDR(SPP_VIOC_MODULE, 0, VREG_BMC=
_SENSOR1)
+#define SPP_PANIC_SENSOR_REG   GETRELADDR(SPP_VIOC_MODULE, 0, VREG_BMC=
_SENSOR2)
+#define SPP_RST_SENSOR_REG     GETRELADDR(SPP_VIOC_MODULE, 0, VREG_BMC=
_SENSOR3)
+
+/* PMM-BMC communications registers */
+#define SPP_BMC_HB_REG         GETRELADDR(SPP_VIOC_MODULE, SPP_BMC_VNI=
C, VREG_BMC_REG_R31)
+#define SPP_BMC_CMD_REG                GETRELADDR(SPP_VIOC_MODULE, SPP=
_BMC_VNIC, VREG_BMC_REG_R30)
+
+static DECLARE_MUTEX(vnic_prov_sem);
+
+static inline void vnic_prov_get_sema(void)
+{
+	down(&vnic_prov_sem);
+}
+
+static inline void vnic_prov_put_sema(void)
+{
+	up(&vnic_prov_sem);
+}
+
+/* VIOC must be write-locked */
+static int vioc_vnic_enable(int vioc_id, int vnic_id)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(vioc_id);
+	struct net_device *netdev;
+	int rc =3D E_VIOCOK;
+
+	netdev =3D viocdev->vnic_netdev[vnic_id];
+	if (netdev =3D=3D NULL) {
+		netdev =3D vioc_alloc_vnicdev(viocdev, vnic_id);
+		if (netdev =3D=3D NULL) {
+			rc =3D -ENOMEM;
+			goto vioc_vnic_enable_exit;
+		} else {
+			viocdev->vnic_netdev[vnic_id] =3D netdev;
+
+			if ((rc =3D register_netdev(netdev))) {
+				free_netdev(netdev);
+				viocdev->vnic_netdev[vnic_id] =3D NULL;
+				goto vioc_vnic_enable_exit;
+			}
+		}
+	}
+
+	viocdev->vnics_map |=3D (1 << vnic_id);
+
+	rc =3D vioc_vnic_resources_set(vioc_id, vnic_id);
+
+      vioc_vnic_enable_exit:
+
+	return rc;
+}
+
+/* VIOC must be write-locked */
+static int vioc_vnic_disable(int vioc_id, int vnic_id, int unreg_flag)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(vioc_id);
+
+	/* Remove VNIC from the map BEFORE releasing resources */
+	viocdev->vnics_map &=3D ~(1 << vnic_id);
+
+	if (unreg_flag) {
+		/* Unregister netdev */
+		if (viocdev->vnic_netdev[vnic_id]) {
+			unregister_netdev(viocdev->vnic_netdev[vnic_id]);
+			dev_err(&viocdev->pdev->dev, "%s: %s\n", __FUNCTION__,
+			       (viocdev->vnic_netdev[vnic_id])->name);
+			free_netdev(viocdev->vnic_netdev[vnic_id]);
+			viocdev->vnic_netdev[vnic_id] =3D NULL;
+		} else
+			BUG_ON(viocdev->vnic_netdev[vnic_id] =3D=3D NULL);
+	}
+
+	return E_VIOCOK;
+}
+
+void vioc_vnic_prov(int vioc_id, u32 vnic_en, u32 port_en, int free_fl=
ag)
+{
+	u32 change_map;
+	u32 up_map;
+	u32 down_map;
+	int vnic_id;
+	int rc =3D E_VIOCOK;
+	struct vioc_device *viocdev =3D vioc_viocdev(vioc_id);
+
+	change_map =3D vnic_en ^ viocdev->vnics_map;
+	up_map =3D vnic_en & change_map;
+	down_map =3D viocdev->vnics_map & change_map;
+
+	/* Enable from 0 to max */
+	for (vnic_id =3D 0; vnic_id < VIOC_MAX_VNICS; vnic_id++) {
+		if (up_map & (1 << vnic_id)) {
+			rc =3D vioc_vnic_enable(vioc_id, vnic_id);
+			if (rc) {
+				dev_err(&viocdev->pdev->dev, "%s: Enable VNIC %d FAILED\n",
+				       __FUNCTION__, vnic_id);
+			}
+		}
+	}
+
+	/* Disable from max to 0 */
+	for (vnic_id =3D VIOC_MAX_VNICS - 1; vnic_id >=3D 0; vnic_id--) {
+		if (down_map & (1 << vnic_id)) {
+			rc =3D vioc_vnic_disable(vioc_id, vnic_id, free_flag);
+			if (rc) {
+				dev_err(&viocdev->pdev->dev, "%s: Disable VNIC %d FAILED\n",
+				       __FUNCTION__, vnic_id);
+			}
+		}
+	}
+
+	/*
+	 * Now, after all VNIC enable-disable changes are in place,
+	 * viocdev->vnics_map contains the current state of VNIC map.
+	 * Use only ENABLED VNICs to process PORT_EN register, aka
+	 * LINK state register.
+	 */
+	for (vnic_id =3D VIOC_MAX_VNICS - 1; vnic_id >=3D 0; vnic_id--) {
+		if (viocdev->vnics_map & (1 << vnic_id)) {
+			struct net_device *netdev =3D
+			    viocdev->vnic_netdev[vnic_id];
+			if (port_en & (1 << vnic_id)) {
+				/* PORT ENABLED - LINK UP */
+				if (!netif_carrier_ok(netdev)) {
+					netif_carrier_on(netdev);
+					netif_wake_queue(netdev);
+					dev_err(&viocdev->pdev->dev, "idx %d, %s: Link UP\n",
+					       vioc_id, netdev->name);
+				}
+			} else {
+				/* PORT DISABLED - LINK DOWN */
+				if (netif_carrier_ok(netdev)) {
+					netif_stop_queue(netdev);
+					netif_carrier_off(netdev);
+					dev_err(&viocdev->pdev->dev,
+					       "idx %d, %s: Link DOWN\n",
+					       vioc_id, netdev->name);
+				}
+			}
+		}
+	}
+}
+
+/*
+ * Called from interrupt or task context
+ */
+void vioc_bmc_interrupt(struct work_struct *work)
+{
+        struct vioc_intreq *input_param=3D container_of(work, struct v=
ioc_intreq,
+				                     taskq);
+	int vioc_id =3D VIOC_IRQ_PARAM_VIOC_ID(input_param->intrFuncparm);
+	int rc =3D 0;
+	u32 intr_source_map, intr_source;
+	struct vioc_device *viocdev =3D vioc_viocdev(vioc_id);
+
+	if (viocdev->vioc_state !=3D VIOC_STATE_UP) {
+		dev_err(&viocdev->pdev->dev, "VIOC %d is not UP yet\n",
+		       viocdev->viocdev_idx);
+		return;
+	}
+
+	/* Get the Interrupt Source Register */
+	intr_source_map =3D vioc_rrd(viocdev->viocdev_idx, VIOC_BMC, 0,
+				   VREG_BMC_INTRSTATUS);
+
+	vnic_prov_get_sema();
+
+	/*
+	 * Clear all pending interrupt bits, we will service all interrupts
+	 * based on the copy of 0x144 register in intr_source.
+	 */
+	rc =3D vioc_rwr(viocdev->viocdev_idx, VIOC_BMC, 0,
+		      VREG_BMC_INTRSTATUS, intr_source_map);
+	if (rc) {
+		dev_err(&viocdev->pdev->dev, "%s: vioc_rwr() -> %d\n", __FUNCTION__,=
 rc);
+		goto vioc_bmc_interrupt_exit;
+	}
+
+	for (intr_source =3D VIOC_BMC_INTR0; intr_source_map; intr_source <<=3D=
 1) {
+		switch (intr_source_map & intr_source) {
+		case VIOC_BMC_INTR0:
+			dev_err(&viocdev->pdev->dev,
+			       "*** OLD SPP commands (BMC intr %08x) are no longer supporte=
d\n",
+			       intr_source_map);
+			break;
+		case VIOC_BMC_INTR1:
+			spp_msg_from_sim(viocdev->viocdev_idx);
+			break;
+
+		default:
+			break;
+		}
+		intr_source_map &=3D ~intr_source;
+	}
+
+      vioc_bmc_interrupt_exit:
+
+	vnic_prov_put_sema();
+
+	return;
+
+}
+
+/* SPP Messages originated by VIOC driver */
+void vioc_hb_to_bmc(int vioc_id)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(0);
+
+	if (!viocdev)
+		return;
+
+	/* Signal BMC that command was written by setting bit 0 of
+	 * SENSOR Register */
+	vioc_reg_wr(1, viocdev->ba.virt, SPP_HB_SENSOR_REG);
+}
+
+void vioc_reset_rq_to_bmc(int vioc_id, u32 command)
+{
+	struct vioc_device *viocdev =3D vioc_viocdev(0);
+
+	if (!viocdev)
+		return;
+
+	switch (command) {
+	case SYS_RESTART:
+		vioc_reg_wr(1, viocdev->ba.virt, SPP_RST_SENSOR_REG);
+		break;
+	case SYS_HALT:
+	case SYS_POWER_OFF:
+		vioc_reg_wr(1, viocdev->ba.virt, SPP_SHUTDWN_SENSOR_REG);
+		break;
+	default:
+		dev_err(&viocdev->pdev->dev, "%s: Received invalid command %d\n",
+		       __FUNCTION__, command);
+	}
+}
+
+/*-------------------------------------------------------------------*=
/
+
+/* Shutdown/Reboot handler definitions */
+static int vioc_shutdown_notify(struct notifier_block *thisblock,
+				unsigned long code, void *unused);
+
+static struct notifier_block vioc_shutdown_notifier =3D {
+	.notifier_call =3D vioc_shutdown_notify
+};
+
+void vioc_os_reset_notifier_init(void)
+{
+	/* We want to know get a callback when the system is going down */
+	if (register_reboot_notifier(&vioc_shutdown_notifier)) {
+		printk(KERN_ERR "%s: register_reboot_notifier() returned error\n",
+		       __FUNCTION__);
+	}
+}
+
+void vioc_os_reset_notifier_exit(void)
+{
+	if (unregister_reboot_notifier(&vioc_shutdown_notifier)) {
+		printk (KERN_ERR "%s: unregister_reboot_notifier() returned error\n"=
,
+		     __FUNCTION__);
+	}
+}
+
+ /*
+  * vioc_shutdown_notify - Called when the OS is going down.
+  */
+static int vioc_shutdown_notify(struct notifier_block *thisblock,
+				unsigned long code, void *unused)
+{
+	vioc_reset_rq_to_bmc(0, code);
+	printk(KERN_ERR "%s: sent %s UOS state to BMC\n",
+			__FUNCTION__,
+			((code =3D=3D SYS_RESTART) ? "REBOOT" :
+			((code =3D=3D SYS_HALT) ? "HALT" :
+			((code =3D=3D SYS_POWER_OFF) ? "POWER_OFF" : "Unknown"))));
+
+	return 0;
+}
+
+/*
+ * FUNCTION: vioc_handle_reset_request
+ * INPUT: Reset type : Shutdown, Reboot, Poweroff
+ * OUTPUT: Returns 0 on Success -EINVAL on failure
+ *
+ */
+int vioc_handle_reset_request(int reset_type)
+{
+	struct sk_buff *msg =3D NULL;
+	void *hdr;
+
+	printk(KERN_ERR "%s: received reset request %d via SPP\n",
+	       __FUNCTION__, reset_type);
+
+	/* Disable VIOC interrupts */
+	// vioc_irq_exit();
+
+	msg =3D nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (msg =3D=3D NULL) {
+		printk(KERN_ERR "%s: nlmsg_new() FAILS\n", __FUNCTION__);
+		return (-ENOBUFS);
+	}
+
+	hdr =3D nlmsg_put(msg, 0, 0, 0, 0, 0);
+
+	if (reset_type =3D=3D SPP_RESET_TYPE_REBOOT)
+		nla_put_string(msg, reset_type, "Reboot");
+	else
+		nla_put_string(msg, reset_type, "Shutdown");
+
+	nlmsg_end(msg, hdr);
+
+	return nlmsg_multicast(genl_sock, msg, 0, VIOC_LISTEN_GROUP, GFP_ATOM=
IC);
+}
diff -puN /dev/null drivers/net/vioc/vioc_transmit.c
--- /dev/null
+++ a/drivers/net/vioc/vioc_transmit.c
@@ -0,0 +1,1034 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#include <linux/module.h>
+#include <linux/autoconf.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/sched.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/socket.h>
+#include <linux/in.h>
+#include <linux/inet.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/ioport.h>
+#include <linux/pci.h>
+#include <linux/if_vlan.h>
+#include <linux/timex.h>
+#include <linux/ethtool.h>
+
+#include <net/dst.h>
+#include <net/arp.h>
+#include <net/sock.h>
+#include <net/ipv6.h>
+#include <net/ip.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/checksum.h>
+#include <asm/io.h>
+#include <asm/byteorder.h>
+#include <asm/msr.h>
+
+#include "f7/vnic_defs.h"
+#include "f7/vioc_pkts_defs.h"
+
+#include "vioc_vnic.h"
+#include "vioc_api.h"
+
+#define VNIC_MIN_MTU   64
+#define TXQ0            0
+#define NOT_SET        -1
+
+static inline u32 vnic_rd_txd_ctl(struct txq *txq)
+{
+	return readl(txq->va_of_vreg_veng_txd_ctl);
+}
+
+static inline void vnic_ring_tx_bell(struct txq *txq)
+{
+	writel(txq->shadow_VREG_VENG_TXD_CTL | VREG_VENG_TXD_CTL_QRING_MASK,
+	       txq->va_of_vreg_veng_txd_ctl);
+	txq->bells++;
+}
+
+static inline void vnic_reset_tx_ring_err(struct txq *txq)
+{
+	writel(txq->shadow_VREG_VENG_TXD_CTL |
+	       (VREG_VENG_TXD_CTL_QENABLE_MASK | VREG_VENG_TXD_CTL_CLEARMASK)=
,
+	       txq->va_of_vreg_veng_txd_ctl);
+}
+
+static inline void vnic_enable_tx_ring(struct txq *txq)
+{
+	txq->shadow_VREG_VENG_TXD_CTL =3D VREG_VENG_TXD_CTL_QENABLE_MASK;
+	writel(txq->shadow_VREG_VENG_TXD_CTL, txq->va_of_vreg_veng_txd_ctl);
+}
+
+static inline void vnic_disable_tx_ring(struct txq *txq)
+{
+	txq->shadow_VREG_VENG_TXD_CTL =3D 0;
+	writel(0, txq->va_of_vreg_veng_txd_ctl);
+}
+
+static inline void vnic_pause_tx_ring(struct txq *txq)
+{
+	txq->shadow_VREG_VENG_TXD_CTL |=3D VREG_VENG_TXD_CTL_QPAUSE_MASK;
+	writel(txq->shadow_VREG_VENG_TXD_CTL, txq->va_of_vreg_veng_txd_ctl);
+}
+
+static inline void vnic_resume_tx_ring(struct txq *txq)
+{
+	txq->shadow_VREG_VENG_TXD_CTL &=3D ~VREG_VENG_TXD_CTL_QPAUSE_MASK;
+	writel(txq->shadow_VREG_VENG_TXD_CTL, txq->va_of_vreg_veng_txd_ctl);
+}
+
+
+/* TxQ must be locked */
+static void vnic_reset_txq(struct vnic_device *vnicdev, struct txq *tx=
q)
+{
+
+	struct tx_pktBufDesc_Phys_w *txd;
+	int i;
+
+	vnic_reset_tx_ring_err(txq);
+
+	/* The reset of the code is not executing
+	 * because so far we can't reset individual VNICs.
+	 * Need to (SW) Reset the whole VIOC.
+	 */
+
+	vnic_disable_tx_ring(txq);
+	wmb();
+	/*
+	 * Clean-up all Tx Descriptors, take ownership of all
+	 * descriptors
+	 */
+	for (i =3D 0; i < txq->count; i++) {
+		if (txq->desc) {
+			txd =3D TXD_PTR(txq, i);
+			txd->word_1 =3D 0;
+			txd->word_0 =3D 0;
+		}
+		if (txq->vbuf) {
+			if (txq->vbuf[i].dma) {
+				pci_unmap_page(vnicdev->viocdev->pdev,
+					       txq->vbuf[i].dma,
+					       txq->vbuf[i].length,
+					       PCI_DMA_TODEVICE);
+				txq->vbuf[i].dma =3D 0;
+			}
+
+			/* Free skb , should be for SOP (in case of frags) only  */
+			if (txq->vbuf[i].skb) {
+				dev_kfree_skb_any((struct sk_buff *)txq->
+						  vbuf[i].skb);
+				txq->vbuf[i].skb =3D NULL;
+			}
+		}
+	}
+	txq->next_to_clean =3D 0;
+	txq->next_to_use =3D 0;
+	txq->empty =3D txq->count;
+	wmb();
+	vnic_enable_tx_ring(txq);
+}
+
+/* TxQ must be locked */
+static int vnic_clean_txq(struct vnic_device *vnicdev, struct txq *txq=
)
+{
+	struct tx_pktBufDesc_Phys_w *txd;
+	int clean_idx, pkt_len;
+	int sop_idx =3D NOT_SET;
+	int eop_idx =3D NOT_SET;
+	int reset_flag =3D 0;
+
+	if (unlikely(!txq->desc))
+		return reset_flag;
+
+	/*
+	 * Clean-up all Tx Descriptors, whose buffers where
+	 * transmitted by VIOC:
+	 * bit 30 (Valid) indicates if bits 27-29 (Status) have been set
+	 * by the VIOC HW, stating that descrptor was processed by HW.
+	 */
+	for (clean_idx =3D txq->next_to_clean;;
+	     clean_idx =3D VNIC_NEXT_IDX(clean_idx, txq->count)) {
+
+		txd =3D TXD_PTR(txq, clean_idx);
+
+		if (GET_VNIC_TX_HANDED(txd) !=3D VNIC_TX_HANDED_HW_W)
+			/* This descriptor has NOT been handed to HW, done! */
+			break;
+
+		if (GET_VNIC_TX_SOP(txd) =3D=3D VNIC_TX_SOP_W) {
+			if (sop_idx !=3D NOT_SET) {
+				/* Problem - SOP back-to-back without EOP */
+				dev_err(&vnicdev->viocdev->pdev->dev,
+				       "vioc%d-vnic%d-txd%d ERROR (back-to-back SOP) (txd->word_1=3D=
%08x).\n",
+				       vnicdev->viocdev->viocdev_idx,
+				       vnicdev->vnic_id, clean_idx,
+				       txd->word_1);
+
+				vnicdev->net_stats.tx_errors++;
+				reset_flag =3D 1;
+				break;
+			}
+			sop_idx =3D clean_idx;
+		}
+
+		if (GET_VNIC_TX_EOP(txd) =3D=3D VNIC_TX_EOP_W) {
+			eop_idx =3D clean_idx;
+			if (sop_idx =3D=3D NOT_SET) {
+				/* Problem - EOP without SOP */
+				dev_err(&vnicdev->viocdev->pdev->dev,
+				       "vioc%d-vnic%d-txd%d ERROR (EOP without SOP)  (txd->word_1=3D=
%08x).\n",
+				       vnicdev->viocdev->viocdev_idx,
+				       vnicdev->vnic_id, clean_idx,
+				       txd->word_1);
+
+				vnicdev->net_stats.tx_errors++;
+				reset_flag =3D 1;
+				break;
+			}
+			if (GET_VNIC_TX_VALID(txd) !=3D VNIC_TX_VALID_W)
+				/* VIOC is still working on this descriptor */
+				break;
+		}
+
+		/*
+		 * Check for errors: regardless of whether an error detected
+		 * on SOP, MOP or EOP descritptor, reset the ring.
+		 */
+		if (GET_VNIC_TX_STS(txd) !=3D VNIC_TX_TX_OK_W) {
+			dev_err(&vnicdev->viocdev->pdev->dev,
+			       "vioc%d-vnic%d TxD ERROR (txd->word_1=3D%08x).\n",
+			       vnicdev->viocdev->viocdev_idx, vnicdev->vnic_id,
+			       txd->word_1);
+
+			vnicdev->net_stats.tx_errors++;
+			reset_flag =3D 1;
+			break;
+		}
+
+		if (eop_idx !=3D NOT_SET) {
+			/* Found EOP fragment: start CLEANING */
+			pkt_len =3D 0;
+			for (clean_idx =3D sop_idx;;
+			     clean_idx =3D VNIC_NEXT_IDX(clean_idx, txq->count)) {
+
+				txd =3D TXD_PTR(txq, clean_idx);
+
+				/* Clear TxD's Handed bit, indicating that SW owns it now */
+				CLR_VNIC_TX_HANDED(txd);
+
+				/* One more empty descriptor */
+				txq->empty++;
+
+				if (txq->vbuf[clean_idx].dma) {
+					pci_unmap_page(vnicdev->viocdev->pdev,
+						       txq->vbuf[clean_idx].dma,
+						       txq->vbuf[clean_idx].
+						       length,
+						       PCI_DMA_TODEVICE);
+					txq->vbuf[clean_idx].dma =3D 0;
+				}
+
+				/* Free skb , should be for SOP (in case of frags) only  */
+				if (txq->vbuf[clean_idx].skb) {
+					dev_kfree_skb_any((struct sk_buff *)
+							  txq->vbuf[clean_idx].
+							  skb);
+					txq->vbuf[clean_idx].skb =3D NULL;
+				}
+
+				pkt_len +=3D txq->vbuf[clean_idx].length;
+
+				if (clean_idx =3D=3D eop_idx)
+					goto set_pkt_stats;
+			}
+
+		      set_pkt_stats:
+			/*
+			 * Since this Tx Descriptor was already
+			 * transmitted, account for it - update stats.
+			 */
+			vnicdev->net_stats.tx_bytes +=3D pkt_len;
+			vnicdev->net_stats.tx_packets++;
+			/*
+			 * This is the ONLY place, where txq->next_to_clean is
+			 * advanced.
+			 * It will point past EOP descriptor of the just cleaned pkt.
+			 */
+			txq->next_to_clean =3D VNIC_NEXT_IDX(eop_idx, txq->count);
+			/*
+			 * Reset sop_idx and eop_idx: start looking for next pkt
+			 */
+			sop_idx =3D eop_idx =3D NOT_SET;
+			/*
+			 * At this point clean_idx =3D=3D eop_idx, it will be advanced
+			 * to the next descriptor at the top of the loop
+			 */
+		}
+	}
+
+	if (reset_flag) {
+		/* For DEBUGGING */
+	}
+
+	/*
+	 * If the queue was stopped, and if we have now enough room -
+	 * wake it up
+	 */
+	if ((netif_queue_stopped(vnicdev->netdev)) &&
+	    !txq->vbuf[txq->next_to_use].skb) {
+		netif_wake_queue(vnicdev->netdev);
+	}
+
+	return reset_flag;
+}
+
+/*
+ * Only called from interrupt context.
+ */
+static void vnic_tx_interrupt(struct vioc_device *viocdev, int vnic_id=
,
+			      int clean)
+{
+	struct vnic_device *vnicdev =3D viocdev->vnic_netdev[vnic_id]->priv;
+	u32 txd_ctl;
+	int txq_was_reset;
+	struct txq *txq;
+	char *txdesc_s =3D "";
+	char *txring_s =3D "";
+
+	txq =3D &vnicdev->txq;
+
+	if (!spin_trylock(&txq->lock)) {
+		/* Retry later */
+		return;
+	}
+
+	/* Get the TxD Control Register */
+	txd_ctl =3D vnic_rd_txd_ctl(txq);
+
+	if (txd_ctl & VREG_VENG_TXD_CTL_ERROR_MASK)
+		txring_s =3D "Tx Ring";
+
+	if (txd_ctl & VREG_VENG_TXD_CTL_INVDESC_MASK)
+		txdesc_s =3D "Tx Descriptor";
+
+	if (txd_ctl &
+	    (VREG_VENG_TXD_CTL_INVDESC_MASK | VREG_VENG_TXD_CTL_ERROR_MASK)) =
{
+		dev_err(&viocdev->pdev->dev,
+		       "vioc%d-vnic%d TxD Ctl=3D%08x, ERROR %s %s. Reset Tx Ring!\n"=
,
+		       viocdev->viocdev_idx, vnic_id, txd_ctl, txdesc_s,
+		       txring_s);
+
+		vnic_reset_txq(vnicdev, txq);
+		netif_wake_queue(vnicdev->netdev);
+	} else {
+		/* No problem with HW, just clean-up the Tx Ring */
+		if (clean)
+			txq_was_reset =3D vnic_clean_txq(vnicdev, txq);
+	}
+
+	if ((txd_ctl & VREG_VENG_TXD_CTL_TXSTATE_MASK) =3D=3D
+	    VVAL_VENG_TXD_CTL_TXSTATE_EMPTY)
+		vnicdev->vnic_stats.tx_on_empty_interrupts++;
+
+	spin_unlock(&txq->lock);
+}
+
+/*
+ * Must only be called from interrupt context.
+ */
+void vioc_tx_interrupt(struct work_struct *work)
+{
+        struct vioc_intreq *input_param=3D container_of(work, struct v=
ioc_intreq,
+				                     taskq);
+	struct vioc_device *viocdev;
+	u32 vioc_idx;
+	u32 vnic_idx;
+	u32 vnic_map;
+
+	vioc_idx =3D VIOC_IRQ_PARAM_VIOC_ID(input_param->intrFuncparm);
+	viocdev =3D vioc_viocdev(vioc_idx);
+	// read_lock(&viocdev->lock); /* protect against vnic changes */
+	vnic_map =3D viocdev->vnics_map;
+	for (vnic_idx =3D 0; vnic_idx < VIOC_MAX_VNICS; vnic_idx++) {
+		if (vnic_map & (1 << vnic_idx))
+			vnic_tx_interrupt(viocdev, vnic_idx, 1);
+	}
+	viocdev->vioc_stats.tx_tasklets++;
+	// read_unlock(&viocdev->lock);
+}
+void vnic_enqueue_tx_pkt(struct vnic_device *vnicdev, struct txq *txq,
+			 struct sk_buff *skb, struct vioc_prov *prov)
+{
+	int idx, sop_idx, eop_idx, f;
+	struct tx_pktBufDesc_Phys_w *txd;
+
+	/*
+	 * Map Tx buffers vbuf queue.
+	 */
+	idx =3D txq->next_to_use;
+	sop_idx =3D idx;
+
+	txq->vbuf[idx].skb =3D skb;
+	txq->vbuf[idx].dma =3D pci_map_single(vnicdev->viocdev->pdev,
+					    skb->data,
+					    skb->len, PCI_DMA_TODEVICE);
+	txq->vbuf[idx].length =3D skb_headlen(skb);
+
+	for (f =3D 0; f < skb_shinfo(skb)->nr_frags; f++) {
+		struct skb_frag_struct *frag;
+
+		frag =3D &skb_shinfo(skb)->frags[f];
+
+		idx =3D VNIC_NEXT_IDX(idx, txq->count);
+
+		txq->vbuf[idx].skb =3D NULL;
+
+		txq->vbuf[idx].dma =3D pci_map_page(vnicdev->viocdev->pdev,
+						  frag->page,
+						  frag->page_offset,
+						  frag->size, PCI_DMA_TODEVICE);
+		txq->vbuf[idx].length =3D frag->size;
+		txq->frags++;
+	}
+
+	eop_idx =3D idx;
+
+	txq->next_to_use =3D VNIC_NEXT_IDX(eop_idx, txq->count);
+
+	if (txq->next_to_use < sop_idx)
+		txq->empty -=3D ((txq->count + txq->next_to_use) - sop_idx);
+	else
+		txq->empty -=3D (txq->next_to_use - sop_idx);
+
+	/*
+	 * We are going backwards (from EOP to SOP) in setting up Tx Descript=
ors.
+	 * (idx =3D=3D eop_ied, when we enter the loop)
+	 * So, by the time we will transfer the SOP Tx Descriptor
+	 * fragment over to VIOC HW, ALL following fragments would have
+	 * been already transferred, and VIOC HW should not have trouble
+	 * picking all of them.
+	 */
+
+	for (;;) {
+		u32 word_1 =3D 0;
+
+		txd =3D TXD_PTR(txq, idx);
+
+		/* Set Tx buffer address */
+		*((dma_addr_t *) txd) =3D txq->vbuf[idx].dma;
+
+		/*
+		 * Force memory writes to complete (FENCE), before letting VIOC know=
,
+		 * that there are new descriptor(s). Do it ONLY for the
+		 * SOP descriptor:  no point "fencing" on every other descriptori
+		 * if, there were frags...
+		 */
+		/* Set SOP */
+		if (idx =3D=3D sop_idx) {
+			word_1 |=3D VNIC_TX_SOP_W;
+			wmb();
+		}
+		/* Set EOP */
+		if (idx =3D=3D eop_idx)
+			word_1 |=3D VNIC_TX_EOP_W;
+
+		/* Set Interrupt request (VNIC_TX_INTR_W), when needed */
+		if (prov->run_param.tx_pkts_per_irq > 0) {
+			if (txq->tx_pkts_til_irq =3D=3D 0) {
+				txq->tx_pkts_til_irq =3D
+				    prov->run_param.tx_pkts_per_irq;
+				word_1 |=3D VNIC_TX_INTR_W;
+			} else {
+				txq->tx_pkts_til_irq--;
+			}
+		}
+
+		/* Now the rest of it */
+		txd->word_1 |=3D word_1 |
+		    VNIC_TX_HANDED_HW_W |
+		    ((txq->vbuf[idx].length << VNIC_TX_BUFLEN_SHIFT) &
+		     VNIC_TX_BUFLEN_MASK);
+
+		if (idx =3D=3D sop_idx)
+			/* All done, if SOP descriptor was just set */
+			break;
+		else
+			/* Go back one more fragment */
+			idx =3D VNIC_PREV_IDX(idx, txq->count);
+	}
+
+	/*
+	 *  Ring bell here, before checking, if vnic_clean_txq() needs to
+	 *  be called.
+	 */
+	vnic_ring_tx_bell(txq);
+
+	if (txq->next_to_use =3D=3D txq->next_to_clean) {
+		txq->wraps++;
+		vnic_clean_txq(vnicdev, txq);
+		if (txq->next_to_use =3D=3D txq->next_to_clean) {
+			txq->full++;
+		}
+	}
+
+}
+
+void vnic_enqueue_tx_buffers(struct vnic_device *vnicdev, struct txq *=
txq,
+			     struct sk_buff *skb, struct vioc_prov *prov)
+{
+	int len;
+	int idx;
+	struct tx_pktBufDesc_Phys_w *txd;
+
+	idx =3D txq->next_to_use;
+	len =3D skb->len;
+
+	txq->vbuf[idx].skb =3D skb;
+	txq->vbuf[idx].dma =3D pci_map_single(vnicdev->viocdev->pdev,
+					    skb->data, len, PCI_DMA_TODEVICE);
+	txq->vbuf[idx].length =3D skb->len;
+
+	/*
+	 * We are going backwards in setting up Tx Descriptors.  So,
+	 * by the time we will trun the Tx Descriptor with the first
+	 * fragment over to VIOC, the following fragments would have
+	 * been already turned over.
+	 */
+	txd =3D TXD_PTR(txq, idx);
+
+	/*
+	 * Force memory writes to complete, before letting VIOC know,
+	 * that there are new descriptor(s), but do it ONLY for the
+	 * very first descriptor (in case there were frags). No point
+	 * "fencing" on every descriptor in this request.
+	 */
+	wmb();
+
+	*((dma_addr_t *) txd) =3D txq->vbuf[idx].dma;
+
+	if (prov->run_param.tx_pkts_per_irq > 0) {
+		if (txq->tx_pkts_til_irq =3D=3D 0) {
+			txq->tx_pkts_til_irq =3D prov->run_param.tx_pkts_per_irq;
+			/* Set Interrupt request: VNIC_TX_INTR_W */
+			txd->word_1 |=3D
+			    (VNIC_TX_HANDED_HW_W | VNIC_TX_SOP_W | VNIC_TX_EOP_W
+			     | VNIC_TX_INTR_W | ((len << VNIC_TX_BUFLEN_SHIFT) &
+						 VNIC_TX_BUFLEN_MASK));
+		} else {
+			/* Set NO Interrupt request... */
+			txd->word_1 |=3D
+			    (VNIC_TX_HANDED_HW_W | VNIC_TX_SOP_W | VNIC_TX_EOP_W
+			     | ((len << VNIC_TX_BUFLEN_SHIFT) &
+				VNIC_TX_BUFLEN_MASK));
+			txq->tx_pkts_til_irq--;
+		}
+	} else {
+		/* Set NO Interrupt request... */
+		txd->word_1 |=3D
+		    (VNIC_TX_HANDED_HW_W | VNIC_TX_SOP_W | VNIC_TX_EOP_W |
+		     ((len << VNIC_TX_BUFLEN_SHIFT) & VNIC_TX_BUFLEN_MASK));
+	}
+
+	/*
+	 *  Ring bell here, before checking, if vnic_clean_txq() needs to
+	 *  be called.
+	 */
+	vnic_ring_tx_bell(txq);
+
+	idx =3D VNIC_NEXT_IDX(idx, txq->count);
+	if (idx =3D=3D txq->next_to_clean) {
+		txq->wraps++;
+		vnic_clean_txq(vnicdev, txq);
+		if (idx =3D=3D txq->next_to_clean) {
+			txq->full++;
+		}
+	}
+
+	txq->next_to_use =3D idx;
+}
+
+static inline void init_f7_header(struct sk_buff *skb)
+{
+	struct vioc_f7pf_w *f7p;
+	unsigned char tag;
+
+	/*
+	 * Initialize F7 Header AFTER processing the skb + frags, because we
+	 * need the TOTAL pkt length in the F7 Header.
+	 */
+
+	/* Determine packet tag */
+	if (((struct ethhdr *)skb->mac.raw)->h_proto =3D=3D ntohs(ETH_P_IP)) =
{
+		if (skb->ip_summed =3D=3D VIOC_CSUM_OFFLOAD) {
+			switch (skb->nh.iph->protocol) {
+			case IPPROTO_TCP:
+				tag =3D VIOC_F7PF_ET_ETH_IPV4_CKS;
+				skb->h.th->check =3D 0;
+				break;
+			case IPPROTO_UDP:
+				tag =3D VIOC_F7PF_ET_ETH_IPV4_CKS;
+				skb->h.uh->check =3D 0;
+				break;
+			default:
+				tag =3D VIOC_F7PF_ET_ETH_IPV4;
+				break;
+			}
+		} else {
+			tag =3D VIOC_F7PF_ET_ETH_IPV4;
+		}
+	} else {
+		tag =3D VIOC_F7PF_ET_ETH;
+	}
+
+	f7p =3D (struct vioc_f7pf_w *)skb->data;
+	memset((void *)skb->data, 0, F7PF_HLEN_STD);
+
+	/* Encapsulation Version */
+	SET_HTON_VIOC_F7PF_ENVER_SHIFTED(f7p, VIOC_F7PF_VERSION1);
+	/* Reserved */
+	SET_HTON_VIOC_F7PF_MC_SHIFTED(f7p, 0);
+	/* No Touch Flag */
+	SET_HTON_VIOC_F7PF_NOTOUCH_SHIFTED(f7p, 0);
+	/* Drop Precedence */
+	SET_HTON_VIOC_F7PF_F7DP_SHIFTED(f7p, 0);
+	/* Class of Service */
+	SET_HTON_VIOC_F7PF_F7COS_SHIFTED(f7p, 2);
+	/* Encapsulation Tag */
+	SET_HTON_VIOC_F7PF_ENTAG_SHIFTED(f7p, tag);
+	/* Key Length */
+	SET_HTON_VIOC_F7PF_EKLEN_SHIFTED(f7p, 1);
+	/* Packet Length */
+	SET_HTON_VIOC_F7PF_PKTLEN_SHIFTED(f7p, skb->len);
+
+	/* lifID */
+	SET_HTON_VIOC_F7PF_LIFID_SHIFTED(f7p, 0);
+}
+
+/**
+ * vioc_tx_timer - Tx Timer
+ * @data: pointer to viocdev cast into an unsigned long
+ **/
+void vioc_tx_timer(unsigned long data)
+{
+	struct vioc_device *viocdev =3D (struct vioc_device *)data;
+	u32 vnic_idx;
+
+	if (!viocdev->tx_timer_active)
+		return;
+
+	viocdev->vioc_stats.tx_timers++;
+
+	for (vnic_idx =3D 0; vnic_idx < VIOC_MAX_VNICS; vnic_idx++) {
+		if (viocdev->vnics_map & (1 << vnic_idx)) {
+			vnic_tx_interrupt(viocdev, vnic_idx, 1);
+		}		/* Process VNIC's TX interrupt */
+	}
+	/* Reset the timer */
+	mod_timer(&viocdev->tx_timer, jiffies + HZ / 4);
+}
+
+
+/*
+ * hard_start_xmit() routine.
+ * NOTE WELL: We don't take a read lock on the VIOC, but rely on the
+ * networking subsystem to guarantee we will not be asked to Tx if
+ * the interface is unregistered.  Revisit if this assumption does
+ * not hold - add a tx_enabled flag to the vnic struct protected
+ * by txq->lock.  Or just read-lock the VIOC.
+ */
+int vnic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	struct txq *txq =3D &vnicdev->txq;
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	if (!spin_trylock(&txq->lock)) {
+		/* Retry later */
+		local_irq_restore(flags);
+		return NETDEV_TX_LOCKED;
+	}
+
+	if (unlikely(skb_headroom(skb) < F7PF_HLEN_STD)) {
+		vnicdev->vnic_stats.headroom_misses++;
+		if (unlikely(skb_cow(skb, F7PF_HLEN_STD))) {
+			dev_kfree_skb_any(skb);
+			vnicdev->vnic_stats.headroom_miss_drops++;
+			ret =3D NETDEV_TX_OK;	/* since we freed it */
+			goto end_start_xmit;
+		}
+	}
+
+	/* Don't rely on the skb pointers being set */
+	skb->mac.raw =3D skb->data;
+	skb->nh.raw =3D skb->data + ETH_HLEN;
+	skb_push(skb, F7PF_HLEN_STD);
+
+	init_f7_header(skb);
+
+	if (skb_shinfo(skb)->nr_frags)
+		vnic_enqueue_tx_pkt(vnicdev, txq, skb, &vnicdev->viocdev->prov);
+	else
+		vnic_enqueue_tx_buffers(vnicdev, txq, skb,
+					&vnicdev->viocdev->prov);
+
+	/*
+	 * Check if there is room on the queue.
+	 */
+	if (txq->empty < MAX_SKB_FRAGS) {
+		netif_stop_queue(netdev);
+		vnicdev->vnic_stats.netif_stops++;
+		ret =3D NETDEV_TX_BUSY;
+	} else {
+		ret =3D NETDEV_TX_OK;
+	}
+
+      end_start_xmit:
+	spin_unlock_irqrestore(&txq->lock, flags);
+	return ret;
+}
+
+/*
+ *      Create Ethernet header
+ *
+ *      saddr=3DNULL      means use device source address
+ *      daddr=3DNULL      means leave destination address (eg unresolv=
ed arp)
+ */
+int vnic_eth_header(struct sk_buff *skb, struct net_device *dev,
+		    unsigned short type, void *daddr, void *saddr, unsigned len)
+{
+	struct ethhdr *eth =3D (struct ethhdr *)skb_push(skb, ETH_HLEN);
+
+	skb->mac.raw =3D skb->data;
+
+	/*
+	 *      Set the protocol type. For a packet of type
+	 *      ETH_P_802_3 we put the length in here instead. It is
+	 *      up to the 802.2 layer to carry protocol information.
+	 */
+
+	if (type !=3D ETH_P_802_3)
+		eth->h_proto =3D htons(type);
+	else
+		eth->h_proto =3D htons(len);
+
+	if (saddr)
+		memcpy(eth->h_source, saddr, ETH_ALEN);
+	else
+		memcpy(eth->h_source, dev->dev_addr, ETH_ALEN);
+
+	if (dev->flags & (IFF_LOOPBACK | IFF_NOARP)) {
+		memset(eth->h_dest, 0, ETH_ALEN);
+		return ETH_HLEN + F7PF_HLEN_STD;
+	}
+
+	if (daddr) {
+		memcpy(eth->h_dest, daddr, ETH_ALEN);
+		return ETH_HLEN + F7PF_HLEN_STD;
+	}
+
+	return -(ETH_HLEN + F7PF_HLEN_STD);	/* XXX */
+}
+
+
+
+/**
+ * vnic_open - Called when a network interface is made active
+ * @netdev: network interface device structure
+ *
+ * Returns 0 on success, negative value on failure
+ *
+ * The open entry point is called when a network interface is made
+ * active by the system (IFF_UP).  At this point all resources needed
+ * for transmit and receive operations are allocated, the interrupt
+ * handler is registered with the OS, the watchdog timer is started,
+ * and the stack is notified that the interface is ready.
+ **/
+
+static int vnic_open(struct net_device *netdev)
+{
+	int ret =3D 0;
+	struct vnic_device *vnicdev =3D netdev->priv;
+
+	ret =3D vioc_set_vnic_cfg(vnicdev->viocdev->viocdev_idx,
+				vnicdev->vnic_id,
+				(VREG_BMC_VNIC_CFG_ENABLE_MASK |
+				 VREG_BMC_VNIC_CFG_PROMISCUOUS_MASK));
+
+	vnic_enable_tx_ring(&vnicdev->txq);
+
+	netif_start_queue(netdev);
+	netif_carrier_on(netdev);
+
+	return ret;
+}
+
+static int vnic_close(struct net_device *netdev)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	struct txq *txq =3D &vnicdev->txq;
+	unsigned long flags;
+
+	vioc_set_vnic_cfg(vnicdev->viocdev->viocdev_idx, vnicdev->vnic_id, 0)=
;
+
+	netif_carrier_off(netdev);
+	netif_stop_queue(netdev);
+
+	spin_lock_irqsave(&txq->lock, flags);
+
+	vnic_reset_txq(vnicdev, txq);
+	vnic_disable_tx_ring(&vnicdev->txq);
+
+	spin_unlock_irqrestore(&txq->lock, flags);
+
+	return 0;
+}
+
+/*
+ * Set netdev->dev_addr to this interface's MAC Address
+ */
+static int vnic_set_mac_addr(struct net_device *netdev, void *p)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+
+	/*
+	 * Get HW MAC address form VIOC egisters
+	 */
+	vioc_get_vnic_mac(vnicdev->viocdev->viocdev_idx, vnicdev->vnic_id,
+			  &vnicdev->hw_mac[0]);
+
+	if (!is_valid_ether_addr(vnicdev->hw_mac)) {
+		dev_err(&vnicdev->viocdev->pdev->dev, "Invalid MAC Address\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * ...and install it in nedev structure
+	 */
+	memcpy(netdev->dev_addr, vnicdev->hw_mac, netdev->addr_len);
+	netdev->addr_len =3D ETH_ALEN;
+
+	return 0;
+}
+
+/*
+ * Set netdev->mtu to this interface's MTU
+ */
+static int vnic_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	int max_frame =3D new_mtu + ETH_HLEN + F7PF_HLEN_STD;
+
+	if ((max_frame < VNIC_MIN_MTU) || (max_frame > VNIC_MAX_MTU)) {
+		dev_err(&vnicdev->viocdev->pdev->dev, "Invalid MTU setting\n");
+		return -EINVAL;
+	}
+
+	netdev->mtu =3D new_mtu;
+	return 0;
+}
+
+/**
+ * vnic_get_stats - Get System Network Statistics
+ * @netdev: network interface device structure
+ *
+ * Returns the address of the device statistics structure.
+ * The statistics are actually updated from the timer callback.
+ **/
+
+static struct net_device_stats *vnic_get_stats(struct net_device *netd=
ev)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	return &vnicdev->net_stats;
+}
+
+static int vnic_alloc_tx_resources(struct vnic_device *vnicdev)
+{
+	struct vioc_device *viocdev =3D vnicdev->viocdev;
+	struct net_device *netdev =3D viocdev->vnic_netdev[vnicdev->vnic_id];
+	struct txq *txq;
+	size_t size;
+
+	vnicdev->vnic_stats.tx_on_empty_interrupts =3D 0;
+
+	txq =3D &vnicdev->txq;
+
+	txq->txq_id =3D TXQ0;
+	txq->vnic_id =3D vnicdev->vnic_id;
+	txq->next_to_use =3D 0;
+	txq->next_to_clean =3D 0;
+	txq->empty =3D txq->count;
+	txq->tx_pkts_til_irq =3D viocdev->prov.run_param.tx_pkts_per_irq;
+	txq->tx_pkts_til_bell =3D viocdev->prov.run_param.tx_pkts_per_bell;
+	txq->do_ring_bell =3D 0;
+	txq->bells =3D 0;
+	txq->frags =3D 0;
+	txq->wraps =3D 0;
+	txq->full =3D 0;
+
+	size =3D TX_DESC_SIZE * txq->count;
+	txq->desc =3D pci_alloc_consistent(viocdev->pdev, size, &txq->dma);
+	if (!txq->desc) {
+		dev_err(&viocdev->pdev->dev, "%sError allocating Tx ring (size %d)\n=
",
+		       netdev->name, txq->count);
+		return -ENOMEM;
+	}
+
+	txq->vbuf =3D vmalloc(sizeof(struct vbuf) * txq->count);
+	if (!txq->vbuf) {
+		dev_err(&viocdev->pdev->dev, "%sError allocating Tx resource (size %=
d)\n",
+		       netdev->name, txq->count);
+		return -ENOMEM;
+	}
+	memset(txq->vbuf, 0, sizeof(struct vbuf) * txq->count);
+
+	txq->va_of_vreg_veng_txd_ctl =3D
+	    (&viocdev->ba)->virt +
+	    GETRELADDR(VIOC_VENG, vnicdev->vnic_id,
+		       (VREG_VENG_TXD_CTL + (TXQ0 * 0x14)));
+	spin_lock_init(&txq->lock);
+
+	/*
+	 * Tell VIOC where TxQ things are
+	 */
+	vioc_set_txq(viocdev->viocdev_idx, vnicdev->vnic_id, TXQ0,
+		     txq->dma, txq->count);
+	vnic_enable_tx_ring(txq);
+	vioc_ena_dis_tx_on_empty(viocdev->viocdev_idx,
+				 vnicdev->vnic_id,
+				 TXQ0,
+				 viocdev->prov.run_param.tx_intr_on_empty);
+	return 0;
+}
+
+static void vnic_free_tx_resources(struct vnic_device *vnicdev)
+{
+	pci_free_consistent(vnicdev->viocdev->pdev,
+			    vnicdev->txq.count * TX_DESC_SIZE,
+			    vnicdev->txq.desc, vnicdev->txq.dma);
+	vnicdev->txq.desc =3D NULL;
+	vnicdev->txq.dma =3D (dma_addr_t) NULL;
+	vfree(vnicdev->txq.vbuf);
+	vnicdev->txq.vbuf =3D NULL;
+}
+
+void vioc_reset_if_tx(struct net_device *netdev)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	struct txq *txq =3D &vnicdev->txq;
+
+	vnic_reset_txq(vnicdev, txq);
+}
+
+extern struct ethtool_ops vioc_ethtool_ops;
+
+/**
+ * vnic_uninit - Device Termination Routine
+ *
+ * Returns 0 on success, negative on failure
+ *
+ **/
+static void vnic_uninit(struct net_device *netdev)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	vnic_free_tx_resources(vnicdev);
+}
+
+/**
+ * vnic_init - Device Initialization Routine
+ *
+ * Returns 0 on success, negative on failure
+ *
+ **/
+int vioc_vnic_init(struct net_device *netdev)
+{
+	struct vnic_device *vnicdev =3D netdev->priv;
+	struct vioc_device *viocdev =3D vnicdev->viocdev;
+	int ret;
+
+	SET_ETHTOOL_OPS(netdev, &vioc_ethtool_ops);
+	/*
+	 * we're going to reset, so assume we have no link for now
+	 */
+	netif_carrier_off(netdev);
+	netif_stop_queue(netdev);
+
+	ether_setup(netdev);
+
+	netdev->hard_header_len =3D ETH_HLEN + F7PF_HLEN_STD;	/* XXX */
+	netdev->hard_header =3D &vnic_eth_header;
+	netdev->rebuild_header =3D NULL;	/* XXX */
+
+	vnic_change_mtu(netdev, 1500);	/* default */
+	vnic_set_mac_addr(netdev, NULL);
+
+	netdev->open =3D &vnic_open;
+	netdev->stop =3D &vnic_close;
+	netdev->get_stats =3D &vnic_get_stats;
+	netdev->uninit =3D &vnic_uninit;
+	netdev->set_mac_address =3D &vnic_set_mac_addr;
+	netdev->change_mtu =3D &vnic_change_mtu;
+	netdev->watchdog_timeo =3D HZ;
+	if (viocdev->highdma) {
+		netdev->features |=3D NETIF_F_HIGHDMA;
+	}
+	netdev->features |=3D NETIF_F_VLAN_CHALLENGED;	/* VLAN locked */
+	netdev->features |=3D NETIF_F_LLTX;	/* lockless Tx */
+
+	netdev->features |=3D NETIF_F_IP_CSUM;	/* Tx checksum */
+	dev_err(&viocdev->pdev->dev, "%s: HW IP checksum offload ENABLED\n", =
netdev->name);
+
+	/* allocate Tx descriptors, tell VIOC where */
+	if ((ret =3D vnic_alloc_tx_resources(vnicdev)))
+		goto vnic_init_err;
+
+	netdev->hard_start_xmit =3D &vnic_start_xmit;
+	/* Set standard  Rx callback */
+
+	return 0;
+
+      vnic_init_err:
+	dev_err(&viocdev->pdev->dev, "%s: Error initializing vnic resources\n=
",
+	       netdev->name);
+	return ret;
+}
diff -puN /dev/null drivers/net/vioc/vioc_vnic.h
--- /dev/null
+++ a/drivers/net/vioc/vioc_vnic.h
@@ -0,0 +1,515 @@
+/*
+ * Fabric7 Systems Virtual IO Controller Driver
+ * Copyright (C) 2003-2006 Fabric7 Systems.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
+ * USA
+ *
+ * http://www.fabric7.com/
+ *
+ * Maintainers:
+ *    driver-support@fabric7.com
+ *
+ *
+ */
+#ifndef _VIOC_VNIC_H
+#define _VIOC_VNIC_H
+
+#include <linux/netdevice.h>
+#include <linux/if_ether.h>
+#include <linux/pci.h>
+
+#include "f7/vnic_defs.h"
+#include "f7/vioc_hw_registers.h"
+#include "f7/vioc_pkts_defs.h"
+
+/*
+ * VIOC PCI constants
+ */
+#define PCI_VENDOR_ID_FABRIC7  0xfab7
+#define PCI_DEVICE_ID_VIOC_1   0x0001
+#define PCI_DEVICE_ID_VIOC_8   0x0008
+#define PCI_DEVICE_ID_IOAPIC   0x7459
+
+#define VIOC_DRV_MODULE_NAME	"vioc"
+
+#define F7PF_HLEN_MIN   8	/* Minimal (kl=3D0) header */
+#define F7PF_HLEN_STD   10	/* Standard (kl=3D1) header */
+
+#define VNIC_MAX_MTU   9180
+#define VNIC_STD_MTU   1500
+
+/* VIOC device constants */
+#define VIOC_MAX_RXDQ		16
+#define VIOC_MAX_RXCQ		16
+#define VIOC_MAX_RXQ		4
+#define VIOC_MAX_TXQ		4
+#define VIOC_NAME_LEN		16
+
+/*
+ * VIOC device state
+ */
+
+#define VIOC_STATE_INIT                0
+#define VIOC_STATE_UP          (VIOC_STATE_INIT + 1)
+
+#define RX_DESC_SIZE   sizeof (struct rx_pktBufDesc_Phys_w)
+#define RX_DESC_QUANT  (4096/RX_DESC_SIZE)
+
+#define RXC_DESC_SIZE  sizeof (struct rxc_pktDesc_Phys_w)
+#define RXC_DESC_QUANT (4096/RXC_DESC_SIZE)
+
+#define TX_DESC_SIZE   sizeof (struct tx_pktBufDesc_Phys_w)
+#define TX_DESC_QUANT  (4096/TX_DESC_SIZE)
+
+#define RXS_DESC_SIZE  sizeof (struct rxc_pktStatusBlock_w)
+
+#define VIOC_COPYOUT_THRESHOLD	128
+#define VIOC_RXD_BATCH_BITS		32
+#define ALL_BATCH_SW_OWNED		0
+#define ALL_BATCH_HW_OWNED		0xffffffff
+
+#define VIOC_ANY_VNIC			0
+#define VIOC_NONE_TO_HW			(u32) -1
+
+/*
+ * Status of the Rx operation as reflected in Rx Completion Descriptor
+ */
+#define GET_VNIC_RXC_STATUS(rxcd)      (\
+       GET_VNIC_RXC_BADCRC(rxcd) |\
+       GET_VNIC_RXC_BADLENGTH(rxcd) |\
+       GET_VNIC_RXC_BADSMPARITY(rxcd) |\
+       GET_VNIC_RXC_PKTABORT(rxcd)\
+       )
+#define VNIC_RXC_STATUS_OK_W           0
+
+#define VNIC_RXC_STATUS_MASK (\
+               VNIC_RXC_ISBADLENGTH_W | \
+               VNIC_RXC_ISBADCRC_W | \
+               VNIC_RXC_ISBADSMPARITY_W | \
+               VNIC_RXC_ISPKTABORT_W \
+       )
+
+#define VIOC_IRQ_PARAM_VIOC_ID(param)  \
+       (int) (((u64) param >> 28) & 0xf)
+#define VIOC_IRQ_PARAM_INTR_ID(param)  \
+       (int) ((u64) param & 0xffff)
+#define VIOC_IRQ_PARAM_PARAM_ID(param) \
+       (int) (((u64) param >> 16) & 0xff)
+
+#define VIOC_IRQ_PARAM_SET(vioc, intr, param) \
+               ((((u64) vioc & 0xf) << 28) | \
+               (((u64) param & 0xff) << 16) | \
+               ((u64) intr & 0xffff))
+/*
+ * Return status codes
+ */
+#define E_VIOCOK       0
+#define E_VIOCMAX      1
+#define E_VIOCINTERNAL 2
+#define E_VIOCNETREGERR 3
+#define E_VIOCPARMERR  4
+#define E_VIOCNOOP     5
+#define E_VIOCTXFULL   6
+#define E_VIOCIFNOTFOUND 7
+#define E_VIOCMALLOCERR 8
+#define E_VIOCORDERR   9
+#define E_VIOCHWACCESS 10
+#define E_VIOCHWNOTREADY 11
+#define E_ALLOCERR     12
+#define E_VIOCRXHW     13
+#define E_VIOCRXCEMPTY 14
+
+/*
+ * From the HW statnd point, every VNIC has 4 RxQ - receive queues.
+ * Every RxQ is mapped to RxDQ (a ring with buffers for Rx Packets)
+ * and RxC queue (a ring with descriptors that reflect the status of t=
he receive.
+ * I.e. when VIOC receives the packet on any of the 4 RxQ, it would us=
e the mapping to determine where
+ * to get buffer for the packet (RxDQ) and where to post the result of=
 the operation (RxC).
+ */
+
+struct rxd_q_prov {
+	u32 buf_size;
+	u32 entries;
+	u8 id;
+	u8 state;
+};
+
+struct vnic_prov_def {
+	struct rxd_q_prov rxd_ring[4];
+	u32 tx_entries;
+	u32 rxc_entries;
+	u8 rxc_id;
+	u8 rxc_intr_id;
+};
+
+struct vioc_run_param {
+	u32 rx_intr_timeout;
+	u32 rx_intr_cntout;
+	u32 rx_wdog_timeout;
+	u32 tx_pkts_per_bell;
+	u32 tx_pkts_per_irq;
+	int tx_intr_on_empty;
+};
+
+struct vioc_prov {
+	struct vnic_prov_def **vnic_prov_p;
+	struct vioc_run_param run_param;
+};
+
+struct vioc_irq {
+	int irq;
+	void *dev_id;
+};
+
+/*
+ * Wrapper around a pointer to a socket buffer
+ */
+struct vbuf {
+	volatile struct sk_buff *skb;
+	volatile dma_addr_t dma;
+	volatile u32 length;
+	volatile u32 special;
+	volatile unsigned long time_stamp;
+};
+
+struct rxc;
+
+/* Receive Completion set - RxC + NAPI device */
+struct napi_poll {
+	volatile u8 enabled;	/* if 0, Rx resource are not available */
+	volatile u8 stopped;	/* if 1, NAPI has stopped servicing set */
+	struct net_device poll_dev;	/* for NAPI */
+	u64 rx_interrupts;	/* Number of Rx Interrupts for VIOC stats */
+	struct rxc *rxc;
+};
+
+/* Rx Completion Queue */
+struct rxc {
+	u8 rxc_id;
+	u8 interrupt_id;
+	spinlock_t lock;
+	struct rxc_pktDesc_Phys_w *desc;
+	dma_addr_t dma;
+	u32 count;
+	u32 sw_idx;
+	u32 quota;
+	u32 budget;
+	void __iomem *va_of_vreg_ihcu_rxcintpktcnt;
+	void __iomem *va_of_vreg_ihcu_rxcinttimer;
+	void __iomem *va_of_vreg_ihcu_rxcintctl;
+	struct vioc_device *viocdev;
+	struct napi_poll napi;
+};
+
+/* Rx Descriptor Queue */
+struct rxdq {
+	u8 rxdq_id;
+	/* pointer to the Rx Buffer descriptor queue memory */
+	struct rx_pktBufDesc_Phys_w *desc;
+	dma_addr_t dma;
+	struct vbuf *vbuf;
+	u32 count;
+	u16 rx_buf_size;
+	/* A bit map of descriptors: 0 - owned by SW, 1 - owned by HW */
+	u32 *dmap;
+	u32 dmap_count;
+	/* dmap_idx is needed for proc fs */
+	u32 dmap_idx;
+	/* Descriptor desginated as a "fence", i.e. owned by SW. */
+	volatile u32 fence;
+	/* A counter that, when expires, forces a call to vioc_next_fence_run=
() */
+	volatile u32 skip_fence_run;
+	volatile u32 run_to_end;
+	volatile u32 to_hw;
+	volatile u32 starvations;
+	u32 prev_rxd_id;
+	u32 err_cnt;
+	u32 reset_cnt;
+	struct vioc_device *viocdev;
+};
+
+/* Tx Buffer Descriptor queue */
+struct txq {
+	u8 txq_id;		/* always TXQ0 for now */
+	u8 vnic_id;
+
+	spinlock_t lock;	/* interrupt-safe */
+	/*
+	 * Shadow of the TxD Control Register, keep it here, so we do
+	 * not have to read from HW
+	 */
+	u32 shadow_VREG_VENG_TXD_CTL;
+	/*
+	 * Address of the TxD Control Register when we ring the
+	 * bell. Keep this always ready, for expediency.
+	 */
+	void __iomem *va_of_vreg_veng_txd_ctl;
+	/*
+	 * pointer to the Tx Buffer Descriptor queue memory
+	 */
+	struct tx_pktBufDesc_Phys_w *desc;
+	dma_addr_t dma;
+	struct vbuf *vbuf;
+	u32 count;
+	u32 tx_pkts_til_irq;
+	u32 tx_pkts_til_bell;
+	u32 bells;
+	int do_ring_bell;
+	/* next descriptor to use for Tx */
+	volatile u32 next_to_use;
+	/* next descriptor to check completion of Tx */
+	volatile u32 next_to_clean;
+	/* Frags count */
+	volatile u32 frags;
+	/* Empty Tx descriptor slots */
+	volatile u32 empty;
+	u32 wraps;
+	u32 full;
+};
+
+/*  Rx Completion Status Block */
+struct rxs {
+	struct rxc_pktStatusBlock_w *block;
+	dma_addr_t dma;
+};
+
+typedef enum { RX_WDOG_DISABLED, RX_WDOG_EXPECT_PKT,
+	RX_WDOG_EXPECT_WDOGPKT
+} wdog_state_t;
+
+struct vioc_device_stats {
+	u64 tx_tasklets;	/* Number of Tx Interrupts */
+	u64 tx_timers;		/* Number of Tx watchdog timers */
+};
+
+#define        NETIF_STOP_Q    0xdead
+#define NETIF_START_Q  0xfeed
+
+struct vnic_device_stats {
+	u64 rx_fragment_errors;
+	u64 rx_dropped;
+	u64 skb_enqueued;	/* Total number of skb's enqueued */
+	u64 skb_freed;		/* Total number of skb's freed */
+	u32 netif_stops;	/* Number of times Tx was stopped */
+	u32 netif_last;		/* Last netif_  command */
+	u64 tx_on_empty_interrupts;	/* Number of Tx Empty Interrupts */
+	u32 headroom_misses;	/* Number of headroom misses */
+	u32 headroom_miss_drops;	/* Number of headroom misses */
+};
+
+struct vioc_ba {
+       void __iomem *virt;
+       unsigned long long phy;
+       unsigned long len;
+};
+
+struct vioc_device {
+	char name[VIOC_NAME_LEN];
+	u32 vioc_bits_version;
+	u32 vioc_bits_subversion;
+
+	u8 viocdev_idx;
+	u8 vioc_state;		/* Initialization state */
+	u8 mgmt_state;		/*  Management state */
+	u8 highdma;
+
+	u32 vnics_map;
+	u32 vnics_admin_map;
+	u32 vnics_link_map;
+
+	struct vioc_ba ba;	/* VIOC PCI Dev Base Address: virtual and phy */
+	struct vioc_ba ioapic_ba;	/* VIOC's IOAPIC Base Address: virtual and =
phy */
+	struct pci_dev *pdev;
+
+	/*
+	 * An array of pointers to net_device structures for
+	 * every subordinate VNIC
+	 */
+	struct net_device *vnic_netdev[VIOC_MAX_VNICS];
+	/*
+	 * An array describing all Rx Completion Descriptor Queues in VIOC
+	 */
+	struct rxc *rxc_p[VIOC_MAX_RXCQ];
+	struct rxc rxc_buf[VIOC_MAX_RXCQ];
+	/*
+	 * An array describing all Rx Descriptor Queues in VIOC
+	 */
+	struct rxdq *rxd_p[VIOC_MAX_RXDQ];
+	struct rxdq rxd_buf[VIOC_MAX_RXDQ];
+
+	/* Rx Completion Status Block */
+	struct rxs rxcstat;
+
+	/* ----- SIM SPECIFIC ------ */
+	/* * Round-robbin over Rx Completion queues */
+	u32 next_rxc_to_use;
+	/* Round-robbin over RxDQs, when checking them out */
+	u32 next_rxdq_to_use;
+
+	struct vioc_prov prov;	/* VIOC provisioning info */
+	struct vioc_device_stats vioc_stats;
+
+	struct timer_list bmc_wd_timer;
+	int bmc_wd_timer_active;
+
+	struct timer_list tx_timer;
+	int tx_timer_active;
+
+	u32 num_rx_irqs;
+	u32 num_irqs;
+	u32 last_msg_to_sim;
+};
+
+#define VIOC_BMC_INTR0 (1 << 0)
+#define VIOC_BMC_INTR1 (1 << 1)
+#define VIOC_BMC_INTR2 (1 << 2)
+#define VIOC_BMC_INTR3 (1 << 3)
+#define VIOC_BMC_INTR4 (1 << 4)
+#define VIOC_BMC_INTR5 (1 << 5)
+#define VIOC_BMC_INTR6 (1 << 6)
+#define VIOC_BMC_INTR7 (1 << 7)
+#define VIOC_BMC_INTR8 (1 << 8)
+#define VIOC_BMC_INTR9 (1 << 9)
+#define VIOC_BMC_INTR10        (1 << 10)
+#define VIOC_BMC_INTR11        (1 << 11)
+#define VIOC_BMC_INTR12        (1 << 12)
+#define VIOC_BMC_INTR13        (1 << 13)
+#define VIOC_BMC_INTR14        (1 << 14)
+#define VIOC_BMC_INTR15        (1 << 15)
+#define VIOC_BMC_INTR16        (1 << 16)
+#define VIOC_BMC_INTR17        (1 << 17)
+
+#define VNIC_NEXT_IDX(i, count) ((count =3D=3D 0) ? 0: (((i) + 1) % (c=
ount)))
+#define VNIC_PREV_IDX(i, count) ((count =3D=3D 0) ? 0: ((((i) =3D=3D 0=
) ? ((count) - 1): ((i) - 1))))
+
+#define VNIC_RING_BELL(vnic, q_idx) vnic_ring_bell(vnic, q_idx)
+
+#define TXDS_REQUIRED(skb) 1
+
+#define TXD_WATER_MARK                 8
+
+#define GET_DESC_PTR(R, i, type) (&(((struct type *)((R)->desc))[i]))
+#define RXD_PTR(R, i)          GET_DESC_PTR(R, i, rx_pktBufDesc_Phys_w=
)
+#define TXD_PTR(R, i)          GET_DESC_PTR(R, i, tx_pktBufDesc_Phys_w=
)
+#define RXC_PTR(R, i)          GET_DESC_PTR(R, i, rxc_pktBufDesc_Phys_=
w)
+
+/* Receive packet fragments */
+
+/* VNIC DEVICE */
+struct vnic_device {
+	u8 vnic_id;
+	u8 rxc_id;
+	u8 rxc_intr_id;
+
+	u32 qmap;		/* VNIC rx queues mappings */
+	u32 vnic_q_en;		/* VNIC queues enables */
+
+	struct txq txq;
+	struct vioc_device *viocdev;
+	struct net_device *netdev;
+	struct net_device_stats net_stats;
+	struct vnic_device_stats vnic_stats;
+
+	u8 hw_mac[ETH_ALEN];
+};
+
+struct vioc_intreq {
+	char name[VIOC_NAME_LEN];
+	void (*intrFuncp) (struct work_struct *work);
+	void *intrFuncparm;
+	irqreturn_t(*hthandler) (int, void *);
+	unsigned int irq;
+	unsigned int vec;
+	unsigned int intr_base;
+	unsigned int intr_offset;
+	unsigned int timeout_value;
+	unsigned int pkt_counter;
+	unsigned int rxc_mask;
+	struct work_struct taskq;
+	struct tasklet_struct tasklet;
+};
+
+
+/* vioc_transmit.c */
+extern int vioc_vnic_init(struct net_device *);
+extern void vioc_tx_timer(unsigned long data);
+
+/* vioc_driver.c */
+extern struct vioc_device *vioc_viocdev(u32 vioc_id);
+extern struct net_device *vioc_alloc_vnicdev(struct vioc_device *, int=
);
+
+/* vioc_irq.c */
+extern int vioc_irq_init(void);
+extern void vioc_irq_exit(void);
+extern void vioc_free_irqs(u32 viocdev_idx);
+extern int vioc_request_irqs(u32 viocdev_idx);
+
+extern int vioc_set_intr_func_param(int viocdev_idx, int intr_idx,
+				    int intr_param);
+
+extern void vioc_rxc_interrupt(struct work_struct *work);
+extern void vioc_tx_interrupt(struct work_struct *work);
+extern void vioc_bmc_interrupt(struct work_struct *work);
+
+/* vioc_receive.c */
+extern int vioc_rx_poll(struct net_device *dev, int *budget);
+extern int vioc_next_fence_run(struct rxdq *);
+
+/* spp.c */
+extern int spp_init(void);
+extern void spp_terminate(void);
+extern void spp_msg_from_sim(int);
+
+/* spp_vnic.c */
+extern int spp_vnic_init(void);
+extern void spp_vnic_exit(void);
+
+/* vioc_spp.c */
+extern void vioc_vnic_prov(int, u32, u32, int);
+extern struct vnic_prov_def **vioc_prov_get(int);
+extern void vioc_hb_to_bmc(int vioc_id);
+extern int vioc_handle_reset_request(int);
+extern void vioc_os_reset_notifier_exit(void);
+extern void vioc_os_reset_notifier_init(void);
+
+
+
+static inline void vioc_rxc_interrupt_disable(struct rxc *rxc)
+{
+	writel(3, rxc->va_of_vreg_ihcu_rxcintctl);
+}
+
+static inline void vioc_rxc_interrupt_enable(struct rxc *rxc)
+{
+	writel(0, rxc->va_of_vreg_ihcu_rxcintctl);
+}
+
+static inline void vioc_rxc_interrupt_clear_pend(struct rxc *rxc)
+{
+	writel(2, rxc->va_of_vreg_ihcu_rxcintctl);
+}
+
+#define POLL_WEIGHT 		32
+#define RX_INTR_TIMEOUT		2
+#define RX_INTR_PKT_CNT		8
+#define TX_PKTS_PER_IRQ		64
+#define TX_PKTS_PER_BELL	1
+#define VIOC_CSUM_OFFLOAD	CHECKSUM_COMPLETE
+#define VIOC_TRACE			0
+
+#define VIOC_LISTEN_GROUP	1
+
+#endif				/* _VIOC_VNIC_H */
_

Patches currently in -mm which might be from schidambaram@fabric7.com a=
re

=46abric7-VIOC-driver.patch
=46abric7-VIOC-driver-fixes.patch
