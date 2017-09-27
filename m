From: akpm@linux-foundation.org
Subject: + lib-lz4-make-arrays-static-const-reduces-object-code-size.patch added to -mm tree
Date: Tue, 26 Sep 2017 17:00:58 -0700
Message-ID: <59caea3a.CnY8r9s4hMpVkBsW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030518AbdI0AA7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2017 20:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, 4sschmid@informatik.uni-hamburg.de, arnd@arndb.de, christophe.jaillet@wanadoo.fr, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lz4: make arrays static const, reduces object code size
has been added to the -mm tree.  Its filename is
     lib-lz4-make-arrays-static-const-reduces-object-code-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-lz4-make-arrays-static-const-reduces-object-code-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-lz4-make-arrays-static-const-reduces-object-code-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: lib/lz4: make arrays static const, reduces object code size

Don't populate the read-only arrays dec32table and dec64table on the
stack, instead make them both static const.  Makes the object code smaller
by over 10K bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  31500	      0	      0	  31500	   7b0c	lib/lz4/lz4_decompress.o

After:
   text	   data	    bss	    dec	    hex	filename
  20237	    176	      0	  20413	   4fbd	lib/lz4/lz4_decompress.o

(gcc version 7.2.0 x86_64)

Link: http://lkml.kernel.org/r/20170921221939.20820-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/lz4/lz4_decompress.c~lib-lz4-make-arrays-static-const-reduces-object-code-size lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-lz4-make-arrays-static-const-reduces-object-code-size
+++ a/lib/lz4/lz4_decompress.c
@@ -85,8 +85,8 @@ static FORCE_INLINE int LZ4_decompress_g
 	const BYTE * const lowLimit = lowPrefix - dictSize;
 
 	const BYTE * const dictEnd = (const BYTE *)dictStart + dictSize;
-	const unsigned int dec32table[] = { 0, 1, 2, 1, 4, 4, 4, 4 };
-	const int dec64table[] = { 0, 0, 0, -1, 0, 1, 2, 3 };
+	static const unsigned int dec32table[] = { 0, 1, 2, 1, 4, 4, 4, 4 };
+	static const int dec64table[] = { 0, 0, 0, -1, 0, 1, 2, 3 };
 
 	const int safeDecode = (endOnInput == endOnInputSize);
 	const int checkOffset = ((safeDecode) && (dictSize < (int)(64 * KB)));
_

Patches currently in -mm which might be from colin.king@canonical.com are

lib-lz4-make-arrays-static-const-reduces-object-code-size.patch
kernel-watchdog-fix-spelling-mistake-permanetely-permanently.patch

