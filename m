From: akpm@linux-foundation.org
Subject: [folded-merged]
 rapidio-change-inbound-window-size-type-to-u64-fix.patch removed from -mm
 tree
Date: Tue, 02 Aug 2016 13:47:46 -0700
Message-ID: <57a106f2.hrC3zqdUuG2LlXw/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbcHBU46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mpe@ellerman.id.au, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: change inbound window size type to u64 fix
has been removed from the -mm tree.  Its filename was
     rapidio-change-inbound-window-size-type-to-u64-fix.patch

This patch was dropped because it was folded into rapidio-change-inbound-window-size-type-to-u64.patch

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: change inbound window size type to u64 fix

Fix for patch "rapidio: change inbound window size type to u64".

Remove compiler warning about size of constant.

Link: http://lkml.kernel.org/r/20160802184856.2566-1-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-change-inbound-window-size-type-to-u64-fix arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-change-inbound-window-size-type-to-u64-fix
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -298,7 +298,7 @@ int fsl_map_inb_mem(struct rio_mport *mp
 	u32 riwar;
 	int i;
 
-	if ((size & (size - 1)) != 0 || size > 0x400000000UL)
+	if ((size & (size - 1)) != 0 || size > 0x400000000ULL)
 		return -EINVAL;
 
 	base_size_log = ilog2(size);
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

