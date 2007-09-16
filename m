From: akpm@linux-foundation.org
Subject: + lib-iomapcbad_io_access-print-0x-hex-prefix.patch added to -mm tree
Date: Sat, 15 Sep 2007 22:39:27 -0700
Message-ID: <200709160539.l8G5dRtH002152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbXIPFjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:39:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@gmail.com


The patch titled
     lib/iomap.c:bad_io_access(): print 0x hex prefix
has been added to the -mm tree.  Its filename is
     lib-iomapcbad_io_access-print-0x-hex-prefix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib/iomap.c:bad_io_access(): print 0x hex prefix
From: Rene Herman <rene.herman@gmail.com>

Be explicit about printing hex.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/iomap.c~lib-iomapcbad_io_access-print-0x-hex-prefix lib/iomap.c
--- a/lib/iomap.c~lib-iomapcbad_io_access-print-0x-hex-prefix
+++ a/lib/iomap.c
@@ -40,7 +40,7 @@ static void bad_io_access(unsigned long 
 	static int count = 10;
 	if (count) {
 		count--;
-		printk(KERN_ERR "Bad IO access at port %lx (%s)\n", port, access);
+		printk(KERN_ERR "Bad IO access at port %#lx (%s)\n", port, access);
 		WARN_ON(1);
 	}
 }
_

Patches currently in -mm which might be from rene.herman@gmail.com are

git-alsa.patch
lib-iomapcbad_io_access-print-0x-hex-prefix.patch
