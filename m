From: akpm@linux-foundation.org
Subject: + mmc-prepare-tmio_mmc-for-passing-of-dma-configuration-from-the-mfd-cell.patch added to -mm tree
Date: Thu, 13 May 2010 15:04:31 -0700
Message-ID: <201005132204.o4DM4V4F023159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab0EMWFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 18:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, dan.j.williams@intel.com, ian@mnementh.co.uk, lethal@linux-sh.org, magnus.damm@gmail.com, rmk@arm.linux.org.uk, sameo@linux.intel.com


The patch titled
     mmc: prepare tmio_mmc for passing of DMA configuration from the MFD cell
has been added to the -mm tree.  Its filename is
     mmc-prepare-tmio_mmc-for-passing-of-dma-configuration-from-the-mfd-cell.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: prepare tmio_mmc for passing of DMA configuration from the MFD cell
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

After this patch, if the "dma" pointer in struct tmio_mmc_data is not
NULL, it points to a struct, containing two tokens, that have to be passed
to the dmaengine driver for channel configuration.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mfd/tmio.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/mfd/tmio.h~mmc-prepare-tmio_mmc-for-passing-of-dma-configuration-from-the-mfd-cell include/linux/mfd/tmio.h
--- a/include/linux/mfd/tmio.h~mmc-prepare-tmio_mmc-for-passing-of-dma-configuration-from-the-mfd-cell
+++ a/include/linux/mfd/tmio.h
@@ -55,12 +55,18 @@ int tmio_core_mmc_resume(void __iomem *c
 void tmio_core_mmc_pwr(void __iomem *cnf, int shift, int state);
 void tmio_core_mmc_clk_div(void __iomem *cnf, int shift, int state);
 
+struct tmio_mmc_dma {
+	void *chan_priv_tx;
+	void *chan_priv_rx;
+};
+
 /*
  * data for the MMC controller
  */
 struct tmio_mmc_data {
 	unsigned int			hclk;
 	unsigned long			capabilities;
+	struct tmio_mmc_dma		*dma;
 	void (*set_pwr)(struct platform_device *host, int state);
 	void (*set_clk_div)(struct platform_device *host, int state);
 };
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header.patch
sh-add-dma-slaves-for-two-sdhi-controllers-to-sh7722.patch
sh-add-dma-slave-definitions-to-sh7724.patch
mmc-prepare-tmio_mmc-for-passing-of-dma-configuration-from-the-mfd-cell.patch
sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc.patch
mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh.patch
sh-add-sdhi-dma-support-to-ecovec.patch
sh-add-sdhi-dma-support-to-ms7724se.patch
sh-add-sdhi-dma-support-to-kfr2r09.patch
sh-add-sdhi-dma-support-to-migor.patch
arm-add-dma-support-to-sh7372-enable-dma-for-sdhi.patch

