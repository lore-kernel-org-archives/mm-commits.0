From: akpm@linux-foundation.org
Subject: + defxx-use-__maybe_unused-rather-than-a-local-hack.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:02:34 -0700
Message-ID: <200707202102.l6KL2YGt016243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755623AbXGTVC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org


The patch titled
     defxx: use __maybe_unused rather than a local hack
has been added to the -mm tree.  Its filename is
     defxx-use-__maybe_unused-rather-than-a-local-hack.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: defxx: use __maybe_unused rather than a local hack
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a change to remove a local hack in favour to __maybe_unused that
has been recently added.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/defxx.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/net/defxx.c~defxx-use-__maybe_unused-rather-than-a-local-hack drivers/net/defxx.c
--- a/drivers/net/defxx.c~defxx-use-__maybe_unused-rather-than-a-local-hack
+++ a/drivers/net/defxx.c
@@ -200,6 +200,7 @@
 
 /* Include files */
 #include <linux/bitops.h>
+#include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/eisa.h>
@@ -240,8 +241,6 @@ static char version[] __devinitdata =
  */
 #define NEW_SKB_SIZE (PI_RCV_DATA_K_SIZE_MAX+128)
 
-#define __unused __attribute__ ((unused))
-
 #ifdef CONFIG_PCI
 #define DFX_BUS_PCI(dev) (dev->bus == &pci_bus_type)
 #else
@@ -375,7 +374,7 @@ static inline void dfx_outl(DFX_board_t 
 
 static void dfx_port_write_long(DFX_board_t *bp, int offset, u32 data)
 {
-	struct device __unused *bdev = bp->bus_dev;
+	struct device __maybe_unused *bdev = bp->bus_dev;
 	int dfx_bus_tc = DFX_BUS_TC(bdev);
 	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 
@@ -399,7 +398,7 @@ static inline void dfx_inl(DFX_board_t *
 
 static void dfx_port_read_long(DFX_board_t *bp, int offset, u32 *data)
 {
-	struct device __unused *bdev = bp->bus_dev;
+	struct device __maybe_unused *bdev = bp->bus_dev;
 	int dfx_bus_tc = DFX_BUS_TC(bdev);
 	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
 
@@ -866,7 +865,7 @@ static void __devinit dfx_bus_uninit(str
 
 static void __devinit dfx_bus_config_check(DFX_board_t *bp)
 {
-	struct device __unused *bdev = bp->bus_dev;
+	struct device __maybe_unused *bdev = bp->bus_dev;
 	int dfx_bus_eisa = DFX_BUS_EISA(bdev);
 	int	status;				/* return code from adapter port control call */
 	u32	host_data;			/* LW data returned from port control call */
@@ -3624,8 +3623,8 @@ static void __devexit dfx_unregister(str
 }
 
 
-static int __devinit __unused dfx_dev_register(struct device *);
-static int __devexit __unused dfx_dev_unregister(struct device *);
+static int __devinit __maybe_unused dfx_dev_register(struct device *);
+static int __devexit __maybe_unused dfx_dev_unregister(struct device *);
 
 #ifdef CONFIG_PCI
 static int __devinit dfx_pci_register(struct pci_dev *,
@@ -3699,7 +3698,7 @@ static struct tc_driver dfx_tc_driver = 
 };
 #endif /* CONFIG_TC */
 
-static int __devinit __unused dfx_dev_register(struct device *dev)
+static int __devinit __maybe_unused dfx_dev_register(struct device *dev)
 {
 	int status;
 
@@ -3709,7 +3708,7 @@ static int __devinit __unused dfx_dev_re
 	return status;
 }
 
-static int __devexit __unused dfx_dev_unregister(struct device *dev)
+static int __devexit __maybe_unused dfx_dev_unregister(struct device *dev)
 {
 	put_device(dev);
 	dfx_unregister(dev);
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
defxx-use-__maybe_unused-rather-than-a-local-hack.patch
sb1250-duart-__maybe_unused-etc-fixes.patch
