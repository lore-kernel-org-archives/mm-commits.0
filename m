From: akpm@linux-foundation.org
Subject: + mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch added to -mm tree
Date: Mon, 22 Aug 2011 13:36:51 -0700
Message-ID: <201108222036.p7MKapOT004994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab1HVUg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 16:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     mm/debug-pagealloc.c: use plain __ratelimit() instead of printk_ratelimit()
has been added to the -mm tree.  Its filename is
     mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch

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
Subject: mm/debug-pagealloc.c: use plain __ratelimit() instead of printk_ratelimit()
From: Akinobu Mita <akinobu.mita@gmail.com>

printk_ratelimit() should not be used, because it shares ratelimiting
state with all other unrelated printk_ratelimit() callsites.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug-pagealloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/debug-pagealloc.c~mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit
+++ a/mm/debug-pagealloc.c
@@ -2,6 +2,7 @@
 #include <linux/mm.h>
 #include <linux/page-debug-flags.h>
 #include <linux/poison.h>
+#include <linux/ratelimit.h>
 
 static inline void set_page_poison(struct page *page)
 {
@@ -59,6 +60,7 @@ static bool single_bit_flip(unsigned cha
 
 static void check_poison_mem(unsigned char *mem, size_t bytes)
 {
+	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 10);
 	unsigned char *start;
 	unsigned char *end;
 
@@ -74,7 +76,7 @@ static void check_poison_mem(unsigned ch
 			break;
 	}
 
-	if (!printk_ratelimit())
+	if (!__ratelimit(&ratelimit))
 		return;
 	else if (start == end && single_bit_flip(*start, PAGE_POISON))
 		printk(KERN_ERR "pagealloc: single bit error\n");
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch

