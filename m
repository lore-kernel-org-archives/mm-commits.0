From: akpm@linux-foundation.org
Subject: + drivers-edac-new-intel-5000-mc-driver-fix.patch added to -mm tree
Date: Wed, 06 Jun 2007 18:57:03 -0700
Message-ID: <200706070157.l571v3FF018329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57127 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764962AbXFGB5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 21:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, ericw@xmtp.net, norsk5@xmission.com


The patch titled
     edac i5000 parenthesis balance fix
has been added to the -mm tree.  Its filename is
     drivers-edac-new-intel-5000-mc-driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: edac i5000 parenthesis balance fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Eric Wollesen <ericw@xmtp.net>
Cc: Doug Thompson <norsk5@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/i5000_edac.c~drivers-edac-new-intel-5000-mc-driver-fix drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~drivers-edac-new-intel-5000-mc-driver-fix
+++ a/drivers/edac/i5000_edac.c
@@ -277,7 +277,7 @@
 #define MTR_DRAM_BANKS(mtr)		((((mtr) >> 5) & 0x1) ? 8 : 4)
 #define MTR_DRAM_BANKS_ADDR_BITS(mtr)	((MTR_DRAM_BANKS(mtr) == 8) ? 3 : 2)
 #define MTR_DIMM_RANK(mtr)		(((mtr) >> 4) & 0x1)
-#define MTR_DIMM_RANK_ADDR_BITS(mtr)	((MTR_DIM_RANKS(mtr) ? 2 : 1)
+#define MTR_DIMM_RANK_ADDR_BITS(mtr)	(MTR_DIM_RANKS(mtr) ? 2 : 1)
 #define MTR_DIMM_ROWS(mtr)		(((mtr) >> 2) & 0x3)
 #define MTR_DIMM_ROWS_ADDR_BITS(mtr)	(MTR_DIMM_ROWS(mtr) + 13)
 #define MTR_DIMM_COLS(mtr)		((mtr) & 0x3)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

dm-add-missing-braces-in-driver-debug-code.patch
arm26-remove-broken-and-unused-macro.patch
drivers-edac-new-intel-5000-mc-driver-fix.patch
