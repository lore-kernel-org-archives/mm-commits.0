From: akpm@linux-foundation.org
Subject: - generic-swap-lib-sortc-rename-swap-to-swap_func.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:14 -0800
Message-ID: <200901082251.n08MpE5M030356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763515AbZAHWvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     generic swap(): lib/sort.c: rename swap to swap_func
has been removed from the -mm tree.  Its filename was
     generic-swap-lib-sortc-rename-swap-to-swap_func.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic swap(): lib/sort.c: rename swap to swap_func
From: Wu Fengguang <fengguang.wu@intel.com>

This is to avoid name clashes for the introduction of a global swap()
macro.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN lib/sort.c~generic-swap-lib-sortc-rename-swap-to-swap_func lib/sort.c
--- a/lib/sort.c~generic-swap-lib-sortc-rename-swap-to-swap_func
+++ a/lib/sort.c
@@ -32,11 +32,11 @@ static void generic_swap(void *a, void *
  * @base: pointer to data to sort
  * @num: number of elements
  * @size: size of each element
- * @cmp: pointer to comparison function
- * @swap: pointer to swap function or NULL
+ * @cmp_func: pointer to comparison function
+ * @swap_func: pointer to swap function or NULL
  *
  * This function does a heapsort on the given array. You may provide a
- * swap function optimized to your element type.
+ * swap_func function optimized to your element type.
  *
  * Sorting time is O(n log n) both on average and worst-case. While
  * qsort is about 20% faster on average, it suffers from exploitable
@@ -45,37 +45,39 @@ static void generic_swap(void *a, void *
  */
 
 void sort(void *base, size_t num, size_t size,
-	  int (*cmp)(const void *, const void *),
-	  void (*swap)(void *, void *, int size))
+	  int (*cmp_func)(const void *, const void *),
+	  void (*swap_func)(void *, void *, int size))
 {
 	/* pre-scale counters for performance */
 	int i = (num/2 - 1) * size, n = num * size, c, r;
 
-	if (!swap)
-		swap = (size == 4 ? u32_swap : generic_swap);
+	if (!swap_func)
+		swap_func = (size == 4 ? u32_swap : generic_swap);
 
 	/* heapify */
 	for ( ; i >= 0; i -= size) {
 		for (r = i; r * 2 + size < n; r  = c) {
 			c = r * 2 + size;
-			if (c < n - size && cmp(base + c, base + c + size) < 0)
+			if (c < n - size &&
+					cmp_func(base + c, base + c + size) < 0)
 				c += size;
-			if (cmp(base + r, base + c) >= 0)
+			if (cmp_func(base + r, base + c) >= 0)
 				break;
-			swap(base + r, base + c, size);
+			swap_func(base + r, base + c, size);
 		}
 	}
 
 	/* sort */
 	for (i = n - size; i > 0; i -= size) {
-		swap(base, base + i, size);
+		swap_func(base, base + i, size);
 		for (r = 0; r * 2 + size < i; r = c) {
 			c = r * 2 + size;
-			if (c < i - size && cmp(base + c, base + c + size) < 0)
+			if (c < i - size &&
+					cmp_func(base + c, base + c + size) < 0)
 				c += size;
-			if (cmp(base + r, base + c) >= 0)
+			if (cmp_func(base + r, base + c) >= 0)
 				break;
-			swap(base + r, base + c, size);
+			swap_func(base + r, base + c, size);
 		}
 	}
 }
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch

