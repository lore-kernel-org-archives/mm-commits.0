From: akpm@linux-foundation.org
Subject: + rapidio-switches-add-driver-for-idt-gen3-switches-fix.patch
 added to -mm tree
Date: Thu, 21 Jul 2016 14:49:40 -0700
Message-ID: <57914374./XZ5jTwkcAMEWhKn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbcGUVtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 17:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/idt_gen3: fixup for original driver patch
has been added to the -mm tree.  Its filename is
     rapidio-switches-add-driver-for-idt-gen3-switches-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-switches-add-driver-for-idt-gen3-switches-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-switches-add-driver-for-idt-gen3-switches-fix.patch

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
Subject: rapidio/idt_gen3: fixup for original driver patch

This patch has two fixes for the patch
"rapidio/switches: add driver for IDT gen3 switches" currently in -mm tree.

First address Andrew's comment about blocking delay.
The second fix was missed during the original patch preparation.

Link: http://lkml.kernel.org/r/1469137596-18241-1-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idt_gen3.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/switches/idt_gen3.c~rapidio-switches-add-driver-for-idt-gen3-switches-fix drivers/rapidio/switches/idt_gen3.c
--- a/drivers/rapidio/switches/idt_gen3.c~rapidio-switches-add-driver-for-idt-gen3-switches-fix
+++ a/drivers/rapidio/switches/idt_gen3.c
@@ -173,7 +173,8 @@ idtg3_em_init(struct rio_dev *rdev)
 	rio_write_config_32(rdev, RIO_EM_DEV_INT_EN, 0);
 
 	/* Disable port-write event notifications during initialization */
-	rio_write_config_32(rdev, rdev->em_efptr + RIO_EM_PW_TX_CTRL, 0);
+	rio_write_config_32(rdev, rdev->em_efptr + RIO_EM_PW_TX_CTRL,
+			    RIO_EM_PW_TX_CTRL_PW_DIS);
 
 	/* Configure Port-Write notifications for hot-swap events */
 	tmp = RIO_GET_TOTAL_PORTS(rdev->swpinfo);
@@ -255,7 +256,7 @@ idtg3_em_handler(struct rio_dev *rdev, u
 				    rval | RIO_PLM_SPx_IMP_SPEC_CTL_SOFT_RST);
 		udelay(10);
 		rio_write_config_32(rdev, RIO_PLM_SPx_IMP_SPEC_CTL(pnum), rval);
-		mdelay(500);
+		msleep(500);
 	}
 
 	return 0;
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
rapidio-switches-add-driver-for-idt-gen3-switches-fix.patch

