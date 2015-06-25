From: akpm@linux-foundation.org
Subject: [folded-merged] lib-sort-add-64-bit-swap-function-v2.patch
 removed from -mm tree
Date: Thu, 25 Jun 2015 14:52:51 -0700
Message-ID: <558c7833.u89APwIP5u510G9j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbbFYVww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.wagner@bmw-carit.de, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-sort-add-64-bit-swap-function-v2
has been removed from the -mm tree.  Its filename was
     lib-sort-add-64-bit-swap-function-v2.patch

This patch was dropped because it was folded into lib-sort-add-64-bit-swap-function.patch

------------------------------------------------------
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: lib-sort-add-64-bit-swap-function-v2

Changes since v0:
	- Test for alignment of the array.
	- Fixed compare function in test program according
	  Rasmus' feedback
	- Added an unaligned test cases (swap_72)

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN lib/sort.c~lib-sort-add-64-bit-swap-function-v2 lib/sort.c
--- a/lib/sort.c~lib-sort-add-64-bit-swap-function-v2
+++ a/lib/sort.c
@@ -58,6 +58,7 @@ void sort(void *base, size_t num, size_t
 	int i = (num/2 - 1) * size, n = num * size, c, r;
 
 	if (!swap_func) {
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 		switch (size) {
 		case 4:
 			swap_func = u32_swap;
@@ -65,9 +66,22 @@ void sort(void *base, size_t num, size_t
 		case 8:
 			swap_func = u64_swap;
 			break;
-		default:
-			swap_func = generic_swap;
 		}
+#else
+		switch (size) {
+		case 4:
+			if (((unsigned long)base & 3) == 0)
+				swap_func = u32_swap;
+			break;
+		case 8:
+			if (((unsigned long)base & 7) == 0)
+				swap_func = u64_swap;
+			break;
+		}
+#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+
+		if (!swap_func)
+			swap_func = generic_swap;
 	}
 
 	/* heapify */
_

Patches currently in -mm which might be from daniel.wagner@bmw-carit.de are

origin.patch
lib-sort-add-64-bit-swap-function.patch
lib-sort-add-64-bit-swap-function-v2-fix.patch

