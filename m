From: akpm@linux-foundation.org
Subject: + cramfs-propagate-uncompression-errors.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:16:39 -0800
Message-ID: <200902092316.n19NGd9r028906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbZBIXRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dvomlehn@cisco.com


The patch titled
     cramfs: propagate uncompression errors
has been added to the -mm tree.  Its filename is
     cramfs-propagate-uncompression-errors.patch

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
Subject: cramfs: propagate uncompression errors
From: David VomLehn <dvomlehn@cisco.com>

If cramfs_uncompress_block() detects an error uncompressing it will return
a zero value.  This patch checks the return value and propagates the error
back up to the block layer.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN fs/cramfs/inode.c~cramfs-propagate-uncompression-errors fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-propagate-uncompression-errors
+++ a/fs/cramfs/inode.c
@@ -488,12 +488,19 @@ static int cramfs_readpage(struct file *
 				 compr_len);
 			mutex_unlock(&read_mutex);
 		}
-	} else
-		pgdata = kmap(page);
-	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
-	kunmap(page);
-	flush_dcache_page(page);
-	SetPageUptodate(page);
+
+		if (bytes_filled == 0) {
+			/* Decompression error */
+			ClearPageUptodate(page);
+			SetPageError(page);
+		} else {
+			memset(pgdata + bytes_filled, 0,
+					PAGE_CACHE_SIZE - bytes_filled);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+		}
+		kunmap(page);
+	}
 	unlock_page(page);
 	return 0;
 }
_

Patches currently in -mm which might be from dvomlehn@cisco.com are

cramfs-propagate-uncompression-errors.patch

