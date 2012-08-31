From: akpm@linux-foundation.org
Subject: [to-be-updated] avr32-linux-at32ap700x-set-dma-slave-properties-for-mci-dw_dmac.patch removed from -mm tree
Date: Fri, 31 Aug 2012 16:50:26 -0700
Message-ID: <20120831235026.CDAD61E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63117 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2HaXu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 19:50:27 -0400
Received: by yhl10 with SMTP id 10so406155yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 16:50:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hein_tibosch@yahoo.es, arnd.bergmann@linaro.org, egtvedt@samfundet.no, havard@skinnemoen.net, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32-linux: at32ap700x: set DMA slave properties for MCI dw_dmac
has been removed from the -mm tree.  Its filename was
     avr32-linux-at32ap700x-set-dma-slave-properties-for-mci-dw_dmac.patch

This patch was dropped because an updated version will be merged

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

lib-decompressc-add-__init-to-decompress_method-and-data.patch

