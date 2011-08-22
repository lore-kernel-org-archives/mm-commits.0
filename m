From: akpm@linux-foundation.org
Subject: + mm-debug-pageallocc-use-memchr_inv.patch added to -mm tree
Date: Mon, 22 Aug 2011 13:53:15 -0700
Message-ID: <201108222053.p7MKrFWA005855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079Ab1HVUxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 16:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     mm/debug-pagealloc.c: use memchr_inv
has been added to the -mm tree.  Its filename is
     mm-debug-pageallocc-use-memchr_inv.patch

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
Subject: mm/debug-pagealloc.c: use memchr_inv
From: Akinobu Mita <akinobu.mita@gmail.com>

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

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
mm-debug-pageallocc-use-plain-__ratelimit-instead-of-printk_ratelimit.patch
lib-stringc-introduce-memchr_inv.patch
mm-debug-pageallocc-use-memchr_inv.patch

