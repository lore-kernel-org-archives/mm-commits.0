From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-infiniband.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:52:07 -0700
Message-ID: <200707060052.l660q7RE028346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761159AbXGFA5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects II - Infiniband
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-infiniband.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects II - Infiniband
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/Kconfig             |   15 +++++++--------
 drivers/infiniband/hw/amso1100/Kconfig |    2 +-
 drivers/infiniband/hw/cxgb3/Kconfig    |    2 +-
 drivers/infiniband/hw/ehca/Kconfig     |    2 +-
 drivers/infiniband/hw/ipath/Kconfig    |    2 +-
 drivers/infiniband/hw/mlx4/Kconfig     |    1 -
 drivers/infiniband/hw/mthca/Kconfig    |    2 +-
 drivers/infiniband/ulp/ipoib/Kconfig   |    2 +-
 drivers/infiniband/ulp/iser/Kconfig    |    2 +-
 drivers/infiniband/ulp/srp/Kconfig     |    2 +-
 10 files changed, 15 insertions(+), 17 deletions(-)

diff -puN drivers/infiniband/hw/amso1100/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/hw/amso1100/Kconfig
--- a/drivers/infiniband/hw/amso1100/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/hw/amso1100/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_AMSO1100
 	tristate "Ammasso 1100 HCA support"
-	depends on PCI && INET && INFINIBAND
+	depends on PCI && INET
 	---help---
 	  This is a low-level driver for the Ammasso 1100 host
 	  channel adapter (HCA).
diff -puN drivers/infiniband/hw/cxgb3/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/hw/cxgb3/Kconfig
--- a/drivers/infiniband/hw/cxgb3/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/hw/cxgb3/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_CXGB3
 	tristate "Chelsio RDMA Driver"
-	depends on CHELSIO_T3 && INFINIBAND && INET
+	depends on CHELSIO_T3 && INET
 	select GENERIC_ALLOCATOR
 	---help---
 	  This is an iWARP/RDMA driver for the Chelsio T3 1GbE and
diff -puN drivers/infiniband/hw/ehca/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/hw/ehca/Kconfig
--- a/drivers/infiniband/hw/ehca/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/hw/ehca/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_EHCA
 	tristate "eHCA support"
-	depends on IBMEBUS && INFINIBAND
+	depends on IBMEBUS
 	---help---
 	This driver supports the IBM pSeries eHCA InfiniBand adapter.
 
diff -puN drivers/infiniband/hw/ipath/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/hw/ipath/Kconfig
--- a/drivers/infiniband/hw/ipath/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/hw/ipath/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_IPATH
 	tristate "QLogic InfiniPath Driver"
-	depends on (PCI_MSI || HT_IRQ) && 64BIT && INFINIBAND && NET
+	depends on (PCI_MSI || HT_IRQ) && 64BIT && NET
 	---help---
 	This is a driver for QLogic InfiniPath host channel adapters,
 	including InfiniBand verbs support.  This driver allows these
diff -puN drivers/infiniband/hw/mlx4/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/hw/mlx4/Kconfig
--- a/drivers/infiniband/hw/mlx4/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/hw/mlx4/Kconfig
@@ -1,6 +1,5 @@
 config MLX4_INFINIBAND
 	tristate "Mellanox ConnectX HCA support"
-	depends on INFINIBAND
 	select MLX4_CORE
 	---help---
 	  This driver provides low-level InfiniBand support for
diff -puN drivers/infiniband/hw/mthca/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/hw/mthca/Kconfig
--- a/drivers/infiniband/hw/mthca/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/hw/mthca/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_MTHCA
 	tristate "Mellanox HCA support"
-	depends on PCI && INFINIBAND
+	depends on PCI
 	---help---
 	  This is a low-level driver for Mellanox InfiniHost host
 	  channel adapters (HCAs), including the MT23108 PCI-X HCA
diff -puN drivers/infiniband/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/Kconfig
--- a/drivers/infiniband/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/Kconfig
@@ -1,14 +1,14 @@
-menu "InfiniBand support"
-	depends on HAS_IOMEM
-
-config INFINIBAND
-	depends on PCI || BROKEN
+menuconfig INFINIBAND
 	tristate "InfiniBand support"
+	depends on PCI || BROKEN
+	depends on HAS_IOMEM
 	---help---
 	  Core support for InfiniBand (IB).  Make sure to also select
 	  any protocols you wish to use as well as drivers for your
 	  InfiniBand hardware.
 
+if INFINIBAND
+
 config INFINIBAND_USER_MAD
 	tristate "InfiniBand userspace MAD support"
 	depends on INFINIBAND
@@ -20,7 +20,6 @@ config INFINIBAND_USER_MAD
 
 config INFINIBAND_USER_ACCESS
 	tristate "InfiniBand userspace access (verbs and CM)"
-	depends on INFINIBAND
 	---help---
 	  Userspace InfiniBand access support.  This enables the
 	  kernel side of userspace verbs and the userspace
@@ -37,7 +36,7 @@ config INFINIBAND_USER_MEM
 
 config INFINIBAND_ADDR_TRANS
 	bool
-	depends on INFINIBAND && INET
+	depends on INET
 	default y
 
 source "drivers/infiniband/hw/mthca/Kconfig"
@@ -54,4 +53,4 @@ source "drivers/infiniband/ulp/srp/Kconf
 
 source "drivers/infiniband/ulp/iser/Kconfig"
 
-endmenu
+endif # INFINIBAND
diff -puN drivers/infiniband/ulp/ipoib/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/ulp/ipoib/Kconfig
--- a/drivers/infiniband/ulp/ipoib/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/ulp/ipoib/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_IPOIB
 	tristate "IP-over-InfiniBand"
-	depends on INFINIBAND && NETDEVICES && INET && (IPV6 || IPV6=n)
+	depends on NETDEVICES && INET && (IPV6 || IPV6=n)
 	---help---
 	  Support for the IP-over-InfiniBand protocol (IPoIB). This
 	  transports IP packets over InfiniBand so you can use your IB
diff -puN drivers/infiniband/ulp/iser/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/ulp/iser/Kconfig
--- a/drivers/infiniband/ulp/iser/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/ulp/iser/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_ISER
 	tristate "iSCSI Extensions for RDMA (iSER)"
-	depends on INFINIBAND && SCSI && INET
+	depends on SCSI && INET
 	select SCSI_ISCSI_ATTRS
 	---help---
 	  Support for the iSCSI Extensions for RDMA (iSER) Protocol
diff -puN drivers/infiniband/ulp/srp/Kconfig~use-menuconfig-objects-ii-infiniband drivers/infiniband/ulp/srp/Kconfig
--- a/drivers/infiniband/ulp/srp/Kconfig~use-menuconfig-objects-ii-infiniband
+++ a/drivers/infiniband/ulp/srp/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_SRP
 	tristate "InfiniBand SCSI RDMA Protocol"
-	depends on INFINIBAND && SCSI
+	depends on SCSI
 	---help---
 	  Support for the SCSI RDMA Protocol over InfiniBand.  This
 	  allows you to access storage devices that speak SRP over
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

git-acpi.patch
git-hid.patch
git-infiniband.patch
git-kvm.patch
git-netdev-all.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
kernel-utf-8-handling.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_i4l.patch
use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch
