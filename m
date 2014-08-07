From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:08:27 -0700
Message-ID: <53e3dcbb.CnnHBQWuQ6kIekJU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37004 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbaHGUI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:28 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so613448qaq.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: fix typo in kerneldoc for bitmap_pos_to_ord
has been removed from the -mm tree.  Its filename was
     lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: fix typo in kerneldoc for bitmap_pos_to_ord

A few lines above, it was stated that positions for non-set bits are
mapped to -1, which is obviously also what the code does.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bitmap.c~lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-fix-typo-in-kerneldoc-for-bitmap_pos_to_ord
+++ a/lib/bitmap.c
@@ -712,7 +712,7 @@ EXPORT_SYMBOL(bitmap_parselist_user);
  *
  * If for example, just bits 4 through 7 are set in @buf, then @pos
  * values 4 through 7 will get mapped to 0 through 3, respectively,
- * and other @pos values will get mapped to 0.  When @pos value 7
+ * and other @pos values will get mapped to -1.  When @pos value 7
  * gets mapped to (returns) @ord value 3 in this example, that means
  * that bit 7 is the 3rd (starting with 0th) set bit in @buf.
  *
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

