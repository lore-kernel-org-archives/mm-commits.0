From: akpm@linux-foundation.org
Subject: + driver-edac-i5000-define-typo.patch added to -mm tree
Date: Fri, 08 Jun 2007 12:40:39 -0700
Message-ID: <200706081940.l58JedlS009877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968950AbXFHTku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 15:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, dougthompson@xmission.com


The patch titled
     drivers/edac: i5000 define typo
has been added to the -mm tree.  Its filename is
     driver-edac-i5000-define-typo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

arm26-remove-broken-and-unused-macro.patch
drivers-edac-new-intel-5000-mc-driver-fix.patch
driver-edac-i5000-define-typo.patch
