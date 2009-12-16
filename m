From: akpm@linux-foundation.org
Subject: [merged] hpfs-use-hweight32.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:08 -0800
Message-ID: <200912162037.nBGKb8r9013313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935487AbZLPUhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     hpfs: use hweight32
has been removed from the -mm tree.  Its filename was
     hpfs-use-hweight32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpfs: use hweight32
From: Akinobu Mita <akinobu.mita@gmail.com>

Use hweight32 instead of counting for each bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/super.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/hpfs/super.c~hpfs-use-hweight32 fs/hpfs/super.c
--- a/fs/hpfs/super.c~hpfs-use-hweight32
+++ a/fs/hpfs/super.c
@@ -119,11 +119,8 @@ unsigned hpfs_count_one_bitmap(struct su
 	unsigned i, count;
 	if (!(bits = hpfs_map_4sectors(s, secno, &qbh, 4))) return 0;
 	count = 0;
-	for (i = 0; i < 2048 / sizeof(unsigned); i++) {
-		unsigned b; 
-		if (!bits[i]) continue;
-		for (b = bits[i]; b; b>>=1) count += b & 1;
-	}
+	for (i = 0; i < 2048 / sizeof(unsigned); i++)
+		count += hweight32(bits[i]);
 	hpfs_brelse4(&qbh);
 	return count;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
x86-optimize-hweight32.patch
ntfs-use-bitmap_weight.patch

