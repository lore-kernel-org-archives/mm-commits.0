From: akpm@linux-foundation.org
Subject: [merged] mm-debug-pageallocc-use-memchr_inv.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:09:55 -0700
Message-ID: <201111012109.pA1L9tf6004762@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab1KAVJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:09:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug-pagealloc.c: use memchr_inv
has been removed from the -mm tree.  Its filename was
     mm-debug-pageallocc-use-memchr_inv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/debug-pagealloc.c: use memchr_inv

Use newly introduced memchr_inv() for page verification.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug-pagealloc.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/debug-pagealloc.c~mm-debug-pageallocc-use-memchr_inv mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~mm-debug-pageallocc-use-memchr_inv
+++ a/mm/debug-pagealloc.c
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/page-debug-flags.h>
 #include <linux/poison.h>
@@ -64,11 +65,8 @@ static void check_poison_mem(unsigned ch
 	unsigned char *start;
 	unsigned char *end;
 
-	for (start = mem; start < mem + bytes; start++) {
-		if (*start != PAGE_POISON)
-			break;
-	}
-	if (start == mem + bytes)
+	start = memchr_inv(mem, PAGE_POISON, bytes);
+	if (!start)
 		return;
 
 	for (end = mem + bytes - 1; end > start; end--) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

