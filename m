From: akpm@linux-foundation.org
Subject: + mfd-fix-a-bug-in-the-asic3-irq-demux-code.patch added to -mm tree
Date: Wed, 02 Jul 2008 10:51:20 -0700
Message-ID: <200807021751.m62HpKAw028511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbYGBRvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 13:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com, sameo@openedhand.com


The patch titled
     mfd: fix a bug in the asic3 irq demux code
has been added to the -mm tree.  Its filename is
     mfd-fix-a-bug-in-the-asic3-irq-demux-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: fix a bug in the asic3 irq demux code
From: Philipp Zabel <philipp.zabel@gmail.com>

Wrong irq numbers were given to desc->handle_irq, which on some devices
caused endless loops (asic3_irq_demux calling itself, basically).

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/asic3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/asic3.c~mfd-fix-a-bug-in-the-asic3-irq-demux-code drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~mfd-fix-a-bug-in-the-asic3-irq-demux-code
+++ a/drivers/mfd/asic3.c
@@ -137,7 +137,7 @@ static void asic3_irq_demux(unsigned int
 		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
 			/* They start at bit 4 and go up */
 			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
-				desc = irq_desc +  + i;
+				desc = irq_desc + asic->irq_base + i;
 				desc->handle_irq(asic->irq_base + i,
 						 desc);
 			}
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

w100fb-do-not-depend-on-sharpsl.patch
w100fb-add-80-mhz-modeline.patch
mfd-maintainer.patch
linux-next.patch
asic3-new-gpio-configuration-code-fix-asic3-config-array-initialisation.patch
mfd-move-asic3-probe-functions-into-__init-section.patch
mfd-fix-a-bug-in-the-asic3-irq-demux-code.patch

