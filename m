Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF791D79B8
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743546076; cv=none; b=dSJrYS4886IQd7AuErxZTOdSlWg1Gk5ESFUwjdemXB3IO2QOb3vTFrAWPsPYjYZQB+LpcLCLD8H1LJ0C/mPStAvRqEGoX1UIEUfenoMz7RNUldPU4jqkwICM3OKhhjhPbUbmINi3wbuHNO58fG8zNnLiUj9ZVWHENoeFIh53KN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743546076; c=relaxed/simple;
	bh=+MVYGGCf5EAjamV8int/apew6T6YaHVm13BVdOnv1qk=;
	h=Date:To:From:Subject:Message-Id; b=Pr+jCDMDhoIdn1fgmi3LzBGHTPieEI8pMa4ziP/+B2RaKmSFGzApw+M8IjExjURXORPYnO9aDgd3ADNTkMHCf32q7ZchrHyV/ZTsXMW4eOaOWKmAp0Lux21OpvSlXouU+EfnBWFNzC0GQq/J1nFuaNKthX7F51Jq30qOMQpcFKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=scK2yYut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="scK2yYut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4864C4CEE4;
	Tue,  1 Apr 2025 22:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743546075;
	bh=+MVYGGCf5EAjamV8int/apew6T6YaHVm13BVdOnv1qk=;
	h=Date:To:From:Subject:From;
	b=scK2yYutHyo27P3cUi4mlnsV9IEK2i1o4rB9aAHxOGyI5GDURuZ3NMqkcn/bKyvLw
	 A/EJKIPCC3UNmpv5FOboTE0TuB0sTPUdxplAjim/oCT9XflQbGgdLqoJopaEW6Kexc
	 lwF0D5qUP53EZWKQZuV2aneIci3jfPABH2JWWL/U=
Date: Tue, 01 Apr 2025 15:21:15 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,sfr@canb.auug.org.au,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-sortc-add-_nonatomic-variants-with-cond_resched.patch removed from -mm tree
Message-Id: <20250401222115.B4864C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/sort.c: add _nonatomic() variants with cond_resched()
has been removed from the -mm tree.  Its filename was
     lib-sortc-add-_nonatomic-variants-with-cond_resched.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: lib/sort.c: add _nonatomic() variants with cond_resched()
Date: Wed, 26 Mar 2025 11:26:06 -0400

bcachefs calls sort() during recovery to sort all keys it found in the
journal, and this may be very large - gigabytes on large machines.

This has been causing "task blocked" warnings, so needs a
cond_resched().

[kent.overstreet@linux.dev: fix kerneldoc]
  Link: https://lkml.kernel.org/r/cgsr5a447pxqomc4gvznsp5yroqmif4omd7o5lsr2swifjhoic@yzjjrx2bvrq7
Link: https://lkml.kernel.org/r/20250326152606.2594920-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sort.h |   11 ++++
 lib/sort.c           |  110 +++++++++++++++++++++++++++++------------
 2 files changed, 90 insertions(+), 31 deletions(-)

--- a/include/linux/sort.h~lib-sortc-add-_nonatomic-variants-with-cond_resched
+++ a/include/linux/sort.h
@@ -13,4 +13,15 @@ void sort(void *base, size_t num, size_t
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func);
 
+/* Versions that periodically call cond_resched(): */
+
+void sort_r_nonatomic(void *base, size_t num, size_t size,
+		      cmp_r_func_t cmp_func,
+		      swap_r_func_t swap_func,
+		      const void *priv);
+
+void sort_nonatomic(void *base, size_t num, size_t size,
+		    cmp_func_t cmp_func,
+		    swap_func_t swap_func);
+
 #endif
--- a/lib/sort.c~lib-sortc-add-_nonatomic-variants-with-cond_resched
+++ a/lib/sort.c
@@ -186,36 +186,13 @@ static size_t parent(size_t i, unsigned
 	return i / 2;
 }
 
-/**
- * sort_r - sort an array of elements
- * @base: pointer to data to sort
- * @num: number of elements
- * @size: size of each element
- * @cmp_func: pointer to comparison function
- * @swap_func: pointer to swap function or NULL
- * @priv: third argument passed to comparison function
- *
- * This function does a heapsort on the given array.  You may provide
- * a swap_func function if you need to do something more than a memory
- * copy (e.g. fix up pointers or auxiliary data), but the built-in swap
- * avoids a slow retpoline and so is significantly faster.
- *
- * The comparison function must adhere to specific mathematical
- * properties to ensure correct and stable sorting:
- * - Antisymmetry: cmp_func(a, b) must return the opposite sign of
- * cmp_func(b, a).
- * - Transitivity: if cmp_func(a, b) <= 0 and cmp_func(b, c) <= 0, then
- * cmp_func(a, c) <= 0.
- *
- * Sorting time is O(n log n) both on average and worst-case. While
- * quicksort is slightly faster on average, it suffers from exploitable
- * O(n*n) worst-case behavior and extra memory requirements that make
- * it less suitable for kernel use.
- */
-void sort_r(void *base, size_t num, size_t size,
-	    cmp_r_func_t cmp_func,
-	    swap_r_func_t swap_func,
-	    const void *priv)
+#include <linux/sched.h>
+
+static void __sort_r(void *base, size_t num, size_t size,
+		     cmp_r_func_t cmp_func,
+		     swap_r_func_t swap_func,
+		     const void *priv,
+		     bool may_schedule)
 {
 	/* pre-scale counters for performance */
 	size_t n = num * size, a = (num/2) * size;
@@ -286,6 +263,9 @@ void sort_r(void *base, size_t num, size
 			b = parent(b, lsbit, size);
 			do_swap(base + b, base + c, size, swap_func, priv);
 		}
+
+		if (may_schedule)
+			cond_resched();
 	}
 
 	n -= size;
@@ -293,8 +273,63 @@ void sort_r(void *base, size_t num, size
 	if (n == size * 2 && do_cmp(base, base + size, cmp_func, priv) > 0)
 		do_swap(base, base + size, size, swap_func, priv);
 }
+
+/**
+ * sort_r - sort an array of elements
+ * @base: pointer to data to sort
+ * @num: number of elements
+ * @size: size of each element
+ * @cmp_func: pointer to comparison function
+ * @swap_func: pointer to swap function or NULL
+ * @priv: third argument passed to comparison function
+ *
+ * This function does a heapsort on the given array.  You may provide
+ * a swap_func function if you need to do something more than a memory
+ * copy (e.g. fix up pointers or auxiliary data), but the built-in swap
+ * avoids a slow retpoline and so is significantly faster.
+ *
+ * The comparison function must adhere to specific mathematical
+ * properties to ensure correct and stable sorting:
+ * - Antisymmetry: cmp_func(a, b) must return the opposite sign of
+ * cmp_func(b, a).
+ * - Transitivity: if cmp_func(a, b) <= 0 and cmp_func(b, c) <= 0, then
+ * cmp_func(a, c) <= 0.
+ *
+ * Sorting time is O(n log n) both on average and worst-case. While
+ * quicksort is slightly faster on average, it suffers from exploitable
+ * O(n*n) worst-case behavior and extra memory requirements that make
+ * it less suitable for kernel use.
+ */
+void sort_r(void *base, size_t num, size_t size,
+	    cmp_r_func_t cmp_func,
+	    swap_r_func_t swap_func,
+	    const void *priv)
+{
+	__sort_r(base, num, size, cmp_func, swap_func, priv, false);
+}
 EXPORT_SYMBOL(sort_r);
 
+/**
+ * sort_r_nonatomic - sort an array of elements, with cond_resched
+ * @base: pointer to data to sort
+ * @num: number of elements
+ * @size: size of each element
+ * @cmp_func: pointer to comparison function
+ * @swap_func: pointer to swap function or NULL
+ * @priv: third argument passed to comparison function
+ *
+ * Same as sort_r, but preferred for larger arrays as it does a periodic
+ * cond_resched().
+ */
+void sort_r_nonatomic(void *base, size_t num, size_t size,
+		      cmp_r_func_t cmp_func,
+		      swap_r_func_t swap_func,
+		      const void *priv)
+{
+	__sort_r(base, num, size, cmp_func, swap_func, priv, true);
+}
+EXPORT_SYMBOL(sort_r_nonatomic);
+
 void sort(void *base, size_t num, size_t size,
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func)
@@ -304,6 +339,19 @@ void sort(void *base, size_t num, size_t
 		.swap = swap_func,
 	};
 
-	return sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w);
+	return __sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w, false);
 }
 EXPORT_SYMBOL(sort);
+
+void sort_nonatomic(void *base, size_t num, size_t size,
+		    cmp_func_t cmp_func,
+		    swap_func_t swap_func)
+{
+	struct wrapper w = {
+		.cmp  = cmp_func,
+		.swap = swap_func,
+	};
+
+	return __sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w, true);
+}
+EXPORT_SYMBOL(sort_nonatomic);
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


