From: akpm@linux-foundation.org
Subject: [to-be-updated] mips-txx9-add-tx4939-rng-support.patch removed from -mm tree
Date: Mon, 01 Jun 2009 20:58:47 -0700
Message-ID: <200906020358.n523wl2w015026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbZFBD7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 23:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, herbert@gondor.apana.org.au, mpm@selenic.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: TXx9: add TX4939 RNG support
has been removed from the -mm tree.  Its filename was
     mips-txx9-add-tx4939-rng-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: TXx9: add TX4939 RNG support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add platform support for RNG of TX4939 SoC.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/txx9/tx4939.h   |    1 +
 arch/mips/txx9/generic/setup_tx4939.c |   18 ++++++++++++++++++
 arch/mips/txx9/rbtx4939/setup.c       |    1 +
 3 files changed, 20 insertions(+)

diff -puN arch/mips/include/asm/txx9/tx4939.h~mips-txx9-add-tx4939-rng-support arch/mips/include/asm/txx9/tx4939.h
--- a/arch/mips/include/asm/txx9/tx4939.h~mips-txx9-add-tx4939-rng-support
+++ a/arch/mips/include/asm/txx9/tx4939.h
@@ -539,6 +539,7 @@ int tx4939_pci_map_irq(const struct pci_
 void tx4939_setup_pcierr_irq(void);
 void tx4939_irq_init(void);
 int tx4939_irq(void);
+void tx4939_rng_init(void);
 void tx4939_mtd_init(int ch);
 void tx4939_ata_init(void);
 void tx4939_rtc_init(void);
diff -puN arch/mips/txx9/generic/setup_tx4939.c~mips-txx9-add-tx4939-rng-support arch/mips/txx9/generic/setup_tx4939.c
--- a/arch/mips/txx9/generic/setup_tx4939.c~mips-txx9-add-tx4939-rng-support
+++ a/arch/mips/txx9/generic/setup_tx4939.c
@@ -494,6 +494,24 @@ void __init tx4939_aclc_init(void)
 			       TXX9_IRQ_BASE + TX4939_IR_ACLC, 1, 0, 1);
 }
 
+#define TX4939_RNG_REG	((TX4939_CRYPTO_REG & 0xfffffffffULL) + 0xb0)
+void __init tx4939_rng_init(void)
+{
+	static struct resource res = {
+		.start = TX4939_RNG_REG,
+		.end = TX4939_RNG_REG + 0x30 - 1,
+		.flags = IORESOURCE_MEM,
+	};
+	static struct platform_device pdev = {
+		.name = "tx4939-rng",
+		.id = -1,
+		.num_resources = 1,
+		.resource = &res,
+	};
+
+	platform_device_register(&pdev);
+}
+
 static void __init tx4939_stop_unused_modules(void)
 {
 	__u64 pcfg, rst = 0, ckd = 0;
diff -puN arch/mips/txx9/rbtx4939/setup.c~mips-txx9-add-tx4939-rng-support arch/mips/txx9/rbtx4939/setup.c
--- a/arch/mips/txx9/rbtx4939/setup.c~mips-txx9-add-tx4939-rng-support
+++ a/arch/mips/txx9/rbtx4939/setup.c
@@ -501,6 +501,7 @@ static void __init rbtx4939_device_init(
 	tx4939_dmac_init(0, 2);
 	tx4939_aclc_init();
 	platform_device_register_simple("txx9aclc-generic", -1, NULL, 0);
+	tx4939_rng_init();
 }
 
 static void __init rbtx4939_setup(void)
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch
mips-txx9-add-tx4939-rng-support.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
rtc-rtc-ds1742-nvram-attribute-fix.patch
rtc-tx4939-drop-irqf_shared.patch
rtc-ds1553-drop-irqf_shared.patch
rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch

