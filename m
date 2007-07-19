From: akpm@linux-foundation.org
Subject: - driver-edac-i5000-define-typo.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:53 -0700
Message-ID: <200707192006.l6JK6r1a020205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbXGSUPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: i5000 define typo
has been removed from the -mm tree.  Its filename was
     driver-edac-i5000-define-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: i5000 define typo
From: Marisuz Kozlowski <m.kozlowski@tuxland.pl>

Found a typo in one of the #defines in the driver

MTR_DIM_RANKS --> MTR_DIMM_RANK

Signed-off-by: Marisuz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/i5000_edac.c~driver-edac-i5000-define-typo drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~driver-edac-i5000-define-typo
+++ a/drivers/edac/i5000_edac.c
@@ -279,7 +279,7 @@
 #define MTR_DRAM_BANKS(mtr)		((((mtr) >> 5) & 0x1) ? 8 : 4)
 #define MTR_DRAM_BANKS_ADDR_BITS(mtr)	((MTR_DRAM_BANKS(mtr) == 8) ? 3 : 2)
 #define MTR_DIMM_RANK(mtr)		(((mtr) >> 4) & 0x1)
-#define MTR_DIMM_RANK_ADDR_BITS(mtr)	(MTR_DIM_RANKS(mtr) ? 2 : 1)
+#define MTR_DIMM_RANK_ADDR_BITS(mtr)	(MTR_DIMM_RANK(mtr) ? 2 : 1)
 #define MTR_DIMM_ROWS(mtr)		(((mtr) >> 2) & 0x3)
 #define MTR_DIMM_ROWS_ADDR_BITS(mtr)	(MTR_DIMM_ROWS(mtr) + 13)
 #define MTR_DIMM_COLS(mtr)		((mtr) & 0x3)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
powerpc-tlb_32c-build-fix.patch
mtd-add-module-license-to-mtdbdi.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
