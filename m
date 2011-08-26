From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-use-of-non-compatible-registers.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:41 -0700
Message-ID: <201108261903.p7QJ3PKn005681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab1HZTEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, chul.kim@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, stable@kernel.org, thomas.moll@sysgo.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: fix use of non-compatible registers
has been removed from the -mm tree.  Its filename was
     rapidio-fix-use-of-non-compatible-registers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix use of non-compatible registers
From: Alexandre Bounine <alexandre.bounine@idt.com>

Replace/remove use of RIO v.1.2 registers/bits that are not
forward-compatible with newer versions of RapidIO specification.

RapidIO specification v.  1.3 removed Write Port CSR, Doorbell CSR,
Mailbox CSR and Mailbox and Doorbell bits of the PEF CAR.

Use of removed (since RIO v.1.3) register bits affects users of currently
available 1.3 and 2.x compliant devices who may use not so recent kernel
versions.

Removing checks for unsupported bits makes corresponding routines
compatible with all versions of RapidIO specification.  Therefore,
backporting makes stable kernel versions compliant with RIO v.1.3 and
later as well.  

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/rionet.c       |   23 ++++++++---------------
 drivers/rapidio/rio-scan.c |    3 +--
 include/linux/rio_regs.h   |   18 +++++++++---------
 3 files changed, 18 insertions(+), 26 deletions(-)

diff -puN drivers/net/rionet.c~rapidio-fix-use-of-non-compatible-registers drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-fix-use-of-non-compatible-registers
+++ a/drivers/net/rionet.c
@@ -80,13 +80,13 @@ static int rionet_capable = 1;
  */
 static struct rio_dev **rionet_active;
 
-#define is_rionet_capable(pef, src_ops, dst_ops)		\
-			((pef & RIO_PEF_INB_MBOX) &&		\
-			 (pef & RIO_PEF_INB_DOORBELL) &&	\
+#define is_rionet_capable(src_ops, dst_ops)			\
+			((src_ops & RIO_SRC_OPS_DATA_MSG) &&	\
+			 (dst_ops & RIO_DST_OPS_DATA_MSG) &&	\
 			 (src_ops & RIO_SRC_OPS_DOORBELL) &&	\
 			 (dst_ops & RIO_DST_OPS_DOORBELL))
 #define dev_rionet_capable(dev) \
-	is_rionet_capable(dev->pef, dev->src_ops, dev->dst_ops)
+	is_rionet_capable(dev->src_ops, dev->dst_ops)
 
 #define RIONET_MAC_MATCH(x)	(*(u32 *)x == 0x00010001)
 #define RIONET_GET_DESTID(x)	(*(u16 *)(x + 4))
@@ -282,7 +282,6 @@ static int rionet_open(struct net_device
 {
 	int i, rc = 0;
 	struct rionet_peer *peer, *tmp;
-	u32 pwdcsr;
 	struct rionet_private *rnet = netdev_priv(ndev);
 
 	if (netif_msg_ifup(rnet))
@@ -332,13 +331,8 @@ static int rionet_open(struct net_device
 			continue;
 		}
 
-		/*
-		 * If device has initialized inbound doorbells,
-		 * send a join message
-		 */
-		rio_read_config_32(peer->rdev, RIO_WRITE_PORT_CSR, &pwdcsr);
-		if (pwdcsr & RIO_DOORBELL_AVAIL)
-			rio_send_doorbell(peer->rdev, RIONET_DOORBELL_JOIN);
+		/* Send a join message */
+		rio_send_doorbell(peer->rdev, RIONET_DOORBELL_JOIN);
 	}
 
       out:
@@ -492,7 +486,7 @@ static int rionet_setup_netdev(struct ri
 static int rionet_probe(struct rio_dev *rdev, const struct rio_device_id *id)
 {
 	int rc = -ENODEV;
-	u32 lpef, lsrc_ops, ldst_ops;
+	u32 lsrc_ops, ldst_ops;
 	struct rionet_peer *peer;
 	struct net_device *ndev = NULL;
 
@@ -515,12 +509,11 @@ static int rionet_probe(struct rio_dev *
 	 * on later probes
 	 */
 	if (!rionet_check) {
-		rio_local_read_config_32(rdev->net->hport, RIO_PEF_CAR, &lpef);
 		rio_local_read_config_32(rdev->net->hport, RIO_SRC_OPS_CAR,
 					 &lsrc_ops);
 		rio_local_read_config_32(rdev->net->hport, RIO_DST_OPS_CAR,
 					 &ldst_ops);
-		if (!is_rionet_capable(lpef, lsrc_ops, ldst_ops)) {
+		if (!is_rionet_capable(lsrc_ops, ldst_ops)) {
 			printk(KERN_ERR
 			       "%s: local device is not network capable\n",
 			       DRV_NAME);
diff -puN drivers/rapidio/rio-scan.c~rapidio-fix-use-of-non-compatible-registers drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-fix-use-of-non-compatible-registers
+++ a/drivers/rapidio/rio-scan.c
@@ -505,8 +505,7 @@ static struct rio_dev __devinit *rio_set
 	rdev->dev.dma_mask = &rdev->dma_mask;
 	rdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
-	if ((rdev->pef & RIO_PEF_INB_DOORBELL) &&
-	    (rdev->dst_ops & RIO_DST_OPS_DOORBELL))
+	if (rdev->dst_ops & RIO_DST_OPS_DOORBELL)
 		rio_init_dbell_res(&rdev->riores[RIO_DOORBELL_RESOURCE],
 				   0, 0xffff);
 
diff -puN include/linux/rio_regs.h~rapidio-fix-use-of-non-compatible-registers include/linux/rio_regs.h
--- a/include/linux/rio_regs.h~rapidio-fix-use-of-non-compatible-registers
+++ a/include/linux/rio_regs.h
@@ -36,12 +36,12 @@
 #define  RIO_PEF_PROCESSOR		0x20000000	/* [I] Processor */
 #define  RIO_PEF_SWITCH			0x10000000	/* [I] Switch */
 #define  RIO_PEF_MULTIPORT		0x08000000	/* [VI, 2.1] Multiport */
-#define  RIO_PEF_INB_MBOX		0x00f00000	/* [II] Mailboxes */
-#define  RIO_PEF_INB_MBOX0		0x00800000	/* [II] Mailbox 0 */
-#define  RIO_PEF_INB_MBOX1		0x00400000	/* [II] Mailbox 1 */
-#define  RIO_PEF_INB_MBOX2		0x00200000	/* [II] Mailbox 2 */
-#define  RIO_PEF_INB_MBOX3		0x00100000	/* [II] Mailbox 3 */
-#define  RIO_PEF_INB_DOORBELL		0x00080000	/* [II] Doorbells */
+#define  RIO_PEF_INB_MBOX		0x00f00000	/* [II, <= 1.2] Mailboxes */
+#define  RIO_PEF_INB_MBOX0		0x00800000	/* [II, <= 1.2] Mailbox 0 */
+#define  RIO_PEF_INB_MBOX1		0x00400000	/* [II, <= 1.2] Mailbox 1 */
+#define  RIO_PEF_INB_MBOX2		0x00200000	/* [II, <= 1.2] Mailbox 2 */
+#define  RIO_PEF_INB_MBOX3		0x00100000	/* [II, <= 1.2] Mailbox 3 */
+#define  RIO_PEF_INB_DOORBELL		0x00080000	/* [II, <= 1.2] Doorbells */
 #define  RIO_PEF_EXT_RT			0x00000200	/* [III, 1.3] Extended route table support */
 #define  RIO_PEF_STD_RT			0x00000100	/* [III, 1.3] Standard route table support */
 #define  RIO_PEF_CTLS			0x00000010	/* [III] CTLS */
@@ -102,7 +102,7 @@
 #define	RIO_SWITCH_RT_LIMIT	0x34	/* [III, 1.3] Switch Route Table Destination ID Limit CAR */
 #define	 RIO_RT_MAX_DESTID		0x0000ffff
 
-#define RIO_MBOX_CSR		0x40	/* [II] Mailbox CSR */
+#define RIO_MBOX_CSR		0x40	/* [II, <= 1.2] Mailbox CSR */
 #define  RIO_MBOX0_AVAIL		0x80000000	/* [II] Mbox 0 avail */
 #define  RIO_MBOX0_FULL			0x40000000	/* [II] Mbox 0 full */
 #define  RIO_MBOX0_EMPTY		0x20000000	/* [II] Mbox 0 empty */
@@ -128,8 +128,8 @@
 #define  RIO_MBOX3_FAIL			0x00000008	/* [II] Mbox 3 fail */
 #define  RIO_MBOX3_ERROR		0x00000004	/* [II] Mbox 3 error */
 
-#define RIO_WRITE_PORT_CSR	0x44	/* [I] Write Port CSR */
-#define RIO_DOORBELL_CSR	0x44	/* [II] Doorbell CSR */
+#define RIO_WRITE_PORT_CSR	0x44	/* [I, <= 1.2] Write Port CSR */
+#define RIO_DOORBELL_CSR	0x44	/* [II, <= 1.2] Doorbell CSR */
 #define  RIO_DOORBELL_AVAIL		0x80000000	/* [II] Doorbell avail */
 #define  RIO_DOORBELL_FULL		0x40000000	/* [II] Doorbell full */
 #define  RIO_DOORBELL_EMPTY		0x20000000	/* [II] Doorbell empty */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch
rapidio-add-mport-driver-for-tsi721-bridge.patch

