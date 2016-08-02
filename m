From: akpm@linux-foundation.org
Subject: + rapidio-change-inbound-window-size-type-to-u64-fix.patch added
 to -mm tree
Date: Tue, 02 Aug 2016 12:27:39 -0700
Message-ID: <57a0f42b.wNs/lW5ygdJAhIMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbcHBT2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 15:28:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mpe@ellerman.id.au, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: change inbound window size type to u64 fix
has been added to the -mm tree.  Its filename is
     rapidio-change-inbound-window-size-type-to-u64-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-change-inbound-window-size-type-to-u64-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-change-inbound-window-size-type-to-u64-fix.patch

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
rapidio-change-inbound-window-size-type-to-u64-fix.patch
rapidio-modify-for-rev3-specification-changes.patch
rapidio-modify-for-rev3-specification-changes-fix-docbook-warning-for-gen3-update.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix-fix.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch
rapidio-switches-add-driver-for-idt-gen3-switches-fix.patch

