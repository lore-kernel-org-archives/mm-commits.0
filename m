From: akpm@linux-foundation.org
Subject: + bitmap-fix-calculation-of-bitmap_scnprintf_len.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:51:15 -0700
Message-ID: <200804272051.m3RKpFvu024271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764443AbYD0Uvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bert.wesarg@googlemail.com, mingo@elte.hu, pj@sgi.com, travis@sgi.com


The patch titled
     bitmap: Fix calculation of bitmap_scnprintf_len()
has been added to the -mm tree.  Its filename is
     bitmap-fix-calculation-of-bitmap_scnprintf_len.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitmap: Fix calculation of bitmap_scnprintf_len()
From: Bert Wesarg <bert.wesarg@googlemail.com>

The function bitmap_scnprintf_len() is currently not used, but the returned
value is 4 times larger than needed.  This value is also only a good upper
bound.  Which should be mentioned in the comment.

The correct number of chars needed for the buffer, exluding any new line and
terminating zero is:

int bitmap_scnprintf_len(int len)
{
	return  /* complete hunks with commas */
	          ((len / CHUNKSZ) * 9)
	        /* partial hunk, 4 bits in one char */
	       + (((len % CHUNKSZ) + 3) / 4)
	        /* one less comma, if no partial hunk */
	       -  !(len % CHUNKSZ);
}

Signed-off-by: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~bitmap-fix-calculation-of-bitmap_scnprintf_len lib/bitmap.c
--- a/lib/bitmap.c~bitmap-fix-calculation-of-bitmap_scnprintf_len
+++ a/lib/bitmap.c
@@ -325,7 +325,7 @@ int bitmap_scnprintf_len(unsigned int le
 	/* we need 9 chars per word for 32 bit words (8 hexdigits + sep/null) */
 	int bitslen = ALIGN(len, CHUNKSZ);
 	int wordlen = CHUNKSZ / 4;
-	int buflen = (bitslen / wordlen) * (wordlen + 1) * sizeof(char);
+	int buflen = (bitslen / CHUNKSZ) * (wordlen + 1);
 
 	return buflen;
 }
_

Patches currently in -mm which might be from bert.wesarg@googlemail.com are

bitmap-fix-calculation-of-bitmap_scnprintf_len.patch

