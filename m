Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239B91C5D62
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 19:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743535088; cv=none; b=UUdylreskFiNvPRiy4mblHivn+2XAHg/K2KtIufF/B8h9nQKI+CWID4hT9XzFdPzbGvZks3sznEpy7KRYCvct1+K6OfSM9CC/QaQQg1JVSf+PyD8lC+M3H4DNCGAHEXRnetYFPfgjCOitFXvzcUHeCyLlXUx4dE56Z3QT50sFJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743535088; c=relaxed/simple;
	bh=YytqUoYGqSo+4anNctMXvjlYeiRhafvpfCKPM/k8jEU=;
	h=Date:To:From:Subject:Message-Id; b=lEU9byTI13XNJANEN8vLAesQ6mngbuiIqkhgjve747/nRPOEpZT0f+KVKjp1aBFAiEMyO7ktKxcTjNBqhYRRJwvaIONUy1WHqbLMgcWetzjmtXcto8mxaNj2ko/KkvGZuzMne9H6Ex6FGnIm2K6TSq4Lqdde76LfdIWYlycjatw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v/8p5rCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v/8p5rCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EB7C4CEE4;
	Tue,  1 Apr 2025 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743535087;
	bh=YytqUoYGqSo+4anNctMXvjlYeiRhafvpfCKPM/k8jEU=;
	h=Date:To:From:Subject:From;
	b=v/8p5rCNR3TyK4+Szpw7Cwj2QSueqkwN97Fv7FxRnT16B+GE4j/8Rrez1nCsGWSXK
	 Td0HVsFfmV+bNq6g5qVfKHLTHJ6FiZjYLVFxSMf9hcEZprLqo+TgDMFZg1EozpPOj3
	 0M9PCdenvnFQqojxauHIQCBzO2GnQqX5wlNL3bMc=
Date: Tue, 01 Apr 2025 12:18:06 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-sortc-add-_nonatomic-variants-with-cond_resched-fix.patch removed from -mm tree
Message-Id: <20250401191807.79EB7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-sortc-add-_nonatomic-variants-with-cond_resched-fix
has been removed from the -mm tree.  Its filename was
     lib-sortc-add-_nonatomic-variants-with-cond_resched-fix.patch

This patch was dropped because it was folded into lib-sortc-add-_nonatomic-variants-with-cond_resched.patch

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: lib-sortc-add-_nonatomic-variants-with-cond_resched-fix
Date: Fri, 28 Mar 2025 11:07:39 -0400

fix kerneldoc

Link: https://lkml.kernel.org/r/cgsr5a447pxqomc4gvznsp5yroqmif4omd7o5lsr2swifjhoic@yzjjrx2bvrq7
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |   64 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 26 deletions(-)

--- a/lib/sort.c~lib-sortc-add-_nonatomic-variants-with-cond_resched-fix
+++ a/lib/sort.c
@@ -188,32 +188,6 @@ static size_t parent(size_t i, unsigned
 
 #include <linux/sched.h>
 
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
 static void __sort_r(void *base, size_t num, size_t size,
 		     cmp_r_func_t cmp_func,
 		     swap_r_func_t swap_func,
@@ -300,6 +274,32 @@ static void __sort_r(void *base, size_t
 		do_swap(base, base + size, size, swap_func, priv);
 }
 
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
 void sort_r(void *base, size_t num, size_t size,
 	    cmp_r_func_t cmp_func,
 	    swap_r_func_t swap_func,
@@ -309,6 +309,18 @@ void sort_r(void *base, size_t num, size
 }
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
 void sort_r_nonatomic(void *base, size_t num, size_t size,
 		      cmp_r_func_t cmp_func,
 		      swap_r_func_t swap_func,
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

lib-sortc-add-_nonatomic-variants-with-cond_resched.patch

