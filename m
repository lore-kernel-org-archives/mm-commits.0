From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-drivers-net.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:29 -0700
Message-ID: <20120913233729.6A70D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:33886 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068Ab2IMXha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:30 -0400
Received: by mail-yx0-f202.google.com with SMTP id q6so389740yen.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, davem@davemloft.net


The patch titled
     Subject: sections: fix section conflicts in drivers/net
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-drivers-net.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/net

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/can/slcan.c                         |    2 +-
 drivers/net/can/vcan.c                          |    2 +-
 drivers/net/ethernet/8390/ne3210.c              |    2 +-
 drivers/net/ethernet/adaptec/starfire.c         |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c        |    2 +-
 drivers/net/ethernet/dec/tulip/eeprom.c         |    2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c    |    2 +-
 drivers/net/ethernet/dlink/sundance.c           |    2 +-
 drivers/net/ethernet/fealnx.c                   |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c  |    2 +-
 drivers/net/ethernet/realtek/8139too.c          |    2 +-
 drivers/net/ethernet/sis/sis190.c               |    2 +-
 drivers/net/hamradio/6pack.c                    |    4 ++--
 14 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/net/can/slcan.c~sections-fix-section-conflicts-in-drivers-net drivers/net/can/slcan.c
--- a/drivers/net/can/slcan.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/can/slcan.c
@@ -56,7 +56,7 @@
 #include <linux/kernel.h>
 #include <linux/can.h>
 
-static __initdata const char banner[] =
+static __initconst const char banner[] =
 	KERN_INFO "slcan: serial line CAN interface driver\n";
 
 MODULE_ALIAS_LDISC(N_SLCAN);
diff -puN drivers/net/can/vcan.c~sections-fix-section-conflicts-in-drivers-net drivers/net/can/vcan.c
--- a/drivers/net/can/vcan.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/can/vcan.c
@@ -49,7 +49,7 @@
 #include <linux/slab.h>
 #include <net/rtnetlink.h>
 
-static __initdata const char banner[] =
+static __initconst const char banner[] =
 	KERN_INFO "vcan: Virtual CAN interface driver\n";
 
 MODULE_DESCRIPTION("virtual CAN interface");
diff -puN drivers/net/ethernet/8390/ne3210.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/8390/ne3210.c
--- a/drivers/net/ethernet/8390/ne3210.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/8390/ne3210.c
@@ -81,7 +81,7 @@ static void ne3210_block_output(struct n
 
 static unsigned char irq_map[] __initdata = {15, 12, 11, 10, 9, 7, 5, 3};
 static unsigned int shmem_map[] __initdata = {0xff0, 0xfe0, 0xfff0, 0xd8, 0xffe0, 0xffc0, 0xd0, 0x0};
-static const char *ifmap[] __initdata = {"UTP", "?", "BNC", "AUI"};
+static const char * const ifmap[] __initconst = {"UTP", "?", "BNC", "AUI"};
 static int ifmap_val[] __initdata = {
 		IF_PORT_10BASET,
 		IF_PORT_UNKNOWN,
diff -puN drivers/net/ethernet/adaptec/starfire.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/adaptec/starfire.c
--- a/drivers/net/ethernet/adaptec/starfire.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/adaptec/starfire.c
@@ -295,7 +295,7 @@ MODULE_DEVICE_TABLE(pci, starfire_pci_tb
 static const struct chip_info {
 	const char *name;
 	int drv_flags;
-} netdrv_tbl[] __devinitdata = {
+} netdrv_tbl[] __devinitconst = {
 	{ "Adaptec Starfire 6915", CanHaveMII },
 };
 
diff -puN drivers/net/ethernet/atheros/atl1c/atl1c_main.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/atheros/atl1c/atl1c_main.c
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -702,7 +702,7 @@ struct atl1c_platform_patch {
 	u32 patch_flag;
 #define ATL1C_LINK_PATCH	0x1
 };
-static const struct atl1c_platform_patch plats[] __devinitdata = {
+static const struct atl1c_platform_patch plats[] __devinitconst = {
 {0x2060, 0xC1, 0x1019, 0x8152, 0x1},
 {0x2060, 0xC1, 0x1019, 0x2060, 0x1},
 {0x2060, 0xC1, 0x1019, 0xE000, 0x1},
diff -puN drivers/net/ethernet/atheros/atlx/atl2.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/atheros/atlx/atl2.c
--- a/drivers/net/ethernet/atheros/atlx/atl2.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -2845,7 +2845,7 @@ static void atl2_force_ps(struct atl2_hw
  */
 
 #define ATL2_PARAM(X, desc) \
-    static const int __devinitdata X[ATL2_MAX_NIC + 1] = ATL2_PARAM_INIT; \
+    static const int __devinitconst X[ATL2_MAX_NIC + 1] = ATL2_PARAM_INIT; \
     MODULE_PARM(X, "1-" __MODULE_STRING(ATL2_MAX_NIC) "i"); \
     MODULE_PARM_DESC(X, desc);
 #else
diff -puN drivers/net/ethernet/dec/tulip/eeprom.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/dec/tulip/eeprom.c
--- a/drivers/net/ethernet/dec/tulip/eeprom.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/dec/tulip/eeprom.c
@@ -79,7 +79,7 @@ static struct eeprom_fixup eeprom_fixups
   {NULL}};
 
 
-static const char *block_name[] __devinitdata = {
+static const char *const block_name[] __devinitconst = {
 	"21140 non-MII",
 	"21140 MII PHY",
 	"21142 Serial PHY",
diff -puN drivers/net/ethernet/dec/tulip/winbond-840.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/dec/tulip/winbond-840.c
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -236,7 +236,7 @@ struct pci_id_info {
         int drv_flags;		/* Driver use, intended as capability flags. */
 };
 
-static const struct pci_id_info pci_id_tbl[] __devinitdata = {
+static const struct pci_id_info pci_id_tbl[] __devinitconst = {
 	{ 				/* Sometime a Level-One switch card. */
 	  "Winbond W89c840",	CanHaveMII | HasBrokenTx | FDXOnNoMII},
 	{ "Winbond W89c840",	CanHaveMII | HasBrokenTx},
diff -puN drivers/net/ethernet/dlink/sundance.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/dlink/sundance.c
--- a/drivers/net/ethernet/dlink/sundance.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/dlink/sundance.c
@@ -218,7 +218,7 @@ enum {
 struct pci_id_info {
         const char *name;
 };
-static const struct pci_id_info pci_id_tbl[] __devinitdata = {
+static const struct pci_id_info pci_id_tbl[] __devinitconst = {
 	{"D-Link DFE-550TX FAST Ethernet Adapter"},
 	{"D-Link DFE-550FX 100Mbps Fiber-optics Adapter"},
 	{"D-Link DFE-580TX 4 port Server Adapter"},
diff -puN drivers/net/ethernet/fealnx.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/fealnx.c
--- a/drivers/net/ethernet/fealnx.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/fealnx.c
@@ -150,7 +150,7 @@ struct chip_info {
 	int flags;
 };
 
-static const struct chip_info skel_netdrv_tbl[] __devinitdata = {
+static const struct chip_info skel_netdrv_tbl[] __devinitconst = {
  	{ "100/10M Ethernet PCI Adapter",	HAS_MII_XCVR },
 	{ "100/10M Ethernet PCI Adapter",	HAS_CHIP_XCVR },
 	{ "1000/100/10M Ethernet PCI Adapter",	HAS_MII_XCVR },
diff -puN drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -38,7 +38,7 @@ static inline void writeq(u64 val, void 
 }
 #endif
 
-static const struct crb_128M_2M_block_map
+static struct crb_128M_2M_block_map
 crb_128M_2M_map[64] __cacheline_aligned_in_smp = {
     {{{0, 0,         0,         0} } },		/* 0: PCI */
     {{{1, 0x0100000, 0x0102000, 0x120000},	/* 1: PCIE */
diff -puN drivers/net/ethernet/realtek/8139too.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/realtek/8139too.c
--- a/drivers/net/ethernet/realtek/8139too.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/realtek/8139too.c
@@ -228,7 +228,7 @@ typedef enum {
 static const struct {
 	const char *name;
 	u32 hw_flags;
-} board_info[] __devinitdata = {
+} board_info[] __devinitconst = {
 	{ "RealTek RTL8139", RTL8139_CAPS },
 	{ "RealTek RTL8129", RTL8129_CAPS },
 };
diff -puN drivers/net/ethernet/sis/sis190.c~sections-fix-section-conflicts-in-drivers-net drivers/net/ethernet/sis/sis190.c
--- a/drivers/net/ethernet/sis/sis190.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/ethernet/sis/sis190.c
@@ -1618,7 +1618,7 @@ static int __devinit sis190_get_mac_addr
 static int __devinit sis190_get_mac_addr_from_apc(struct pci_dev *pdev,
 						  struct net_device *dev)
 {
-	static const u16 __devinitdata ids[] = { 0x0965, 0x0966, 0x0968 };
+	static const u16 __devinitconst ids[] = { 0x0965, 0x0966, 0x0968 };
 	struct sis190_private *tp = netdev_priv(dev);
 	struct pci_dev *isa_bridge;
 	u8 reg, tmp8;
diff -puN drivers/net/hamradio/6pack.c~sections-fix-section-conflicts-in-drivers-net drivers/net/hamradio/6pack.c
--- a/drivers/net/hamradio/6pack.c~sections-fix-section-conflicts-in-drivers-net
+++ a/drivers/net/hamradio/6pack.c
@@ -811,9 +811,9 @@ static struct tty_ldisc_ops sp_ldisc = {
 
 /* Initialize 6pack control device -- register 6pack line discipline */
 
-static const char msg_banner[]  __initdata = KERN_INFO \
+static const char msg_banner[]  __initconst = KERN_INFO \
 	"AX.25: 6pack driver, " SIXPACK_VERSION "\n";
-static const char msg_regfail[] __initdata = KERN_ERR  \
+static const char msg_regfail[] __initconst = KERN_ERR  \
 	"6pack: can't register line discipline (err = %d)\n";
 
 static int __init sixpack_init_driver(void)
_

Patches currently in -mm which might be from ak@linux.intel.com are

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

