From: akpm@linux-foundation.org
Subject: [merged] qnx4-use-hweight8.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:26 -0800
Message-ID: <200912162041.nBGKfQ6T013742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965038AbZLPUla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, al@alarsen.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     qnx4: use hweight8
has been removed from the -mm tree.  Its filename was
     qnx4-use-hweight8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: qnx4: use hweight8
From: Akinobu Mita <akinobu.mita@gmail.com>

Use hweight8 instead of counting for each bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Anders Larsen <al@alarsen.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx4/bitmap.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff -puN fs/qnx4/bitmap.c~qnx4-use-hweight8 fs/qnx4/bitmap.c
--- a/fs/qnx4/bitmap.c~qnx4-use-hweight8
+++ a/fs/qnx4/bitmap.c
@@ -28,22 +28,7 @@ static void count_bits(register const ch
 	}
 	do {
 		b = *bmPart++;
-		if ((b & 1) == 0)
-			tot++;
-		if ((b & 2) == 0)
-			tot++;
-		if ((b & 4) == 0)
-			tot++;
-		if ((b & 8) == 0)
-			tot++;
-		if ((b & 16) == 0)
-			tot++;
-		if ((b & 32) == 0)
-			tot++;
-		if ((b & 64) == 0)
-			tot++;
-		if ((b & 128) == 0)
-			tot++;
+		tot += 8 - hweight8(b);
 		size--;
 	} while (size != 0);
 	*tf = tot;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
x86-optimize-hweight32.patch
ntfs-use-bitmap_weight.patch

