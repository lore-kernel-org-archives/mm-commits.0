From: akpm@linux-foundation.org
Subject: [merged] uwb-use-for_each_clear_bit.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:20 -0700
Message-ID: <20120326192920.62967A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62426 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:21 -0400
Received: by yenq2 with SMTP id q2so832015yen.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, david.vrabel@csr.com, stefano.panella@csr.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uwb: use for_each_clear_bit()
has been removed from the -mm tree.  Its filename was
     uwb-use-for_each_clear_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: uwb: use for_each_clear_bit()

Use for_each_clear_bit() to iterate over all the cleared bit in a
memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stefano Panella <stefano.panella@csr.com>
Cc: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uwb/allocator.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/uwb/allocator.c~uwb-use-for_each_clear_bit drivers/uwb/allocator.c
--- a/drivers/uwb/allocator.c~uwb-use-for_each_clear_bit
+++ a/drivers/uwb/allocator.c
@@ -334,10 +334,8 @@ int uwb_rsv_find_best_allocation(struct 
 
 
 	/* fill the not available vector from the available bm */
-	for (bit_index = 0; bit_index < UWB_NUM_MAS; bit_index++) {
-		if (!test_bit(bit_index, available->bm))
-			ai->bm[bit_index] = UWB_RSV_MAS_NOT_AVAIL;
-	}
+	for_each_clear_bit(bit_index, available->bm, UWB_NUM_MAS)
+		ai->bm[bit_index] = UWB_RSV_MAS_NOT_AVAIL;
 
 	if (ai->max_interval == 1) {
 		get_row_descriptors(ai);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
sysctl-use-bitmap-library-functions.patch

