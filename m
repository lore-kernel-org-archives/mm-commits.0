From: akpm@linux-foundation.org
Subject: + hpfs-use-hweight32.patch added to -mm tree
Date: Fri, 13 Nov 2009 15:32:59 -0800
Message-ID: <200911132332.nADNWxbq026649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932506AbZKMXc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 18:32:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk


The patch titled
     hpfs: use hweight32
has been added to the -mm tree.  Its filename is
     hpfs-use-hweight32.patch

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

linux-next.patch
hpfs-use-hweight32.patch
qnx4-use-hweight8.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

