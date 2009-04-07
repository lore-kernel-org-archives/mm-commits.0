From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-remove-useless-asm-cplbinith.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:22 -0700
Message-ID: <200904071906.n37J6MTQ010788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760685AbZDGTKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: remove useless <asm/cplbinit.h>
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-remove-useless-asm-cplbinith.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: remove useless <asm/cplbinit.h>
From: Mike Frysinger <vapier.adi@gmail.com>

We already moved bfin_addr_dcachable() and friends into the cacheflush
header where it belongs, so don't need to include <asm/cplbinit.h> here.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-remove-useless-asm-cplbinith drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-remove-useless-asm-cplbinith
+++ a/drivers/spi/spi_bfin5xx.c
@@ -25,9 +25,6 @@
 #include <asm/dma.h>
 #include <asm/portmux.h>
 #include <asm/bfin5xx_spi.h>
