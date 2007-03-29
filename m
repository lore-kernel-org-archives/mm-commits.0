From: akpm@linux-foundation.org
Subject: - atl1-remove-unnecessary-crc-inversion.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:43:23 -0700
Message-ID: <200703290743.l2T7hNxq030379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46238 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965254AbXC2Hnd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacliburn@bellsouth.net, jareguero@telefonica.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     atl1: remove unnecessary crc inversion
has been removed from the -mm tree.  Its filename was
     atl1-remove-unnecessary-crc-inversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atl1: remove unnecessary crc inversion
From: Jay Cliburn <jacliburn@bellsouth.net>

The original vendor driver contained a private ether_crc_le() function that
produced an inverted crc.  When we changed to the kernel version of
ether_crc_le(), we neglected to undo the inversion.  Let's do it now. 
Discovered by and patch proffered by Jose Alberto Reguero.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_hw.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/atl1/atl1_hw.c~atl1-remove-unnecessary-crc-inversion drivers/net/atl1/atl1_hw.c
--- a/drivers/net/atl1/atl1_hw.c~atl1-remove-unnecessary-crc-inversion
+++ a/drivers/net/atl1/atl1_hw.c
@@ -334,7 +334,6 @@ u32 atl1_hash_mc_addr(struct atl1_hw *hw
 	int i;
 
 	crc32 = ether_crc_le(6, mc_addr);
-	crc32 = ~crc32;
 	for (i = 0; i < 32; i++)
 		value |= (((crc32 >> i) & 1) << (31 - i));
 
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

origin.patch
