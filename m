From: akpm@linux-foundation.org
Subject: + bitmap-use-for_each_set_bit.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:28:12 -0800
Message-ID: <201002012228.o11MSCko016397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324Ab0BAW2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:28:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     bitmap: use for_each_set_bit()
has been added to the -mm tree.  Its filename is
     bitmap-use-for_each_set_bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
fault-injection-correct-function-names-in-documentation.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
infiniband-use-for_each_set_bit.patch
ntfs-use-bitmap_weight.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
sched-use-for_each_set_bit.patch
bitmap-use-for_each_set_bit.patch
sgi-gru-use-for_each_set_bit.patch

