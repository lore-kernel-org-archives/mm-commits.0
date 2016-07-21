From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
 added to -mm tree
Date: Thu, 21 Jul 2016 11:40:26 -0700
Message-ID: <5791171a.PJduMqS0NvdvMJq/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcGUSk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 14:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: add messaging mbox selector parameter
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-add-messaging-mbox-selector-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721-add-messaging-mbox-selector-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-rapidio-channelized-messaging-driver.patch
rapidio-documentation-fix-mangled-paragraph-in-mport_cdev.patch
rapidio-fix-return-value-description-for-dma_prep-functions.patch
rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
rapidio-fix-error-handling-in-mbox-request-release-functions.patch
rapidio-idt_gen2-fix-locking-warning.patch
rapidio-change-inbound-window-size-type-to-u64.patch
rapidio-modify-for-rev3-specification-changes.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch

