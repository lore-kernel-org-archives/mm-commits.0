From: akpm@linux-foundation.org
Subject: [merged] ipath-use-bitmap_weight.patch removed from -mm tree
Date: Fri, 11 Dec 2009 12:59:21 -0800
Message-ID: <200912112059.nBBKxLcS020163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762605AbZLKU7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Dec 2009 15:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, hal.rosenstock@gmail.com, infinipath@qlogic.com, rolandd@cisco.com, sean.hefty@intel.com, mm-commits@vger.kernel.org


The patch titled
     ipath: use bitmap_weight()
has been removed from the -mm tree.  Its filename was
     ipath-use-bitmap_weight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipath: use bitmap_weight()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use bitmap_weight() instead of finding all set bits in bitmap.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ralph Campbell <infinipath@qlogic.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ipath/ipath_driver.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/infiniband/hw/ipath/ipath_driver.c~ipath-use-bitmap_weight drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c~ipath-use-bitmap_weight
+++ a/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -39,6 +39,7 @@
 #include <linux/delay.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
+#include <linux/bitmap.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
@@ -1697,7 +1698,7 @@ void ipath_chg_pioavailkernel(struct ipa
 			      unsigned len, int avail)
 {
 	unsigned long flags;
-	unsigned end, cnt = 0, next;
+	unsigned end, cnt = 0;
 
 	/* There are two bits per send buffer (busy and generation) */
 	start *= 2;
@@ -1748,12 +1749,7 @@ void ipath_chg_pioavailkernel(struct ipa
 
 	if (dd->ipath_pioupd_thresh) {
 		end = 2 * (dd->ipath_piobcnt2k + dd->ipath_piobcnt4k);
-		next = find_first_bit(dd->ipath_pioavailkernel, end);
-		while (next < end) {
-			cnt++;
-			next = find_next_bit(dd->ipath_pioavailkernel, end,
-					next + 1);
-		}
+		cnt = bitmap_weight(dd->ipath_pioavailkernel, end);
 	}
 	spin_unlock_irqrestore(&ipath_pioavail_lock, flags);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
x86-optimize-hweight32.patch
ntfs-use-bitmap_weight.patch
hpfs-use-hweight32.patch
hpfs-use-bitmap_weight.patch
qnx4-use-hweight8.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

