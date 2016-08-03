From: akpm@linux-foundation.org
Subject: [patch 01/18] drivers/fpga/Kconfig: fix build failure
Date: Wed, 03 Aug 2016 13:45:46 -0700
Message-ID: <57a257fa.XSlT26U7HzEaBxvL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606AbcHCUpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, atull@opensource.altera.com, moritz.fischer@ettus.com, sudip.mukherjee@codethink.co.uk

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: drivers/fpga/Kconfig: fix build failure

While building m32r allmodconfig the build is failing with the error:
ERROR: "bad_dma_ops" [drivers/fpga/zynq-fpga.ko] undefined!

Xilinx Zynq FPGA is using DMA but there was no dependency while
building.

Link: http://lkml.kernel.org/r/1464346526-13913-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Acked-by: Moritz Fischer <moritz.fischer@ettus.com>
Cc: Alan Tull <atull@opensource.altera.com>
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
