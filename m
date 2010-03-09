From: akpm@linux-foundation.org
Subject: [merged] bitmap-use-for_each_set_bit.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:37 -0800
Message-ID: <201003091907.o29J7bXV031351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754463Ab0CITV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:21:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     bitmap: use for_each_set_bit()
has been removed from the -mm tree.  Its filename was
     bitmap-use-for_each_set_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitmap: use for_each_set_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN lib/bitmap.c~bitmap-use-for_each_set_bit lib/bitmap.c
--- a/lib/bitmap.c~bitmap-use-for_each_set_bit
+++ a/lib/bitmap.c
@@ -733,10 +733,9 @@ void bitmap_remap(unsigned long *dst, co
 	bitmap_zero(dst, bits);
 
 	w = bitmap_weight(new, bits);
-	for (oldbit = find_first_bit(src, bits);
-	     oldbit < bits;
-	     oldbit = find_next_bit(src, bits, oldbit + 1)) {
+	for_each_set_bit(oldbit, src, bits) {
 	     	int n = bitmap_pos_to_ord(old, oldbit, bits);
+
 		if (n < 0 || w == 0)
 			set_bit(oldbit, dst);	/* identity map */
 		else
@@ -903,9 +902,7 @@ void bitmap_onto(unsigned long *dst, con
 	 */
 
 	m = 0;
-	for (n = find_first_bit(relmap, bits);
-	     n < bits;
-	     n = find_next_bit(relmap, bits, n + 1)) {
+	for_each_set_bit(n, relmap, bits) {
 		/* m == bitmap_pos_to_ord(relmap, n, bits) */
 		if (test_bit(m, orig))
 			set_bit(n, dst);
@@ -934,9 +931,7 @@ void bitmap_fold(unsigned long *dst, con
 		return;
 	bitmap_zero(dst, bits);
 
-	for (oldbit = find_first_bit(orig, bits);
-	     oldbit < bits;
-	     oldbit = find_next_bit(orig, bits, oldbit + 1))
+	for_each_set_bit(oldbit, orig, bits)
 		set_bit(oldbit % sz, dst);
 }
 EXPORT_SYMBOL(bitmap_fold);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
ntfs-use-bitmap_weight.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
sgi-gru-use-for_each_set_bit.patch
bitops-remove-temporary-for_each_bit.patch

