From: akpm@linux-foundation.org
Subject: - blackfin-patch-add-blackfin-support-in-smc91x.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:49 -0700
Message-ID: <200705080004.l4804nPW009042@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967365AbXEHAFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin: add blackfin support in smc91x ethernet controller driver
has been removed from the -mm tree.  Its filename was
     blackfin-patch-add-blackfin-support-in-smc91x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Blackfin: add blackfin support in smc91x ethernet controller driver
From: "Wu, Bryan" <bryan.wu@analog.com>

As SMC91X ethernet controller are used in blackfin STAMP 533 development
board, this patch add blackfin support to the smc91x linux driver.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig  |    2 -
 drivers/net/smc91x.h |   47 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff -puN drivers/net/Kconfig~blackfin-patch-add-blackfin-support-in-smc91x drivers/net/Kconfig
--- a/drivers/net/Kconfig~blackfin-patch-add-blackfin-support-in-smc91x
+++ a/drivers/net/Kconfig
@@ -822,7 +822,7 @@ config SMC91X
 	tristate "SMC 91C9x/91C1xxx support"
 	select CRC32
 	select MII
-	depends on NET_ETHERNET && (ARM || REDWOOD_5 || REDWOOD_6 || M32R || SUPERH || SOC_AU1X00)
+	depends on NET_ETHERNET && (ARM || REDWOOD_5 || REDWOOD_6 || M32R || SUPERH || SOC_AU1X00 || BFIN)
 	help
 	  This is a driver for SMC's 91x series of Ethernet chipsets,
 	  including the SMC91C94 and the SMC91C111. Say Y if you want it
diff -puN drivers/net/smc91x.h~blackfin-patch-add-blackfin-support-in-smc91x drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~blackfin-patch-add-blackfin-support-in-smc91x
+++ a/drivers/net/smc91x.h
@@ -55,6 +55,53 @@
 #define SMC_insw(a, r, p, l)	readsw((a) + (r), p, l)
 #define SMC_outsw(a, r, p, l)	writesw((a) + (r), p, l)
 
+#elif defined(CONFIG_BFIN)
+
+#define SMC_IRQ_FLAGS		IRQF_TRIGGER_HIGH
+
+# if defined (CONFIG_BFIN561_EZKIT)
+#define SMC_CAN_USE_8BIT	0
+#define SMC_CAN_USE_16BIT	1
+#define SMC_CAN_USE_32BIT	1
+#define SMC_IO_SHIFT		0
+#define SMC_NOWAIT      	1
+#define SMC_USE_BFIN_DMA	0
+
+
+#define SMC_inw(a, r)       	readw((a) + (r))
+#define SMC_outw(v, a, r)   	writew(v, (a) + (r))
+#define SMC_inl(a, r)       	readl((a) + (r))
+#define SMC_outl(v, a, r)   	writel(v, (a) + (r))
+#define SMC_outsl(a, r, p, l)	outsl((unsigned long *)((a) + (r)), p, l)
+#define SMC_insl(a, r, p, l) 	insl ((unsigned long *)((a) + (r)), p, l)
+# else
+#define SMC_CAN_USE_8BIT	0
+#define SMC_CAN_USE_16BIT	1
+#define SMC_CAN_USE_32BIT	0
+#define SMC_IO_SHIFT		0
+#define SMC_NOWAIT      	1
+#define SMC_USE_BFIN_DMA	0
+
+
+#define SMC_inw(a, r)       	readw((a) + (r))
+#define SMC_outw(v, a, r)   	writew(v, (a) + (r))
+#define SMC_outsw(a, r, p, l)	outsw((unsigned long *)((a) + (r)), p, l)
+#define SMC_insw(a, r, p, l) 	insw ((unsigned long *)((a) + (r)), p, l)
+# endif
+/* check if the mac in reg is valid */
+#define SMC_GET_MAC_ADDR(addr)					\
+	do {							\
+		unsigned int __v;				\
+		__v = SMC_inw(ioaddr, ADDR0_REG);		\
+		addr[0] = __v; addr[1] = __v >> 8;		\
+		__v = SMC_inw(ioaddr, ADDR1_REG);		\
+		addr[2] = __v; addr[3] = __v >> 8;		\
+		__v = SMC_inw(ioaddr, ADDR2_REG);		\
+		addr[4] = __v; addr[5] = __v >> 8;		\
+		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
+			random_ether_addr(addr);		\
+		}						\
+	} while (0)
 #elif defined(CONFIG_REDWOOD_5) || defined(CONFIG_REDWOOD_6)
 
 /* We can only do 16-bit reads and writes in the static memory space. */
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
move-die-notifier-handling-to-common-code.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
