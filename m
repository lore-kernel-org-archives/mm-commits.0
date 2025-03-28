Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0F41865E5
	for <mm-commits@vger.kernel.org>; Fri, 28 Mar 2025 22:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743201105; cv=none; b=njzWkiEXlOHXqvAQrSI6m1spn8NY21sbq83NdOWmavtjeN4/lyMaVTpjKPY59kO+j2bqxkcK/BppnNjacau4gfj64EY+hI7j/jfGcFygMlDC+t4CVnegd8a1rf6EMeqwbOKa666WsKIIWTfvL0dNYUpKZCcAc3ZNi07D+AdxKho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743201105; c=relaxed/simple;
	bh=LGizyfKN+89t3RcWiInxTmEhE0DXqGe3o5l9TLgsdwY=;
	h=Date:To:From:Subject:Message-Id; b=eBZW0B/cfDSKgcXSd4w5hUP3CULcchvglko4R9mt4/sULnIN1XaqKs1WAvwKX7/+j+tvvobqBkIpMnstUhASgR355LCHEhTTq5CioeGlvHIpo0xRj67nCiVeBbWs9P+xSo21EzD++u3LaxF8X/LI+yJhho/16I0dA9c4q7I0HYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bC6GJdQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bC6GJdQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CE1C4CEE4;
	Fri, 28 Mar 2025 22:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743201104;
	bh=LGizyfKN+89t3RcWiInxTmEhE0DXqGe3o5l9TLgsdwY=;
	h=Date:To:From:Subject:From;
	b=bC6GJdQTYFgEPo9HWsObt0yXklZTIOraqRSDfr8VdiKd4/IZ9vYND9YfrhFU2Vb01
	 ruRvLnnO3nCPaooMRq6mizfeawp9rzA4y4Z0BiBdTyjJrRiH3hhn9YEFhc5YtCUR0g
	 BMihpeXxkdYdM8xB1kLvLnpPnbtaKSwGx5BLdQDw=
Date: Fri, 28 Mar 2025 15:31:43 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sortc-add-_nonatomic-variants-with-cond_resched-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250328223144.97CE1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-sortc-add-_nonatomic-variants-with-cond_resched-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sortc-add-_nonatomic-variants-with-cond_resched-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sortc-add-_nonatomic-variants-with-cond_resched-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
lib-sortc-add-_nonatomic-variants-with-cond_resched-fix.patch

