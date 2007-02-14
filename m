From: akpm@linux-foundation.org
Subject: + fix-atl1-braino.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:46:07 -0800
Message-ID: <200702142146.l1ELkiDY010259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47496 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781AbXBNVrU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:47:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, jeff@garzik.org, viro@zeniv.linux.org.uk


The patch titled
     fix atl1 braino
has been added to the -mm tree.  Its filename is
     fix-atl1-braino.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-atl1-braino.patch
slab-leaks3-default-y.patch
