From: akpm@linux-foundation.org
Subject: + zlib_deflate-deftree-remove-bi_reverse.patch added to -mm tree
Date: Thu, 13 Aug 2015 13:57:10 -0700
Message-ID: <55cd04a6.J8UsUdWzbhBk5oCy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbbHMU5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Aug 2015 16:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zlib_deflate/deftree: remove bi_reverse()
has been added to the -mm tree.  Its filename is
     zlib_deflate-deftree-remove-bi_reverse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zlib_deflate-deftree-remove-bi_reverse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zlib_deflate-deftree-remove-bi_reverse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yalin wang <yalin.wang2010@gmail.com>
Subject: zlib_deflate/deftree: remove bi_reverse()

Remove bi_reverse() and use generic bitrev32() instead - it should have
better performance on some platforms.

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_deflate/deftree.c |    6 +++---
 lib/zlib_deflate/defutil.h |   16 ----------------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff -puN lib/zlib_deflate/deftree.c~zlib_deflate-deftree-remove-bi_reverse lib/zlib_deflate/deftree.c
--- a/lib/zlib_deflate/deftree.c~zlib_deflate-deftree-remove-bi_reverse
+++ a/lib/zlib_deflate/deftree.c
@@ -35,6 +35,7 @@
 /* #include "deflate.h" */
 
 #include <linux/zutil.h>
+#include <linux/bitrev.h>
 #include "defutil.h"
 
 #ifdef DEBUG_ZLIB
@@ -146,7 +147,6 @@ static void send_all_trees (deflate_stat
 static void compress_block (deflate_state *s, ct_data *ltree,
                            ct_data *dtree);
 static void set_data_type  (deflate_state *s);
-static unsigned bi_reverse (unsigned value, int length);
 static void bi_windup      (deflate_state *s);
 static void bi_flush       (deflate_state *s);
 static void copy_block     (deflate_state *s, char *buf, unsigned len,
@@ -284,7 +284,7 @@ static void tr_static_init(void)
     /* The static distance tree is trivial: */
     for (n = 0; n < D_CODES; n++) {
         static_dtree[n].Len = 5;
-        static_dtree[n].Code = bi_reverse((unsigned)n, 5);
+        static_dtree[n].Code = bitrev32((u32)n) >> (32 - 5);
     }
     static_init_done = 1;
 }
@@ -520,7 +520,7 @@ static void gen_codes(
         int len = tree[n].Len;
         if (len == 0) continue;
         /* Now reverse the bits */
-        tree[n].Code = bi_reverse(next_code[len]++, len);
+        tree[n].Code = bitrev32((u32)(next_code[len]++)) >> (32 - len);
 
         Tracecv(tree != static_ltree, (stderr,"\nn %3d %c l %2d c %4x (%x) ",
              n, (isgraph(n) ? n : ' '), len, tree[n].Code, next_code[len]-1));
diff -puN lib/zlib_deflate/defutil.h~zlib_deflate-deftree-remove-bi_reverse lib/zlib_deflate/defutil.h
--- a/lib/zlib_deflate/defutil.h~zlib_deflate-deftree-remove-bi_reverse
+++ a/lib/zlib_deflate/defutil.h
@@ -293,22 +293,6 @@ void zlib_tr_stored_type_only (deflate_s
 }
 
 /* ===========================================================================
- * Reverse the first len bits of a code, using straightforward code (a faster
- * method would use a table)
- * IN assertion: 1 <= len <= 15
- */
-static inline unsigned bi_reverse(unsigned code, /* the value to invert */
-				  int len)       /* its bit length */
-{
-    register unsigned res = 0;
-    do {
-        res |= code & 1;
-        code >>= 1, res <<= 1;
-    } while (--len > 0);
-    return res >> 1;
-}
