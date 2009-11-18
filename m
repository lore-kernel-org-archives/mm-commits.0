From: akpm@linux-foundation.org
Subject: + hpfs-use-bitmap_weight.patch added to -mm tree
Date: Wed, 18 Nov 2009 12:27:45 -0800
Message-ID: <200911182027.nAIKRjrh026849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932287AbZKRU1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Nov 2009 15:27:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk


The patch titled
     hpfs: use bitmap_weight()
has been added to the -mm tree.  Its filename is
     hpfs-use-bitmap_weight.patch

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
Subject: hpfs: use bitmap_weight()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use bitmap_weight instead of doing hweight32 for each 32bit in bitmap.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/super.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/hpfs/super.c~hpfs-use-bitmap_weight fs/hpfs/super.c
--- a/fs/hpfs/super.c~hpfs-use-bitmap_weight
+++ a/fs/hpfs/super.c
@@ -14,6 +14,7 @@
 #include <linux/magic.h>
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
+#include <linux/bitmap.h>
 
 /* Mark the filesystem dirty, so that chkdsk checks it when os/2 booted */
 
@@ -115,12 +116,13 @@ static void hpfs_put_super(struct super_
 unsigned hpfs_count_one_bitmap(struct super_block *s, secno secno)
 {
 	struct quad_buffer_head qbh;
-	unsigned *bits;
-	unsigned i, count;
-	if (!(bits = hpfs_map_4sectors(s, secno, &qbh, 4))) return 0;
-	count = 0;
-	for (i = 0; i < 2048 / sizeof(unsigned); i++)
-		count += hweight32(bits[i]);
+	unsigned long *bits;
+	unsigned count;
+
+	bits = hpfs_map_4sectors(s, secno, &qbh, 4);
+	if (!bits)
+		return 0;
+	count = bitmap_weight(bits, 2048 * BITS_PER_BYTE);
 	hpfs_brelse4(&qbh);
 	return count;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
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

