From: akpm@linux-foundation.org
Subject: [patch 047/114] lib/zlib_inflate/inftrees.c: fix potential
 buffer overflow
Date: Mon, 08 May 2017 15:56:54 -0700
Message-ID: <20170508225654.ZmBDj-udx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbdEHW4z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@roeck-us.net, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Guenter Roeck <linux@roeck-us.net>
Subject: lib/zlib_inflate/inftrees.c: fix potential buffer overflow

smatch says:

WARNING: please, no spaces at the start of a line
#30: FILE: lib/zlib_inflate/inftrees.c:112:
+    for (min = 1; min < MAXBITS; min++)$

total: 0 errors, 1 warnings, 8 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/zlib-inflate-fix-potential-buffer-overflow.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches


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
