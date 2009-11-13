From: akpm@linux-foundation.org
Subject: + qnx4-use-hweight8.patch added to -mm tree
Date: Fri, 13 Nov 2009 15:31:06 -0800
Message-ID: <200911132331.nADNV621022149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414AbZKMXbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 18:31:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, al@alarsen.net, viro@zeniv.linux.org.uk


The patch titled
     qnx4: use hweight8
has been added to the -mm tree.  Its filename is
     qnx4-use-hweight8.patch

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

linux-next.patch
qnx4-use-hweight8.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

