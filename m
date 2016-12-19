From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
 added to -mm tree
Date: Mon, 19 Dec 2016 14:27:00 -0800
Message-ID: <58585eb4.C0NFkpmSuduLyOFl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43932 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSW0B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:26:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "overrided" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "overrided" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  overrided||overridden

Link: http://lkml.kernel.org/r/1481573103-11329-22-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/acpi/method-customizing.txt           |    2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c           |    2 +-
 drivers/acpi/resource.c                             |    2 +-
 drivers/gpu/drm/amd/powerplay/inc/hardwaremanager.h |    2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c        |    2 +-
 drivers/net/ethernet/micrel/ksz884x.c               |    8 ++++----
 drivers/pinctrl/bcm/Kconfig                         |    2 +-
 scripts/spelling.txt                                |    1 +
 tools/lib/bpf/bpf.c                                 |    2 +-
 9 files changed, 12 insertions(+), 11 deletions(-)

diff -puN Documentation/acpi/method-customizing.txt~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances Documentation/acpi/method-customizing.txt
--- a/Documentation/acpi/method-customizing.txt~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances
+++ a/Documentation/acpi/method-customizing.txt
@@ -57,7 +57,7 @@ Note: To get the ACPI debug object outpu
 3. undo your changes
    The "undo" operation is not supported for a new inserted method
    right now, i.e. we can not remove a method currently.
-   For an overrided method, in order to undo your changes, please
+   For an overridden method, in order to undo your changes, please
    save a copy of the method original ASL code in step c) section 1,
    and redo step c) ~ g) to override the method with the original one.
 
diff -puN arch/powerpc/platforms/powernv/pci-ioda.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances arch/powerpc/platforms/powernv/pci-ioda.c
--- a/arch/powerpc/platforms/powernv/pci-ioda.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances
+++ a/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -3031,7 +3031,7 @@ static void pnv_ioda_setup_pe_res(struct
 /*
  * This function is supposed to be called on basis of PE from top
  * to bottom style. So the the I/O or MMIO segment assigned to
- * parent PE could be overrided by its child PEs if necessary.
+ * parent PE could be overridden by its child PEs if necessary.
  */
 static void pnv_ioda_setup_pe_seg(struct pnv_ioda_pe *pe)
 {
diff -puN drivers/acpi/resource.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances drivers/acpi/resource.c
--- a/drivers/acpi/resource.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances
+++ a/drivers/acpi/resource.c
@@ -393,7 +393,7 @@ static void acpi_dev_get_irqresource(str
 	}
 
 	/*
-	 * In IO-APIC mode, use overrided attribute. Two reasons:
+	 * In IO-APIC mode, use overridden attribute. Two reasons:
 	 * 1. BIOS bug in DSDT
 	 * 2. BIOS uses IO-APIC mode Interrupt Source Override
 	 *
diff -puN drivers/gpu/drm/amd/powerplay/inc/hardwaremanager.h~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances drivers/gpu/drm/amd/powerplay/inc/hardwaremanager.h
--- a/drivers/gpu/drm/amd/powerplay/inc/hardwaremanager.h~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances
+++ a/drivers/gpu/drm/amd/powerplay/inc/hardwaremanager.h
@@ -89,7 +89,7 @@ enum phm_platform_caps {
 	PHM_PlatformCaps_EnableSideportControl,                 /* indicates Sideport can be controlled */
 	PHM_PlatformCaps_VideoPlaybackEEUNotification,          /* indicates EEU notification of video start/stop is required */
 	PHM_PlatformCaps_TurnOffPll_ASPML1,                     /* PCIE Turn Off PLL in ASPM L1 */
-	PHM_PlatformCaps_EnableHTLinkControl,                   /* indicates HT Link can be controlled by ACPI or CLMC overrided/automated mode. */
+	PHM_PlatformCaps_EnableHTLinkControl,                   /* indicates HT Link can be controlled by ACPI or CLMC overridden/automated mode. */
 	PHM_PlatformCaps_PerformanceStateOnly,                  /* indicates only performance power state to be used on current system. */
 	PHM_PlatformCaps_ExclusiveModeAlwaysHigh,               /* In Exclusive (3D) mode always stay in High state. */
 	PHM_PlatformCaps_DisableMGClockGating,                  /* to disable Medium Grain Clock Gating or not */
diff -puN drivers/net/ethernet/broadcom/bcm63xx_enet.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances drivers/net/ethernet/broadcom/bcm63xx_enet.c
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -817,7 +817,7 @@ static void bcm_enet_adjust_phy_link(str
 			rx_pause_en = 1;
 			tx_pause_en = 1;
 		} else if (!priv->pause_auto) {
-			/* pause setting overrided by user */
+			/* pause setting overridden by user */
 			rx_pause_en = priv->pause_rx;
 			tx_pause_en = priv->pause_tx;
 		} else {
diff -puN drivers/net/ethernet/micrel/ksz884x.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances drivers/net/ethernet/micrel/ksz884x.c
--- a/drivers/net/ethernet/micrel/ksz884x.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/micrel/ksz884x.c
@@ -1251,10 +1251,10 @@ struct ksz_port_info {
  * @tx_size:		Transmit data size.  Used for TX optimization.
  * 			The maximum is defined by MAX_TX_HELD_SIZE.
  * @perm_addr:		Permanent MAC address.
- * @override_addr:	Overrided MAC address.
+ * @override_addr:	Overridden MAC address.
  * @address:		Additional MAC address entries.
  * @addr_list_size:	Additional MAC address list size.
- * @mac_override:	Indication of MAC address overrided.
+ * @mac_override:	Indication of MAC address overridden.
  * @promiscuous:	Counter to keep track of promiscuous mode set.
  * @all_multi:		Counter to keep track of all multicast mode set.
  * @multi_list:		Multicast address entries.
@@ -4042,7 +4042,7 @@ static int empty_addr(u8 *addr)
  * @hw: 	The hardware instance.
  *
  * This routine programs the MAC address of the hardware when the address is
- * overrided.
+ * overridden.
  */
 static void hw_set_addr(struct ksz_hw *hw)
 {
@@ -7029,7 +7029,7 @@ static int pcidev_init(struct pci_dev *p
 	if (macaddr[0] != ':')
 		get_mac_addr(hw_priv, macaddr, MAIN_PORT);
 
-	/* Read MAC address and initialize override address if not overrided. */
+	/* Read MAC address and initialize override address if not overridden. */
 	hw_read_addr(hw);
 
 	/* Multiple device interfaces mode requires a second MAC address. */
diff -puN drivers/pinctrl/bcm/Kconfig~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances drivers/pinctrl/bcm/Kconfig
--- a/drivers/pinctrl/bcm/Kconfig~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances
+++ a/drivers/pinctrl/bcm/Kconfig
@@ -70,7 +70,7 @@ config PINCTRL_CYGNUS_MUX
 
 	  The Broadcom Cygnus IOMUX driver supports group based IOMUX
 	  configuration, with the exception that certain individual pins
-	  can be overrided to GPIO function
+	  can be overridden to GPIO function
 
 config PINCTRL_NSP_GPIO
 	bool "Broadcom NSP GPIO (with PINCONF) driver"
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -727,6 +727,7 @@ overaall||overall
 overhread||overhead
 overlaping||overlapping
 overide||override
+overrided||overridden
 overriden||overridden
 overun||overrun
 pacakge||package
diff -puN tools/lib/bpf/bpf.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances tools/lib/bpf/bpf.c
--- a/tools/lib/bpf/bpf.c~scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances
+++ a/tools/lib/bpf/bpf.c
@@ -27,7 +27,7 @@
 #include "bpf.h"
 
 /*
- * When building perf, unistd.h is overrided. __NR_bpf is
+ * When building perf, unistd.h is overridden. __NR_bpf is
  * required to be defined explicitly.
  */
 #ifndef __NR_bpf
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

