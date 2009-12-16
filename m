From: akpm@linux-foundation.org
Subject: [merged] hpfs-use-bitmap_weight.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:11 -0800
Message-ID: <200912162037.nBGKbBlt013316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935491AbZLPUhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     hpfs: use bitmap_weight()
has been removed from the -mm tree.  Its filename was
     hpfs-use-bitmap_weight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
x86-optimize-hweight32.patch
ntfs-use-bitmap_weight.patch

