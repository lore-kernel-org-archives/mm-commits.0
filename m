From: akpm@linux-foundation.org
Subject: [patch 094/111] rapidio/tsi721: add messaging mbox selector
 parameter
Date: Tue, 02 Aug 2016 14:06:43 -0700
Message-ID: <57a10b63.5voieHZwYX1dPprh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbcHBVXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org

From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: add messaging mbox selector parameter

Add module parameter to allow load time configuration of available RapidIO
messaging mailboxes (MBOX1 - MBOX4).

Having a messaging MBOX selector mask allows to define which MBOXes are
controlled by the mport device driver and reserve some of them for direct
use by other drivers.

Link: http://lkml.kernel.org/r/1469125134-16523-7-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Barry Wood <barry.wood@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/tsi721.txt |    5 +++++
 drivers/rapidio/devices/tsi721.c |   15 +++++++++++++++
 2 files changed, 20 insertions(+)

diff -puN Documentation/rapidio/tsi721.txt~rapidio-tsi721-add-messaging-mbox-selector-parameter Documentation/rapidio/tsi721.txt
--- a/Documentation/rapidio/tsi721.txt~rapidio-tsi721-add-messaging-mbox-selector-parameter
+++ a/Documentation/rapidio/tsi721.txt
@@ -46,6 +46,11 @@ fully compatible with RIONET driver (Eth
         0 = 128B, 1 = 256B, 2 = 512B, 3 = 1024B, 4 = 2048B and 5 = 4096B.
         Default value is '-1' (= keep platform setting).
 
+- 'mbox_sel' - RIO messaging MBOX selection mask. This is a bitmask that defines
+        messaging MBOXes are managed by this device driver. Mask bits 0 - 3
+        correspond to MBOX0 - MBOX3. MBOX is under driver's control if the
+        corresponding bit is set to '1'. Default value is 0x0f (= all).
+
 II. Known problems
 
   None.
diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-messaging-mbox-selector-parameter drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-messaging-mbox-selector-parameter
+++ a/drivers/rapidio/devices/tsi721.c
@@ -46,6 +46,11 @@ static int pcie_mrrs = -1;
 module_param(pcie_mrrs, int, S_IRUGO);
 MODULE_PARM_DESC(pcie_mrrs, "PCIe MRRS override value (0...5)");
 
+static u8 mbox_sel = 0x0f;
+module_param(mbox_sel, byte, S_IRUGO);
+MODULE_PARM_DESC(mbox_sel,
+		 "RIO Messaging MBOX Selection Mask (default: 0x0f = all)");
+
 static void tsi721_omsg_handler(struct tsi721_device *priv, int ch);
 static void tsi721_imsg_handler(struct tsi721_device *priv, int ch);
 
@@ -1881,6 +1886,11 @@ static int tsi721_open_outb_mbox(struct
 		goto out;
 	}
 
+	if ((mbox_sel & (1 << mbox)) == 0) {
+		rc = -ENODEV;
+		goto out;
+	}
+
 	priv->omsg_ring[mbox].dev_id = dev_id;
 	priv->omsg_ring[mbox].size = entries;
 	priv->omsg_ring[mbox].sts_rdptr = 0;
@@ -2165,6 +2175,11 @@ static int tsi721_open_inb_mbox(struct r
 		goto out;
 	}
 
+	if ((mbox_sel & (1 << mbox)) == 0) {
+		rc = -ENODEV;
+		goto out;
+	}
+
 	/* Initialize IB Messaging Ring */
 	priv->imsg_ring[mbox].dev_id = dev_id;
 	priv->imsg_ring[mbox].size = entries;
_
