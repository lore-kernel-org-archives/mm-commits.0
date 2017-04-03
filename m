From: akpm@linux-foundation.org
Subject: + zlib-inflate-fix-potential-buffer-overflow.patch added to -mm
 tree
Date: Mon, 03 Apr 2017 15:32:59 -0700
Message-ID: <58e2cd9b.pepSB1dERsgQseYe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdDCWdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 18:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib_inflate/inftrees.c: fix potential buffer overflow
has been added to the -mm tree.  Its filename is
     zlib-inflate-fix-potential-buffer-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zlib-inflate-fix-potential-buffer-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zlib-inflate-fix-potential-buffer-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: lib/zlib_inflate/inftrees.c: fix potential buffer overflow

smatch says:

lib/zlib_inflate/inftrees.c:240 zlib_inflate_table() error:
	buffer overflow 'count' 16 <= 16

The loop calculating the value for 'min', which is later used to access
count[], can indeed result in an index larger than ARRAY_SIZE(count)
if the array is filled with 0.

Fixes: 4f3865fb57a04 ("zlib_inflate: Upgrade library code to a recent version")
Link: http://lkml.kernel.org/r/1491236059-32592-1-git-send-email-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inftrees.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/zlib_inflate/inftrees.c~zlib-inflate-fix-potential-buffer-overflow lib/zlib_inflate/inftrees.c
--- a/lib/zlib_inflate/inftrees.c~zlib-inflate-fix-potential-buffer-overflow
+++ a/lib/zlib_inflate/inftrees.c
@@ -109,7 +109,7 @@ int zlib_inflate_table(codetype type, un
         *bits = 1;
         return 0;     /* no symbols, but wait for decoding to report error */
     }
-    for (min = 1; min <= MAXBITS; min++)
+    for (min = 1; min < MAXBITS; min++)
         if (count[min] != 0) break;
     if (root < min) root = min;
 
_

Patches currently in -mm which might be from linux@roeck-us.net are

zlib-inflate-fix-potential-buffer-overflow.patch

