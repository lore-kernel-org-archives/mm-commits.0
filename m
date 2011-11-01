From: akpm@linux-foundation.org
Subject: [merged] mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:09:47 -0700
Message-ID: <201111012109.pA1L9l2j003997@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab1KAVJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:09:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug-pagealloc.c: use plain __ratelimit() instead of printk_ratelimit()
has been removed from the -mm tree.  Its filename was
     mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/debug-pagealloc.c: use plain __ratelimit() instead of printk_ratelimit()

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

origin.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

