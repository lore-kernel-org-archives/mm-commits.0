From: akpm@linux-foundation.org
Subject: + avr32-linux-at32ap700x-set-dma-slave-properties-for-mci-dw_dmac.patch added to -mm tree
Date: Fri, 31 Aug 2012 16:44:54 -0700
Message-ID: <20120831234455.AE3F820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:65391 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2HaXo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 19:44:58 -0400
Received: by weyr1 with SMTP id r1so177084wey.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 16:44:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hein_tibosch@yahoo.es, arnd.bergmann@linaro.org, egtvedt@samfundet.no, havard@skinnemoen.net, nicolas.ferre@atmel.com


The patch titled
     Subject: avr32-linux: at32ap700x: set DMA slave properties for MCI dw_dmac
has been added to the -mm tree.  Its filename is
     avr32-linux-at32ap700x-set-dma-slave-properties-for-mci-dw_dmac.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hein Tibosch <hein_tibosch@yahoo.es>
Subject: avr32-linux: at32ap700x: set DMA slave properties for MCI dw_dmac

The MCI makes use of the dw_dmac driver when DMA is being used.  Due to
recent changes the driver was broken because:

- the SMS field in the CTLL register received the wrong value 0

- a patch in dw_dmac allowed for 64-bit transfers on the memory side,
  giving an illegal value of 3 in the SRC/DST_TR_WIDTH register.

This patch sets the SMS to 1 and limits the maximum transfer width to 2
(32 bits)

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Havard Skinnemoen <havard@skinnemoen.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mach-at32ap/at32ap700x.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/avr32/mach-at32ap/at32ap700x.c~avr32-linux-at32ap700x-set-dma-slave-properties-for-mci-dw_dmac arch/avr32/mach-at32ap/at32ap700x.c
--- a/arch/avr32/mach-at32ap/at32ap700x.c~avr32-linux-at32ap700x-set-dma-slave-properties-for-mci-dw_dmac
+++ a/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1355,6 +1355,10 @@ at32_add_device_mci(unsigned int id, str
 				| DWC_CFGH_DST_PER(1));
 	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
 				| DWC_CFGL_HS_SRC_POL);
+	/* Give CTLL SMS value 1 */
+	slave->sdata.src_master = 1;
+	/* SRC/DST_TR_WIDTH register only accepts 0,1,2 */
+	slave->sdata.max_mem_width = 2;
 
 	data->dma_slave = slave;
 
_

Patches currently in -mm which might be from hein_tibosch@yahoo.es are

dw_dmac-make-driver-endianness-configurable.patch
avr32-linux-at32ap700x-set-dma-slave-properties-for-mci-dw_dmac.patch
lib-decompressc-add-__init-to-decompress_method-and-data.patch

