From: akpm@linux-foundation.org
Subject: + fpga-zynq-fpga-fix-build-failure.patch added to -mm tree
Date: Fri, 27 May 2016 12:56:44 -0700
Message-ID: <5748a67c.I07VPWUyfe1oxaPm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbcE0T4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 15:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, atull@opensource.altera.com, moritz.fischer@ettus.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/fpga/Kconfig: fix build failure
has been added to the -mm tree.  Its filename is
     fpga-zynq-fpga-fix-build-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fpga-zynq-fpga-fix-build-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fpga-zynq-fpga-fix-build-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: drivers/fpga/Kconfig: fix build failure

While building m32r allmodconfig the build is failing with the error:
ERROR: "bad_dma_ops" [drivers/fpga/zynq-fpga.ko] undefined!

Xilinx Zynq FPGA is using DMA but there was no dependency while
building.

Link: http://lkml.kernel.org/r/1464346526-13913-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Cc: Alan Tull <atull@opensource.altera.com>
Cc: Moritz Fischer <moritz.fischer@ettus.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/fpga/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/fpga/Kconfig~fpga-zynq-fpga-fix-build-failure drivers/fpga/Kconfig
--- a/drivers/fpga/Kconfig~fpga-zynq-fpga-fix-build-failure
+++ a/drivers/fpga/Kconfig
@@ -21,6 +21,7 @@ config FPGA_MGR_SOCFPGA
 
 config FPGA_MGR_ZYNQ_FPGA
 	tristate "Xilinx Zynq FPGA"
+	depends on HAS_DMA
 	help
 	  FPGA manager driver support for Xilinx Zynq FPGAs.
 
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

fpga-zynq-fpga-fix-build-failure.patch

