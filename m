From: akpm@linux-foundation.org
Subject: + lib-decompress_bunzip2c-fix-checkstack-warning.patch added to -mm tree
Date: Wed, 26 May 2010 16:55:20 -0700
Message-ID: <201005262355.o4QNtKF6022312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934747Ab0EZX4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 May 2010 19:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     lib/decompress_bunzip2.c: fix checkstack warning
has been added to the -mm tree.  Its filename is
     lib-decompress_bunzip2c-fix-checkstack-warning.patch

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
Subject: lib/decompress_bunzip2.c: fix checkstack warning
From: Prarit Bhargava <prarit@redhat.com>

Fix checkstack error:

lib/decompress_bunzip2.c: In function `get_next_block':
lib/decompress_bunzip2.c:511: warning: the frame size of 1932 bytes is larger than 1024 bytes

byteCount, symToByte, and mtfSymbol cannot be declared static or allocated
dynamically so place them in the bunzip_data struct.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN lib/decompress_bunzip2.c~lib-decompress_bunzip2c-fix-checkstack-warning lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~lib-decompress_bunzip2c-fix-checkstack-warning
+++ a/lib/decompress_bunzip2.c
@@ -107,6 +107,8 @@ struct bunzip_data {
 	unsigned char selectors[32768];		/* nSelectors = 15 bits */
 	struct group_data groups[MAX_GROUPS];	/* Huffman coding tables */
 	int io_error;			/* non-zero if we have IO error */
+	int byteCount[256];
+	unsigned char symToByte[256], mtfSymbol[256];
 };
 
 
@@ -158,14 +160,16 @@ static int INIT get_next_block(struct bu
 	int *base = NULL;
 	int *limit = NULL;
 	int dbufCount, nextSym, dbufSize, groupCount, selector,
-		i, j, k, t, runPos, symCount, symTotal, nSelectors,
-		byteCount[256];
-	unsigned char uc, symToByte[256], mtfSymbol[256], *selectors;
+		i, j, k, t, runPos, symCount, symTotal, nSelectors, *byteCount;
+	unsigned char uc, *symToByte, *mtfSymbol, *selectors;
 	unsigned int *dbuf, origPtr;
 
 	dbuf = bd->dbuf;
 	dbufSize = bd->dbufSize;
 	selectors = bd->selectors;
+	byteCount = bd->byteCount;
+	symToByte = bd->symToByte;
+	mtfSymbol = bd->mtfSymbol;
 
 	/* Read in header signature and CRC, then validate signature.
 	   (last block signature means CRC is for whole file, return now) */
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
lib-decompress_bunzip2c-fix-checkstack-warning.patch

