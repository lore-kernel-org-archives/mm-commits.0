From: akpm@linux-foundation.org
Subject: - fix-atl1-braino.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:14:50 -0800
Message-ID: <200702180214.l1I2Eov6008313@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55680 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993113AbXBRCP3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, jeff@garzik.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix atl1 braino
has been removed from the -mm tree.  Its filename was
     fix-atl1-braino.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix atl1 braino
From: Al Viro <viro@ftp.linux.org.uk>

Spot the bug...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_hw.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/atl1/atl1_hw.c~fix-atl1-braino drivers/net/atl1/atl1_hw.c
--- a/drivers/net/atl1/atl1_hw.c~fix-atl1-braino
+++ a/drivers/net/atl1/atl1_hw.c
@@ -357,7 +357,7 @@ void atl1_hash_set(struct atl1_hw *hw, u
 	 */
 	hash_reg = (hash_value >> 31) & 0x1;
 	hash_bit = (hash_value >> 26) & 0x1F;
-	mta = ioread32((hw + REG_RX_HASH_TABLE) + (hash_reg << 2));
+	mta = ioread32((hw->hw_addr + REG_RX_HASH_TABLE) + (hash_reg << 2));
 	mta |= (1 << hash_bit);
 	iowrite32(mta, (hw->hw_addr + REG_RX_HASH_TABLE) + (hash_reg << 2));
 }
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
git-acpi.patch
slab-leaks3-default-y.patch
