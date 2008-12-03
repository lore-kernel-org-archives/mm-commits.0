From: akpm@linux-foundation.org
Subject: + generic-swap-lib-sortc-rename-swap-to-swap_func.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:19:10 -0800
Message-ID: <200812030819.mB38JARs010216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbYLCITM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:19:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com


The patch titled
     generic swap(): lib/sort.c: rename swap to swap_func
has been added to the -mm tree.  Its filename is
     generic-swap-lib-sortc-rename-swap-to-swap_func.patch

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

linux-next.patch
9p-convert-d_iname-references-to-d_namename.patch
nfs-remove-redundant-tests-on-reading-new-pages.patch
generic-swap-ath9k-rename-swap-to-swap_array.patch
generic-swap-sparc-rename-swap-to-swap_ulong.patch
generic-swap-iphase-rename-swap-to-swap_byte_order.patch
generic-swap-lib-sortc-rename-swap-to-swap_func.patch
generic-swap-introduce-global-macro-swapa-b.patch
generic-swap-ext3-remove-local-swap-macro.patch
generic-swap-ext4-remove-local-swap-macro.patch
generic-swap-sched-remove-local-swap-macro.patch
generic-swap-dcache-use-swap-instead-of-private-do_switch.patch

