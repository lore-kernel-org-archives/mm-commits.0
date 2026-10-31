Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793412741;
	b=QZJ8hnBzjbagvYjXIbxGUUdGDFAkszU5Yqy03x5K9gRKsLMh++xTlQnAtdm3i+Vmj3R7
	 FjcqM1BPdElQQpDqOwsyEooYSwmGfA8RXKbFdbBhDFvffAEB6vr82EVfsdpu8yKKsw2bU
	 W555UfoB4c0ghKU++ORURl2ykvbUEse5PF1QgXqDQUg/GbmRI2kz0moOWnDewxd08XjDW
	 H0ePxVizk0XiLvBWH3nCTTb8j1O0Et/LSR0uFut0kt0T1zis0WWECdX7SCr94Lt17umnN
	 fA8Fn7zGeqX7Wg44YuT4K+EUyIFDkKY6pM/R7ZBU7X+CfAAlgv2kL59VV+x/N/oqP3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793412741;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=USSm+kEP3bXbYx4Pn9zoQZJa50qbTM8fIyIl+mNKkGc=;
	b=oZvBFqhlcVHQhEhX+dWzx/T8PXdNObSp6190NzUFO/GCXuP9EjEAggaQ9BaUeiggF2IN
	 sMR+WnI2UqGGhuusWL/UtaLHc0mlahl0KOIripakV2yS/1iYQNDOG/8RtHBiZVP8VfOdb
	 beeHFWhmsiXaK0uD55PCibqctzt6M6KUjYw16LEyaM/Fi83KcE0s8vQJwkcUzyoWzxsSv
	 xiiKpEBtaETAMzk2mR8Hgy2N7Wm60uXi7OEvM35IyjqLdD9mgkeROEF9sCp4gpERs4Y4S
	 npxPPIjRXwevCNAI+ZKz21yYqUw2uZLvrV7NDSEmCY5LwupTieFPM85GCABQzXWfowQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="tQ/yxqLx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1AE606A31C
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 02:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tQ/yxqLx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33F61F000C1;
	Sat, 31 Oct 2026 02:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793412740;
	bh=USSm+kEP3bXbYx4Pn9zoQZJa50qbTM8fIyIl+mNKkGc=;
	h=Date:To:From:Subject;
	b=tQ/yxqLxd47UScIzShlVLyiAIHVvfRwQrAScoGn/J5NVK97H4vKaIl0ly8yMwHNRA
	 z+Nu6HT9PT9Son+HriT70+pCS10iLpO4QbhwbkJ4XPH1+rB0n5UIqz8JuesQ+COPFR
	 wvdenQpY6k4P3hyUGeskl6EciWXVlt59J4YWWoNk=
Date: Fri, 30 Oct 2026 19:12:20 -0700
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,song@kernel.org,
	rostedt@goodmis.org,mhiramat@kernel.org,memxor@gmail.com,matt@bobrowski.net,
	mathieu.desnoyers@efficios.com,martin.lau@linux.dev,marscheng@google.com,
	kpsingh@kernel.org,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,
	ihor.solodrai@linux.dev,hch@infradead.org,emil@etsalapatis.com,
	eleanor.lin@realtek.com,eddyz87@gmail.com,daniel@iogearbox.net,
	ast@kernel.org,andrii@kernel.org,visitorckw@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-lib-sortc-add-_nonatomic-variants-with-cond_resched.patch added to mm-nonmm-unstable branch
Message-Id: <20261031021220.B33F61F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Revert "lib/sort.c: add _nonatomic() variants with cond_resched()"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     revert-lib-sortc-add-_nonatomic-variants-with-cond_resched.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-lib-sortc-add-_nonatomic-variants-with-cond_resched.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: Revert "lib/sort.c: add _nonatomic() variants with cond_resched()"
Date: Thu, 10 Sep 2026 16:52:21 +0000

This reverts commit e2a33a2a3258794891cdd6ca4b1318da6594d157.

With no remaining users in the kernel tree, remove sort_nonatomic() and
sort_r_nonatomic() to clean up dead code. This effectively drops the
wrapper function __sort_r() and eliminates the may_schedule branch and
cond_resched() call from the inner loop of the core sorting routine,
slightly simplifying and optimizing the code.

Link: https://lore.kernel.org/20260910165222.1186628-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Liu <song@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: <matt@bobrowski.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: <martin.lau@linux.dev>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Emil Tsalapatis <emil@etsalapatis.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: <hch@infradead.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Yu-Chun Lin <eleanor.lin@realtek.com>
Cc: <marscheng@google.com>
---

 include/linux/sort.h |   11 ----
 lib/sort.c           |  110 +++++++++++------------------------------
 2 files changed, 31 insertions(+), 90 deletions(-)

--- a/include/linux/sort.h~revert-lib-sortc-add-_nonatomic-variants-with-cond_resched
+++ a/include/linux/sort.h
@@ -23,15 +23,4 @@ void sort(void *base, size_t num, size_t
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func);
 
-/* Versions that periodically call cond_resched(): */
-
-void sort_r_nonatomic(void *base, size_t num, size_t size,
-		      cmp_r_func_t cmp_func,
-		      swap_r_func_t swap_func,
-		      const void *priv);
-
-void sort_nonatomic(void *base, size_t num, size_t size,
-		    cmp_func_t cmp_func,
-		    swap_func_t swap_func);
-
 #endif
--- a/lib/sort.c~revert-lib-sortc-add-_nonatomic-variants-with-cond_resched
+++ a/lib/sort.c
@@ -186,13 +186,36 @@ static size_t parent(size_t i, unsigned
 	return i / 2;
 }
 
-#include <linux/sched.h>
-
-static void __sort_r(void *base, size_t num, size_t size,
-		     cmp_r_func_t cmp_func,
-		     swap_r_func_t swap_func,
-		     const void *priv,
-		     bool may_schedule)
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
 {
 	/* pre-scale counters for performance */
 	size_t n = num * size, a = (num/2) * size;
@@ -263,9 +286,6 @@ static void __sort_r(void *base, size_t
 			b = parent(b, lsbit, size);
 			do_swap(base + b, base + c, size, swap_func, priv);
 		}
-
-		if (may_schedule)
-			cond_resched();
 	}
 
 	n -= size;
@@ -273,63 +293,8 @@ static void __sort_r(void *base, size_t
 	if (n == size * 2 && do_cmp(base, base + size, cmp_func, priv) > 0)
 		do_swap(base, base + size, size, swap_func, priv);
 }
-
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
-{
-	__sort_r(base, num, size, cmp_func, swap_func, priv, false);
-}
 EXPORT_SYMBOL(sort_r);
 
-/**
- * sort_r_nonatomic - sort an array of elements, with cond_resched
- * @base: pointer to data to sort
- * @num: number of elements
- * @size: size of each element
- * @cmp_func: pointer to comparison function
- * @swap_func: pointer to swap function or NULL
- * @priv: third argument passed to comparison function
- *
- * Same as sort_r, but preferred for larger arrays as it does a periodic
- * cond_resched().
- */
-void sort_r_nonatomic(void *base, size_t num, size_t size,
-		      cmp_r_func_t cmp_func,
-		      swap_r_func_t swap_func,
-		      const void *priv)
-{
-	__sort_r(base, num, size, cmp_func, swap_func, priv, true);
-}
-EXPORT_SYMBOL(sort_r_nonatomic);
-
 void sort(void *base, size_t num, size_t size,
 	  cmp_func_t cmp_func,
 	  swap_func_t swap_func)
@@ -339,19 +304,6 @@ void sort(void *base, size_t num, size_t
 		.swap = swap_func,
 	};
 
-	return __sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w, false);
+	return sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w);
 }
 EXPORT_SYMBOL(sort);
-
-void sort_nonatomic(void *base, size_t num, size_t size,
-		    cmp_func_t cmp_func,
-		    swap_func_t swap_func)
-{
-	struct wrapper w = {
-		.cmp  = cmp_func,
-		.swap = swap_func,
-	};
-
-	return __sort_r(base, num, size, _CMP_WRAPPER, SWAP_WRAPPER, &w, true);
-}
-EXPORT_SYMBOL(sort_nonatomic);
_

Patches currently in -mm which might be from visitorckw@gmail.com are

bpf-replace-sort_r_nonatomic-with-sort_r-in-check_dup_ids.patch
revert-lib-sortc-add-_nonatomic-variants-with-cond_resched.patch

