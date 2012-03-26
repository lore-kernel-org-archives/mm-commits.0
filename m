From: akpm@linux-foundation.org
Subject: [merged] mtd-use-for_each_clear_bit.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:16 -0700
Message-ID: <20120326192916.4F934A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63241 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:18 -0400
Received: by wejx9 with SMTP id x9so290130wej.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mtd: use for_each_clear_bit()
has been removed from the -mm tree.  Its filename was
     mtd-use-for_each_clear_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mtd: use for_each_clear_bit()

Use for_each_clear_bit() to iterate over all the cleared bit in a
memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~mtd-use-for_each_clear_bit drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~mtd-use-for_each_clear_bit
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -2526,12 +2526,10 @@ static void cfi_intelext_restore_locks(s
 		if (!region->lockmap)
 			continue;
 
-		for (block = 0; block < region->numblocks; block++) {
+		for_each_clear_bit(block, region->lockmap, region->numblocks) {
 			len = region->erasesize;
 			adr = region->offset + block * len;
