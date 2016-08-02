From: akpm@linux-foundation.org
Subject: + powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix-fix.patch
 added to -mm tree
Date: Tue, 02 Aug 2016 12:27:08 -0700
Message-ID: <57a0f40c.3qXSNJZHtN2bi4mq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbcHBT1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 15:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mpe@ellerman.id.au, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fsl_rio: apply changes for RIO spec rev 3 fix2
has been added to the -mm tree.  Its filename is
     powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix-fix.patch

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
Subject: powerpc/fsl_rio: apply changes for RIO spec rev 3 fix2

corrects fix: https://lkml.org/lkml/2016/7/27/488

Link: http://lkml.kernel.org/r/20160802184932.2755-1-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix-fix arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix-fix
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -697,6 +697,9 @@ int fsl_rio_setup(struct platform_device
 			((i == 0) ? RIO_INB_ATMU_REGS_PORT1_OFFSET :
 			RIO_INB_ATMU_REGS_PORT2_OFFSET));
 
+		/* Set to receive packets with any dest ID */
+		out_be32((priv->regs_win + RIO_ISR_AACR + i*0x80),
+			 RIO_ISR_AACR_AA);
 
 		/* Configure maintenance transaction window */
 		out_be32(&priv->maint_atmu_regs->rowbar,
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
rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix-fix.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch
rapidio-switches-add-driver-for-idt-gen3-switches-fix.patch

