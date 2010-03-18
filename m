From: akpm@linux-foundation.org
Subject: [merged] atm-use-for_each_set_bit.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:08:55 -0400
Message-ID: <201003181809.o2II9aCw007580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897Ab0CRSRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, chas@cmf.nrl.navy.mil, mm-commits@vger.kernel.org


The patch titled
     atm: use for_each_set_bit()
has been removed from the -mm tree.  Its filename was
     atm-use-for_each_set_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atm: use for_each_set_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/lanai.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/atm/lanai.c~atm-use-for_each_set_bit drivers/atm/lanai.c
--- a/drivers/atm/lanai.c~atm-use-for_each_set_bit
+++ a/drivers/atm/lanai.c
@@ -306,11 +306,10 @@ static void vci_bitfield_iterate(struct 
 	const unsigned long *lp,
 	void (*func)(struct lanai_dev *,vci_t vci))
 {
-	vci_t vci = find_first_bit(lp, NUM_VCI);
-	while (vci < NUM_VCI) {
+	vci_t vci;
+
+	for_each_set_bit(vci, lp, NUM_VCI)
 		func(lanai, vci);
-		vci = find_next_bit(lp, NUM_VCI, vci + 1);
-	}
 }
 
 /* -------------------- BUFFER  UTILITIES: */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
ntfs-use-bitmap_weight.patch
hpet-use-for_each_set_bit.patch
linux-next.patch
intel-iommu-use-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
bitops-remove-temporary-for_each_bit.patch

